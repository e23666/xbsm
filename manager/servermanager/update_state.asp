<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%
conn.open constr
id=requesta("id")
act=requesta("act")

if act<>"1" and act<>"2" and act<>"reupdate" then url_return "�����д�",-1
set bs=new buyServer_Class:bs.setUserid=session("u_sysid"):bs.oldhostid=id
call bs.getHostdata(id)
if act="reupdate" then
	commandstr="server"& vbcrlf & _
			   "set"& vbcrlf & _
			   "entityname:reupserver" & vbcrlf & _
			   "serverip:" & bs.oldserverip & vbcrlf & _
			   "." & vbcrlf	   

	resultstr=pcommand(commandstr,bs.user_name)	
	if left(resultstr,3)="200" then
		gowithwin "update.asp?id="&id
	else
		alert_redirect resultstr,requesta("script_name")&"?id="&id
	end if
	response.end
end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>����IP��������</title>
<link href="<%=managercss1%>" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=managercss2%>" type="text/css" />
<link href="/manager/css/admin.css" rel="stylesheet" type="text/css" />
<link href="/manager/css/style.css" rel="stylesheet" type="text/css" />
<script language="javascript" src="/jscripts/jq.js"></script>
<script language="javascript">
function reupdate(){
	if(confirm("ȷ������������ת�����?")){
		$("input[name='act']:hidden").val("reupdate");
		$("form[name='form_uphost']").submit();
	}
}
</script>
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
          <div class="tab">����IP��������</div>
          <div class="table_out">
            <form name="form_uphost" action="<%=requesta("script_name")%>" method="post">
            	<%if upstate=1 then%>
            	<div>���ǽ���һ���������ڶ�����VPS�����������������������н��ж�1�������ҡ�</div>
                <%else%>
                <div>
                	<div>��IPΪ:<span class="price"><%=bs.oldserverip%></span></div>
                    <div>������:<span class="price"><%=bs.RamdomPass%></span></div>
                    <div>������ɺ���10�������ҿ�ͨ</div>
                    <div>
                    	<div>
                        	�뼰ʱת������,ԭ���ݽ�������7���ɾ��
                        </div>
                    </div>
                    <div><input type="button" value="�����Ѿ�ת����ϣ���������" onClick="reupdate()" class="btn_blue"  /></div>
                </div>
                <%end if%>
                <input type="hidden" name="act" />
                <input type="hidden" name="id" value="<%=id%>" />
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!--#include virtual="/manager/bottom.asp" --> 
</div>
</body>
</html>
