import{d as P,r as i,j as I,bm as N,h as s,o as d,c as f,w as u,v,a as h,p as B,ab as D,e as n,ac as $,i as L,D as V,_ as C}from"./index-797c0a85.js";import{_ as R}from"./PageWrapper.vue_vue_type_style_index_0_lang-f0d6bddb.js";import{u as W}from"./useTransition-5809f8e4.js";import _ from"./labelIcon-e8ba569a.js";import{T as z,a as M}from"./index-a4ce3dd6.js";import{N as b}from"./Icon-abc31adc.js";import{N as g}from"./Space-3cb079f3.js";import"./monacoEditor-d72532b2.js";import"./sharp-arrow-back-ios-ca1144ee.js";import"./useDesign-a03ef768.js";import"./useAppInject-e4ee4e96.js";import"./helper-b8eb37e9.js";const S={class:"terminal-page",style:{height:"100%",width:"100%"}},H=["src"],j=P({__name:"index",setup(A){const m=i("fade-slide");W(m);const y=I(()=>N()),p=i(),c=i(1),l=i("1"),a=i([{value:"1",label:()=>s(g,{style:"gap: 4px"},{default:()=>[s(b,{size:20},{default:()=>s(_)}),"1"]}),removable:!1}]),w=()=>{a.value.length===c.value?c.value+=1:c.value=a.value.length+1;const t=parseInt(a.value[a.value.length-1].value)+1;a.value.push({value:`${t}`,label:()=>s(g,{style:"gap: 4px"},{default:()=>[s(b,{size:20},{default:()=>s(_)}),`${t}`]}),removable:!0}),l.value=`${t}`},k=({value:t,index:e})=>{if(e<0)return!1;a.value.splice(e,1),a.value.length!==0&&l.value===t&&(l.value=a.value[Math.max(e-1,0)].value)},x=t=>{const e=p.value[t-1].contentWindow;T(e),E(e)},T=t=>{const e=t.document,o=e.createElement("style");o.id="stylePatch",o.innerHTML=`
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
`,e.getElementById("stylePatch")||e.head.appendChild(o)},E=t=>{const e=t.document,o=e.createElement("script");o.id="scriptPatch",o.innerHTML=`
  setTimeout(() => {
    const myEvent = new Event('resize')
    window.dispatchEvent(myEvent)
  }, 2000)
`,e.getElementById("scriptPatch")||e.body.appendChild(o)};return(t,e)=>{const o=R;return d(),f(o,{ref:"pageWrapper","content-full":!0,"no-header":!0},{default:u(()=>[v("div",S,[h(n(z),{modelValue:n(l),"onUpdate:modelValue":e[1]||(e[1]=r=>L(l)?l.value=r:null),style:{height:"100%",width:"100%"},addable:!0,onAdd:w,onRemove:k},{default:u(()=>[(d(!0),B($,null,D(n(a),r=>(d(),f(n(M),{key:r.value,style:{height:"100%",width:"100%",padding:"0"},value:r.value,label:r.label,removable:r.removable,"destroy-on-hide":!1},{default:u(()=>[h(V,{name:n(m),mode:"out-in",appear:""},{default:u(()=>[v("iframe",{ref_for:!0,ref_key:"frameRef",ref:p,src:`/api/shell?token=${n(y)}`,style:{height:"100%",width:"100%"},onLoad:e[0]||(e[0]=F=>x(n(c)))},null,40,H)]),_:1},8,["name"])]),_:2},1032,["value","label","removable"]))),128))]),_:1},8,["modelValue"])])]),_:1},512)}}});const ae=C(j,[["__scopeId","data-v-7ff1e59e"]]);export{ae as default};
