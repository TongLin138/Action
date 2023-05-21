/**
 * 格式化时间
 * @param fmt
 * @param date
 * @returns {*}
 */
function dateFormat(fmt, date) {
    let ret;
    const opt = {
        "y+": date.getFullYear().toString(),        // 年
        "M+": (date.getMonth() + 1).toString(),     // 月
        "d+": date.getDate().toString(),            // 日
        "h+": date.getHours().toString(),           // 时
        "m+": date.getMinutes().toString(),         // 分
        "s+": date.getSeconds().toString()          // 秒
        // 有其他格式化字符需求可以继续添加，必须转化成字符串
    };
    for (let k in opt) {
        ret = new RegExp("(" + k + ")").exec(fmt);
        if (ret) {
            fmt = fmt.replace(ret[1], (ret[1].length === 1) ? (opt[k]) : (opt[k].padStart(ret[1].length, "0")))
        }
    }
    return fmt;
}

function dateToString(date) {
    return dateFormat('yyyy-MM-dd hh:mm:ss', date)
}

Date.prototype.toJSON = function () {
    return dateToString(this);
}

function parseFileNameDate(fileName) {
    fileName = fileName.replace(".log", "");
    let array = fileName.split("-");
    return new Date(array[0], array[1] - 1, array[2], array[3], array[4], array[5]);
}

function randomNumber(min = 0, max = 100) {
    return Math.min(Math.floor(min + Math.random() * (max - min)), max);
}

/**
 * 对象数组排序
 * @param array 需要排序的数组
 * @param field 字段
 * @param isAsc 是否升序
 * @returns {*[]}
 */
function arrayObjectSort(field, array = [], isAsc = true) {
    field && array.sort((a, b) => {
        return isAsc ? a[field] - b[field] : b[field] - a[field];
    })
    return array;
}

//console.log(arrayObjectSort([{a: 1, c: '1'}, {a: 3, c: '3'}, {a: 2, c: '2'}],'a',false));

function inArray(search, array) {
    for (let i in array) {
        if (array[i] === search) {
            return true;
        }
    }
    return false;
}

/**
 * 是否为空
 * @param str
 * @returns {boolean}
 */
function isNotEmpty(str) {
    return null !== str && undefined !== str && str !== ''
}

/**
 * 去空格
 */
function strTrim(str = "") {
    return str.trim();
}

/**
 * 正则匹配
 */
function regExecFirst(str = "", reg) {
    let exec = reg.exec(str);
    if (exec && exec.length > 0) {
        return strTrim(exec[0])
    }
    return "";
}

module.exports = {
    dateToString,
    dateFormat, parseFileNameDate, randomNumber, arrayObjectSort, inArray, isNotEmpty, strTrim, regExecFirst
}
