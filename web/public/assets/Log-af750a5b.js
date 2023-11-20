import{d as w,h as s,aX as q,F,H as W,r as C,j as T,B as V,A as $,J as j,P as z,R as E,b1 as A,Q as D,G as K,S as N,dt as Y,V as G,I as J,aS as Q,D as U,an as _,a_ as M}from"./index-797c0a85.js";import{u as X}from"./use-locale-3967e664.js";import{t as Z}from"./throttle-d0379a19.js";import{u as ee,_ as oe}from"./Code-81e48d26.js";const te=w({name:"LogLoader",props:{clsPrefix:{type:String,required:!0}},setup(){return{locale:X("Log").localeRef}},render(){const{clsPrefix:e}=this;return s("div",{class:`${e}-log-loader`},s(q,{clsPrefix:e,strokeWidth:24,scale:.85}),s("span",{class:`${e}-log-loader__content`},this.locale.loading))}}),O=F("n-log"),ne=w({props:{line:{type:String,default:""}},setup(e){const{trimRef:n,highlightRef:r,languageRef:a,mergedHljsRef:h}=W(O),m=C(null),R=T(()=>n.value?e.line.trim():e.line);function u(){m.value&&(m.value.innerHTML=x(a.value,R.value))}function x(p,H){const{value:b}=h;return b&&p&&b.getLanguage(p)?b.highlight(H,{language:p}).value:H}return V(()=>{r.value&&u()}),$(j(e,"line"),()=>{r.value&&u()}),{highlight:r,selfRef:m,maybeTrimmedLines:R}},render(){const{highlight:e,maybeTrimmedLines:n}=this;return s("pre",{ref:"selfRef"},e?null:n)}}),ie=z("log",`
 position: relative;
 box-sizing: border-box;
 transition: border-color .3s var(--n-bezier);
`,[E("pre",`
 white-space: pre-wrap;
 word-break: break-word;
 margin: 0;
 `),z("log-loader",`
 transition:
 color .3s var(--n-bezier),
 background-color .3s var(--n-bezier),
 border-color .3s var(--n-bezier);
 box-sizing: border-box;
 position: absolute;
 right: 16px;
 top: 8px;
 height: 34px;
 border-radius: 17px;
 line-height: 34px;
 white-space: nowrap;
 overflow: hidden;
 border: var(--n-loader-border);
 color: var(--n-loader-text-color);
 background-color: var(--n-loader-color);
 font-size: var(--n-loader-font-size);
 `,[A(),D("content",`
 display: inline-block;
 vertical-align: bottom;
 line-height: 34px;
 padding-left: 40px;
 padding-right: 20px;
 white-space: nowrap;
 `),z("base-loading",`
 color: var(--n-loading-color);
 position: absolute;
 left: 12px;
 top: calc(50% - 10px);
 font-size: 20px;
 width: 20px;
 height: 20px;
 display: inline-block;
 `)])]),le=Object.assign(Object.assign({},N.props),{loading:Boolean,trim:Boolean,log:String,fontSize:{type:Number,default:14},lines:{type:Array,default:()=>[]},lineHeight:{type:Number,default:1.25},language:String,rows:{type:Number,default:15},offsetTop:{type:Number,default:0},offsetBottom:{type:Number,default:0},hljs:Object,onReachTop:Function,onReachBottom:Function,onRequireMore:Function}),de=w({name:"Log",props:le,setup(e){const{mergedClsPrefixRef:n,inlineThemeDisabled:r}=K(e),a=C(!1),h=T(()=>e.language!==void 0),m=T(()=>`calc(${Math.round(e.rows*e.lineHeight*e.fontSize)}px)`),R=T(()=>{const{log:o}=e;return o?o.split(`
`):e.lines}),u=C(null),x=N("Log","-log",ie,Y,e,n);function p(o){const t=o.target,c=t.firstElementChild;if(a.value){_(()=>{a.value=!1});return}const d=t.offsetHeight,i=t.scrollTop,v=c.offsetHeight,L=i,S=v-i-d;if(L<=e.offsetTop){const{onReachTop:f,onRequireMore:l}=e;l&&l("top"),f&&f()}if(S<=e.offsetBottom){const{onReachBottom:f,onRequireMore:l}=e;l&&l("bottom"),f&&f()}}const H=Z(b,300);function b(o){if(a.value){_(()=>{a.value=!1});return}if(u.value){const{containerRef:t,contentRef:c}=u.value;if(t&&c){const d=t.offsetHeight,i=t.scrollTop,v=c.offsetHeight,L=i,S=v-i-d,f=o.deltaY;if(L===0&&f<0){const{onRequireMore:l}=e;l&&l("top")}if(S<=0&&f>0){const{onRequireMore:l}=e;l&&l("bottom")}}}}function y(o){const{value:t}=u;if(!t)return;const{silent:c,top:d,position:i}=o;c&&(a.value=!0),d!==void 0?t.scrollTo({left:0,top:d}):(i==="bottom"||i==="top")&&t.scrollTo({position:i})}function P(o=!1){M("log","`scrollToTop` is deprecated, please use `scrollTo({ position: 'top'})` instead."),y({position:"top",silent:o})}function k(o=!1){M("log","`scrollToTop` is deprecated, please use `scrollTo({ position: 'bottom'})` instead."),y({position:"bottom",silent:o})}G(O,{languageRef:j(e,"language"),mergedHljsRef:ee(e),trimRef:j(e,"trim"),highlightRef:h});const I={scrollTo:y},B=T(()=>{const{self:{loaderFontSize:o,loaderTextColor:t,loaderColor:c,loaderBorder:d,loadingColor:i},common:{cubicBezierEaseInOut:v}}=x.value;return{"--n-bezier":v,"--n-loader-font-size":o,"--n-loader-border":d,"--n-loader-color":c,"--n-loader-text-color":t,"--n-loading-color":i}}),g=r?J("log",void 0,B,e):void 0;return Object.assign(Object.assign({},I),{mergedClsPrefix:n,scrollbarRef:u,mergedTheme:x,styleHeight:m,mergedLines:R,scrollToTop:P,scrollToBottom:k,handleWheel:H,handleScroll:p,cssVars:r?void 0:B,themeClass:g==null?void 0:g.themeClass,onRender:g==null?void 0:g.onRender})},render(){const{mergedClsPrefix:e,mergedTheme:n,onRender:r}=this;return r==null||r(),s("div",{class:[`${e}-log`,this.themeClass],style:[{lineHeight:this.lineHeight,height:this.styleHeight},this.cssVars],onWheelPassive:this.handleWheel},[s(Q,{ref:"scrollbarRef",theme:n.peers.Scrollbar,themeOverrides:n.peerOverrides.Scrollbar,onScroll:this.handleScroll},{default:()=>s(oe,{internalNoHighlight:!0,internalFontSize:this.fontSize,theme:n.peers.Code,themeOverrides:n.peerOverrides.Code},{default:()=>this.mergedLines.map((a,h)=>s(ne,{key:h,line:a}))})}),s(U,{name:"fade-in-scale-up-transition"},{default:()=>this.loading?s(te,{clsPrefix:e}):null})])}});export{de as _};
