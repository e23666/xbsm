<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->

<%
conn.open constr
'��������ҳ������Ƿ����ת�������������ϵ���������
DomainID=requesta("DomainID")
action=requesta("act")
if requesta("q")="yes" then response.Redirect "renewDomain.asp?DomainID=" & DomainID
if not isnumeric(DomainID&"") then url_return "�������ݴ���a",-1


sql="select * from domainlist where userid=" &  session("u_sysid") & " and d_id=" & DomainID
rs.open sql,conn,1,1
if rs.eof and rs.bof then url_return "û���ҵ�������",-1
For i=0 to rs.Fields.Count-1
	Execute( "m_" & rs.Fields(i).Name & "=rs.Fields(" &i& ").value")
Next
rs.close
strDomain=m_strdomain
register=left(m_bizcnorder,5)
up_register = getDomReg(strDomain)

if instr(",11,9,12,",","&m_tran_state&",")>0 then url_return "�����������ת�����ڴ����У�����ԼΪ5-30�죡��ת�ɹ�������",-1
if not checkTrans then response.Redirect "renewDomain.asp?DomainID=" & DomainID



if action="sub" then
	'renin ����ת��  newin �ⲿת��  out  ת��    ,get_reg �õ�ע���� , get_state �õ�ת��״̬
	ishelp = requesta("ishelp")
	u_name = session("user_name")
	proid  = m_proid	'GetDomainType(strDomain)
	needPrice=getNeedPrice(u_name,proid,1,"renew")	
	if ccur(session("u_usemoney"))<needprice then url_return "��Ǹ�����㣬����һ����Ҫ" & needprice & "Ԫ",-1
	if isChinese(strDomain) then strDomain=punycode(strDomain)
	if left(strDomain,4)="xn--" then bstrDomain=Gbkcode(strDomain)
	
	cmdinfo="domainname" & vbcrlf &_
		"trans" & vbcrlf &_
		"entityname:renin" & vbcrlf &_
		"domain:" & strDomain & vbcrlf &_
		"ishelp:" & ishelp & vbcrlf &_
		"." & vbcrlf
	retCode=connectToUp(cmdinfo)
	if left(retCode,3)="200" then
		whoismail=mid(retCode,instr(retCode,",")+1)
		countinfo="����ת��-" & strDomain 
		countid=left("translo-" & UCase(left(u_name,10)) & "-" &Cstr(timer()) ,20)
		if not consume(u_name,needprice,false,countid,countinfo,proid,"") then
			addRec "�������Ѳ�ת����˾����", strDomain & "�ɹ�����ת�룬���û���δ�۳ɹ������ֹ���ʵ"		
		end if
		sql="select * from domainlist where d_id=" & domainid
		rs.open sql,conn,1,3
		rs("tran_state")=11
		if request("isbizcn")<>"" then rs("tran_state")=12
		rs("years")=rs("years")+1
		rs("rexpiredate")=dateadd("yyyy",1,rs("rexpiredate"))
		rs.update
		rs.close
		if request("isbizcn")<>"" then
			resultinfo = "��ϲ���������ύ�ɹ�������ذ�����ҳ����ʾ��ת�����������в�����лл��"
		elseif ishelp<>"" then
			resultinfo = "��ϲ���������Ѿ��ύ�ɹ�����������Լ��5-30�����ң����Ժ����������ת�봦�鿴���ȡ�"
		else
			resultinfo = "��˾����һ���������ڰ�ת�����뷢�͵�����������������" & whoismail & "��������¼�����ȡת����������������������-����ת���б����[ȷ�Ͽ�ʼת��]�������û�н���ȷ�ϣ�����������ת��Ҳ�������ѣ�������1����������δ�յ�ת�����룬����ϵ���Ǵ���"
		end if
	else
		resultinfo = "<font color=red>ת������ʧ�ܣ�ԭ��" & retcode & "������ѡ��ֱ�����ѣ�лл</font>"
	end if
	
end if


sub di_over(str)
	response.Write "<hr>OVER :" & str
	response.end
end sub
	

'����������������������������������������������������������
function checkTrans()
	checkTrans=false
	if register<>"defau" and register<>"" then exit function
	if cdate(m_regdate)>"2011-5-20" then exit function  	'�����05/20��ע�������--����/��Ϊ�϶������ǵ�
	if instr(lcase(api_url),"api.west263.com")=0 then exit function		'������Ӵ���--����
	if datediff("d",m_regdate,date())<=60 then exit function			'��ע��60��--����
	if datediff("d",m_rexpiredate,date)>=-7 then exit function			'����ڲ���7��--����
	if m_proid<>"domcom" and m_proid<>"domnet" then exit function		'�������com/net����--����
	sql="select 1 from countlist where u_id=" & session("u_sysid") & " and c_memo like 'renew domain%' and dateDiff("&PE_DatePart_D&",c_date,date())<60 and u_countid like '" & strDomain & "%'"
	set trs=conn.execute(sql)
	if not trs.eof then exit function
	trs.close														'���������60��ǰ--����
	if up_register="west2" then exit function				'���ע��������west2��������Ϊ����û���ֶα������ͨ���ӿڲ�ѯ
	checkTrans=true
end function

