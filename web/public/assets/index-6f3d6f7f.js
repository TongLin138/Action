import{_ as T}from"./PageWrapper.vue_vue_type_style_index_0_lang-bfc5bf26.js";import{o as E,_ as B}from"./index-f8002877.js";import{G as C,h as c,x as d,a6 as i,a7 as _,a8 as u,aG as m,ac as L,u as s,aE as N,as as P,aU as R,au as W,bN as I,bl as M}from"./vendor-c47b8ac0.js";import"./sharp-arrow-back-ios-73882074.js";import"./useDesign-53b53602.js";import"./useAppInject-da0b3031.js";const V={class:"terminal-page",style:{height:"100%",width:"100%"}},$=["src","onLoad"],z=C({__name:"index",setup(A){const f=c(()=>E()),p=d(),n=d(1),o=d([1]),h=t=>{const e=p.value[t].contentWindow;b(e),setTimeout(()=>{const a=new Event("resize");e.dispatchEvent(a)},800)},b=t=>{const e=t.document,a=e.createElement("style");a.id="stylePatch",a.innerHTML=`
#terminal-container .xterm-viewport {
  overflow-y: auto;
}

/* 整个滚动条 */
::-webkit-scrollbar {
  width: 10px;
  background-color: transparent;
}

/* 滚动条上的滚动滑块 */
::-webkit-scrollbar-thumb {
  background-color: #999999;
  border-radius: 5px;
}

/* 滚动条轨道 */
::-webkit-scrollbar-track {
  background-color: transparent;
}
`,e.getElementById("stylePatch")||e.head.appendChild(a)},v=c(()=>({disabled:o.value.length>=10})),g=c(()=>o.value.length>1),y=()=>{const t=Math.max(...o.value)+1;o.value.push(t),n.value=t},w=t=>{const{value:e}=o,a=e.findIndex(r=>t===r);e.splice(a,1),n.value===t&&(n.value=e[Math.min(a,e.length-1)])};return(t,e)=>{const a=I,r=M,x=T;return i(),_(x,{ref:"pageWrapper","content-full":!0,"no-header":!0},{default:u(()=>[m("div",V,[L(r,{value:s(n),"onUpdate:value":e[0]||(e[0]=l=>N(n)?n.value=l:null),type:"card",size:"small",addable:s(v),closable:s(g),"tab-style":"min-width: 60px",style:{height:"100%",width:"100%"},onClose:w,onAdd:y},{default:u(()=>[(i(!0),P(R,null,W(s(o),(l,k)=>(i(),_(a,{key:l,"display-directive":"show",name:l,style:{height:"100%",width:"100%",padding:"0"}},{default:u(()=>[m("iframe",{ref_for:!0,ref_key:"frameRef",ref:p,src:`/api/shell?token=${s(f)}`,style:{height:"100%",width:"100%"},onLoad:D=>h(k)},null,40,$)]),_:2},1032,["name"]))),128))]),_:1},8,["value","addable","closable"])])]),_:1},512)}}});const q=B(z,[["__scopeId","data-v-8cd4dff7"]]);export{q as default};