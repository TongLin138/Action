require("./dbInit")
const template = require("../db/curdTemplate");

let curd = template("config", {
    id:0,
    type:'',
    label:'',
    value:'',
    sort:0,
}, "id", 0);

const Type = curd.Type;

module.exports = curd;
