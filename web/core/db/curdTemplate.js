const db = require("./index");

/**
 * @template T
 * @param {T} filter
 * @param {string[]?} tableKeys
 * @param {string[]?} likeKeys
 * @param {((obj:Object,sql:string,args:any[])=>string)?} customize
 * @return {{whereSql: string, param: any[]}}
 */
function filterObj(filter, tableKeys = [], likeKeys = [], customize,) {
    let keys = Object.keys(filter);
    if (keys.length <= 0) {
        let param = [];
        let whereSql = "";
        if (customize) {
            const newSql = customize(filter, whereSql, param);
            if (typeof newSql === "string") {
                whereSql = newSql
            }
        }
        return {whereSql, param}
    }
    let param = []
    let where = keys.filter(k => filter[k] !== undefined && tableKeys.includes(k)).map(k => {
        if (likeKeys.includes(k)) {
            if (!filter[k]) {
                return ""
            }
            param.push(filter[k])
            return k + db.likeSql()
        }
        param.push(filter[k])
        return k + '=?'
    }).filter(e => e.length > 0).join(" and ")
    if (customize) {
        const newSql = customize(filter, where, param);
        if (typeof newSql === "string") {
            where = newSql
        }
    }
    return {
        whereSql: where, param: param
    };
}

/**
 * @template T
 * @template K
 * @param {T} entity
 * @param {string} tableName
 * @param {string} idKey
 * @param {K} idType
 * @returns {crudManager<T,K>} db操作对象
 */
