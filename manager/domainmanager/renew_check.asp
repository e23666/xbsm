<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
act=requesta("act") : randomize : rndx = int(rnd*100)
domainid = requesta("DomainID")

If Not IsNumeric(domainid&"") Then url_return "��������",-1
oldurl	= "renewDomain.asp?domainid=" & domainid
If requesta("q")="yes" Then response.Redirect oldurl
if instr(lcase(api_url),"api.west263.com")=0 Then response.Redirect oldurl
user_name = session("user_name") : user_id  = session("u_sysid")
renewYear = 1
myauthcode = request("authcode")

conn.open constr
sql="select top 1 * from domainlist where d_id=" & domainid & " and userid=" & user_id & " and isreglocal=0"
rs.open sql,conn,1,1
If rs.eof Then Response.Redirect oldurl
For i=0 to rs.Fields.Count-1
	execute( "fo_" & rs.Fields(i).Name & "=rs.Fields(" & i & ").value")
Next
rs.close
domain  = fo_strDomain : strDomain=domain

if instr(",1,11,9,12,",","&fo_tran_state&",")>0 then url_return "������������ת�룬����ԼΪ5-30�죬������ʱ���������ϵ����Ա",-1
upState =  getDomTransState(domain)
if instr(",1,11,9,12,", ","&upState&",")>0 then url_return "������������ת�룬����ԼΪ5-30�죬������ʱ���������ϵ����Ա",-1

domtype = lcase(fo_proid)
channel = getW2Channel(domain)
if datediff("d",fo_regdate,date())<=60 then errmsg=errmsg+"<li>����ע��δ��60�죬Ϊ��ֹ����ʧ�ܣ����60�����������ת�ơ�</li>"'����������
 

if channel="" then  Response.Redirect oldurl	'��˾��֧��ת����������
If channel="west2" And left(domain,4)="xn--" Then bDomain = gbkcode(domain)
If channel="west2" Or channel="west3" Then needDays1=5 Else needDays1=6
whoismail=fo_dom_em :if whoismail="" then whoismail=fo_admi_en
'if whoismail="" then url_return "�����������������������������",-1

register = getDomReg(strDomain) 
if register="" or left(register,4)="west" then response.Redirect oldurl
if register="webcc" Then response.Redirect oldurl	'20150429

rexpiredate=formatDateTime(DateAdd("yyyy",fo_years,fo_regdate),2)
remainYear = datediff("yyyy",date(),rexpiredate)
leftdays = datediff("d",date(),rexpiredate):leftdays=Cdbl(leftdays)
MaxRenewDate=dateadd("d",3650,now())
MaxRenewDay=Datediff("d",rexpiredate,MaxRenewDate)
remainYear=int(MaxRenewDay/365)
if remainYear=0 then url_return "�������Ѿ��ﵽ������ޣ��޷�����",-1

needpass=0		'�� -- �Ƿ���Ҫ�ṩת������
if channel="west4" or channel="west5" or ( (channel="west2" or channel="west3") and register="bizcn" ) then needPass=1

checkren=False	'��Ҫ��60���ڣ������ҵ������������ѵļ�¼
sql="select 1 from countlist where u_id=" & user_id & " and dateDiff("&PE_DatePart_D&",c_date,"&PE_Now&")<60 and c_memo like 'renew domain%' and u_countid like '%-" & domain & "'"
set trs=conn.execute(sql)
If trs.eof then checkren=true Else errmsg=errmsg+"<li>�����������(60����)�����Ѳ�����Ϊ��ֹת������ʧ�ܣ���60���ִ�б�������</li>"
trs.close

'�������룬���������������ǰ�������ύ, ����������ȷ��������6��ǰ���������룬��Ҫ����2��ǰ
If leftdays<=0 then errmsg=errmsg+"<li>�����Ѿ����ڣ���������ǰ����ת��(����ǰ1����)��</li>"
If leftdays<=2 And needPass=0 Then errmsg=errmsg+"<li>��������ʱ��̫�̣�������Ϊ����ȡ���룬��������ǰ����ת��(����ǰ1����)��</li>"
If leftdays<=needDays1 And (channel="west4" Or channel="west5") Then errmsg=errmsg+"<li>��������ʱ��̫�̣���ֱ�����Ѻ��������ʱ����ǰ1������ת��</li>"

