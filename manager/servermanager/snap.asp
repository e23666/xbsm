<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr 
id=requesta("id")
If Not isnumeric(id&"") Then Call url_return("��������",-1)
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-�������������չ���</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
   <script type="text/javascript" src="/noedit/template.js"></script>
    <script type="text/javascript" src="/jscripts/layer/layer.js"></script>
</HEAD>
<body>
  <!--#include virtual="/manager/top.asp" -->
  <!--#include virtual="/manager/rengzheng.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			   <li><a href="/Manager/servermanager/">����IP��������</a></li>
			   <li>�������������չ���</li>
			   
			 </ul>
		  </div>
	 
	<div class="manager-right-bg" id="snapbody">
	
	</div> 
  </div>
  </div>

 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
<script type="text/html" id="tpl_snapbody"> 
			  <div class="mt-20">
                <span class="va-m font14">��ǰ������IP��</span>
                <label class="va-m font14 dis-ib" style="width: 132px;">
				{{serverip}}
                </label>
            
            </div>
             <div class="mt-20">
                <span class="va-m font14">��ǰ���շ���</span>
                <label class="va-m font14 dis-ib" style="width: 132px;">
                {{if snapadv=="False"}}�����ƿ���{{else}}�߼��ƿ���{{/if}}
                </label>
                {{if snapadv=="False" && snappolicy=="0"}}
                <a class="manager-btn ml-20 va-m width100" href="javascript:snapupadv();">��ͨ�߼��ƿ���</a>
              
                <a href="javascript:;" style="position: relative">
                    <span class="icon-question"></span>
                    <div class="manager-tip">�߼����շ����ṩ��ǿ��Ŀ��չ��ܣ�ͬʱ���ṩ5�����ձ��ݣ�����1-4������Ϊ���4�����ݣ���5������Ϊ���15�������ݣ������Զ��屸��Ƶ�ʣ������ݸ���ȫ��<i></i></div>
                </a> 
                 {{/if}}
            </div>
            <div class="mt-20">
                <span class="va-m font14">�ֹ��������գ�</span>
                <label class="va-m font14"><input type="checkbox" name="BkupDisk" value="data">&nbsp;������</label>
                <label class="va-m font14 ml-10"><input type="checkbox" name="BkupDisk"  value="os">&nbsp;ϵͳ��</label>
                <a class="manager-btn va-m ml-20 width100 snapbkupbt" href="javascript:;">��������</a>
                <a href="javascript:;" style="position: relative">
                    <span class="icon-question"></span>
                    <div class="manager-tip">ϵͳ�Զ����ݣ�һ�㲻��Ҫ�ֹ�������������Ҫ����ѡ����Ҫ���ݵĴ��̣�֧��ͬʱѡ��ϵͳ�̺������̡�<i></i></div>
                </a>
              
            </div>
           
            {{if snapadv=="True"}}
            <div class="mt-20">
                <span class="va-m font14">�߼����շ���</span>
                <select class="manager-select s-select va-m" name="snapperiod" style="width: 132px;">
                    <option value="1"  {{if snapperiod==1}}selected{{/if}}>1��</option>			  
                    <option value="2"  {{if snapperiod==2}}selected{{/if}}>2��</option>			  
                    <option value="3"  {{if snapperiod==3}}selected{{/if}}>3��</option>			  
                    <option value="4"  {{if snapperiod==4}}selected{{/if}}>4��</option>			  
                    <option value="5"  {{if snapperiod==5}}selected{{/if}}>5��</option>			  
                    <option value="6"  {{if snapperiod==6}}selected{{/if}}>6��</option>			  
                    <option value="7"  {{if snapperiod==7}}selected{{/if}}>7��</option>			  
                    <option value="8"  {{if snapperiod==8}}selected{{/if}}>8��</option>			  
                    <option value="9"  {{if snapperiod==9}}selected{{/if}}>9��</option>			  
                    <option value="10"  {{if snapperiod==10}}selected{{/if}}>10��</option>			  
                </select>
                <a class="manager-btn ml-20 va-m width100" id="setsnapperiod" href="javascript:;">���ñ���Ƶ��</a>
                <a href="javascript:;" style="position: relative">
                    <span class="icon-question"></span>
                    <div class="manager-tip">���ѿ�ͨ�߼��ƿ��շ��񣬿��Զ�����ձ���Ƶ�ʡ�<i></i></div>
                </a>
            </div>
            {{/if}}
            <table class="manager-table">
                <thead>
                <tr>
                    <th>����</th>
                    <th>���</th>
                    <th>����</th>
                    <th>�ļ���С</th>
                    <th>����״̬</th>
                    <th width="150">���ز���</th>
                    <th>����</th>
                </tr>
                </thead>
                <tbody >
                {{each os as key index}}
                <tr>
                    {{if index=="0"}}
                        <td rowspan="{{(os.length)}}">ϵͳ��</td>
                    {{/if}}
                    <td>{{index+1}}</td>
                    <td><label class="dis-ib text-l" style="width: 200px;"><input type="checkbox" name="snapos" value="{{key.index}}" data-at="{{key.date}}" data-size="{{key.size}}"> {{key.date}} ����</label></td>
                    <td>{{key.size}}G</td>
                    <td  id="osstatusimg{{key.index}}"><img src="/images/unguazai.png" width="24" alt="�ѹ���" title="�ѹ���"></td>
                    <td  id="osstatus{{key.index}}">--</td>
                    {{if index==0}}
                    <td rowspan="{{(os.length)+(data.length)}}">
                        <a class="manager-btn snapbt" data-op="os"  data-cmd="0" href="javascript:;" style="position: relative;">���չ���<div class="manager-tip">�����ڽ����滻���̲����ļ���<i></i></div></a>
                        <a class="manager-btn ml-10 snapbt"  data-op="os" data-cmd="1"  href="javascript:;" style="position: relative;">���ջع�<div class="manager-tip">����������ָ�����ȫ���ļ���<i></i></div></a>
                    </td>
                    {{/if}}
                </tr>
                {{/each}}
                {{each data as key index}}
                <tr style="background-color: #f8f8f8;">
                    {{if index=="0"}}
                    <td rowspan="{{data.length}}">������</td>
                    {{/if}}
                    <td>{{index+1}}</td>
                    <td><label class="dis-ib text-l" style="width: 200px;"><input type="checkbox" name="snapdata" value="{{key.index}}" data-at="{{key.date}}" data-size="{{key.size}}"> {{key.date}} ����</label></td>
                    <td>{{key.size}}G</td>
                    <td  id="datastatusimg{{key.index}}"><img src="/images/unguazai.png" width="24" alt="�ѹ���" title="�ѹ���"></td>
                    <td  id="datastatus{{key.index}}">--</td>
                     
                </tr>
                {{/each}}                
                </tbody>
            </table>

 
