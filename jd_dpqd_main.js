/*
活动名称：批量店铺签到（活动查询）
活动链接：https://h5.m.jd.com/babelDiy/Zeus/2PAAf74aG3D61qvfKUM5dxUssJQ9/index.html?token=<token>
环境变量：jd_dpqd_tokens // 活动令牌，多个用英文逗号，@，&，换行分割

查询活动信息主脚本，IP限制严重建议使用代理，请勿频繁运行
自动去重并过滤无效活动，默认过滤垃圾奖品活动
运行后会在本地目录生成缓存文件以用于签到脚本使用

cron:1 1 1 1 *

*/

const $ = new Env('批量店铺签到（活动查询）')
const _0x260733=_0x2f24;(function(_0x47e18d,_0x34907f){const _0x2c8edf=_0x2f24,_0x599ad1=_0x47e18d();while(!![]){try{const _0x32e78d=-parseInt(_0x2c8edf(0x101,'(S75'))/0x1+-parseInt(_0x2c8edf(0x132,'USqL'))/0x2*(parseInt(_0x2c8edf(0x141,'USqL'))/0x3)+parseInt(_0x2c8edf(0x127,'Zhs^'))/0x4*(-parseInt(_0x2c8edf(0x124,'[A()'))/0x5)+parseInt(_0x2c8edf(0x14f,'9K@F'))/0x6+-parseInt(_0x2c8edf(0x174,'Kl(F'))/0x7+-parseInt(_0x2c8edf(0x121,'g@Vr'))/0x8+parseInt(_0x2c8edf(0x13c,'wNu4'))/0x9*(parseInt(_0x2c8edf(0xfc,'PUuV'))/0xa);if(_0x32e78d===_0x34907f)break;else _0x599ad1['push'](_0x599ad1['shift']());}catch(_0x518f65){_0x599ad1['push'](_0x599ad1['shift']());}}}(_0xadca,0x2e3da));const common=require(_0x260733(0x155,'6)oz')),{H5st,jsTk}=require(_0x260733(0x1a3,'PUuV'));let tokensList=(process[_0x260733(0x11d,'9K@F')][_0x260733(0x13f,'lMEf')]||'')[_0x260733(0x16f,'INOA')](/[,@&|\n]+/g)[_0x260733(0x158,'eeyC')](Boolean);function _0xadca(){const _0x6784c3=['BXaChSkRzmkCWPSeaapdKa','oezjESo7oSkr','W7RdVJrq','WOXaWPvNW7WdW5y','wqxcVa','D8o5ESoHW67cISoAtbT7iYRdUCoTWRLzD2HkWQPW','5l2x5Ocd5yUw','WQ/ORyhMSR3LKkRLUOaF','WOaDW78','EmkooSk3rxRdTCo9WRy','ESoQya','W6pdGu8','WO3ORPNMSltLPANOTy4i4P+YWPO','77+j5BsC5y6h5A+u','emotW4xdM8kRda','iXdcG8kxWRC','uXVdSGZdId/dQwi5s8kOemkZWQBdPW','8jsyLM3MNjlORyBMTj7LIOBKV4dMGRVLPjpOTR984P6fpW','W7aYA8kPzG','WRi+WOj7AmkaWOFcLG','B8kzj8kffuxdQa','W69UWOT/u8kL','wbhdOq','WOaxW7yNbh4','kmkgWOdcICo4','W57dQqSf','xZ/dUmkn','W78WCSkNEmoNdSoLWPP2','C8oRCq','cdG0W7e+W6JdI8oa','WObeWRy','tmo9omombHhcTmkxWPna','FCotW5/dQSkbnHVcQ8oIW6VdGJNdNq','W6DQWPf5','FEE7U+ADSU+8OUs6MEATTUAuNEEbSEACTEwrNtpcNW','W4BcMmkHWQbMDq1W','EqBcTa','W59fxtmOvvBcSq','W7RdISk0W75ErmoSWOpcMXtdKSkA','naFcNSk9WQbJDu5Ifr4mwhq','WPWdzG','iaRcHCkDWPXTyfi','5yEa57QP5y+G','W6VdL8kgWPq','sCo8kq','5lUV5lIk54IA5QgK5B+Z6zwY6k2A','wmo3W5S','W5Pewq','uJxdPCkIiLCWD8ojW5RcGSonz3X7','W6SnW50PqexdPa','z8oJD8o2W6lcL8oC','bKtdQwddGSoDW78','W4BcMmo3W7iAdYffW7jCWRO5','W47dV8kJWQfmvbW','WONdSmknW7NcOWldQa','pmkiWOijuIxcVXVdHwWMW4yr','eg3cSmoqWRFdLCkNeSkbnh3dQSoDW6BdHcDIW5VdVx4lW5bwW4NcOSoow8kaWOjgW70QhSoYfLSuWQNcKmop','uG/cRW/cKmkhWQzxl8kFh8ozW7bSDa','k8kmWOdcUq','ChTgcCopmer1W6KoB8kGWRG','stpdTa','jSkyWRrr','xHRdMsNdMZRdPeSKumk6pmkZWRm','h3hcQ8oyWOddMSkWfmk3mMS','W69RWO54mdRdP8oVFSkmW6ddLq','WQ48W4KMDxK','W7b/WPDXsCkQWOZcHgS','W6tdUdbB','WRK+W4i8','WOzRW4u','WQVcGse','jsuv','eCoZWOyb','cEw7LUITK+EMJUMyS+EzM+A1VUwlOo++SG','sJBdT8kaW7ZcHSk8cSkDneddQW','WOuCW6WLaLv4W5HPe2tcUgfDdvJcRSk/W4K2','aSo+AKmvW6WAW7XeWRap','WPFdUSkPW7m','j8kXnfOgdSkQWPJdTr8FWPRcKa','ye3cIry/','W7n+WPzW','WQtcNSo3','FEIVN+AXR+wKN+I2T3FINAJdQoAwSowsT+w7MEAxPEApTW','W69NWOP/pd7dQ8oMFmkmW5RdNW','lqpcIae+WRm2z8o6wLVcMuLnmI9UgmkHzCoQWPdcHG','4P2eW5ZOHyNMN6hOV7dOOBRPG5VLIR7KUytPLy3ORyuQ','W4pdVqudxrZcVa','WRpcO8oimuKP','lv1ErG','xW7cHcRcG8kcWQT+nSkzd8o+W6PvFSoAW6m','BmkDj8kS','s8oyoq','5BMT6zkJ5zkW56wO77YtW48','WPHHW5mEkJCE','oeZdU1jDbrpcGYZcNG','eCoVWOabjCoPW5VdIhS','vmoUWPWWmCkOWPRcNbD6oNbsv8oqlCoMWR5mW5G','W4VcR8keW7FdNCoUWRtdVq','hCo1WOmBmmkQ','WP8RW4/dLxRcIW','W59GWOfmW4OS','ot8bwq','W6hdGv8','W5dcQ8ksW5/dNCoQWPJdTq','cNFcTSoCWQVdK8kTamkN','iXFcMCkf','nu1msSo3jCkh','WQCeWQdcJ3tcLq','W4tdOqSf','C03cJXq6WQWbkCoCxG','W7FdPSo4W6Gj','W7S7D8k1DCoPdW','W7jzW6q','W6VdN8kmWOr7sSoVWRK','W54pgZ1grXZdK10Bgq','WOSNW4iWWOP8W788oSoXW69z','DuNcKXeYWQ0mla','5y2U6yEK54Qi5OgE57Qo5P2UdSo/WOTFWOHkbSo/CXu','W6JdUCoZ','wbVdQcRdNYm','WOPcWR8udCkloa','5RE65yUE5BsC5lUfqa','qmoskG','Fmkzimk5','A1JcIquKW6vQz8oacHFcKqTucwTPnmkJjW','WRRNJkFLO6xLJRJPH7FVVBu','WPaQW6NdT2lcIxG','lsSlqG','pISBrq','5lMS55kW5B+/5yAulH/dMG','W6FdUt1qeW','5B+W5AAN5PE36zEt77Yb','WQOyWRq','WOLfWQC','W5DisJyRweFcU8oLfSoua07cSq','cNFcPCobWRddHW','WR7cMHVcQgxdGSo9W6pcJWJcULFcGG','W6xdTCoGW6GlWQLfumotW5q','iSoHzLGm','WPCjDwz4eSokpq0zW5v7CCkLlG','5Q6E5Pwr562C5yIN','bYqJW6X2W5FdJ8kjyCo3gCkvWPxdGXBdUa','fwZcOW','zmktna','p0BdUq','4P6MjoImLEwoVEA1TowlRos+I+AcKEwNS+I2PW','y8keeYeaWPbYW5vzWPbQfSkz','W4ldVqGLvGS','WRlcKXxcPghdJ8o2WRtdHhm','W6pdS8oGW4aEWRryx8oZW4tcUCoRuCkQWOm','W5NdUZabvaBcQW','WRK2W5pdRgZcGMldJJijzX8','W6pdMCky','W6u7Ca','WQ4RW5O9CvNdQSoytq','5RAn5yQd5BEm57Qm5PYcoW','hY4PW7W8W7q','sCkOW5PyymoVWO/cOH50ivq','xatcRYVcGCksWQXvfSkzd8oQW7TzCmobW5NcQ8kEW60','pCorthbmW4a','4PUCWPBORzZLH7tLRyxKUk3LV53OPj/NM6dNJiNLOj7LJzVPHjZLKklLHyFOV5xOOyBOHylMN5lVV50','WPtcQfZcPNFcI8oehHKXeCkTW57cV8oVESomCdpcHqOxts7cP8kfWQ3dK8oJumofxCoDvJr9W43dO1m7tmowW4xcPmooW6xcRvZcNmoth3qdWRuDcxusW5hdV8oKW7xdPhStv8oZxCkJWRdcNCkIEq','WPzFmfRcQqjiWPKHmeJdOmkKWOrYWRC','4P25CoEUVq','nGZcJSk5WRTHAa','it4gqCkipvGZW60Ru8oGWPbcmtCUsSkPg17cUCoVW4W','W63dUmoIW6arWQLvAmo5W4q','WPHoWQKbtSkxlqLBW7G','WOKPW5hdSx0','W7RdHCkAWQzKt8ovWQhdJG','br3dSLxdMGZcHmkH','WRFcPM0nxWRdHmkah8k7WQ0WWRW','ggdcSmoCWRpdNCkWh8kxmW','WRaSW5W','WQC3WPymsYhdUCoDbCk+W7xdTcOAvZ1vrmo1','WQOyWRtcO2hcIq','5yw2fEwpSa','WOaEAf1+nmowjWeHW4vbAW','nGZcNSkFWRTPFG','WOLakxNcMGvIW6a','fCo9WOik','WQxcKmoG','W73dG8ktWOjN','o8kaWRrBqL7cJH4Pymk+C8oRWP9oW6a'];_0xadca=function(){return _0x6784c3;};return _0xadca();}const printEnvValue=process[_0x260733(0x186,'pGRi')][_0x260733(0x15a,'&!d5')]==='true';let TokensMap=new Map();const CacheFile=__dirname+_0x260733(0x161,'IvYr');function _0x2f24(_0x2e073a,_0x5eb111){const _0xadca2c=_0xadca();return _0x2f24=function(_0x2f249c,_0x4d00a7){_0x2f249c=_0x2f249c-0xf8;let _0x2ce95a=_0xadca2c[_0x2f249c];if(_0x2f24['zYVqwq']===undefined){var _0x5cd8e0=function(_0x58bd77){const _0x4dc07f='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/=';let _0x492e7f='',_0x5ab0fd='';for(let _0x497b10=0x0,_0x1c8eff,_0x407801,_0x354c81=0x0;_0x407801=_0x58bd77['charAt'](_0x354c81++);~_0x407801&&(_0x1c8eff=_0x497b10%0x4?_0x1c8eff*0x40+_0x407801:_0x407801,_0x497b10++%0x4)?_0x492e7f+=String['fromCharCode'](0xff&_0x1c8eff>>(-0x2*_0x497b10&0x6)):0x0){_0x407801=_0x4dc07f['indexOf'](_0x407801);}for(let _0x49177e=0x0,_0x431071=_0x492e7f['length'];_0x49177e<_0x431071;_0x49177e++){_0x5ab0fd+='%'+('00'+_0x492e7f['charCodeAt'](_0x49177e)['toString'](0x10))['slice'](-0x2);}return decodeURIComponent(_0x5ab0fd);};const _0x252e00=function(_0x5e217c,_0x5715da){let _0x11d9d6=[],_0x3b7bb9=0x0,_0x502e50,_0x255baf='';_0x5e217c=_0x5cd8e0(_0x5e217c);let _0x355d9a;for(_0x355d9a=0x0;_0x355d9a<0x100;_0x355d9a++){_0x11d9d6[_0x355d9a]=_0x355d9a;}for(_0x355d9a=0x0;_0x355d9a<0x100;_0x355d9a++){_0x3b7bb9=(_0x3b7bb9+_0x11d9d6[_0x355d9a]+_0x5715da['charCodeAt'](_0x355d9a%_0x5715da['length']))%0x100,_0x502e50=_0x11d9d6[_0x355d9a],_0x11d9d6[_0x355d9a]=_0x11d9d6[_0x3b7bb9],_0x11d9d6[_0x3b7bb9]=_0x502e50;}_0x355d9a=0x0,_0x3b7bb9=0x0;for(let _0x194600=0x0;_0x194600<_0x5e217c['length'];_0x194600++){_0x355d9a=(_0x355d9a+0x1)%0x100,_0x3b7bb9=(_0x3b7bb9+_0x11d9d6[_0x355d9a])%0x100,_0x502e50=_0x11d9d6[_0x355d9a],_0x11d9d6[_0x355d9a]=_0x11d9d6[_0x3b7bb9],_0x11d9d6[_0x3b7bb9]=_0x502e50,_0x255baf+=String['fromCharCode'](_0x5e217c['charCodeAt'](_0x194600)^_0x11d9d6[(_0x11d9d6[_0x355d9a]+_0x11d9d6[_0x3b7bb9])%0x100]);}return _0x255baf;};_0x2f24['zBzLJo']=_0x252e00,_0x2e073a=arguments,_0x2f24['zYVqwq']=!![];}const _0x1de37a=_0xadca2c[0x0],_0xad60ba=_0x2f249c+_0x1de37a,_0x480ff8=_0x2e073a[_0xad60ba];return!_0x480ff8?(_0x2f24['vfZzVM']===undefined&&(_0x2f24['vfZzVM']=!![]),_0x2ce95a=_0x2f24['zBzLJo'](_0x2ce95a,_0x4d00a7),_0x2e073a[_0xad60ba]=_0x2ce95a):_0x2ce95a=_0x480ff8,_0x2ce95a;},_0x2f24(_0x2e073a,_0x5eb111);}!(async()=>{await Main();})()[_0x260733(0x150,'6)oz')](_0x252e00=>$[_0x260733(0xf8,'1Qj0')](_0x252e00))[_0x260733(0x179,'pGRi')](()=>$[_0x260733(0x13b,'g@Vr')]());async function Main(){const _0x292f08=_0x260733;try{console[_0x292f08(0x185,'1Qj0')]('=========='+$[_0x292f08(0x11a,'CmMS')]+'变量开启状态=========='),console[_0x292f08(0x191,'oNhg')](_0x292f08(0x182,'u$^B')+common[_0x292f08(0x128,'2!Pw')]()+']'),console[_0x292f08(0x199,'u$^B')](_0x292f08(0x195,'0O!W')+$[_0x292f08(0xfd,'IvYr')]+_0x292f08(0x176,'WXs$')),console[_0x292f08(0x10c,'0O!W')]('');if(tokensList[_0x292f08(0x118,'u!6V')]>0x0)tokensList=[...new Set(tokensList[_0x292f08(0x163,'IvYr')](_0x5ab0fd=>_0x5ab0fd!==''))];if(tokensList[_0x292f08(0x116,'7tNH')]<=0x0){console[_0x292f08(0x146,'FLuy')](_0x292f08(0x1a1,'Oksp'));return;}const _0x58bd77=[];console['log'](''),$['UA']=common[_0x292f08(0x119,'g@Vr')](_0x292f08(0x136,'[A()')),{jsToken:$[_0x292f08(0x17f,'H[WX')]}=await jsTk($['UA'],_0x292f08(0x1a2,'R[uN'),{'bizId':_0x292f08(0x14d,'YzB['),'v':_0x292f08(0x134,'&!d5'),'qs':'token='+tokensList[0x0]});for(let [_0x497b10,_0x1c8eff]of tokensList[_0x292f08(0xfb,'2!Pw')]()){let _0x407801=!![];const _0x354c81=_0x497b10+0x1;_0x1c8eff[_0x292f08(0x126,'WXs$')](':')&&_0x1c8eff[_0x292f08(0x1a9,'H[WX')](':')['length']===0x3&&(_0x1c8eff=_0x1c8eff[_0x292f08(0x16f,'INOA')](':')[0x0]);if(_0x1c8eff[_0x292f08(0x116,'7tNH')]!==0x20||!/^[A-Z0-9]*$/[_0x292f08(0x17c,'!oL%')](_0x1c8eff)){console[_0x292f08(0x10b,'9K@F')](_0x292f08(0x1a4,'LAF%')+_0x354c81+_0x292f08(0x12e,'bajf'));continue;}$['token']=_0x1c8eff,TokensMap['set'](_0x1c8eff,{'index':null,'venderId':'','shopName':'','activityId':'','startTime':'','endTime':'','isValid':!![],'rules':[],'minLevel':null,'maxLevel':null});let _0x49177e=0x0;$['getActivityInfo']='',$[_0x292f08(0x120,'a!QW')]=![];const _0x431071=0xa;while(!$['getActivityInfo']&&_0x49177e<_0x431071&&!$[_0x292f08(0x1a7,'INOA')]){$['getActivityInfo']='',await sendRequest(_0x292f08(0x13a,'&!d5')),await $[_0x292f08(0x181,'wNu4')](0x3e8),_0x49177e++,_0x49177e===_0x431071&&(console[_0x292f08(0x148,'wNu4')]($[_0x292f08(0x164,'H[WX')]||_0x292f08(0x192,'FLuy')),$[_0x292f08(0x165,'Kl(F')]='');}if(!$['getActivityInfo'])continue;const _0x5e217c=$['getActivityInfo'][_0x292f08(0x162,'$koQ')],_0x5715da=$['getActivityInfo']['id'],_0x11d9d6=$[_0x292f08(0x18c,'VP%C')][_0x292f08(0x187,'WXs$')],_0x3b7bb9=$['getActivityInfo'][_0x292f08(0x106,'*cj4')]||[],_0x502e50=$[_0x292f08(0x131,'LAF%')][_0x292f08(0xfa,'VP%C')]||[],_0x255baf=$[_0x292f08(0x196,'INOA')][_0x292f08(0x19b,'USqL')],_0x355d9a=$[_0x292f08(0x131,'LAF%')][_0x292f08(0x102,'(S75')],_0x194600=$[_0x292f08(0x16d,'CmMS')](_0x292f08(0x100,'GHv4'),_0x255baf),_0xc80922=$[_0x292f08(0x103,'xbXt')](_0x292f08(0x18e,'G8Zr'),_0x355d9a);let _0x58e48d=![];const _0x5356f8=[],_0x38c450=[..._0x502e50,..._0x3b7bb9];for(const _0xa4077e of _0x38c450){const _0x1e7a96=_0xa4077e['level'],_0x5b1521=_0xa4077e[_0x292f08(0x10a,'!oL%')]||[],_0x28853a=[];for(const _0x34c07f of _0x5b1521){let _0x55c126='';const _0x463ab2=_0x34c07f[_0x292f08(0x172,'u$^B')],_0x4ecb2d=_0x34c07f[_0x292f08(0x14e,'qex1')],_0x585ff0=_0x34c07f['number'],_0x375b70=_0x34c07f[_0x292f08(0x188,'TgYs')],_0x2f7fdd=_0x375b70===0x5;switch(_0x4ecb2d){case 0x1:_0x55c126=_0x292f08(0x107,'g@Vr');break;case 0x4:_0x55c126=_0x463ab2+'京豆';break;case 0x6:_0x55c126=_0x463ab2+'店铺积分';break;case 0x9:_0x55c126=''+_0x34c07f?.[_0x292f08(0x19f,'&!d5')][0x0]?.['skuName'];break;case 0xa:_0x55c126=_0x463ab2+_0x292f08(0xf9,'LAF%');break;case 0xe:_0x55c126=_0x463ab2/0x64+_0x292f08(0x12b,'7tNH');break;default:_0x55c126='未知奖品（'+_0x4ecb2d+'）';}if(![0x1,0x6][_0x292f08(0x1ab,'$4S1')](_0x4ecb2d)&&!_0x2f7fdd)_0x58e48d=!![];_0x28853a[_0x292f08(0x159,'(S75')](_0x55c126+'（共'+_0x585ff0+'份'+(_0x2f7fdd?_0x292f08(0x10e,'bajf'):'')+'）');}_0x5356f8['push']({'days':_0x1e7a96,'prize':_0x28853a,'havePrize':_0x58e48d});}const _0x55cbff=await common['getShopName']({'venderId':_0x5e217c});console[_0x292f08(0xfe,'Zhs^')]('【'+_0x1c8eff+'】\x0a'+(_0x55cbff?_0x292f08(0x15d,'H[WX')+_0x55cbff+'\x0a':'')+_0x292f08(0x184,'VP%C')+_0x194600+'\x0a结束时间：'+_0xc80922);_0x5356f8[_0x292f08(0x1a0,'YzB[')]>0x0&&console[_0x292f08(0x109,'u!6V')](_0x5356f8[_0x292f08(0x152,'Zhs^')](_0x562c9a=>(_0x562c9a[_0x292f08(0x12c,'u$^B')]===0x0?_0x292f08(0x18d,'YzB['):'连续'+(_0x562c9a[_0x292f08(0x13e,'GHv4')]<0xa?'\x20':'')+_0x562c9a[_0x292f08(0x180,'wNu4')]+'天')+'：'+_0x562c9a[_0x292f08(0x110,'2!Pw')][_0x292f08(0x144,'xbXt')]('，'))[_0x292f08(0x149,'IvYr')]('\x0a'));console[_0x292f08(0x18f,'TgYs')]('');const _0x5b29eb=Date[_0x292f08(0x167,'0O!W')]();_0x255baf&&_0x5b29eb<_0x255baf&&(console[_0x292f08(0x117,'lMEf')]('活动将在\x20'+_0x194600+'\x20开始，晚点再来吧~\x0a'),_0x58bd77['push'](_0x1c8eff),_0x407801=![]);if(_0x355d9a&&_0x5b29eb>_0x355d9a)console[_0x292f08(0x105,'&!d5')](_0x292f08(0x17a,'a4u*')+_0xc80922+_0x292f08(0x123,'(S75')),_0x58bd77[_0x292f08(0x151,'7tNH')](_0x1c8eff),_0x407801=![];else _0x11d9d6===0x3&&(console['log'](_0x292f08(0x19c,'WXs$')),_0x58bd77['push'](_0x1c8eff),_0x407801=![]);!_0x58e48d&&(_0x58bd77[_0x292f08(0x16a,'2!Pw')](_0x1c8eff),_0x407801=![]);const _0x341052=TokensMap[_0x292f08(0x15c,'WH4#')](_0x1c8eff);_0x341052[_0x292f08(0x183,'xbXt')]=_0x354c81,_0x341052[_0x292f08(0x11e,'G8Zr')]=_0x5e217c,_0x341052[_0x292f08(0x12a,'2!Pw')]=_0x55cbff,_0x341052[_0x292f08(0x18a,'INOA')]=_0x5715da,_0x341052['startTime']=_0x255baf,_0x341052[_0x292f08(0x1a5,'2!Pw')]=_0x355d9a,_0x341052[_0x292f08(0x197,'CmMS')]=_0x407801,_0x341052[_0x292f08(0xff,'u$^B')]=_0x5356f8,_0x5356f8[_0x292f08(0x178,'lMEf')]>0x0&&(_0x341052['minLevel']=_0x5356f8[0x0]['days'],_0x341052[_0x292f08(0x168,'$koQ')]=_0x5356f8[_0x5356f8['length']-0x1][_0x292f08(0x145,'USqL')]),TokensMap[_0x292f08(0x19a,'5m7T')](_0x1c8eff,_0x341052);}if(_0x58bd77[_0x292f08(0x10f,'Oksp')]>0x0){console[_0x292f08(0x11f,'pGRi')](_0x292f08(0x14a,'6)oz'));for(const _0x1dae1f of _0x58bd77){console[_0x292f08(0x17b,'WH4#')](_0x1dae1f);}}const _0x4dc07f=Object[_0x292f08(0x140,'TgYs')](TokensMap),_0x492e7f=require('fs');_0x492e7f[_0x292f08(0x138,'UPn(')](CacheFile,JSON[_0x292f08(0x143,'7tNH')](_0x4dc07f,null,0x2)),console[_0x292f08(0x130,'WXs$')]('缓存写入完毕，所在目录：'),console['log'](CacheFile);if(printEnvValue){console[_0x292f08(0x129,'VP%C')](_0x292f08(0x17e,'CmMS'));let _0x24a9ca=[];for(const [_0x276650,_0x101aa1]of TokensMap){_0x101aa1['activityId']&&_0x101aa1['venderId']&&_0x24a9ca[_0x292f08(0x166,'wNu4')](_0x276650+':'+_0x101aa1[_0x292f08(0x1ad,'TgYs')]+':'+_0x101aa1[_0x292f08(0x175,'6)oz')]);}console[_0x292f08(0x190,'!oL%')](_0x24a9ca[_0x292f08(0x11b,'LAF%')](','));}}catch(_0x15339f){console[_0x292f08(0x177,'INOA')](_0x292f08(0x156,'!oL%')+_0x15339f);}}async function handleResponse(_0x328264,_0x40ba6b){const _0x3cf005=_0x260733;try{switch(_0x328264){case _0x3cf005(0x111,'lMEf'):if(_0x40ba6b['code']===0xc8&&_0x40ba6b[_0x3cf005(0x157,'CmMS')]===!![]&&_0x40ba6b[_0x3cf005(0x122,'7tNH')])$['getActivityInfo']=_0x40ba6b['data'];else _0x40ba6b[_0x3cf005(0x1ae,'USqL')]?(console[_0x3cf005(0x117,'lMEf')](_0x3cf005(0x112,'WH4#')+_0x40ba6b['msg']),$['invalidAct']=!![]):(console['log']('❓'+_0x328264+'\x20'+JSON[_0x3cf005(0x169,'TgYs')](_0x40ba6b)),$[_0x3cf005(0x11c,'5m7T')]=!![]);break;}}catch(_0x30368a){console['log']('❌\x20未能正确处理\x20'+_0x328264+_0x3cf005(0x108,'u$^B')+(_0x30368a[_0x3cf005(0x170,'5m7T')]||_0x30368a));}}async function sendRequest(_0x205fb2){const _0x40ff21=_0x260733;if($[_0x40ff21(0x194,'CmMS')])return;let _0x2e7a8b='',_0x5a1032=null,_0x4c6e46=null,_0x358f8c=_0x40ff21(0x12f,'Fx7M'),_0x7c9007={},_0x1892b4={};switch(_0x205fb2){case'getActivityInfo':_0x1892b4={'appId':_0x40ff21(0x18b,'9K@F'),'functionId':_0x40ff21(0x139,'TgYs'),'appid':_0x40ff21(0x14c,'u!6V'),'body':{'token':$['token'],'venderId':parseInt($['venderId'])||''},'version':_0x40ff21(0x171,'1Qj0'),'ua':$['UA']},_0x7c9007=await H5st[_0x40ff21(0x115,'!oL%')](_0x1892b4),_0x2e7a8b=_0x40ff21(0x1a6,'wNu4'),_0x4c6e46=Object[_0x40ff21(0x16c,'1Qj0')]({},_0x7c9007[_0x40ff21(0x16e,'6)oz')],{'jsonp':_0x40ff21(0x160,'IvYr')});break;default:console[_0x40ff21(0x12d,'a!QW')]('❌\x20未知请求\x20'+_0x205fb2);return;}const _0x25333e={'t':Math[_0x40ff21(0x113,'5m7T')](Date[_0x40ff21(0x147,'bajf')]()/0x3e8)+_0x40ff21(0x13d,'TgYs'),'loginType':'2','x-api-eid-token':$[_0x40ff21(0x137,'qex1')]};_0x5a1032&&Object[_0x40ff21(0x19d,'G8Zr')](_0x5a1032,_0x25333e);_0x4c6e46&&Object['assign'](_0x4c6e46,_0x25333e);const _0x25f7ae={'url':_0x2e7a8b,'method':_0x358f8c,'headers':{'Accept':_0x40ff21(0x125,'oNhg'),'Accept-Encoding':'gzip,\x20deflate,\x20br','Accept-Language':_0x40ff21(0x1af,'USqL'),'Connection':_0x40ff21(0x15f,'oNhg'),'Content-Type':_0x40ff21(0x1a8,'pGRi'),'Host':'api.m.jd.com','Referer':_0x40ff21(0x17d,'6)oz'),'Sec-Fetch-Dest':_0x40ff21(0x142,'USqL'),'Sec-Fetch-Mode':'no-cors','Sec-Fetch-Site':_0x40ff21(0x173,'AecN'),'User-Agent':$['UA']},'params':_0x4c6e46,'data':_0x5a1032,'timeout':0x7530,'httpsTlsOptions':common[_0x40ff21(0x1aa,'u$^B')]()};_0x358f8c==='GET'&&(delete _0x25f7ae['data'],delete _0x25f7ae[_0x40ff21(0x16b,'(S75')][_0x40ff21(0x198,'H[WX')]);const _0x1876a9=0x1;let _0x2332cd=0x0,_0x5b1428=null,_0x5d27f7=null;while(_0x2332cd<_0x1876a9){_0x2332cd>0x0&&await $['wait'](0x7d0);const _0x1ad67b=await common[_0x40ff21(0x15e,'FLuy')](_0x25f7ae);if(!_0x1ad67b[_0x40ff21(0x133,'*cj4')]){_0x5d27f7=_0x1ad67b['status'],_0x5b1428='🚫\x20'+_0x205fb2+_0x40ff21(0x10d,'AecN')+_0x1ad67b['error'],_0x2332cd++;continue;}if(!_0x1ad67b[_0x40ff21(0x15b,'!oL%')]){_0x5b1428='🚫\x20'+_0x205fb2+_0x40ff21(0x153,'(S75'),_0x2332cd++;continue;}await handleResponse(_0x205fb2,_0x1ad67b['data']),ipBlack=![];break;}_0x2332cd>=_0x1876a9&&($['errMsg']=_0x5b1428,_0x5d27f7!==0x193&&console[_0x40ff21(0x18f,'TgYs')](_0x5b1428));}
// prettier-ignore
function Env(t,e){"undefined"!=typeof process&&JSON.stringify(process.env).indexOf("GITHUB")>-1&&process.exit(0);class s{constructor(t){this.env=t}send(t,e="GET"){t="string"==typeof t?{url:t}:t;let s=this.get;return"POST"===e&&(s=this.post),new Promise((e,i)=>{s.call(this,t,(t,s,r)=>{t?i(t):e(s)})})}get(t){return this.send.call(this.env,t)}post(t){return this.send.call(this.env,t,"POST")}}return new class{constructor(t,e){this.name=t,this.http=new s(this),this.data=null,this.dataFile="box.dat",this.logs=[],this.isMute=!1,this.isNeedRewrite=!1,this.logSeparator="\n",this.startTime=(new Date).getTime(),Object.assign(this,e),this.log("",`🔔${this.name}, 开始!`)}isNode(){return"undefined"!=typeof module&&!!module.exports}isQuanX(){return"undefined"!=typeof $task}isSurge(){return"undefined"!=typeof $httpClient&&"undefined"==typeof $loon}isLoon(){return"undefined"!=typeof $loon}toObj(t,e=null){try{return JSON.parse(t)}catch{return e}}toStr(t,e=null){try{return JSON.stringify(t)}catch{return e}}getjson(t,e){let s=e;const i=this.getdata(t);if(i)try{s=JSON.parse(this.getdata(t))}catch{}return s}setjson(t,e){try{return this.setdata(JSON.stringify(t),e)}catch{return!1}}getScript(t){return new Promise(e=>{this.get({url:t},(t,s,i)=>e(i))})}runScript(t,e){return new Promise(s=>{let i=this.getdata("@chavy_boxjs_userCfgs.httpapi");i=i?i.replace(/\n/g,"").trim():i;let r=this.getdata("@chavy_boxjs_userCfgs.httpapi_timeout");r=r?1*r:20,r=e&&e.timeout?e.timeout:r;const[o,h]=i.split("@"),n={url:`http://${h}/v1/scripting/evaluate`,body:{script_text:t,mock_type:"cron",timeout:r},headers:{"X-Key":o,Accept:"*/*"}};this.post(n,(t,e,i)=>s(i))}).catch(t=>this.logErr(t))}loaddata(){if(!this.isNode())return{};{this.fs=this.fs?this.fs:require("fs"),this.path=this.path?this.path:require("path");const t=this.path.resolve(this.dataFile),e=this.path.resolve(process.cwd(),this.dataFile),s=this.fs.existsSync(t),i=!s&&this.fs.existsSync(e);if(!s&&!i)return{};{const i=s?t:e;try{return JSON.parse(this.fs.readFileSync(i))}catch(t){return{}}}}}writedata(){if(this.isNode()){this.fs=this.fs?this.fs:require("fs"),this.path=this.path?this.path:require("path");const t=this.path.resolve(this.dataFile),e=this.path.resolve(process.cwd(),this.dataFile),s=this.fs.existsSync(t),i=!s&&this.fs.existsSync(e),r=JSON.stringify(this.data);s?this.fs.writeFileSync(t,r):i?this.fs.writeFileSync(e,r):this.fs.writeFileSync(t,r)}}lodash_get(t,e,s){const i=e.replace(/\[(\d+)\]/g,".$1").split(".");let r=t;for(const t of i)if(r=Object(r)[t],void 0===r)return s;return r}lodash_set(t,e,s){return Object(t)!==t?t:(Array.isArray(e)||(e=e.toString().match(/[^.[\]]+/g)||[]),e.slice(0,-1).reduce((t,s,i)=>Object(t[s])===t[s]?t[s]:t[s]=Math.abs(e[i+1])>>0==+e[i+1]?[]:{},t)[e[e.length-1]]=s,t)}getdata(t){let e=this.getval(t);if(/^@/.test(t)){const[,s,i]=/^@(.*?)\.(.*?)$/.exec(t),r=s?this.getval(s):"";if(r)try{const t=JSON.parse(r);e=t?this.lodash_get(t,i,""):e}catch(t){e=""}}return e}setdata(t,e){let s=!1;if(/^@/.test(e)){const[,i,r]=/^@(.*?)\.(.*?)$/.exec(e),o=this.getval(i),h=i?"null"===o?null:o||"{}":"{}";try{const e=JSON.parse(h);this.lodash_set(e,r,t),s=this.setval(JSON.stringify(e),i)}catch(e){const o={};this.lodash_set(o,r,t),s=this.setval(JSON.stringify(o),i)}}else s=this.setval(t,e);return s}getval(t){return this.isSurge()||this.isLoon()?$persistentStore.read(t):this.isQuanX()?$prefs.valueForKey(t):this.isNode()?(this.data=this.loaddata(),this.data[t]):this.data&&this.data[t]||null}setval(t,e){return this.isSurge()||this.isLoon()?$persistentStore.write(t,e):this.isQuanX()?$prefs.setValueForKey(t,e):this.isNode()?(this.data=this.loaddata(),this.data[e]=t,this.writedata(),!0):this.data&&this.data[e]||null}initGotEnv(t){this.got=this.got?this.got:require("got"),this.cktough=this.cktough?this.cktough:require("tough-cookie"),this.ckjar=this.ckjar?this.ckjar:new this.cktough.CookieJar,t&&(t.headers=t.headers?t.headers:{},void 0===t.headers.Cookie&&void 0===t.cookieJar&&(t.cookieJar=this.ckjar))}get(t,e=(()=>{})){t.headers&&(delete t.headers["Content-Type"],delete t.headers["Content-Length"]),this.isSurge()||this.isLoon()?(this.isSurge()&&this.isNeedRewrite&&(t.headers=t.headers||{},Object.assign(t.headers,{"X-Surge-Skip-Scripting":!1})),$httpClient.get(t,(t,s,i)=>{!t&&s&&(s.body=i,s.statusCode=s.status),e(t,s,i)})):this.isQuanX()?(this.isNeedRewrite&&(t.opts=t.opts||{},Object.assign(t.opts,{hints:!1})),$task.fetch(t).then(t=>{const{statusCode:s,statusCode:i,headers:r,body:o}=t;e(null,{status:s,statusCode:i,headers:r,body:o},o)},t=>e(t))):this.isNode()&&(this.initGotEnv(t),this.got(t).on("redirect",(t,e)=>{try{if(t.headers["set-cookie"]){const s=t.headers["set-cookie"].map(this.cktough.Cookie.parse).toString();s&&this.ckjar.setCookieSync(s,null),e.cookieJar=this.ckjar}}catch(t){this.logErr(t)}}).then(t=>{const{statusCode:s,statusCode:i,headers:r,body:o}=t;e(null,{status:s,statusCode:i,headers:r,body:o},o)},t=>{const{message:s,response:i}=t;e(s,i,i&&i.body)}))}post(t,e=(()=>{})){if(t.body&&t.headers&&!t.headers["Content-Type"]&&(t.headers["Content-Type"]="application/x-www-form-urlencoded"),t.headers&&delete t.headers["Content-Length"],this.isSurge()||this.isLoon())this.isSurge()&&this.isNeedRewrite&&(t.headers=t.headers||{},Object.assign(t.headers,{"X-Surge-Skip-Scripting":!1})),$httpClient.post(t,(t,s,i)=>{!t&&s&&(s.body=i,s.statusCode=s.status),e(t,s,i)});else if(this.isQuanX())t.method="POST",this.isNeedRewrite&&(t.opts=t.opts||{},Object.assign(t.opts,{hints:!1})),$task.fetch(t).then(t=>{const{statusCode:s,statusCode:i,headers:r,body:o}=t;e(null,{status:s,statusCode:i,headers:r,body:o},o)},t=>e(t));else if(this.isNode()){this.initGotEnv(t);const{url:s,...i}=t;this.got.post(s,i).then(t=>{const{statusCode:s,statusCode:i,headers:r,body:o}=t;e(null,{status:s,statusCode:i,headers:r,body:o},o)},t=>{const{message:s,response:i}=t;e(s,i,i&&i.body)})}}time(t,e=null){const s=e?new Date(e):new Date;let i={"M+":s.getMonth()+1,"d+":s.getDate(),"H+":s.getHours(),"m+":s.getMinutes(),"s+":s.getSeconds(),"q+":Math.floor((s.getMonth()+3)/3),S:s.getMilliseconds()};/(y+)/.test(t)&&(t=t.replace(RegExp.$1,(s.getFullYear()+"").substr(4-RegExp.$1.length)));for(let e in i)new RegExp("("+e+")").test(t)&&(t=t.replace(RegExp.$1,1==RegExp.$1.length?i[e]:("00"+i[e]).substr((""+i[e]).length)));return t}msg(e=t,s="",i="",r){const o=t=>{if(!t)return t;if("string"==typeof t)return this.isLoon()?t:this.isQuanX()?{"open-url":t}:this.isSurge()?{url:t}:void 0;if("object"==typeof t){if(this.isLoon()){let e=t.openUrl||t.url||t["open-url"],s=t.mediaUrl||t["media-url"];return{openUrl:e,mediaUrl:s}}if(this.isQuanX()){let e=t["open-url"]||t.url||t.openUrl,s=t["media-url"]||t.mediaUrl;return{"open-url":e,"media-url":s}}if(this.isSurge()){let e=t.url||t.openUrl||t["open-url"];return{url:e}}}};if(this.isMute||(this.isSurge()||this.isLoon()?$notification.post(e,s,i,o(r)):this.isQuanX()&&$notify(e,s,i,o(r))),!this.isMuteLog){let t=["","==============📣系统通知📣=============="];t.push(e),s&&t.push(s),i&&t.push(i),console.log(t.join("\n")),this.logs=this.logs.concat(t)}}log(...t){t.length>0&&(this.logs=[...this.logs,...t]),console.log(t.join(this.logSeparator))}logErr(t,e){const s=!this.isSurge()&&!this.isQuanX()&&!this.isLoon();s?this.log("",`❗️${this.name}, 错误!`,t.stack):this.log("",`❗️${this.name}, 错误!`,t)}wait(t){return new Promise(e=>setTimeout(e,t))}done(t={}){const e=(new Date).getTime(),s=(e-this.startTime)/1e3;this.log("",`🔔${this.name}, 结束! 🕛 ${s} 秒`),this.log(),(this.isSurge()||this.isQuanX()||this.isLoon())&&$done(t)}}(t,e)}