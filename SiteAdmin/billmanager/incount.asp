<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%Check_Is_Master(3)%>
<script>

function check()
{

	if(formincount.sid4.options[formincount.sid4.selectedIndex].value=="���Ž���x" || formincount.sid4.options[formincount.sid4.selectedIndex].value=="�������x"|| formincount.sid4.options[formincount.sid4.selectedIndex].value=="����֧��x")
	{
		if (PatternMatch(formincount.sid)){
			if (formincount.sid.value=='no-000'){
				alert('��������');
				formincount.sid.focus();
				return false;
			}
			return true;
			}
		else
			return false;
	}


	//PatternMatch(formincount.sid)
}


function PatternMatch(Str){
	var reg=/^no-\d+/;
	if (reg.exec(Str.value)==null){
		alert("ģʽ������ȷΪ:no-XXX(����XXXΪ����)");
		Str.value='no-000';
		Str.focus();
		Str.select();
		return false;
		}
	return true;
}
/*
if (formincount.sid.value.indexOf("��")!=-1)
{
	if (!PatternMatch(formincount.sid))
		{
			return false;
		}
}
*/
</script>
<%
'on error resume next
Ident=Ucase(left(Session("user_name"),3)) & "-"

substrings="<input type=submit name=Submit1 value=ȷ�� onClick=""javascript:document.formincount.module.value='incount';"">"
module=Requesta("module")
if module="PayEnd" then
	c_date=Requesta("PayTime")
	If Not isdate(c_date&"") Then c_date=now()
else
	c_date=now()
end if
ssmsg=""
conn.open constr
If module="incount" Then
		isAgent=Requesta("isAgent")
 		u_countid_2=Requesta("sid")
		u_name=Requesta("sid2")

'---------��ֹͬʱ����һ�ʶ�����
'response.Write "oldapplication="&Application("incount")
 if instr(Application("incount"),u_name)<>0 then
		mytemp=split(Application("incount"),":")
		
		if session("user_name")<>mytemp(1) then
		response.Write("<script>alert(""����ͬ��"&mytemp(1)&"���ڶԸ��û�������ʱ�����Ը��û�����������"");history.back();</script>")
		end if
end if

Application("incount")=Requesta("sid2")&":"&session("user_name")


'---------��ֹͬʱ����һ�ʶ�����

		u_countid=Ident & u_countid_2
		u_in=Requesta("sid3")

		u_out=0
		c_date=Requesta("sid5")
		If Not isdate(c_date&"") Then c_date=now()
		c_memo=Requesta("sid4")
		If u_out="" Then u_out=0
		If u_in="" Then u_in=0
		Sql="Select countlist.sysid,countlist.c_dateinput from countlist,userdetail where countlist.u_in=" & u_in & " and countlist.u_id=userdetail.u_id and userdetail.u_name='" & u_name & "' order by countlist.c_dateinput desc"
'		Response.write Sql
  		Rs.open Sql,conn,1,1
			
			
		if not Rs.eof then
		
			Msg2="����!���û�[" & formatDateTime(Rs("c_dateinput"),2) & "]���Ѿ���һ����ͬ�������ʣ������Ƿ��ظ�����<br>"
		end if
		Rs.close
'---------���

		Sql="Select * from ourmoney where PayMethod='" & Requesta("sid4") &"' and Amount=" & u_in & " and datediff("&PE_DatePart_D&",PayDate,'" & Requesta("sid5") & "')=0"
		Rs.open Sql,conn,1,1

		if not Rs.eof then
			AlertMessage="<font color=red><b>����!</b>" & Requesta("sid4") & "��" & u_in & "Ԫ��"&Requesta("sid5")&"�Ѿ����"&rs.RecordCount&"�Σ������"&rs.RecordCount+1&"��"& u_in&"Ԫ���ʣ��ټ������!"
		end if
		Rs.close
