import{V as ze,F as Ce}from"./FocusDetector-effeeed3.js";import{d as I,h as c,H as Y,aY as j,cN as Z,N as Oe,D as Fe,P as m,Q as F,aK as R,R as P,aL as Pe,b1 as Te,S as q,J as b,cO as _e,r as L,j as y,A as U,C as Le,aR as Be,aO as T,c3 as E,V as W,B as Ie,I as $e,M as Ke,aX as je,aS as Ee,K as Ve,an as De}from"./index-797c0a85.js";import{i as D,e as Ae}from"./Tooltip-271e10cc.js";import{a as He,h as J,_ as Ge}from"./Empty-aa248199.js";import{u as qe}from"./use-resize-d169ca1a.js";function V(e){const t=e.filter(i=>i!==void 0);if(t.length!==0)return t.length===1?t[0]:i=>{e.forEach(l=>{l&&l(i)})}}const Ue=I({name:"Checkmark",render(){return c("svg",{xmlns:"http://www.w3.org/2000/svg",viewBox:"0 0 16 16"},c("g",{fill:"none"},c("path",{d:"M14.046 3.486a.75.75 0 0 1-.032 1.06l-7.93 7.474a.85.85 0 0 1-1.188-.022l-2.68-2.72a.75.75 0 1 1 1.068-1.053l2.234 2.267l7.468-7.038a.75.75 0 0 1 1.06.032z",fill:"currentColor"})))}});function We(e,t){return c(Fe,{name:"fade-in-scale-up-transition"},{default:()=>e?c(Oe,{clsPrefix:t,class:`${t}-base-select-option__check`},{default:()=>c(Ue)}):null})}const Q=I({name:"NBaseSelectOption",props:{clsPrefix:{type:String,required:!0},tmNode:{type:Object,required:!0}},setup(e){const{valueRef:t,pendingTmNodeRef:i,multipleRef:l,valueSetRef:a,renderLabelRef:s,renderOptionRef:r,labelFieldRef:d,valueFieldRef:h,showCheckmarkRef:S,nodePropsRef:g,handleOptionClick:M,handleOptionMouseEnter:x}=Y(D),N=j(()=>{const{value:v}=i;return v?e.tmNode.key===v.key:!1});function u(v){const{tmNode:p}=e;p.disabled||M(v,p)}function k(v){const{tmNode:p}=e;p.disabled||x(v,p)}function _(v){const{tmNode:p}=e,{value:w}=N;p.disabled||w||x(v,p)}return{multiple:l,isGrouped:j(()=>{const{tmNode:v}=e,{parent:p}=v;return p&&p.rawNode.type==="group"}),showCheckmark:S,nodeProps:g,isPending:N,isSelected:j(()=>{const{value:v}=t,{value:p}=l;if(v===null)return!1;const w=e.tmNode.rawNode[h.value];if(p){const{value:$}=a;return $.has(w)}else return v===w}),labelField:d,renderLabel:s,renderOption:r,handleMouseMove:_,handleMouseEnter:k,handleClick:u}},render(){const{clsPrefix:e,tmNode:{rawNode:t},isSelected:i,isPending:l,isGrouped:a,showCheckmark:s,nodeProps:r,renderOption:d,renderLabel:h,handleClick:S,handleMouseEnter:g,handleMouseMove:M}=this,x=We(i,e),N=h?[h(t,i),s&&x]:[Z(t[this.labelField],t,i),s&&x],u=r==null?void 0:r(t),k=c("div",Object.assign({},u,{class:[`${e}-base-select-option`,t.class,u==null?void 0:u.class,{[`${e}-base-select-option--disabled`]:t.disabled,[`${e}-base-select-option--selected`]:i,[`${e}-base-select-option--grouped`]:a,[`${e}-base-select-option--pending`]:l,[`${e}-base-select-option--show-checkmark`]:s}],style:[(u==null?void 0:u.style)||"",t.style||""],onClick:V([S,u==null?void 0:u.onClick]),onMouseenter:V([g,u==null?void 0:u.onMouseenter]),onMousemove:V([M,u==null?void 0:u.onMousemove])}),c("div",{class:`${e}-base-select-option__content`},N));return t.render?t.render({node:k,option:t,selected:i}):d?d({node:k,option:t,selected:i}):k}}),X=I({name:"NBaseSelectGroupHeader",props:{clsPrefix:{type:String,required:!0},tmNode:{type:Object,required:!0}},setup(){const{renderLabelRef:e,renderOptionRef:t,labelFieldRef:i,nodePropsRef:l}=Y(D);return{labelField:i,nodeProps:l,renderLabel:e,renderOption:t}},render(){const{clsPrefix:e,renderLabel:t,renderOption:i,nodeProps:l,tmNode:{rawNode:a}}=this,s=l==null?void 0:l(a),r=t?t(a,!1):Z(a[this.labelField],a,!1),d=c("div",Object.assign({},s,{class:[`${e}-base-select-group-header`,s==null?void 0:s.class]}),r);return a.render?a.render({node:d,option:a}):i?i({node:d,option:a,selected:!1}):d}}),Je=m("base-select-menu",`
 line-height: 1.5;
 outline: none;
 z-index: 0;
 position: relative;
 border-radius: var(--n-border-radius);
 transition:
 background-color .3s var(--n-bezier),
 box-shadow .3s var(--n-bezier);
 background-color: var(--n-color);
`,[m("scrollbar",`
 max-height: var(--n-height);
 `),m("virtual-list",`
 max-height: var(--n-height);
 `),m("base-select-option",`
 min-height: var(--n-option-height);
 font-size: var(--n-option-font-size);
 display: flex;
 align-items: center;
 `,[F("content",`
 z-index: 1;
 white-space: nowrap;
 text-overflow: ellipsis;
 overflow: hidden;
 `)]),m("base-select-group-header",`
 min-height: var(--n-option-height);
 font-size: .93em;
 display: flex;
 align-items: center;
 `),m("base-select-menu-option-wrapper",`
 position: relative;
 width: 100%;
 `),F("loading, empty",`
 display: flex;
 padding: 12px 32px;
 flex: 1;
 justify-content: center;
 `),F("loading",`
 color: var(--n-loading-color);
 font-size: var(--n-loading-size);
 `),F("action",`
 padding: 8px var(--n-option-padding-left);
 font-size: var(--n-option-font-size);
 transition: 
 color .3s var(--n-bezier),
 border-color .3s var(--n-bezier);
 border-top: 1px solid var(--n-action-divider-color);
 color: var(--n-action-text-color);
 `),m("base-select-group-header",`
 position: relative;
 cursor: default;
 padding: var(--n-option-padding);
 color: var(--n-group-header-text-color);
 `),m("base-select-option",`
 cursor: pointer;
 position: relative;
 padding: var(--n-option-padding);
 transition:
 color .3s var(--n-bezier),
 opacity .3s var(--n-bezier);
 box-sizing: border-box;
 color: var(--n-option-text-color);
 opacity: 1;
 `,[R("show-checkmark",`
 padding-right: calc(var(--n-option-padding-right) + 20px);
 `),P("&::before",`
 content: "";
 position: absolute;
 left: 4px;
 right: 4px;
 top: 0;
 bottom: 0;
 border-radius: var(--n-border-radius);
 transition: background-color .3s var(--n-bezier);
 `),P("&:active",`
 color: var(--n-option-text-color-pressed);
 `),R("grouped",`
 padding-left: calc(var(--n-option-padding-left) * 1.5);
 `),R("pending",[P("&::before",`
 background-color: var(--n-option-color-pending);
 `)]),R("selected",`
 color: var(--n-option-text-color-active);
 `,[P("&::before",`
 background-color: var(--n-option-color-active);
 `),R("pending",[P("&::before",`
 background-color: var(--n-option-color-active-pending);
 `)])]),R("disabled",`
 cursor: not-allowed;
 `,[Pe("selected",`
 color: var(--n-option-text-color-disabled);
 `),R("selected",`
 opacity: var(--n-option-opacity-disabled);
 `)]),F("check",`
 font-size: 16px;
 position: absolute;
 right: calc(var(--n-option-padding-right) - 4px);
 top: calc(50% - 7px);
 color: var(--n-option-check-color);
 transition: color .3s var(--n-bezier);
 `,[Te({enterScale:"0.5"})])])]),nn=I({name:"InternalSelectMenu",props:Object.assign(Object.assign({},q.props),{clsPrefix:{type:String,required:!0},scrollable:{type:Boolean,default:!0},treeMate:{type:Object,required:!0},multiple:Boolean,size:{type:String,default:"medium"},value:{type:[String,Number,Array],default:null},autoPending:Boolean,virtualScroll:{type:Boolean,default:!0},show:{type:Boolean,default:!0},labelField:{type:String,default:"label"},valueField:{type:String,default:"value"},loading:Boolean,focusable:Boolean,renderLabel:Function,renderOption:Function,nodeProps:Function,showCheckmark:{type:Boolean,default:!0},onMousedown:Function,onScroll:Function,onFocus:Function,onBlur:Function,onKeyup:Function,onKeydown:Function,onTabOut:Function,onMouseenter:Function,onMouseleave:Function,onResize:Function,resetMenuOnOptionsChange:{type:Boolean,default:!0},inlineThemeDisabled:Boolean,onToggle:Function}),setup(e){const t=q("InternalSelectMenu","-internal-select-menu",Je,_e,e,b(e,"clsPrefix")),i=L(null),l=L(null),a=L(null),s=y(()=>e.treeMate.getFlattenedNodes()),r=y(()=>He(s.value)),d=L(null);function h(){const{treeMate:n}=e;let o=null;const{value:f}=e;f===null?o=n.getFirstAvailableNode():(e.multiple?o=n.getNode((f||[])[(f||[]).length-1]):o=n.getNode(f),(!o||o.disabled)&&(o=n.getFirstAvailableNode())),C(o||null)}function S(){const{value:n}=d;n&&!e.treeMate.getNode(n.key)&&(d.value=null)}let g;U(()=>e.show,n=>{n?g=U(()=>e.treeMate,()=>{e.resetMenuOnOptionsChange?(e.autoPending?h():S(),De(A)):S()},{immediate:!0}):g==null||g()},{immediate:!0}),Le(()=>{g==null||g()});const M=y(()=>Be(t.value.self[T("optionHeight",e.size)])),x=y(()=>E(t.value.self[T("padding",e.size)])),N=y(()=>e.multiple&&Array.isArray(e.value)?new Set(e.value):new Set),u=y(()=>{const n=s.value;return n&&n.length===0});function k(n){const{onToggle:o}=e;o&&o(n)}function _(n){const{onScroll:o}=e;o&&o(n)}function v(n){var o;(o=a.value)===null||o===void 0||o.sync(),_(n)}function p(){var n;(n=a.value)===null||n===void 0||n.sync()}function w(){const{value:n}=d;return n||null}function $(n,o){o.disabled||C(o,!1)}function ne(n,o){o.disabled||k(o)}function oe(n){var o;J(n,"action")||(o=e.onKeyup)===null||o===void 0||o.call(e,n)}function te(n){var o;J(n,"action")||(o=e.onKeydown)===null||o===void 0||o.call(e,n)}function ie(n){var o;(o=e.onMousedown)===null||o===void 0||o.call(e,n),!e.focusable&&n.preventDefault()}function le(){const{value:n}=d;n&&C(n.getNext({loop:!0}),!0)}function re(){const{value:n}=d;n&&C(n.getPrev({loop:!0}),!0)}function C(n,o=!1){d.value=n,o&&A()}function A(){var n,o;const f=d.value;if(!f)return;const O=r.value(f.key);O!==null&&(e.virtualScroll?(n=l.value)===null||n===void 0||n.scrollTo({index:O}):(o=a.value)===null||o===void 0||o.scrollTo({index:O,elSize:M.value}))}function ae(n){var o,f;!((o=i.value)===null||o===void 0)&&o.contains(n.target)&&((f=e.onFocus)===null||f===void 0||f.call(e,n))}function se(n){var o,f;!((o=i.value)===null||o===void 0)&&o.contains(n.relatedTarget)||(f=e.onBlur)===null||f===void 0||f.call(e,n)}W(D,{handleOptionMouseEnter:$,handleOptionClick:ne,valueSetRef:N,pendingTmNodeRef:d,nodePropsRef:b(e,"nodeProps"),showCheckmarkRef:b(e,"showCheckmark"),multipleRef:b(e,"multiple"),valueRef:b(e,"value"),renderLabelRef:b(e,"renderLabel"),renderOptionRef:b(e,"renderOption"),labelFieldRef:b(e,"labelField"),valueFieldRef:b(e,"valueField")}),W(Ae,i),Ie(()=>{const{value:n}=a;n&&n.sync()});const H=y(()=>{const{size:n}=e,{common:{cubicBezierEaseInOut:o},self:{height:f,borderRadius:O,color:ce,groupHeaderTextColor:ue,actionDividerColor:fe,optionTextColorPressed:ve,optionTextColor:pe,optionTextColorDisabled:ge,optionTextColorActive:he,optionOpacityDisabled:be,optionCheckColor:me,actionTextColor:ye,optionColorPending:xe,optionColorActive:ke,loadingColor:Re,loadingSize:Se,optionColorActivePending:Me,[T("optionFontSize",n)]:Ne,[T("optionHeight",n)]:we,[T("optionPadding",n)]:K}}=t.value;return{"--n-height":f,"--n-action-divider-color":fe,"--n-action-text-color":ye,"--n-bezier":o,"--n-border-radius":O,"--n-color":ce,"--n-option-font-size":Ne,"--n-group-header-text-color":ue,"--n-option-check-color":me,"--n-option-color-pending":xe,"--n-option-color-active":ke,"--n-option-color-active-pending":Me,"--n-option-height":we,"--n-option-opacity-disabled":be,"--n-option-text-color":pe,"--n-option-text-color-active":he,"--n-option-text-color-disabled":ge,"--n-option-text-color-pressed":ve,"--n-option-padding":K,"--n-option-padding-left":E(K,"left"),"--n-option-padding-right":E(K,"right"),"--n-loading-color":Re,"--n-loading-size":Se}}),{inlineThemeDisabled:G}=e,z=G?$e("internal-select-menu",y(()=>e.size[0]),H,e):void 0,de={selfRef:i,next:le,prev:re,getPendingTmNode:w};return qe(i,e.onResize),Object.assign({mergedTheme:t,virtualListRef:l,scrollbarRef:a,itemSize:M,padding:x,flattenedNodes:s,empty:u,virtualListContainer(){const{value:n}=l;return n==null?void 0:n.listElRef},virtualListContent(){const{value:n}=l;return n==null?void 0:n.itemsElRef},doScroll:_,handleFocusin:ae,handleFocusout:se,handleKeyUp:oe,handleKeyDown:te,handleMouseDown:ie,handleVirtualListResize:p,handleVirtualListScroll:v,cssVars:G?void 0:H,themeClass:z==null?void 0:z.themeClass,onRender:z==null?void 0:z.onRender},de)},render(){const{$slots:e,virtualScroll:t,clsPrefix:i,mergedTheme:l,themeClass:a,onRender:s}=this;return s==null||s(),c("div",{ref:"selfRef",tabindex:this.focusable?0:-1,class:[`${i}-base-select-menu`,a,this.multiple&&`${i}-base-select-menu--multiple`],style:this.cssVars,onFocusin:this.handleFocusin,onFocusout:this.handleFocusout,onKeyup:this.handleKeyUp,onKeydown:this.handleKeyDown,onMousedown:this.handleMouseDown,onMouseenter:this.onMouseenter,onMouseleave:this.onMouseleave},this.loading?c("div",{class:`${i}-base-select-menu__loading`},c(je,{clsPrefix:i,strokeWidth:20})):this.empty?c("div",{class:`${i}-base-select-menu__empty`,"data-empty":!0,"data-action":!0},Ve(e.empty,()=>[c(Ge,{theme:l.peers.Empty,themeOverrides:l.peerOverrides.Empty})])):c(Ee,{ref:"scrollbarRef",theme:l.peers.Scrollbar,themeOverrides:l.peerOverrides.Scrollbar,scrollable:this.scrollable,container:t?this.virtualListContainer:void 0,content:t?this.virtualListContent:void 0,onScroll:t?void 0:this.doScroll},{default:()=>t?c(ze,{ref:"virtualListRef",class:`${i}-virtual-list`,items:this.flattenedNodes,itemSize:this.itemSize,showScrollbar:!1,paddingTop:this.padding.top,paddingBottom:this.padding.bottom,onResize:this.handleVirtualListResize,onScroll:this.handleVirtualListScroll,itemResizable:!0},{default:({item:r})=>r.isGroup?c(X,{key:r.key,clsPrefix:i,tmNode:r}):r.ignored?null:c(Q,{clsPrefix:i,key:r.key,tmNode:r})}):c("div",{class:`${i}-base-select-menu-option-wrapper`,style:{paddingTop:this.padding.top,paddingBottom:this.padding.bottom}},this.flattenedNodes.map(r=>r.isGroup?c(X,{key:r.key,clsPrefix:i,tmNode:r}):c(Q,{clsPrefix:i,key:r.key,tmNode:r})))}),Ke(e.action,r=>r&&[c("div",{class:`${i}-base-select-menu__action`,"data-action":!0,key:"action"},r),c(Ce,{onFocus:this.onTabOut,key:"focus-detector"})]))}});function B(e){return e.type==="group"}function ee(e){return e.type==="ignored"}function on(e,t){try{return!!(1+t.toString().toLowerCase().indexOf(e.trim().toLowerCase()))}catch(i){return!1}}function tn(e,t){return{getIsGroup:B,getIgnored:ee,getKey(l){return B(l)?l.name||l.key||"key-required":l[e]},getChildren(l){return l[t]}}}function ln(e,t,i,l){if(!t)return e;function a(s){if(!Array.isArray(s))return[];const r=[];for(const d of s)if(B(d)){const h=a(d[l]);h.length&&r.push(Object.assign({},d,{[l]:h}))}else{if(ee(d))continue;t(i,d)&&r.push(d)}return r}return a(e)}function rn(e,t,i){const l=new Map;return e.forEach(a=>{B(a)?a[i].forEach(s=>{l.set(s[t],s)}):l.set(a[t],a)}),l}export{Ue as F,nn as N,rn as a,tn as c,ln as f,V as m,on as p};
