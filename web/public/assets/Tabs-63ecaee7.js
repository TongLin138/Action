import{d as K,r as $,cd as it,h as l,F as st,H as ye,dh as lt,j as Y,m as dt,ac as ct,N as bt,cN as ft,cQ as pt,Y as ut,P as r,aK as o,R as f,Q as P,aL as vt,G as ht,S as we,dj as gt,cH as pe,bL as Q,A as Z,V as xt,J as E,k as mt,aO as A,c3 as U,I as yt,M as ue,aZ as ve,Z as X,an as ee,ad as wt,ap as St,dk as Ct,cJ as Rt}from"./index-797c0a85.js";import{A as zt}from"./Add-843bb42e.js";import{f as $t,h as he,u as Pt}from"./Tooltip-271e10cc.js";import{t as te}from"./throttle-d0379a19.js";import{o as Tt}from"./on-fonts-ready-2684803e.js";const _t=he(".v-x-scroll",{overflow:"auto",scrollbarWidth:"none"},[he("&::-webkit-scrollbar",{width:0,height:0})]),Wt=K({name:"XScroll",props:{disabled:Boolean,onScroll:Function},setup(){const e=$(null);function s(d){!(d.currentTarget.offsetWidth<d.currentTarget.scrollWidth)||d.deltaY===0||(d.currentTarget.scrollLeft+=d.deltaY+d.deltaX,d.preventDefault())}const b=it();return _t.mount({id:"vueuc/x-scroll",head:!0,anchorMetaName:$t,ssr:b}),Object.assign({selfRef:e,handleWheel:s},{scrollTo(...d){var h;(h=e.value)===null||h===void 0||h.scrollTo(...d)}})},render(){return l("div",{ref:"selfRef",onScroll:this.onScroll,onWheel:this.disabled?void 0:this.handleWheel,class:"v-x-scroll"},this.$slots)}}),ne=st("n-tabs"),Se={tab:[String,Number,Object,Function],name:{type:[String,Number],required:!0},disabled:Boolean,displayDirective:{type:String,default:"if"},closable:{type:Boolean,default:void 0},tabProps:Object,label:[String,Number,Object,Function]},Ft=K({__TAB_PANE__:!0,name:"TabPane",alias:["TabPanel"],props:Se,setup(e){const s=ye(ne,null);return s||lt("tab-pane","`n-tab-pane` must be placed inside `n-tabs`."),{style:s.paneStyleRef,class:s.paneClassRef,mergedClsPrefix:s.mergedClsPrefixRef}},render(){return l("div",{class:[`${this.mergedClsPrefix}-tab-pane`,this.class],style:this.style},this.$slots)}}),Lt=Object.assign({internalLeftPadded:Boolean,internalAddable:Boolean,internalCreatedByPane:Boolean},ut(Se,["displayDirective"])),re=K({__TAB__:!0,inheritAttrs:!1,name:"Tab",props:Lt,setup(e){const{mergedClsPrefixRef:s,valueRef:b,typeRef:y,closableRef:d,tabStyleRef:h,tabChangeIdRef:p,onBeforeLeaveRef:w,triggerRef:R,handleAdd:S,activateTab:u,handleClose:C}=ye(ne);return{trigger:R,mergedClosable:Y(()=>{if(e.internalAddable)return!1;const{closable:v}=e;return v===void 0?d.value:v}),style:h,clsPrefix:s,value:b,type:y,handleClose(v){v.stopPropagation(),!e.disabled&&C(e.name)},activateTab(){if(e.disabled)return;if(e.internalAddable){S();return}const{name:v}=e,g=++p.id;if(v!==b.value){const{value:x}=w;x?Promise.resolve(x(e.name,b.value)).then(W=>{W&&p.id===g&&u(v)}):u(v)}}}},render(){const{internalAddable:e,clsPrefix:s,name:b,disabled:y,label:d,tab:h,value:p,mergedClosable:w,style:R,trigger:S,$slots:{default:u}}=this,C=d!=null?d:h;return l("div",{class:`${s}-tabs-tab-wrapper`},this.internalLeftPadded?l("div",{class:`${s}-tabs-tab-pad`}):null,l("div",Object.assign({key:b,"data-name":b,"data-disabled":y?!0:void 0},dt({class:[`${s}-tabs-tab`,p===b&&`${s}-tabs-tab--active`,y&&`${s}-tabs-tab--disabled`,w&&`${s}-tabs-tab--closable`,e&&`${s}-tabs-tab--addable`],onClick:S==="click"?this.activateTab:void 0,onMouseenter:S==="hover"?this.activateTab:void 0,style:e?void 0:R},this.internalCreatedByPane?this.tabProps||{}:this.$attrs)),l("span",{class:`${s}-tabs-tab__label`},e?l(ct,null,l("div",{class:`${s}-tabs-tab__height-placeholder`}," "),l(bt,{clsPrefix:s},{default:()=>l(zt,null)})):u?u():typeof C=="object"?C:ft(C!=null?C:b)),w&&this.type==="card"?l(pt,{clsPrefix:s,class:`${s}-tabs-tab__close`,onClick:this.handleClose,disabled:y}):null))}}),At=r("tabs",`
 box-sizing: border-box;
 width: 100%;
 display: flex;
 flex-direction: column;
 transition:
 background-color .3s var(--n-bezier),
 border-color .3s var(--n-bezier);
`,[o("segment-type",[r("tabs-rail",[f("&.transition-disabled","color: red;",[r("tabs-tab",`
 transition: none;
 `)])])]),o("top",[r("tab-pane",`
 padding: var(--n-pane-padding-top) var(--n-pane-padding-right) var(--n-pane-padding-bottom) var(--n-pane-padding-left);
 `)]),o("left",[r("tab-pane",`
 padding: var(--n-pane-padding-right) var(--n-pane-padding-bottom) var(--n-pane-padding-left) var(--n-pane-padding-top);
 `)]),o("left, right",`
 flex-direction: row;
 `,[r("tabs-bar",`
 width: 2px;
 right: 0;
 transition:
 top .2s var(--n-bezier),
 max-height .2s var(--n-bezier),
 background-color .3s var(--n-bezier);
 `),r("tabs-tab",`
 padding: var(--n-tab-padding-vertical); 
 `)]),o("right",`
 flex-direction: row-reverse;
 `,[r("tab-pane",`
 padding: var(--n-pane-padding-left) var(--n-pane-padding-top) var(--n-pane-padding-right) var(--n-pane-padding-bottom);
 `),r("tabs-bar",`
 left: 0;
 `)]),o("bottom",`
 flex-direction: column-reverse;
 justify-content: flex-end;
 `,[r("tab-pane",`
 padding: var(--n-pane-padding-bottom) var(--n-pane-padding-right) var(--n-pane-padding-top) var(--n-pane-padding-left);
 `),r("tabs-bar",`
 top: 0;
 `)]),r("tabs-rail",`
 padding: 3px;
 border-radius: var(--n-tab-border-radius);
 width: 100%;
 background-color: var(--n-color-segment);
 transition: background-color .3s var(--n-bezier);
 display: flex;
 align-items: center;
 `,[r("tabs-tab-wrapper",`
 flex-basis: 0;
 flex-grow: 1;
 display: flex;
 align-items: center;
 justify-content: center;
 `,[r("tabs-tab",`
 overflow: hidden;
 border-radius: var(--n-tab-border-radius);
 width: 100%;
 display: flex;
 align-items: center;
 justify-content: center;
 `,[o("active",`
 font-weight: var(--n-font-weight-strong);
 color: var(--n-tab-text-color-active);
 background-color: var(--n-tab-color-segment);
 box-shadow: 0 1px 3px 0 rgba(0, 0, 0, .08);
 `),f("&:hover",`
 color: var(--n-tab-text-color-hover);
 `)])])]),o("flex",[r("tabs-nav",{width:"100%"},[r("tabs-wrapper",{width:"100%"},[r("tabs-tab",{marginRight:0})])])]),r("tabs-nav",`
 box-sizing: border-box;
 line-height: 1.5;
 display: flex;
 transition: border-color .3s var(--n-bezier);
 `,[P("prefix, suffix",`
 display: flex;
 align-items: center;
 `),P("prefix","padding-right: 16px;"),P("suffix","padding-left: 16px;")]),o("top, bottom",[r("tabs-nav-scroll-wrapper",[f("&::before",`
 top: 0;
 bottom: 0;
 left: 0;
 width: 20px;
 `),f("&::after",`
 top: 0;
 bottom: 0;
 right: 0;
 width: 20px;
 `),o("shadow-start",[f("&::before",`
 box-shadow: inset 10px 0 8px -8px rgba(0, 0, 0, .12);
 `)]),o("shadow-end",[f("&::after",`
 box-shadow: inset -10px 0 8px -8px rgba(0, 0, 0, .12);
 `)])])]),o("left, right",[r("tabs-nav-scroll-wrapper",[f("&::before",`
 top: 0;
 left: 0;
 right: 0;
 height: 20px;
 `),f("&::after",`
 bottom: 0;
 left: 0;
 right: 0;
 height: 20px;
 `),o("shadow-start",[f("&::before",`
 box-shadow: inset 0 10px 8px -8px rgba(0, 0, 0, .12);
 `)]),o("shadow-end",[f("&::after",`
 box-shadow: inset 0 -10px 8px -8px rgba(0, 0, 0, .12);
 `)])])]),r("tabs-nav-scroll-wrapper",`
 flex: 1;
 position: relative;
 overflow: hidden;
 `,[r("tabs-nav-y-scroll",`
 height: 100%;
 width: 100%;
 overflow-y: auto; 
 scrollbar-width: none;
 `,[f("&::-webkit-scrollbar",`
 width: 0;
 height: 0;
 `)]),f("&::before, &::after",`
 transition: box-shadow .3s var(--n-bezier);
 pointer-events: none;
 content: "";
 position: absolute;
 z-index: 1;
 `)]),r("tabs-nav-scroll-content",`
 display: flex;
 position: relative;
 min-width: 100%;
 width: fit-content;
 box-sizing: border-box;
 `),r("tabs-wrapper",`
 display: inline-flex;
 flex-wrap: nowrap;
 position: relative;
 `),r("tabs-tab-wrapper",`
 display: flex;
 flex-wrap: nowrap;
 flex-shrink: 0;
 flex-grow: 0;
 `),r("tabs-tab",`
 cursor: pointer;
 white-space: nowrap;
 flex-wrap: nowrap;
 display: inline-flex;
 align-items: center;
 color: var(--n-tab-text-color);
 font-size: var(--n-tab-font-size);
 background-clip: padding-box;
 padding: var(--n-tab-padding);
 transition:
 box-shadow .3s var(--n-bezier),
 color .3s var(--n-bezier),
 background-color .3s var(--n-bezier),
 border-color .3s var(--n-bezier);
 `,[o("disabled",{cursor:"not-allowed"}),P("close",`
 margin-left: 6px;
 transition:
 background-color .3s var(--n-bezier),
 color .3s var(--n-bezier);
 `),P("label",`
 display: flex;
 align-items: center;
 `)]),r("tabs-bar",`
 position: absolute;
 bottom: 0;
 height: 2px;
 border-radius: 1px;
 background-color: var(--n-bar-color);
 transition:
 left .2s var(--n-bezier),
 max-width .2s var(--n-bezier),
 background-color .3s var(--n-bezier);
 `,[f("&.transition-disabled",`
 transition: none;
 `),o("disabled",`
 background-color: var(--n-tab-text-color-disabled)
 `)]),r("tabs-pane-wrapper",`
 position: relative;
 overflow: hidden;
 transition: max-height .2s var(--n-bezier);
 `),r("tab-pane",`
 color: var(--n-pane-text-color);
 width: 100%;
 transition:
 color .3s var(--n-bezier),
 background-color .3s var(--n-bezier),
 opacity .2s var(--n-bezier);
 left: 0;
 right: 0;
 top: 0;
 `,[f("&.next-transition-leave-active, &.prev-transition-leave-active, &.next-transition-enter-active, &.prev-transition-enter-active",`
 transition:
 color .3s var(--n-bezier),
 background-color .3s var(--n-bezier),
 transform .2s var(--n-bezier),
 opacity .2s var(--n-bezier);
 `),f("&.next-transition-leave-active, &.prev-transition-leave-active",`
 position: absolute;
 `),f("&.next-transition-enter-from, &.prev-transition-leave-to",`
 transform: translateX(32px);
 opacity: 0;
 `),f("&.next-transition-leave-to, &.prev-transition-enter-from",`
 transform: translateX(-32px);
 opacity: 0;
 `),f("&.next-transition-leave-from, &.next-transition-enter-to, &.prev-transition-leave-from, &.prev-transition-enter-to",`
 transform: translateX(0);
 opacity: 1;
 `)]),r("tabs-tab-pad",`
 box-sizing: border-box;
 width: var(--n-tab-gap);
 flex-grow: 0;
 flex-shrink: 0;
 `),o("line-type, bar-type",[r("tabs-tab",`
 font-weight: var(--n-tab-font-weight);
 box-sizing: border-box;
 vertical-align: bottom;
 `,[f("&:hover",{color:"var(--n-tab-text-color-hover)"}),o("active",`
 color: var(--n-tab-text-color-active);
 font-weight: var(--n-tab-font-weight-active);
 `),o("disabled",{color:"var(--n-tab-text-color-disabled)"})])]),r("tabs-nav",[o("line-type",[o("top",[P("prefix, suffix",`
 border-bottom: 1px solid var(--n-tab-border-color);
 `),r("tabs-nav-scroll-content",`
 border-bottom: 1px solid var(--n-tab-border-color);
 `),r("tabs-bar",`
 bottom: -1px;
 `)]),o("left",[P("prefix, suffix",`
 border-right: 1px solid var(--n-tab-border-color);
 `),r("tabs-nav-scroll-content",`
 border-right: 1px solid var(--n-tab-border-color);
 `),r("tabs-bar",`
 right: -1px;
 `)]),o("right",[P("prefix, suffix",`
 border-left: 1px solid var(--n-tab-border-color);
 `),r("tabs-nav-scroll-content",`
 border-left: 1px solid var(--n-tab-border-color);
 `),r("tabs-bar",`
 left: -1px;
 `)]),o("bottom",[P("prefix, suffix",`
 border-top: 1px solid var(--n-tab-border-color);
 `),r("tabs-nav-scroll-content",`
 border-top: 1px solid var(--n-tab-border-color);
 `),r("tabs-bar",`
 top: -1px;
 `)]),P("prefix, suffix",`
 transition: border-color .3s var(--n-bezier);
 `),r("tabs-nav-scroll-content",`
 transition: border-color .3s var(--n-bezier);
 `),r("tabs-bar",`
 border-radius: 0;
 `)]),o("card-type",[P("prefix, suffix",`
 transition: border-color .3s var(--n-bezier);
 border-bottom: 1px solid var(--n-tab-border-color);
 `),r("tabs-pad",`
 flex-grow: 1;
 transition: border-color .3s var(--n-bezier);
 border-bottom: 1px solid var(--n-tab-border-color);
 `),r("tabs-tab-pad",`
 transition: border-color .3s var(--n-bezier);
 `),r("tabs-tab",`
 font-weight: var(--n-tab-font-weight);
 border: 1px solid var(--n-tab-border-color);
 background-color: var(--n-tab-color);
 box-sizing: border-box;
 position: relative;
 vertical-align: bottom;
 display: flex;
 justify-content: space-between;
 font-size: var(--n-tab-font-size);
 color: var(--n-tab-text-color);
 `,[o("addable",`
 padding-left: 8px;
 padding-right: 8px;
 font-size: 16px;
 `,[P("height-placeholder",`
 width: 0;
 font-size: var(--n-tab-font-size);
 `),vt("disabled",[f("&:hover",`
 color: var(--n-tab-text-color-hover);
 `)])]),o("closable","padding-right: 8px;"),o("active",`
 background-color: #0000;
 font-weight: var(--n-tab-font-weight-active);
 color: var(--n-tab-text-color-active);
 `),o("disabled","color: var(--n-tab-text-color-disabled);")]),r("tabs-scroll-padding","border-bottom: 1px solid var(--n-tab-border-color);")]),o("left, right",[r("tabs-wrapper",`
 flex-direction: column;
 `,[r("tabs-tab-wrapper",`
 flex-direction: column;
 `,[r("tabs-tab-pad",`
 height: var(--n-tab-gap-vertical);
 width: 100%;
 `)])])]),o("top",[o("card-type",[r("tabs-tab",`
 border-top-left-radius: var(--n-tab-border-radius);
 border-top-right-radius: var(--n-tab-border-radius);
 `,[o("active",`
 border-bottom: 1px solid #0000;
 `)]),r("tabs-tab-pad",`
 border-bottom: 1px solid var(--n-tab-border-color);
 `)])]),o("left",[o("card-type",[r("tabs-tab",`
 border-top-left-radius: var(--n-tab-border-radius);
 border-bottom-left-radius: var(--n-tab-border-radius);
 `,[o("active",`
 border-right: 1px solid #0000;
 `)]),r("tabs-tab-pad",`
 border-right: 1px solid var(--n-tab-border-color);
 `)])]),o("right",[o("card-type",[r("tabs-tab",`
 border-top-right-radius: var(--n-tab-border-radius);
 border-bottom-right-radius: var(--n-tab-border-radius);
 `,[o("active",`
 border-left: 1px solid #0000;
 `)]),r("tabs-tab-pad",`
 border-left: 1px solid var(--n-tab-border-color);
 `)])]),o("bottom",[o("card-type",[r("tabs-tab",`
 border-bottom-left-radius: var(--n-tab-border-radius);
 border-bottom-right-radius: var(--n-tab-border-radius);
 `,[o("active",`
 border-top: 1px solid #0000;
 `)]),r("tabs-tab-pad",`
 border-top: 1px solid var(--n-tab-border-color);
 `)])])])]),Bt=Object.assign(Object.assign({},we.props),{value:[String,Number],defaultValue:[String,Number],trigger:{type:String,default:"click"},type:{type:String,default:"bar"},closable:Boolean,justifyContent:String,size:{type:String,default:"medium"},placement:{type:String,default:"top"},tabStyle:[String,Object],barWidth:Number,paneClass:String,paneStyle:[String,Object],paneWrapperClass:String,paneWrapperStyle:[String,Object],addable:[Boolean,Object],tabsPadding:{type:Number,default:0},animated:Boolean,onBeforeLeave:Function,onAdd:Function,"onUpdate:value":[Function,Array],onUpdateValue:[Function,Array],onClose:[Function,Array],labelSize:String,activeName:[String,Number],onActiveNameChange:[Function,Array]}),It=K({name:"Tabs",props:Bt,setup(e,{slots:s}){var b,y,d,h;const{mergedClsPrefixRef:p,inlineThemeDisabled:w}=ht(e),R=we("Tabs","-tabs",At,gt,e,p),S=$(null),u=$(null),C=$(null),v=$(null),g=$(null),x=$(!0),W=$(!0),L=pe(e,["labelSize","size"]),H=pe(e,["activeName","value"]),T=$((y=(b=H.value)!==null&&b!==void 0?b:e.defaultValue)!==null&&y!==void 0?y:s.default?(h=(d=Q(s.default())[0])===null||d===void 0?void 0:d.props)===null||h===void 0?void 0:h.name:null),B=Pt(H,T),j={id:0},c=Y(()=>{if(!(!e.justifyContent||e.type==="card"))return{display:"flex",justifyContent:e.justifyContent}});Z(B,()=>{j.id=0,D(),ie()});function m(){var t;const{value:a}=B;return a===null?null:(t=S.value)===null||t===void 0?void 0:t.querySelector(`[data-name="${a}"]`)}function I(t){if(e.type==="card")return;const{value:a}=u;if(a&&t){const n=`${p.value}-tabs-bar--disabled`,{barWidth:i,placement:z}=e;if(t.dataset.disabled==="true"?a.classList.add(n):a.classList.remove(n),["top","bottom"].includes(z)){if(oe(["top","maxHeight","height"]),typeof i=="number"&&t.offsetWidth>=i){const _=Math.floor((t.offsetWidth-i)/2)+t.offsetLeft;a.style.left=`${_}px`,a.style.maxWidth=`${i}px`}else a.style.left=`${t.offsetLeft}px`,a.style.maxWidth=`${t.offsetWidth}px`;a.style.width="8192px",a.offsetWidth}else{if(oe(["left","maxWidth","width"]),typeof i=="number"&&t.offsetHeight>=i){const _=Math.floor((t.offsetHeight-i)/2)+t.offsetTop;a.style.top=`${_}px`,a.style.maxHeight=`${i}px`}else a.style.top=`${t.offsetTop}px`,a.style.maxHeight=`${t.offsetHeight}px`;a.style.height="8192px",a.offsetHeight}}}function oe(t){const{value:a}=u;if(a)for(const n of t)a.style[n]=""}function D(){if(e.type==="card")return;const t=m();t&&I(t)}function ie(t){var a;const n=(a=g.value)===null||a===void 0?void 0:a.$el;if(!n)return;const i=m();if(!i)return;const{scrollLeft:z,offsetWidth:_}=n,{offsetLeft:F,offsetWidth:N}=i;z>F?n.scrollTo({top:0,left:F,behavior:"smooth"}):F+N>z+_&&n.scrollTo({top:0,left:F+N-_,behavior:"smooth"})}const M=$(null);let J=0,k=null;function Ce(t){const a=M.value;if(a){J=t.getBoundingClientRect().height;const n=`${J}px`,i=()=>{a.style.height=n,a.style.maxHeight=n};k?(i(),k(),k=null):k=i}}function Re(t){const a=M.value;if(a){const n=t.getBoundingClientRect().height,i=()=>{document.body.offsetHeight,a.style.maxHeight=`${n}px`,a.style.height=`${Math.max(J,n)}px`};k?(k(),k=null,i()):k=i}}function ze(){const t=M.value;if(t){t.style.maxHeight="",t.style.height="";const{paneWrapperStyle:a}=e;if(typeof a=="string")t.style.cssText=a;else if(a){const{maxHeight:n,height:i}=a;n!==void 0&&(t.style.maxHeight=n),i!==void 0&&(t.style.height=i)}}}const se={value:[]},le=$("next");function $e(t){const a=B.value;let n="next";for(const i of se.value){if(i===a)break;if(i===t){n="prev";break}}le.value=n,Pe(t)}function Pe(t){const{onActiveNameChange:a,onUpdateValue:n,"onUpdate:value":i}=e;a&&X(a,t),n&&X(n,t),i&&X(i,t),T.value=t}function Te(t){const{onClose:a}=e;a&&X(a,t)}function de(){const{value:t}=u;if(!t)return;const a="transition-disabled";t.classList.add(a),D(),t.classList.remove(a)}let ce=0;function _e(t){var a;if(t.contentRect.width===0&&t.contentRect.height===0||ce===t.contentRect.width)return;ce=t.contentRect.width;const{type:n}=e;(n==="line"||n==="bar")&&de(),n!=="segment"&&q((a=g.value)===null||a===void 0?void 0:a.$el)}const We=te(_e,64);Z([()=>e.justifyContent,()=>e.size],()=>{ee(()=>{const{type:t}=e;(t==="line"||t==="bar")&&de()})});const V=$(!1);function Le(t){var a;const{target:n,contentRect:{width:i}}=t,z=n.parentElement.offsetWidth;if(!V.value)z<i&&(V.value=!0);else{const{value:_}=v;if(!_)return;z-i>_.$el.offsetWidth&&(V.value=!1)}q((a=g.value)===null||a===void 0?void 0:a.$el)}const Ae=te(Le,64);function Be(){const{onAdd:t}=e;t&&t(),ee(()=>{const a=m(),{value:n}=g;!a||!n||n.scrollTo({left:a.offsetLeft,top:0,behavior:"smooth"})})}function q(t){if(!t)return;const{placement:a}=e;if(a==="top"||a==="bottom"){const{scrollLeft:n,scrollWidth:i,offsetWidth:z}=t;x.value=n<=0,W.value=n+z>=i}else{const{scrollTop:n,scrollHeight:i,offsetHeight:z}=t;x.value=n<=0,W.value=n+z>=i}}const je=te(t=>{q(t.target)},64);xt(ne,{triggerRef:E(e,"trigger"),tabStyleRef:E(e,"tabStyle"),paneClassRef:E(e,"paneClass"),paneStyleRef:E(e,"paneStyle"),mergedClsPrefixRef:p,typeRef:E(e,"type"),closableRef:E(e,"closable"),valueRef:B,tabChangeIdRef:j,onBeforeLeaveRef:E(e,"onBeforeLeave"),activateTab:$e,handleClose:Te,handleAdd:Be}),Tt(()=>{D(),ie()}),mt(()=>{const{value:t}=C;if(!t)return;const{value:a}=p,n=`${a}-tabs-nav-scroll-wrapper--shadow-start`,i=`${a}-tabs-nav-scroll-wrapper--shadow-end`;x.value?t.classList.remove(n):t.classList.add(n),W.value?t.classList.remove(i):t.classList.add(i)});const be=$(null);Z(B,()=>{if(e.type==="segment"){const t=be.value;t&&ee(()=>{t.classList.add("transition-disabled"),t.offsetWidth,t.classList.remove("transition-disabled")})}});const ke={syncBarPosition:()=>{D()}},fe=Y(()=>{const{value:t}=L,{type:a}=e,n={card:"Card",bar:"Bar",line:"Line",segment:"Segment"}[a],i=`${t}${n}`,{self:{barColor:z,closeIconColor:_,closeIconColorHover:F,closeIconColorPressed:N,tabColor:Ee,tabBorderColor:He,paneTextColor:Oe,tabFontWeight:Fe,tabBorderRadius:Ie,tabFontWeightActive:De,colorSegment:Me,fontWeightStrong:Ve,tabColorSegment:Ne,closeSize:Ge,closeIconSize:Ue,closeColorHover:Xe,closeColorPressed:Ye,closeBorderRadius:Ke,[A("panePadding",t)]:G,[A("tabPadding",i)]:Je,[A("tabPaddingVertical",i)]:qe,[A("tabGap",i)]:Qe,[A("tabGap",`${i}Vertical`)]:Ze,[A("tabTextColor",a)]:et,[A("tabTextColorActive",a)]:tt,[A("tabTextColorHover",a)]:at,[A("tabTextColorDisabled",a)]:rt,[A("tabFontSize",t)]:nt},common:{cubicBezierEaseInOut:ot}}=R.value;return{"--n-bezier":ot,"--n-color-segment":Me,"--n-bar-color":z,"--n-tab-font-size":nt,"--n-tab-text-color":et,"--n-tab-text-color-active":tt,"--n-tab-text-color-disabled":rt,"--n-tab-text-color-hover":at,"--n-pane-text-color":Oe,"--n-tab-border-color":He,"--n-tab-border-radius":Ie,"--n-close-size":Ge,"--n-close-icon-size":Ue,"--n-close-color-hover":Xe,"--n-close-color-pressed":Ye,"--n-close-border-radius":Ke,"--n-close-icon-color":_,"--n-close-icon-color-hover":F,"--n-close-icon-color-pressed":N,"--n-tab-color":Ee,"--n-tab-font-weight":Fe,"--n-tab-font-weight-active":De,"--n-tab-padding":Je,"--n-tab-padding-vertical":qe,"--n-tab-gap":Qe,"--n-tab-gap-vertical":Ze,"--n-pane-padding-left":U(G,"left"),"--n-pane-padding-right":U(G,"right"),"--n-pane-padding-top":U(G,"top"),"--n-pane-padding-bottom":U(G,"bottom"),"--n-font-weight-strong":Ve,"--n-tab-color-segment":Ne}}),O=w?yt("tabs",Y(()=>`${L.value[0]}${e.type[0]}`),fe,e):void 0;return Object.assign({mergedClsPrefix:p,mergedValue:B,renderedNames:new Set,tabsRailElRef:be,tabsPaneWrapperRef:M,tabsElRef:S,barElRef:u,addTabInstRef:v,xScrollInstRef:g,scrollWrapperElRef:C,addTabFixed:V,tabWrapperStyle:c,handleNavResize:We,mergedSize:L,handleScroll:je,handleTabsResize:Ae,cssVars:w?void 0:fe,themeClass:O==null?void 0:O.themeClass,animationDirection:le,renderNameListRef:se,onAnimationBeforeLeave:Ce,onAnimationEnter:Re,onAnimationAfterEnter:ze,onRender:O==null?void 0:O.onRender},ke)},render(){const{mergedClsPrefix:e,type:s,placement:b,addTabFixed:y,addable:d,mergedSize:h,renderNameListRef:p,onRender:w,paneWrapperClass:R,paneWrapperStyle:S,$slots:{default:u,prefix:C,suffix:v}}=this;w==null||w();const g=u?Q(u()).filter(c=>c.type.__TAB_PANE__===!0):[],x=u?Q(u()).filter(c=>c.type.__TAB__===!0):[],W=!x.length,L=s==="card",H=s==="segment",T=!L&&!H&&this.justifyContent;p.value=[];const B=()=>{const c=l("div",{style:this.tabWrapperStyle,class:[`${e}-tabs-wrapper`]},T?null:l("div",{class:`${e}-tabs-scroll-padding`,style:{width:`${this.tabsPadding}px`}}),W?g.map((m,I)=>(p.value.push(m.props.name),ae(l(re,Object.assign({},m.props,{internalCreatedByPane:!0,internalLeftPadded:I!==0&&(!T||T==="center"||T==="start"||T==="end")}),m.children?{default:m.children.tab}:void 0)))):x.map((m,I)=>(p.value.push(m.props.name),ae(I!==0&&!T?me(m):m))),!y&&d&&L?xe(d,(W?g.length:x.length)!==0):null,T?null:l("div",{class:`${e}-tabs-scroll-padding`,style:{width:`${this.tabsPadding}px`}}));return l("div",{ref:"tabsElRef",class:`${e}-tabs-nav-scroll-content`},L&&d?l(ve,{onResize:this.handleTabsResize},{default:()=>c}):c,L?l("div",{class:`${e}-tabs-pad`}):null,L?null:l("div",{ref:"barElRef",class:`${e}-tabs-bar`}))},j=H?"top":b;return l("div",{class:[`${e}-tabs`,this.themeClass,`${e}-tabs--${s}-type`,`${e}-tabs--${h}-size`,T&&`${e}-tabs--flex`,`${e}-tabs--${j}`],style:this.cssVars},l("div",{class:[`${e}-tabs-nav--${s}-type`,`${e}-tabs-nav--${j}`,`${e}-tabs-nav`]},ue(C,c=>c&&l("div",{class:`${e}-tabs-nav__prefix`},c)),H?l("div",{class:`${e}-tabs-rail`,ref:"tabsRailElRef"},W?g.map((c,m)=>(p.value.push(c.props.name),l(re,Object.assign({},c.props,{internalCreatedByPane:!0,internalLeftPadded:m!==0}),c.children?{default:c.children.tab}:void 0))):x.map((c,m)=>(p.value.push(c.props.name),m===0?c:me(c)))):l(ve,{onResize:this.handleNavResize},{default:()=>l("div",{class:`${e}-tabs-nav-scroll-wrapper`,ref:"scrollWrapperElRef"},["top","bottom"].includes(j)?l(Wt,{ref:"xScrollInstRef",onScroll:this.handleScroll},{default:B}):l("div",{class:`${e}-tabs-nav-y-scroll`,onScroll:this.handleScroll},B()))}),y&&d&&L?xe(d,!0):null,ue(v,c=>c&&l("div",{class:`${e}-tabs-nav__suffix`},c))),W&&(this.animated&&(j==="top"||j==="bottom")?l("div",{ref:"tabsPaneWrapperRef",style:S,class:[`${e}-tabs-pane-wrapper`,R]},ge(g,this.mergedValue,this.renderedNames,this.onAnimationBeforeLeave,this.onAnimationEnter,this.onAnimationAfterEnter,this.animationDirection)):ge(g,this.mergedValue,this.renderedNames)))}});function ge(e,s,b,y,d,h,p){const w=[];return e.forEach(R=>{const{name:S,displayDirective:u,"display-directive":C}=R.props,v=x=>u===x||C===x,g=s===S;if(R.key!==void 0&&(R.key=S),g||v("show")||v("show:lazy")&&b.has(S)){b.has(S)||b.add(S);const x=!v("if");w.push(x?wt(R,[[St,g]]):R)}}),p?l(Ct,{name:`${p}-transition`,onBeforeLeave:y,onEnter:d,onAfterEnter:h},{default:()=>w}):w}function xe(e,s){return l(re,{ref:"addTabInstRef",key:"__addable",name:"__addable",internalCreatedByPane:!0,internalAddable:!0,internalLeftPadded:s,disabled:typeof e=="object"&&e.disabled})}function me(e){const s=Rt(e);return s.props?s.props.internalLeftPadded=!0:s.props={internalLeftPadded:!0},s}function ae(e){return Array.isArray(e.dynamicProps)?e.dynamicProps.includes("internalLeftPadded")||e.dynamicProps.push("internalLeftPadded"):e.dynamicProps=["internalLeftPadded"],e}export{It as _,re as a,Ft as b};
