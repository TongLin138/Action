import{G as n,w as c,u as p,c0 as i,a6 as u,aH as m}from"./vendor-339b2486.js";import{w as _}from"./index-b98e63e9.js";const y=n({__name:"index",setup(f){const{currentRoute:o,replace:a}=c(),e=_(),{query:s}=p(o),r=e.getPath,t=Array.isArray(r)?r.join("/"):r;return e.getRedirentType==="name"?a({name:t,query:s,params:e.getParams}):a({path:t.startsWith("/")?t:`/${t}`,query:s}),i(()=>{e.$reset()}),(d,h)=>(u(),m("div"))}});export{y as default};