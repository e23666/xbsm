<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/action.asp" -->
<!--#include virtual="/config/upmssql_class.asp" -->
<%
response.Charset="gb2312"
response.Buffer=true
dataID=Trim(Requesta("id"))
act=trim(requesta("act"))
new_proid=requesta("new_proid")
new_room=requesta("new_room")
conn.open constr
set up=new upmssql_class:up.u_sysid=session("u_sysid"):up.setdataid=dataID
if act="sub" then
	if up.dosub(new_proid,new_room,errstr) then
		alert_redirect "恭喜,升级成功","/manager/sqlmanager/manage.asp?p_id="& dataid
	else
		url_return "抱歉，升级失败:" & errstr,-1
	end if
elseif act="getroomlist" then
	call up.getProInfo(new_proid,0)
	response.write up.roomlist
	conn.close:set up=nothing:response.end
elseif act="getneedprice" then
	needPrice=up.getupNeedPrice(new_proid,new_room)
	movestr=""
	if not (new_room=up.dbroom and up.newp_server=up.dbp_server) then movestr="<div style=""float:none; clear:both; height:auto;background-color:#FFC; border-top:1px solid #Fc6;border-bottom:1px solid #Fc6; color:#F00; text-align:left;font-size:14px "" id=""movetitle"">变更服务器后数据将不会保留，若需数据请自行迁移。</div>"
	result="每天差价["& fmtPrice(up.everydayPrice) &"]×剩余天数["& up.dayHave &"]+手续费["& fmtPrice(up.RoomShouXuFei) &"]=<span class=""price"">"& needPrice & "元</span>^|^" & _
	"(新价格["& fmtPrice(up.newPrice) &"]-原价格["& fmtPrice(up.oldPrice) &"])÷总天数["& up.dayCount &"]="& fmtPrice(up.everydayPrice) & "元" & _
	"^|^" & fmtPrice(up.RoomShouXuFei) & "元" & _
	"^|^" & movestr
	response.write result
	conn.close:set up=nothing:response.end
end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-Mssql数据库升级</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
   <script language="javascript" src="/jscripts/upmssql.js"></script>
<script language="javascript">
function dosort(v){
 	if(v!=''){
		var sorttype="<%=request("sorttype")%>";
		if (sorttype=="") sorttype="desc";
		if (sorttype=="desc")
			sorttype="asc";
		else if(sorttype=="asc") 
			sorttype="desc";
     	document.form1.action="<%=request("script_name")%>?pageNo=<%=Requesta("pageNo")%>&sorttype="+ sorttype +"&sorts="+ v ;
		document.form1.submit();
	  }
}
</script>

</HEAD>
<body>
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			   			   <li><a href="/manager/sqlmanager/">Mssql数据库管理</a></li>
               			   <li>Mssql升级</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
               <form name="form_uphost" action="<%=requesta("script_name")%>" method="post">
                  <table class="manager-table">
                   <tr >
                     <th class="title" align="right">数据库名称:</th>
                     <td align="left"><%=up.dbname%></td>
                   </tr>
                   <tr >
                     <th class="title"  align="right">使用时间:</th>
                     <td align="left"><%=up.dbbuydate%>～<%=up.dbexpiredate%>&nbsp;&nbsp;剩余天数:<%=up.dayHave%>天</td>
                   </tr>
                   <tr >
                     <th class="title"  align="right">当前型号:</th>
                     <td align="left"><%=up.dbp_name%>(<%=up.dbproid%>)</td>
                   </tr>
                   <tr >
                     <th class="title"  align="right">当前机房:</th>
                     <td align="left"><%=up.dbroomname%></td>
                   </tr>
                   <tr >
                     <th class="title"  align="right">升级到的新型号:</th>
                     <td align="left"><%=up.newProidlist%></td>
                     <div id="bubbleContent" style="clear:both; margin-left:150px; color:#F00; background-color:#FFC; display:none"></div>
                   </tr>

                   <tr  id="newroomlist">
                     <th class="title"  align="right">升级到的机房:</th>
                     <td align="left"></td>
                   </tr>
                   <tr id="priceMethod">
                     <th class="title"  align="right">每天差价:</th>
                     <td align="left"></td>
                   </tr>
                   <tr id="priceShouXuFei">
                     <th class="title"  align="right">手续费:</th>
                     <td align="left"></td>
                   </tr>
                   <tr id="needPrice">
                     <th class="title"  align="right">合计:</th>
                     <td align="left"></td>
                   </tr>
                   <tr class="buttonmsg">
                     <td  colspan="2"><input type="button"  value="确定升级" name="subbtton" class="manager-btn s-btn"  /></td>
                     <label id="loadsubinfo" style="display:none"><img src="/images/mallload.gif">正在执行中,请勿刷新或关闭该页面..</label>
                   </tr>
                 </table >
                 <input type="hidden" name="id" value="<%=dataID%>" />
                 <input type="hidden" name="act" />
                 <input type="hidden" name="dbproid" value="<%=up.dbproid%>" />
                 <input type="hidden" name="dbroom" value="<%=up.dbroom%>" />

               </form>
               <div style="border:2px dotted #ccc; border: 2px dotted #ccc;margin: 20px 0 0 0;width: 100%;">1.升级后MSSQL数据库的到期日期不变<br />
                 2.升级费用为：新旧数据库型号每天的差价×剩余的未使用天数。升级费用不足30元的，按30元计算。<br />
                 3.建议网站与Mssql放在同一机房，跨机房调用速度会非常慢</div>
               <%
               function fmtPrice(byval numstr)
               	if numstr<>"" and isnumeric(numstr) then
               	 fmtPrice=formatnumber(Round(numstr,2),2,-1,-2,0)
               	else
               		fmtPrice=0.00
               	end if
               end function
               %>
		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>