needPrice2 = getNeedPrice(user_name,domtype,1,"renew")	'�ɼ�
domtype_=domtype
if domtype_="domnet" then domtype_="domcom"
needPrice = eval("trainsin_" & domtype_)	'�¼�

if not isnumeric(needPrice&"") then needPrice=needPrice2
needPrice=ccur(needPrice) : needPrice2=ccur(needPrice2)

if needPrice<1 or needPrice2<1  then response.Write "�۸��д�������ϵ����Ա" : response.End()

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>����ת��</title>
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style>
#resultdiv{
	border:1px solid #39F;
	padding:10px;
	margin:10px auto;
	width:750px;
}
a:link,a:visited{
	color:#0080C0;
	text-decoration:underline;
}
a:hover{
	color:red;
	text-decoration:none
}
</style>
</head>

<body>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" >����ת�벢����</td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td height='30' ><!--#include file="../share/AgentPrice.asp"--></td>
  </tr>
</table>

<div id="resultdiv"> 
<div style="color:#004080">
<p>����������ʾ�� 
<%if domtype="domcn" or domtype="domchina" then%>
<%=companyname%>����2011��5����ʽͨ��CNNIC��֤
<%else%>
<%=companyname%>����2011��10����ʽͨ��������������ϵ��߹������ICANN��֤
<%end if%>����Ϊ��������ע���̡���������������˾ͨ����֤��ǰͨ��������������ע��������ġ�Ϊ�˱��ڹ�����˾ǿ�ҽ�����������ת��ע����Ϊ��˾��ת�Ƴɹ����������Զ�����һ�ꡣ</p>
<p>������˾Ϊ������˽�Ϊ�Ż������̣������谴�������̽�����ϼ������ɽ�����ת�Ƴɹ���ת�Ƴɹ���������������ø��͵����Ѽ۸�͸���ݵķ���</p>
</div>
<hr />

<%if act="" then%>

<form method="post" name="form1" id="form1" onSubmit="return check1()">
<%if errmsg<>"" then%>
	<div style="background:#FFEEF7;padding:10px;">
	<h4 style="color:red;">����������������ת��������</h4>
	<%=errmsg%>
    </div>
<%elseif (domtype="domcn" or domtype="domchina") then%>
<div class="nopassbox">
	<div style="margin-bottom:15px;font-weight:bold"><span style="font-size:14px"><font color="#FF0000">���Ȱ�����������ȡ����ת�����룬��ȡת������󼴿ɰ�������ת�ƣ�<br></font>��������"��ȡת������"�Ļ���������</span><br />����ע�������60�գ��������������25�����ϣ����������һ��ת��ע���̻�������60��</div>
<%If leftdays<25 then%>
	<span class='bred'>�������������ʱ��̫�̣��Ѿ���������ȡ���룬������Ѿ���ȡ�����룬��ֱ���������ύ</span>
	<%If leftdays<=needDays1+1 then%>
	<br><span class='bred'>�����������ڣ�ת�ƹ����п��ܻ��������жϷ��ʵ�����</span>
	<%End if%>
<%elseif register="xinet" then%>
            <div class="tit">ԭע����Ϊ����������"��ȡת������"Ӧ�ύ�Ĳ��ϣ�</div>
