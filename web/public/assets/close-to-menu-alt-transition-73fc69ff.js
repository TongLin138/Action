import{P as a,aK as u,Q as n,R as f,d as C,h as i,N as Z,S as $,H as q,r as y,j as p,J as N,be as D,V as G,G as J,bf as Q,I as ee,aS as te,Z as _,o as m,p as S,v as oe,_ as R,c as I,w as P,a as j,bg as E}from"./index-797c0a85.js";import{C as re}from"./ChevronRight-54f6887a.js";import{l as le,p as ne}from"./interface-6b37b567.js";import{l as ae}from"./Layout-06ff11a6.js";import{f as x,N as O}from"./Icon-abc31adc.js";import{u as se}from"./Tooltip-271e10cc.js";import{_ as ie}from"./index-f66bd7de.js";const ce=a("layout-sider",`
 flex-shrink: 0;
 box-sizing: border-box;
 position: relative;
 z-index: 1;
 color: var(--n-text-color);
 transition:
 color .3s var(--n-bezier),
 border-color .3s var(--n-bezier),
 min-width .3s var(--n-bezier),
 max-width .3s var(--n-bezier),
 transform .3s var(--n-bezier),
 background-color .3s var(--n-bezier);
 background-color: var(--n-color);
 display: flex;
 justify-content: flex-end;
`,[u("bordered",[n("border",`
 content: "";
 position: absolute;
 top: 0;
 bottom: 0;
 width: 1px;
 background-color: var(--n-border-color);
 transition: background-color .3s var(--n-bezier);
 `)]),n("left-placement",[u("bordered",[n("border",`
 right: 0;
 `)])]),u("right-placement",`
 justify-content: flex-start;
 `,[u("bordered",[n("border",`
 left: 0;
 `)]),u("collapsed",[a("layout-toggle-button",[a("base-icon",`
 transform: rotate(180deg);
 `)]),a("layout-toggle-bar",[f("&:hover",[n("top",{transform:"rotate(-12deg) scale(1.15) translateY(-2px)"}),n("bottom",{transform:"rotate(12deg) scale(1.15) translateY(2px)"})])])]),a("layout-toggle-button",`
 left: 0;
 transform: translateX(-50%) translateY(-50%);
 `,[a("base-icon",`
 transform: rotate(0);
 `)]),a("layout-toggle-bar",`
 left: -28px;
 transform: rotate(180deg);
 `,[f("&:hover",[n("top",{transform:"rotate(12deg) scale(1.15) translateY(-2px)"}),n("bottom",{transform:"rotate(-12deg) scale(1.15) translateY(2px)"})])])]),u("collapsed",[a("layout-toggle-bar",[f("&:hover",[n("top",{transform:"rotate(-12deg) scale(1.15) translateY(-2px)"}),n("bottom",{transform:"rotate(12deg) scale(1.15) translateY(2px)"})])]),a("layout-toggle-button",[a("base-icon",`
 transform: rotate(0);
 `)])]),a("layout-toggle-button",`
 transition:
 color .3s var(--n-bezier),
 right .3s var(--n-bezier),
 left .3s var(--n-bezier),
 border-color .3s var(--n-bezier),
 background-color .3s var(--n-bezier);
 cursor: pointer;
 width: 24px;
 height: 24px;
 position: absolute;
 top: 50%;
 right: 0;
 border-radius: 50%;
 display: flex;
 align-items: center;
 justify-content: center;
 font-size: 18px;
 color: var(--n-toggle-button-icon-color);
 border: var(--n-toggle-button-border);
 background-color: var(--n-toggle-button-color);
 box-shadow: 0 2px 4px 0px rgba(0, 0, 0, .06);
 transform: translateX(50%) translateY(-50%);
 z-index: 1;
 `,[a("base-icon",`
 transition: transform .3s var(--n-bezier);
 transform: rotate(180deg);
 `)]),a("layout-toggle-bar",`
 cursor: pointer;
 height: 72px;
 width: 32px;
 position: absolute;
 top: calc(50% - 36px);
 right: -28px;
 `,[n("top, bottom",`
 position: absolute;
 width: 4px;
 border-radius: 2px;
 height: 38px;
 left: 14px;
 transition: 
 background-color .3s var(--n-bezier),
 transform .3s var(--n-bezier);
 `),n("bottom",`
 position: absolute;
 top: 34px;
 `),f("&:hover",[n("top",{transform:"rotate(12deg) scale(1.15) translateY(-2px)"}),n("bottom",{transform:"rotate(-12deg) scale(1.15) translateY(2px)"})]),n("top, bottom",{backgroundColor:"var(--n-toggle-bar-color)"}),f("&:hover",[n("top, bottom",{backgroundColor:"var(--n-toggle-bar-color-hover)"})])]),n("border",`
 position: absolute;
 top: 0;
 right: 0;
 bottom: 0;
 width: 1px;
 transition: background-color .3s var(--n-bezier);
 `),a("layout-sider-scroll-container",`
 flex-grow: 1;
 flex-shrink: 0;
 box-sizing: border-box;
 height: 100%;
 opacity: 0;
 transition: opacity .3s var(--n-bezier);
 max-width: 100%;
 `),u("show-content",[a("layout-sider-scroll-container",{opacity:1})]),u("absolute-positioned",`
 position: absolute;
 left: 0;
 top: 0;
 bottom: 0;
 `)]),de=C({name:"LayoutToggleButton",props:{clsPrefix:{type:String,required:!0},onClick:Function},render(){const{clsPrefix:e}=this;return i("div",{class:`${e}-layout-toggle-button`,onClick:this.onClick},i(Z,{clsPrefix:e},{default:()=>i(re,null)}))}}),ue=C({props:{clsPrefix:{type:String,required:!0},onClick:Function},render(){const{clsPrefix:e}=this;return i("div",{onClick:this.onClick,class:`${e}-layout-toggle-bar`},i("div",{class:`${e}-layout-toggle-bar__top`}),i("div",{class:`${e}-layout-toggle-bar__bottom`}))}}),ge={position:ne,bordered:Boolean,collapsedWidth:{type:Number,default:48},width:{type:[Number,String],default:272},contentStyle:{type:[String,Object],default:""},collapseMode:{type:String,default:"transform"},collapsed:{type:Boolean,default:void 0},defaultCollapsed:Boolean,showCollapsedContent:{type:Boolean,default:!0},showTrigger:{type:[Boolean,String],default:!1},nativeScrollbar:{type:Boolean,default:!0},inverted:Boolean,scrollbarProps:Object,triggerStyle:[String,Object],collapsedTriggerStyle:[String,Object],"onUpdate:collapsed":[Function,Array],onUpdateCollapsed:[Function,Array],onAfterEnter:Function,onAfterLeave:Function,onExpand:[Function,Array],onCollapse:[Function,Array],onScroll:Function},Ee=C({name:"LayoutSider",props:Object.assign(Object.assign({},$.props),ge),setup(e){const o=q(ae),s=y(null),d=y(null),H=p(()=>x(h.value?e.collapsedWidth:e.width)),Y=p(()=>e.collapseMode!=="transform"?{}:{minWidth:x(e.width)}),F=p(()=>o?o.siderPlacement:"left"),w=y(e.defaultCollapsed),h=se(N(e,"collapsed"),w);function V(l,t){if(e.nativeScrollbar){const{value:r}=s;r&&(t===void 0?r.scrollTo(l):r.scrollTo(l,t))}else{const{value:r}=d;r&&r.scrollTo(l,t)}}function A(){const{"onUpdate:collapsed":l,onUpdateCollapsed:t,onExpand:r,onCollapse:v}=e,{value:b}=h;t&&_(t,!b),l&&_(l,!b),w.value=!b,b?r&&_(r):v&&_(v)}let k=0,T=0;const W=l=>{var t;const r=l.target;k=r.scrollLeft,T=r.scrollTop,(t=e.onScroll)===null||t===void 0||t.call(e,l)};D(()=>{if(e.nativeScrollbar){const l=s.value;l&&(l.scrollTop=T,l.scrollLeft=k)}}),G(le,{collapsedRef:h,collapseModeRef:N(e,"collapseMode")});const{mergedClsPrefixRef:z,inlineThemeDisabled:B}=J(e),M=$("Layout","-layout-sider",ce,Q,e,z);function U(l){var t,r;l.propertyName==="max-width"&&(h.value?(t=e.onAfterLeave)===null||t===void 0||t.call(e):(r=e.onAfterEnter)===null||r===void 0||r.call(e))}const K={scrollTo:V},L=p(()=>{const{common:{cubicBezierEaseInOut:l},self:t}=M.value,{siderToggleButtonColor:r,siderToggleButtonBorder:v,siderToggleBarColor:b,siderToggleBarColorHover:X}=t,c={"--n-bezier":l,"--n-toggle-button-color":r,"--n-toggle-button-border":v,"--n-toggle-bar-color":b,"--n-toggle-bar-color-hover":X};return e.inverted?(c["--n-color"]=t.siderColorInverted,c["--n-text-color"]=t.textColorInverted,c["--n-border-color"]=t.siderBorderColorInverted,c["--n-toggle-button-icon-color"]=t.siderToggleButtonIconColorInverted,c.__invertScrollbar=t.__invertScrollbar):(c["--n-color"]=t.siderColor,c["--n-text-color"]=t.textColor,c["--n-border-color"]=t.siderBorderColor,c["--n-toggle-button-icon-color"]=t.siderToggleButtonIconColor),c}),g=B?ee("layout-sider",p(()=>e.inverted?"a":"b"),L,e):void 0;return Object.assign({scrollableElRef:s,scrollbarInstRef:d,mergedClsPrefix:z,mergedTheme:M,styleMaxWidth:H,mergedCollapsed:h,scrollContainerStyle:Y,siderPlacement:F,handleNativeElScroll:W,handleTransitionend:U,handleTriggerClick:A,inlineThemeDisabled:B,cssVars:L,themeClass:g==null?void 0:g.themeClass,onRender:g==null?void 0:g.onRender},K)},render(){var e;const{mergedClsPrefix:o,mergedCollapsed:s,showTrigger:d}=this;return(e=this.onRender)===null||e===void 0||e.call(this),i("aside",{class:[`${o}-layout-sider`,this.themeClass,`${o}-layout-sider--${this.position}-positioned`,`${o}-layout-sider--${this.siderPlacement}-placement`,this.bordered&&`${o}-layout-sider--bordered`,s&&`${o}-layout-sider--collapsed`,(!s||this.showCollapsedContent)&&`${o}-layout-sider--show-content`],onTransitionend:this.handleTransitionend,style:[this.inlineThemeDisabled?void 0:this.cssVars,{maxWidth:this.styleMaxWidth,width:x(this.width)}]},this.nativeScrollbar?i("div",{class:`${o}-layout-sider-scroll-container`,onScroll:this.handleNativeElScroll,style:[this.scrollContainerStyle,{overflow:"auto"},this.contentStyle],ref:"scrollableElRef"},this.$slots):i(te,Object.assign({},this.scrollbarProps,{onScroll:this.onScroll,ref:"scrollbarInstRef",style:this.scrollContainerStyle,contentStyle:this.contentStyle,theme:this.mergedTheme.peers.Scrollbar,themeOverrides:this.mergedTheme.peerOverrides.Scrollbar,builtinThemeOverrides:this.inverted&&this.cssVars.__invertScrollbar==="true"?{colorHover:"rgba(255, 255, 255, .4)",color:"rgba(255, 255, 255, .3)"}:void 0}),this.$slots),d?d==="bar"?i(ue,{clsPrefix:o,style:s?this.collapsedTriggerStyle:this.triggerStyle,onClick:this.handleTriggerClick}):i(de,{clsPrefix:o,style:s?this.collapsedTriggerStyle:this.triggerStyle,onClick:this.handleTriggerClick}):null,this.bordered?i("div",{class:`${o}-layout-sider__border`}):null)}}),be={style:{display:"inline-block"},viewBox:"0 0 256 256",width:"1em",height:"1em"},he=oe("path",{fill:"currentColor",d:"M228 152v56a20 20 0 0 1-20 20H48a20 20 0 0 1-20-20v-56a12 12 0 0 1 24 0v52h152v-52a12 12 0 0 1 24 0Zm-108.49 8.49a12 12 0 0 0 17 0l40-40a12 12 0 0 0-17-17L140 123V40a12 12 0 0 0-24 0v83l-19.51-19.49a12 12 0 0 0-17 17Z"},null,-1),fe=[he];function pe(e,o){return m(),S("svg",be,[...fe])}const me={name:"ph-download-simple-bold",render:pe},ve={};function _e(e,o){const s=me,d=O;return m(),I(d,null,{default:P(()=>[j(s,{style:{"vertical-align":"baseline"}})]),_:1})}const Oe=R(ve,[["render",_e]]),ye={};function xe(e,o){const s=ie,d=O;return m(),I(d,null,{default:P(()=>[j(s)]),_:1})}const He=R(ye,[["render",xe]]),Ce={style:{display:"inline-block"},viewBox:"0 0 24 24",width:"1em",height:"1em"},Se=E('<g fill="none" stroke="currentColor" stroke-linecap="round" stroke-width="2"><path d="M5 5L12 5L19 5"><animate fill="freeze" attributeName="d" dur="0.4s" values="M5 5L12 5L19 5;M5 5L12 12L19 5"></animate></path><path d="M5 12H19"><animate fill="freeze" attributeName="d" dur="0.4s" values="M5 12H19;M12 12H12"></animate></path><path d="M5 19L12 19L19 19"><animate fill="freeze" attributeName="d" dur="0.4s" values="M5 19L12 19L19 19;M5 19L12 12L19 19"></animate></path></g>',1),we=[Se];function ke(e,o){return m(),S("svg",Ce,[...we])}const Ye={name:"line-md-menu-to-close-transition",render:ke},Te={style:{display:"inline-block"},viewBox:"0 0 24 24",width:"1em",height:"1em"},ze=E('<g fill="none" stroke="currentColor" stroke-linecap="round" stroke-width="2"><path d="M5 5L19 19"><animate fill="freeze" attributeName="d" dur="0.4s" values="M5 5L19 19;M5 5L19 5"></animate></path><path d="M12 12H12" opacity="0"><animate fill="freeze" attributeName="d" begin="0.2s" dur="0.4s" values="M12 12H12;M5 12H19"></animate><set attributeName="opacity" begin="0.2s" to="1"></set></path><path d="M5 19L19 5"><animate fill="freeze" attributeName="d" dur="0.4s" values="M5 19L19 5;M5 19L19 19"></animate></path></g>',1),Be=[ze];function Me(e,o){return m(),S("svg",Te,[...Be])}const Fe={name:"line-md-close-to-menu-alt-transition",render:Me};export{Fe as _,Ye as a,Ee as b,He as c,Oe as d};
