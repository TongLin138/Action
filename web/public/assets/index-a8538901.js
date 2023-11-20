import{_ as U}from"./PageWrapper.vue_vue_type_style_index_0_lang-f0d6bddb.js";import{u as A}from"./useAppInject-e4ee4e96.js";import{R as D,P as B,aL as K,aK as h,d as z,G as X,S as C,ba as Y,r as I,bb as q,k as J,h as W,bc as Q,o as Z,c as ee,w as b,a as w,e as te,E as ae,y as ne}from"./index-797c0a85.js";import{o as oe}from"./on-fonts-ready-2684803e.js";import{_ as re}from"./Alert-c87d39d3.js";import"./sharp-arrow-back-ios-ca1144ee.js";import"./useDesign-a03ef768.js";import"./Icon-abc31adc.js";import"./monacoEditor-d72532b2.js";const ie=D([B("watermark-container",`
 position: relative;
 `,[K("selectable",`
 user-select: none;
 -webkit-user-select: none;
 `),h("global-rotate",`
 overflow: hidden;
 `),h("fullscreen",`
 top: 0;
 left: 0;
 width: 100%;
 height: 100%;
 pointer-events: none;
 position: fixed;
 `)]),B("watermark",`
 position: absolute;
 top: 0;
 left: 0;
 width: 100%;
 height: 100%;
 pointer-events: none;
 background-repeat: repeat;
 `,[h("fullscreen",`
 position: fixed;
 `),h("global-rotate",`
 position: absolute;
 height: max(284vh, 284vw);
 width: max(284vh, 284vw);
 `)])]);function le(e){if(!e)return 1;const c=e.backingStorePixelRatio||e.webkitBackingStorePixelRatio||e.mozBackingStorePixelRatio||e.msBackingStorePixelRatio||e.oBackingStorePixelRatio||e.backingStorePixelRatio||1;return(window.devicePixelRatio||1)/c}const se=Object.assign(Object.assign({},C.props),{debug:Boolean,cross:Boolean,fullscreen:Boolean,width:{type:Number,default:32},height:{type:Number,default:32},zIndex:{type:Number,default:10},xGap:{type:Number,default:0},yGap:{type:Number,default:0},yOffset:{type:Number,default:0},xOffset:{type:Number,default:0},rotate:{type:Number,default:0},image:String,imageOpacity:{type:Number,default:1},imageHeight:Number,imageWidth:Number,content:String,selectable:{type:Boolean,default:!0},fontSize:{type:Number,default:14},fontFamily:String,fontStyle:{type:String,default:"normal"},fontVariant:{type:String,default:""},fontWeight:{type:Number,default:400},fontColor:{type:String,default:"rgba(128, 128, 128, .3)"},fontStretch:{type:String,default:""},lineHeight:{type:Number,default:14},globalRotate:{type:Number,default:0}}),ce=z({name:"Watermark",props:se,setup(e,{slots:c}){const{mergedClsPrefixRef:p}=X(e),y=C("Watermark","-watermark",ie,Y,e,p),l=I(""),r=q?document.createElement("canvas"):null,t=r?r.getContext("2d"):null,m=I(!1);return oe(()=>m.value=!0),J(()=>{if(!r)return;m.value;const a=le(t),{xGap:i,yGap:f,width:u,height:o,yOffset:d,xOffset:s,rotate:g,image:_,content:k,fontColor:G,fontStyle:H,fontVariant:F,fontStretch:L,fontWeight:M,fontFamily:T,fontSize:V,lineHeight:v,debug:x}=e,j=(i+u)*a,E=(f+o)*a,$=s*a,S=d*a;if(r.width=j,r.height=E,t){t.translate(0,0);const R=u*a,N=o*a;if(x&&(t.strokeStyle="grey",t.strokeRect(0,0,R,N)),t.rotate(g*(Math.PI/180)),_){const n=new Image;n.crossOrigin="anonymous",n.referrerPolicy="no-referrer",n.src=_,n.onload=()=>{t.globalAlpha=e.imageOpacity;const{imageWidth:P,imageHeight:O}=e;t.drawImage(n,$,S,(e.imageWidth||(O?n.width*O/n.height:n.width))*a,(e.imageHeight||(P?n.height*P/n.width:n.height))*a),l.value=r.toDataURL()}}else k&&(x&&(t.strokeStyle="green",t.strokeRect(0,0,R,N)),t.font=`${H} ${F} ${M} ${L} ${V*a}px/${v*a}px ${T||y.value.self.fontFamily}`,t.fillStyle=G,t.fillText(k,$,S+v*a),l.value=r.toDataURL())}else Q("watermark","Canvas is not supported in the browser.")}),()=>{var a;const{globalRotate:i,fullscreen:f,zIndex:u}=e,o=p.value,d=i!==0&&f,s="max(142vh, 142vw)",g=W("div",{class:[`${o}-watermark`,i!==0&&`${o}-watermark--global-rotate`,f&&`${o}-watermark--fullscreen`],style:{transform:i?`translateX(-50%) translateY(-50%) rotate(${i}deg)`:void 0,zIndex:d?void 0:u,backgroundSize:`${e.xGap+e.width}px`,backgroundPosition:i===0?e.cross?`${e.width/2}px ${e.height/2}px, 0 0`:"":e.cross?`calc(${s} + ${e.width/2}px) calc(${s} + ${e.height/2}px), ${s} ${s}`:s,backgroundImage:e.cross?`url(${l.value}), url(${l.value})`:`url(${l.value})`}});return e.fullscreen&&!i?g:W("div",{class:[`${o}-watermark-container`,i!==0&&`${o}-watermark-container--global-rotate`,f&&`${o}-watermark-container--fullscreen`,e.selectable&&`${o}-watermark-container--selectable`],style:{zIndex:d?u:void 0}},(a=c.default)===null||a===void 0?void 0:a.call(c),g)}}}),ye=z({__name:"index",setup(e){const{getIsMobile:c}=A();return(p,y)=>{const l=re,r=ne,t=ce,m=U;return Z(),ee(m,{ref:"pageWrapper","content-full":!0},{default:b(()=>[w(t,{content:"核心机密",cross:"",selectable:"","font-size":16,"line-height":16,width:192,height:128,"x-offset":12,"y-offset":28,rotate:-15},{default:b(()=>[w(r,{bordered:!te(c),style:{height:"100%"}},{default:b(()=>[w(l,{title:"页面开发中",type:"info"},{default:b(()=>[ae(" 下个版本上线 ")]),_:1})]),_:1},8,["bordered"])]),_:1})]),_:1},512)}}});export{ye as default};