'-------------�������

		Sql="Select u_checkmoney,u_contract,u_telphone,u_address,u_memo,u_levelName,u_level,f_id,u_regdate from userdetail where u_name='" & u_name & "'"
		Rs.open Sql,conn,1,1
		if Rs.eof then 
			Msg2="����!δ�ҵ����û�"
		else
		''''''''''''''''''''''''''''''''''
			if trim(c_memo)="���Ž���" and rs("f_id")>0 then
				'if rs("f_id")>0 then url_return "���û�Ϊvcp�û�,��������á����Ž��ѡ����ַ�ʽ",-1
				if isdate(rs("u_regdate")) then
					if datediff("d",rs("u_regdate"),"2007-11-20")=<0 then
						url_return "��ע���VCP���û�,��������á����Ž��ѡ����ַ�ʽ�������ڸ߼�����>����VCP �����������",-1
					end if
				end if
			end if
		''''''''''''''''''''''''''''''''''
			if Ccur(Rs("u_checkmoney"))>0 then Msg2=Msg2 & "����!���û�����" & Rs("u_checkmoney") & "Ԫδ��˵Ľ����Ƿ���Ƿ��"
			agentLevel=Rs("u_level")
			if Rs("u_level")>1 then
				innerRed="<font color=red>"
				innerRed2="</font>"
			else
				innerRed="":innerRed2=""
			end if
			Mes3="��ϵ��:" & Rs("u_contract") & "<br>�绰:" & Rs("u_telphone") & "<br>��ַ:" & Rs("u_address") & "<br>����:"& innerRed & rs("u_levelName")  & innerRed2
			userinfo=Rs("u_memo")
		end if
		Rs.close
		
		
		'------------------------------------------
		'Modify By Edward.Yang on 2006-3-1
		
		sql="SELECT countlist.u_moneysum, countlist.u_in, countlist.u_out, countlist.sysid, countlist.c_date FROM (countlist INNER JOIN UserDetail ON countlist.u_id = UserDetail.u_id) WHERE UserDetail.u_name = '"&u_name&"' AND countlist.c_check ="&PE_True&" AND countlist.c_memo = '���' ORDER BY countlist.c_dateinput DESC"
		
		Rs.open sql,conn,1,1
		
		if not Rs.eof then
			do while not Rs.eof
				Msg4_edward=Msg4_edward & "<input type='checkbox' name='q_money_sysid' value='"&Rs(3)&"' checked>&nbsp;���û���<font color=ff0000><strong>["& Rs(4) &"]</strong></font>��<font color=ff0000><strong>"&Rs(0)&"</strong></font>ԪǷ��δ��<input type='hidden' name='"&Rs(3)&"' value='"&Rs(0)&"'><br>"
			Rs.movenext
			loop
		end if
		
		Rs.close
		'------------------------------------------
		
		
		substrings="<input type=submit name=Submit1 value=�������ȷ�� onClick=""javascript:document.formincount.module.value='check';"">"
