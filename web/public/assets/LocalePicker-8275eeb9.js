import{_ as h}from"./language-88bfd6ce.js";import{u as L}from"./useLocale-ebbf1077.js";import{l as i}from"./index-b98e63e9.js";import{G as k,x as C,h as u,aF as w,a6 as p,a7 as B,a8 as b,as as E,a9 as N,aH as T,aI as P,u as s,aJ as V,aG as D,aD as G,al as l,aE as S}from"./vendor-339b2486.js";const j={key:0,class:"ml-1"},I=k({__name:"LocalePicker",props:{showText:{type:Boolean,default:!1},reload:{type:Boolean},triggerCls:{type:String}},setup(r){const o=r,a=C(),{changeLocale:f,getLocale:c}=L(),d=u(()=>{const e=a.value;return e?i.find(t=>t.value===e)?.text:""}),g=u(()=>o.triggerCls?{class:o.triggerCls}:{});function m({label:e,value:t}){const n=t;return l("div",{class:"min-w-120px d-flex flex-jb-ac"},{default:()=>[l("span",void 0,{default:()=>e}),l("span",{class:"text-xs text-gray-400"},{default:()=>n})]})}w(()=>{a.value=s(c)});async function _(e){await f(e),a.value=e,o.reload&&location.reload()}function x(e){s(c)!==e&&_(e)}return(e,t)=>{const n=h,y=S;return p(),B(y,{value:s(a),"onUpdate:value":[t[0]||(t[0]=v=>G(a)?a.value=v:null),x],trigger:"click",options:s(i),"render-label":m},{default:b(()=>[E("span",D({quaternary:"",focusable:!1,size:"large",style:{"border-radius":"0",transition:".2s"}},{...s(g)}),[N(n,{class:"text-18px"}),r.showText?(p(),T("span",j,P(s(d)),1)):V("",!0)],16)]),_:1},8,["value","options"])}}});export{I as default};