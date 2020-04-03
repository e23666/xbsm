/*
    ͨ�ñ���֤����
    Validform version 5.1
	By sean during April 7, 2010 - July 31, 2012
	For more information, please visit http://validform.rjboy.cn
	Validform is available under the terms of the MIT license.
	
	Demo:
	$(".demoform").Validform({//$(".demoform")ָ������һ����Ҫ��֤,���������form����;
		btnSubmit:"#btn_sub", //#btn_sub�Ǹñ���Ҫ�󶨵���ύ���¼��İ�ť;���form�ں���submit��ť�ò�����ʡ��;
		btnReset:".btn_reset",//��ѡ�� .btn_reset�Ǹñ���Ҫ�󶨵�����ñ��¼��İ�ť;
		tiptype:1, //��ѡ�� 1=>pop box,2=>side tip��Ĭ��Ϊ1��Ҳ���Դ���һ��function�������Զ�����ʾ��Ϣ����ʾ��ʽ������ʵ������Ҫ���κ�Ч��������μ�demoҳ��;
		ignoreHidden:false,//��ѡ�� true | false Ĭ��Ϊfalse����Ϊtrueʱ��:hidden�ı�Ԫ�ؽ�������֤;
		dragonfly:false,//��ѡ�� true | false Ĭ��false����Ϊtrueʱ��ֵΪ��ʱ������֤��
		tipSweep:true,//��ѡ�� true | false Ĭ��Ϊfalse����trueʱ��ʾ��Ϣ��ֻ���ڱ��ύʱ������ʾ������Ԫ��blurʱ���ᱻ������ʾ;
		showAllError:false,//��ѡ�� true | false��true���ύ��ʱ���д�����ʾ��Ϣ������ʾ��false��һ������֤��ͨ���ľ�ֹͣ�������Ԫ�أ�ֻ��ʾ��Ԫ�صĴ�����Ϣ;
		postonce:true, //��ѡ�� �Ƿ���������ʱ�Ķ����ύ������true������������Ĭ�Ϲر�;
		ajaxPost:true, //ʹ��ajax��ʽ�ύ�����ݣ�Ĭ��false���ύ��ַ����actionָ����ַ;
		datatype:{//�����Զ���datatype���ͣ�����������Ҳ�����Ǻ����������ڻᴫ��һ��������;
			"*6-20": /^[^\s]{6,20}$/,
			"z2-4" : /^[\u4E00-\u9FA5\uf900-\ufa2d]{2,4}$/,
			"username":function(gets,obj,curform,regxp){
				//����gets�ǻ�ȡ���ı�Ԫ��ֵ��objΪ��ǰ��Ԫ�أ�curformΪ��ǰ��֤�ı���regxpΪ���õ�һЩ������ʽ������;
				var reg1=/^[\w\.]{4,16}$/,
					reg2=/^[\u4E00-\u9FA5\uf900-\ufa2d]{2,8}$/;
				
				if(reg1.test(gets)){return true;}
				if(reg2.test(gets)){return true;}
				return false;
				
				//ע��return���Է���true �� false �� �ַ������֣�true��ʾ��֤ͨ���������ַ�����ʾ��֤ʧ�ܣ��ַ�����Ϊ������ʾ��ʾ������false����errmsg��Ĭ�ϵĴ�����ʾ;
			},
			"phone":function(){
				// 5.0 �汾֮��Ҫʵ�ֶ�ѡһ����֤Ч����datatype ������ �� ��Ҫ�� "option_" ��ͷ;	
			}
		},
		usePlugin:{
			swfupload:{},
			datepicker:{},
			passwordstrength:{},
			jqtransform:{
				selector:"select,input"
			}
		},
		beforeCheck:function(curform){
			//�ڱ��ύִ����֤֮ǰִ�еĺ�����curform�����ǵ�ǰ������
			//������ȷreturn false�Ļ����������ִ����֤����;	
		},
		beforeSubmit:function(curform){
			//����֤�ɹ��󣬱��ύǰִ�еĺ�����curform�����ǵ�ǰ������
			//������ȷreturn false�Ļ����������ύ;	
		},
		callback:function(data){
			//��������data��json��ʽ��{"info":"demo info","status":"y"}
			//info: �����ʾ��Ϣ;
			//status: �����ύ���ݵ�״̬,�Ƿ��ύ�ɹ����������"y"��ʾ�ύ�ɹ���"n"��ʾ�ύʧ�ܣ���ajax_post.php�ļ������������Զ��ַ�����Ҫ����callback��������ݸ�ִֵ����Ӧ�Ļص�����;
			//��Ҳ������ajax_post.php�ļ����ظ�����Ϣ�������ȡ��������Ӧ������
			
			//����ִ�лص�����;
			//ע�⣺�������ajax��ʽ�ύ��������callback����ʱdata�����ǵ�ǰ�����󣬻ص��������ڱ���֤ȫ��ͨ����ִ�У�Ȼ���ж��Ƿ��ύ�������callback����ȷreturn false����������ύ�����return true��û��return������ύ����
		}
	});
	
	Validform����ķ��������ԣ�
	tipmsg���Զ�����ʾ��Ϣ��ͨ���޸�Validform������������ֵ����ͬһ��ҳ��Ĳ�ͬ��ʹ�ò�ͬ����ʾ���֣�
	dataType����ȡ���õ�һЩ����
	eq(n)����ȡValidform����ĵ�n��Ԫ��;
	ajaxPost(flag,sync)����ajax��ʽ�ύ����flagΪtrueʱ��������ֱ֤���ύ��syncΪtrueʱ����ͬ���ķ�ʽ����ajax�ύ��
	abort()����ֹajax���ύ��
	submitForm(flag)���Բ��������õķ�ʽ�ύ����flagΪtrueʱ��������ֱ֤���ύ��
	resetForm()�����ñ���
	resetStatus()�����ñ����ύ״̬��������postonce�����Ļ������ɹ��ύ��״̬������Ϊ"posted"�������ύ״̬�����ñ����������ύ��
	getStatus()����ȡ�����ύ״̬��normal��δ�ύ��posting�������ύ��posted���ѳɹ��ύ����
	setStatus(status)�����ñ����ύ״̬����������normal��posting��posted����״̬��������������״̬Ϊposting�����״̬��������֤���������ύ��
	ignore(selector)�����Զ���ѡ��������֤��
	unignore(selector)����ignore������������֤�Ķ������»�ȡ��֤Ч����
	addRule(rule)������ͨ��Validform������������������Ԫ�ذ���֤����
*/

