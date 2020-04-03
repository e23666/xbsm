<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr 
id=requesta("id")
If Not isnumeric(id&"") Then Call url_return("参数有误",-1)
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-弹性云主机快照功能</title>
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
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			   <li><a href="/Manager/servermanager/">独立IP主机管理</a></li>
			   <li>弹性云主机快照功能</li>
			   
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
                <span class="va-m font14">当前服务器IP：</span>
                <label class="va-m font14 dis-ib" style="width: 132px;">
				{{serverip}}
                </label>
            
            </div>
             <div class="mt-20">
                <span class="va-m font14">当前快照服务：</span>
                <label class="va-m font14 dis-ib" style="width: 132px;">
                {{if snapadv=="False"}}基础云快照{{else}}高级云快照{{/if}}
                </label>
                {{if snapadv=="False" && snappolicy=="0"}}
                <a class="manager-btn ml-20 va-m width100" href="javascript:snapupadv();">开通高级云快照</a>
              
                <a href="javascript:;" style="position: relative">
                    <span class="icon-question"></span>
                    <div class="manager-tip">高级快照服务将提供更强大的快照功能，同时能提供5个快照备份，其中1-4个备份为最近4天数据，第5个备份为最近15天内数据，并可自定义备份频率，让数据更安全。<i></i></div>
                </a> 
                 {{/if}}
            </div>
            <div class="mt-20">
                <span class="va-m font14">手工创建快照：</span>
                <label class="va-m font14"><input type="checkbox" name="BkupDisk" value="data">&nbsp;数据盘</label>
                <label class="va-m font14 ml-10"><input type="checkbox" name="BkupDisk"  value="os">&nbsp;系统盘</label>
                <a class="manager-btn va-m ml-20 width100 snapbkupbt" href="javascript:;">创建快照</a>
                <a href="javascript:;" style="position: relative">
                    <span class="icon-question"></span>
                    <div class="manager-tip">系统自动备份，一般不需要手工创建。若有需要，请选择您要备份的磁盘，支持同时选择系统盘和数据盘。<i></i></div>
                </a>
              
            </div>
           
            {{if snapadv=="True"}}
            <div class="mt-20">
                <span class="va-m font14">高级快照服务：</span>
                <select class="manager-select s-select va-m" name="snapperiod" style="width: 132px;">
                    <option value="1"  {{if snapperiod==1}}selected{{/if}}>1天</option>			  
                    <option value="2"  {{if snapperiod==2}}selected{{/if}}>2天</option>			  
                    <option value="3"  {{if snapperiod==3}}selected{{/if}}>3天</option>			  
                    <option value="4"  {{if snapperiod==4}}selected{{/if}}>4天</option>			  
                    <option value="5"  {{if snapperiod==5}}selected{{/if}}>5天</option>			  
                    <option value="6"  {{if snapperiod==6}}selected{{/if}}>6天</option>			  
                    <option value="7"  {{if snapperiod==7}}selected{{/if}}>7天</option>			  
                    <option value="8"  {{if snapperiod==8}}selected{{/if}}>8天</option>			  
                    <option value="9"  {{if snapperiod==9}}selected{{/if}}>9天</option>			  
                    <option value="10"  {{if snapperiod==10}}selected{{/if}}>10天</option>			  
                </select>
                <a class="manager-btn ml-20 va-m width100" id="setsnapperiod" href="javascript:;">设置备份频率</a>
                <a href="javascript:;" style="position: relative">
                    <span class="icon-question"></span>
                    <div class="manager-tip">您已开通高级云快照服务，可自定义快照备份频率。<i></i></div>
                </a>
            </div>
            {{/if}}
            <table class="manager-table">
                <thead>
                <tr>
                    <th>磁盘</th>
                    <th>序号</th>
                    <th>快照</th>
                    <th>文件大小</th>
                    <th>挂载状态</th>
                    <th width="150">挂载操作</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody >
                {{each os as key index}}
                <tr>
                    {{if index=="0"}}
                        <td rowspan="{{(os.length)}}">系统盘</td>
                    {{/if}}
                    <td>{{index+1}}</td>
                    <td><label class="dis-ib text-l" style="width: 200px;"><input type="checkbox" name="snapos" value="{{key.index}}" data-at="{{key.date}}" data-size="{{key.size}}"> {{key.date}} 快照</label></td>
                    <td>{{key.size}}G</td>
                    <td  id="osstatusimg{{key.index}}"><img src="/images/unguazai.png" width="24" alt="已挂载" title="已挂载"></td>
                    <td  id="osstatus{{key.index}}">--</td>
                    {{if index==0}}
                    <td rowspan="{{(os.length)+(data.length)}}">
                        <a class="manager-btn snapbt" data-op="os"  data-cmd="0" href="javascript:;" style="position: relative;">快照挂载<div class="manager-tip">适用于仅需替换磁盘部分文件。<i></i></div></a>
                        <a class="manager-btn ml-10 snapbt"  data-op="os" data-cmd="1"  href="javascript:;" style="position: relative;">快照回滚<div class="manager-tip">适用于整体恢复磁盘全部文件。<i></i></div></a>
                    </td>
                    {{/if}}
                </tr>
                {{/each}}
                {{each data as key index}}
                <tr style="background-color: #f8f8f8;">
                    {{if index=="0"}}
                    <td rowspan="{{data.length}}">数据盘</td>
                    {{/if}}
                    <td>{{index+1}}</td>
                    <td><label class="dis-ib text-l" style="width: 200px;"><input type="checkbox" name="snapdata" value="{{key.index}}" data-at="{{key.date}}" data-size="{{key.size}}"> {{key.date}} 快照</label></td>
                    <td>{{key.size}}G</td>
                    <td  id="datastatusimg{{key.index}}"><img src="/images/unguazai.png" width="24" alt="已挂载" title="已挂载"></td>
                    <td  id="datastatus{{key.index}}">--</td>
                     
                </tr>
                {{/each}}                
                </tbody>
            </table>

 