</script> 

<script type="text/html" id="tpl_snapupadv">
     <table  class="snaptable form-table">
          <tr>
		     <th colspan="2" class="nolin">�߼����շ��� </th>
		  </tr>
          <tr>
            <td width="80"  align="right">����(��):</td>
            <td align="left"><font color=red>&yen; {{snapadvprice}}</font></td>
          </tr>
          <tr>
            <td   align="right">ʣ���·�:</td>
            <td align="left"><font color=red>{{leftmonth}}����</font></td>
          </tr>
          <tr>
            <td  align="right">��ͨ���:</td>
            <td align="left"><font color=red>&yen;{{leftmonth*snapadvprice}}</font></td>
          </tr> 
          <tr>
            <td colspan=2>������ʾ:�������ʣ��ʱ�䲻��1�°�1����ȡ</td>
          </tr>
     </table>
</script>

	
<script>
var apiurl="load.asp"
var id=<%=id%>;
var cfg={};
function sendpost(url,postdata,callback,type){
            var loadbox=layer.load();
            type=type=="GET"?"POST":"GET";
            $.ajax({
                type:type,
                url: url,
                data: postdata,
                dataType: "JSON",
                success: function (response) {
                    callback(response);
                },
                error:function(a,b,c){
                    layer.msg(a+b+c);
                },
                complete:function(a,b){
                    layer.close(loadbox)
                }
            });
    }

  $(function(){
      loadinfo() 
  })

  function loadinfo(){

      sendpost(apiurl,{act:"getsnapinfo",id:id,t:Math.random()},function(data){
          cfg=data.datas;
          $("#snapbody").html(template("tpl_snapbody",data.datas))
          ///�����Ѿ���������
          loadsnapmountlist()
          bindbt()
      })
  }

  function bindbt(){
	   
	  $("input[name='snapos']:checkbox").on("click",function(){
		 var c_=$("input[name='snapos']:checkbox:checked").length;  
		 if (c_>1)
		 {
			$("input[name='snapos']:checkbox").removeProp("checked");
			$(this).prop("checked","checked")
		 }
	  })

	  $("input[name='snapdata']:checkbox").on("click",function(){
		 var c_=$("input[name='snapdata']:checkbox:checked").length;  
		 if (c_>1)
		 {
			$("input[name='snapdata']:checkbox").removeProp("checked");
			$(this).prop("checked","checked")
		 }
	  })
  


      
     

      $(".snapbt").on("click",function(){
            var snapcmdtype=$(this).attr("data-cmd");
			
		//	if($("input[name='snapos']:checkbox:checked").length!=0 && $("input[name='snapdata']:checkbox:checked")!=0){
		//		 layer.msg("����ѡ��Ҫ�����Ŀ�������,����ͬʱѡ�������̺�ϵͳ�̣�����ÿ��ֻ��ѡ��һ��������");
		///		 return false;			
		//	}
		//var nowselect="<div style='background-color: #fffde6;border:1px solid #efefef;text-align:center;;color:red;font-size:16px;;margin:5px 0;'>ѡ�д��̣�"
            var os=$("input[name='snapos']:checkbox:checked");//.val();
            var data=$("input[name='snapdata']:checkbox:checked");//.val();

           
            var postdata={id:id,t:Math.random()}
            
            if (os.length==0 && data.length==0){
                layer.msg("����ѡ��Ҫ�����Ŀ�������");
                return false;
            } 

			alertmsg="��ѡ�е��ǣ�<BR>" 
			if (os.length>0)
			{
				alertmsg+=os.attr("data-at")+" ���ݵ�<font color=red>ϵͳ��</font>��"+os.attr("data-size")+"G��<BR>" 
				postdata.os=os.val();
			}
			if (data.length>0)
			{
				alertmsg+=data.attr("data-at")+" ���ݵ�<font color=red>������</font>��"+data.attr("data-size")+"G��<BR>";
				postdata.data=data.val();
			}
			 
 

            if(snapcmdtype==0){
                  postdata.act="setsnapmount"
                   layer.confirm("��ȷ��Ҫ����ѡ�е��ƿ��ձ�����?<br />�ر�˵��:<BR><font color=red>1.����ͬʱ���ض����ͬ���̿��գ����ش���Ϊֻ��������д�����ݡ�<br />2.�ѹ����ƿ��ջ�ÿ��1:00ͨ�������������Զ�ȡ����<br />3.�����ʧ�ܻ�û�����ݣ���ػ�������һ�κ����¹��ؼ��ɡ�",function(){
                  
                        sendpost(apiurl,postdata,function(data){
                            layer.msg(data.msg)
                            if(data.result=="200"){
                                  loadsnapmountlist()
                            }
                        })

                    })
            }else{
			  
			  alertmsg+="<font color=red>��ȷ��ִ�п��ջع����ع������棡8Сʱ��ֻ�ָܻ�һ�Σ�<Br>����Ҫ��������ϵ����Ա</font>"
			  
			  layer.alert(alertmsg)
		   }
               


      })

      

      $("#setsnapperiod").on("click",function(){
            var snapperiod=$("select[name='snapperiod']").val()
            layer.confirm("��ȷ��Ҫ�����ձ��ݱ�����������Ϊ<font color=red>"+snapperiod+"��</font>",function(){
                   sendpost(apiurl,{act:"setsnapperiod",snapperiod:snapperiod,id:id,t:Math.random()},function(data){
                  layer.msg(data.msg)
                  if(data.result=="200"){
                        loadsnapmountlist()
                  }
              })
            })
      })

      $(".snapbkupbt").on("click",function(){
          var BkupDisk=$("input[name='BkupDisk']:checked");//.val();
          var infos=[]
          $.each(BkupDisk,function(i,n){
                infos.push($(this).val())
          })
          if(infos.length==0){
             layer.msg("��ѡ��Ҫ���ݵ�����");
              return false 
          }

          layer.confirm("��ȷ��Ҫ��������ѡ��Ӳ������?<br />���ݴ��̴�С��һ��1-30�������ҿ��ձ��ݳɹ�",function(){
              sendpost(apiurl,{act:"setsnapbkup",info:infos.join(","),id:id,t:Math.random()},function(data){
                  layer.msg(data.msg)
                  if(data.result=="200"){
                        loadsnapmountlist()
                  }
              }) 
          })

      })
  }
  function snapunmount(info){
      layer.confirm("��ȷ��Ҫȡ���˿��չ��أ�<BR>1.��˰�ť֮ǰ�������Ʒ��������Ƴ���windows��/ȡ�����أ�linux�����ش��̣������콫�����ٴι��أ�<BR>2.Ҳ��ֱ��Զ�̹ػ����������Ʒ�������ϵͳ�Զ�ȡ�����ء���������ȡ�����ء�",function(){
            var postdata={id:id,info:info,act:"setsnapunmount",t:Math.random()} 
            sendpost(apiurl,postdata,function(data){
                  layer.msg(data.msg)
                  if(data.result=="200"){
                        loadsnapmountlist()
                  }
             })

      })
  }
  function loadsnapmountlist(){
      sendpost(apiurl,{act:"getsnapmountlist",id:id,t:Math.random()},function(data){ 
          $("[id^=datastatus]").html("-")
          $("[id^=osstatus]").html("-")
          $("[id^=datastatusimg]").html('<img src="/images/unguazai.png" width=24  alt="δ����" title="δ����" >')
          $("[id^=osstatusimg]").html('<img src="/images/unguazai.png" width=24  alt="δ����" title="δ����" >')
          
         $("input[name='snapos']:checkbox").removeProp("checked")
         $("input[name='snapdata']:checkbox").removeProp("checked")
          if(data.result=="200"){
              $("#osstatus"+data.datas.snapmountlist.os).html('<input type="button" onclick="snapunmount(\'os\')" class="manager-btn s-btn" value="ȡ������">')
              $("#datastatus"+data.datas.snapmountlist.data).html('<input type="button" onclick="snapunmount(\'data\')" class="manager-btn s-btn" value="ȡ������">')
              $("#osstatusimg"+data.datas.snapmountlist.os).html('<img src="/images/onguazai.png" width=24  alt="�ѹ���" title="�ѹ���" >')
              $("#datastatusimg"+data.datas.snapmountlist.data).html('<img src="/images/onguazai.png" width=24  alt="�ѹ���" title="�ѹ���" >')
              //$("#osstatusimg"+data.datas.snapmountlist.os).parents("tr").find("input[name='snapos']").click()
              //$("#datastatusimg"+data.datas.snapmountlist.data).parents("tr").find("input[name='snapdata']").click()
          }
      })
  }
  function snapupadv(){
      layer.open({"title":"��ͨ�߼����շ���",content:template("tpl_snapupadv",cfg),btn:["ȷ����ͨ","ȡ��"],yes:function(){
            
            layer.confirm("��ȷ��Ҫ��ͨ�߼����շ���?<br>��ͨ���:<font color=red>&yen; "+cfg.leftmonth*cfg.snapadvprice+"</font>",function(){
                var postdata={id:id,act:"buysnapadv",t:Math.random()} 
                sendpost(apiurl,postdata,function(data){
                    layer.msg(data.msg)
                    if(data.result=="200"){
                         loadinfo();
                    }
                })


            })
      }})
  }

	
</script>