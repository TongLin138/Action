import{a7 as a,aK as r,av as c,I as l,y as p,h as d,u as n,aa as _,ay as t,aF as m}from"./vendor-CVUNLYN4.js";import{h,Y as f,d as g}from"./index-BW0Kz9QR.js";import{u as C}from"./useDesign-DCKbhR-1.js";const y={style:{display:"inline-block"},viewBox:"0 0 1024 1024",width:"1em",height:"1em"},w=c("path",{fill:"currentColor",d:"M511.6 76.3C264.3 76.2 64 276.4 64 523.5C64 718.9 189.3 885 363.8 946c23.5 5.9 19.9-10.8 19.9-22.2v-77.5c-135.7 15.9-141.2-73.9-150.3-88.9C215 726 171.5 718 184.5 703c30.9-15.9 62.4 4 98.9 57.9c26.4 39.1 77.9 32.5 104 26c5.7-23.5 17.9-44.5 34.7-60.8c-140.6-25.2-199.2-111-199.2-213c0-49.5 16.3-95 48.3-131.7c-20.4-60.5 1.9-112.3 4.9-120c58.1-5.2 118.5 41.6 123.2 45.3c33-8.9 70.7-13.6 112.9-13.6c42.4 0 80.2 4.9 113.5 13.9c11.3-8.6 67.3-48.8 121.3-43.9c2.9 7.7 24.7 58.3 5.5 118c32.4 36.8 48.9 82.7 48.9 132.3c0 102.2-59 188.1-200 212.9a127.5 127.5 0 0 1 38.1 91v112.5c.8 9 0 17.9 15 17.9c177.1-59.7 304.6-227 304.6-424.1c0-247.2-200.4-447.3-447.5-447.3"},null,-1),F=[w];function v(o,e){return a(),r("svg",y,[...F])}const B={name:"ant-design-github-filled",render:v},$="https://github.com/SuperManito/Arcadia",L=l({name:"LayoutFooter",props:{show:Boolean},setup(){const{getShowFooter:o}=h(),{currentRoute:e}=p(),{prefixCls:s}=C("layout-footer");return{getShowLayoutFooter:d(()=>n(o)&&!n(e).meta?.hiddenFooter),prefixCls:s,GITHUB_URL:$,openWindow:f}}});function S(o,e,s,i,k,R){const u=B;return o.show||o.getShowLayoutFooter?(a(),r("footer",{key:0,class:t(o.prefixCls)},[_(u,{class:t(`${o.prefixCls}__icon`),onClick:e[0]||(e[0]=b=>o.openWindow(o.GITHUB_URL))},null,8,["class"]),c("div",{class:t(`${o.prefixCls}__text`)}," Copyright ©2024 Arcadia Team ",2)],2)):m("",!0)}const I=g(L,[["render",S]]);export{I as F};