function getDomReg(byval domain)
	cmdinfo="domainname" & vbcrlf & _
		"trans" & vbcrlf & _
		"entityname:get_reg" & vbcrlf & _
		"domain:" & domain & vbcrlf & _
		"." & vbcrlf
	retCode=connectToUp(cmdinfo)
	if left(retCode,4)="200 " then getDomReg=mid(retCode,5)
end function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
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

<%if resultinfo="" then%>

<table WIDTH="99%" BORDER="0" align="center" CELLPADDING="6" CELLSPACING="0" class="border">
<form name="form1" action="/manager/domainmanager/renewDomain_new.asp" method="post">
    <tr >
      <td height="63" class="tdbg"><p style="font-size:12px;font-weight:bold;line-height:180%;">����������ʾ����������������˾ͨ����֤��ǰͨ��������������ע��������ġ�Ϊ�˱��ڹ�����˾ǿ�ҽ�����������ת��ע����Ϊ��˾��ת�Ƴɹ����������Զ�����һ�ꡣ<br>
������˾Ϊ������˽�Ϊ�Ż������̣������谴�������̽�����ϼ������ɽ�����ת�Ƴɹ��� ת�Ƴɹ���������������ø��͵����Ѽ۸�͸���ݵķ���</p></td>
    </tr>
<%if up_register="bizcn" then%>
<tr>
<td>
<div style="padding-top:10px;color:#00F;font-size:14px;font-weight:bold">��������ת�����̣�</div>
����1. ���ز���д<a href="http://www.west263.com/customercenter/doc/�����й�����ת��ע���������.doc" target="_blank">�������й�����ת��ע���������</a>����ӡ����»�ǩ�֣�Ȼ����ɨ��ΪͼƬ��<br />
����2. ɨ�����������ߵ�֤��(����ɨ�����֤����ҵ��ɨ��Ӫҵִ�ջ���֯��������֤)��<br />
����3. ���������������������ߵ����䷢�ʼ�����mzhtang@bizcn.com ���ʼ�����д1309890865@qq.com���ʼ�����д����ȡ��������ת�����룡<br />
����4. �����й��յ���ᷢ�ʼ�����������������ѯ���Ƿ�ͬ��ת�����뼰ʱ�ظ��ʼ���ͬ��ת����<br />
����5. �����й�����1�����������ҷ�ת�����뵽�������������䡣���ת������󣬽���"ת�Ʋ�����һ��"�Ĳ���,Ȼ������������-ҵ�����-����ת���б����"ȷ�Ͽ�ʼת��"������ת������󼴿�������ʼת�ƣ�ת�Ƴɹ�����Զ�����һ�ꡣ <br />
<br />

<font color="red">�ر���ʾ���������ϵ�����й�(www.bizcn.com)�ɹ����ת��������ٽ���"<b>ת�Ʋ�����һ��</b>"�Ĳ���</font>��<br />
��������й���������Ϸ���ת�����룬��绰��ϵ�����й���0592-2577888 ת2308 ��С��<br />
���߰� <a href="http://www.im286.com/thread-6549097-1-1.html" target="_blank">http://www.im286.com/thread-6549097-1-1.html</a> �����̶������й�����Ͷ�ߡ�<br /><input type="hidden" name="isbizcn" value="yes">
</td>
</tr>
<%else%>
    <tr >
      <td class="tdbg">����<label style="width:70%"><input value="" <%=que1%> type="radio" name="ishelp">        ����һ�������������������ʼ�ȷ�ϣ���˾����һ���������ڰ�ת�����뷢�͵����������������䡣������¼�����ȡת����������������������-ҵ�����-����ת���б����"ȷ�Ͽ�ʼת��"������ת������󼴿�������ʼת�ƣ�ת�Ƴɹ�����Զ�����һ�ꡣ</label></td>
    </tr>
    <tr >
      <td class="tdbg">����<label style="width:70%"><input value="yes" <%=que2%> type="radio" name="ishelp">
�������������������������޷������ʼ���������Ȩ��˾ȫ�̲�����ϵͳ����ʱ�޸������������������䣬ת�Ƴɹ�����Զ���ԭΪ��Ŀǰ�����䡣(�������ת��ʧ�ܣ��򽫰�ԭ�۸�Ϊ�����ѣ��ұ�������ԭע���̲���)</label></td>
    </tr>
<%end if%>
    <tr >
      <td class="tdbg" style="border-top:1px dashed #4AC5FF">������ȷ���Ƿ�ת�ƣ�
          <label>
            <input value="" checked type="radio" name="q">
            ת�Ʋ�����һ��(ǿ���Ƽ�)</label>
          <label>
            <input value="yes" type="radio" name="q">
            ֱ�����Ѳ�ת��</label>
       </td>
    </tr>
    <tr >
      <td align="center" class="tdbg"><input type="submit" value="��һ��"><input type="hidden" name="act" value="sub"><input type="hidden" name="DomainID" value="<%=DomainID%>"></td>
    </tr>
  </form>
</table>

<%else%>

<center><div style="margin:20px auto;width:500px;border:1px dashed red;padding:20px;color:green;font-weight:bold;">	<%=resultinfo%> <br>
<input type="button" value=" ���� " onClick="history.back()"></center>

<%end if%>

<!--#include virtual="/config/bottom_superadmin.asp" -->
</body>