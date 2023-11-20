var W=(e,t,a)=>new Promise((d,r)=>{var i=c=>{try{u(a.next(c))}catch(v){r(v)}},p=c=>{try{u(a.throw(c))}catch(v){r(v)}},u=c=>c.done?d(c.value):Promise.resolve(c.value).then(i,p);u((a=a.apply(e,t)).next())});import{d as E,r as R,j as z,A as J,an as X,J as A,h as o,R as f,c5 as te,P as m,fm as ne,aK as $,Q as w,aQ as ae,d9 as oe,dk as re,b1 as q,G as L,S as O,fn as ie,cE as le,B as se,aN as F,aO as de,I as H,bS as ce,D as ue,K as me,fo as fe,b3 as pe,b4 as ve,fp as he,V as be,F as ge,H as xe,dh as _e,fq as ye,ac as G,o as x,p as B,v as M,aa as we,c as P,w as h,ad as $e,ab as Q,a as C,n as Y,au as ke,t as N,E as V,a8 as ze,e as y,x as Ce,i as Re,q as K,bv as Se}from"./index-797c0a85.js";import{_ as Ne}from"./Avatar-c373b8f2.js";import{_ as Be}from"./text-116532e9.js";import{_ as Ee}from"./Ellipsis-348a6bfd.js";import{_ as Te}from"./Tag-274eae2a.js";import{_ as Pe}from"./Empty-aa248199.js";import{_ as je}from"./Scrollbar-cdc51570.js";import{u as Oe}from"./useDesign-a03ef768.js";import{g as De}from"./attribute-2ee9e579.js";import{_ as Ie,b as Me}from"./Tabs-63ecaee7.js";import{_ as Ve}from"./Tooltip-271e10cc.js";import{N as Ae}from"./Space-3cb079f3.js";import"./monacoEditor-d72532b2.js";import"./utils-e4b90de2.js";import"./use-locale-3967e664.js";import"./Add-843bb42e.js";import"./throttle-d0379a19.js";import"./on-fonts-ready-2684803e.js";import"./Icon-abc31adc.js";const U=E({name:"SlotMachineNumber",props:{clsPrefix:{type:String,required:!0},value:{type:[Number,String],required:!0},oldOriginalNumber:{type:Number,default:void 0},newOriginalNumber:{type:Number,default:void 0}},setup(e){const t=R(null),a=R(e.value),d=R(e.value),r=R("up"),i=R(!1),p=z(()=>i.value?`${e.clsPrefix}-base-slot-machine-current-number--${r.value}-scroll`:null),u=z(()=>i.value?`${e.clsPrefix}-base-slot-machine-old-number--${r.value}-scroll`:null);J(A(e,"value"),(n,l)=>{a.value=l,d.value=n,X(c)});function c(){const n=e.newOriginalNumber,l=e.oldOriginalNumber;l===void 0||n===void 0||(n>l?v("up"):l>n&&v("down"))}function v(n){r.value=n,i.value=!1,X(()=>{var l;(l=t.value)===null||l===void 0||l.offsetWidth,i.value=!0})}return()=>{const{clsPrefix:n}=e;return o("span",{ref:t,class:`${n}-base-slot-machine-number`},a.value!==null?o("span",{class:[`${n}-base-slot-machine-old-number ${n}-base-slot-machine-old-number--top`,u.value]},a.value):null,o("span",{class:[`${n}-base-slot-machine-current-number`,p.value]},o("span",{ref:"numberWrapper",class:[`${n}-base-slot-machine-current-number__inner`,typeof e.value!="number"&&`${n}-base-slot-machine-current-number__inner--not-number`]},d.value)),a.value!==null?o("span",{class:[`${n}-base-slot-machine-old-number ${n}-base-slot-machine-old-number--bottom`,u.value]},a.value):null)}}}),{cubicBezierEaseOut:j}=te;function Ye({duration:e=".2s"}={}){return[f("&.fade-up-width-expand-transition-leave-active",{transition:`
 opacity ${e} ${j},
 max-width ${e} ${j},
 transform ${e} ${j}
 `}),f("&.fade-up-width-expand-transition-enter-active",{transition:`
 opacity ${e} ${j},
 max-width ${e} ${j},
 transform ${e} ${j}
 `}),f("&.fade-up-width-expand-transition-enter-to",{opacity:1,transform:"translateX(0) translateY(0)"}),f("&.fade-up-width-expand-transition-enter-from",{maxWidth:"0 !important",opacity:0,transform:"translateY(60%)"}),f("&.fade-up-width-expand-transition-leave-from",{opacity:1,transform:"translateY(0)"}),f("&.fade-up-width-expand-transition-leave-to",{maxWidth:"0 !important",opacity:0,transform:"translateY(60%)"})]}const Le=f([f("@keyframes n-base-slot-machine-fade-up-in",`
 from {
 transform: translateY(60%);
 opacity: 0;
 }
 to {
 transform: translateY(0);
 opacity: 1;
 }
 `),f("@keyframes n-base-slot-machine-fade-down-in",`
 from {
 transform: translateY(-60%);
 opacity: 0;
 }
 to {
 transform: translateY(0);
 opacity: 1;
 }
 `),f("@keyframes n-base-slot-machine-fade-up-out",`
 from {
 transform: translateY(0%);
 opacity: 1;
 }
 to {
 transform: translateY(-60%);
 opacity: 0;
 }
 `),f("@keyframes n-base-slot-machine-fade-down-out",`
 from {
 transform: translateY(0%);
 opacity: 1;
 }
 to {
 transform: translateY(60%);
 opacity: 0;
 }
 `),m("base-slot-machine",`
 overflow: hidden;
 white-space: nowrap;
 display: inline-block;
 height: 18px;
 line-height: 18px;
 `,[m("base-slot-machine-number",`
 display: inline-block;
 position: relative;
 height: 18px;
 width: .6em;
 max-width: .6em;
 `,[Ye({duration:".2s"}),ne({duration:".2s",delay:"0s"}),m("base-slot-machine-old-number",`
 display: inline-block;
 opacity: 0;
 position: absolute;
 left: 0;
 right: 0;
 `,[$("top",{transform:"translateY(-100%)"}),$("bottom",{transform:"translateY(100%)"}),$("down-scroll",{animation:"n-base-slot-machine-fade-down-out .2s cubic-bezier(0, 0, .2, 1)",animationIterationCount:1}),$("up-scroll",{animation:"n-base-slot-machine-fade-up-out .2s cubic-bezier(0, 0, .2, 1)",animationIterationCount:1})]),m("base-slot-machine-current-number",`
 display: inline-block;
 position: absolute;
 left: 0;
 top: 0;
 bottom: 0;
 right: 0;
 opacity: 1;
 transform: translateY(0);
 width: .6em;
 `,[$("down-scroll",{animation:"n-base-slot-machine-fade-down-in .2s cubic-bezier(0, 0, .2, 1)",animationIterationCount:1}),$("up-scroll",{animation:"n-base-slot-machine-fade-up-in .2s cubic-bezier(0, 0, .2, 1)",animationIterationCount:1}),w("inner",`
 display: inline-block;
 position: absolute;
 right: 0;
 top: 0;
 width: .6em;
 `,[$("not-number",`
 right: unset;
 left: 0;
 `)])])])])]),Fe=E({name:"BaseSlotMachine",props:{clsPrefix:{type:String,required:!0},value:{type:[Number,String],default:0},max:{type:Number,default:void 0},appeared:{type:Boolean,required:!0}},setup(e){ae("-base-slot-machine",Le,A(e,"clsPrefix"));const t=R(),a=R(),d=z(()=>{if(typeof e.value=="string")return[];if(e.value<1)return[0];const r=[];let i=e.value;for(e.max!==void 0&&(i=Math.min(e.max,i));i>=1;)r.push(i%10),i/=10,i=Math.floor(i);return r.reverse(),r});return J(A(e,"value"),(r,i)=>{typeof r=="string"?(a.value=void 0,t.value=void 0):typeof i=="string"?(a.value=r,t.value=void 0):(a.value=r,t.value=i)}),()=>{const{value:r,clsPrefix:i}=e;return typeof r=="number"?o("span",{class:`${i}-base-slot-machine`},o(re,{name:"fade-up-width-expand-transition",tag:"span"},{default:()=>d.value.map((p,u)=>o(U,{clsPrefix:i,key:d.value.length-u-1,oldOriginalNumber:t.value,newOriginalNumber:a.value,value:p}))}),o(oe,{key:"+",width:!0},{default:()=>e.max!==void 0&&e.max<r?o(U,{clsPrefix:i,value:"+"}):null})):o("span",{class:`${i}-base-slot-machine`},r)}}}),He=f([f("@keyframes badge-wave-spread",{from:{boxShadow:"0 0 0.5px 0px var(--n-ripple-color)",opacity:.6},to:{boxShadow:"0 0 0.5px 4.5px var(--n-ripple-color)",opacity:0}}),m("badge",`
 display: inline-flex;
 position: relative;
 vertical-align: middle;
 color: var(--n-color);
 font-family: var(--n-font-family);
 `,[$("as-is",[m("badge-sup",{position:"static",transform:"translateX(0)"},[q({transformOrigin:"left bottom",originalTransform:"translateX(0)"})])]),$("dot",[m("badge-sup",`
 height: 8px;
 width: 8px;
 padding: 0;
 min-width: 8px;
 left: 100%;
 bottom: calc(100% - 4px);
 `,[f("::before","border-radius: 4px;")])]),m("badge-sup",`
 background: var(--n-color);
 transition:
 background-color .3s var(--n-bezier),
 color .3s var(--n-bezier);
 color: #FFF;
 position: absolute;
 height: 18px;
 line-height: 18px;
 border-radius: 9px;
 padding: 0 6px;
 text-align: center;
 font-size: var(--n-font-size);
 transform: translateX(-50%);
 left: 100%;
 bottom: calc(100% - 9px);
 font-variant-numeric: tabular-nums;
 z-index: 1;
 display: flex;
 align-items: center;
 `,[q({transformOrigin:"left bottom",originalTransform:"translateX(-50%)"}),m("base-wave",{zIndex:1,animationDuration:"2s",animationIterationCount:"infinite",animationDelay:"1s",animationTimingFunction:"var(--n-ripple-bezier)",animationName:"badge-wave-spread"}),f("&::before",`
 opacity: 0;
 transform: scale(1);
 border-radius: 9px;
 content: "";
 position: absolute;
 left: 0;
 right: 0;
 top: 0;
 bottom: 0;
 `)])])]),Ge=Object.assign(Object.assign({},O.props),{value:[String,Number],max:Number,dot:Boolean,type:{type:String,default:"default"},show:{type:Boolean,default:!0},showZero:Boolean,processing:Boolean,color:String,offset:Array}),We=E({name:"Badge",props:Ge,setup(e,{slots:t}){const{mergedClsPrefixRef:a,inlineThemeDisabled:d,mergedRtlRef:r}=L(e),i=O("Badge","-badge",He,ie,e,a),p=R(!1),u=()=>{p.value=!0},c=()=>{p.value=!1},v=z(()=>e.show&&(e.dot||e.value!==void 0&&!(!e.showZero&&Number(e.value)<=0)||!le(t.value)));se(()=>{v.value&&(p.value=!0)});const n=F("Badge",r,a),l=z(()=>{const{type:s,color:_}=e,{common:{cubicBezierEaseInOut:k,cubicBezierEaseOut:T},self:{[de("color",s)]:b,fontFamily:D,fontSize:I}}=i.value;return{"--n-font-size":I,"--n-font-family":D,"--n-color":_||b,"--n-ripple-color":_||b,"--n-bezier":k,"--n-ripple-bezier":T}}),g=d?H("badge",z(()=>{let s="";const{type:_,color:k}=e;return _&&(s+=_[0]),k&&(s+=ce(k)),s}),l,e):void 0,S=z(()=>{const{offset:s}=e;if(!s)return;const[_,k]=s,T=typeof _=="number"?`${_}px`:_,b=typeof k=="number"?`${k}px`:k;return{transform:`translate(calc(${n!=null&&n.value?"50%":"-50%"} + ${T}), ${b})`}});return{rtlEnabled:n,mergedClsPrefix:a,appeared:p,showBadge:v,handleAfterEnter:u,handleAfterLeave:c,cssVars:d?void 0:l,themeClass:g==null?void 0:g.themeClass,onRender:g==null?void 0:g.onRender,offsetStyle:S}},render(){var e;const{mergedClsPrefix:t,onRender:a,themeClass:d,$slots:r}=this;a==null||a();const i=(e=r.default)===null||e===void 0?void 0:e.call(r);return o("div",{class:[`${t}-badge`,this.rtlEnabled&&`${t}-badge--rtl`,d,{[`${t}-badge--dot`]:this.dot,[`${t}-badge--as-is`]:!i}],style:this.cssVars},i,o(ue,{name:"fade-in-scale-up-transition",onAfterEnter:this.handleAfterEnter,onAfterLeave:this.handleAfterLeave},{default:()=>this.showBadge?o("sup",{class:`${t}-badge-sup`,title:De(this.value),style:this.offsetStyle},me(r.value,()=>[this.dot?null:o(Fe,{clsPrefix:t,appeared:this.appeared,max:this.max,value:this.value})]),this.processing?o(fe,{clsPrefix:t}):null):null}))}}),Xe=f([m("list",`
 --n-merged-border-color: var(--n-border-color);
 --n-merged-color: var(--n-color);
 --n-merged-color-hover: var(--n-color-hover);
 margin: 0;
 font-size: var(--n-font-size);
 transition:
 background-color .3s var(--n-bezier),
 color .3s var(--n-bezier),
 border-color .3s var(--n-bezier);
 padding: 0;
 list-style-type: none;
 color: var(--n-text-color);
 background-color: var(--n-merged-color);
 `,[$("show-divider",[m("list-item",[f("&:not(:last-child)",[w("divider",`
 background-color: var(--n-merged-border-color);
 `)])])]),$("clickable",[m("list-item",`
 cursor: pointer;
 `)]),$("bordered",`
 border: 1px solid var(--n-merged-border-color);
 border-radius: var(--n-border-radius);
 `),$("hoverable",[m("list-item",`
 border-radius: var(--n-border-radius);
 `,[f("&:hover",`
 background-color: var(--n-merged-color-hover);
 `,[w("divider",`
 background-color: transparent;
 `)])])]),$("bordered, hoverable",[m("list-item",`
 padding: 12px 20px;
 `),w("header, footer",`
 padding: 12px 20px;
 `)]),w("header, footer",`
 padding: 12px 0;
 box-sizing: border-box;
 transition: border-color .3s var(--n-bezier);
 `,[f("&:not(:last-child)",`
 border-bottom: 1px solid var(--n-merged-border-color);
 `)]),m("list-item",`
 position: relative;
 padding: 12px 0; 
 box-sizing: border-box;
 display: flex;
 flex-wrap: nowrap;
 align-items: center;
 transition:
 background-color .3s var(--n-bezier),
 border-color .3s var(--n-bezier);
 `,[w("prefix",`
 margin-right: 20px;
 flex: 0;
 `),w("suffix",`
 margin-left: 20px;
 flex: 0;
 `),w("main",`
 flex: 1;
 `),w("divider",`
 height: 1px;
 position: absolute;
 bottom: 0;
 left: 0;
 right: 0;
 background-color: transparent;
 transition: background-color .3s var(--n-bezier);
 pointer-events: none;
 `)])]),pe(m("list",`
 --n-merged-color-hover: var(--n-color-hover-modal);
 --n-merged-color: var(--n-color-modal);
 --n-merged-border-color: var(--n-border-color-modal);
 `)),ve(m("list",`
 --n-merged-color-hover: var(--n-color-hover-popover);
 --n-merged-color: var(--n-color-popover);
 --n-merged-border-color: var(--n-border-color-popover);
 `))]),qe=Object.assign(Object.assign({},O.props),{size:{type:String,default:"medium"},bordered:Boolean,clickable:Boolean,hoverable:Boolean,showDivider:{type:Boolean,default:!0}}),ee=ge("n-list"),Ke=E({name:"List",props:qe,setup(e){const{mergedClsPrefixRef:t,inlineThemeDisabled:a,mergedRtlRef:d}=L(e),r=F("List",d,t),i=O("List","-list",Xe,he,e,t);be(ee,{showDividerRef:A(e,"showDivider"),mergedClsPrefixRef:t});const p=z(()=>{const{common:{cubicBezierEaseInOut:c},self:{fontSize:v,textColor:n,color:l,colorModal:g,colorPopover:S,borderColor:s,borderColorModal:_,borderColorPopover:k,borderRadius:T,colorHover:b,colorHoverModal:D,colorHoverPopover:I}}=i.value;return{"--n-font-size":v,"--n-bezier":c,"--n-text-color":n,"--n-color":l,"--n-border-radius":T,"--n-border-color":s,"--n-border-color-modal":_,"--n-border-color-popover":k,"--n-color-modal":g,"--n-color-popover":S,"--n-color-hover":b,"--n-color-hover-modal":D,"--n-color-hover-popover":I}}),u=a?H("list",void 0,p,e):void 0;return{mergedClsPrefix:t,rtlEnabled:r,cssVars:a?void 0:p,themeClass:u==null?void 0:u.themeClass,onRender:u==null?void 0:u.onRender}},render(){var e;const{$slots:t,mergedClsPrefix:a,onRender:d}=this;return d==null||d(),o("ul",{class:[`${a}-list`,this.rtlEnabled&&`${a}-list--rtl`,this.bordered&&`${a}-list--bordered`,this.showDivider&&`${a}-list--show-divider`,this.hoverable&&`${a}-list--hoverable`,this.clickable&&`${a}-list--clickable`,this.themeClass],style:this.cssVars},t.header?o("div",{class:`${a}-list__header`},t.header()):null,(e=t.default)===null||e===void 0?void 0:e.call(t),t.footer?o("div",{class:`${a}-list__footer`},t.footer()):null)}}),Ue=E({name:"ListItem",setup(){const e=xe(ee,null);return e||_e("list-item","`n-list-item` must be placed in `n-list`."),{showDivider:e.showDividerRef,mergedClsPrefix:e.mergedClsPrefixRef}},render(){const{$slots:e,mergedClsPrefix:t}=this;return o("li",{class:`${t}-list-item`},e.prefix?o("div",{class:`${t}-list-item__prefix`},e.prefix()):null,e.default?o("div",{class:`${t}-list-item__main`},e):null,e.suffix?o("div",{class:`${t}-list-item__suffix`},e.suffix()):null,this.showDivider&&o("div",{class:`${t}-list-item__divider`}))}}),Ze=m("thing",`
 display: flex;
 transition: color .3s var(--n-bezier);
 font-size: var(--n-font-size);
 color: var(--n-text-color);
`,[m("thing-avatar",`
 margin-right: 12px;
 margin-top: 2px;
 `),m("thing-avatar-header-wrapper",`
 display: flex;
 flex-wrap: nowrap;
 `,[m("thing-header-wrapper",`
 flex: 1;
 `)]),m("thing-main",`
 flex-grow: 1;
 `,[m("thing-header",`
 display: flex;
 margin-bottom: 4px;
 justify-content: space-between;
 align-items: center;
 `,[w("title",`
 font-size: 16px;
 font-weight: var(--n-title-font-weight);
 transition: color .3s var(--n-bezier);
 color: var(--n-title-text-color);
 `)]),w("description",[f("&:not(:last-child)",`
 margin-bottom: 4px;
 `)]),w("content",[f("&:not(:first-child)",`
 margin-top: 12px;
 `)]),w("footer",[f("&:not(:first-child)",`
 margin-top: 12px;
 `)]),w("action",[f("&:not(:first-child)",`
 margin-top: 12px;
 `)])])]),Je=Object.assign(Object.assign({},O.props),{title:String,titleExtra:String,description:String,descriptionStyle:[String,Object],content:String,contentStyle:[String,Object],contentIndented:Boolean}),Qe=E({name:"Thing",props:Je,setup(e,{slots:t}){const{mergedClsPrefixRef:a,inlineThemeDisabled:d,mergedRtlRef:r}=L(e),i=O("Thing","-thing",Ze,ye,e,a),p=F("Thing",r,a),u=z(()=>{const{self:{titleTextColor:v,textColor:n,titleFontWeight:l,fontSize:g},common:{cubicBezierEaseInOut:S}}=i.value;return{"--n-bezier":S,"--n-font-size":g,"--n-text-color":n,"--n-title-font-weight":l,"--n-title-text-color":v}}),c=d?H("thing",void 0,u,e):void 0;return()=>{var v;const{value:n}=a,l=p?p.value:!1;return(v=c==null?void 0:c.onRender)===null||v===void 0||v.call(c),o("div",{class:[`${n}-thing`,c==null?void 0:c.themeClass,l&&`${n}-thing--rtl`],style:d?void 0:u.value},t.avatar&&e.contentIndented?o("div",{class:`${n}-thing-avatar`},t.avatar()):null,o("div",{class:`${n}-thing-main`},!e.contentIndented&&(t.header||e.title||t["header-extra"]||e.titleExtra||t.avatar)?o("div",{class:`${n}-thing-avatar-header-wrapper`},t.avatar?o("div",{class:`${n}-thing-avatar`},t.avatar()):null,t.header||e.title||t["header-extra"]||e.titleExtra?o("div",{class:`${n}-thing-header-wrapper`},o("div",{class:`${n}-thing-header`},t.header||e.title?o("div",{class:`${n}-thing-header__title`},t.header?t.header():e.title):null,t["header-extra"]||e.titleExtra?o("div",{class:`${n}-thing-header__extra`},t["header-extra"]?t["header-extra"]():e.titleExtra):null),t.description||e.description?o("div",{class:`${n}-thing-main__description`,style:e.descriptionStyle},t.description?t.description():e.description):null):null):o(G,null,t.header||e.title||t["header-extra"]||e.titleExtra?o("div",{class:`${n}-thing-header`},t.header||e.title?o("div",{class:`${n}-thing-header__title`},t.header?t.header():e.title):null,t["header-extra"]||e.titleExtra?o("div",{class:`${n}-thing-header__extra`},t["header-extra"]?t["header-extra"]():e.titleExtra):null):null,t.description||e.description?o("div",{class:`${n}-thing-main__description`,style:e.descriptionStyle},t.description?t.description():e.description):null),t.default||e.content?o("div",{class:`${n}-thing-main__content`,style:e.contentStyle},t.default?t.default():e.content):null,t.footer?o("div",{class:`${n}-thing-main__footer`},t.footer()):null,t.action?o("div",{class:`${n}-thing-main__action`},t.action()):null))}}}),et={style:{display:"inline-block"},viewBox:"0 0 1024 1024",width:"1em",height:"1em"},tt=M("path",{fill:"currentColor",d:"M816 768h-24V428c0-141.1-104.3-257.7-240-277.1V112c0-22.1-17.9-40-40-40s-40 17.9-40 40v38.9c-135.7 19.4-240 136-240 277.1v340h-24c-17.7 0-32 14.3-32 32v32c0 4.4 3.6 8 8 8h216c0 61.8 50.2 112 112 112s112-50.2 112-112h216c4.4 0 8-3.6 8-8v-32c0-17.7-14.3-32-32-32zM512 888c-26.5 0-48-21.5-48-48h96c0 26.5-21.5 48-48 48zM304 768V428c0-55.6 21.6-107.8 60.9-147.1S456.4 220 512 220c55.6 0 107.8 21.6 147.1 60.9S720 372.4 720 428v340H304z"},null,-1),nt=[tt];function at(e,t){return x(),B("svg",et,[...nt])}const ot={name:"ant-design-bell-outlined",render:at},Z=[{key:"1",name:"通知",list:[{id:"000000001",avatar:"https://gw.alipayobjects.com/zos/rmsportal/ThXAXghbEsBCCSDihZxY.png",title:"你收到了 14 份新周报",datetime:"2022-08-09",type:"1"},{id:"000000002",avatar:"https://gw.alipayobjects.com/zos/rmsportal/OKJXDXrmkNshAMvwtvhu.png",title:"你推荐的 罗伯茨 已通过第三轮面试",datetime:"2022-08-08",type:"1"},{id:"000000003",avatar:"https://gw.alipayobjects.com/zos/rmsportal/kISTdvpyTAhtGxpovNWd.png",title:"这种模板可以区分多种通知类型",datetime:"2022-08-07",type:"1"},{id:"000000004",avatar:"https://gw.alipayobjects.com/zos/rmsportal/GvqBnKhFgObvnSGkDsje.png",title:"左侧图标用于区分不同的类型",datetime:"2022-08-07",type:"1"},{id:"000000005",avatar:"https://gw.alipayobjects.com/zos/rmsportal/GvqBnKhFgObvnSGkDsje.png",title:"标题可以设置自动显示省略号，本例中标题行数已设为1行，如果内容超过1行将自动截断并支持tooltip显示完整标题。",datetime:"2022-08-07",type:"1"}]},{key:"2",name:"消息",badgeType:"info",list:[{id:"000000006",avatar:"https://gw.alipayobjects.com/zos/rmsportal/fcHMVNCjPOsbUGdEduuv.jpeg",title:"莉蛐蛐 评论了你",description:"描述信息描述信息描述信息",datetime:"2017-08-07",type:"2"},{id:"000000007",avatar:"https://gw.alipayobjects.com/zos/rmsportal/fcHMVNCjPOsbUGdEduuv.jpeg",title:"范德萨 回复了你",description:"这种模板用于提醒谁与你发生了互动",datetime:"2022-08-07",type:"2"},{id:"000000008",avatar:"https://gw.alipayobjects.com/zos/rmsportal/fcHMVNCjPOsbUGdEduuv.jpeg",title:"标题",description:"请将鼠标移动到此处，以便测试超长的消息在此处将如何处理。本例中设置的描述最大行数为2，超过2行的描述内容将被省略并且可以通过tooltip查看完整内容",datetime:"2024-08-07",type:"2"}]},{key:"3",name:"待办",badgeType:"success",list:[{id:"000000009",avatar:"",title:"任务名称",description:"任务需要在 2017-01-12 20:00 前启动",datetime:"",extra:"未开始",color:"default",type:"3"},{id:"000000010",avatar:"",title:"第三方紧急代码变更",description:"范德萨 需在 2023-01-07 前完成代码变更任务",datetime:"",extra:"马上到期",color:"error",type:"3"},{id:"000000011",avatar:"",title:"信息安全考试",description:"指派史蒂芬斯于 2022-01-09 前完成更新并发布",datetime:"",extra:"已耗时 8 天",color:"warning",type:"3"},{id:"000000012",avatar:"",title:"ABCD 版本发布",description:"指派竹尔于 2021-01-09 前完成更新并发布后面还加了好几个文字以此增加长度",datetime:"",extra:"进行中",color:"info",type:"3"}]}],rt={key:1},it={key:1,class:"text-$app-text-color-3"},lt={class:"text-$app-text-color-3"},st=E({__name:"NoticeList",props:{list:{default:()=>[]},loading:{type:Boolean,default:!1},titleRows:{default:1},descRows:{default:2}},setup(e){const t=a=>{a.read=!0};return(a,d)=>{const r=Ne,i=Be,p=Ee,u=Te,c=Qe,v=Ue,n=Pe,l=Ke,g=je,S=we("loading");return x(),P(g,{style:{"max-height":"360px"}},{default:h(()=>[$e((x(),P(l,null,{default:h(()=>[e.list.length?(x(!0),B(G,{key:0},Q(e.list,s=>(x(),P(v,{key:s.id,class:"hover:bg-$app-hover-color cursor-pointer",onClick:_=>t(s)},{default:h(()=>[C(c,{class:Y(["px-4",{"opacity-30":s.read}])},ke({avatar:h(()=>[s.avatar?(x(),P(r,{key:0,style:{backgroundColor:"transparent"},src:s.avatar},null,8,["src"])):(x(),B("span",rt,N(s.avatar),1))]),header:h(()=>[C(p,{"line-clamp":e.titleRows,tooltip:{placement:"top"}},{tooltip:h(()=>[V(N(s.title),1)]),default:h(()=>[C(i,null,{default:h(()=>[V(N(s.title),1)]),_:2},1024)]),_:2},1032,["line-clamp"])]),description:h(()=>[s.description?(x(),P(p,{key:0,"line-clamp":e.descRows},{default:h(()=>[V(N(s.description),1)]),_:2},1032,["line-clamp"])):(x(),B("span",it,N(s.datetime),1))]),_:2},[s.extra?{name:"header-extra",fn:h(()=>[C(u,{type:s==null?void 0:s.color,size:"small"},{default:h(()=>[V(N(s.extra),1)]),_:2},1032,["type"])]),key:"0"}:void 0,s.description?{name:"footer",fn:h(()=>[M("span",lt,N(s.datetime),1)]),key:"1"}:void 0]),1032,["class"])]),_:2},1032,["onClick"]))),128)):(x(),P(n,{key:1,class:"min-h-200px flex-jc-ac"}))]),_:1})),[[S,e.loading]])]),_:1})}}}),dt={class:"app-layout-header-anction-icon mr-1 relative"},ct={class:"mt-1px"},ut={key:0,class:"flex border-t border-$n-divider-color"},Tt=E({__name:"index",setup(e){const{prefixCls:t}=Oe("header-notify"),a=R(ze(Z)),d=R(!1),r=R(0),i=z(()=>a.value.reduce((n,l)=>n+l.list.filter(g=>!g.read).length,0)),p=z(()=>({display:"flex",justifyContent:"center",minWidth:"6rem"})),u=z(()=>({right:`-${i.value>9?6:1}px`})),c=n=>{a.value[n].list=[]},v=n=>W(this,null,function*(){const l=a.value[n];l.list.length>99||(d.value=!0,yield Se(1e3),l.list.push(...Z[n].list),d.value=!1)});return(n,l)=>{const g=ot,S=We,s=Ae,_=Me,k=Ie,T=Ve;return x(),B("div",{class:Y([y(t),"h-full"])},[C(T,{trigger:"click",class:"!p-0",placement:"bottom"},{trigger:h(()=>[M("span",dt,[C(g,{class:Y(["text-$n-text-color",{"mt-1":y(i)>0}])},null,8,["class"]),C(S,{value:y(i),show:y(i)>0,class:"absolute top-1.5",style:Ce(y(u)),max:99},null,8,["value","show","style"])])]),default:h(()=>[C(k,{value:y(r),"onUpdate:value":l[0]||(l[0]=b=>Re(r)?r.value=b:null),"tab-style":y(p),type:"line","justify-content":"space-evenly",class:"w-20rem"},{default:h(()=>[(x(!0),B(G,null,Q(y(a),(b,D)=>(x(),P(_,{key:b.key,name:D},{tab:h(()=>[C(s,{size:3},{default:h(()=>[M("div",ct,N(b.name),1),C(S,{value:b.list.filter(I=>!I.read).length,type:b.badgeType,max:99,show:b.list.length!==0},null,8,["value","type","show"])]),_:2},1024)]),default:h(()=>[C(st,{list:b.list,loading:y(d)},null,8,["list","loading"])]),_:2},1032,["name"]))),128))]),_:1},8,["value","tab-style"]),y(a)[y(r)].list.length>0?(x(),B("div",ut,[M("div",{class:"py-3 text-center cursor-pointer flex-1",onClick:l[1]||(l[1]=b=>c(y(r)))}," 清空 "),y(r)!==2?(x(),B("div",{key:0,class:"py-3 text-center cursor-pointer flex-1 border-l border-$n-divider-color",onClick:l[2]||(l[2]=b=>v(y(r)))}," 查看更多 ")):K("",!0)])):K("",!0)]),_:1})],2)}}});export{Tt as default};
