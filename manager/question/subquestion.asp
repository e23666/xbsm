<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open conStr
function dvHTMLEncode(fString)
if not isnull(fString) then
    fString = replace(fString, ">", "&gt;")
    fString = replace(fString, "<", "&lt;")

    fString = Replace(fString, CHR(9), "&nbsp;")
    fString = Replace(fString, CHR(34), "&quot;")
    fString = Replace(fString, CHR(39), "&#39;")
    fString = Replace(fString, CHR(13), "")
    fString = Replace(fString, CHR(10) & CHR(10), "</P><P> ")
    fString = Replace(fString, CHR(10), "<BR> ")

    dvHTMLEncode = fString
end if
end function
function HTMLCode(SString)
if SString<>"" then


    SString = replace(SString, "&gt;",">")
    SString = replace(SString,  "&lt;","<")

   SString = Replace(SString, "&nbsp;", CHR(9))
   SString = Replace(SString, "&quot;", CHR(34))
   SString = Replace(SString, "&#39;",  CHR(39))
   SString = Replace(SString, "</P><P> ", CHR(10) & CHR(10))
   SString = Replace(SString,  "<BR> ",CHR(10))

    HTMLCode = SString
end if
end function

q_fid=Trim(Requesta("q_fid")) 
if isNumeric(q_fid&"") then
	Csearch=True
	IdSet=Cstr(q_fid)
	Sid=q_fid
	Do While Csearch
		Sql="Select * from question where q_id=" & Sid & " and q_user_name='" & Session("user_name") & "'"
		Rs.open Sql,conn,1,1
		if Not Rs.eof then 
			if Rs("q_fid")>0 then
				Sid=Rs("q_fid")
				IdSet=IdSet & "," & Sid
			else
				subject=Rs("q_subject")
				domain=Rs("q_user_domain")
				ip=Rs("q_user_ip")
				keyword=Rs("q_keyword")
				q_type=Rs("q_type")
				Csearch=False
			end If
		Else
			Csearch=False
		End if
		Rs.close
	Loop
end if

content=""

if isNumeric(q_fid) then
	Sql="Select * from question where q_id in (" & IdSet & ") and q_user_name='" & Session("user_name") & "' order by q_id"
	Rs.Open Sql,conn,1,1
	Do While Not Rs.eof
		content=content & "<div style=""background-color:#ffcc99"">��----</div>" & "<BR>&nbsp;&nbsp;" & Rs("q_content") & "<BR>" & "<div style=""background-color:#ffcc99"">��----</div><BR>&nbsp;&nbsp;" &VbCrLf & Rs("q_reply_content")
	Rs.MoveNext
	Loop
	Rs.close
end if
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-���ʱش�</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<SCRIPT language=javascript>
q_type="0<%=q_type%>"
$(function(){

	$("select[name='type']").val(q_type);
})
function checkstr()
{
	if(form1.subject.value==""){
		$.dialog.alert("��ʾ��������������Ŀ��");
		form1.subject.focus();
		return false;
	}

	if($("select[name='type']").val()==null)
	{
		$.dialog.alert("��ѡ���������");
		 
		return false;
	}

	if(form1.content.value==""){
		$.dialog.alert("��ʾ���������������ݣ�");
		form1.content.focus();
		return false;
	}
	form1.content.value=replacesqlin(form1.content.value)
	
	
}

function autotxt(obj){
	var val=obj.selectedIndex;
	var txt=document.getElementById("content").value;
	var tip="";
	switch(val){   
  ����case 1:tip="FTP(�ϴ�)�û�����";break;
  ����case 2:tip="�ҵ�������";break;
  ����case 3:tip="����������";break;
  	  case 5:
 	  case 6:tip="������IP��";break;
  	  default:tip="";
	}
	if (tip.length>1){
	document.getElementById("content").value = tip + "\n" + txt;
	}

}
 function replacesqlin(content)
 {
		var  bjiaoarr=Array('exec','execute','master','user','cmd.exe','insert','xp_cmdshell','mid','update','select','delete','drop','database','db_name','union','char','unicode','asc','left','or','where','backup','chr','nchar','cast','substring','set','from','into','values','and','declare','exists','truncate','join','create','--','convert','db_name','schema','executeglobal','eval','script','applet','object','alter','rename','modify','varchar','sp_executesql')
	var qjiaoarr=Array('��xec','��xecute','��aster','��ser','��md.exe','��nsert','��p_cmdshell','��id','��pdate','��elect','��elete','��rop','��atabase','��b_name','��nion','��har','��nicode','��sc','��eft','��r','��here','��ackup','��hr','��char','��ast','��ubstring','��et','��rom','��nto','��alues','��nd','��eclare','��xists','��runcate','��oin','��reate','--','��onvert','��b_name','��chema','��xecuteglobal','��val','��cript','��pplet','object','��lter','��ename','��odify','��archar','��p_executesql')
	 for (i=0;i<bjiaoarr.length ;i++ )
	{	
		//var regx=exec('/['+bjiaoarr[i]+']/ig');
		var regx = new RegExp(bjiaoarr[i], "ig")
		content=content.replace(regx,qjiaoarr[i])
	}
	return content;
 }
