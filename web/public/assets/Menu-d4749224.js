import{l as pe}from"./interface-6b37b567.js";import{d as M,h as p,F as q,H as F,j as b,V as L,cN as O,ac as fe,N as ge,r as U,aY as G,d9 as xe,X as D,O as W,R as g,P as h,aK as z,Q as d,aL as _,da as be,G as Ce,S as le,e8 as ze,k as oe,J as te,cH as ye,Z as P,I as Ie}from"./index-797c0a85.js";import{N as we}from"./Dropdown-03dfd01d.js";import{a as Se,u as re}from"./Tooltip-271e10cc.js";import{c as Ae}from"./Empty-aa248199.js";const Re=M({name:"ChevronDownFilled",render(){return p("svg",{viewBox:"0 0 16 16",fill:"none",xmlns:"http://www.w3.org/2000/svg"},p("path",{d:"M3.20041 5.73966C3.48226 5.43613 3.95681 5.41856 4.26034 5.70041L8 9.22652L11.7397 5.70041C12.0432 5.41856 12.5177 5.43613 12.7996 5.73966C13.0815 6.0432 13.0639 6.51775 12.7603 6.7996L8.51034 10.7996C8.22258 11.0668 7.77743 11.0668 7.48967 10.7996L3.23966 6.7996C2.93613 6.51775 2.91856 6.0432 3.20041 5.73966Z",fill:"currentColor"}))}}),$=q("n-menu"),Z=q("n-submenu"),J=q("n-menu-item-group"),B=8;function Q(e){const n=F($),{props:r,mergedCollapsedRef:i}=n,l=F(Z,null),a=F(J,null),s=b(()=>r.mode==="horizontal"),v=b(()=>s.value?r.dropdownPlacement:"tmNodes"in e?"right-start":"right"),c=b(()=>{var u;return Math.max((u=r.collapsedIconSize)!==null&&u!==void 0?u:r.iconSize,r.iconSize)}),I=b(()=>{var u;return!s.value&&e.root&&i.value&&(u=r.collapsedIconSize)!==null&&u!==void 0?u:r.iconSize}),R=b(()=>{if(s.value)return;const{collapsedWidth:u,indent:w,rootIndent:A}=r,{root:S,isGroup:H}=e,N=A===void 0?w:A;if(S)return i.value?u/2-c.value/2:N;if(a)return w/2+a.paddingLeftRef.value;if(l)return(H?w/2:w)+l.paddingLeftRef.value}),y=b(()=>{const{collapsedWidth:u,indent:w,rootIndent:A}=r,{value:S}=c,{root:H}=e;return s.value||!H||!i.value?B:(A===void 0?w:A)+S+B-(u+S)/2});return{dropdownPlacement:v,activeIconSize:I,maxIconSize:c,paddingLeft:R,iconMarginRight:y,NMenu:n,NSubmenu:l}}const X={internalKey:{type:[String,Number],required:!0},root:Boolean,isGroup:Boolean,level:{type:Number,required:!0},title:[String,Function],extra:[String,Function]},ae=Object.assign(Object.assign({},X),{tmNode:{type:Object,required:!0},tmNodes:{type:Array,required:!0}}),He=M({name:"MenuOptionGroup",props:ae,setup(e){L(Z,null);const n=Q(e);L(J,{paddingLeftRef:n.paddingLeft});const{mergedClsPrefixRef:r,props:i}=F($);return function(){const{value:l}=r,a=n.paddingLeft.value,{nodeProps:s}=i,v=s==null?void 0:s(e.tmNode.rawNode);return p("div",{class:`${l}-menu-item-group`,role:"group"},p("div",Object.assign({},v,{class:[`${l}-menu-item-group-title`,v==null?void 0:v.class],style:[(v==null?void 0:v.style)||"",a!==void 0?`padding-left: ${a}px;`:""]}),O(e.title),e.extra?p(fe,null," ",O(e.extra)):null),p("div",null,e.tmNodes.map(c=>Y(c,i))))}}}),ce=M({name:"MenuOptionContent",props:{collapsed:Boolean,disabled:Boolean,title:[String,Function],icon:Function,extra:[String,Function],showArrow:Boolean,childActive:Boolean,hover:Boolean,paddingLeft:Number,selected:Boolean,maxIconSize:{type:Number,required:!0},activeIconSize:{type:Number,required:!0},iconMarginRight:{type:Number,required:!0},clsPrefix:{type:String,required:!0},onClick:Function,tmNode:{type:Object,required:!0}},setup(e){const{props:n}=F($);return{menuProps:n,style:b(()=>{const{paddingLeft:r}=e;return{paddingLeft:r&&`${r}px`}}),iconStyle:b(()=>{const{maxIconSize:r,activeIconSize:i,iconMarginRight:l}=e;return{width:`${r}px`,height:`${r}px`,fontSize:`${i}px`,marginRight:`${l}px`}})}},render(){const{clsPrefix:e,tmNode:n,menuProps:{renderIcon:r,renderLabel:i,renderExtra:l,expandIcon:a}}=this,s=r?r(n.rawNode):O(this.icon);return p("div",{onClick:v=>{var c;(c=this.onClick)===null||c===void 0||c.call(this,v)},role:"none",class:[`${e}-menu-item-content`,{[`${e}-menu-item-content--selected`]:this.selected,[`${e}-menu-item-content--collapsed`]:this.collapsed,[`${e}-menu-item-content--child-active`]:this.childActive,[`${e}-menu-item-content--disabled`]:this.disabled,[`${e}-menu-item-content--hover`]:this.hover}],style:this.style},s&&p("div",{class:`${e}-menu-item-content__icon`,style:this.iconStyle,role:"none"},[s]),p("div",{class:`${e}-menu-item-content-header`,role:"none"},i?i(n.rawNode):O(this.title),this.extra||l?p("span",{class:`${e}-menu-item-content-header__extra`}," ",l?l(n.rawNode):O(this.extra)):null),this.showArrow?p(ge,{ariaHidden:!0,class:`${e}-menu-item-content__arrow`,clsPrefix:e},{default:()=>a?a(n.rawNode):p(Re,null)}):null)}}),de=Object.assign(Object.assign({},X),{rawNodes:{type:Array,default:()=>[]},tmNodes:{type:Array,default:()=>[]},tmNode:{type:Object,required:!0},disabled:{type:Boolean,default:!1},icon:Function,onClick:Function}),Ne=M({name:"Submenu",props:de,setup(e){const n=Q(e),{NMenu:r,NSubmenu:i}=n,{props:l,mergedCollapsedRef:a,mergedThemeRef:s}=r,v=b(()=>{const{disabled:u}=e;return i!=null&&i.mergedDisabledRef.value||l.disabled?!0:u}),c=U(!1);L(Z,{paddingLeftRef:n.paddingLeft,mergedDisabledRef:v}),L(J,null);function I(){const{onClick:u}=e;u&&u()}function R(){v.value||(a.value||r.toggleExpand(e.internalKey),I())}function y(u){c.value=u}return{menuProps:l,mergedTheme:s,doSelect:r.doSelect,inverted:r.invertedRef,isHorizontal:r.isHorizontalRef,mergedClsPrefix:r.mergedClsPrefixRef,maxIconSize:n.maxIconSize,activeIconSize:n.activeIconSize,iconMarginRight:n.iconMarginRight,dropdownPlacement:n.dropdownPlacement,dropdownShow:c,paddingLeft:n.paddingLeft,mergedDisabled:v,mergedValue:r.mergedValueRef,childActive:G(()=>r.activePathRef.value.includes(e.internalKey)),collapsed:b(()=>l.mode==="horizontal"?!1:a.value?!0:!r.mergedExpandedKeysRef.value.includes(e.internalKey)),dropdownEnabled:b(()=>!v.value&&(l.mode==="horizontal"||a.value)),handlePopoverShowChange:y,handleClick:R}},render(){var e;const{mergedClsPrefix:n,menuProps:{renderIcon:r,renderLabel:i}}=this,l=()=>{const{isHorizontal:s,paddingLeft:v,collapsed:c,mergedDisabled:I,maxIconSize:R,activeIconSize:y,title:u,childActive:w,icon:A,handleClick:S,menuProps:{nodeProps:H},dropdownShow:N,iconMarginRight:V,tmNode:k,mergedClsPrefix:j}=this,K=H==null?void 0:H(k.rawNode);return p("div",Object.assign({},K,{class:[`${j}-menu-item`,K==null?void 0:K.class],role:"menuitem"}),p(ce,{tmNode:k,paddingLeft:v,collapsed:c,disabled:I,iconMarginRight:V,maxIconSize:R,activeIconSize:y,title:u,extra:this.extra,showArrow:!s,childActive:w,clsPrefix:j,icon:A,hover:N,onClick:S}))},a=()=>p(xe,null,{default:()=>{const{tmNodes:s,collapsed:v}=this;return v?null:p("div",{class:`${n}-submenu-children`,role:"menu"},s.map(c=>Y(c,this.menuProps)))}});return this.root?p(we,Object.assign({size:"large",trigger:"hover"},(e=this.menuProps)===null||e===void 0?void 0:e.dropdownProps,{themeOverrides:this.mergedTheme.peerOverrides.Dropdown,theme:this.mergedTheme.peers.Dropdown,builtinThemeOverrides:{fontSizeLarge:"14px",optionIconSizeLarge:"18px"},value:this.mergedValue,disabled:!this.dropdownEnabled,placement:this.dropdownPlacement,keyField:this.menuProps.keyField,labelField:this.menuProps.labelField,childrenField:this.menuProps.childrenField,onUpdateShow:this.handlePopoverShowChange,options:this.rawNodes,onSelect:this.doSelect,inverted:this.inverted,renderIcon:r,renderLabel:i}),{default:()=>p("div",{class:`${n}-submenu`,role:"menuitem","aria-expanded":!this.collapsed},l(),this.isHorizontal?null:a())}):p("div",{class:`${n}-submenu`,role:"menuitem","aria-expanded":!this.collapsed},l(),a())}}),se=Object.assign(Object.assign({},X),{tmNode:{type:Object,required:!0},disabled:Boolean,icon:Function,onClick:Function}),Pe=M({name:"MenuOption",props:se,setup(e){const n=Q(e),{NSubmenu:r,NMenu:i}=n,{props:l,mergedClsPrefixRef:a,mergedCollapsedRef:s}=i,v=r?r.mergedDisabledRef:{value:!1},c=b(()=>v.value||e.disabled);function I(y){const{onClick:u}=e;u&&u(y)}function R(y){c.value||(i.doSelect(e.internalKey,e.tmNode.rawNode),I(y))}return{mergedClsPrefix:a,dropdownPlacement:n.dropdownPlacement,paddingLeft:n.paddingLeft,iconMarginRight:n.iconMarginRight,maxIconSize:n.maxIconSize,activeIconSize:n.activeIconSize,mergedTheme:i.mergedThemeRef,menuProps:l,dropdownEnabled:G(()=>e.root&&s.value&&l.mode!=="horizontal"&&!c.value),selected:G(()=>i.mergedValueRef.value===e.internalKey),mergedDisabled:c,handleClick:R}},render(){const{mergedClsPrefix:e,mergedTheme:n,tmNode:r,menuProps:{renderLabel:i,nodeProps:l}}=this,a=l==null?void 0:l(r.rawNode);return p("div",Object.assign({},a,{role:"menuitem",class:[`${e}-menu-item`,a==null?void 0:a.class]}),p(Se,{theme:n.peers.Tooltip,themeOverrides:n.peerOverrides.Tooltip,trigger:"hover",placement:this.dropdownPlacement,disabled:!this.dropdownEnabled||this.title===void 0,internalExtraClass:["menu-tooltip"]},{default:()=>i?i(r.rawNode):O(this.title),trigger:()=>p(ce,{tmNode:r,clsPrefix:e,paddingLeft:this.paddingLeft,iconMarginRight:this.iconMarginRight,maxIconSize:this.maxIconSize,activeIconSize:this.activeIconSize,selected:this.selected,title:this.title,extra:this.extra,disabled:this.mergedDisabled,icon:this.icon,onClick:this.handleClick})}))}}),Te=M({name:"MenuDivider",setup(){const e=F($),{mergedClsPrefixRef:n,isHorizontalRef:r}=e;return()=>r.value?null:p("div",{class:`${n.value}-menu-divider`})}}),Fe=W(ae),Me=W(se),Ke=W(de);function ve(e){return e.type==="divider"||e.type==="render"}function Ee(e){return e.type==="divider"}function Y(e,n){const{rawNode:r}=e,{show:i}=r;if(i===!1)return null;if(ve(r))return Ee(r)?p(Te,Object.assign({key:e.key},r.props)):null;const{labelField:l}=n,{key:a,level:s,isGroup:v}=e,c=Object.assign(Object.assign({},r),{title:r.title||r[l],extra:r.titleExtra||r.extra,key:a,internalKey:a,level:s,root:s===0,isGroup:v});return e.children?e.isGroup?p(He,D(c,Fe,{tmNode:e,tmNodes:e.children,key:a})):p(Ne,D(c,Ke,{key:a,rawNodes:r[n.childrenField],tmNodes:e.children,tmNode:e})):p(Pe,D(c,Me,{key:a,tmNode:e}))}const ne=[g("&::before","background-color: var(--n-item-color-hover);"),d("arrow",`
 color: var(--n-arrow-color-hover);
 `),d("icon",`
 color: var(--n-item-icon-color-hover);
 `),h("menu-item-content-header",`
 color: var(--n-item-text-color-hover);
 `,[g("a",`
 color: var(--n-item-text-color-hover);
 `),d("extra",`
 color: var(--n-item-text-color-hover);
 `)])],ie=[d("icon",`
 color: var(--n-item-icon-color-hover-horizontal);
 `),h("menu-item-content-header",`
 color: var(--n-item-text-color-hover-horizontal);
 `,[g("a",`
 color: var(--n-item-text-color-hover-horizontal);
 `),d("extra",`
 color: var(--n-item-text-color-hover-horizontal);
 `)])],Oe=g([h("menu",`
 background-color: var(--n-color);
 color: var(--n-item-text-color);
 overflow: hidden;
 transition: background-color .3s var(--n-bezier);
 box-sizing: border-box;
 font-size: var(--n-font-size);
 padding-bottom: 6px;
 `,[z("horizontal",`
 display: inline-flex;
 padding-bottom: 0;
 `,[h("submenu","margin: 0;"),h("menu-item","margin: 0;"),h("menu-item-content",`
 padding: 0 20px;
 border-bottom: 2px solid #0000;
 `,[g("&::before","display: none;"),z("selected","border-bottom: 2px solid var(--n-border-color-horizontal)")]),h("menu-item-content",[z("selected",[d("icon","color: var(--n-item-icon-color-active-horizontal);"),h("menu-item-content-header",`
 color: var(--n-item-text-color-active-horizontal);
 `,[g("a","color: var(--n-item-text-color-active-horizontal);"),d("extra","color: var(--n-item-text-color-active-horizontal);")])]),z("child-active",`
 border-bottom: 2px solid var(--n-border-color-horizontal);
 `,[h("menu-item-content-header",`
 color: var(--n-item-text-color-child-active-horizontal);
 `,[g("a",`
 color: var(--n-item-text-color-child-active-horizontal);
 `),d("extra",`
 color: var(--n-item-text-color-child-active-horizontal);
 `)]),d("icon",`
 color: var(--n-item-icon-color-child-active-horizontal);
 `)]),_("disabled",[_("selected, child-active",[g("&:focus-within",ie)]),z("selected",[T(null,[d("icon","color: var(--n-item-icon-color-active-hover-horizontal);"),h("menu-item-content-header",`
 color: var(--n-item-text-color-active-hover-horizontal);
 `,[g("a","color: var(--n-item-text-color-active-hover-horizontal);"),d("extra","color: var(--n-item-text-color-active-hover-horizontal);")])])]),z("child-active",[T(null,[d("icon","color: var(--n-item-icon-color-child-active-hover-horizontal);"),h("menu-item-content-header",`
 color: var(--n-item-text-color-child-active-hover-horizontal);
 `,[g("a","color: var(--n-item-text-color-child-active-hover-horizontal);"),d("extra","color: var(--n-item-text-color-child-active-hover-horizontal);")])])]),T("border-bottom: 2px solid var(--n-border-color-horizontal);",ie)]),h("menu-item-content-header",[g("a","color: var(--n-item-text-color-horizontal);")])])]),z("collapsed",[h("menu-item-content",[z("selected",[g("&::before",`
 background-color: var(--n-item-color-active-collapsed) !important;
 `)]),h("menu-item-content-header","opacity: 0;"),d("arrow","opacity: 0;"),d("icon","color: var(--n-item-icon-color-collapsed);")])]),h("menu-item",`
 height: var(--n-item-height);
 margin-top: 6px;
 position: relative;
 `),h("menu-item-content",`
 box-sizing: border-box;
 line-height: 1.75;
 height: 100%;
 display: grid;
 grid-template-areas: "icon content arrow";
 grid-template-columns: auto 1fr auto;
 align-items: center;
 cursor: pointer;
 position: relative;
 padding-right: 18px;
 transition:
 background-color .3s var(--n-bezier),
 padding-left .3s var(--n-bezier),
 border-color .3s var(--n-bezier);
 `,[g("> *","z-index: 1;"),g("&::before",`
 z-index: auto;
 content: "";
 background-color: #0000;
 position: absolute;
 left: 8px;
 right: 8px;
 top: 0;
 bottom: 0;
 pointer-events: none;
 border-radius: var(--n-border-radius);
 transition: background-color .3s var(--n-bezier);
 `),z("disabled",`
 opacity: .45;
 cursor: not-allowed;
 `),z("collapsed",[d("arrow","transform: rotate(0);")]),z("selected",[g("&::before","background-color: var(--n-item-color-active);"),d("arrow","color: var(--n-arrow-color-active);"),d("icon","color: var(--n-item-icon-color-active);"),h("menu-item-content-header",`
 color: var(--n-item-text-color-active);
 `,[g("a","color: var(--n-item-text-color-active);"),d("extra","color: var(--n-item-text-color-active);")])]),z("child-active",[h("menu-item-content-header",`
 color: var(--n-item-text-color-child-active);
 `,[g("a",`
 color: var(--n-item-text-color-child-active);
 `),d("extra",`
 color: var(--n-item-text-color-child-active);
 `)]),d("arrow",`
 color: var(--n-arrow-color-child-active);
 `),d("icon",`
 color: var(--n-item-icon-color-child-active);
 `)]),_("disabled",[_("selected, child-active",[g("&:focus-within",ne)]),z("selected",[T(null,[d("arrow","color: var(--n-arrow-color-active-hover);"),d("icon","color: var(--n-item-icon-color-active-hover);"),h("menu-item-content-header",`
 color: var(--n-item-text-color-active-hover);
 `,[g("a","color: var(--n-item-text-color-active-hover);"),d("extra","color: var(--n-item-text-color-active-hover);")])])]),z("child-active",[T(null,[d("arrow","color: var(--n-arrow-color-child-active-hover);"),d("icon","color: var(--n-item-icon-color-child-active-hover);"),h("menu-item-content-header",`
 color: var(--n-item-text-color-child-active-hover);
 `,[g("a","color: var(--n-item-text-color-child-active-hover);"),d("extra","color: var(--n-item-text-color-child-active-hover);")])])]),z("selected",[T(null,[g("&::before","background-color: var(--n-item-color-active-hover);")])]),T(null,ne)]),d("icon",`
 grid-area: icon;
 color: var(--n-item-icon-color);
 transition:
 color .3s var(--n-bezier),
 font-size .3s var(--n-bezier),
 margin-right .3s var(--n-bezier);
 box-sizing: content-box;
 display: inline-flex;
 align-items: center;
 justify-content: center;
 `),d("arrow",`
 grid-area: arrow;
 font-size: 16px;
 color: var(--n-arrow-color);
 transform: rotate(180deg);
 opacity: 1;
 transition:
 color .3s var(--n-bezier),
 transform 0.2s var(--n-bezier),
 opacity 0.2s var(--n-bezier);
 `),h("menu-item-content-header",`
 grid-area: content;
 transition:
 color .3s var(--n-bezier),
 opacity .3s var(--n-bezier);
 opacity: 1;
 white-space: nowrap;
 overflow: hidden;
 text-overflow: ellipsis;
 color: var(--n-item-text-color);
 `,[g("a",`
 outline: none;
 text-decoration: none;
 transition: color .3s var(--n-bezier);
 color: var(--n-item-text-color);
 `,[g("&::before",`
 content: "";
 position: absolute;
 left: 0;
 right: 0;
 top: 0;
 bottom: 0;
 `)]),d("extra",`
 font-size: .93em;
 color: var(--n-group-text-color);
 transition: color .3s var(--n-bezier);
 `)])]),h("submenu",`
 cursor: pointer;
 position: relative;
 margin-top: 6px;
 `,[h("menu-item-content",`
 height: var(--n-item-height);
 `),h("submenu-children",`
 overflow: hidden;
 padding: 0;
 `,[be({duration:".2s"})])]),h("menu-item-group",[h("menu-item-group-title",`
 margin-top: 6px;
 color: var(--n-group-text-color);
 cursor: default;
 font-size: .93em;
 height: 36px;
 display: flex;
 align-items: center;
 transition:
 padding-left .3s var(--n-bezier),
 color .3s var(--n-bezier);
 `)])]),h("menu-tooltip",[g("a",`
 color: inherit;
 text-decoration: none;
 `)]),h("menu-divider",`
 transition: background-color .3s var(--n-bezier);
 background-color: var(--n-divider-color);
 height: 1px;
 margin: 6px 18px;
 `)]);function T(e,n){return[z("hover",e,n),g("&:hover",e,n)]}const ke=Object.assign(Object.assign({},le.props),{options:{type:Array,default:()=>[]},collapsed:{type:Boolean,default:void 0},collapsedWidth:{type:Number,default:48},iconSize:{type:Number,default:20},collapsedIconSize:{type:Number,default:24},rootIndent:Number,indent:{type:Number,default:32},labelField:{type:String,default:"label"},keyField:{type:String,default:"key"},childrenField:{type:String,default:"children"},disabledField:{type:String,default:"disabled"},defaultExpandAll:Boolean,defaultExpandedKeys:Array,expandedKeys:Array,value:[String,Number],defaultValue:{type:[String,Number],default:null},mode:{type:String,default:"vertical"},watchProps:{type:Array,default:void 0},disabled:Boolean,show:{type:Boolean,default:!0},inverted:Boolean,"onUpdate:expandedKeys":[Function,Array],onUpdateExpandedKeys:[Function,Array],onUpdateValue:[Function,Array],"onUpdate:value":[Function,Array],expandIcon:Function,renderIcon:Function,renderLabel:Function,renderExtra:Function,dropdownProps:Object,accordion:Boolean,nodeProps:Function,items:Array,onOpenNamesChange:[Function,Array],onSelect:[Function,Array],onExpandedNamesChange:[Function,Array],expandedNames:Array,defaultExpandedNames:Array,dropdownPlacement:{type:String,default:"bottom"}}),Ve=M({name:"Menu",props:ke,setup(e){const{mergedClsPrefixRef:n,inlineThemeDisabled:r}=Ce(e),i=le("Menu","-menu",Oe,ze,e,n),l=F(pe,null),a=b(()=>{var m;const{collapsed:x}=e;if(x!==void 0)return x;if(l){const{collapseModeRef:o,collapsedRef:f}=l;if(o.value==="width")return(m=f.value)!==null&&m!==void 0?m:!1}return!1}),s=b(()=>{const{keyField:m,childrenField:x,disabledField:o}=e;return Ae(e.items||e.options,{getIgnored(f){return ve(f)},getChildren(f){return f[x]},getDisabled(f){return f[o]},getKey(f){var C;return(C=f[m])!==null&&C!==void 0?C:f.name}})}),v=b(()=>new Set(s.value.treeNodes.map(m=>m.key))),{watchProps:c}=e,I=U(null);c!=null&&c.includes("defaultValue")?oe(()=>{I.value=e.defaultValue}):I.value=e.defaultValue;const R=te(e,"value"),y=re(R,I),u=U([]),w=()=>{u.value=e.defaultExpandAll?s.value.getNonLeafKeys():e.defaultExpandedNames||e.defaultExpandedKeys||s.value.getPath(y.value,{includeSelf:!1}).keyPath};c!=null&&c.includes("defaultExpandedKeys")?oe(w):w();const A=ye(e,["expandedNames","expandedKeys"]),S=re(A,u),H=b(()=>s.value.treeNodes),N=b(()=>s.value.getPath(y.value).keyPath);L($,{props:e,mergedCollapsedRef:a,mergedThemeRef:i,mergedValueRef:y,mergedExpandedKeysRef:S,activePathRef:N,mergedClsPrefixRef:n,isHorizontalRef:b(()=>e.mode==="horizontal"),invertedRef:te(e,"inverted"),doSelect:V,toggleExpand:j});function V(m,x){const{"onUpdate:value":o,onUpdateValue:f,onSelect:C}=e;f&&P(f,m,x),o&&P(o,m,x),C&&P(C,m,x),I.value=m}function k(m){const{"onUpdate:expandedKeys":x,onUpdateExpandedKeys:o,onExpandedNamesChange:f,onOpenNamesChange:C}=e;x&&P(x,m),o&&P(o,m),f&&P(f,m),C&&P(C,m),u.value=m}function j(m){const x=Array.from(S.value),o=x.findIndex(f=>f===m);if(~o)x.splice(o,1);else{if(e.accordion&&v.value.has(m)){const f=x.findIndex(C=>v.value.has(C));f>-1&&x.splice(f,1)}x.push(m)}k(x)}const K=m=>{const x=s.value.getPath(m!=null?m:y.value,{includeSelf:!1}).keyPath;if(!x.length)return;const o=Array.from(S.value),f=new Set([...o,...x]);e.accordion&&v.value.forEach(C=>{f.has(C)&&!x.includes(C)&&f.delete(C)}),k(Array.from(f))},ee=b(()=>{const{inverted:m}=e,{common:{cubicBezierEaseInOut:x},self:o}=i.value,{borderRadius:f,borderColorHorizontal:C,fontSize:ue,itemHeight:me,dividerColor:he}=o,t={"--n-divider-color":he,"--n-bezier":x,"--n-font-size":ue,"--n-border-color-horizontal":C,"--n-border-radius":f,"--n-item-height":me};return m?(t["--n-group-text-color"]=o.groupTextColorInverted,t["--n-color"]=o.colorInverted,t["--n-item-text-color"]=o.itemTextColorInverted,t["--n-item-text-color-hover"]=o.itemTextColorHoverInverted,t["--n-item-text-color-active"]=o.itemTextColorActiveInverted,t["--n-item-text-color-child-active"]=o.itemTextColorChildActiveInverted,t["--n-item-text-color-child-active-hover"]=o.itemTextColorChildActiveInverted,t["--n-item-text-color-active-hover"]=o.itemTextColorActiveHoverInverted,t["--n-item-icon-color"]=o.itemIconColorInverted,t["--n-item-icon-color-hover"]=o.itemIconColorHoverInverted,t["--n-item-icon-color-active"]=o.itemIconColorActiveInverted,t["--n-item-icon-color-active-hover"]=o.itemIconColorActiveHoverInverted,t["--n-item-icon-color-child-active"]=o.itemIconColorChildActiveInverted,t["--n-item-icon-color-child-active-hover"]=o.itemIconColorChildActiveHoverInverted,t["--n-item-icon-color-collapsed"]=o.itemIconColorCollapsedInverted,t["--n-item-text-color-horizontal"]=o.itemTextColorHorizontalInverted,t["--n-item-text-color-hover-horizontal"]=o.itemTextColorHoverHorizontalInverted,t["--n-item-text-color-active-horizontal"]=o.itemTextColorActiveHorizontalInverted,t["--n-item-text-color-child-active-horizontal"]=o.itemTextColorChildActiveHorizontalInverted,t["--n-item-text-color-child-active-hover-horizontal"]=o.itemTextColorChildActiveHoverHorizontalInverted,t["--n-item-text-color-active-hover-horizontal"]=o.itemTextColorActiveHoverHorizontalInverted,t["--n-item-icon-color-horizontal"]=o.itemIconColorHorizontalInverted,t["--n-item-icon-color-hover-horizontal"]=o.itemIconColorHoverHorizontalInverted,t["--n-item-icon-color-active-horizontal"]=o.itemIconColorActiveHorizontalInverted,t["--n-item-icon-color-active-hover-horizontal"]=o.itemIconColorActiveHoverHorizontalInverted,t["--n-item-icon-color-child-active-horizontal"]=o.itemIconColorChildActiveHorizontalInverted,t["--n-item-icon-color-child-active-hover-horizontal"]=o.itemIconColorChildActiveHoverHorizontalInverted,t["--n-arrow-color"]=o.arrowColorInverted,t["--n-arrow-color-hover"]=o.arrowColorHoverInverted,t["--n-arrow-color-active"]=o.arrowColorActiveInverted,t["--n-arrow-color-active-hover"]=o.arrowColorActiveHoverInverted,t["--n-arrow-color-child-active"]=o.arrowColorChildActiveInverted,t["--n-arrow-color-child-active-hover"]=o.arrowColorChildActiveHoverInverted,t["--n-item-color-hover"]=o.itemColorHoverInverted,t["--n-item-color-active"]=o.itemColorActiveInverted,t["--n-item-color-active-hover"]=o.itemColorActiveHoverInverted,t["--n-item-color-active-collapsed"]=o.itemColorActiveCollapsedInverted):(t["--n-group-text-color"]=o.groupTextColor,t["--n-color"]=o.color,t["--n-item-text-color"]=o.itemTextColor,t["--n-item-text-color-hover"]=o.itemTextColorHover,t["--n-item-text-color-active"]=o.itemTextColorActive,t["--n-item-text-color-child-active"]=o.itemTextColorChildActive,t["--n-item-text-color-child-active-hover"]=o.itemTextColorChildActiveHover,t["--n-item-text-color-active-hover"]=o.itemTextColorActiveHover,t["--n-item-icon-color"]=o.itemIconColor,t["--n-item-icon-color-hover"]=o.itemIconColorHover,t["--n-item-icon-color-active"]=o.itemIconColorActive,t["--n-item-icon-color-active-hover"]=o.itemIconColorActiveHover,t["--n-item-icon-color-child-active"]=o.itemIconColorChildActive,t["--n-item-icon-color-child-active-hover"]=o.itemIconColorChildActiveHover,t["--n-item-icon-color-collapsed"]=o.itemIconColorCollapsed,t["--n-item-text-color-horizontal"]=o.itemTextColorHorizontal,t["--n-item-text-color-hover-horizontal"]=o.itemTextColorHoverHorizontal,t["--n-item-text-color-active-horizontal"]=o.itemTextColorActiveHorizontal,t["--n-item-text-color-child-active-horizontal"]=o.itemTextColorChildActiveHorizontal,t["--n-item-text-color-child-active-hover-horizontal"]=o.itemTextColorChildActiveHoverHorizontal,t["--n-item-text-color-active-hover-horizontal"]=o.itemTextColorActiveHoverHorizontal,t["--n-item-icon-color-horizontal"]=o.itemIconColorHorizontal,t["--n-item-icon-color-hover-horizontal"]=o.itemIconColorHoverHorizontal,t["--n-item-icon-color-active-horizontal"]=o.itemIconColorActiveHorizontal,t["--n-item-icon-color-active-hover-horizontal"]=o.itemIconColorActiveHoverHorizontal,t["--n-item-icon-color-child-active-horizontal"]=o.itemIconColorChildActiveHorizontal,t["--n-item-icon-color-child-active-hover-horizontal"]=o.itemIconColorChildActiveHoverHorizontal,t["--n-arrow-color"]=o.arrowColor,t["--n-arrow-color-hover"]=o.arrowColorHover,t["--n-arrow-color-active"]=o.arrowColorActive,t["--n-arrow-color-active-hover"]=o.arrowColorActiveHover,t["--n-arrow-color-child-active"]=o.arrowColorChildActive,t["--n-arrow-color-child-active-hover"]=o.arrowColorChildActiveHover,t["--n-item-color-hover"]=o.itemColorHover,t["--n-item-color-active"]=o.itemColorActive,t["--n-item-color-active-hover"]=o.itemColorActiveHover,t["--n-item-color-active-collapsed"]=o.itemColorActiveCollapsed),t}),E=r?Ie("menu",b(()=>e.inverted?"a":"b"),ee,e):void 0;return{mergedClsPrefix:n,controlledExpandedKeys:A,uncontrolledExpanededKeys:u,mergedExpandedKeys:S,uncontrolledValue:I,mergedValue:y,activePath:N,tmNodes:H,mergedTheme:i,mergedCollapsed:a,cssVars:r?void 0:ee,themeClass:E==null?void 0:E.themeClass,onRender:E==null?void 0:E.onRender,showOption:K}},render(){const{mergedClsPrefix:e,mode:n,themeClass:r,onRender:i}=this;return i==null||i(),p("div",{role:n==="horizontal"?"menubar":"menu",class:[`${e}-menu`,r,`${e}-menu--${n}`,this.mergedCollapsed&&`${e}-menu--collapsed`],style:this.cssVars},this.tmNodes.map(l=>Y(l,this.$props)))}});export{Ve as _};