ElseIf module="check" Then


	isAgent=Requesta("isAgent")
	substrings="<input type=submit name=Submit1 value=�ٴ�ȷ�� onClick=""javascript:document.formincount.module.value='check';"">"
	u_countid_2=Requesta("sid")
	u_countid=Ident & u_countid_2
	u_in=Requesta("sid3")
	u_name=Requesta("sid2")
	u_out=Requesta("u_out")
	c_date=Requesta("sid5")
	If Not isdate(c_date&"") Then c_date=now()
	c_memo=Requesta("sid4")
		
		if not isdate(c_date) then
			response.Write("<script>alert(""���ڸ�ʽ����"");history.back();</script>")
			response.End()
		end if

		'------------------------------------------
		'Modify By Edward.Yang on 2006-3-1
		if c_memo<>"���" then
			sq_money_sysid=Requesta("q_money_sysid")
			'response.Write(sq_money_sysid)
			'response.End()
			if sq_money_sysid<>"" then
			
			CheckedUnPay=0
			
				sq_money_sysid=replace(sq_money_sysid," ","")
				
				if instr(sq_money_sysid,",")>0 then
					SysId_array=split(sq_money_sysid,",")
					for i=0 to ubound(SysId_array)
						CheckedUnPay=CheckedUnPay+Ccur(Requesta(SysId_array(i)))
					next
				else
					CheckedUnPay=Ccur(Requesta(sq_money_sysid))
				end if
				if CCur(u_in)<CheckedUnPay then
					response.Write("<script>alert(""���������������ѡδ���"");history.back()</script>")
					response.End()
				end if
			end if
		end if
		
		'response.Write(u_in & "----" &CheckedUnPay)
		'------------------------------------------



	If u_out="" Then u_out=0
	If u_in="" Then u_in=0
	
	sql="select u_countid from countlist where u_countid = '"&u_countid&"'"
	rs.open sql,conn,1,3
	if not rs.eof then
		rs.close
		url_return "ƾ֤����ظ�",-1
	end if
	rs.close
	
	if not isdate(c_date) then
		url_return "���ڸ�ʽ����",-1
	end if
	
	sql="select u_id from userdetail where u_name = '"&u_name&"'"
	rs.open sql,conn,1,3
	if rs.eof then
		rs.close
		url_return "�����û�ʧ��",-1
	else
		u_id=rs("u_id")
	end if
	rs.close
	
	'�ӿʼ
	sql="update Userdetail set u_usemoney = u_usemoney + "&u_in&" - "&u_out&" , u_checkmoney = u_checkmoney  + "&u_in&" - "&u_out&"  where u_name = '"&u_name&"'"
	conn.execute(sql)
	u_Balance=conn.execute("select u_usemoney from Userdetail  where u_name = '"&u_name&"'")(0)
	
	Sql="insert into countlist (u_id,u_moneysum,u_in,u_out, u_countid , c_memo ,c_date ,c_dateinput,c_type,o_id,p_proid,u_Balance) values (" & u_id & "," & u_in-u_out & "," & u_in & "," & u_out & ",'" & u_countid & "' , '" & c_memo & "','" & c_date & "',"&PE_Now&" ,8,null,'',"&u_Balance&")"
	conn.execute(sql)



	'�ӿ����

	'-----���������֧���������û�����֧�����е���ؼ�¼����Ϊ�Ѵ���
		'if c_memo="����֧��" or c_memo="����֧��" or c_memo="֧����֧��" or c_memo="�Ƹ�֧ͨ��" or c_memo="��Ǯ֧��" then
			sql="update ring set ring_ov=1 where ring_us='" & u_name & "' and ring_ov=0"
			conn.Execute(Sql)
		'end if

		ssmsg =  "���ɹ�"
		substrings="<input type=submit name=Submit1 value=ȷ�� onClick=""javascript:document.formincount.module.value='';"">"
		Sql="Select u_email,u_contract from userdetail where u_name='" & u_name & "'"
		Rs.open Sql,conn,1,1
		if not Rs.eof then
			
			getStr="user_name="&u_name&","& _
					"dateTime="&formatDateTime(c_date,1)&","& _
					"paytype="&c_memo&","& _
					"incount="&u_in
			
			mailbody=redMailTemplate("payConfirm.txt",getStr)
			call sendMail(Rs("u_email"),"���Ļ�����յ�!",mailbody)
			ssmsg = ssmsg & ",���ѷ����ʼ�֪ͨ"
		end if
		Rs.close
		

		Application("incount")="over"

		'------------------------
		'Edward 2006-6-1
		'д����ˮ��
		if c_memo<>"���" then
			if A_name="" then 
				A_name=Requesta("sid2")
			end if
			Sql="Insert into OurMoney([Name],[UserName],[Paymethod],[Amount],[PayDate],[Orders],[Memo],ismove) values('" & A_name &"','" & Requesta("sid2") &"','" & Requesta("sid4") & "'," & Requesta("sid3") & ",'" & Requesta("sid5") & "','" & Requesta("Orders") & "','" & Requesta("sid4") &"',"&Requesta("ismove")&")"
			conn.Execute(Sql)
		  if isNumeric(Requesta("PayendID")) and Requesta("PayendID")<>"" then
				Sql="Update PayEnd Set P_state=1 Where id=" & Requesta("PayendID")
				conn.Execute(Sql)
		  end if
		end if

		'------------------------------------------
		'Modify By Edward.Yang on 2006-3-1
		if c_memo<>"���" then
			sq_money_sysid=Requesta("q_money_sysid")
			'response.Write(sq_money_sysid)
			'response.End()
			if sq_money_sysid<>"" then
			
			'Response.Write(u_name)
			'response.End()
			sql="SELECT u_id FROM UserDetail where u_name='"&u_name&"'"
			Rs.open sql,conn,1,1
			if not Rs.eof then
				edward_u_id=Rs(0)
					
				CheckedUnPay=0
				
					sq_money_sysid=replace(sq_money_sysid," ","")
					
					if sq_money_sysid<>"" then
						SysId_array=split(sq_money_sysid,",")
						for i=0 to ubound(SysId_array)
							CheckedUnPay=Requesta(SysId_array(i))
							'���±��û���
					
							conn.execute("update userdetail set u_usemoney=u_usemoney-" & CheckedUnpay & ",u_checkmoney=u_checkmoney-" & CheckedUnPay & " where u_id=" & edward_u_id)
							
							'����һ�������¼
							DateRadom=GetDateRadom()
							sql="INSERT INTO countlist (u_id, u_moneysum, u_in, u_out, u_countId, c_memo, c_check, c_date, c_dateinput, c_datecheck, c_type, o_id, p_proid, c_note) VALUES ("&edward_u_id&","&CheckedUnPay&",0,"&CheckedUnPay&",'"&DateRadom&"','֧��Ƿ��',0,'"&now()&"','"&now()&"','"&now()&"',1,4735,'FR001',0)"
							conn.execute(sql)
							
							'������¼��Ϊ�����
							sql="UPDATE countlist SET c_check =0 WHERE sysid="&SysId_array(i)&""
							conn.execute(sql)
						next
					end if
				'	response.End()
				else
					Rs.close
					url_return "δ�ҵ��û���Ϣ",-1
					'response.Write("δ�ҵ��û���Ϣ")
					'response.End()
				end if
			end if
		
		'response.Write(u_in & "----" &CheckedUnPay)
		'------------------------------------------
		
	End If
		u_name=""
		u_countid=""
		u_in=""
		u_out=""
		c_date=now()
		c_memo=""
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong> ����ȷ��</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="/SiteAdmin/billmanager/incount.asp" target="main">�û����</a>| <a href="InActressCount.asp" target="main">�Ż����</a><a href="outcount.asp"></a> | <a href="returncount.asp" target="main">�����뻧</a><a href="returncount.asp"></a> | <a href="comsume.asp" target="main">�ֹ��ۿ�</a><a href="comsume.asp"></a> | <a href="outOurMoney.asp" target="main">��¼��֧</a><a href="checkcount.asp"></a> | <a href="ViewOurMoney.asp" target="main">�鿴��ˮ��</a><a href="checkmoney.asp"></a> | <a href="InActressCount.asp">�Ż����</a> | <a href="OurMoney.asp">����ˮ��</a></td>
  </tr>
