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
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>�û������̨-Mssql���ݿ�����</title>

<link href="/manager/css/admin.css" rel="stylesheet" type="text/css" />
<link href="/manager/css/style.css" rel="stylesheet" type="text/css" />
<link href="<%=managercss1%>" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=managercss2%>" type="text/css" />
<script language="javascript" src="/jscripts/jq.js"></script>
<script language="javascript" src="/jscripts/upmssql.js"></script>
</head>
<body id="thrColEls">

<div class="Style2009"> 
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV"> 
    <!--#include virtual="/manager/manageleft.asp" -->
    <div id="MainRight">
      <div class="new_right"> 
        <!--#include virtual="/manager/pulictop.asp" -->
        
        <div class="main_table">
          <div class="tab">Mssql���ݿ�����</div>
          <div class="table_out">
         
        <form name="form_uphost" action="<%=requesta("script_name")%>" method="post">
  <dl class="linebox" style="width:700px; margin:10px;">
    <dt>MSSQL����</dt>
    <dd class="clearfix">
      <label class="title">���ݿ�����:</label>
      <label><%=up.dbname%></label>
    </dd>
    <dd class="clearfix">
      <label class="title" >ʹ��ʱ��:</label>
      <label><%=up.dbbuydate%>��<%=up.dbexpiredate%>&nbsp;&nbsp;ʣ������:<%=up.dayHave%>��</label>
    </dd>
    <dd class="clearfix">
      <label class="title">��ǰ�ͺ�:</label>
      <label><%=up.dbp_name%>(<%=up.dbproid%>)</label>
    </dd>
    <dd class="clearfix">
      <label class="title">��ǰ����:</label>
      <label><%=up.dbroomname%></label>
    </dd>
    <dd class="clearfix">
      <label class="title">�����������ͺ�:</label>
      <label><%=up.newProidlist%></label>
      <div id="bubbleContent" style="clear:both; margin-left:150px; color:#F00; background-color:#FFC; display:none"></div>
    </dd>
    <dd class="clearfix" id="newroomlist">
      <label class="title">�������Ļ���:</label>
      <label></label>
    </dd>
    <dd class="clearfix" id="priceMethod">
      <label class="title">ÿ����:</label>
      <label></label>
    </dd>
    <dd class="clearfix"id="priceShouXuFei">
      <label class="title">������:</label>
      <label></label>
    </dd>
    <dd class="clearfix" id="needPrice">
      <label class="title">�ϼ�:</label>
      <label></label>
    </dd>
    <dd class="buttonmsg">
      <input type="button" value="ȷ������" name="subbtton" />
      <div id="loadsubinfo" style="display:none"><img src="/images/mallload.gif">����ִ����,����ˢ�»�رո�ҳ��..</div>
    </dd>
  </dl>
  <input type="hidden" name="id" value="<%=dataID%>" />
  <input type="hidden" name="act" />
  <input type="hidden" name="dbproid" value="<%=up.dbproid%>" />
  <input type="hidden" name="dbroom" value="<%=up.dbroom%>" />

</form>
<div style="border:2px dotted #ccc; padding:10px; margin:10px; width:700px">1.������MSSQL���ݿ�ĵ������ڲ���<br />
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
    </div>
  </div>
  <!--#include virtual="/manager/bottom.asp" --> 
</div>


</body>

</html>

