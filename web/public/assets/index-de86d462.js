import{_ as P}from"./PageWrapper.vue_vue_type_style_index_0_lang-8acb7284.js";import{u as y}from"./useAppInject-eccad02d.js";import{b as w}from"./index-d34c0c00.js";import{_ as z}from"./PasswordChange.vue_vue_type_script_setup_true_lang-aa2e5319.js";import{_ as k}from"./Personalized.vue_vue_type_script_setup_true_lang-980cc814.js";import I from"./PasswordChange-852ebd77.js";import $ from"./Personalized-3aaf4c49.js";import{G as j,r as B,al as s,aJ as p,x as M,h as m,a6 as u,a7 as _,a8 as n,ac as d,aG as f,u as e,aE as N,av as D,bH as G,aC as H,bI as V,aH as A}from"./vendor-3aaf0758.js";import"./sharp-arrow-back-ios-881c0b7d.js";import"./useDesign-4409cc98.js";import"./useForm-f529811b.js";import"./question-circle-outlined-94183e9b.js";import"./propTypes-8a448afd.js";import"./useBreakpoint-c5ef6959.js";const E={class:"grid grid-cols-1 lg:grid-cols-[auto_1fr] gap-x-6 gap-y-4"},J={class:"text-xl mt-2 mb-4"},oe=j({__name:"index",setup(O){const{t}=w(),g={PasswordChange:z,Personalized:k},r=B([{label:"setting.menu.changePwd",key:"PasswordChange",icon:()=>s(p,null,{default:()=>s(I)})},{label:"setting.menu.personalized",key:"Personalized",icon:()=>s(p,null,{default:()=>s($)})}]),o=M("PasswordChange"),{getIsMobile:l}=y(),b=m(()=>l.value?"horizontal":"vertical"),v=m(()=>r.find(i=>i.key===o.value)?.label);return(i,c)=>{const h=V,x=A,C=P;return u(),_(C,null,{default:n(()=>[d(x,null,{default:n(()=>[f("div",E,[d(h,{value:e(o),"onUpdate:value":c[0]||(c[0]=a=>N(o)?o.value=a:null),options:e(r).map(a=>({...a,label:e(t)(a.label)})),mode:e(b),class:D([e(l)?"justify-center":"w-200px border-r justify-center border-$app-border-color transition-all ease-in-out-300"])},null,8,["value","options","mode","class"]),(u(),_(G(g[e(o)]),null,{title:n(()=>[f("div",J,H(e(t)(e(v))),1)]),_:1}))])]),_:1})]),_:1})}}});export{oe as default};