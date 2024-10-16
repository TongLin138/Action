import{_ as G}from"./app-dbd1102e.js";import{aN as W,a6 as r,aG as u,al as b,G as I,h as d,bW as O,a9 as g,a8 as s,aj as U,ak as X,F as e,ao as y,aT as Y,aI as k,N as l,aq as Z,C as D,n as J,bX as K,bY as Q,aU as V,aA as j,bZ as tt,a7 as H,am as et,aH as P,an as ot,aS as nt,aF as at,o as x,ap as st,bd as rt,aa as lt,ab as it}from"./vendor-f4e37609.js";import{a as q,o as ct,p as $}from"./app-516cf0fd.js";import{b as dt,u as ut,a as pt}from"./app-34fc42c0.js";import{u as A}from"./app-e921add8.js";const gt={style:{display:"inline-block"},viewBox:"0 0 24 24",width:"1em",height:"1em"};function mt(o,n){return r(),u("svg",gt,n[0]||(n[0]=[b("path",{fill:"currentColor",d:"m3.55 12l7.35 7.35q.375.375.363.875t-.388.875t-.875.375t-.875-.375l-7.7-7.675q-.3-.3-.45-.675T.825 12t.15-.75t.45-.675l7.7-7.7q.375-.375.888-.363t.887.388t.375.875t-.375.875z"},null,-1)]))}const ft=W({name:"material-symbols-arrow-back-ios-rounded",render:mt}),kt={class:"overflow-hidden fixed bottom-0 left-0 w-full z-1000"},bt={key:0,class:"flex-ac py-2"},yt=I({__name:"PageFooter",props:{isTitleBottomBack:{type:Boolean}},setup(o){const{prefixCls:n}=A("page-footer"),{getIsDarkMode:p}=q(),{getEnableTransition:S}=ct(),m=D(),{headerColor:_,footerBorderColor:h}=$("Layout"),{footerColor:C,footerBorderColor:w}=$("Layout",!0),T=d(()=>{const a=p.value;return{color:a?C:_,backdropColor:J(a?C:_).setAlpha(.25).toRgbString(),borderColor:a?w:h}});K(()=>{const a="page-footer",{color:i,backdropColor:f,borderColor:t}=T.value;return{[`${a}-color`]:i,[`${a}-backdrop-color`]:f,[`${a}-border-color`]:t}});const{getPageTranstionState:v,getPageTranstionName:F}=dt(),B=O(async()=>{if(!e(S)||!e(F))return await Q(100),!0;if(e(v)!=="running")return!0});return(a,i)=>{const f=ft,t=V,c=j;return r(),u("div",kt,[g(Z,{name:"page-footer-fade",appear:""},{default:s(()=>[U(b("div",{class:y([e(n)])},[b("div",{class:y(`${e(n)}__left`)},[o.isTitleBottomBack?(r(),u("div",bt,[g(c,{strong:"",quaternary:"",onClick:i[0]||(i[0]=N=>e(m).go(-1))},{icon:s(()=>[g(t,{size:14,class:"mb-2px"},{default:s(()=>[g(f)]),_:1})]),default:s(()=>[i[1]||(i[1]=Y(" 返回 "))]),_:1})])):k("",!0),l(a.$slots,"left")],2),l(a.$slots,"default"),b("div",{class:y(`${e(n)}__right`)},[l(a.$slots,"right")],2)],2),[[X,e(B)]])]),_:3})])}}}),_t={key:0},ht={key:1,class:"font-bold text-xl"},wt=I({__name:"PageWrapper",props:{title:null,isTitleBack:{type:Boolean},isTitleBottomBack:{type:Boolean},ghost:{type:Boolean},content:null,contentStyle:null,contentBackground:{type:Boolean},contentClass:null,contentFull:{type:Boolean},noHeader:{type:Boolean},noHeaderBordered:{type:Boolean}},setup(o){const n=o,p=tt(),S=D(),{prefixCls:m}=A("page-wrapper"),{getIsDarkMode:_}=q(),{getIsMobile:h}=ut(),{headerColor:C}=$("Layout"),{headerColor:w}=$("Layout",!0),{height:T}=pt(),v=d(()=>p?.leftFooter||p?.rightFooter),F=d(()=>p?.headerContent),B=d(()=>Object.keys(x(p,"default","leftFooter","rightFooter","headerContent"))),a=d(()=>({padding:"10px",transition:"background-color var(--app-transition-duration) var(--app-bezier), border-color var(--app-transition-duration) var(--app-bezier)",borderBottom:`1px solid ${n.noHeaderBordered?"transparent":"var(--app-border-color)"}`,...n.ghost?{}:{backgroundColor:_.value?w:C}})),i=d(()=>{const t=h.value?0:18,c=e(T)-(50+2*t)+(n.noHeader?50:0)-(v.value?69:0)-(F.value?47:0);return{height:n.contentFull?`${c}px`:void 0,margin:h.value?"0":`${t}px ${t-2}px`,...n.contentStyle}}),f=d(()=>{const{contentBackground:t,contentClass:c}=n;return[`${m}-content`,c,{[`${m}-content-bg`]:t}]});return(t,c)=>{const N=G,L=V,R=j,M=rt;return r(),u("div",{class:y([e(m),t.$attrs.class??{}])},[o.content||t.$slots.headerContent||o.title||e(B).length?(r(),H(M,at({key:0},e(x)(t.$attrs,"class"),{style:e(a)}),et({title:s(()=>[o.title?(r(),u(nt,{key:0},[o.isTitleBack?(r(),H(R,{key:0,text:"",onClick:c[0]||(c[0]=z=>e(S).go(-1))},{icon:s(()=>[g(L,{size:19,class:"mr-6"},{default:s(()=>[g(N)]),_:1})]),_:1})):k("",!0),o.title?(r(),u("span",ht,P(o.title),1)):k("",!0)],64)):l(t.$slots,"title",{key:1})]),_:2},[o.content||t.$slots.headerContent?{name:"default",fn:s(()=>[o.content?(r(),u("div",_t,P(o.content),1)):l(t.$slots,"headerContent",{key:1})]),key:"0"}:void 0,ot(e(B),z=>({name:z,fn:s(E=>[l(t.$slots,z,lt(it(E||{})))])}))]),1040,["style"])):k("",!0),b("div",{class:y(["overflow-hidden",e(f)]),style:st(e(i))},[l(t.$slots,"default")],6),e(v)?(r(),H(yt,{key:1,"is-title-bottom-back":o.isTitleBottomBack},{left:s(()=>[l(t.$slots,"leftFooter")]),right:s(()=>[l(t.$slots,"rightFooter")]),_:3},8,["is-title-bottom-back"])):k("",!0)],2)}}});export{wt as _};
