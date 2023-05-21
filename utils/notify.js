const {DIR_KEY} = require("../web/core/file");
const notify = require(DIR_KEY.ROOT + DIR_KEY.SCRIPTS + 'sendNotify');
const title = process.argv[2];
const content = process.argv[3];

notify.sendNotify(`${title}`, `${content}`);