import{R as b,P as S,d as C,G as R,S as k,j as w,h as p,m as O,ac as j,ds as A,aO as H,aV as f}from"./index-797c0a85.js";import{u as N}from"./use-houdini-2ac76cd5.js";const E=b([S("skeleton",`
 height: 1em;
 width: 100%;
 transition: background-color .3s var(--n-bezier);
 transition:
 --n-color-start .3s var(--n-bezier),
 --n-color-end .3s var(--n-bezier),
 background-color .3s var(--n-bezier);
 animation: 2s skeleton-loading infinite cubic-bezier(0.36, 0, 0.64, 1);
 background-color: var(--n-color-start);
 `),b("@keyframes skeleton-loading",`
 0% {
 background: var(--n-color-start);
 }
 40% {
 background: var(--n-color-end);
 }
 80% {
 background: var(--n-color-start);
 }
 100% {
 background: var(--n-color-start);
 }
 `)]),T=Object.assign(Object.assign({},k.props),{text:Boolean,round:Boolean,circle:Boolean,height:[String,Number],width:[String,Number],size:String,repeat:{type:Number,default:1},animated:{type:Boolean,default:!0},sharp:{type:Boolean,default:!0}}),F=C({name:"Skeleton",inheritAttrs:!1,props:T,setup(n){N();const{mergedClsPrefixRef:o}=R(n),s=k("Skeleton","-skeleton",E,A,n,o);return{mergedClsPrefix:o,style:w(()=>{var r,t;const a=s.value,{common:{cubicBezierEaseInOut:v}}=a,m=a.self,{color:y,colorEnd:z,borderRadius:x}=m;let i;const{circle:l,sharp:_,round:B,width:e,height:c,size:g,text:h,animated:P}=n;g!==void 0&&(i=m[H("height",g)]);const d=l?(r=e!=null?e:c)!==null&&r!==void 0?r:i:e,u=(t=l&&e!=null?e:c)!==null&&t!==void 0?t:i;return{display:h?"inline-block":"",verticalAlign:h?"-0.125em":"",borderRadius:l?"50%":B?"4096px":_?"":x,width:typeof d=="number"?f(d):d,height:typeof u=="number"?f(u):u,animation:P?"":"none","--n-bezier":v,"--n-color-start":y,"--n-color-end":z}})}},render(){const{repeat:n,style:o,mergedClsPrefix:s,$attrs:r}=this,t=p("div",O({class:`${s}-skeleton`,style:o},r));return n>1?p(j,null,Array.apply(null,{length:n}).map(a=>[t,`
`])):t}});export{F as _};
