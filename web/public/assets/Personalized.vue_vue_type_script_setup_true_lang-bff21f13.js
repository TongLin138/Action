import{u as f,_}from"./useForm-8e7f1fdb.js";import{U as P,p as b,b as F,P as T,m as v,s as a}from"./index-f8002877.js";import{G as w,r as x,h as y,aI as I,a6 as S,as as k,M as B,ac as n,a8 as V,aL as D,aC as M,u as l,aG as A,bw as E}from"./vendor-c47b8ac0.js";const G={class:"grid grid-cols-1 grid-flow-row-dense md:grid-cols-[450px_1fr] gap-4"},O=w({__name:"Personalized",setup(N){const e=P(),{getThemeColor:c,getIsDarkMode:i}=b(),{t:s}=F(),m=x({projectConfig:T.getLocal(v)}),p=y(()=>{const o=c.value,r=m.projectConfig?.themeColor,t=i.value?a.themeOverrides.dark.common.primaryColor:a.themeOverrides.light.common.primaryColor;return!e.getThemeColorIsManualChange&&e.getThemeColorIsFirstChange||o===r?t:r}),d=[{field:"themeColor",component:"NColorPicker",label:s("setting.personalized.themeColor"),componentProps:{modes:["hex"],showAlpha:!1,swatches:["#2d8cf0","#0960bd","#0084f4","#009688","#536dfe","#ff5c93","#ee4f12","#0096c7","#9c27b0","#ff9800","#FF3D68","#00C1D4","#71EFA3","#171010","#78DEC7","#1768AC","#FB9300","#FC5404"]},defaultValue:p.value}],[u,{setFieldsValue:g}]=f({schemas:d,labelPlacement:"top",gridProps:{cols:3,xGap:6},giProps:{span:2},submitButtonText:s("setting.changePwd.button.confirm")}),h=async o=>{e.setThemeColorIsFirstChange(!1),e.setThemeColorIsManualChange(!0),e.setProjectConfig({themeColor:o.themeColor})};return I(async()=>{g({})}),(o,r)=>{const t=E,C=_;return S(),k("div",null,[B(o.$slots,"title"),n(t,{type:"info",closable:"",style:{"max-width":"fit-content","padding-right":"2em"}},{default:V(()=>[D(M(l(s)("setting.personalized.resetHelp")),1)]),_:1}),A("div",G,[n(C,{onRegister:l(u),onSubmit:h},null,8,["onRegister"])])])}}});export{O as _};