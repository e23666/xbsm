<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
response.Charset="gb2312"
function Trims(varStr)
 varStr=Trim(varStr)
 Trims=replace(varStr,"'","��")
end function

conn.open constr
name=Trims(Requesta("name"))
username=Trims(Requesta("username"))
hktype=Trims(Requesta("hktype"))
moneys=Trims(Requesta("money"))
uploadFileName=Requesta("uploadFileName")
PayDate=Requesta("year") & "-" & Requesta("months") & "-" & Requesta("day") & "  " & Requesta("time") & "ʱ"
Orders=Trims(Requesta("ddnum"))
UseFor=Trims(Requesta("UseFor"))
Mem=Trims(Requesta("Mem"))
if Requesta("phone")<>"" then Mem=Mem & ",�绰��" & Requesta("phone")

if name<>"" and username<>"" then
  Sql="Select u_id from userdetail where u_name='" & username & "'"
  Rs.open Sql,conn,1,1
  if Rs.eof then
		url_return "����,����д�Ļ�Ա�û�������˾ϵͳ�в�����,�⽫Ӱ����ҵ���������ͨ,��������ϸ��д!",-1
  end if
  Rs.close
  if not isnumeric(moneys&"") then url_return "����ȷ¼������",-1

  Sql="Insert into PayEnd ([name],[username],[PayMethod],[Amount],[PayDate],[Orders],[ForUse],p_state,[Memo],[Pdate],[SubIP],[P_Pic]) Values ("
  Sql=Sql & "'" & name &"','" & username & "','" & hktype &"'," & Moneys & ",'" & PayDate & "','" & Orders &"','" & UseFor & "',0,'" & Mem &"','" & Now & "','" & Request.ServerVariables("Remote_Addr") & "','" & uploadFileName & "')"
  conn.Execute(Sql)
  		getStr="username=" & username & "," & _
			  "name=" & name & "," & _
			  "hktype=" & hktype & "," & _
			  "Moneys=" & Moneys & "," & _
			  "PayDate=" & PayDate & "," & _
			  "phone=" & replace(Requesta("phone"),",","��") & "," & _
			  "Mem=" & replace(Requesta("Mem"),",","��")
		mailbody=redMailTemplate("payendtomanager.txt",getStr)
		if agentmail<>"" then
			call sendMail(agentmail,"���ȷ��-"& username,mailbody)
		end if
  
  
  Response.write "<script language=javascript>alert('���Ļ��ȷ���Ѿ��ύ�ɹ������ǻ��ڲ��ʺ󾡿쿪ͨ����ҵ����ע������ʼ����������ע�����ϲ�����ϸ���������޸ģ������ܼ�ʱΪ����ͨҵ��');window.location.href='ViewPayEnd.asp';</script>"
  Response.end
end if
sql="select u_namecn,u_name from userdetail where u_id="& session("u_sysid") &""
rs.open sql,conn,1,1
if not rs.eof then
	u_namecn=rs("u_namecn")
	u_name=rs("u_name")
