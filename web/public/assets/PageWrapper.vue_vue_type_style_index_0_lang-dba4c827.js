import{a6 as r,as as c,aG as h,G as N,w as D,h as u,T as J,bJ as K,bK as W,ac as d,a8 as a,aq as O,av as k,u as t,aL as U,aD as b,M as l,ar as Z,aK as Q,bL as X,aJ as I,am as M,bM as Y,o as z,a7 as x,at as tt,aC as L,au as et,a9 as ot,aa as nt,aU as at,aB as st,aw as rt,bN as lt}from"./vendor-a7094419.js";import{_ as ct}from"./sharp-arrow-back-ios-13cc3b11.js";import{q as V,r as it,t as $}from"./index-c5daf99f.js";import{u as H}from"./useDesign-01a81f9b.js";import{b as ut,u as dt,a as pt}from"./useAppInject-582724ea.js";const gt={style:{display:"inline-block"},viewBox:"0 0 24 24",width:"1em",height:"1em"},_t=h("path",{fill:"currentColor",d:"M9.125 21.1L.7 12.7q-.15-.15-.213-.325T.425 12q0-.2.063-.375T.7 11.3l8.425-8.425q.35-.35.875-.35t.9.375q.375.375.375.875t-.375.875L3.55 12l7.35 7.35q.35.35.35.863t-.375.887q-.375.375-.875.375t-.875-.375Z"},null,-1),mt=[_t];function ft(e,s){return r(),c("svg",gt,mt)}const yt={name:"material-symbols-arrow-back-ios-rounded",render:ft},bt={class:"overflow-hidden fixed bottom-0 left-0 w-full z-1000"},ht={key:0,class:"flex-ac py-2"},kt=N({__name:"PageFooter",props:{isTitleBottomBack:{type:Boolean}},setup(e){const{prefixCls:s}=H("page-footer"),{getIsDarkMode:p}=V(),{getEnableTransition:S}=it(),g=D(),{headerColor:_,footerBorderColor:v}=$("Layout"),{footerColor:C,footerBorderColor:T}=$("Layout",!0),w=u(()=>{const o=p.value;return{color:o?C:_,backdropColor:J(o?C:_).setAlpha(.25).toRgbString(),borderColor:o?T:v}});K(()=>{const o="page-footer",{color:i,backdropColor:m,borderColor:f}=w.value;return{[`${o}-color`]:i,[`${o}-backdrop-color`]:m,[`${o}-border-color`]:f}});const{getPageTranstionState:F,getPageTranstionName:P}=ut(),B=W(async()=>{if(!t(S)||!t(P))return await X(100),!0;if(t(F)!=="running")return!0});return(o,i)=>{const m=yt,f=I,n=M;return r(),c("div",bt,[d(Q,{name:"page-footer-fade",appear:""},{default:a(()=>[O(h("div",{class:k([t(s)])},[h("div",{class:k(`${t(s)}__left`)},[e.isTitleBottomBack?(r(),c("div",ht,[d(n,{strong:"",quaternary:"",onClick:i[0]||(i[0]=y=>t(g).go(-1))},{icon:a(()=>[d(f,{size:14,class:"mb-2px"},{default:a(()=>[d(m)]),_:1})]),default:a(()=>[U(" 返回 ")]),_:1})])):b("",!0),l(o.$slots,"left")],2),l(o.$slots,"default"),h("div",{class:k(`${t(s)}__right`)},[l(o.$slots,"right")],2)],2),[[Z,t(B)]])]),_:3})])}}});const vt={key:0},Ct={key:1,class:"font-bold text-xl"},Ft=N({__name:"PageWrapper",props:{title:null,isTitleBack:{type:Boolean},isTitleBottomBack:{type:Boolean},ghost:{type:Boolean},content:null,contentStyle:null,contentBackground:{type:Boolean},contentClass:null,contentFull:{type:Boolean},noHeader:{type:Boolean}},setup(e){const s=e,p=Y(),S=D(),{prefixCls:g}=H("page-wrapper"),{getIsDarkMode:_}=V(),{getIsMobile:v}=dt(),{headerColor:C,headerBorderColor:T}=$("Layout"),{headerColor:w,headerBorderColor:F}=$("Layout",!0),{height:P}=pt(),B=u(()=>p?.leftFooter||p?.rightFooter),o=u(()=>Object.keys(z(p,"default","leftFooter","rightFooter","headerContent"))),i=u(()=>({padding:"10px",transition:"background-color var(--app-transition-duration) var(--app-bezier), border-color var(--app-transition-duration) var(--app-bezier)",borderBottom:`1px solid ${_.value?F:T}`,...s.ghost?{}:{backgroundColor:_.value?w:C}})),m=u(()=>({height:s.contentFull?`${t(P)+(v.value?20:0)+(s.noHeader?50:0)-70-(B.value?69:0)}px`:void 0,margin:v.value?"0":"10px",...s.contentStyle})),f=u(()=>{const{contentBackground:n,contentClass:y}=s;return[`${g}-content`,y,{[`${g}-content-bg`]:n}]});return(n,y)=>{const R=ct,j=I,A=M,E=lt;return r(),c("div",{class:k([t(g),n.$attrs.class??{}])},[e.content||n.$slots.headerContent||e.title||t(o).length?(r(),x(E,st({key:0},t(z)(n.$attrs,"class"),{style:t(i)}),tt({title:a(()=>[e.title?(r(),c(at,{key:0},[e.isTitleBack?(r(),x(A,{key:0,text:"",onClick:y[0]||(y[0]=q=>t(S).go(-1))},{icon:a(()=>[d(j,{size:19,class:"mr-6"},{default:a(()=>[d(R)]),_:1})]),_:1})):b("",!0),e.title?(r(),c("span",Ct,L(e.title),1)):b("",!0)],64)):l(n.$slots,"title",{key:1})]),_:2},[e.content||n.$slots.headerContent?{name:"default",fn:a(()=>[e.content?(r(),c("div",vt,L(e.content),1)):l(n.$slots,"headerContent",{key:1})]),key:"0"}:void 0,et(t(o),q=>({name:q,fn:a(G=>[l(n.$slots,q,ot(nt(G||{})))])}))]),1040,["style"])):b("",!0),h("div",{ref:"contentRef",class:k(["overflow-hidden",t(f)]),style:rt(t(m))},[l(n.$slots,"default")],6),t(B)?(r(),x(kt,{key:1,"is-title-bottom-back":e.isTitleBottomBack},{left:a(()=>[l(n.$slots,"leftFooter")]),right:a(()=>[l(n.$slots,"rightFooter")]),_:3},8,["is-title-bottom-back"])):b("",!0)],2)}}});export{Ft as _};
