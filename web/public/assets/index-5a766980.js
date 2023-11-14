import{G as P,x as i,h as B,al as s,aB as f,aC as v,a6 as d,a7 as h,a8 as u,as as _,a9 as b,aH as I,au as D,u as o,aV as V,aD as $,ax as C}from"./vendor-339b2486.js";import{_ as L}from"./PageWrapper.vue_vue_type_style_index_0_lang-ebcdd68c.js";import{q as N,_ as R}from"./index-b98e63e9.js";import{u as W}from"./useTransition-0172c80f.js";import g from"./labelIcon-8f24400f.js";import{T as z,a as H}from"./index-03bc6ce5.js";import"./sharp-arrow-back-ios-59e3289b.js";import"./useDesign-d1f0a28d.js";import"./useAppInject-25d4ad8f.js";import"./helper-121dcefa.js";const M={class:"terminal-page",style:{height:"100%",width:"100%"}},S=["src"],q=P({__name:"index",setup(A){const m=i("fade-slide");W(m);const y=B(()=>N()),p=i(),c=i(1),l=i("1"),t=i([{value:"1",label:()=>s(v,{style:"gap: 4px"},{default:()=>[s(f,{size:20},{default:()=>s(g)}),"1"]}),removable:!1}]),w=()=>{t.value.length===c.value?c.value+=1:c.value=t.value.length+1;const a=parseInt(t.value[t.value.length-1].value)+1;t.value.push({value:`${a}`,label:()=>s(v,{style:"gap: 4px"},{default:()=>[s(f,{size:20},{default:()=>s(g)}),`${a}`]}),removable:!0}),l.value=`${a}`},x=({value:a,index:e})=>{if(e<0)return!1;t.value.splice(e,1),t.value.length!==0&&l.value===a&&(l.value=t.value[Math.max(e-1,0)].value)},k=a=>{const e=p.value[a-1].contentWindow;T(e),E(e)},T=a=>{const e=a.document,n=e.createElement("style");n.id="stylePatch",n.innerHTML=`
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
`,e.getElementById("scriptPatch")||e.body.appendChild(n)};return(a,e)=>{const n=L;return d(),h(n,{ref:"pageWrapper","content-full":!0,"no-header":!0},{default:u(()=>[_("div",M,[b(o(z),{modelValue:o(l),"onUpdate:modelValue":e[1]||(e[1]=r=>$(l)?l.value=r:null),style:{height:"100%",width:"100%"},addable:!0,onAdd:w,onRemove:x},{default:u(()=>[(d(!0),I(V,null,D(o(t),r=>(d(),h(o(H),{key:r.value,style:{height:"100%",width:"100%",padding:"0"},value:r.value,label:r.label,removable:r.removable,"destroy-on-hide":!1},{default:u(()=>[b(C,{name:o(m),mode:"out-in",appear:""},{default:u(()=>[_("iframe",{ref_for:!0,ref_key:"frameRef",ref:p,src:`/api/shell?token=${o(y)}`,style:{height:"100%",width:"100%"},onLoad:e[0]||(e[0]=F=>k(o(c)))},null,40,S)]),_:1},8,["name"])]),_:2},1032,["value","label","removable"]))),128))]),_:1},8,["modelValue"])])]),_:1},512)}}});const ee=R(q,[["__scopeId","data-v-7ff1e59e"]]);export{ee as default};