module.exports = function curd(tableName, entity, idKey, idType) {
    const keys = Object.keys(entity)
    const keysNoId = keys.filter(k => k !== idKey)
    const idType1 = typeof idType

    /**
     * @template T
     * @template K
     * @typedef {Object}crudManager
     * @property {T} Type
     * @property {K} IdType
     * @property {page<T>} page
     * @property {getById<T,K>} getById
     * @property {list<T>} list
     * @property {save<T>} save
     * @property {updateById<T>} updateById
     * @property {updateCustomize<T>} updateCustomize
     * @property {deleteById<K>} deleteById
     * @property deleteCustomize
     * @property db
     * @property tableName
     * @property idKey
     * @property keys
     * @property idType
     */
    return {
        /**
         * @typedef page
         * @template T
         * @param {number?} page
         * @param {number?} size
         * @param {{
         *     orderBy:({name:string,desc:boolean?}|string)[]?,
         *     filter:Partial<T>|(Partial<T>[])?,
         *     likeKeys:string[]?,
         *     customize:((obj:Object,sql:string,args:any[])=>string)?,
         * }?} config
         * @returns {Promise<{data:T[],total:number,page:number,size:number}>}
         */
        page: async function (page = 1, size = 20, config) {
            page = Math.max(page, 0)
            let filter = config?.filter;
            let whereSql, param
            if (Array.isArray(filter)) {
                ({whereSql, param} = filter?.map(f => filterObj(f, keys, config.likeKeys, config.customize))
                    .reduce((p, c) => {
                        if (c.whereSql) {
                            if (p.whereSql) {
                                p.whereSql += " or (" + c.whereSql + ")"
                            } else {
                                p.whereSql = "(" + c.whereSql + ")"
                            }
                            p.param.push(...c.param)
                        }
                        return p
                    }, {whereSql: "", param: []}))
            } else if (filter) {
                ({whereSql, param} = filterObj(filter, keys, config.likeKeys, config.customize))
            }
            let sql0 = `
            select ${keys.join(', ')}
            `
            let sql1 = `
                from ${tableName} ${whereSql ? 'where ' + whereSql : ''}
            `
            let orderBy = (config.orderBy || []).map(o => o.name ? o.desc ? o.name + " desc" : o.name : o).join(',')
            const count = (await db.selectFirst("select count(*) count " + sql1, param)).count
            return {
                data: count <= size * (page - 1) ? [] : await db.exec(sql0 + sql1 + ` ${orderBy ? ('order by ' + orderBy) : ''}` + ` limit ?,?`, [...param, size * (page - 1), size]),
                total: count,
                page,
                size,
            }
        },

        /**
         * @typedef getById
         * @template T
         * @template K
         * @param {K} id
         * @returns {Promise<T|void>}
         */
        getById(id) {
            return db.selectFirst(`
                select ${keys.join(', ')}
                from ${tableName}
                where ${idKey} = ?`, id)
        },

        /**
         * @typedef list
         * @template T
         * @param {Partial<T>|Partial<T>[]} filter
         * @param {string[]?} likeKeys
         * @param {((obj:Object,sql:string,args:any[])=>string)?} customize

         * @returns {Promise<T[]>}
         */
        list(filter, likeKeys, customize) {
            let whereSql, param
            if (Array.isArray(filter)) {
                ({whereSql, param} = (filter || []).map(f => filterObj(f, keys, likeKeys, customize))
                    .reduce((p, c) => {
                        if (c.whereSql) {
                            if (p.whereSql) {
                                p.whereSql += " or (" + c.whereSql + ")"
                            } else {
                                p.whereSql = "(" + c.whereSql + ")"
                            }
                            p.param.push(c.param)
                        }
                        return p
                    }, {whereSql: "", param: []}))
            } else if (filter) {
                ({whereSql, param} = filterObj(filter, keys, likeKeys, customize))
            }
            return db.exec(`
                select ${keys.join(', ')}
                from ${tableName} ${whereSql ? 'where ' + whereSql : ''}`, param)
        }
        ,

        /**
         * @typedef save
         * @template T
         * @param {Partial<T>|Partial<T>[]} entities
         * @returns {Promise<number>} id
         */
        save(entities) {
            //fixme,返回id或者填充id
            if (!Array.isArray(entities)) {
                return db.exec(`
                    insert into ${tableName} (${keys.filter(k => entities[k] !== undefined).join(', ')})
                    values (${keys.filter(k => entities[k] !== undefined).map(s => '?').join(', ')})
                `, keys.filter(k => entities[k] !== undefined).map(k => entities[k]))
                    .then(e => {
                        entities[idKey] = e.id();
                        return e
                    })
            }
            return new Promise((r, f) => {
                db.serialize(() => {
                    db.sqlite.run('BEGIN TRANSACTION');
                    db.execGroup(`
                                insert into ${tableName} (${keysNoId.join(', ')})
                                values (${keysNoId.map(s => '?').join(', ')})
                        `,
                        entities.map(e => keysNoId.reduce((p, c) => p[c] = e[c], {})))
                        .then(d => {
                            db.sqlite.run("COMMIT")
                            r(d)
                        }, e => {
                            db.sqlite.run('ROLLBACK')
                            f(e)
                        })
                })
            })
        }
        ,

        /**
         * @typedef updateById
         * @template T
         * @template K
         * @param {Partial<T>} entity
         * @param {K?} id
         * @returns {Promise<boolean>}
         */
        updateById(entity, id) {
            if (id === undefined) {
                id = entity[idKey];
            }
            if (id === null || id === undefined) {
                return Promise.reject('id 不能为空')
            }
            const param = []
            return db.exec(`
                update ${tableName}
                set ${keys
                        .filter(k => k !== idKey && keys.includes(k) && entity[k] !== undefined)
                        .map(k => {
                            param.push(entity[k]);
                            return k + " = ?"
                        })
                        .join(",")
                    }
                where ${idKey} = ?`, [...param, id]).then(e => e.change() > 0)
        },

        /**
         * @template T
         * @template K
         * @param {Partial<T>} entity
         * @param {string} whereSql
         * @param {*[]} param
         * @returns {Promise<boolean>}
         */
        updateCustomize(entity, whereSql, param) {
            if (!whereSql) {
                return Promise.reject('whereSql 不能为空')
            }
            return db.exec(`
                update ${tableName}
                set ${keys
                        .filter(k => k !== idKey && keys.includes(k) && entity[k] !== undefined)
                        .map(k => {
                            param.push(entity[k]);
                            return k + " = ?"
                        })
                        .join(",")
                    }
                where ${whereSql}`, [...param])

        },
        /**
         * @typedef deleteById
         * @template K
         * @param {K|K[]} id
         * @returns {Promise<boolean>}
         */
        deleteById(id) {
            if (Array.isArray(id)) {
                return db.exec(`
                    delete
                    from ${tableName}
                    where ${idKey} in (${id.map(i => "?").join(",")})`, id)
            }
            return db.exec(`
                delete
                from ${tableName}
                where ${idKey} = ?`, id)
        },
        /**
         * @template K
         * @param {string} whereSql
         * @param {*[]} param
         * @returns {Promise<boolean>}
         */
        deleteCustomize(whereSql, param) {
            if (!whereSql) {
                return Promise.reject('whereSql 不能为空')
            }
            return db.exec(`
                delete
                from ${tableName}
                where ${whereSql}`, param)
        },
        /**
         * @return {string}
         */
        tableName() {
            return tableName
        }
        ,

        /**
         * @return {string}
         */
        idKey() {
            return idKey
        }
        ,

        /**
         * @return {string[]}
         */
        keys() {
            return keys
        }
        ,

        /**
         * @return {string}
         */
        idType() {
            return idType1
        }
        ,
        /**
         * @type {import("./index").db}
         */
        db,
    }
}
