var g=(t,r,a)=>new Promise((c,e)=>{var s=o=>{try{n(a.next(o))}catch(i){e(i)}},l=o=>{try{n(a.throw(o))}catch(i){e(i)}},n=o=>o.done?c(o.value):Promise.resolve(o.value).then(s,l);n((a=a.apply(t,r)).next())});import{h as m,u as d,_}from"./vendor--53G7TFY.js";import{F as p,G as u,H as L,I as h,J as I}from"./index-BeP8DsMB.js";function f(t){const r=p();u.mode==="legacy"?u.global.locale=t:u.global.locale.value=t,r.setLocaleInfo({locale:t}),I(t)}function S(){const t=p(),r=m(()=>t.getLocale),a=m(()=>t.getShowPicker);function c(e){return g(this,null,function*(){const s=u.global;if(d(s.locale)===e)return e;if(L.includes(e))return f(e),e;const n=(yield h(Object.assign({"./lang/en.ts":()=>_(()=>import("./en-n7XvYXDu.js"),__vite__mapDeps([0,1,2,3,4]),import.meta.url),"./lang/zh_CN.ts":()=>_(()=>import("./zh_CN-uxnfETfp.js"),__vite__mapDeps([5,1,2,3,4]),import.meta.url)}),`./lang/${e}.ts`)).default;if(!n)return;const{message:o}=n;return s.setLocaleMessage(e,o),L.push(e),f(e),e})}return{getLocale:r,getShowLocalePicker:a,changeLocale:c}}export{S as u};
function __vite__mapDeps(indexes) {
  if (!__vite__mapDeps.viteFileDeps) {
    __vite__mapDeps.viteFileDeps = ["./en-n7XvYXDu.js","./index-BeP8DsMB.js","./vendor--53G7TFY.js","./vendor-R3Rv6mP0.css","./index-Gofo9UYK.css","./zh_CN-uxnfETfp.js"]
  }
  return indexes.map((i) => __vite__mapDeps.viteFileDeps[i])
}