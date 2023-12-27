import{_ as B}from"./PageWrapper.vue_vue_type_style_index_0_lang-dycZnHT_.js";import{a7 as u,aJ as h,at as m,H as N,y as c,h as V,a8 as f,a9 as l,aa as i,av as C,u as s,aZ as D,aE as L,bY as M,aC as H,aI as R,aO as S,ay as W,aN as z,c3 as j}from"./vendor--53G7TFY.js";import{u as A}from"./useTransition-4NA9ntj9.js";import{a as F,r as J,d as O}from"./index-BeP8DsMB.js";import"./sharp-arrow-back-ios-8mKfxEIv.js";import"./useDesign-WRqooCBp.js";import"./useAppInject-4CezJXac.js";const U={style:{display:"inline-block"},viewBox:"0 0 24 24",width:"1em",height:"1em"},Y=m("path",{fill:"none",stroke:"currentColor","stroke-linecap":"round","stroke-linejoin":"round","stroke-width":"2",d:"M12.5 16H4a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1h16a1 1 0 0 1 1 1v8M7 20h4m-2-4v4m11 1l2-2l-2-2m-3 0l-2 2l2 2"},null,-1),Z=[Y];function q(b,p){return u(),h("svg",U,[...Z])}const G={name:"tabler-device-desktop-code",render:q},K={class:"terminal-page",style:{height:"100%",width:"100%"}},Q=["src"],X=N({__name:"index",setup(b){const{t:p}=F(),_=c("fade-slide");A(_);const g=V(()=>J()),v=c(),d=c(1),r=c("1"),a=c([{value:"1",label:"1",removable:!1}]),y=()=>{a.value.length===d.value?d.value+=1:d.value=a.value.length+1;const t=parseInt(a.value[a.value.length-1].value)+1;a.value.push({value:`${t}`,label:`${t}`,removable:!0}),r.value=`${t}`},k=({value:t,index:e})=>{if(e<0)return!1;a.value.splice(e,1),a.value.length!==0&&r.value===t&&(r.value=a.value[Math.max(e-1,0)].value)},w=t=>{const e=v.value[t-1].contentWindow;x(e),T(e)},x=t=>{const e=t.document,n=e.createElement("style");n.id="stylePatch",n.innerHTML=`
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
`,e.getElementById("stylePatch")||e.head.appendChild(n)},T=t=>{const e=t.document,n=e.createElement("script");n.id="scriptPatch",n.innerHTML=`
  setTimeout(() => {
    const myEvent = new Event('resize')
    window.dispatchEvent(myEvent)
  }, 2000)
`,e.getElementById("scriptPatch")||e.body.appendChild(n)};return(t,e)=>{const n=G,E=z,$=j,I=M,P=B;return u(),f(P,{ref:"pageWrapper","content-full":"","no-header":""},{default:l(()=>[m("div",K,[i(I,{modelValue:s(r),"onUpdate:modelValue":e[1]||(e[1]=o=>L(r)?r.value=o:null),style:{height:"100%",width:"100%"},addable:!0,onAdd:y,onRemove:k},{default:l(()=>[(u(!0),h(D,null,C(s(a),o=>(u(),f($,{key:o.value,style:{height:"100%",width:"100%",padding:"0"},value:o.value,label:o.label,removable:o.removable,"destroy-on-hide":!1},{label:l(()=>[i(s(H),{style:{gap:"4px"}},{default:l(()=>[i(E,{size:16},{default:l(()=>[i(n,{style:{"vertical-align":"-0.2em"}})]),_:1}),S(" "+R(`${s(p)("page.terminal.tabLabel")} ${o.label}`),1)]),_:2},1024)]),default:l(()=>[i(W,{name:s(_),mode:"out-in",appear:""},{default:l(()=>[m("iframe",{ref_for:!0,ref_key:"frameRef",ref:v,src:`/api/shell?token=${s(g)}`,style:{height:"100%",width:"100%"},onLoad:e[0]||(e[0]=ee=>w(s(d)))},null,40,Q)]),_:1},8,["name"])]),_:2},1032,["value","label","removable"]))),128))]),_:1},8,["modelValue"])])]),_:1},512)}}}),ce=O(X,[["__scopeId","data-v-58211b95"]]);export{ce as default};
