import{_ as P}from"./PageWrapper.vue_vue_type_style_index_0_lang-03fea7bc.js";import{u as y}from"./useAppInject-dd275d0f.js";import{b as w}from"./index-18ef6ea1.js";import{_ as z}from"./PasswordChange.vue_vue_type_script_setup_true_lang-a66ae415.js";import{_ as k}from"./Personalized.vue_vue_type_script_setup_true_lang-e2808568.js";import I from"./PasswordChange-27167aa1.js";import $ from"./Personalized-46ef9403.js";import{G as j,r as B,al as s,aJ as p,x as M,h as m,a6 as u,a7 as _,a8 as n,ac as d,aG as f,u as e,aE as N,av as D,bK as G,aC as V,bL as A,aH as E}from"./vendor-95d24bd5.js";import"./sharp-arrow-back-ios-6d3804a3.js";import"./useDesign-04e0d610.js";import"./useForm-667e65fa.js";import"./question-circle-outlined-b38cad74.js";import"./propTypes-8a448afd.js";import"./useBreakpoint-ad41d372.js";const H={class:"grid grid-cols-1 lg:grid-cols-[auto_1fr] gap-x-6 gap-y-4"},J={class:"text-xl mt-2 mb-4"},oe=j({__name:"index",setup(K){const{t}=w(),g={PasswordChange:z,Personalized:k},r=B([{label:"setting.menu.changePwd",key:"PasswordChange",icon:()=>s(p,null,{default:()=>s(I)})},{label:"setting.menu.personalized",key:"Personalized",icon:()=>s(p,null,{default:()=>s($)})}]),o=M("PasswordChange"),{getIsMobile:l}=y(),b=m(()=>l.value?"horizontal":"vertical"),v=m(()=>r.find(i=>i.key===o.value)?.label);return(i,c)=>{const h=A,x=E,C=P;return u(),_(C,null,{default:n(()=>[d(x,null,{default:n(()=>[f("div",H,[d(h,{value:e(o),"onUpdate:value":c[0]||(c[0]=a=>N(o)?o.value=a:null),options:e(r).map(a=>({...a,label:e(t)(a.label)})),mode:e(b),class:D([e(l)?"justify-center":"w-200px border-r justify-center border-$app-border-color transition-all ease-in-out-300"])},null,8,["value","options","mode","class"]),(u(),_(G(g[e(o)]),null,{title:n(()=>[f("div",J,V(e(t)(e(v))),1)]),_:1}))])]),_:1})]),_:1})}}});export{oe as default};