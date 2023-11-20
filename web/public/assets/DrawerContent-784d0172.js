import{d as A,r as E,H as V,du as N,j as z,G as K,aN as fe,k as me,A as be,C as ge,cC as ve,dv as we,V as F,ad as j,ap as U,h as a,cF as pe,D as q,m as ye,aS as Q,c8 as $e,c9 as Se,c7 as ze,R as n,c5 as H,P as h,aK as $,Q as k,bU as xe,bW as Ce,S as G,dw as Be,J as L,dx as ke,I as Ee,bY as Re,bX as Te,dy as Fe,Z as C,dh as He,cQ as Me}from"./index-797c0a85.js";import{u as X}from"./Tooltip-271e10cc.js";import{f as Y}from"./Icon-abc31adc.js";const Oe=A({name:"NDrawerContent",inheritAttrs:!1,props:{blockScroll:Boolean,show:{type:Boolean,default:void 0},displayDirective:{type:String,required:!0},placement:{type:String,required:!0},contentStyle:[Object,String],nativeScrollbar:{type:Boolean,required:!0},scrollbarProps:Object,trapFocus:{type:Boolean,default:!0},autoFocus:{type:Boolean,default:!0},showMask:{type:[Boolean,String],required:!0},maxWidth:Number,maxHeight:Number,minWidth:Number,minHeight:Number,resizable:Boolean,onClickoutside:Function,onAfterLeave:Function,onAfterEnter:Function,onEsc:Function},setup(e){const t=E(!!e.show),r=E(null),g=V(N);let f=0,w="",u=null;const p=E(!1),v=E(!1),S=z(()=>e.placement==="top"||e.placement==="bottom"),{mergedClsPrefixRef:m,mergedRtlRef:M}=K(e),O=fe("Drawer",M,m),P=i=>{v.value=!0,f=S.value?i.clientY:i.clientX,w=document.body.style.cursor,document.body.style.cursor=S.value?"ns-resize":"ew-resize",document.body.addEventListener("mousemove",y),document.body.addEventListener("mouseleave",s),document.body.addEventListener("mouseup",o)},I=()=>{u!==null&&(window.clearTimeout(u),u=null),v.value?p.value=!0:u=window.setTimeout(()=>{p.value=!0},300)},D=()=>{u!==null&&(window.clearTimeout(u),u=null),p.value=!1},{doUpdateHeight:W,doUpdateWidth:_}=g,R=i=>{const{maxWidth:l}=e;if(l&&i>l)return l;const{minWidth:c}=e;return c&&i<c?c:i},T=i=>{const{maxHeight:l}=e;if(l&&i>l)return l;const{minHeight:c}=e;return c&&i<c?c:i},y=i=>{var l,c;if(v.value)if(S.value){let b=((l=r.value)===null||l===void 0?void 0:l.offsetHeight)||0;const x=f-i.clientY;b+=e.placement==="bottom"?x:-x,b=T(b),W(b),f=i.clientY}else{let b=((c=r.value)===null||c===void 0?void 0:c.offsetWidth)||0;const x=f-i.clientX;b+=e.placement==="right"?x:-x,b=R(b),_(b),f=i.clientX}},o=()=>{v.value&&(f=0,v.value=!1,document.body.style.cursor=w,document.body.removeEventListener("mousemove",y),document.body.removeEventListener("mouseup",o),document.body.removeEventListener("mouseleave",s))},s=o;me(()=>{e.show&&(t.value=!0)}),be(()=>e.show,i=>{i||o()}),ge(()=>{o()});const d=z(()=>{const{show:i}=e,l=[[U,i]];return e.showMask||l.push([ve,e.onClickoutside,void 0,{capture:!0}]),l});function B(){var i;t.value=!1,(i=e.onAfterLeave)===null||i===void 0||i.call(e)}return we(z(()=>e.blockScroll&&t.value)),F($e,r),F(Se,null),F(ze,null),{bodyRef:r,rtlEnabled:O,mergedClsPrefix:g.mergedClsPrefixRef,isMounted:g.isMountedRef,mergedTheme:g.mergedThemeRef,displayed:t,transitionName:z(()=>({right:"slide-in-from-right-transition",left:"slide-in-from-left-transition",top:"slide-in-from-top-transition",bottom:"slide-in-from-bottom-transition"})[e.placement]),handleAfterLeave:B,bodyDirectives:d,handleMousedownResizeTrigger:P,handleMouseenterResizeTrigger:I,handleMouseleaveResizeTrigger:D,isDragging:v,isHoverOnResizeTrigger:p}},render(){const{$slots:e,mergedClsPrefix:t}=this;return this.displayDirective==="show"||this.displayed||this.show?j(a("div",{role:"none"},a(pe,{disabled:!this.showMask||!this.trapFocus,active:this.show,autoFocus:this.autoFocus,onEsc:this.onEsc},{default:()=>a(q,{name:this.transitionName,appear:this.isMounted,onAfterEnter:this.onAfterEnter,onAfterLeave:this.handleAfterLeave},{default:()=>j(a("div",ye(this.$attrs,{role:"dialog",ref:"bodyRef","aria-modal":"true",class:[`${t}-drawer`,this.rtlEnabled&&`${t}-drawer--rtl`,`${t}-drawer--${this.placement}-placement`,this.isDragging&&`${t}-drawer--unselectable`,this.nativeScrollbar&&`${t}-drawer--native-scrollbar`]}),[this.resizable?a("div",{class:[`${t}-drawer__resize-trigger`,(this.isDragging||this.isHoverOnResizeTrigger)&&`${t}-drawer__resize-trigger--hover`],onMouseenter:this.handleMouseenterResizeTrigger,onMouseleave:this.handleMouseleaveResizeTrigger,onMousedown:this.handleMousedownResizeTrigger}):null,this.nativeScrollbar?a("div",{class:`${t}-drawer-content-wrapper`,style:this.contentStyle,role:"none"},e):a(Q,Object.assign({},this.scrollbarProps,{contentStyle:this.contentStyle,contentClass:`${t}-drawer-content-wrapper`,theme:this.mergedTheme.peers.Scrollbar,themeOverrides:this.mergedTheme.peerOverrides.Scrollbar}),e)]),this.bodyDirectives)})})),[[U,this.displayDirective==="if"||this.displayed||this.show]]):null}}),{cubicBezierEaseIn:Pe,cubicBezierEaseOut:Ie}=H;function De({duration:e="0.3s",leaveDuration:t="0.2s",name:r="slide-in-from-right"}={}){return[n(`&.${r}-transition-leave-active`,{transition:`transform ${t} ${Pe}`}),n(`&.${r}-transition-enter-active`,{transition:`transform ${e} ${Ie}`}),n(`&.${r}-transition-enter-to`,{transform:"translateX(0)"}),n(`&.${r}-transition-enter-from`,{transform:"translateX(100%)"}),n(`&.${r}-transition-leave-from`,{transform:"translateX(0)"}),n(`&.${r}-transition-leave-to`,{transform:"translateX(100%)"})]}const{cubicBezierEaseIn:We,cubicBezierEaseOut:_e}=H;function je({duration:e="0.3s",leaveDuration:t="0.2s",name:r="slide-in-from-left"}={}){return[n(`&.${r}-transition-leave-active`,{transition:`transform ${t} ${We}`}),n(`&.${r}-transition-enter-active`,{transition:`transform ${e} ${_e}`}),n(`&.${r}-transition-enter-to`,{transform:"translateX(0)"}),n(`&.${r}-transition-enter-from`,{transform:"translateX(-100%)"}),n(`&.${r}-transition-leave-from`,{transform:"translateX(0)"}),n(`&.${r}-transition-leave-to`,{transform:"translateX(-100%)"})]}const{cubicBezierEaseIn:Ae,cubicBezierEaseOut:Ne}=H;function Ue({duration:e="0.3s",leaveDuration:t="0.2s",name:r="slide-in-from-top"}={}){return[n(`&.${r}-transition-leave-active`,{transition:`transform ${t} ${Ae}`}),n(`&.${r}-transition-enter-active`,{transition:`transform ${e} ${Ne}`}),n(`&.${r}-transition-enter-to`,{transform:"translateY(0)"}),n(`&.${r}-transition-enter-from`,{transform:"translateY(-100%)"}),n(`&.${r}-transition-leave-from`,{transform:"translateY(0)"}),n(`&.${r}-transition-leave-to`,{transform:"translateY(-100%)"})]}const{cubicBezierEaseIn:Le,cubicBezierEaseOut:Xe}=H;function Ye({duration:e="0.3s",leaveDuration:t="0.2s",name:r="slide-in-from-bottom"}={}){return[n(`&.${r}-transition-leave-active`,{transition:`transform ${t} ${Le}`}),n(`&.${r}-transition-enter-active`,{transition:`transform ${e} ${Xe}`}),n(`&.${r}-transition-enter-to`,{transform:"translateY(0)"}),n(`&.${r}-transition-enter-from`,{transform:"translateY(100%)"}),n(`&.${r}-transition-leave-from`,{transform:"translateY(0)"}),n(`&.${r}-transition-leave-to`,{transform:"translateY(100%)"})]}const Ve=n([h("drawer",`
 word-break: break-word;
 line-height: var(--n-line-height);
 position: absolute;
 pointer-events: all;
 box-shadow: var(--n-box-shadow);
 transition:
 background-color .3s var(--n-bezier),
 color .3s var(--n-bezier);
 background-color: var(--n-color);
 color: var(--n-text-color);
 box-sizing: border-box;
 `,[De(),je(),Ue(),Ye(),$("unselectable",`
 user-select: none; 
 -webkit-user-select: none;
 `),$("native-scrollbar",[h("drawer-content-wrapper",`
 overflow: auto;
 height: 100%;
 `)]),k("resize-trigger",`
 position: absolute;
 background-color: #0000;
 transition: background-color .3s var(--n-bezier);
 `,[$("hover",`
 background-color: var(--n-resize-trigger-color-hover);
 `)]),h("drawer-content-wrapper",`
 box-sizing: border-box;
 `),h("drawer-content",`
 height: 100%;
 display: flex;
 flex-direction: column;
 `,[$("native-scrollbar",[h("drawer-body-content-wrapper",`
 height: 100%;
 overflow: auto;
 `)]),h("drawer-body",`
 flex: 1 0 0;
 overflow: hidden;
 `),h("drawer-body-content-wrapper",`
 box-sizing: border-box;
 padding: var(--n-body-padding);
 `),h("drawer-header",`
 font-weight: var(--n-title-font-weight);
 line-height: 1;
 font-size: var(--n-title-font-size);
 color: var(--n-title-text-color);
 padding: var(--n-header-padding);
 transition: border .3s var(--n-bezier);
 border-bottom: 1px solid var(--n-divider-color);
 border-bottom: var(--n-header-border-bottom);
 display: flex;
 justify-content: space-between;
 align-items: center;
 `,[k("close",`
 margin-left: 6px;
 transition:
 background-color .3s var(--n-bezier),
 color .3s var(--n-bezier);
 `)]),h("drawer-footer",`
 display: flex;
 justify-content: flex-end;
 border-top: var(--n-footer-border-top);
 transition: border .3s var(--n-bezier);
 padding: var(--n-footer-padding);
 `)]),$("right-placement",`
 top: 0;
 bottom: 0;
 right: 0;
 `,[k("resize-trigger",`
 width: 3px;
 height: 100%;
 top: 0;
 left: 0;
 transform: translateX(-1.5px);
 cursor: ew-resize;
 `)]),$("left-placement",`
 top: 0;
 bottom: 0;
 left: 0;
 `,[k("resize-trigger",`
 width: 3px;
 height: 100%;
 top: 0;
 right: 0;
 transform: translateX(1.5px);
 cursor: ew-resize;
 `)]),$("top-placement",`
 top: 0;
 left: 0;
 right: 0;
 `,[k("resize-trigger",`
 width: 100%;
 height: 3px;
 bottom: 0;
 left: 0;
 transform: translateY(1.5px);
 cursor: ns-resize;
 `)]),$("bottom-placement",`
 left: 0;
 bottom: 0;
 right: 0;
 `,[k("resize-trigger",`
 width: 100%;
 height: 3px;
 top: 0;
 left: 0;
 transform: translateY(-1.5px);
 cursor: ns-resize;
 `)])]),n("body",[n(">",[h("drawer-container",{position:"fixed"})])]),h("drawer-container",`
 position: relative;
 position: absolute;
 left: 0;
 right: 0;
 top: 0;
 bottom: 0;
 pointer-events: none;
 `,[n("> *",{pointerEvents:"all"})]),h("drawer-mask",`
 background-color: rgba(0, 0, 0, .3);
 position: absolute;
 left: 0;
 right: 0;
 top: 0;
 bottom: 0;
 `,[$("invisible",`
 background-color: rgba(0, 0, 0, 0)
 `),xe({enterDuration:"0.2s",leaveDuration:"0.2s",enterCubicBezier:"var(--n-bezier-in)",leaveCubicBezier:"var(--n-bezier-out)"})])]),Ke=Object.assign(Object.assign({},G.props),{show:Boolean,width:[Number,String],height:[Number,String],placement:{type:String,default:"right"},maskClosable:{type:Boolean,default:!0},showMask:{type:[Boolean,String],default:!0},to:[String,Object],displayDirective:{type:String,default:"if"},nativeScrollbar:{type:Boolean,default:!0},zIndex:Number,onMaskClick:Function,scrollbarProps:Object,contentStyle:[Object,String],trapFocus:{type:Boolean,default:!0},onEsc:Function,autoFocus:{type:Boolean,default:!0},closeOnEsc:{type:Boolean,default:!0},blockScroll:{type:Boolean,default:!0},maxWidth:Number,maxHeight:Number,minWidth:Number,minHeight:Number,resizable:Boolean,defaultWidth:{type:[Number,String],default:251},defaultHeight:{type:[Number,String],default:251},onUpdateWidth:[Function,Array],onUpdateHeight:[Function,Array],"onUpdate:width":[Function,Array],"onUpdate:height":[Function,Array],"onUpdate:show":[Function,Array],onUpdateShow:[Function,Array],onAfterEnter:Function,onAfterLeave:Function,drawerStyle:[String,Object],drawerClass:String,target:null,onShow:Function,onHide:Function}),Ze=A({name:"Drawer",inheritAttrs:!1,props:Ke,setup(e){const{mergedClsPrefixRef:t,namespaceRef:r,inlineThemeDisabled:g}=K(e),f=Ce(),w=G("Drawer","-drawer",Ve,Be,e,t),u=E(e.defaultWidth),p=E(e.defaultHeight),v=X(L(e,"width"),u),S=X(L(e,"height"),p),m=z(()=>{const{placement:o}=e;return o==="top"||o==="bottom"?"":Y(v.value)}),M=z(()=>{const{placement:o}=e;return o==="left"||o==="right"?"":Y(S.value)}),O=o=>{const{onUpdateWidth:s,"onUpdate:width":d}=e;s&&C(s,o),d&&C(d,o),u.value=o},P=o=>{const{onUpdateHeight:s,"onUpdate:width":d}=e;s&&C(s,o),d&&C(d,o),p.value=o},I=z(()=>[{width:m.value,height:M.value},e.drawerStyle||""]);function D(o){const{onMaskClick:s,maskClosable:d}=e;d&&R(!1),s&&s(o)}const W=ke();function _(o){var s;(s=e.onEsc)===null||s===void 0||s.call(e),e.show&&e.closeOnEsc&&Fe(o)&&!W.value&&R(!1)}function R(o){const{onHide:s,onUpdateShow:d,"onUpdate:show":B}=e;d&&C(d,o),B&&C(B,o),s&&!o&&C(s,o)}F(N,{isMountedRef:f,mergedThemeRef:w,mergedClsPrefixRef:t,doUpdateShow:R,doUpdateHeight:P,doUpdateWidth:O});const T=z(()=>{const{common:{cubicBezierEaseInOut:o,cubicBezierEaseIn:s,cubicBezierEaseOut:d},self:{color:B,textColor:i,boxShadow:l,lineHeight:c,headerPadding:b,footerPadding:x,bodyPadding:J,titleFontSize:Z,titleTextColor:ee,titleFontWeight:te,headerBorderBottom:re,footerBorderTop:oe,closeIconColor:ne,closeIconColorHover:ie,closeIconColorPressed:se,closeColorHover:ae,closeColorPressed:le,closeIconSize:de,closeSize:ce,closeBorderRadius:ue,resizableTriggerColorHover:he}}=w.value;return{"--n-line-height":c,"--n-color":B,"--n-text-color":i,"--n-box-shadow":l,"--n-bezier":o,"--n-bezier-out":d,"--n-bezier-in":s,"--n-header-padding":b,"--n-body-padding":J,"--n-footer-padding":x,"--n-title-text-color":ee,"--n-title-font-size":Z,"--n-title-font-weight":te,"--n-header-border-bottom":re,"--n-footer-border-top":oe,"--n-close-icon-color":ne,"--n-close-icon-color-hover":ie,"--n-close-icon-color-pressed":se,"--n-close-size":ce,"--n-close-color-hover":ae,"--n-close-color-pressed":le,"--n-close-icon-size":de,"--n-close-border-radius":ue,"--n-resize-trigger-color-hover":he}}),y=g?Ee("drawer",void 0,T,e):void 0;return{mergedClsPrefix:t,namespace:r,mergedBodyStyle:I,handleMaskClick:D,handleEsc:_,mergedTheme:w,cssVars:g?void 0:T,themeClass:y==null?void 0:y.themeClass,onRender:y==null?void 0:y.onRender,isMounted:f}},render(){const{mergedClsPrefix:e}=this;return a(Te,{to:this.to,show:this.show},{default:()=>{var t;return(t=this.onRender)===null||t===void 0||t.call(this),j(a("div",{class:[`${e}-drawer-container`,this.namespace,this.themeClass],style:this.cssVars,role:"none"},this.showMask?a(q,{name:"fade-in-transition",appear:this.isMounted},{default:()=>this.show?a("div",{"aria-hidden":!0,class:[`${e}-drawer-mask`,this.showMask==="transparent"&&`${e}-drawer-mask--invisible`],onClick:this.handleMaskClick}):null}):null,a(Oe,Object.assign({},this.$attrs,{class:[this.drawerClass,this.$attrs.class],style:[this.mergedBodyStyle,this.$attrs.style],blockScroll:this.blockScroll,contentStyle:this.contentStyle,placement:this.placement,scrollbarProps:this.scrollbarProps,show:this.show,displayDirective:this.displayDirective,nativeScrollbar:this.nativeScrollbar,onAfterEnter:this.onAfterEnter,onAfterLeave:this.onAfterLeave,trapFocus:this.trapFocus,autoFocus:this.autoFocus,resizable:this.resizable,maxHeight:this.maxHeight,minHeight:this.minHeight,maxWidth:this.maxWidth,minWidth:this.minWidth,showMask:this.showMask,onEsc:this.handleEsc,onClickoutside:this.handleMaskClick}),this.$slots)),[[Re,{zIndex:this.zIndex,enabled:this.show}]])}})}}),qe={title:{type:String},headerStyle:[Object,String],footerStyle:[Object,String],bodyStyle:[Object,String],bodyContentStyle:[Object,String],nativeScrollbar:{type:Boolean,default:!0},scrollbarProps:Object,closable:Boolean},et=A({name:"DrawerContent",props:qe,setup(){const e=V(N,null);e||He("drawer-content","`n-drawer-content` must be placed inside `n-drawer`.");const{doUpdateShow:t}=e;function r(){t(!1)}return{handleCloseClick:r,mergedTheme:e.mergedThemeRef,mergedClsPrefix:e.mergedClsPrefixRef}},render(){const{title:e,mergedClsPrefix:t,nativeScrollbar:r,mergedTheme:g,bodyStyle:f,bodyContentStyle:w,headerStyle:u,footerStyle:p,scrollbarProps:v,closable:S,$slots:m}=this;return a("div",{role:"none",class:[`${t}-drawer-content`,r&&`${t}-drawer-content--native-scrollbar`]},m.header||e||S?a("div",{class:`${t}-drawer-header`,style:u,role:"none"},a("div",{class:`${t}-drawer-header__main`,role:"heading","aria-level":"1"},m.header!==void 0?m.header():e),S&&a(Me,{onClick:this.handleCloseClick,clsPrefix:t,class:`${t}-drawer-header__close`,absolute:!0})):null,r?a("div",{class:`${t}-drawer-body`,style:f,role:"none"},a("div",{class:`${t}-drawer-body-content-wrapper`,style:w,role:"none"},m)):a(Q,Object.assign({themeOverrides:g.peerOverrides.Scrollbar,theme:g.peers.Scrollbar},v,{class:`${t}-drawer-body`,contentClass:`${t}-drawer-body-content-wrapper`,contentStyle:w}),m),m.footer?a("div",{class:`${t}-drawer-footer`,style:p,role:"none"},m.footer()):null)}});export{et as _,Ze as a};
