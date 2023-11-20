import{P as s,R as u,Q as t,d as E,G as A,aQ as ue,h as o,aL as V,aK as a,S as T,dl as he,j as B,I as X,ac as be,b2 as G,dm as fe,c2 as pe,r as O,J as ge,aO as y,aV as H,aR as p,cE as M,M as k,aW as ve,aX as me,Z as U}from"./index-797c0a85.js";import{u as we}from"./Tooltip-271e10cc.js";const xe=s("input-group",`
 display: inline-flex;
 width: 100%;
 flex-wrap: nowrap;
 vertical-align: bottom;
`,[u(">",[s("input",[u("&:not(:last-child)",`
 border-top-right-radius: 0!important;
 border-bottom-right-radius: 0!important;
 `),u("&:not(:first-child)",`
 border-top-left-radius: 0!important;
 border-bottom-left-radius: 0!important;
 margin-left: -1px!important;
 `)]),s("button",[u("&:not(:last-child)",`
 border-top-right-radius: 0!important;
 border-bottom-right-radius: 0!important;
 `,[t("state-border, border",`
 border-top-right-radius: 0!important;
 border-bottom-right-radius: 0!important;
 `)]),u("&:not(:first-child)",`
 border-top-left-radius: 0!important;
 border-bottom-left-radius: 0!important;
 `,[t("state-border, border",`
 border-top-left-radius: 0!important;
 border-bottom-left-radius: 0!important;
 `)])]),u("*",[u("&:not(:last-child)",`
 border-top-right-radius: 0!important;
 border-bottom-right-radius: 0!important;
 `,[u(">",[s("input",`
 border-top-right-radius: 0!important;
 border-bottom-right-radius: 0!important;
 `),s("base-selection",[s("base-selection-label",`
 border-top-right-radius: 0!important;
 border-bottom-right-radius: 0!important;
 `),s("base-selection-tags",`
 border-top-right-radius: 0!important;
 border-bottom-right-radius: 0!important;
 `),t("box-shadow, border, state-border",`
 border-top-right-radius: 0!important;
 border-bottom-right-radius: 0!important;
 `)])])]),u("&:not(:first-child)",`
 margin-left: -1px!important;
 border-top-left-radius: 0!important;
 border-bottom-left-radius: 0!important;
 `,[u(">",[s("input",`
 border-top-left-radius: 0!important;
 border-bottom-left-radius: 0!important;
 `),s("base-selection",[s("base-selection-label",`
 border-top-left-radius: 0!important;
 border-bottom-left-radius: 0!important;
 `),s("base-selection-tags",`
 border-top-left-radius: 0!important;
 border-bottom-left-radius: 0!important;
 `),t("box-shadow, border, state-border",`
 border-top-left-radius: 0!important;
 border-bottom-left-radius: 0!important;
 `)])])])])])]),ye={},ze=E({name:"InputGroup",props:ye,setup(e){const{mergedClsPrefixRef:l}=A(e);return ue("-input-group",xe,l),{mergedClsPrefix:l}},render(){const{mergedClsPrefix:e}=this;return o("div",{class:`${e}-input-group`},this.$slots)}}),ke=s("divider",`
 position: relative;
 display: flex;
 width: 100%;
 box-sizing: border-box;
 font-size: 16px;
 color: var(--n-text-color);
 transition:
 color .3s var(--n-bezier),
 background-color .3s var(--n-bezier);
`,[V("vertical",`
 margin-top: 24px;
 margin-bottom: 24px;
 `,[V("no-title",`
 display: flex;
 align-items: center;
 `)]),t("title",`
 display: flex;
 align-items: center;
 margin-left: 12px;
 margin-right: 12px;
 white-space: nowrap;
 font-weight: var(--n-font-weight);
 `),a("title-position-left",[t("line",[a("left",{width:"28px"})])]),a("title-position-right",[t("line",[a("right",{width:"28px"})])]),a("dashed",[t("line",`
 background-color: #0000;
 height: 0px;
 width: 100%;
 border-style: dashed;
 border-width: 1px 0 0;
 `)]),a("vertical",`
 display: inline-block;
 height: 1em;
 margin: 0 8px;
 vertical-align: middle;
 width: 1px;
 `),t("line",`
 border: none;
 transition: background-color .3s var(--n-bezier), border-color .3s var(--n-bezier);
 height: 1px;
 width: 100%;
 margin: 0;
 `),V("dashed",[t("line",{backgroundColor:"var(--n-color)"})]),a("dashed",[t("line",{borderColor:"var(--n-color)"})]),a("vertical",{backgroundColor:"var(--n-color)"})]),$e=Object.assign(Object.assign({},T.props),{titlePlacement:{type:String,default:"center"},dashed:Boolean,vertical:Boolean}),Be=E({name:"Divider",props:$e,setup(e){const{mergedClsPrefixRef:l,inlineThemeDisabled:h}=A(e),b=T("Divider","-divider",ke,he,e,l),d=B(()=>{const{common:{cubicBezierEaseInOut:r},self:{color:x,textColor:$,fontWeight:f}}=b.value;return{"--n-bezier":r,"--n-color":x,"--n-text-color":$,"--n-font-weight":f}}),c=h?X("divider",void 0,d,e):void 0;return{mergedClsPrefix:l,cssVars:h?void 0:d,themeClass:c==null?void 0:c.themeClass,onRender:c==null?void 0:c.onRender}},render(){var e;const{$slots:l,titlePlacement:h,vertical:b,dashed:d,cssVars:c,mergedClsPrefix:r}=this;return(e=this.onRender)===null||e===void 0||e.call(this),o("div",{role:"separator",class:[`${r}-divider`,this.themeClass,{[`${r}-divider--vertical`]:b,[`${r}-divider--no-title`]:!l.default,[`${r}-divider--dashed`]:d,[`${r}-divider--title-position-${h}`]:l.default&&h}],style:c},b?null:o("div",{class:`${r}-divider__line ${r}-divider__line--left`}),!b&&l.default?o(be,null,o("div",{class:`${r}-divider__title`},this.$slots),o("div",{class:`${r}-divider__line ${r}-divider__line--right`})):null)}}),_e=s("switch",`
 height: var(--n-height);
 min-width: var(--n-width);
 vertical-align: middle;
 user-select: none;
 -webkit-user-select: none;
 display: inline-flex;
 outline: none;
 justify-content: center;
 align-items: center;
`,[t("children-placeholder",`
 height: var(--n-rail-height);
 display: flex;
 flex-direction: column;
 overflow: hidden;
 pointer-events: none;
 visibility: hidden;
 `),t("rail-placeholder",`
 display: flex;
 flex-wrap: none;
 `),t("button-placeholder",`
 width: calc(1.75 * var(--n-rail-height));
 height: var(--n-rail-height);
 `),s("base-loading",`
 position: absolute;
 top: 50%;
 left: 50%;
 transform: translateX(-50%) translateY(-50%);
 font-size: calc(var(--n-button-width) - 4px);
 color: var(--n-loading-color);
 transition: color .3s var(--n-bezier);
 `,[G({left:"50%",top:"50%",originalTransform:"translateX(-50%) translateY(-50%)"})]),t("checked, unchecked",`
 transition: color .3s var(--n-bezier);
 color: var(--n-text-color);
 box-sizing: border-box;
 position: absolute;
 white-space: nowrap;
 top: 0;
 bottom: 0;
 display: flex;
 align-items: center;
 line-height: 1;
 `),t("checked",`
 right: 0;
 padding-right: calc(1.25 * var(--n-rail-height) - var(--n-offset));
 `),t("unchecked",`
 left: 0;
 justify-content: flex-end;
 padding-left: calc(1.25 * var(--n-rail-height) - var(--n-offset));
 `),u("&:focus",[t("rail",`
 box-shadow: var(--n-box-shadow-focus);
 `)]),a("round",[t("rail","border-radius: calc(var(--n-rail-height) / 2);",[t("button","border-radius: calc(var(--n-button-height) / 2);")])]),V("disabled",[V("icon",[a("rubber-band",[a("pressed",[t("rail",[t("button","max-width: var(--n-button-width-pressed);")])]),t("rail",[u("&:active",[t("button","max-width: var(--n-button-width-pressed);")])]),a("active",[a("pressed",[t("rail",[t("button","left: calc(100% - var(--n-offset) - var(--n-button-width-pressed));")])]),t("rail",[u("&:active",[t("button","left: calc(100% - var(--n-offset) - var(--n-button-width-pressed));")])])])])])]),a("active",[t("rail",[t("button","left: calc(100% - var(--n-button-width) - var(--n-offset))")])]),t("rail",`
 overflow: hidden;
 height: var(--n-rail-height);
 min-width: var(--n-rail-width);
 border-radius: var(--n-rail-border-radius);
 cursor: pointer;
 position: relative;
 transition:
 opacity .3s var(--n-bezier),
 background .3s var(--n-bezier),
 box-shadow .3s var(--n-bezier);
 background-color: var(--n-rail-color);
 `,[t("button-icon",`
 color: var(--n-icon-color);
 transition: color .3s var(--n-bezier);
 font-size: calc(var(--n-button-height) - 4px);
 position: absolute;
 left: 0;
 right: 0;
 top: 0;
 bottom: 0;
 display: flex;
 justify-content: center;
 align-items: center;
 line-height: 1;
 `,[G()]),t("button",`
 align-items: center; 
 top: var(--n-offset);
 left: var(--n-offset);
 height: var(--n-button-height);
 width: var(--n-button-width-pressed);
 max-width: var(--n-button-width);
 border-radius: var(--n-button-border-radius);
 background-color: var(--n-button-color);
 box-shadow: var(--n-button-box-shadow);
 box-sizing: border-box;
 cursor: inherit;
 content: "";
 position: absolute;
 transition:
 background-color .3s var(--n-bezier),
 left .3s var(--n-bezier),
 opacity .3s var(--n-bezier),
 max-width .3s var(--n-bezier),
 box-shadow .3s var(--n-bezier);
 `)]),a("active",[t("rail","background-color: var(--n-rail-color-active);")]),a("loading",[t("rail",`
 cursor: wait;
 `)]),a("disabled",[t("rail",`
 cursor: not-allowed;
 opacity: .5;
 `)])]),Ce=Object.assign(Object.assign({},T.props),{size:{type:String,default:"medium"},value:{type:[String,Number,Boolean],default:void 0},loading:Boolean,defaultValue:{type:[String,Number,Boolean],default:!1},disabled:{type:Boolean,default:void 0},round:{type:Boolean,default:!0},"onUpdate:value":[Function,Array],onUpdateValue:[Function,Array],checkedValue:{type:[String,Number,Boolean],default:!0},uncheckedValue:{type:[String,Number,Boolean],default:!1},railStyle:Function,rubberBand:{type:Boolean,default:!0},onChange:[Function,Array]});let z;const Ve=E({name:"Switch",props:Ce,setup(e){z===void 0&&(typeof CSS!="undefined"?typeof CSS.supports!="undefined"?z=CSS.supports("width","max(1px)"):z=!1:z=!0);const{mergedClsPrefixRef:l,inlineThemeDisabled:h}=A(e),b=T("Switch","-switch",_e,fe,e,l),d=pe(e),{mergedSizeRef:c,mergedDisabledRef:r}=d,x=O(e.defaultValue),$=ge(e,"value"),f=we($,x),S=B(()=>f.value===e.checkedValue),_=O(!1),n=O(!1),g=B(()=>{const{railStyle:i}=e;if(i)return i({focused:n.value,checked:S.value})});function v(i){const{"onUpdate:value":P,onChange:F,onUpdateValue:D}=e,{nTriggerFormInput:N,nTriggerFormChange:W}=d;P&&U(P,i),D&&U(D,i),F&&U(F,i),x.value=i,N(),W()}function Q(){const{nTriggerFormFocus:i}=d;i()}function Y(){const{nTriggerFormBlur:i}=d;i()}function J(){e.loading||r.value||(f.value!==e.checkedValue?v(e.checkedValue):v(e.uncheckedValue))}function Z(){n.value=!0,Q()}function q(){n.value=!1,Y(),_.value=!1}function ee(i){e.loading||r.value||i.key===" "&&(f.value!==e.checkedValue?v(e.checkedValue):v(e.uncheckedValue),_.value=!1)}function te(i){e.loading||r.value||i.key===" "&&(i.preventDefault(),_.value=!0)}const L=B(()=>{const{value:i}=c,{self:{opacityDisabled:P,railColor:F,railColorActive:D,buttonBoxShadow:N,buttonColor:W,boxShadowFocus:ie,loadingColor:re,textColor:oe,iconColor:ne,[y("buttonHeight",i)]:m,[y("buttonWidth",i)]:ae,[y("buttonWidthPressed",i)]:le,[y("railHeight",i)]:w,[y("railWidth",i)]:R,[y("railBorderRadius",i)]:se,[y("buttonBorderRadius",i)]:de},common:{cubicBezierEaseInOut:ce}}=b.value;let j,K,I;return z?(j=`calc((${w} - ${m}) / 2)`,K=`max(${w}, ${m})`,I=`max(${R}, calc(${R} + ${m} - ${w}))`):(j=H((p(w)-p(m))/2),K=H(Math.max(p(w),p(m))),I=p(w)>p(m)?R:H(p(R)+p(m)-p(w))),{"--n-bezier":ce,"--n-button-border-radius":de,"--n-button-box-shadow":N,"--n-button-color":W,"--n-button-width":ae,"--n-button-width-pressed":le,"--n-button-height":m,"--n-height":K,"--n-offset":j,"--n-opacity-disabled":P,"--n-rail-border-radius":se,"--n-rail-color":F,"--n-rail-color-active":D,"--n-rail-height":w,"--n-rail-width":R,"--n-width":I,"--n-box-shadow-focus":ie,"--n-loading-color":re,"--n-text-color":oe,"--n-icon-color":ne}}),C=h?X("switch",B(()=>c.value[0]),L,e):void 0;return{handleClick:J,handleBlur:q,handleFocus:Z,handleKeyup:ee,handleKeydown:te,mergedRailStyle:g,pressed:_,mergedClsPrefix:l,mergedValue:f,checked:S,mergedDisabled:r,cssVars:h?void 0:L,themeClass:C==null?void 0:C.themeClass,onRender:C==null?void 0:C.onRender}},render(){const{mergedClsPrefix:e,mergedDisabled:l,checked:h,mergedRailStyle:b,onRender:d,$slots:c}=this;d==null||d();const{checked:r,unchecked:x,icon:$,"checked-icon":f,"unchecked-icon":S}=c,_=!(M($)&&M(f)&&M(S));return o("div",{role:"switch","aria-checked":h,class:[`${e}-switch`,this.themeClass,_&&`${e}-switch--icon`,h&&`${e}-switch--active`,l&&`${e}-switch--disabled`,this.round&&`${e}-switch--round`,this.loading&&`${e}-switch--loading`,this.pressed&&`${e}-switch--pressed`,this.rubberBand&&`${e}-switch--rubber-band`],tabindex:this.mergedDisabled?void 0:0,style:this.cssVars,onClick:this.handleClick,onFocus:this.handleFocus,onBlur:this.handleBlur,onKeyup:this.handleKeyup,onKeydown:this.handleKeydown},o("div",{class:`${e}-switch__rail`,"aria-hidden":"true",style:b},k(r,n=>k(x,g=>n||g?o("div",{"aria-hidden":!0,class:`${e}-switch__children-placeholder`},o("div",{class:`${e}-switch__rail-placeholder`},o("div",{class:`${e}-switch__button-placeholder`}),n),o("div",{class:`${e}-switch__rail-placeholder`},o("div",{class:`${e}-switch__button-placeholder`}),g)):null)),o("div",{class:`${e}-switch__button`},k($,n=>k(f,g=>k(S,v=>o(ve,null,{default:()=>this.loading?o(me,{key:"loading",clsPrefix:e,strokeWidth:20}):this.checked&&(g||n)?o("div",{class:`${e}-switch__button-icon`,key:g?"checked-icon":"icon"},g||n):!this.checked&&(v||n)?o("div",{class:`${e}-switch__button-icon`,key:v?"unchecked-icon":"icon"},v||n):null})))),k(r,n=>n&&o("div",{key:"checked",class:`${e}-switch__checked`},n)),k(x,n=>n&&o("div",{key:"unchecked",class:`${e}-switch__unchecked`},n)))))}});export{Ve as N,ze as _,Be as a};
