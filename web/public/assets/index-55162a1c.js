import{a6 as g,as as Z,aG as w,G as ue,x as s,C as A,aI as de,a7 as k,at as pe,u as e,a8 as t,ac as o,aE as E,aJ as m,aK as _e,aC as P,aD as q,aL as fe,al as d,aM as me,aN as ge,aO as he,aP as ve,am as ye,aQ as be,aR as ke,aH as we}from"./vendor-b0543d82.js";import{_ as xe}from"./PageWrapper.vue_vue_type_style_index_0_lang-6aa3ce87.js";import{b as Ce,c as Se,L as Te}from"./index-7ca99342.js";import{s as Ne,g as J,f as K,a as $e,_ as ze,b as Ee,c as Pe,d as Ve,e as Ie}from"./folderOpen-f78fffb3.js";import{_ as Be,a as Fe,f as Me}from"./index-db543441.js";import{u as Oe}from"./useAppInject-556e31df.js";import{u as De}from"./useTransition-d423da33.js";import{F as Q}from"./fileTreeEnum-8c192873.js";import{f as Le}from"./folderDisable-3564ff46.js";import"./sharp-arrow-back-ios-357f60fd.js";import"./useDesign-94a763ab.js";import"./propTypes-8a448afd.js";const He={style:{display:"inline-block"},viewBox:"0 0 2048 2048",width:"1em",height:"1em"},We=w("path",{fill:"currentColor",d:"M1792 0v2048H256V0h1536zM384 128v384h1280V128H384zm1280 1408H384v384h1280v-384zm0-256V640H384v640h1280z"},null,-1),je=[We];function Ge(D,f){return g(),Z("svg",He,je)}const Re={name:"fluent-mdl2-diff-inline",render:Ge},Ue={style:{display:"inline-block"},viewBox:"0 0 24 24",width:"1em",height:"1em"},Ae=w("path",{fill:"currentColor",d:"M13 23h-2V1h2v22m-4-4H5V5h4V3H5c-1.11 0-2 .89-2 2v14a2 2 0 0 0 2 2h4v-2M19 7v2h2V7h-2m0-2h2a2 2 0 0 0-2-2v2m2 10h-2v2h2v-2m-2-4v2h2v-2h-2m-2-8h-2v2h2V3m2 18c1.11 0 2-.89 2-2h-2v2m-2-2h-2v2h2v-2Z"},null,-1),qe=[Ae];function Je(D,f){return g(),Z("svg",Ue,qe)}const Ke={name:"mdi-select-compare",render:Je},cn=ue({__name:"index",setup(D){const{getIsMobile:f}=Oe(),{t:r}=Ce(),{message:L}=Se(),H=s("fade-slide");De(H);const V=s(),I=s([]),B=s([]),W=s({}),v=s(""),y=s(""),x=s(""),C=s(!f.value),S=s(f.value?"on":"off"),u=s(""),p=s(""),F=s(!1),M=s(!1),h=s(!1),T=async n=>{switch(n){case"showEditorShortcutsInfo":V.value.showShortCuts=!0;break;case"wordWrap":S.value=S.value==="on"?"off":"on";break;case"renderSideBySide":C.value=!C.value;break;case"save":F.value=!0;const a=e(V).getValue();try{await Ne({content:a,path:u.value}),L.success(r("editor.main.savedSuccess"))}finally{F.value=!1}break}},X=async()=>{h.value=!0;const n=await J({type:Q.CONFIG}),a=await J({type:Q.SAMPLE});I.value=j(n),B.value=j(a),h.value=!1},j=n=>{const a=l=>{l.length&&l.forEach(i=>{if(i.type===0)Object.assign(i,{key:i.path,label:i.title,disabled:!0,prefix:()=>d(m,null,{default:()=>d(K)})}),a(i.children),i.children.length||(Object.assign(i,{children:null,disabled:!0}),i.prefix=()=>d(m,null,{default:()=>d(Le)}));else{const _=i.name;if(_){const $=_.substring(_.lastIndexOf(".")+1),b=Me[$]||{};Object.assign(i,{key:i.path,label:_,language:b.language||"plaintext",disabled:b.disabled||!1,prefix:()=>d(m,null,{default:()=>d(b.icon||Ve)})})}}})};return a(n),n},N=(n,a,l)=>{if(l.node)switch(l.action){case"expand":l.node.prefix=()=>d(m,null,{default:()=>d($e)});break;case"collapse":l.node.prefix=()=>d(m,null,{default:()=>d(K)});break}},Y=async(n,a)=>{M.value=!0;const l=await Ie({path:encodeURI(n)});if(M.value=!1,l)switch(a){case"config":v.value=l;break;case"sample":y.value=l;break}else{switch(a){case"config":v.value="";break;case"sample":y.value="";break}L.info(r("page.compareTool.fileContentIsEmptyMsg"))}},G=({option:n})=>({onClick(){!n.children&&!n.disabled&&(x.value=n.language,W.value=n,U(n,"config"))}}),R=({option:n})=>({onClick(){!n.children&&!n.disabled&&(x.value=n.language,W.value=n,U(n,"sample"))}});async function U(n,a){x.value=n.language,Y(n.key,a)}return A(u,n=>{n||(v.value="")}),A(p,n=>{n||(y.value="")}),de(async()=>{await X()}),(n,a)=>{const l=me,i=Ke,_=ge,$=he,b=ve,ee=Be,z=ye,O=be,ne=ze,ae=Re,te=Fe,oe=Ee,le=Pe,se=ke,ie=Te,re=we,ce=xe;return g(),k(ce,{ref:"pageWrapper","content-full":!0,title:e(r)("routes.main.page.compareTool")},pe({extra:t(()=>[e(u)&&e(p)?(g(),k(_e,{key:0,name:e(H),mode:"out-in",appear:""},{default:t(()=>[o(_,null,{default:t(()=>[o(_,{style:{gap:"0"}},{default:t(()=>[e(f)?q("",!0):(g(),k(O,{key:0,placement:"bottom",trigger:"hover",delay:500},{trigger:t(()=>[o(z,{strong:"",quaternary:"",size:"small",type:"tertiary",focusable:!1,onClick:a[4]||(a[4]=c=>T("showEditorShortcutsInfo"))},{default:t(()=>[o(ee)]),_:1})]),default:t(()=>[w("span",null,P(e(r)("editor.switch.shortcutsTips")),1)]),_:1})),o(O,{placement:"bottom",trigger:"hover",delay:500},{trigger:t(()=>[o(z,{strong:"",quaternary:"",type:e(S)==="on"?"primary":"tertiary",size:"small",focusable:!1,onClick:a[5]||(a[5]=c=>T("wordWrap"))},{default:t(()=>[o(ne)]),_:1},8,["type"])]),default:t(()=>[w("span",null,P(e(r)("editor.switch.wordWrapTips")),1)]),_:1}),o(O,{placement:"bottom",trigger:"hover",delay:500},{trigger:t(()=>[o(z,{strong:"",quaternary:"",type:e(C)?"tertiary":"primary",size:"small",focusable:!1,onClick:a[6]||(a[6]=c=>T("renderSideBySide"))},{default:t(()=>[o(ae)]),_:1},8,["type"])]),default:t(()=>[w("span",null,P(e(r)("editor.switch.inlineModeTips")),1)]),_:1})]),_:1}),o(z,{strong:"",type:"primary",size:"small",disabled:!e(u),loading:e(F),focusable:!1,onClick:a[7]||(a[7]=c=>T("save"))},{icon:t(()=>[o(te)]),default:t(()=>[fe(" "+P(e(r)("editor.main.saveButton")),1)]),_:1},8,["disabled","loading"])]),_:1})]),_:1},8,["name"])):q("",!0)]),default:t(()=>[o(re,{bordered:!e(f),style:{height:"100%","word-break":"unset"},"content-style":"padding: 0"},{default:t(()=>[e(v)||e(y)?(g(),k(oe,{key:0,ref_key:"editor",ref:V,value:e(v),"origin-value":e(y),"diff-mode":!0,language:e(x),"word-wrap":e(S),"render-side-by-side":e(C)},null,8,["value","origin-value","language","word-wrap","render-side-by-side"])):(g(),k(se,{key:1,class:"min-h-200px flex-jc-ac h-full",size:"huge",description:e(r)("common.selectFileEmptyDesc")},{icon:t(()=>[o(e(m),null,{default:t(()=>[o(le)]),_:1})]),_:1},8,["description"])),o(ie,{show:e(M)},null,8,["show"])]),_:1},8,["bordered"])]),_:2},[e(f)?{name:"headerContent",fn:t(()=>[o(b,{"x-gap":12,cols:2},{default:t(()=>[o($,null,{default:t(()=>[o(l,{value:e(p),"onUpdate:value":a[2]||(a[2]=c=>E(p)?p.value=c:null),size:"small",loading:e(h),"consistent-menu-width":!1,clearable:"",placeholder:e(r)("page.compareTool.selectSampleFilePlaceholder"),options:e(B),"node-props":R,"on-update:expanded-keys":N},null,8,["value","loading","placeholder","options"])]),_:1}),o($,null,{default:t(()=>[o(l,{value:e(u),"onUpdate:value":a[3]||(a[3]=c=>E(u)?u.value=c:null),size:"small",loading:e(h),"consistent-menu-width":!1,clearable:"",placeholder:e(r)("page.compareTool.selectConfigFilePlaceholder"),options:e(I),"node-props":G,"on-update:expanded-keys":N},null,8,["value","loading","placeholder","options"])]),_:1})]),_:1})]),key:"1"}:{name:"subtitle",fn:t(()=>[o(_,null,{default:t(()=>[o(l,{value:e(p),"onUpdate:value":a[0]||(a[0]=c=>E(p)?p.value=c:null),size:"small",style:{width:"200px"},loading:e(h),"consistent-menu-width":!1,clearable:"",placeholder:e(r)("page.compareTool.selectSampleFilePlaceholder"),options:e(B),"node-props":R,"on-update:expanded-keys":N},null,8,["value","loading","placeholder","options"]),o(e(m),{size:"24",depth:3},{default:t(()=>[o(i)]),_:1}),o(l,{value:e(u),"onUpdate:value":a[1]||(a[1]=c=>E(u)?u.value=c:null),size:"small",style:{width:"200px"},loading:e(h),"consistent-menu-width":!1,clearable:"",placeholder:e(r)("page.compareTool.selectConfigFilePlaceholder"),options:e(I),"node-props":G,"on-update:expanded-keys":N},null,8,["value","loading","placeholder","options"])]),_:1})]),key:"0"}]),1032,["title"])}}});export{cn as default};