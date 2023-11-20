import{d as oe,r as c,cd as ft,B as ne,an as re,h as r,at as vt,R as L,P as l,Q as a,aL as X,aK as A,S as Z,J as U,dc as pt,j as M,cN as N,A as V,k as gt,aO as ee,I as wt,dd as mt,ac as xt}from"./index-797c0a85.js";import{N as Ct}from"./Input-c8aa899c.js";import{_ as q}from"./Tag-274eae2a.js";import{f as yt,h as $t,_ as _t}from"./Tooltip-271e10cc.js";import{g as Rt}from"./attribute-2ee9e579.js";import{u as Ft}from"./use-resize-d169ca1a.js";const P="v-hidden",It=$t("[v-hidden]",{display:"none!important"}),te=oe({name:"Overflow",props:{getCounter:Function,getTail:Function,updateCounter:Function,onUpdateOverflow:Function},setup(t,{slots:T}){const b=c(null),u=c(null);function C(){const{value:w}=b,{getCounter:n,getTail:F}=t;let s;if(n!==void 0?s=n():s=u.value,!w||!s)return;s.hasAttribute(P)&&s.removeAttribute(P);const{children:m}=w,f=w.offsetWidth,v=[],p=T.tail?F==null?void 0:F():null;let x=p?p.offsetWidth:0,I=!1;const y=w.children.length-(T.tail?1:0);for(let i=0;i<y-1;++i){if(i<0)continue;const $=m[i];if(I){$.hasAttribute(P)||$.setAttribute(P,"");continue}else $.hasAttribute(P)&&$.removeAttribute(P);const z=$.offsetWidth;if(x+=z,v[i]=z,x>f){const{updateCounter:O}=t;for(let _=i;_>=0;--_){const S=y-1-_;O!==void 0?O(S):s.textContent=`${S}`;const E=s.offsetWidth;if(x-=v[_],x+E<=f||_===0){I=!0,i=_-1,p&&(i===-1?(p.style.maxWidth=`${f-E}px`,p.style.boxSizing="border-box"):p.style.maxWidth="");break}}}}const{onUpdateOverflow:h}=t;I?h!==void 0&&h(!0):(h!==void 0&&h(!1),s.setAttribute(P,""))}const R=ft();return It.mount({id:"vueuc/overflow",head:!0,anchorMetaName:yt,ssr:R}),ne(C),{selfRef:b,counterRef:u,sync:C}},render(){const{$slots:t}=this;return re(this.sync),r("div",{class:"v-overflow",ref:"selfRef"},[vt(t,"default"),t.counter?t.counter():r("span",{style:{display:"inline-block"},ref:"counterRef"}),t.tail?t.tail():null])}}),Tt=L([l("base-selection",`
 position: relative;
 z-index: auto;
 box-shadow: none;
 width: 100%;
 max-width: 100%;
 display: inline-block;
 vertical-align: bottom;
 border-radius: var(--n-border-radius);
 min-height: var(--n-height);
 line-height: 1.5;
 font-size: var(--n-font-size);
 `,[l("base-loading",`
 color: var(--n-loading-color);
 `),l("base-selection-tags","min-height: var(--n-height);"),a("border, state-border",`
 position: absolute;
 left: 0;
 right: 0;
 top: 0;
 bottom: 0;
 pointer-events: none;
 border: var(--n-border);
 border-radius: inherit;
 transition:
 box-shadow .3s var(--n-bezier),
 border-color .3s var(--n-bezier);
 `),a("state-border",`
 z-index: 1;
 border-color: #0000;
 `),l("base-suffix",`
 cursor: pointer;
 position: absolute;
 top: 50%;
 transform: translateY(-50%);
 right: 10px;
 `,[a("arrow",`
 font-size: var(--n-arrow-size);
 color: var(--n-arrow-color);
 transition: color .3s var(--n-bezier);
 `)]),l("base-selection-overlay",`
 display: flex;
 align-items: center;
 white-space: nowrap;
 pointer-events: none;
 position: absolute;
 top: 0;
 right: 0;
 bottom: 0;
 left: 0;
 padding: var(--n-padding-single);
 transition: color .3s var(--n-bezier);
 `,[a("wrapper",`
 flex-basis: 0;
 flex-grow: 1;
 overflow: hidden;
 text-overflow: ellipsis;
 `)]),l("base-selection-placeholder",`
 color: var(--n-placeholder-color);
 `,[a("inner",`
 max-width: 100%;
 overflow: hidden;
 `)]),l("base-selection-tags",`
 cursor: pointer;
 outline: none;
 box-sizing: border-box;
 position: relative;
 z-index: auto;
 display: flex;
 padding: var(--n-padding-multiple);
 flex-wrap: wrap;
 align-items: center;
 width: 100%;
 vertical-align: bottom;
 background-color: var(--n-color);
 border-radius: inherit;
 transition:
 color .3s var(--n-bezier),
 box-shadow .3s var(--n-bezier),
 background-color .3s var(--n-bezier);
 `),l("base-selection-label",`
 height: var(--n-height);
 display: inline-flex;
 width: 100%;
 vertical-align: bottom;
 cursor: pointer;
 outline: none;
 z-index: auto;
 box-sizing: border-box;
 position: relative;
 transition:
 color .3s var(--n-bezier),
 box-shadow .3s var(--n-bezier),
 background-color .3s var(--n-bezier);
 border-radius: inherit;
 background-color: var(--n-color);
 align-items: center;
 `,[l("base-selection-input",`
 font-size: inherit;
 line-height: inherit;
 outline: none;
 cursor: pointer;
 box-sizing: border-box;
 border:none;
 width: 100%;
 padding: var(--n-padding-single);
 background-color: #0000;
 color: var(--n-text-color);
 transition: color .3s var(--n-bezier);
 caret-color: var(--n-caret-color);
 `,[a("content",`
 text-overflow: ellipsis;
 overflow: hidden;
 white-space: nowrap; 
 `)]),a("render-label",`
 color: var(--n-text-color);
 `)]),X("disabled",[L("&:hover",[a("state-border",`
 box-shadow: var(--n-box-shadow-hover);
 border: var(--n-border-hover);
 `)]),A("focus",[a("state-border",`
 box-shadow: var(--n-box-shadow-focus);
 border: var(--n-border-focus);
 `)]),A("active",[a("state-border",`
 box-shadow: var(--n-box-shadow-active);
 border: var(--n-border-active);
 `),l("base-selection-label","background-color: var(--n-color-active);"),l("base-selection-tags","background-color: var(--n-color-active);")])]),A("disabled","cursor: not-allowed;",[a("arrow",`
 color: var(--n-arrow-color-disabled);
 `),l("base-selection-label",`
 cursor: not-allowed;
 background-color: var(--n-color-disabled);
 `,[l("base-selection-input",`
 cursor: not-allowed;
 color: var(--n-text-color-disabled);
 `),a("render-label",`
 color: var(--n-text-color-disabled);
 `)]),l("base-selection-tags",`
 cursor: not-allowed;
 background-color: var(--n-color-disabled);
 `),l("base-selection-placeholder",`
 cursor: not-allowed;
 color: var(--n-placeholder-color-disabled);
 `)]),l("base-selection-input-tag",`
 height: calc(var(--n-height) - 6px);
 line-height: calc(var(--n-height) - 6px);
 outline: none;
 display: none;
 position: relative;
 margin-bottom: 3px;
 max-width: 100%;
 vertical-align: bottom;
 `,[a("input",`
 font-size: inherit;
 font-family: inherit;
 min-width: 1px;
 padding: 0;
 background-color: #0000;
 outline: none;
 border: none;
 max-width: 100%;
 overflow: hidden;
 width: 1em;
 line-height: inherit;
 cursor: pointer;
 color: var(--n-text-color);
 caret-color: var(--n-caret-color);
 `),a("mirror",`
 position: absolute;
 left: 0;
 top: 0;
 white-space: pre;
 visibility: hidden;
 user-select: none;
 -webkit-user-select: none;
 opacity: 0;
 `)]),["warning","error"].map(t=>A(`${t}-status`,[a("state-border",`border: var(--n-border-${t});`),X("disabled",[L("&:hover",[a("state-border",`
 box-shadow: var(--n-box-shadow-hover-${t});
 border: var(--n-border-hover-${t});
 `)]),A("active",[a("state-border",`
 box-shadow: var(--n-box-shadow-active-${t});
 border: var(--n-border-active-${t});
 `),l("base-selection-label",`background-color: var(--n-color-active-${t});`),l("base-selection-tags",`background-color: var(--n-color-active-${t});`)]),A("focus",[a("state-border",`
 box-shadow: var(--n-box-shadow-focus-${t});
 border: var(--n-border-focus-${t});
 `)])])]))]),l("base-selection-popover",`
 margin-bottom: -3px;
 display: flex;
 flex-wrap: wrap;
 margin-right: -8px;
 `),l("base-selection-tag-wrapper",`
 max-width: 100%;
 display: inline-flex;
 padding: 0 7px 3px 0;
 `,[L("&:last-child","padding-right: 0;"),l("tag",`
 font-size: 14px;
 max-width: 100%;
 `,[a("content",`
 line-height: 1.25;
 text-overflow: ellipsis;
 overflow: hidden;
 `)])])]),At=oe({name:"InternalSelection",props:Object.assign(Object.assign({},Z.props),{clsPrefix:{type:String,required:!0},bordered:{type:Boolean,default:void 0},active:Boolean,pattern:{type:String,default:""},placeholder:String,selectedOption:{type:Object,default:null},selectedOptions:{type:Array,default:null},labelField:{type:String,default:"label"},valueField:{type:String,default:"value"},multiple:Boolean,filterable:Boolean,clearable:Boolean,disabled:Boolean,size:{type:String,default:"medium"},loading:Boolean,autofocus:Boolean,showArrow:{type:Boolean,default:!0},inputProps:Object,focused:Boolean,renderTag:Function,onKeydown:Function,onClick:Function,onBlur:Function,onFocus:Function,onDeleteOption:Function,maxTagCount:[String,Number],onClear:Function,onPatternInput:Function,onPatternFocus:Function,onPatternBlur:Function,renderLabel:Function,status:String,inlineThemeDisabled:Boolean,ignoreComposition:{type:Boolean,default:!0},onResize:Function}),setup(t){const T=c(null),b=c(null),u=c(null),C=c(null),R=c(null),w=c(null),n=c(null),F=c(null),s=c(null),m=c(null),f=c(!1),v=c(!1),p=c(!1),x=Z("InternalSelection","-internal-selection",Tt,pt,t,U(t,"clsPrefix")),I=M(()=>t.clearable&&!t.disabled&&(p.value||t.active)),y=M(()=>t.selectedOption?t.renderTag?t.renderTag({option:t.selectedOption,handleClose:()=>{}}):t.renderLabel?t.renderLabel(t.selectedOption,!0):N(t.selectedOption[t.labelField],t.selectedOption,!0):t.placeholder),h=M(()=>{const e=t.selectedOption;if(e)return e[t.labelField]}),i=M(()=>t.multiple?!!(Array.isArray(t.selectedOptions)&&t.selectedOptions.length):t.selectedOption!==null);function $(){var e;const{value:o}=T;if(o){const{value:d}=b;d&&(d.style.width=`${o.offsetWidth}px`,t.maxTagCount!=="responsive"&&((e=s.value)===null||e===void 0||e.sync()))}}function z(){const{value:e}=m;e&&(e.style.display="none")}function O(){const{value:e}=m;e&&(e.style.display="inline-block")}V(U(t,"active"),e=>{e||z()}),V(U(t,"pattern"),()=>{t.multiple&&re($)});function _(e){const{onFocus:o}=t;o&&o(e)}function S(e){const{onBlur:o}=t;o&&o(e)}function E(e){const{onDeleteOption:o}=t;o&&o(e)}function J(e){const{onClear:o}=t;o&&o(e)}function B(e){const{onPatternInput:o}=t;o&&o(e)}function D(e){var o;(!e.relatedTarget||!(!((o=u.value)===null||o===void 0)&&o.contains(e.relatedTarget)))&&_(e)}function g(e){var o;!((o=u.value)===null||o===void 0)&&o.contains(e.relatedTarget)||S(e)}function le(e){J(e)}function ie(){p.value=!0}function ae(){p.value=!1}function se(e){!t.active||!t.filterable||e.target!==b.value&&e.preventDefault()}function Q(e){E(e)}function de(e){if(e.key==="Backspace"&&!W.value&&!t.pattern.length){const{selectedOptions:o}=t;o!=null&&o.length&&Q(o[o.length-1])}}const W=c(!1);let j=null;function ce(e){const{value:o}=T;if(o){const d=e.target.value;o.textContent=d,$()}t.ignoreComposition&&W.value?j=e:B(e)}function ue(){W.value=!0}function he(){W.value=!1,t.ignoreComposition&&B(j),j=null}function be(e){var o;v.value=!0,(o=t.onPatternFocus)===null||o===void 0||o.call(t,e)}function fe(e){var o;v.value=!1,(o=t.onPatternBlur)===null||o===void 0||o.call(t,e)}function ve(){var e,o;if(t.filterable)v.value=!1,(e=w.value)===null||e===void 0||e.blur(),(o=b.value)===null||o===void 0||o.blur();else if(t.multiple){const{value:d}=C;d==null||d.blur()}else{const{value:d}=R;d==null||d.blur()}}function pe(){var e,o,d;t.filterable?(v.value=!1,(e=w.value)===null||e===void 0||e.focus()):t.multiple?(o=C.value)===null||o===void 0||o.focus():(d=R.value)===null||d===void 0||d.focus()}function ge(){const{value:e}=b;e&&(O(),e.focus())}function we(){const{value:e}=b;e&&e.blur()}function me(e){const{value:o}=n;o&&o.setTextContent(`+${e}`)}function xe(){const{value:e}=F;return e}function Ce(){return b.value}let H=null;function K(){H!==null&&window.clearTimeout(H)}function ye(){t.active||(K(),H=window.setTimeout(()=>{i.value&&(f.value=!0)},100))}function $e(){K()}function _e(e){e||(K(),f.value=!1)}V(i,e=>{e||(f.value=!1)}),ne(()=>{gt(()=>{const e=w.value;e&&(t.disabled?e.removeAttribute("tabindex"):e.tabIndex=v.value?-1:0)})}),Ft(u,t.onResize);const{inlineThemeDisabled:Y}=t,G=M(()=>{const{size:e}=t,{common:{cubicBezierEaseInOut:o},self:{borderRadius:d,color:Re,placeholderColor:Fe,textColor:Ie,paddingSingle:Te,paddingMultiple:ze,caretColor:Oe,colorDisabled:Pe,textColorDisabled:Se,placeholderColorDisabled:Ee,colorActive:ke,boxShadowFocus:Ae,boxShadowActive:Me,boxShadowHover:Be,border:We,borderFocus:De,borderHover:Le,borderActive:Ne,arrowColor:je,arrowColorDisabled:He,loadingColor:Ke,colorActiveWarning:Ue,boxShadowFocusWarning:Ve,boxShadowActiveWarning:qe,boxShadowHoverWarning:Je,borderWarning:Qe,borderFocusWarning:Ye,borderHoverWarning:Ge,borderActiveWarning:Xe,colorActiveError:Ze,boxShadowFocusError:et,boxShadowActiveError:tt,boxShadowHoverError:ot,borderError:nt,borderFocusError:rt,borderHoverError:lt,borderActiveError:it,clearColor:at,clearColorHover:st,clearColorPressed:dt,clearSize:ct,arrowSize:ut,[ee("height",e)]:ht,[ee("fontSize",e)]:bt}}=x.value;return{"--n-bezier":o,"--n-border":We,"--n-border-active":Ne,"--n-border-focus":De,"--n-border-hover":Le,"--n-border-radius":d,"--n-box-shadow-active":Me,"--n-box-shadow-focus":Ae,"--n-box-shadow-hover":Be,"--n-caret-color":Oe,"--n-color":Re,"--n-color-active":ke,"--n-color-disabled":Pe,"--n-font-size":bt,"--n-height":ht,"--n-padding-single":Te,"--n-padding-multiple":ze,"--n-placeholder-color":Fe,"--n-placeholder-color-disabled":Ee,"--n-text-color":Ie,"--n-text-color-disabled":Se,"--n-arrow-color":je,"--n-arrow-color-disabled":He,"--n-loading-color":Ke,"--n-color-active-warning":Ue,"--n-box-shadow-focus-warning":Ve,"--n-box-shadow-active-warning":qe,"--n-box-shadow-hover-warning":Je,"--n-border-warning":Qe,"--n-border-focus-warning":Ye,"--n-border-hover-warning":Ge,"--n-border-active-warning":Xe,"--n-color-active-error":Ze,"--n-box-shadow-focus-error":et,"--n-box-shadow-active-error":tt,"--n-box-shadow-hover-error":ot,"--n-border-error":nt,"--n-border-focus-error":rt,"--n-border-hover-error":lt,"--n-border-active-error":it,"--n-clear-size":ct,"--n-clear-color":at,"--n-clear-color-hover":st,"--n-clear-color-pressed":dt,"--n-arrow-size":ut}}),k=Y?wt("internal-selection",M(()=>t.size[0]),G,t):void 0;return{mergedTheme:x,mergedClearable:I,patternInputFocused:v,filterablePlaceholder:y,label:h,selected:i,showTagsPanel:f,isComposing:W,counterRef:n,counterWrapperRef:F,patternInputMirrorRef:T,patternInputRef:b,selfRef:u,multipleElRef:C,singleElRef:R,patternInputWrapperRef:w,overflowRef:s,inputTagElRef:m,handleMouseDown:se,handleFocusin:D,handleClear:le,handleMouseEnter:ie,handleMouseLeave:ae,handleDeleteOption:Q,handlePatternKeyDown:de,handlePatternInputInput:ce,handlePatternInputBlur:fe,handlePatternInputFocus:be,handleMouseEnterCounter:ye,handleMouseLeaveCounter:$e,handleFocusout:g,handleCompositionEnd:he,handleCompositionStart:ue,onPopoverUpdateShow:_e,focus:pe,focusInput:ge,blur:ve,blurInput:we,updateCounter:me,getCounter:xe,getTail:Ce,renderLabel:t.renderLabel,cssVars:Y?void 0:G,themeClass:k==null?void 0:k.themeClass,onRender:k==null?void 0:k.onRender}},render(){const{status:t,multiple:T,size:b,disabled:u,filterable:C,maxTagCount:R,bordered:w,clsPrefix:n,onRender:F,renderTag:s,renderLabel:m}=this;F==null||F();const f=R==="responsive",v=typeof R=="number",p=f||v,x=r(mt,null,{default:()=>r(Ct,{clsPrefix:n,loading:this.loading,showArrow:this.showArrow,showClear:this.mergedClearable&&this.selected,onClear:this.handleClear},{default:()=>{var y,h;return(h=(y=this.$slots).arrow)===null||h===void 0?void 0:h.call(y)}})});let I;if(T){const{labelField:y}=this,h=g=>r("div",{class:`${n}-base-selection-tag-wrapper`,key:g.value},s?s({option:g,handleClose:()=>{this.handleDeleteOption(g)}}):r(q,{size:b,closable:!g.disabled,disabled:u,onClose:()=>{this.handleDeleteOption(g)},internalCloseIsButtonTag:!1,internalCloseFocusable:!1},{default:()=>m?m(g,!0):N(g[y],g,!0)})),i=()=>(v?this.selectedOptions.slice(0,R):this.selectedOptions).map(h),$=C?r("div",{class:`${n}-base-selection-input-tag`,ref:"inputTagElRef",key:"__input-tag__"},r("input",Object.assign({},this.inputProps,{ref:"patternInputRef",tabindex:-1,disabled:u,value:this.pattern,autofocus:this.autofocus,class:`${n}-base-selection-input-tag__input`,onBlur:this.handlePatternInputBlur,onFocus:this.handlePatternInputFocus,onKeydown:this.handlePatternKeyDown,onInput:this.handlePatternInputInput,onCompositionstart:this.handleCompositionStart,onCompositionend:this.handleCompositionEnd})),r("span",{ref:"patternInputMirrorRef",class:`${n}-base-selection-input-tag__mirror`},this.pattern)):null,z=f?()=>r("div",{class:`${n}-base-selection-tag-wrapper`,ref:"counterWrapperRef"},r(q,{size:b,ref:"counterRef",onMouseenter:this.handleMouseEnterCounter,onMouseleave:this.handleMouseLeaveCounter,disabled:u})):void 0;let O;if(v){const g=this.selectedOptions.length-R;g>0&&(O=r("div",{class:`${n}-base-selection-tag-wrapper`,key:"__counter__"},r(q,{size:b,ref:"counterRef",onMouseenter:this.handleMouseEnterCounter,disabled:u},{default:()=>`+${g}`})))}const _=f?C?r(te,{ref:"overflowRef",updateCounter:this.updateCounter,getCounter:this.getCounter,getTail:this.getTail,style:{width:"100%",display:"flex",overflow:"hidden"}},{default:i,counter:z,tail:()=>$}):r(te,{ref:"overflowRef",updateCounter:this.updateCounter,getCounter:this.getCounter,style:{width:"100%",display:"flex",overflow:"hidden"}},{default:i,counter:z}):v?i().concat(O):i(),S=p?()=>r("div",{class:`${n}-base-selection-popover`},f?i():this.selectedOptions.map(h)):void 0,E=p?{show:this.showTagsPanel,trigger:"hover",overlap:!0,placement:"top",width:"trigger",onUpdateShow:this.onPopoverUpdateShow,theme:this.mergedTheme.peers.Popover,themeOverrides:this.mergedTheme.peerOverrides.Popover}:null,B=(this.selected?!1:this.active?!this.pattern&&!this.isComposing:!0)?r("div",{class:`${n}-base-selection-placeholder ${n}-base-selection-overlay`},r("div",{class:`${n}-base-selection-placeholder__inner`},this.placeholder)):null,D=C?r("div",{ref:"patternInputWrapperRef",class:`${n}-base-selection-tags`},_,f?null:$,x):r("div",{ref:"multipleElRef",class:`${n}-base-selection-tags`,tabindex:u?void 0:0},_,x);I=r(xt,null,p?r(_t,Object.assign({},E,{scrollable:!0,style:"max-height: calc(var(--v-target-height) * 6.6);"}),{trigger:()=>D,default:S}):D,B)}else if(C){const y=this.pattern||this.isComposing,h=this.active?!y:!this.selected,i=this.active?!1:this.selected;I=r("div",{ref:"patternInputWrapperRef",class:`${n}-base-selection-label`},r("input",Object.assign({},this.inputProps,{ref:"patternInputRef",class:`${n}-base-selection-input`,value:this.active?this.pattern:"",placeholder:"",readonly:u,disabled:u,tabindex:-1,autofocus:this.autofocus,onFocus:this.handlePatternInputFocus,onBlur:this.handlePatternInputBlur,onInput:this.handlePatternInputInput,onCompositionstart:this.handleCompositionStart,onCompositionend:this.handleCompositionEnd})),i?r("div",{class:`${n}-base-selection-label__render-label ${n}-base-selection-overlay`,key:"input"},r("div",{class:`${n}-base-selection-overlay__wrapper`},s?s({option:this.selectedOption,handleClose:()=>{}}):m?m(this.selectedOption,!0):N(this.label,this.selectedOption,!0))):null,h?r("div",{class:`${n}-base-selection-placeholder ${n}-base-selection-overlay`,key:"placeholder"},r("div",{class:`${n}-base-selection-overlay__wrapper`},this.filterablePlaceholder)):null,x)}else I=r("div",{ref:"singleElRef",class:`${n}-base-selection-label`,tabindex:this.disabled?void 0:0},this.label!==void 0?r("div",{class:`${n}-base-selection-input`,title:Rt(this.label),key:"input"},r("div",{class:`${n}-base-selection-input__content`},s?s({option:this.selectedOption,handleClose:()=>{}}):m?m(this.selectedOption,!0):N(this.label,this.selectedOption,!0))):r("div",{class:`${n}-base-selection-placeholder ${n}-base-selection-overlay`,key:"placeholder"},r("div",{class:`${n}-base-selection-placeholder__inner`},this.placeholder)),x);return r("div",{ref:"selfRef",class:[`${n}-base-selection`,this.themeClass,t&&`${n}-base-selection--${t}-status`,{[`${n}-base-selection--active`]:this.active,[`${n}-base-selection--selected`]:this.selected||this.active&&this.pattern,[`${n}-base-selection--disabled`]:this.disabled,[`${n}-base-selection--multiple`]:this.multiple,[`${n}-base-selection--focus`]:this.focused}],style:this.cssVars,onClick:this.onClick,onMouseenter:this.handleMouseEnter,onMouseleave:this.handleMouseLeave,onKeydown:this.onKeydown,onFocusin:this.handleFocusin,onFocusout:this.handleFocusout,onMousedown:this.handleMouseDown},I,w?r("div",{class:`${n}-base-selection__border`}):null,w?r("div",{class:`${n}-base-selection__state-border`}):null)}});export{At as N};
