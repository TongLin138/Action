import{I as n,y as c,u as p,bV as i,a7 as u,aK as m}from"./vendor-CVUNLYN4.js";import{o as _}from"./index-BW0Kz9QR.js";const R=n({__name:"index",setup(f){const{currentRoute:s,replace:a}=c(),e=_(),{query:o}=p(s),r=e.getPath,t=Array.isArray(r)?r.join("/"):r;return e.getRedirentType==="name"?a({name:t,query:o,params:e.getParams}):a({path:t.startsWith("/")?t:`/${t}`,query:o}),i(()=>{e.$reset()}),(d,h)=>(u(),m("div"))}});export{R as default};
