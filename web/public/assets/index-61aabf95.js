import{G as n,w as c,u as p,bT as i,a6 as u,as as m}from"./vendor-c47b8ac0.js";import{t as _}from"./index-f8002877.js";const y=n({__name:"index",setup(f){const{currentRoute:o,replace:a}=c(),e=_(),{query:s}=p(o),r=e.getPath,t=Array.isArray(r)?r.join("/"):r;return e.getRedirentType==="name"?a({name:t,query:s,params:e.getParams}):a({path:t.startsWith("/")?t:`/${t}`,query:s}),i(()=>{e.$reset()}),(d,h)=>(u(),m("div"))}});export{y as default};