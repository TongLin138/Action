import{p as h}from"./propTypes-8a448afd.js";import{u as S}from"./useDesign-04e0d610.js";import{an as v,cB as C,a_ as b,G as $,x as m,h as x,u,a6 as z,as as F,ac as B,a8 as L,aG as w,av as d,aw as _,ax as D}from"./vendor-95d24bd5.js";import{a as W}from"./useAppInject-dd275d0f.js";import{_ as j}from"./index-18ef6ea1.js";const k=Symbol(),I=(e,s=!0)=>{const{on:a,off:i,reset:f,emit:o}=v(e??k);let n,t;function l(p,{wait:c=150,immediate:g=!1,isPassPars:y=!0}={}){n=b(p,c),t=()=>{n()},a(y?n:()=>{n()}),g&&o()}function r(p){const c=p||n||t;c&&i(c)}return C(()=>{s&&r()}),{on:l,off:r,reset:f,emit:o}},N=$({name:"IFrame",props:{frameSrc:h.string.def("")},setup(){const e=m(!0),s=m(),{prefixCls:a}=S("iframe-page"),{on:i,emit:f}=I(),{height:o}=W();i(t);const n=x(()=>({height:`${u(o)}px`}));function t(){const r=u(s);r&&(r.style.height=`${u(o)}px`)}function l(){e.value=!1,f()}return{getWrapStyle:n,loading:e,frameRef:s,prefixCls:a,hideLoading:l}}});const O=["src"];function R(e,s,a,i,f,o){const n=D;return z(),F("div",{class:d(e.prefixCls),style:_(e.getWrapStyle)},[B(n,{show:e.loading,size:"large",style:_(e.getWrapStyle)},{default:L(()=>[w("iframe",{ref:"frameRef",src:e.frameSrc,class:d(`${e.prefixCls}__main`),onLoad:s[0]||(s[0]=(...t)=>e.hideLoading&&e.hideLoading(...t))},null,42,O)]),_:1},8,["show","style"])],6)}const E=j(N,[["render",R],["__scopeId","data-v-cd9f4239"]]),M=Object.freeze(Object.defineProperty({__proto__:null,default:E},Symbol.toStringTag,{value:"Module"}));export{E as F,M as i,I as u};