��1) �а������֤��ӡ����<br />
��2) �Ӹǹ��»�ǩ���ġ�<a href="http://www.myhostadmin.net/Customercenter/doc/����CN����ת�������.doc" target="_blank">��������ת��ע���̣�ת�������������</a>��ԭ����<br />
��3) ���������߹�˾Ӫҵִ�ո�����ӡ�������������������֤��ӡ����<br />
��4) �Ӹǹ��»�ǩ���ġ�<a href="http://www.myhostadmin.net/Customercenter/doc/��������ת����Ȩί����.doc">��Ȩί����</a>��ԭ��
<div class="tit">��Ҫע�⣺</div>
�������֤���ṩ�������渴ӡ����<br />
Ӫҵִ�ո�����ӡ������֯��������֤�����Ч������£�<br />
���ǹ�����������whois���������˵�������Ϣһ�£�<br />
�����˾Ϊ������ҵ,��������Ϣ,����Ϊ���⹫˾פ�й����»���,�޶���Ӫҵִ�ա��뵽��˾���ڹ��ҵ��й���ʹ�ݿ���֤�����ϡ�<br />
<hr />
�ʼĵ�ַ���Ĵ��ɶ������·90���������4¥5�š����ռ��ˣ����١����ʱࣺ610031<br />
��˾���ƣ��ɶ���ά����Ƽ����޹�˾�����绰��028-86263960��204<br />
            <br />
<strong>Aת��ȷ�ϣ�</strong>�����յ��ϸ��ת�����Ϻ󣬽��������Ĺ��������䷢������ת��ȷ�Ϻ����������飬�û����ڹ涨�����ڻظ��ʼ�ȷ��ͬ������ת����<br />
<strong>B����ת�����룺</strong>�����յ�ͬ��ת����ȷ�Ϻ��󣬻���5���������ڷ�������ת��������������������д����,��ע����ա�

<%elseif register="bizcn" then%>
            <div class="tit">ԭע����Ϊ"�����й�"�ļ�����ת�����̣�</div>
��<div style="line-height:25px;">
��˾ÿ��1�Ż�������40���ڵ��ڵ�������ת�����뷢���������������䣬����15������Ч���������յ������������������ת�Ʋ�������������ʧЧ����Ҫ��ϵ�����й��ύ�������ϲ��ܻ�ȡ���롣<br>
		<font color=red>����ǰȷ������whois��Ϣ��������������������ȷ�ģ�</font><br>
		���û���յ����룬����ʹ�����������䣬ֱ�ӷ��ʼ��� trans@west263.com���ʼ�����д �����й�xxx.xxx��������ת�Ƶ�������������롣��˾������Ա��ֱ���ط����롣<br><br>
		</div>

<%elseif register="dnscn" then%>
            <div class="tit">ԭע����Ϊ"��������"�ļ�����ת�����̣�</div>
 <div style="line-height:25px;">
		<font color=red>����ǰȷ������whois��Ϣ��������������������ȷ�ģ�</font><br>
		 ����ʹ�����������䣬ֱ�ӷ��ʼ��� trans@west263.com���ʼ�����д �����й�xxx.xxx��������ת�Ƶ�������������롣��˾������Ա��ֱ���ط����롣<br><br>
		</div>
<%else%>
	ע���̲���ȷ������ϵ����Ա <%=register%><br />
<%end if%>
</div>

<%elseif register="bizcn" then%>
	<div class="bizcninfo">
	        <h3>ԭע����Ϊ"�����й�"�ļ�����ת�����̣�</h3>
	<%If leftdays<=7 then%>
        <span class='bred'>�������������ʱ��̫�̣��Ѿ���������ȡ���룬������Ѿ���ȡ�����룬��ֱ���������ύ</span>
        <%If leftdays<=needDays1 then%>
		<br><span class='bred'>�����������ڣ�ת�ƹ����п��ܻ��������жϷ��ʵ�����</span>
		<%End if%>
    <%else%>
		 <div style="line-height:25px;">��˾ÿ��1�Ż�������40���ڵ��ڵ�������ת�����뷢���������������䣬����15������Ч���������յ������������������ת�Ʋ�������������ʧЧ����Ҫ��ϵ�����й��ύ�������ϲ��ܻ�ȡ���롣<br>
		<font color=red>����ǰȷ������whois��Ϣ��������������������ȷ�ģ�</font><br>
		���û���յ����룬����ʹ�����������䣬ֱ�ӷ��ʼ��� trans@west263.com���ʼ�����д �����й�xxx.xxx��������ת�Ƶ�������������롣��˾������Ա��ֱ���ط����롣<br><br>
		</div>
    <%End if%>
	</div>