end if
rs.close
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-���ȷ��</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
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
			   <li><a href="/manager/useraccount/payend.asp">���ȷ��</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">

  <FORM NAME="form1" METHOD="post" ACTION="PayEnd.asp" ONSUBMIT="return check(this);">
  <TABLE  class="manager-table">

    <TR>
      <TH width="35%" align="right">��������</TH>
      <TD width="65%" align="left"><INPUT TYPE="text" NAME="name" class="manager-input s-input" value="<%=u_namecn%>">
        (�������ʵ����) </TD>
    </TR>
    <TR>
      <Th align="right">�û�����</Th>
      <TD align="left"><INPUT TYPE="text" NAME="username" class="manager-input s-input" value="<%=u_name%>">
        (�ڱ�վע����û����� </TD>
    </TR>
    <TR>
      <Th align="right">��ʽ��</Th>
      <TD align="left"><SELECT NAME="hktype" ONCHANGE="setInfo(this.value);">
          <option value="��������">��������</option>
          <option value="��ͨ����">��ͨ����</option>
          <option value="��������">��������</option>
          <option value="��������">��������</option>
          <option value="ũҵ����">ũҵ����</option>
          <option value="֧����֧��">֧����֧��</option>
          <option value="�Ƹ�֧ͨ��">�Ƹ�֧ͨ��</option>
          <option value="����֧��">����֧��(�ױ�)</option>
          <option value="��˾ת��">��˾ת��</option>
          <option value="�������ʻ��">�������ʻ��</option>
          <option value="��˾ת��2">��˾ת��2</option>
          <option value="�������">�������</option>
          <option value="�������ۻ��">�������ۻ��</option>
          <option value="����֧��">����֧��</option>
          <option value="��Ǯ֧��">��Ǯ֧��</option>
        </SELECT>
        <FONT SIZE=2 COLOR=green><SPAN ID=MESS> <BR>
        ע:����֧��ʧ�ܵ��û�,��ֱ��ѡ������֧����֧����֧��,��Ҫѡ�񸶿�ʱ�����õ�����.</SPAN></FONT></TD>
    </TR>
    <SCRIPT LANGUAGE=javascript>
function setInfo(strValue){
   if (strValue=="�������"||strValue=="��˾ת��") 
      MESS.innerHTML="(" + strValue +"����ʵʱ���ʣ����鴫����׵�)";
  else
      MESS.innerHTML="";
}
</SCRIPT>
    <TR>
      <Th align="right">����</Th>
      <TD align="left"><INPUT TYPE="text" NAME="money" class="manager-input s-input">
        Ԫ </TD>
    </TR>
    <TR>
      <TH align="right">���ʱ�䣺</TH>
      <TD align="left"><INPUT TYPE="text" NAME="year" class="manager-input s-input" VALUE="<%=year(now())%>" MAXLENGTH="4" SIZE="3">
        ��
        <INPUT TYPE="text" NAME="months" VALUE="<%=month(now())%>" class="manager-input s-input" MAXLENGTH="4" SIZE="3">
        ��
        <INPUT TYPE="text" NAME="day" SIZE="2" MAXLENGTH="3" class="manager-input s-input" value="<%=day(now())%>">
        ��
        <SELECT NAME="time">
          <OPTION VALUE="1">01</OPTION>
          <OPTION VALUE="2">02</OPTION>
          <OPTION VALUE="3">03</OPTION>
          <OPTION VALUE="4">04</OPTION>
          <OPTION VALUE="5">05</OPTION>
          <OPTION VALUE="6">06</OPTION>
          <OPTION VALUE="7">07</OPTION>
          <OPTION VALUE="8">08</OPTION>
          <OPTION VALUE="9">09</OPTION>
          <OPTION VALUE="10">10</OPTION>
          <OPTION VALUE="11">11</OPTION>
          <OPTION VALUE="12">12</OPTION>
          <OPTION VALUE="13">13</OPTION>
          <OPTION VALUE="14">14</OPTION>
          <OPTION VALUE="15">15</OPTION>
          <OPTION VALUE="16">16</OPTION>
          <OPTION VALUE="17">17</OPTION>
          <OPTION VALUE="18">18</OPTION>
          <OPTION VALUE="19">19</OPTION>
          <OPTION VALUE="20">20</OPTION>
          <OPTION VALUE="21">21</OPTION>
          <OPTION VALUE="22">22</OPTION>
          <OPTION VALUE="23">23</OPTION>
          <OPTION VALUE="0">00</OPTION>
        </SELECT>
        ʱ </TD>
    </TR>
    <TR>
      <TH align="right" VALIGN="top">�����ţ�</TH>
      <TD align="left"><INPUT TYPE="text" NAME="ddnum" class="manager-input s-input" VALUE="">
        (������������ö��Ÿ���,���Ѳ�����д)</TD>
    </TR>
    <TR>
      <TH align="right" VALIGN="top">�����;��</TH>
      <TD align="left"><INPUT TYPE="radio" NAME="usefor"  VALUE="�����Ʒ" ONCLICK="if (this.form.ddnum.value=='') alert('�����δ��ҵ�񶩵���д��[������]������˾�����𽫿�ӵ�����Ա����,����Ҫ���п�ͨҵ��');">
        �����Ʒ
        <INPUT TYPE="radio" NAME="usefor" VALUE="����">
        ����
        <INPUT TYPE="radio" NAME="usefor" VALUE="����">
        ����
        <INPUT TYPE="radio" NAME="usefor" VALUE="׷��Ԥ����">
        ׷��Ԥ����<BR>
        <INPUT TYPE="radio" NAME="usefor" VALUE="���÷�����">
        ���÷�����
        <INPUT TYPE="radio" NAME="usefor" VALUE="�������">
        �������/�������</TD>
    </TR>
    <TR>
      <TH ALIGN="right" VALIGN="top">��ϵ�绰��</TH>
      <TD align="left"><INPUT TYPE="text" NAME="phone" class="manager-input s-input">
        �����Բ�� </TD>
    </TR>
    <TR>
      <TH align="right" VALIGN="top">��ע��</TH>
      <TD align="left"><INPUT TYPE="text" NAME="mem" class="manager-input s-input">
        �������ѣ�����дҪ���ѵ�ҵ�� </TD>
    </TR>
    <TR>
      <TH ALIGN="right">���׵�ɨ��:</TH>
      <TD ID="uploadLabel"><IFRAME FRAMEBORDER=0 SCROLLING="no"  WIDTH=100% height=24 SRC="/customercenter/post_upload.asp"></IFRAME></TD>
    </TR>
    <TR>
     
      <TD   ID="uploadLabel"colspan=2>���û�в���ѡ��,��չ��:jpg,gif,С��200K</TD>
    </TR>
    <TR>
      
      <TD colspan=2><INPUT TYPE="submit" NAME="Submit" VALUE="�ύ"  class="manager-btn s-btn">
        <INPUT TYPE="reset" NAME="Submit2" VALUE="���"  class="manager-btn s-btn">
        <INPUT TYPE="hidden" NAME="uploadFileName" ID="uploadFileName">
      </TD>
    </TR>
    <TR>
      <TD align="left" colspan="2">��ʾ��
        <P>���ѵĿͻ������ڱ�ע��ע����Ҫ���ѵ��������������������ڻ����;��ѡ�����ѡ����û����ȷע����;�ģ�����ֻ���𽫿��������ʺ��ϣ���Ҫ�Լ����������ĵ��"����"��<BR>
          <BR>
          ����ر�֤���������Աʱ����д���û���������ʵ������,����ҵ���ݲ���ͨ</P></TD>
    </TR>
  </FORM>
</TABLE>
          







		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>





 