</SCRIPT>
 

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
			   <li><a href="/manager/question/subquestion.asp">���ʱش�</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">



      <form name="form2" method="post" action="/faq/search.asp">   
  
                <input id="Keyword"  class="manager-input s-input" maxlength="50" size="20" value="�ؼ���" name="keyword"  onClick="this.focus();if(this.value=='�ؼ���'){this.value=''}"  onBlur="if(this.value==''){this.value='�ؼ���'}">
                <input type=radio name=where value=title checked>
                ���� 
                <input type=radio name=where value=content >
                ���� 
                <input type="submit" name="Submit2" value="������������" class="manager-btn s-btn">
               <a href="allquestion.asp?module=search&qtype=myall" ><font color="#993333">�鿴�ظ�</font></a><br>
           
</form>  
 












 <form action="subok.asp"  onSubmit="return checkstr();" method="post" name="form1">
<table class="manager-table">
			<%if content <> "" then%>
			<tr><th colspan=2>�������:<th></tr>
			<tr><td colspan=2><%=content%></td></tr>
			<%end if%> 
                  <th width="25%" align="right">������Ŀ��</th>
                  <td width="75%" align="left"><input name="subject" id="subject" class="inputbox" value="<%=subject%>"  size=50 ></td>
                </tr>
                <tr> 
                  <th align="right">�������</th>
                  <td align="left">
                          <select name=type class="selectbox" onChange="autotxt(this)">
                            <option value="0101">��ǰ��ѯ</option>
                            <option value="0102" selected>������������</option>
							 <option value="142" >�ƽ�վ</option>
                            <option value="0103">��������</option>
                            <option value="0104">��ҵ��������</option>
                            <option value="0201">���ݿ�����</option>
                            <option value="0202">��������/�й�����</option>
                            <option value="0203">VPS�������</option>
                            <option value="0204">�����������</option>
                            <option value="0301">��������</option>
                            <option value="0302">��վ��������</option>
                            <option value="0302">��վ�ƹ�����</option>
                            <option value="0304">���������������</option>
                            <option value="0304">����ƽ̨�������</option>
                            <option value="0701">Ͷ�߽���</option>
                            <option value="0801">����</option>
                          </select> 
						  
				   </td>
                </tr>
                
                <tr> 
                  <th align="right"> ���������</th>
                  <td align="left"><input  name=domain class="inputbox" value="<%=domain%>" size="40">
                          ����еĻ�
				  </td>
                </tr>
                
                <tr> 
                  <th align="right">���IP��ַ��</th>
                  <td align="left"><input  name=ip class="inputbox" value="<%=ip%>" size="40">
                          (����еĻ�)</td>
                </tr>
                
                <tr> 
                  <th  align="right">����ؼ��֣�</th>
                  <td align="left"><input  name=keyword class="inputbox" value="<%=keyword%>">
                          (����еĻ�) 
                          <input type=hidden value=postquestion name=module>
                          <input type="hidden" name="q_fid" value="<%=q_fid%>">
                          <input type="hidden" name="uploadFileName" id="uploadFileName"> 
				  </td>
                </tr>
                
                <tr> 
                  <th align="right">��ͼ(С��200K)��</th>
                  <td align="left"><IFRAME FRAMEBORDER=0 SCROLLING="no" WIDTH=100% height=24 SRC="post_upload.asp"></IFRAME></td>
                </tr>
                <tr> 
                  <th align="right">����������<br>
<font color="red">���������������дFTP�˺ź�������</font></th>
                  <td  align="left">
					   <textarea  name="content" id="content" cols=55 rows=15 wrap="VIRTUAL" class="inputbox_2"></textarea>
				  </td>
                </tr>
				<tr> 
                  <td height="60" colspan="2" ><input name=Submit type=submit value=�����ύ���� class="manager-btn s-btn"></td>
                </tr>
                <tr> 
                  <td height="60" colspan="2" > 
                  <div align="left">���������ṩ��Ʒ��ͬʱ��ҲΪ���ṩ�����Ƶ��ۺ�����ڲ�Ʒʹ�ù���������������һЩ���⣬�����Ȳο�<a href="/faq"><font color="#0000FF">��������</font></a>��Ŀ��Ҳ�����о�������������Ľ����������<a href="/faq"><font color="#0000FF">��������</font></a>���Ҳ�����ش𰸵ģ����ύ���⡣</div>                  </td>
                </tr>
        </form>
</table>











		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>

 