<%elseif register="dnscn" then%>
	<div class="bizcninfo">
	        <h3>ԭע����Ϊ"��������"�ļ�����ת�����̣�</h3>
	<%If leftdays<=7 then%>
        <span class='bred'>�������������ʱ��̫�̣��Ѿ���������ȡ���룬������Ѿ���ȡ�����룬��ֱ���������ύ</span>
        <%If leftdays<=needDays1 then%>
		<br><span class='bred'>�����������ڣ�ת�ƹ����п��ܻ��������жϷ��ʵ�����</span>
		<%End if%>
    <%else%>
		 <div style="line-height:25px;">
		<font color=red>����ǰȷ������whois��Ϣ��������������������ȷ�ģ�</font><br>
		 ����ʹ�����������䣬ֱ�ӷ��ʼ��� trans@west263.com���ʼ�����д �����й�xxx.xxx��������ת�Ƶ�������������롣��˾������Ա��ֱ���ط����롣<br><br>
		</div>
    <%End if%>
	</div>
<%else%>

<div class="choose onchoose"><label class="x"><input type="radio" name="auth" value="yes" checked>����һ�������������� <%=whoismail%> �޷������ʼ���������Ȩ��˾ȫ�̲�����ϵͳ����ʱ�޸�������������������Ϊtrans@west263.com��ת�Ƴɹ�����Զ���ԭΪ��Ŀǰ�����䡣(�������ת��ʧ�ܣ��򽫰�ԭ�۸�Ϊ�����ѣ��ұ�������ԭע���̲���)</label>
	<%if register="dnscn" and 1=2 then%>
    <span style="color:red">����������������ת�����̱Ƚϸ��ӣ�Ϊ�����û������ת��Ч�ʣ���ѡ����Ȩ��˾ȫ�̲�����</span>
    <%end if%>
</div>
<%end if%>
<div class="fgx"></div>
<div style="padding:10px;font-size:14px;line-height:180%;border-top:1px dashed #B5C5D0;">
<strong>��ʾ�����ύ�ɹ���ʱ����ת��Լ��<%=needDays1%>�죬�ڼ䲻��Ӱ����վ���ʡ�</strong><br />
<%if errmsg<>"" then
	check1="disabled" : check2="checked":needpass=0
else
	check1="checked"  :	check2=""
end if%>
<span class="bluefont">��ȷ���Ƿ�ת�ƣ�</span><label><input type="radio" name="q" value="" <%=check1%> >ת�Ʋ�����һ��<font color="red">[ǿ���Ƽ�]</font><%=needprice%>Ԫ/��</label>&nbsp;&nbsp;&nbsp;<label><input type="radio" name="q" value="yes" <%=check2%>>ֱ�����Ѳ�ת��</label> <%=needprice2%>Ԫ/�ꡣ 
<%if needpass=1 then %>
<br /><span class="bluefont">����дת�����룺</span><input size="25" type="text" name="authcode" style="background:#FFE" />
            <span style="font-size:12px;">*�����д��ȷ��ת�����룬����֪�����Ȱ���ʾ��ȡת�����롣</span> 
            <%end if%>
          </div>

<div style="text-align:center;padding:20px 10px;">
<input type="submit" value="��һ��"  />
<input type="hidden" name="act" value="sub" />
</div>
</form>
<%
Else '��������������������������������������������ύ�˵Ĵ�����̡�������������������

	If needpass=1 And myauthcode = "" Then url_return "�����ṩ��ȷ��ת������",-1
	if ccur(session("u_usemoney")) < needPrice  Then url_return "��������,���β�����Ҫ:" & needPrice & "Ԫ",-1

