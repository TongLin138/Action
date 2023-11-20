import{p as T}from"./interface-6b37b567.js";import{P as m,aK as R,F as j,d as O,S as v,r as y,G as P,bf as z,V as E,be as I,j as S,I as L,h as c,aS as _}from"./index-797c0a85.js";const $=m("layout",`
 color: var(--n-text-color);
 background-color: var(--n-color);
 box-sizing: border-box;
 position: relative;
 z-index: auto;
 flex: auto;
 overflow: hidden;
 transition:
 box-shadow .3s var(--n-bezier),
 background-color .3s var(--n-bezier),
 color .3s var(--n-bezier);
`,[m("layout-scroll-container",`
 overflow-x: hidden;
 box-sizing: border-box;
 height: 100%;
 `),R("absolute-positioned",`
 position: absolute;
 left: 0;
 right: 0;
 top: 0;
 bottom: 0;
 `)]),w={embedded:Boolean,position:T,nativeScrollbar:{type:Boolean,default:!0},scrollbarProps:Object,onScroll:Function,contentStyle:{type:[String,Object],default:""},hasSider:Boolean,siderPlacement:{type:String,default:"left"}},B=j("n-layout");function V(d){return O({name:d?"LayoutContent":"Layout",props:Object.assign(Object.assign({},v.props),w),setup(e){const s=y(null),a=y(null),{mergedClsPrefixRef:n,inlineThemeDisabled:i}=P(e),u=v("Layout","-layout",$,z,e,n);function g(o,l){if(e.nativeScrollbar){const{value:t}=s;t&&(l===void 0?t.scrollTo(o):t.scrollTo(o,l))}else{const{value:t}=a;t&&t.scrollTo(o,l)}}E(B,e);let h=0,b=0;const x=o=>{var l;const t=o.target;h=t.scrollLeft,b=t.scrollTop,(l=e.onScroll)===null||l===void 0||l.call(e,o)};I(()=>{if(e.nativeScrollbar){const o=s.value;o&&(o.scrollTop=b,o.scrollLeft=h)}});const p={display:"flex",flexWrap:"nowrap",width:"100%",flexDirection:"row"},C={scrollTo:g},f=S(()=>{const{common:{cubicBezierEaseInOut:o},self:l}=u.value;return{"--n-bezier":o,"--n-color":e.embedded?l.colorEmbedded:l.color,"--n-text-color":l.textColor}}),r=i?L("layout",S(()=>e.embedded?"e":""),f,e):void 0;return Object.assign({mergedClsPrefix:n,scrollableElRef:s,scrollbarInstRef:a,hasSiderStyle:p,mergedTheme:u,handleNativeElScroll:x,cssVars:i?void 0:f,themeClass:r==null?void 0:r.themeClass,onRender:r==null?void 0:r.onRender},C)},render(){var e;const{mergedClsPrefix:s,hasSider:a}=this;(e=this.onRender)===null||e===void 0||e.call(this);const n=a?this.hasSiderStyle:void 0,i=[this.themeClass,d&&`${s}-layout-content`,`${s}-layout`,`${s}-layout--${this.position}-positioned`];return c("div",{class:i,style:this.cssVars},this.nativeScrollbar?c("div",{ref:"scrollableElRef",class:`${s}-layout-scroll-container`,style:[this.contentStyle,n],onScroll:this.handleNativeElScroll},this.$slots):c(_,Object.assign({},this.scrollbarProps,{onScroll:this.onScroll,ref:"scrollbarInstRef",theme:this.mergedTheme.peers.Scrollbar,themeOverrides:this.mergedTheme.peerOverrides.Scrollbar,contentStyle:[this.contentStyle,n]}),this.$slots))}})}const k=V(!1);export{k as _,V as c,B as l};