</table>
      <br />
<div align="left">
  <table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td valign="top"> 
        <table width="100%" cellPadding="0" cellSpacing="0"   borderColor="#FFFFFF" id="AutoNumber3" style="border-collapse: collapse">
          <tr> 
            <td valign="top" align="center"> <%
						Response.Write ssmsg
						%> 
              <form action="incount.asp" method=post name=formincount onSubmit="return check()">
                <table width=100% border=0 align=center cellpadding=3 cellspacing=0 bordercolordark=#FFFFFF class="border">
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg"> 
                      <input name=module type=hidden value=incount>
                      <input name=name type=hidden value=<%=requesta("name")%>>
                      <input name=Orders type=hidden value=<%=requesta("Orders")%>>
                      <input name=PayendID type=hidden value=<%=requesta("PayendID")%>>
                      ��ƾ֤��ţ�</td>
                    <td width="504" class="tdbg"> 
                      <%
randomize timer
 





if Requesta("module")="" then
  u_name=Requesta("UserName")
'  u_countid_2=left(u_name,4) & "-" & month(date())&"."&day(date())&"-"&regjm
    u_countid_2=left(u_name,4)&"-"&getDateTimeNumber()
	
  u_in=Requesta("Amount")
  c_memo=Requesta("Paymethod")