'��ʼ�����ύ  -- +Ԥ���
	ishelp = "disabled"
	cmdinfo="domainname" & vbcrlf &_
		"trans" & vbcrlf &_
		"entityname:renin" & vbcrlf &_
		"domain:" & strDomain & vbcrlf &_
		"ishelp:" & ishelp & vbcrlf &_
		"authcode:" & replace(myauthcode,"'","&quot;") & vbcrlf &_
		"." & vbcrlf
	retCode=connectToUp(cmdinfo)
	retCodestr = replace(retCode,vbcrlf,"")
	if left(retCode,3)<>"200" then url_return "�ύʧ�� " & retCodestr,-1
	
'��ʼ�۷�
	randomize:countid="transinD3-" & left(user_name,3) & Replace(Timer&"",".","")
	if not consume(user_name,needprice,false,countid,"ת�벢����-"&domain,domtype,"") then
		addRec "����ת��","�ۿ�ʧ�ܣ����ֹ��۳�" & user_name & ", ����" & needPrice & "Ԫ, ���� " & domain
	end if

'����ǰ��һ���ȥ
	sql="select years,rexpiredate,tran_state from domainlist where userid=" & user_id & " and d_id=" & domainid
	rs.open sql,conn,1,3
	if not rs.eof then
		rs("years")=rs("years")+1
		rs("rexpiredate")=dateadd("yyyy",1,rs("rexpiredate"))
		rs("tran_state")=11	'�������״̬Ϊ11
		rs.update
	end if
	rs.close
	
%>
    <div class="oksuccess">��ϲ���������Ѿ��ύ�ɹ�����������Լ��<%=needDays1%>�����ң��������ڹ�������--ҵ�����--����ת���б��в鿴������ȣ�ת�Ƴɹ���ϵͳ���ʼ�֪ͨ��<br />�������ת��ʧ�ܣ��򽫰�ԭ�۸�Ϊ�����ѣ��ұ�������ԭע���̲��䡣
    </div>
    <input type="button" value="������������" onClick="location='/manager/domainmanager/'" /><br /><br />
<%
end if
leftdaystr=leftdays : If leftday<=5 Then leftdaystr="<span class='bred'>" & leftdays & "</span>"
%>
</div>
<center>��������(<%If bDomain<>"" Then response.write bDomain Else response.write strDomain%>)����ڻ���<%=leftdaystr%>��</center>
<script language="javascript">
	$("#resultdiv label.x").mouseover(function(){
		$(this).css("color","#333");
	}).mouseout(function(){
		$(this).css("color","");
	}).click(function(){
		$(this).parent().addClass("onchoose").siblings().removeClass('onchoose');
	});
function check1(){
	if (form1.q[0].checked){
		<%if (leftdays<=0) then%>
		alert("��Ǹ�������Ѿ����ڣ���������ǰһ���°���ת�ƣ�лл��");
		return false;
		<%elseif not checkren then%>
		alert("��Ǹ���������Ѻ���Ҫ��60����ܰ���ת�ƣ�����60���Ժ���������лл��");
		return false;
		<%elseif needpass=1 then%>
		if (form1.authcode.value=="") {
			alert("����д����ת�����룬�����֪�����Ȱ�˵����ȡ����ϵ��˾�ͷ�");
			return false;
		}
		<%end if%>
		if (!confirm('���ʵ���Ѿ���ϸ�Ķ���ҳ���ϵ����˵����ȷ�ϼ�����')) return false;
	}
	return true;

}
</script>
</body>
</html>


<%
function getDomReg(byval domain)
	if not isdomain(domain) then exit function
	cmdinfo="domainname" & vbcrlf & _
		"trans" & vbcrlf & _
		"entityname:get_reg" & vbcrlf & _
		"domain:" & domain & vbcrlf & _
		"." & vbcrlf
	retCode=connectToUp(cmdinfo)
	if left(retCode,4)="200 " then
		getDomReg=lcase(left(mid(retCode,5),5))
	end if
end function

function getDomTransState(byval domain)
	cmdinfo="domainname" & vbcrlf & _
		"trans" & vbcrlf & _
		"entityname:get_state" & vbcrlf & _
		"domain:" & domain & vbcrlf & _
		"." & vbcrlf
	retCode=connectToUp(cmdinfo)
	getDomTransState=retCode
end function
%>