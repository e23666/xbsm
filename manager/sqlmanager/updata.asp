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
		alert_redirect "��ϲ,�����ɹ�","/manager/sqlmanager/manage.asp?p_id="& dataid
	else
		url_return "��Ǹ������ʧ��:" & errstr,-1
	end if
elseif act="getroomlist" then
	call up.getProInfo(new_proid,0)
	response.write up.roomlist
	conn.close:set up=nothing:response.end
elseif act="getneedprice" then
	needPrice=up.getupNeedPrice(new_proid,new_room)
	movestr=""
	if not (new_room=up.dbroom and up.newp_server=up.dbp_server) then movestr="<div style=""float:none; clear:both; height:auto;background-color:#FFC; border-top:1px solid #Fc6;border-bottom:1px solid #Fc6; color:#F00; text-align:left;font-size:14px "" id=""movetitle"">��������������ݽ����ᱣ������������������Ǩ�ơ�</div>"
	result="ÿ����["& fmtPrice(up.everydayPrice) &"]��ʣ������["& up.dayHave &"]+������["& fmtPrice(up.RoomShouXuFei) &"]=<span class=""price"">"& needPrice & "Ԫ</span>^|^" & _
	"(�¼۸�["& fmtPrice(up.newPrice) &"]-ԭ�۸�["& fmtPrice(up.oldPrice) &"])��������["& up.dayCount &"]="& fmtPrice(up.everydayPrice) & "Ԫ" & _
	"^|^" & fmtPrice(up.RoomShouXuFei) & "Ԫ" & _
	"^|^" & movestr
	response.write result
	conn.close:set up=nothing:response.end
end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-Mssql���ݿ�����</title>
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
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			   			   <li><a href="/manager/sqlmanager/">Mssql���ݿ����</a></li>
               			   <li>Mssql����</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
               <form name="form_uphost" action="<%=requesta("script_name")%>" method="post">
                  <table class="manager-table">
                   <tr >
                     <th class="title" align="right">���ݿ�����:</th>
                     <td align="left"><%=up.dbname%></td>
                   </tr>
                   <tr >
                     <th class="title"  align="right">ʹ��ʱ��:</th>
                     <td align="left"><%=up.dbbuydate%>��<%=up.dbexpiredate%>&nbsp;&nbsp;ʣ������:<%=up.dayHave%>��</td>
                   </tr>
                   <tr >
                     <th class="title"  align="right">��ǰ�ͺ�:</th>
                     <td align="left"><%=up.dbp_name%>(<%=up.dbproid%>)</td>
                   </tr>
                   <tr >
                     <th class="title"  align="right">��ǰ����:</th>
                     <td align="left"><%=up.dbroomname%></td>
                   </tr>
                   <tr >
                     <th class="title"  align="right">�����������ͺ�:</th>
                     <td align="left"><%=up.newProidlist%></td>
                     <div id="bubbleContent" style="clear:both; margin-left:150px; color:#F00; background-color:#FFC; display:none"></div>
                   </tr>

                   <tr  id="newroomlist">
                     <th class="title"  align="right">�������Ļ���:</th>
                     <td align="left"></td>
                   </tr>
                   <tr id="priceMethod">
                     <th class="title"  align="right">ÿ����:</th>
                     <td align="left"></td>
                   </tr>
                   <tr id="priceShouXuFei">
                     <th class="title"  align="right">������:</th>
                     <td align="left"></td>
                   </tr>
                   <tr id="needPrice">
                     <th class="title"  align="right">�ϼ�:</th>
                     <td align="left"></td>
                   </tr>
                   <tr class="buttonmsg">
                     <td  colspan="2"><input type="button"  value="ȷ������" name="subbtton" class="manager-btn s-btn"  /></td>
                     <label id="loadsubinfo" style="display:none"><img src="/images/mallload.gif">����ִ����,����ˢ�»�رո�ҳ��..</label>
                   </tr>
                 </table >
                 <input type="hidden" name="id" value="<%=dataID%>" />
                 <input type="hidden" name="act" />
                 <input type="hidden" name="dbproid" value="<%=up.dbproid%>" />
                 <input type="hidden" name="dbroom" value="<%=up.dbroom%>" />

               </form>
               <div style="border:2px dotted #ccc; border: 2px dotted #ccc;margin: 20px 0 0 0;width: 100%;">1.������MSSQL���ݿ�ĵ������ڲ���<br />
                 2.��������Ϊ���¾����ݿ��ͺ�ÿ��Ĳ�ۡ�ʣ���δʹ���������������ò���30Ԫ�ģ���30Ԫ���㡣<br />
                 3.������վ��Mssql����ͬһ����������������ٶȻ�ǳ���</div>
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