elseif Requesta("module")="PayEnd" then
  u_name=Requesta("UserName")
 'y u_countid_2=left(u_name,4) & "-" & month(date())&"."&day(date())&"-"&regjm
  u_countid_2=left(u_name,4) & "-" &getDateTimeNumber()
  u_in=Requesta("money")
  c_memo=Requesta("hktype")
end if
 
%>
                      <%=Ident%> 
                      <input name=sid size="20" value="<%=u_countid_2%>" maxlength="17" >
                      ��(�ܳ�������20λ,�������)</td>
                  </tr>
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg">���� ����</td>
                    <td width="504" class="tdbg"> 
                      <input name=sid2 size="20"  value="<%=u_name%>">
                      ��<font color="#CC0000"><b></b></font><font size="2"></font></td>
                  </tr>
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg">���� �</td>
                    <td width="504" class="tdbg"> 
                      <input name=sid3 size="20"  value="<%=u_in%>">
                      Ԫ��<font color="#CC0000"><b><font color="#FF0000"><%="<br>" & Msg2%></font></b></font></td>
                  </tr>
                  <%
				  	if Msg4_edward<>"" then
				  %>
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg">���Զ�����</td>
                    <td width="504" class="tdbg"><%=Msg4_edward%></td>
                  </tr>
                  <%
				  	end if
				  %>
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg">�������ͣ�</td>
                    <td width="504" class="tdbg"> 
                      <select name="sid4" id="sid4">
          		                <option value="��������"<%if c_memo="��������" then%> selected<%end if%>>��������</option>
			            <option value="�Ƹ�֧ͨ��"<%if c_memo="�Ƹ�֧ͨ��" then%> selected<%end if%>>�Ƹ�֧ͨ��</option>
                        <option value="����֧��"<%if c_memo="����֧��" then%> selected<%end if%>>����֧��</option>    
                        <option value="��ͨ����"<%if c_memo="��ͨ����" then%> selected<%end if%>>��ͨ����</option>
                        <option value="��������"<%if c_memo="��������" then%> selected<%end if%>>��������</option>
                        <option value="��������"<%if c_memo="��������" then%> selected<%end if%>>��������</option>
                        <option value="ũҵ����"<%if c_memo="ũҵ����" then%> selected<%end if%>>ũҵ����</option>
                        <option value="����֧��"<%if c_memo="����֧��" then%> selected<%end if%>>����֧��</option>
                        <option value="Ĭ������֧��"<%if c_memo="Ĭ������֧��" then%> selected<%end if%>>Ĭ������֧��</option>
                        <option value="��˾ת��"<%if c_memo="��˾ת��" then%> selected<%end if%>>��˾ת��</option>
                        <option value="���Ž���"<%if c_memo="���Ž���" then%> selected<%end if%>>���Ž���</option>
                        <option value="֧����֧��"<%if c_memo="֧����֧��" then%> selected<%end if%>>֧����֧��</option>
                        <option value="�������ʻ��"<%if c_memo="�������ʻ��" then%> selected<%end if%>>�������ʻ��</option>
                        <option value="��˾ת��2"<%if c_memo="��˾ת��2" then%> selected<%end if%>>��˾ת��2</option>
                        <option value="�������ۻ��"<%if c_memo="�������ۻ��" then%> selected<%end if%>>�������ۻ��</option>
                        <option value="���"<%if c_memo="���" then%> selected<%end if%>>���</option>
                        <option value="ũҵ����2"<%if c_memo="ũҵ����2" then%> selected<%end if%>>ũҵ����2</option>
                        <option value="��Ǯ֧��"<%if c_memo="��Ǯ֧��" then%> selected<%end if%>>��Ǯ֧��</option>
                        <option value="�������"<%if c_memo="�������" then%> selected<%end if%>>�������</option>
                      </select> *���û�������֧����,�벻Ҫѡ����ĳ����
					</td>
                  </tr>
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg"><font color="#FF0000">ʵ�ʵ�������:</font></td>
                    <td width="504" class="tdbg"> 
                      <input name=sid5 size="20"  value="<%=c_date%>">
                      (yyyy-mm-dd)��</td>
                  </tr>
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg">����˾���:</td>
                    <td width="504" class="tdbg"> 
                      <input type="checkbox" name="isAgent" value="OHYES" <%if isAgent<>"" or (agentLevel>1 and inStr(c_memo,"��˾")>0) then Response.write " checked"%>>
                      ������û��Ǵ����̲���ͨ����˾�������ѡ��</td>
                  </tr>
                  <tr bordercolordark="#ffffff"> 
                    <td width="102" height="19" bgcolor="#D2EAFB" class="tdbg">�Ƿ����ڲ�ת��</td>
                    <td width="504" height="19" class="tdbg"> 
                      <%