</script> 

<script type="text/html" id="tpl_snapupadv">
     <table  class="snaptable form-table">
          <tr>
		     <th colspan="2" class="nolin">高级快照服务 </th>
		  </tr>
          <tr>
            <td width="80"  align="right">单价(月):</td>
            <td align="left"><font color=red>&yen; {{snapadvprice}}</font></td>
          </tr>
          <tr>
            <td   align="right">剩余月份:</td>
            <td align="left"><font color=red>{{leftmonth}}个月</font></td>
          </tr>
          <tr>
            <td  align="right">开通金额:</td>
            <td align="left"><font color=red>&yen;{{leftmonth*snapadvprice}}</font></td>
          </tr> 
          <tr>
            <td colspan=2>友情提示:如服务器剩余时间不足1月按1月收取</td>
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
          ///加载已经挂载数据
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
		//		 layer.msg("请先选择要操作的快照数据,可以同时选择数据盘和系统盘，并且每个只能选择一份来操作");
		///		 return false;			
		//	}
		//var nowselect="<div style='background-color: #fffde6;border:1px solid #efefef;text-align:center;;color:red;font-size:16px;;margin:5px 0;'>选中磁盘："
            var os=$("input[name='snapos']:checkbox:checked");//.val();
            var data=$("input[name='snapdata']:checkbox:checked");//.val();

           
            var postdata={id:id,t:Math.random()}
            
            if (os.length==0 && data.length==0){
                layer.msg("请先选择要操作的快照数据");
                return false;
            } 

			alertmsg="您选中的是：<BR>" 
			if (os.length>0)
			{
				alertmsg+=os.attr("data-at")+" 备份的<font color=red>系统盘</font>（"+os.attr("data-size")+"G）<BR>" 
				postdata.os=os.val();
			}
			if (data.length>0)
			{
				alertmsg+=data.attr("data-at")+" 备份的<font color=red>数据盘</font>（"+data.attr("data-size")+"G）<BR>";
				postdata.data=data.val();
			}
			 
 

            if(snapcmdtype==0){
                  postdata.act="setsnapmount"
                   layer.confirm("您确定要挂载选中的云快照备份吗?<br />特别说明:<BR><font color=red>1.不能同时挂载多个相同磁盘快照，挂载磁盘为只读，不能写入数据。<br />2.已挂载云快照会每天1:00通过重启服务器自动取消。<br />3.如挂载失败或没有数据，请关机再启动一次后，重新挂载即可。",function(){
                  
                        sendpost(apiurl,postdata,function(data){
                            layer.msg(data.msg)
                            if(data.result=="200"){
                                  loadsnapmountlist()
                            }
                        })

                    })
            }else{
			  
			  alertmsg+="<font color=red>请确定执行快照回滚？回滚不可逆！8小时内只能恢复一次！<Br>如需要操作请联系管理员</font>"
			  
			  layer.alert(alertmsg)
		   }
               


      })

      

      $("#setsnapperiod").on("click",function(){
            var snapperiod=$("select[name='snapperiod']").val()
            layer.confirm("您确定要将快照备份备份周期设置为<font color=red>"+snapperiod+"天</font>",function(){
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
             layer.msg("请选择要备份的数据");
              return false 
          }

          layer.confirm("您确定要立即备份选中硬盘数据?<br />根据磁盘大小，一般1-30分钟左右快照备份成功",function(){
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
      layer.confirm("您确定要取消此快照挂载？<BR>1.点此按钮之前，先在云服务器中移除（windows）/取消挂载（linux）挂载磁盘，否则当天将不能再次挂载！<BR>2.也可直接远程关机，再启动云服务器，系统自动取消挂载。重启不会取消挂载。",function(){
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
          $("[id^=datastatusimg]").html('<img src="/images/unguazai.png" width=24  alt="未挂载" title="未挂载" >')
          $("[id^=osstatusimg]").html('<img src="/images/unguazai.png" width=24  alt="未挂载" title="未挂载" >')
          
         $("input[name='snapos']:checkbox").removeProp("checked")
         $("input[name='snapdata']:checkbox").removeProp("checked")
          if(data.result=="200"){
              $("#osstatus"+data.datas.snapmountlist.os).html('<input type="button" onclick="snapunmount(\'os\')" class="manager-btn s-btn" value="取消挂载">')
              $("#datastatus"+data.datas.snapmountlist.data).html('<input type="button" onclick="snapunmount(\'data\')" class="manager-btn s-btn" value="取消挂载">')
              $("#osstatusimg"+data.datas.snapmountlist.os).html('<img src="/images/onguazai.png" width=24  alt="已挂载" title="已挂载" >')
              $("#datastatusimg"+data.datas.snapmountlist.data).html('<img src="/images/onguazai.png" width=24  alt="已挂载" title="已挂载" >')
              //$("#osstatusimg"+data.datas.snapmountlist.os).parents("tr").find("input[name='snapos']").click()
              //$("#datastatusimg"+data.datas.snapmountlist.data).parents("tr").find("input[name='snapdata']").click()
          }
      })
  }
  function snapupadv(){
      layer.open({"title":"开通高级快照服务",content:template("tpl_snapupadv",cfg),btn:["确定开通","取消"],yes:function(){
            
            layer.confirm("您确定要开通高级快照服务?<br>开通金额:<font color=red>&yen; "+cfg.leftmonth*cfg.snapadvprice+"</font>",function(){
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