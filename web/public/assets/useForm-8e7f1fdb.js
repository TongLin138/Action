import{a6 as l,as as A,aG as _e,u as r,c3 as Re,c4 as De,c5 as Se,c6 as je,c7 as be,s as W,a$ as Oe,c2 as Te,bm as ye,c8 as $e,b0 as Ae,c9 as Le,b1 as Ue,b2 as Ge,ca as ze,cb as Ee,cc as qe,cd as Je,aM as We,b3 as He,b4 as Ke,ce as Qe,by as Xe,bn as Ye,G as Ze,x as L,r as xe,bP as et,h as O,ah as tt,C as oe,aI as nt,a7 as g,a8 as i,ac as T,a9 as ne,aa as de,aU as z,au as J,aB as U,at as ot,M as pe,aL as D,aC as S,bL as fe,cf as st,aD as $,aw as me,bi as at,aQ as rt,aV as lt,aN as it,aW as ut,bA as ct,bB as dt,c1 as pt,bz as ft,aO as mt,am as gt,aJ as _t,aP as bt,bC as yt,aS as Nt,y as kt}from"./vendor-c47b8ac0.js";import{_ as Pt}from"./question-circle-outlined-fd31b038.js";import{h as H,V as ht,f as Ne,W as ge,e as ke,b as vt,d as wt,X as Ct,Y as It,_ as Bt,Z as Ft,$ as Vt}from"./index-f8002877.js";import{p as b}from"./propTypes-8a448afd.js";import{u as Mt}from"./useBreakpoint-0c103db4.js";const Rt={style:{display:"inline-block"},viewBox:"0 0 1024 1024",width:"1em",height:"1em"},Dt=_e("path",{fill:"currentColor",d:"M890.5 755.3L537.9 269.2c-12.8-17.6-39-17.6-51.7 0L133.5 755.3A8 8 0 0 0 140 768h75c5.1 0 9.9-2.5 12.9-6.6L512 369.8l284.1 391.6c3 4.1 7.8 6.6 12.9 6.6h75c6.5 0 10.3-7.4 6.5-12.7z"},null,-1),St=[Dt];function jt(e,_){return l(),A("svg",Rt,St)}const Ot={name:"ant-design-up-outlined",render:jt},Tt={style:{display:"inline-block"},viewBox:"0 0 1024 1024",width:"1em",height:"1em"},$t=_e("path",{fill:"currentColor",d:"M884 256h-75c-5.1 0-9.9 2.5-12.9 6.6L512 654.2L227.9 262.6c-3-4.1-7.8-6.6-12.9-6.6h-75c-6.5 0-10.3 7.4-6.5 12.7l352.6 486.1c12.8 17.6 39 17.6 51.7 0l352.6-486.1c3.9-5.3.1-12.7-6.4-12.7z"},null,-1),At=[$t];function Lt(e,_){return l(),A("svg",Tt,At)}const Ut={name:"ant-design-down-outlined",render:Lt};function Gt(e){return e?["NPicker","NSelect","NCheckbox","NRadio","NSwitch","NDatePicker","NTimePicker"].includes(e)?"请选择":"请输入":""}function zt(e,_,f=!0){switch(_){case"NDatePicker":case"NTimePicker":e.type=f?"string":"object";break;case"NUpload":case"NCheckboxGroup":case"NDateRangePicker":e.type="array";break;case"NInputNumber":e.type="number";break}}function Et({emit:e,getProps:_,formModel:f,getSchema:y,formElRef:I,defaultFormModel:M,handleFormValues:o}){async function m(){return r(I)?.validate()}async function u(N){N&&N.preventDefault();const{submitFunc:d}=r(_);if(d&&H(d)){await d(f);return}if(r(I))try{return await m(),e("submit",f),f}catch{return!1}}async function v(){await r(I)?.restoreValidation()}async function B(){const{resetFunc:N,submitOnReset:d}=r(_);if(N&&H(N)&&await N(),!r(I))return;r(y).forEach(j=>{Re(f,j.field,()=>be(M.value,j.field)||null)}),await v();const R=o(f);e("reset",R),d&&await u()}function F(){return r(I)?o(f):{}}async function G(N){const d=r(y).map(k=>De(k.field)?k.field[0]:k.field).filter(Boolean);Object.keys(N).forEach(k=>{const R=N[k];d.includes(k)&&(f[k]=Se(R)?je(f[k],R):R)})}return{handleSubmit:u,validate:m,resetFields:B,getFieldsValue:F,clearValidate:v,setFieldsValue:G}}function qt({defaultFormModel:e,getSchema:_,formModel:f}){function y(M){if(!ht(M))return{};const o={};for(const m of Object.entries(M)){let[,u]=m;const[v]=m;!v||Ne(u)&&u.length===0||H(u)||ge(u)||(ke(u)&&(u=u.trim()),W(o,v,u))}return o}function I(){const M=r(_),o={},m=u=>{u.forEach(v=>{const{defaultValue:B,childrens:F}=v;ge(B)||(W(o,v.field,B),W(f,v.field,B)),F&&F?.length>0&&m(F)})};m(M),e.value=o}return{handleFormValues:y,initDefault:I}}const Jt={model:{type:Object,default:{}},disabled:b.bool.def(!1),require:b.bool.def(!1),rulesMessageJoinLabel:b.bool.def(!0),labelWidth:b.stringNumber.def(80),schemas:{type:[Array],default:()=>[]},inline:b.bool.def(!1),size:b.string.def("medium"),labelPlacement:b.string,isFull:b.bool.def(!0),showActionButtonGroup:b.bool.def(!0),showResetButton:b.bool.def(!0),resetButtonOptions:Object,showSubmitButton:b.bool.def(!0),submitButtonOptions:Object,showAdvancedButton:b.bool.def(!0),submitButtonText:b.string,resetButtonText:b.string,gridProps:Object,giProps:Object,formItemProps:Object,baseGridStyle:Object,collapsed:b.bool.def(!1),collapsedRows:b.number.def(1)},p=new Map;p.set("NInput",Oe);p.set("NDynamicInput",Te);p.set("NInputGroup",ye);p.set("NInputGroupLabel",$e);p.set("NInputNumber",Ae);p.set("NAutoComplete",Le);p.set("NSelect",Ue);p.set("NSwitch",Ge);p.set("NCascader",ze);p.set("NSlider",Ee);p.set("NRate",qe);p.set("NTransfer",Je);p.set("NTreeSelect",We);p.set("NDatePicker",He);p.set("NTimePicker",Ke);p.set("NColorPicker",Qe);p.set("NUpload",Xe);p.set("NDivider",Ye);const Wt=Ze({name:"BasicForm",props:{...Jt},emits:["reset","submit","register"],setup(e,{emit:_,attrs:f}){const{t:y}=vt(),{smaller:I,sizeEnum:M}=Mt(),o=L({}),m=xe({}),u=L({}),v=L(null),B=L(null),F=L(!1),G=L(!1),N=et(()=>I(M.MD).value?"top":"left"),d=O(()=>{const n=Object.assign({},e,r(u)),a={rules:{}};return(n.schemas||[]).forEach(P=>{const V=Fe(P);W(a.rules,P.field,V)}),{...n,...r(a)}}),k=O(()=>{const{schemas:n}=r(d);return{schemas:n,model:r(m)}});function R(n){if(Ne(n))return n.join(".");if(ke(n))return n}function j(n){const{rulesMessageJoinLabel:a,label:c,component:P}=n,{rulesMessageJoinLabel:V}=e,w=Reflect.has(n,"rulesMessageJoinLabel")?a:V;return`${Gt(P)}${w?c??"":""}`}function E(n){const{component:a}=n;let c;switch(a){case"NInputTextarea":c="NInput";break;case"NInputPassword":c="NInput";break;case"NDateRangePicker":c="NDatePicker";break;case"NDatetimeRangePicker":c="NDatePicker";break;default:c=a}return p.get(c)}function Y(n){const{component:a,componentProps:c}=n;let P={};switch(a){case null:case void 0:break;case"NInputTextarea":P={type:"textarea"};break;case"NInputPassword":P={type:"password"};break;case"NDateRangePicker":P={type:"daterange"};break;case"NDatetimeRangePicker":P={type:"datetimerange"};break}const V=c??{};return{clearable:!0,placeholder:j(n),disabled:K(n),...P,...V}}function K(n){const{disabled:a}=n,{disabled:c}=r(d);return H(a)?a(k.value):a??c??!1}function Z(n){const{show:a=!0}=n;return H(a)?a(k.value):a}const x=O(()=>Object.assign({size:e.size,type:"default"},u.value.resetButtonOptions)),ee=O(()=>Object.assign({size:e.size,type:"primary"},u.value.submitButtonOptions)),t=O(()=>r(d).inline),s=O(()=>{const{gridProps:n}=r(d);return{responsive:"screen",collapsed:t.value?F.value:!1,cols:1,...n}});function te(n){const{giProps:a}=n,{giProps:c}=r(d);return{span:1,...c,...a}}const Pe=O(()=>{const{labelPlacement:n,...a}=r(d);return{...f,...e,...a,labelPlacement:n??N.value}}),Q=O(()=>{const n=r(v)||r(d).schemas;for(const a of n){const{defaultValue:c,bindVal:P="value",bindUpdateVal:V="update:value"}=a;a.bindVal=P,a.bindUpdateVal=V,c&&(a.defaultValue=c)}return n}),{handleFormValues:he,initDefault:se}=qt({defaultFormModel:o,getSchema:Q,formModel:m}),{handleSubmit:ae,validate:ve,resetFields:re,getFieldsValue:we,clearValidate:Ce,setFieldsValue:le}=Et({emit:_,getProps:d,formModel:m,getSchema:Q,formElRef:B,defaultFormModel:o,handleFormValues:he});function Ie(){F.value=!F.value}async function Be(n){u.value=It(r(u)||{},n)}function Fe(n){const{rules:a=[],show:c,required:P,component:V}=n;let w=tt(a);const ie=["blur","input"],ue=j(n);function Me(h,C){const X=h.message||ue;return C===void 0||Ct(C)||Array.isArray(C)&&C.length===0||typeof C=="string"&&C.trim()===""||typeof C=="object"&&Reflect.has(C,"checked")&&Reflect.has(C,"halfChecked")&&Array.isArray(C.checked)&&Array.isArray(C.halfChecked)&&C.checked.length===0&&C.halfChecked.length===0?Promise.reject(X):Promise.resolve()}(!w||w.length===0)&&P&&(w=[{required:P,validator:Me,trigger:ie}]);const ce=w.findIndex(h=>Reflect.has(h,"required")&&!Reflect.has(h,"validator"));if(ce!==-1){const h=w[ce];wt(c)&&!c&&(h.required=!1),V&&(Reflect.has(h,"type")||zt(h,V),h.message=h.message||ue,h.trigger=ie,V.includes("NInput")&&(h.whitespace=!0))}const q=w.findIndex(h=>h.max);return q!==-1&&!w[q].validator&&(w[q].message=w[q].message||y("component.form.maxTip",[w[q].max])),w}const Ve={getFieldsValue:we,setFieldsValue:le,resetFields:re,validate:ve,clearValidate:Ce,setProps:Be,submit:ae};return oe(()=>Q.value,n=>{r(G)||n?.length&&(se(),G.value=!0)}),oe(()=>r(d).model,n=>{n&&le(n)},{immediate:!0}),nt(()=>{se(),_("register",Ve)}),{t:y,get:be,set:W,formElRef:B,formModel:m,getGrid:s,getGridItem:te,getProps:d,getShow:Z,getFormItemPath:R,getBindValue:Pe,getSchema:Q,getSubmitBtnOptions:ee,getResetBtnOptions:x,handleSubmit:ae,resetFields:re,isInline:t,getComponentProps:Y,getComp:E,unfoldToggle:Ie,componentMap:p}}});function Ht(e,_,f,y,I,M){const o=at,m=Pt,u=rt,v=lt,B=it,F=ut,G=ct,N=dt,d=pt,k=ye,R=ft,j=mt,E=gt,Y=Ut,K=_t,Z=Ot,x=bt,ee=yt;return l(),g(ee,U(e.getBindValue,{ref:"formElRef",model:e.formModel,class:"mt-2"}),{default:i(()=>[T(x,ne(de(e.getGrid)),{default:i(()=>[(l(!0),A(z,null,J(e.getSchema,t=>(l(),A(z,{key:t.field},[e.getShow(t)?(l(),g(j,ne(U({key:0},e.getGridItem(t))),{default:i(()=>[T(R,U({label:t.label,path:e.getFormItemPath(t.field)},t.formItemProps),ot({default:i(()=>[t.slot?pe(e.$slots,t.slot,{key:0,model:e.formModel,field:t.field,value:e.get(e.formModel,t.field)},void 0,!0):t.component==="NCheckbox"?(l(),g(F,{key:1,value:e.formModel[t.field],"onUpdate:value":s=>e.formModel[t.field]=s},{default:i(()=>[T(B,null,{default:i(()=>[(l(!0),A(z,null,J(t?.componentProps?.options,s=>(l(),g(v,{key:s.value,value:s.value,label:s.label},null,8,["value","label"]))),128))]),_:2},1024)]),_:2},1032,["value","onUpdate:value"])):t.component==="NRadioGroup"?(l(),g(N,{key:2,value:e.formModel[t.field],"onUpdate:value":s=>e.formModel[t.field]=s},{default:i(()=>[T(B,ne(de(t?.componentProps?.spaceProps)),{default:i(()=>[(l(!0),A(z,null,J(t?.componentProps?.options,s=>(l(),g(G,{key:s.value,value:s.value},{default:i(()=>[D(S(s.label),1)]),_:2},1032,["value"]))),128))]),_:2},1040)]),_:2},1032,["value","onUpdate:value"])):t.component==="NRadioButtonGroup"?(l(),g(N,{key:3,value:e.formModel[t.field],"onUpdate:value":s=>e.formModel[t.field]=s},{default:i(()=>[(l(!0),A(z,null,J(t?.componentProps?.options,s=>(l(),g(d,{key:s.value,value:s.value},{default:i(()=>[D(S(s.label),1)]),_:2},1032,["value"]))),128))]),_:2},1032,["value","onUpdate:value"])):t.component==="NInputGroup"?(l(),g(k,{key:4},{default:i(()=>[(l(!0),A(z,null,J(t.childrens,s=>(l(),g(fe(e.getComp(s)),U({key:s.filed},e.getComponentProps(s),{value:e.get(e.formModel,s.field??t.field),class:{isFull:(s.isFull??t.isFull)!=!1&&e.getProps.isFull},"onUpdate:value":te=>e.set(e.formModel,s.field??t.field,te)}),{default:i(()=>[D(S(s?.defaultSlot),1)]),_:2},1040,["value","class","onUpdate:value"]))),128))]),_:2},1024)):(l(),g(fe(e.getComp(t)),U({key:5},e.getComponentProps(t),{[t.bindVal||""]:e.get(e.formModel,t.field),class:{isFull:t.isFull!=!1&&e.getProps.isFull}},{[st(t.bindUpdateVal)]:s=>e.set(e.formModel,t.field,s)}),null,16,["class"])),t.suffix?pe(e.$slots,t.suffix,{key:6,model:e.formModel,field:t.field,value:e.get(e.formModel,t.field)},void 0,!0):$("",!0)]),_:2},[t.subLabel||t.labelMessage?{name:"label",fn:i(()=>[D(S(t.label)+" ",1),t.subLabel?(l(),g(o,{key:0,depth:3,class:"mr-2"},{default:i(()=>[D(S(t.subLabel),1)]),_:2},1024)):$("",!0),t.labelMessage?(l(),g(u,{key:1,trigger:"hover",style:me(t.labelMessageStyle)},{trigger:i(()=>[T(m,{class:"text-18px cursor-pointer text-$app-text-color-3"})]),default:i(()=>[D(" "+S(t.labelMessage),1)]),_:2},1032,["style"])):$("",!0)]),key:"0"}:void 0]),1040,["label","path"])]),_:2},1040)):$("",!0)],64))),128)),e.getProps.showActionButtonGroup?(l(),g(j,{key:0,span:e.isInline?"":24,suffix:!!e.isInline},{default:i(({overflow:t})=>[T(B,{align:"center",justify:e.isInline?"end":"start",style:me({"margin-left":`${e.isInline?12:e.getProps.labelWidth}px`,"margin-bottom":"24px"})},{default:i(()=>[e.getProps.showSubmitButton?(l(),g(E,U({key:0},e.getSubmitBtnOptions,{onClick:e.handleSubmit}),{default:i(()=>[D(S(e.getProps.submitButtonText??e.t("common.queryText")),1)]),_:1},16,["onClick"])):$("",!0),e.getProps.showResetButton?(l(),g(E,U({key:1},e.getResetBtnOptions,{onClick:e.resetFields}),{default:i(()=>[D(S(e.getProps.resetButtonText??e.t("common.resetText")),1)]),_:1},16,["onClick"])):$("",!0),e.isInline&&e.getProps.showAdvancedButton?(l(),g(E,{key:2,type:"primary",text:"","icon-placement":"right",onClick:e.unfoldToggle},{icon:i(()=>[t?(l(),g(K,{key:0,size:"14",class:"unfold-icon"},{default:i(()=>[T(Y)]),_:1})):(l(),g(K,{key:1,size:"14",class:"unfold-icon"},{default:i(()=>[T(Z)]),_:1}))]),default:i(()=>[D(" "+S(t?"展开":"收起"),1)]),_:2},1032,["onClick"])):$("",!0)]),_:2},1032,["justify","style"])]),_:1},8,["span","suffix"])):$("",!0)]),_:3},16)]),_:3},16,["model"])}const xt=Bt(Wt,[["render",Ht],["__scopeId","data-v-99776a72"]]);function en(e){const _=L(null),f=L(!1);async function y(){const o=r(_);return o||console.error("The form instance has not been obtained, please make sure that the form has been rendered when performing the form operation!"),await kt(),o}function I(o){Nt(()=>{_.value=null,f.value=null}),!(r(f)&&Ft()&&o===r(_))&&(_.value=o,f.value=!0,oe(()=>e,()=>{e&&o.setProps(Vt(e))},{immediate:!0,deep:!0}))}return[I,{setProps:async o=>{await(await y()).setProps(o)},resetFields:async()=>{y().then(async o=>{await o.resetFields()})},clearValidate:async o=>{await(await y()).clearValidate(o)},getFieldsValue:()=>r(_)?.getFieldsValue(),setFieldsValue:async o=>{await(await y()).setFieldsValue(o)},submit:async()=>(await y()).submit(),validate:async o=>(await y()).validate(o)}]}export{xt as _,en as u};