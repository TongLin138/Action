import{p as h}from"./propTypes-8a448afd.js";import{u as S}from"./useDesign-01a81f9b.js";import{an as v,cx as C,a_ as b,G as x,x as m,h as $,u,a6 as z,as as F,ac as L,a8 as w,aG as B,av as d,aw as _,ax as D}from"./vendor-a7094419.js";import{a as W}from"./useAppInject-582724ea.js";import{_ as j}from"./index-c5daf99f.js";const k=Symbol(),I=(e,s=!0)=>{const{on:a,off:i,reset:c,emit:o}=v(e??k);let n,t;function l(p,{wait:f=150,immediate:g=!1,isPassPars:y=!0}={}){n=b(p,f),t=()=>{n()},a(y?n:()=>{n()}),g&&o()}function r(p){const f=p||n||t;f&&i(f)}return C(()=>{s&&r()}),{on:l,off:r,reset:c,emit:o}},N=x({name:"IFrame",props:{frameSrc:h.string.def("")},setup(){const e=m(!0),s=m(),{prefixCls:a}=S("iframe-page"),{on:i,emit:c}=I(),{height:o}=W();i(t);const n=$(()=>({height:`${u(o)}px`}));function t(){const r=u(s);r&&(r.style.height=`${u(o)}px`)}function l(){e.value=!1,c()}return{getWrapStyle:n,loading:e,frameRef:s,prefixCls:a,hideLoading:l}}});const O=["src"];function R(e,s,a,i,c,o){const n=D;return z(),F("div",{class:d(e.prefixCls),style:_(e.getWrapStyle)},[L(n,{show:e.loading,size:"large",style:_(e.getWrapStyle)},{default:w(()=>[B("iframe",{ref:"frameRef",src:e.frameSrc,class:d(`${e.prefixCls}__main`),onLoad:s[0]||(s[0]=(...t)=>e.hideLoading&&e.hideLoading(...t))},null,42,O)]),_:1},8,["show","style"])],6)}const E=j(N,[["render",R],["__scopeId","data-v-a223c239"]]),M=Object.freeze(Object.defineProperty({__proto__:null,default:E},Symbol.toStringTag,{value:"Module"}));export{E as F,M as i,I as u};
