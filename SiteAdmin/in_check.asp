<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/md5_16.asp" -->
<%
if trim(webmanagespwd)<>"" then 
die "��Ȩ����"
end if


password=Request.Form("password")
repassword=Request.Form("repassword")
LocalPass = webmanagespwd&year(now())&month(now())
if password<>"" and len(password)>5 and repassword=password Then
     session("pss")=""
	 Set fso = Server.CreateObject(objName_FSO)
		module=Request("module")
		set file=fso.opentextfile(server.mappath("/config/const.asp"),1)
		MB=file.readall
		file.close 
		
		set file = nothing
		splitAll=split(MB,VbCrLf)
		Set rea = New RegExp
	rea.IgnoreCase=true
	    rea.Pattern="(webmanagespwd)\s*=\s*""([^'""\n\r]*)"""
		webmanagespwdmd5=md5_16("west263!~@"&password&"west263!~@o;asdfOqwerJ"&webmanagesrepwd)
		MB=rea.replace(MB,"$1=" & """"&webmanagespwdmd5&"""")
		set file=fso.createtextfile(server.mappath("/config/const.asp"),true) 
			set rea=nothing
	file.write MB
	file.close 
	set file = nothing 
	response.Redirect(SystemAdminPath)
	die ""
     
end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link href="/css/Global.css" rel="stylesheet" type="text/css" />
<link href="/css/Manager.css" rel="stylesheet" type="text/css" />
<style type="text/css">
body {
	background-color: #fff;
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
	font-size:12px;
}
body,td,th {
	color: #000;
	text-align:center;
}
#password,#repassword{ height:20px; line-height:20px; color:red; width:200px; text-align:center;}
h1{ font-size:18px;}
</style>
<title>���������</title>
<script type="text/javascript">
if ( top.location !== self.location ) 
{ 
top.location=self.location; 
} 

</script>
</head>

<body id="thrColEls">
<div id="MainContentDIV">
	<div class="Table_Div_line" style=" width:600px; margin:auto;margin-top:200px; border:solid 1px #ccc;background-color:#efefef">
<form name="form1" method="post" action="?" onsubmit="return chk()">
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
     
        <tr>
          <td height="25"  align="center">&nbsp;&nbsp;<h1 style="color:#0000ff">���ú�̨��½ר����½���룡</h1><font color=red>(���������̨ר����½�����)</font><br /></td>
        </tr>
       
        <tr>
  
          <td height="80" align="center" style="line-height:45px;"> 
            <strong>��½����:</strong>
            <input type="password" name="password" id="password" title="�������̨ר����½���룡" />
              <br />
              <strong>��֤����:</strong>
            <input type="password" name="repassword" id="repassword" title="�������̨ר����½���룡" /></td>
        </tr>
        <tr>
    
          <td align="center"  height="30"><input name="button" type="submit" class="button_gary" id="button" value="   �� ��   "  />
          &nbsp;</td>
        </tr>
        <tr>
          <td align="left"  height="30" style="text-align:left; padding:10px; line-height:25px;"><p>˵����<br />
           
          1��Ϊ��ֹ����Ա��½�ʺ�й©������δ֪bug����ڿ͵�½��̨�����������ú�̨ר�õ�½���룬�Դﵽ˫��������֤Ч������ǿϵͳ��ȫϵ��!<br />
          2����̨ר����½���������������������벻һ�£���ֹ���µ���<br />
          3��Ϊ����ǿ����ƽ̨��̨�İ�ȫ�ԣ�������������ƽ̨��̨Ŀ¼����IP���ƣ�ֻ����ָ����IP��¼���������Է�ֹδ֪��ϵͳ���ա� <br />          
          </p></td>
        </tr>
      </table>
</form>
	<script>
	function chk()
	{
	   p=document.getElementById("password");
	   p2=document.getElementById("repassword")	
	   if(p.value.length<5)
	   {
		alert("��̨��½ר�����볤�ȱش���5���ַ�!");
		p.focus();
		return false
		}
	   if(p.value!=p2.value)
	   {
		alert("�����������벻һ��");
		p.focus();
		return false
		}
	}
	</script>
    
    </div>
</div></body>
</html>