(function($,win,undef){
	var errorobj=null,//ָʾ��ǰ��֤ʧ�ܵı�Ԫ��;
		msgobj=null,//pop box object 
		msghidden=true; //msgbox hidden?

	var tipmsg={//Ĭ����ʾ����;
		tit:"��ʾ��Ϣ",
		w:"��������ȷ��Ϣ��",
		r:"ͨ����Ϣ��֤��",
		c:"���ڼ����Ϣ��",
		s:"��������Ϣ��",
		v:"������Ϣû�о�����֤�����Ժ�",
		p:"�����ύ���ݡ�",
		err:"�����ˣ������ύ��ַ�򷵻����ݸ�ʽ�Ƿ���ȷ��",
		abort:"Ajax������ȡ����"
	}
	$.Tipmsg=tipmsg;
		
	var Validform=function(forms,settings,inited){
		var settings=$.extend({},Validform.defaults,settings);
		settings.datatype && $.extend(Validform.util.dataType,settings.datatype);
		
		var brothers=this;
		brothers.tipmsg={};
		brothers.settings=settings;
		brothers.forms=forms;
		brothers.objects=[];
		
		//�����Ӷ���ʱ���ٰ��¼�;
		if(inited===true){
			return false;	
		}
		
		forms.each(function(n){
			var $this=$(this);
			
			//��ֹ����ť˫���ύ����;
			this.status="normal"; //normal | posting | posted;
			
			//��ÿ��Validform�������Զ���tipmsg;	
			$this.data("tipmsg",brothers.tipmsg);

			//bind the blur event;
			$this.find("[datatype]").on("blur",function(){
				//�ж��Ƿ������ύ������ʱ��������֤����
				var subpost=arguments[1];
				var inputval=Validform.util.getValue.call($this,$(this));
				
				//����dataIgnore���ԵĶ���Ҳ������֤;
				//dragonfly=trueʱ��ֵΪ�ղ�����֤;
				if($(this).data("dataIgnore")==="dataIgnore" || settings.dragonfly && !$(this).data("cked") && Validform.util.isEmpty.call($(this),inputval) ){
					return false;
				}
				
				var flag=true,
					_this;
				errorobj=_this=$(this);

				flag=Validform.util.regcheck.call($this,$(this).attr("datatype"),inputval,$(this));
				if(!flag.passed){
					//ȡ�����ڽ��е�ajax��֤;
					Validform.util.abort.call(_this[0]);
					_this.addClass("Validform_error");
					Validform.util.showmsg.call($this,flag.info,settings.tiptype,{obj:$(this),type:flag.type,sweep:settings.tipSweep},"hide"); //��tiptype=1������£�����"hide"������ʾ�򲻵���,tiptype=2������¸��Ӳ���"hide"��������;
				}else{
					if($(this).attr("ajaxurl")){
						var inputobj=$(this);
						if(inputobj[0].valid==="posting"){return false;}
						
						inputobj[0].valid="posting";
						Validform.util.showmsg.call($this,brothers.tipmsg.c||tipmsg.c,settings.tiptype,{obj:inputobj,type:1,sweep:settings.tipSweep},"hide");
						
						Validform.util.abort.call(_this[0]);
						_this[0].ajax=$.ajax({
							type: "POST",
							cache:false,
							url: inputobj.attr("ajaxurl"),
							data: "param="+escape(inputval)+"&name="+$(this).attr("name"),
							dataType: "text",
							success: function(s){
								if($.trim(s)=="y"){
									inputobj[0].valid="true";
									Validform.util.showmsg.call($this,brothers.tipmsg.r||tipmsg.r,settings.tiptype,{obj:inputobj,type:2,sweep:settings.tipSweep},"hide");
									_this.removeClass("Validform_error");
									errorobj=null;
									if(subpost==="postform"){
										$this.trigger("submit");
									}
								}else{
									inputobj[0].valid=s;
									_this.addClass("Validform_error");
									Validform.util.showmsg.call($this,s,settings.tiptype,{obj:inputobj,type:3,sweep:settings.tipSweep});
								}
								_this[0].ajax=null;
							},
							error: function(){
								inputobj[0].valid=brothers.tipmsg.err || tipmsg.err;
								_this.addClass("Validform_error");
								_this[0].ajax=null;
								Validform.util.showmsg.call($this,brothers.tipmsg.err||tipmsg.err,settings.tiptype,{obj:inputobj,type:3,sweep:settings.tipSweep});	
							}
						});
					}else{
						Validform.util.showmsg.call($this,flag.info,settings.tiptype,{obj:$(this),type:flag.type,sweep:settings.tipSweep},"hide");
						_this.removeClass("Validform_error");
						errorobj=null;
					}
				}

			});
			
			//�����Ԫ�أ�Ĭ��������ʧЧ��;
			Validform.util.hasDefaultText.call($this);
			
			//��Ԫ��ֵ�Ƚ�ʱ����Ϣ��ʾ��ǿ;
			Validform.util.recheckEnhance.call($this);
			
			//plugins here to start;
			if(settings.usePlugin){
				Validform.util.usePlugin.call($this,settings.usePlugin,settings.tiptype,settings.tipSweep,n);
			}
			
			//enhance info feedback for checkbox & radio;
			$this.find(":checkbox[datatype],:radio[datatype]").each(function(){
				var _this=$(this);
				var name=_this.attr("name");
				$this.find("[name='"+name+"']").filter(":checkbox,:radio").bind("click",function(){
					//�������¼���ʱ��ȡֵ�ͺ�����;
					setTimeout(function(){
						_this.trigger("blur");
					},0);
				});
				
			});
			
			settings.btnSubmit && $this.find(settings.btnSubmit).bind("click",function(){
				var subflag=Validform.util.submitForm.call($this,settings);
				subflag === undef && (subflag=true);
				if(subflag===true){
					$this[0].submit();
				}
			});
						
			$this.submit(function(){
				var subflag=Validform.util.submitForm.call($this,settings);
				subflag === undef && (subflag=true);
				return subflag;
			});
			
			$this.find("[type='reset']").add($this.find(settings.btnReset)).bind("click",function(){
				Validform.util.resetForm.call($this);
			});
			
		});
		
		//Ԥ����pop box;
		if( settings.tiptype==1 || (settings.tiptype==2 && settings.ajaxPost) ){		
			creatMsgbox();
		}
	}
	
	Validform.defaults={
		tiptype:1,
		tipSweep:false,
		showAllError:false,
		postonce:false,
		ajaxPost:false
	}
	
	Validform.util={
		dataType:{
			"match":/^(.+?)(\d+)-(\d+)$/,
			"*":/[\w\W]+/,
			"*6-16":/^[\w\W]{6,16}$/,
			"n":/^\d+$/,
			"n6-16":/^\d{6,16}$/,
			"s":/^[\u4E00-\u9FA5\uf900-\ufa2d\w\.\s]+$/,
			"s6-18":/^[\u4E00-\u9FA5\uf900-\ufa2d\w\.\s]{6,18}$/,
			"s2-30":/^[\u4E00-\u9FA5\uf900-\ufa2d\w\.\s]{2,30}$/,
			"p":/^[0-9]{6}$/,
			"m":/^1[0-9]{10}$/,
			"e":/^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/,
			"url":/^(\w+:\/\/)?\w+(\.\w+)+.*$/,
			"pwd":/^[A-Za-z0-9\!\#\$\%\^\&\*\.\~]{6,18}$/,
			"ip4":/^((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)$/,
			"dm":/^[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\.?/,
			"cn2-18":/^[\u4E00-\u9FA5\uf900-\ufa2d\(\)]{2,30}$/,
			"cn1-18":/^[\u4E00-\u9FA5\uf900-\ufa2d]{1,30}$/,
			"cncity":/^[\u4E00-\u9FA5\uf900-\ufa2d]{2,18}$/,
			"cnaddress":/^[\u4E00-\u9FA5\uf900-\ufa2d]{1}[\u4E00-\u9FA5\uf900-\ufa2d\w\.\s-#]{5,30}$/,
			"enname":/^[a-zA-Z\.\s]{4,150}$/,
			"enname2":/^[a-zA-Z\.\s]{2,150}$/,
			"enaddress":/^[0-9a-zA-Z\_\-\.\s#,]{4,75}$/,
			"zip":/^[\d]{6}$/,
			"tel":/^([\d]{3,4})(-)([\d]{7,8})$|^([\d]{7,8})$|^1([\d]{10})$/,
			"fax":/^([\d]{3,4})(-)([\d]{7,8})$|^([\d]{7,8})$|^1([\d]{10})$/,
			"ftp":/^[a-zA-Z]{1}[a-zA-Z0-9_-]{3,15}$/,
			"co":/[\u4E00-\u9FA5]{2,16}/,
			"qq":/^\d{4,13}$/
			 
		},
		
		toString:Object.prototype.toString,
		
		getValue:function(obj){
			var inputval,
				curform=this;
				
			if(obj.is(":radio")){
				inputval=curform.find(":radio[name='"+obj.attr("name")+"']:checked").val();
				inputval= inputval===undef ? "" : inputval;
			}else if(obj.is(":checkbox")){
				inputval=curform.find(":checkbox[name='"+obj.attr("name")+"']:checked").val();
				inputval= inputval===undef ? "" : inputval;
			}else{
				inputval=obj.val();
			}
			return $.trim(inputval);
		},
		
		isEmpty:function(val){
			return val==="" || val===$.trim(this.attr("tip"));
		},
		
		recheckEnhance:function(){
			var curform=this;
			curform.find("input[recheck]").each(function(){
				var _this=$(this);
				var recheckinput=curform.find("input[name='"+$(this).attr("recheck")+"']");
				recheckinput.bind("keyup",function(){
					if(recheckinput.val()==_this.val() && recheckinput.val() != ""){
						if(recheckinput.attr("tip")){
							if(recheckinput.attr("tip") == recheckinput.val()){return false;}
						}
						_this.trigger("blur");
					}
				}).bind("blur",function(){
					if(recheckinput.val()!=_this.val() && _this.val()!=""){
						if(_this.attr("tip")){
							if(_this.attr("tip") == _this.val()){return false;}	
						}
						_this.trigger("blur");
					}
				});
			});
		},
		
		hasDefaultText:function(){
			this.find("[tip]").each(function(){//tip�Ǳ�Ԫ�ص�Ĭ����ʾ��Ϣ,���ǵ�����Ч��;
				var defaultvalue=$(this).attr("tip");
				var altercss=$(this).attr("altercss");
				$(this).focus(function(){
					if($(this).val()==defaultvalue){
						$(this).val('');
						if(altercss){$(this).removeClass(altercss);}
					}
				}).blur(function(){
					if($.trim($(this).val())===''){
						$(this).val(defaultvalue);
						if(altercss){$(this).addClass(altercss);}
					}
				});
			});
		},
		
		usePlugin:function(plugin,tiptype,tipSweep,n){
			/*
				plugin:settings.usePlugin;
				tiptype:settings.tiptype;
				tipSweep:settings.tipSweep;
				n:��ǰ��������;
			*/
			
			var curform=this;
			//swfupload;
			if(plugin.swfupload){
				var swfuploadinput=curform.find("input[plugin='swfupload']").val(""),
					custom={
						custom_settings:{
							form:curform,
							showmsg:function(msg,type){
								Validform.util.showmsg.call(curform,msg,tiptype,{obj:swfuploadinput,type:type,sweep:tipSweep});	
							}	
						}	
					};

				custom=$.extend(true,{},plugin.swfupload,custom);
				if(typeof(swfuploadhandler) != "undefined"){swfuploadhandler.init(custom,n);}
				
			}
			
			//datepicker;
			if(plugin.datepicker){
				if(plugin.datepicker.format){
					Date.format=plugin.datepicker.format; 
					delete plugin.datepicker.format;
				}
				if(plugin.datepicker.firstDayOfWeek){
					Date.firstDayOfWeek=plugin.datepicker.firstDayOfWeek; 
					delete plugin.datepicker.firstDayOfWeek;
				}
				
				var datepickerinput=curform.find("input[plugin='datepicker']");
				plugin.datepicker.callback && datepickerinput.bind("dateSelected",function(){
					var d=new Date( $.event._dpCache[this._dpId].getSelected()[0] ).asString(Date.format);
					plugin.datepicker.callback(d,this);
				});
				
				datepickerinput.datePicker(plugin.datepicker);
			}
			
			//passwordstrength;
			if(plugin.passwordstrength){
				plugin.passwordstrength.showmsg=function(obj,msg,type){
					Validform.util.showmsg.call(curform,msg,tiptype,{obj:obj,type:type,sweep:tipSweep},"hide");
				};
				curform.find("input[plugin*='passwordStrength']").passwordStrength(plugin.passwordstrength);
			}
			
			//jqtransform;
			if(plugin.jqtransform){
				var jqTransformHideSelect = function(oTarget){
					var ulVisible = $('.jqTransformSelectWrapper ul:visible');
					ulVisible.each(function(){
						var oSelect = $(this).parents(".jqTransformSelectWrapper:first").find("select").get(0);
						//do not hide if click on the label object associated to the select
						if( !(oTarget && oSelect.oLabel && oSelect.oLabel.get(0) == oTarget.get(0)) ){$(this).hide();}
					});
				};
				
				/* Check for an external click */
				var jqTransformCheckExternalClick = function(event) {
					if ($(event.target).parents('.jqTransformSelectWrapper').length === 0) { jqTransformHideSelect($(event.target)); }
				};
				
				var jqTransformAddDocumentListener = function (){
					$(document).mousedown(jqTransformCheckExternalClick);
				};
				
				if(plugin.jqtransform.selector){
					curform.find(plugin.jqtransform.selector).filter('input:submit, input:reset, input[type="button"]').jqTransInputButton();
					curform.find(plugin.jqtransform.selector).filter('input:text, input:password').jqTransInputText();			
					curform.find(plugin.jqtransform.selector).filter('input:checkbox').jqTransCheckBox();
					curform.find(plugin.jqtransform.selector).filter('input:radio').jqTransRadio();
					curform.find(plugin.jqtransform.selector).filter('textarea').jqTransTextarea();
					if(curform.find(plugin.jqtransform.selector).filter("select").length > 0 ){
						 curform.find(plugin.jqtransform.selector).filter("select").jqTransSelect();
						 jqTransformAddDocumentListener();
					}
					
				}else{
					curform.jqTransform();
				}
				
				curform.find(".jqTransformSelectWrapper").find("li a").click(function(){
					curform.find("select").trigger("blur");	
				});
			}

		},

		regcheck:function(datatype,gets,obj){
			/*
				datatype:datatype;
				gets:inputvalue;
				obj:input object;
			*/
			var curform=this,
				info=null,
				passed=false,
				type=3;//default set to wrong type, 2,3,4;
				
			//ignore;
			if(obj.attr("ignore")==="ignore" && Validform.util.isEmpty.call(obj,gets)){				
				if(obj.data("cked")){
					info="";	
				}
				
				return {
					passed:true,
					type:4,
					info:info
				};
			}

			obj.data("cked","cked");//do nothing if is the first time validation triggered;

			//default value;
			if($.trim(obj.attr("tip")) && gets===$.trim(obj.attr("tip")) ){
				return {
					passed:false,
					type:3,
					info:obj.attr("nullmsg") || curform.data("tipmsg").s || tipmsg.s
				};
			}
			
			if(Validform.util.toString.call(Validform.util.dataType[datatype])=="[object Function]"){
				passed=Validform.util.dataType[datatype](gets,obj,curform,Validform.util.dataType);
				if(passed === true){
					type=2;
					info=curform.data("tipmsg").r||tipmsg.r;
					
					if(obj.attr("recheck")){
						var theother=curform.find("input[name='"+obj.attr("recheck")+"']:first");
						if(gets!=theother.val()){
							passed=false;
							type=3;
							info=obj.attr("errormsg")  || curform.data("tipmsg").w || tipmsg.w;
						}
					}
					
				}else{
					info= passed || obj.attr("errormsg") || curform.data("tipmsg").w || tipmsg.w;
					passed=false;
					if(gets===""){//��֤��ͨ����Ϊ��ʱ;
						return {
							passed:false,
							type:3,
							info:obj.attr("nullmsg") || curform.data("tipmsg").s || tipmsg.s
						};
					}
				}
				
				return {
					passed:passed,
					type:type,
					info:info
				};
				
			}

			if(!(datatype in Validform.util.dataType)){
				var mac=datatype.match(Validform.util.dataType["match"]),
					temp;
					
				if(!mac){
					return false;
				}

				for(var name in Validform.util.dataType){
					temp=name.match(Validform.util.dataType["match"]);
					if(!temp){continue;}
					if(mac[1]===temp[1]){
						var str=Validform.util.dataType[name].toString(),
							param=str.match(/\/[mgi]*/g)[1].replace("\/",""),
							regxp=new RegExp("\\{"+temp[2]+","+temp[3]+"\\}","g");
    			        str=str.replace(/\/[mgi]*/g,"\/").replace(regxp,"{"+mac[2]+","+mac[3]+"}").replace(/^\//,"").replace(/\/$/,"");
				        Validform.util.dataType[datatype]=new RegExp(str,param);
						break;
					}	
				}
			}

			if(Validform.util.toString.call(Validform.util.dataType[datatype])=="[object RegExp]"){
				passed=Validform.util.dataType[datatype].test(gets);
				if(passed){
					type=2;
					info=curform.data("tipmsg").r||tipmsg.r;
					
					if(obj.attr("recheck")){
						var theother=curform.find("input[name='"+obj.attr("recheck")+"']:first");
						if(gets!=theother.val()){
							passed=false;
							type=3;
							info=obj.attr("errormsg") || curform.data("tipmsg").w || tipmsg.w;
						}
					}
					
				}else{
					info=obj.attr("errormsg") || curform.data("tipmsg").w || tipmsg.w;
					
					if(gets===""){
						return {
							passed:false,
							type:3,
							info:obj.attr("nullmsg") || curform.data("tipmsg").s || tipmsg.s
						};
					}
				}

				return {
					passed:passed,
					type:type,
					info:info
				};
			}

			return{
					passed:false,
					type:3,
					info:curform.data("tipmsg").w || tipmsg.w
			};
			
		},

		showmsg:function(msg,type,o,show){
			/*
				msg:��ʾ����;
				type:��ʾ��Ϣ��ʾ��ʽ;
				o:{obj:��ǰ����, type:1=>���ڼ�� | 2=>ͨ��}, 
				show:��blur���ύ����������֤�У���Щ�������Ҫ��ʾ��ʾ���֣����Զ��嵯����ʾ�����ʾ��ʽ������Ҫÿ��blurʱ�����ϵ�����ʾ;
			*/
			
			//���msgΪnull����ô��û��Ҫִ�к���Ĳ�����ignore�п��ܻ���������;
			if(msg===null){return false;}
			//if(msg===null || o.sweep && show=="hide"){return false;}

			$.extend(o,{curform:this});
				
			if(typeof type == "function"){
				if(!(o.sweep && show=="hide")){
					type(msg,o,Validform.util.cssctl);
				}
				return false;
			}
			if(type==1 || show=="alwaysshow"){
				msgobj.find(".Validform_info").html(msg);
			}

			if(type==1 && show!="hide" || show=="alwaysshow"){
				msghidden=false;
				msgobj.find(".iframe").css("height",msgobj.outerHeight());
				msgobj.show();
				setCenter(msgobj,100);
			}

			if(type==2 && o.obj){
				o.obj.parent().next().find(".Validform_checktip").html(msg);
				Validform.util.cssctl(o.obj.parent().next().find(".Validform_checktip"),o.type);
			}

		},

		cssctl:function(obj,status){
			switch(status){
				case 1:
					obj.removeClass("Validform_right Validform_wrong").addClass("Validform_checktip Validform_loading");//checking;
					break;
				case 2:
					obj.removeClass("Validform_wrong Validform_loading").addClass("Validform_checktip Validform_right");//passed;
					break;
				case 4:
					obj.removeClass("Validform_right Validform_wrong Validform_loading").addClass("Validform_checktip");//for ignore;
					break;
				default:
					obj.removeClass("Validform_right Validform_loading").addClass("Validform_checktip Validform_wrong");//wrong;
			}
		},
		
		submitForm:function(settings,flg,ajaxPost,sync){
			/*
				flg===trueʱ������ֱ֤���ύ;
				ajaxPost==="ajaxPost"ָʾ��ǰ����ajax��ʽ�ύ;
			*/
			var curform=this;
			
			//�������ύʱ����ύ��ť������Ӧ;
			if(curform[0].status==="posting"){return false;}
			
			//Ҫ��ֻ���ύһ��ʱ;
			if(settings.postonce && curform[0].status==="posted"){return false;}
			
			var sync= sync===true ? false:true;
			var beforeCheck=settings.beforeCheck && settings.beforeCheck(curform);
			if(beforeCheck===false){return false;}
			
			var flag=true,
				inflag;

			curform.find("[datatype]").each(function(){
				//������֤;
				if(flg){
					return false;	
				}

				//���ػ��dataIgnore�ı���������֤;
				if(settings.ignoreHidden && $(this).is(":hidden") || $(this).data("dataIgnore")==="dataIgnore"){
					return true;
				}
				
				var inputval=Validform.util.getValue.call(curform,$(this)),
					_this;
				errorobj=_this=$(this);
				
				inflag=Validform.util.regcheck.call(curform,$(this).attr("datatype"),inputval,$(this));

				if(!inflag.passed){
					_this.addClass("Validform_error");
					Validform.util.showmsg.call(curform,inflag.info,settings.tiptype,{obj:$(this),type:inflag.type,sweep:settings.tipSweep});
					
					if(!settings.showAllError){
						_this.focus();
						flag=false;
						return false;
					}
					
					flag && (flag=false);
					return true;
				}

				if($(this).attr("ajaxurl")){
					if(this.valid!=="true"){
						var thisobj=$(this);
						_this.addClass("Validform_error");
						Validform.util.showmsg.call(curform,curform.data("tipmsg").v||tipmsg.v,settings.tiptype,{obj:thisobj,type:3,sweep:settings.tipSweep});
						if(!msghidden || settings.tiptype!=1){
							setTimeout(function(){
								thisobj.trigger("blur",["postform"]);//continue the form post;
							},1500);
						}
						
						if(!settings.showAllError){
							flag=false;
							return false;
						}
						
						flag && (flag=false);
						return true;
					}
				}

				Validform.util.showmsg.call(curform,inflag.info,settings.tiptype,{obj:$(this),type:inflag.type,sweep:settings.tipSweep},"hide");
				_this.removeClass("Validform_error");
				errorobj=null;
			});
			
			if(settings.showAllError){
				curform.find(".Validform_error:first").focus();
			}

			if(flag){
				
				var beforeSubmit=settings.beforeSubmit && settings.beforeSubmit(curform);
				if(beforeSubmit===false){return false;}
				
				curform[0].status="posting";
				
				if(settings.ajaxPost || ajaxPost==="ajaxPost"){
					Validform.util.showmsg.call(curform,curform.data("tipmsg").p||tipmsg.p,settings.tiptype,{obj:curform,type:1,sweep:settings.tipSweep},"alwaysshow");//����"alwaysshow"������ʾ�򲻹ܵ�ǰtiptyeΪ1����2������;
					curform[0].ajax=$.ajax({
						type: "POST",
						dataType:"json",
						async:sync,
						url: curform.attr("action"),
						//data: decodeURIComponent(curform.serialize(),true),
						data: curform.serializeArray(),
						success: function(data){
							if(data.status==="y"){
								Validform.util.showmsg.call(curform,data.info,settings.tiptype,{obj:curform,type:2,sweep:settings.tipSweep},"alwaysshow");
							}else{
								curform[0].posting=false;
								Validform.util.showmsg.call(curform,data.info,settings.tiptype,{obj:curform,type:3,sweep:settings.tipSweep},"alwaysshow");
							}
							
							settings.callback && settings.callback(data);
							
							curform[0].status="posted";
							curform[0].ajax=null;
						},
						error: function(data){
							var msg=data.statusText==="abort" ? 
									curform.data("tipmsg").abort||tipmsg.abort : 
									curform.data("tipmsg").err||tipmsg.err;
									
							curform[0].posting=false;
							Validform.util.showmsg.call(curform,msg,settings.tiptype,{obj:curform,type:3,sweep:settings.tipSweep},"alwaysshow");
							curform[0].status="normal";
							curform[0].ajax=null;
						}
					});
					
				}else{
					if(!settings.postonce){
						curform[0].status="normal";
					}
					return settings.callback && settings.callback(curform);
				}
			}
			
			return false;
			
		},
		
		resetForm:function(){
			var brothers=this;
			brothers.each(function(){
				this.reset();
				this.status="normal";
			});
			
			brothers.find(".Validform_right").text("");
			brothers.find(".passwordStrength").children().removeClass("bgStrength");
			brothers.find(".Validform_checktip").removeClass("Validform_wrong Validform_right Validform_loading");
			brothers.find(".Validform_error").removeClass("Validform_error");
			brothers.find("[datatype]").removeData("cked").removeData("dataIgnore");
			brothers.eq(0).find("input:first").focus();
		},
		
		abort:function(){
			if(this.ajax){
				this.ajax.abort();	
			}
		}
		
	}
	
	$.Datatype=Validform.util.dataType;
	
	Validform.prototype={
		dataType:Validform.util.dataType,
		
		eq:function(n){
			var obj=this;
			
			if(n>=obj.forms.length){
				return null;	
			}
			
			if(!(n in obj.objects)){
				obj.objects[n]=new Validform($(obj.forms[n]).get(),obj.settings,true);
			}
			
			return obj.objects[n];

		},
		
		resetStatus:function(){
			var obj=this;
			$(obj.forms).each(function(){
				this.status="normal";	
			});
			
			return this;
		},
		
		setStatus:function(status){
			var obj=this;
			$(obj.forms).each(function(){
				this.status=status || "posting";	
			});
		},
		
		getStatus:function(){
			var obj=this;
			var status=$(obj.forms)[0].status;
			return status;
		},
		
		ignore:function(selector){
			var obj=this;
			$(obj.forms).find(selector).each(function(){
				$(this).data("dataIgnore","dataIgnore").removeClass("Validform_error");
			});
		},
		
		unignore:function(selector){
			var obj=this;
			$(obj.forms).find(selector).each(function(){
				$(this).removeData("dataIgnore");
			});
		},
		
		addRule:function(rule){
			/*
				rule => [{
					ele:"#id",
					datatype:"*",
					errormsg:"������ʾ���֣�",
					nullmsg:"Ϊ��ʱ����ʾ���֣�",
					tip:"Ĭ����ʾ����ʾ����",
					altercss:"gray",
					ignore:"ignore",
					ajaxurl:"valid.php",
					recheck:"password",
					plugin:"passwordStrength"
				},{},{},...]
			*/
			var obj=this;
			var rule=rule || [];

			for(var index in rule){
				var o=$(obj.forms).find(rule[index].ele);
				for(var attr in rule[index]){
					attr !=="ele" && o.attr(attr,rule[index][attr]);
				}
			}
			
		},
		
		ajaxPost:function(flag,sync){
			var obj=this;
			
			//����pop box;
			if( obj.settings.tiptype==1 || obj.settings.tiptype==2 ){
				creatMsgbox();
			}
			
			Validform.util.submitForm.call($(obj.forms[0]),obj.settings,flag,"ajaxPost",sync);
		},
		
		submitForm:function(flag){
			/*flag===trueʱ������ֱ֤���ύ*/
			
			var obj=this;
			
			//�øö���ĵ�һ�����ύ;
			var subflag=Validform.util.submitForm.call($(obj.forms[0]),obj.settings,flag);
			subflag === undef && (subflag=true);
			if(subflag===true){
				obj.forms[0].submit();
			}
		},
		
		resetForm:function(){
			var obj=this;
			Validform.util.resetForm.call($(obj.forms));
		},
		
		abort:function(){
			var obj=this;
			$(obj.forms).each(function(){
				Validform.util.abort.call(this);
			});	
		}
	}

	$.fn.Validform=function(settings){
		return new Validform(this,settings);
	};
	
	function setCenter(obj,time){
		var left=($(window).width()-obj.outerWidth())/2,
			top=($(window).height()-obj.outerHeight())/2,
			
		top=(document.documentElement.scrollTop?document.documentElement.scrollTop:document.body.scrollTop)+(top>0?top:0);

		obj.css({
			left:left	
		}).animate({
			top : top
		},{ duration:time , queue:false });	
	}
	
	function creatMsgbox(){
		if($("#Validform_msg").length!==0){return false;}
		msgobj=$('<div id="Validform_msg"><div class="Validform_title">'+tipmsg.tit+'<a class="Validform_close" href="javascript:void(0);">&chi;</a></div><div class="Validform_info"></div><div class="iframe"><iframe frameborder="0" scrolling="no" height="100%" width="100%"></iframe></div></div>').appendTo("body");//��ʾ��Ϣ��;
		msgobj.find("a.Validform_close").click(function(){
			msgobj.hide();
			msghidden=true;
			if(errorobj){
				errorobj.focus().addClass("Validform_error");
			}
			return false;
		}).focus(function(){this.blur();});

		$(window).bind("scroll resize",function(){
			!msghidden && setCenter(msgobj,400);
		});
	};
	
	//���÷�����ʾ&�ر���Ϣ��ʾ��;
	$.Showmsg=function(msg){
		creatMsgbox();
		Validform.util.showmsg.call(win,msg,1,{});
	};
	
	$.Hidemsg=function(){
		msgobj.hide();
		msghidden=true;
	};
	
})(jQuery,window);