import{a6 as s,aH as _,bU as p,a7 as c,a8 as i,a9 as l,aB as r,as as h}from"./vendor-339b2486.js";import{_ as d}from"./index-b98e63e9.js";import{_ as b}from"./trash-ddde501b.js";function F(t,o,n,e){const m=typeof e<"u"?[e,t]:[t],u=new Blob(m,{type:n||"application/octet-stream"}),f=window.URL.createObjectURL(u),a=document.createElement("a");a.style.display="none",a.href=f,a.setAttribute("download",o),typeof a.download>"u"&&a.setAttribute("target","_blank"),document.body.appendChild(a),a.click(),document.body.removeChild(a),window.URL.revokeObjectURL(f)}const k={style:{display:"inline-block"},viewBox:"0 0 24 24",width:"1em",height:"1em"},w=p('<g fill="none" stroke="currentColor" stroke-linecap="round" stroke-width="2"><path stroke-dasharray="2 4" stroke-dashoffset="6" d="M12 3C16.9706 3 21 7.02944 21 12C21 16.9706 16.9706 21 12 21"><animate attributeName="stroke-dashoffset" dur="0.6s" repeatCount="indefinite" values="6;0"></animate></path><path stroke-dasharray="30" stroke-dashoffset="30" d="M12 21C7.02944 21 3 16.9706 3 12C3 7.02944 7.02944 3 12 3"><animate fill="freeze" attributeName="stroke-dashoffset" begin="0.1s" dur="0.3s" values="30;0"></animate></path><path stroke-dasharray="10" stroke-dashoffset="10" d="M12 8v7.5"><animate fill="freeze" attributeName="stroke-dashoffset" begin="0.5s" dur="0.2s" values="10;0"></animate></path><path stroke-dasharray="6" stroke-dashoffset="6" d="M12 15.5l3.5 -3.5M12 15.5l-3.5 -3.5"><animate fill="freeze" attributeName="stroke-dashoffset" begin="0.7s" dur="0.2s" values="6;0"></animate></path></g>',1),g=[w];function v(t,o){return s(),_("svg",k,[...g])}const y={name:"line-md-downloading-loop",render:v},$={};function x(t,o){const n=y,e=r;return s(),c(e,null,{default:i(()=>[l(n,{style:{"vertical-align":"baseline"}})]),_:1})}const G=d($,[["render",x]]),C={style:{display:"inline-block"},viewBox:"0 0 24 24",width:"1em",height:"1em"},N=h("path",{fill:"currentColor",d:"m14 2l6 6v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8m4 18V9h-5V4H6v16h12m-6-1l-4-4h2.5v-3h3v3H16l-4 4Z"},null,-1),B=[N];function I(t,o){return s(),_("svg",C,[...B])}const V={name:"mdi-file-download-outline",render:I},H={};function L(t,o){const n=V,e=r;return s(),c(e,null,{default:i(()=>[l(n,{style:{"vertical-align":"baseline"}})]),_:1})}const J=d(H,[["render",L]]),M={style:{display:"inline-block"},viewBox:"0 0 24 24",width:"1em",height:"1em"},U=h("path",{fill:"currentColor",d:"M20 18H4V8h16m0-2h-8l-2-2H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2m-6 3h2v4h3l-4 4l-4-4h3Z"},null,-1),R=[U];function D(t,o){return s(),_("svg",M,[...R])}const z={name:"mdi-folder-download-outline",render:D},j={};function A(t,o){const n=z,e=r;return s(),c(e,null,{default:i(()=>[l(n,{style:{"vertical-align":"baseline"}})]),_:1})}const K=d(j,[["render",A]]),E={};function O(t,o){const n=b,e=r;return s(),c(e,null,{default:i(()=>[l(n,{style:{"vertical-align":"baseline"}})]),_:1})}const P=d(E,[["render",O]]);export{K as a,G as b,F as c,P as d,J as f};