if requesta("ismove")<>"" then
ismove=requesta("ismove")
else
ismove=0
end if

%>
                      <input type="radio" name="ismove" value="0" <%if ismove=0 then response.write "checked"%>>
                      �� 
                      <input type="radio" name="ismove" value="1" <%if ismove=1 then response.write "checked"%>>
                      �� (������񽫹�˾���ֽ�浽��˾�ʺţ���ѡ���ǡ���)</td>
                  </tr>
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg">�û���Ϣ��</td>
                    <td width="504" class="tdbg"><%=Mes3%> &nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg">�û���ע��</td>
                    <td width="504" class="tdbg"><%=userinfo%>&nbsp;<%=AlertMessage%></td>
                  </tr>
                  <tr> 
                    <td colspan=2 align=center class="tdbg"> <%=substrings%> </td>
                  </tr>
                  <tr> 
                    <td colspan=2 align=center class="tdbg"> 
                      <div align="left">����˵����<br>
                        ���: �û����󣬽���ӵ���Ա�ʺ��ϡ��û����ý�����ӡ�<font color="#FF0000">�����ã�</font><br>
                        �ۿ�û������˿����ӻ�Ա�ʺ��п۳����û����ý����١�<br>
                        �����뻧���û�����ҵ��ʧ�ܣ����Ѿ��ۿͨ��������ܽ������˻ء��û����ý�����ӣ��ܽ��䡣<br>
                        ���ѿۿ�û������ƹ�Ȳ�Ʒ����Ҫ�ֹ��ۿ�ģ��û����ý����١�<br>
                        �Ż����û������Ʒ����ģ���Ҫ�������ŻݵĿ�ӵ��û��ʺ��ϣ��ᵼ�¿��ý�����ӣ��ܽ��䡣<br>
                        ������ʱ���������ѡ��Ϊ�������ɣ��������������һ�㲻��<br>
                        ��������ʱ��ϵͳ������ָ��û��н��δ�������Զ����������������Զ������ĸ�ѡ���ϴ򹴣�������Զ�����˻����Ĺ��̡�<br>
                        <font color="#FF0000">ʵ�ʵ�������:</font>��������280Ԫ�û���28�Ż�ģ�����30�Ų���ȷ�ϣ�����Ҫ��28�š�ƾ֤��Ŵ������ڲ��ܸ��ˣ����ԭ���Ĵ���취��һ������ע�⡣<br>
                        �Ƿ����ڲ�ת��:ƽʱ��ѡ��ΪĬ�ϵġ��񡱣��������ڲ�������ʱʹ�á�</div>                    </td>
                  </tr>
                </table>
              </form>
            </td>
          </tr>
        </table>
        <!--  BODY END -->
        <p><br>
        </p>
        </td>
    </tr>
  </table>
  
</div>

<%
function GetCountID(strDomain)
	Randomize
	GetCountID=strDomain & "-" & Right(Cstr(Rnd()*999999),6)
end function
function GetDateRadom()
	TimeStr=now()
	TimeStr=replace(TimeStr," ","")
	TimeStr=replace(TimeStr,":","")
	TimeStr=replace(TimeStr,"-","")
	regma=int(rnd*899+100)
	GetDateRadom=TimeStr&regma
end function
%><!--#include virtual="/config/bottom_superadmin.asp" -->
