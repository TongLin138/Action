import{_ as k,a as T}from"./wb-sunny-outline-CqkdVQ3G.js";import{I as S,q as I,A as C,am as n,aE as r,a7 as i,a8 as c,a9 as m,aa as D,u as e,aF as E,aG as M,ap as z,aH as N}from"./vendor-CVUNLYN4.js";import{I as u}from"./Icon-ljQHnwJa.js";import{u as R,a as w,T as a}from"./index-BW0Kz9QR.js";import"./propTypes-CYyueTg3.js";const q=S({__name:"DarkModeToggle",setup(A){const[o,d]=R(),{t:s}=w(),p=I(),t=C(o.value),g=[{label:()=>n(r,{style:"gap: 8px; height: 18px"},{default:()=>[n(u,{size:18,icon:"line-md:computer",style:"vertical-align: baseline"},{}),s("common.followSystem")]}),value:a.SYSTEM},{label:()=>n(r,{style:"gap: 8px; height: 18px"},{default:()=>[n(u,{size:18,icon:"line-md:sunny-outline",style:"vertical-align: baseline"},{}),s("common.light")]}),value:a.LIGHT},{label:()=>n(r,{style:"gap: 8px; height: 18px"},{default:()=>[n(u,{size:18,icon:"line-md:moon",style:"vertical-align: baseline"},{}),s("common.dark")]}),value:a.DARK}],f=l=>({async onClick(){l.value!==o.value&&d(l.value)}});return(l,_)=>{const y=k,v=T,b=z,h=N;return i(),c(h,{value:e(t),"onUpdate:value":_[0]||(_[0]=x=>M(t)?t.value=x:null),options:g,trigger:"click","node-props":f},{default:m(()=>[D(b,{quaternary:"",strong:"",size:"large",focusable:!1,class:"app-layout-header-anction-icon",style:{"border-radius":"0",transition:".2s"}},{default:m(()=>[e(o)===e(a).LIGHT||e(o)===e(a).SYSTEM&&!e(p)?(i(),c(y,{key:0,class:"text-18px",style:{color:"rgb(51, 54, 57)"}})):e(o)===e(a).DARK||e(o)===e(a).SYSTEM&&e(p)?(i(),c(v,{key:1,class:"text-18px",style:{color:"rgba(255, 255, 255, 0.82)"}})):E("",!0)]),_:1})]),_:1},8,["value"])}}});export{q as default};