import{h as u,u as l,_ as g,a6 as m,as as f,aG as h,G as v,w,ac as C,av as i,aD as S}from"./vendor-a7094419.js";import{y as L,z as s,A as p,B as b,D as B,q as F,E as I,_ as R}from"./index-c5daf99f.js";import{u as $}from"./useDesign-01a81f9b.js";function d(e){const t=L();s.mode==="legacy"?s.global.locale=e:s.global.locale.value=e,t.setLocaleInfo({locale:e}),B(e)}function M(){const e=L(),t=u(()=>e.getLocale),n=u(()=>e.getShowPicker);async function a(o){const r=s.global;if(l(r.locale)===o)return o;if(p.includes(o))return d(o),o;const c=(await b(Object.assign({"./lang/en.ts":()=>g(()=>import("./en-7710bcc3.js"),["./en-7710bcc3.js","./index-c5daf99f.js","./vendor-a7094419.js","./vendor-a6ec39f9.css","./index-af1a905e.css"],import.meta.url),"./lang/zh_CN.ts":()=>g(()=>import("./zh_CN-44f3143b.js"),["./zh_CN-44f3143b.js","./index-c5daf99f.js","./vendor-a7094419.js","./vendor-a6ec39f9.css","./index-af1a905e.css"],import.meta.url)}),`./lang/${o}.ts`)).default;if(!c)return;const{message:y}=c;return r.setLocaleMessage(o,y),p.push(o),d(o),o}return{getLocale:t,getShowLocalePicker:n,changeLocale:a}}const k={style:{display:"inline-block"},viewBox:"0 0 1024 1024",width:"1em",height:"1em"},P=h("path",{fill:"currentColor",d:"M511.6 76.3C264.3 76.2 64 276.4 64 523.5C64 718.9 189.3 885 363.8 946c23.5 5.9 19.9-10.8 19.9-22.2v-77.5c-135.7 15.9-141.2-73.9-150.3-88.9C215 726 171.5 718 184.5 703c30.9-15.9 62.4 4 98.9 57.9c26.4 39.1 77.9 32.5 104 26c5.7-23.5 17.9-44.5 34.7-60.8c-140.6-25.2-199.2-111-199.2-213c0-49.5 16.3-95 48.3-131.7c-20.4-60.5 1.9-112.3 4.9-120c58.1-5.2 118.5 41.6 123.2 45.3c33-8.9 70.7-13.6 112.9-13.6c42.4 0 80.2 4.9 113.5 13.9c11.3-8.6 67.3-48.8 121.3-43.9c2.9 7.7 24.7 58.3 5.5 118c32.4 36.8 48.9 82.7 48.9 132.3c0 102.2-59 188.1-200 212.9a127.5 127.5 0 0 1 38.1 91v112.5c.8 9 0 17.9 15 17.9c177.1-59.7 304.6-227 304.6-424.1c0-247.2-200.4-447.3-447.5-447.3z"},null,-1),x=[P];function A(e,t){return m(),f("svg",k,x)}const D={name:"ant-design-github-filled",render:A},E="https://github.com/SuperManito/Arcadia",T=v({name:"LayoutFooter",props:{show:Boolean},setup(){const{getShowFooter:e}=F(),{currentRoute:t}=w(),{prefixCls:n}=$("layout-footer");return{getShowLayoutFooter:u(()=>l(e)&&!l(t).meta?.hiddenFooter),prefixCls:n,GITHUB_URL:E,openWindow:I}}});function V(e,t,n,a,o,r){const _=D;return e.show||e.getShowLayoutFooter?(m(),f("footer",{key:0,class:i(e.prefixCls)},[C(_,{class:i(`${e.prefixCls}__icon`),onClick:t[0]||(t[0]=c=>e.openWindow(e.GITHUB_URL))},null,8,["class"]),h("div",{class:i(`${e.prefixCls}__text`)}," Copyright ©2023 Arcadia Team ",2)],2)):S("",!0)}const N=R(T,[["render",V]]);export{N as F,M as u};
