import{G as I,x as i,h as P,al as s,aB as f,aC as v,a6 as d,a7 as h,a8 as u,as as b,a9 as _,aI as B,au as D,u as o,aY as $,aD as C,bT as L,bU as N,ax as V}from"./vendor-tP7MJkVm.js";import{_ as R}from"./PageWrapper.vue_vue_type_style_index_0_lang-_BQo_egP.js";import{q as W,_ as z}from"./index-YWZYq8iG.js";import{u as M}from"./useTransition-qMbJRxJj.js";import g from"./labelIcon-NOvFHU6s.js";import"./sharp-arrow-back-ios-o7qdCfpO.js";import"./useDesign-7GyM2Hwu.js";import"./useAppInject-BuU8lio7.js";const S={class:"terminal-page",style:{height:"100%",width:"100%"}},H=["src"],U=I({__name:"index",setup(q){const m=i("fade-slide");M(m);const y=P(()=>W()),p=i(),c=i(1),l=i("1"),t=i([{value:"1",label:()=>s(v,{style:"gap: 4px"},{default:()=>[s(f,{size:20},{default:()=>s(g)}),"1"]}),removable:!1}]),w=()=>{t.value.length===c.value?c.value+=1:c.value=t.value.length+1;const a=parseInt(t.value[t.value.length-1].value)+1;t.value.push({value:`${a}`,label:()=>s(v,{style:"gap: 4px"},{default:()=>[s(f,{size:20},{default:()=>s(g)}),`${a}`]}),removable:!0}),l.value=`${a}`},k=({value:a,index:e})=>{if(e<0)return!1;t.value.splice(e,1),t.value.length!==0&&l.value===a&&(l.value=t.value[Math.max(e-1,0)].value)},x=a=>{const e=p.value[a-1].contentWindow;T(e),E(e)},T=a=>{const e=a.document,n=e.createElement("style");n.id="stylePatch",n.innerHTML=`
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
`,e.getElementById("stylePatch")||e.head.appendChild(n)},E=a=>{const e=a.document,n=e.createElement("script");n.id="scriptPatch",n.innerHTML=`
  setTimeout(() => {
    const myEvent = new Event('resize')
    window.dispatchEvent(myEvent)
  }, 2000)
`,e.getElementById("scriptPatch")||e.body.appendChild(n)};return(a,e)=>{const n=R;return d(),h(n,{ref:"pageWrapper","content-full":!0,"no-header":!0},{default:u(()=>[b("div",S,[_(o(L),{modelValue:o(l),"onUpdate:modelValue":e[1]||(e[1]=r=>C(l)?l.value=r:null),style:{height:"100%",width:"100%"},addable:!0,onAdd:w,onRemove:k},{default:u(()=>[(d(!0),B($,null,D(o(t),r=>(d(),h(o(N),{key:r.value,style:{height:"100%",width:"100%",padding:"0"},value:r.value,label:r.label,removable:r.removable,"destroy-on-hide":!1},{default:u(()=>[_(V,{name:o(m),mode:"out-in",appear:""},{default:u(()=>[b("iframe",{ref_for:!0,ref_key:"frameRef",ref:p,src:`/api/shell?token=${o(y)}`,style:{height:"100%",width:"100%"},onLoad:e[0]||(e[0]=A=>x(o(c)))},null,40,H)]),_:1},8,["name"])]),_:2},1032,["value","label","removable"]))),128))]),_:1},8,["modelValue"])])]),_:1},512)}}}),X=z(U,[["__scopeId","data-v-7ff1e59e"]]);export{X as default};
