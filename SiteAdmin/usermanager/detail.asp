<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/md5_16.asp" -->

<%
response.Charset="gb2312" 
Check_Is_Master(1)%>
<%
u_id=requesta("u_id")
if requesta("act")="isauth" then
	t=requesta("t")
	if instr(",0,1,",","&t&",")=0 then die echojson("500","��������1","")
	if not isnumeric(u_id&"") then die echojson("500","��������2","")
	conn.open constr
	conn.execute("update userdetail set isauthmobile="&t&" where u_id="&u_id)
	die echojson("200","�����ɹ�!","")

end if

'on error resume next
		
if requestf("myact")="chgpass" and requestf("submit2")="�޸Ļ�Ա����" then
		u_password=trim(requesta("u_password"))
		u_telphone=requesta("u_telphone")
		u_company=requesta("u_company")
		u_email=requesta("u_email")
		msn_msg=requesta("msn_msg")
		u_Auditing=trim(requesta("Auditing"))
		u_passwordst=""
		''''''''''''

u_namecn=requesta("u_namecn")
u_nameen=requesta("u_nameen")
u_contract=requesta("u_contract")
u_trade=requesta("u_trade")
u_fax=requesta("u_fax")
u_know_from=requesta("u_know_from")
u_contry=requesta("u_contry")
u_province=requesta("u_province")
u_city=requesta("u_city")
u_zipcode=requesta("u_zipcode")
u_address=requesta("u_address")
qq_msg=requesta("qq_msg")
u_class=requesta("u_class")
if u_class<>"�����û�" then u_class="��˾�û�"
	'''''''''''''''''''''''''''''''''''	
	u_question=trim(requestf("question"))
	myquestion=trim(requestf("myquestion"))
	u_answer=trim(requestf("answer"))
	if u_question="�ҵ��Զ�������" then u_question=myquestion
	if u_question="" then u_answer=""
	if u_answer="" then u_question="":myquestion=""
	'''''''''''''''''''''''''''''''''''
	ipfilter=Trim(Requesta("ipfilter"))
	allowIP=Trim(Requesta("allowIP"))
	if allowIP="" Then ipfilter=""
	if ipfilter<>"" then
		ipfilter=1
	else
		ipfilter=0
	end if
	''''''''''''''''''''''''''''''''''	
		conn.open constr
		u_ids=requesta("u_ids")
		if u_password<>"" then
		       user_name=conn.execute("select u_name from userdetail where u_id="&u_ids)(0)
		    if isBad(user_name,u_password,errinfo) then 
				   die url_return(replace(replace(errinfo,"ftp�û���","��Ա�ʺ�"),"�û���","�û���"),-1)
			end if	
			u_password=md5_16(u_password)
			u_passwordstr="u_password='"& u_password &"',"
		end if
		
		sql2="select u_type from userdetail where u_id="&u_ids
	
		set rstemp=conn.execute(sql2)
		
		if rstemp(0)=0 or isnull(rstemp(0)) or session("u_type")="111111" then
			dim renauthmobile
			renauthmobile=""			
			if isrenauthmobile(u_ids,msn_msg) then
				renauthmobile=",isauthmobile=0"
			end if
		
			sql="update userdetail set "&u_passwordstr&"u_telphone='"&u_telphone&"',u_company='"& u_company &"',u_email='"& u_email &"',msn_msg='"& msn_msg &"',u_Auditing="& u_Auditing &",u_question='"& u_question &"',u_answer='"& u_answer &"',ipfilter="& ipfilter &",allowIP='"& allowIP &"',u_namecn='"&u_namecn&"',u_nameen='"& u_nameen &"',u_contract='"& u_contract &"',u_trade='"& u_trade &"',u_fax='"& u_fax &"',u_know_from='"& u_know_from &"',u_contry='"& u_contry &"',u_province='"& u_province &"',u_city='"& u_city &"',u_zipcode='"& u_zipcode &"',u_address='"& u_address &"',u_class='" & u_class & "'"&renauthmobile&" where u_id="&u_ids
			'die sql
			conn.execute(Sql)
			sql="select * from userdetail where u_id="& u_ids
			rs.open sql,conn,1,3
			if not rs.eof then
				rs("qq_msg")=qq_msg
				rs.update
			end if
			rs.close
		url_return 	"�����޸ĳɹ���" , -1

		else
		url_return 	"��Ǹ�������޸Ĺ���Ա�����ϣ�" , -1

		end if
		set rstemp=noting
		conn.close
		
end if

If Requesta("u_id")<>"" Then
		sqlstring="select * from UserDetail where u_id="&Requesta("u_id")&""
		session("sqlcmd_VU")=sqlstring
	End If
	u_id=Requesta("u_id")
	conn.open constr
	if Requesta("submit")="���͵����ʼ�" then
		if Requesta("subject")<>"" and Requesta("content")<>"" then
			sendmail Requesta("Email"),Requesta("subject"),Requesta("content")
			url_return "�ʼ����ͳɹ�",-1
		end if
	end if
	if Requesta("Act")="CHG" and isNumeric(Requesta("Invoice")) then
		set_Invoice=Requesta("Invoice")
		Invoice=Ccur(Requesta("u_usemoney"))+Ccur(Requesta("u_resumesum"))-ccur(set_Invoice)
		Sql="Update Userdetail set u_Invoice=" & Invoice & " where u_id=" & u_id
		conn.execute(Sql)
	end if

	if Requesta("Act")="LOCK" then
		Sql="Update Userdetail set u_freeze=" & Requesta("LockStatus") & " where u_id=" & u_id
		conn.Execute(Sql)
	end if
	if Requesta("MEMO")<>"" and Requesta("userinfo")<>"" then
		Sql="Update userdetail set u_memo='" & Requesta("userinfo") & "' where u_id=" & u_id
		conn.Execute(Sql)
	end if
	if Requesta("Act")="ADJUST" then			
		Check_Is_Master(1)
		u_remcount=Requesta("u_remcount")
		u_remcount_S=Requesta("u_remcount_S")
		u_usemoney=Requesta("u_usemoney")
		u_usemoney_S=Requesta("u_usemoney_S")
		u_checkmoney=Requesta("u_checkmoney")
		u_checkmoney_S=Requesta("u_checkmoney_S")
		u_resumesum=Requesta("u_resumesum")
		u_resumesum_S=Requesta("u_resumesum_S")
		u_premoney_S=requesta("u_premoney_S")
		u_premoney=requesta("u_premoney")
		u_out=0
		u_in=0
		yebd=false
		'response.Write u_remcount &","& u_usemoney & "," & u_checkmoney & "," & u_resumesum & "," & u_premoney & "," & u_id
		
		if isNumeric(u_remcount) and isNumeric(u_usemoney) and isNumeric(u_checkmoney) and isNumeric(u_resumesum) and isNumeric(u_premoney) and isNumeric(u_id) then
			Sql="Select u_remcount,u_usemoney,u_checkmoney,u_resumesum,u_premoney from userdetail where u_id=" & u_id
			Set MyRs=conn.Execute(Sql) 
			oldu_usemoney=Myrs("u_usemoney")
            
		

			if u_remcount_S<>"=" then 
				if u_remcount_S="+" then u_remcount=Ccur(Myrs("u_remcount")) + u_remcount
				if u_remcount_S="-" then u_remcount=Ccur(Myrs("u_remcount")) - u_remcount
			end if
			if u_usemoney_S<>"=" then 
				if u_usemoney_S="+" then
				u_in=u_usemoney
				u_usemoney=Ccur(Myrs("u_usemoney")) + u_usemoney
				
				u_Balance=oldu_usemoney+ u_in
				yebd=true
				end if
				if u_usemoney_S="-" then
				u_out=u_usemoney
				u_usemoney=Ccur(Myrs("u_usemoney")) - u_usemoney
				
				u_Balance=oldu_usemoney- u_out
				yebd=true
				end if
			else
			'
				if cdbl(oldu_usemoney)<>cdbl(u_usemoney) then
				   if cdbl(oldu_usemoney)<cdbl(u_usemoney) then
				   u_in=cdbl(u_usemoney)-cdbl(oldu_usemoney)
				   u_Balance=oldu_usemoney+u_in
				   else
					u_out=cdbl(oldu_usemoney)-cdbl(u_usemoney)
					u_Balance=oldu_usemoney-u_out
				   end if
				   yebd=true
				end if
			end if
			if u_checkmoney_S<>"=" then 
				if u_checkmoney_S="+" then u_checkmoney=Ccur(Myrs("u_checkmoney")) + u_checkmoney
				if u_checkmoney_S="-" then u_checkmoney=Ccur(Myrs("u_checkmoney")) - u_checkmoney
			end if

			if u_resumesum_S<>"=" then 
				if u_resumesum_S="+" then u_resumesum=Ccur(Myrs("u_resumesum")) + u_resumesum
				if u_resumesum_S="-" then u_resumesum=Ccur(Myrs("u_resumesum")) - u_resumesum
			end if
			if u_premoney_S<>"=" then
				if u_premoney_S="+" then u_premoney=Ccur(Myrs("u_premoney")) + u_premoney
				if u_premoney_S="-" then u_premoney=Ccur(Myrs("u_premoney")) - u_premoney
			end if

			MyRs.close
			Set MyRs=nothing

			'die u_in&"|"&u_out&"|"
	
			Sql="Update userdetail set u_remcount=" & u_remcount & ",u_usemoney=" & u_usemoney & ",u_checkmoney=" & u_checkmoney & ",u_resumesum=" & u_resumesum & ",u_premoney="& u_premoney &" where u_id=" & u_id
			
			conn.Execute(Sql)

			if yebd then
			u_countid="sysu_"&getDateTimeNumber()
			c_date=formatdatetime(now(),2)
			c_memo="����Ա����("&session("u_sysid")&")"
				Sql="insert into countlist (u_id,u_moneysum,u_in,u_out, u_countid , c_memo ,c_date ,c_dateinput,c_type,o_id,p_proid,u_Balance,c_check) values (" & u_id & "," & u_in+u_out & "," & u_in & "," & u_out & ",'" & u_countid & "' , '" & c_memo & "', '" & c_date & "',"&PE_Now&" ,8,null,'',"&u_Balance&",0)"
				conn.execute(sql)
			end if
			'Response.write Sql
		end if
	end if
	
	
	rs.open session("sqlcmd_VU") ,conn,3
if rs("u_ip")<>"" then
u_ips=split(trim(rs("u_ip")),",")
if instr(u_ips(0)&"","|")<>0 then
	 ip_time =split(u_ips(0),"|")
	 if ubound(ip_time)>0 then 
		logip=ip_time(0)
		logtime=ip_time(1)
	end if
else
logip=u_ips(0)
end if
else
logip=""
end if
function isselfquestion(qu)
	if len(qu)="" then isselfquestion=false:exit function
	dim getstrs
	dim stray(10)
	stray(0)="�ҾͶ��ĵ�һ��ѧУ�����ƣ�"
	stray(1)="��ʲô?�Ҹ��׵�ְҵ��"
	stray(2)="�ҵĳ������ǣ�"
	stray(3)="��ĸ�׵�ְҵ��"
	stray(4)="�ҳ��а����ε������ǣ�"
	stray(5)="������˵����֣�"
	stray(6)="�Ұְֵ����գ�"
	stray(7)="����������գ�"
	stray(8)="�Ҹ��׵�������"
	stray(9)="��ĸ�׵�������"
	stray(10)="�ҵ�ѧ��(�򹤺�)��ʲô?"
	getstrs=filter(stray,qu)
	if ubound(getstrs)<0 then	
		isselfquestion=true
	else
		isselfquestion=false
	end if
end function

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<script type="text/javascript" src="/jscripts/jq.js"></script>
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>�û�����</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="deleteuser.asp?u_id=<%=u_id%>" onClick="return confirm('ȷ��Ҫɾ��?')">ɾ������û�</a> | <a href="#sendmail">�����û����ʼ� 
      </a>| <a href="../billmanager/Mlist.asp?username=<%=rs("u_name")%>&module=serach">�鿴���û��Ĳ�����ϸ</a> 
    </td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
<form name="form" method="post" action="<%=Request("script_name")%>">
<tr> 
      <td valign="top" bgcolor="#FFFFFF" class="tdbg"> <b>�û���Ϣ��</b>(�ܽ��:<%=formatNumber(Ccur(Rs("u_usemoney"))+Ccur(Rs("u_resumesum")),2,-1,-1)%>,�ɿ���� 
        <input name="Invoice" type="text"  value="<%=Ccur(Rs("u_usemoney"))+Ccur(Rs("u_resumesum"))-ccur(Rs("u_Invoice"))%>" size="5" maxlength="10">
        <input type="button" onClick="ProcessIt(document.form);" value="�޸ķ�Ʊ">
        <script language="javascript">
function ProcessIt(form){
	if (form.Invoice.value=="") {
			alert("��������");
			return false;
		}
	form.Act.value="CHG";
	form.submit();
}

</script> <select name="LockStatus"> <option value="1" <%if Rs("u_freeze") then Response.write " selected"%>>����</option> 
<option value="0" <%if not Rs("u_freeze") then Response.write " selected"%>>�</option> 
</select> <input type="button" name="Button" value="�ı�״̬" onClick="this.form.Act.value='LOCK';this.form.submit();">
<br> 
���ý� 
<select name="u_usemoney_S"> <option value="=">=</option> <option value="+">+</option> 
<option value="-">-</option> </select> <input type="text" name="u_usemoney" value="<%=Rs("u_usemoney")%>" size="4" maxlength="7"> 
�Ż�ȯ:<select name="u_premoney_S"> <option value="=">=</option> <option value="+">+</option> 
<option value="-">-</option> </select> <input type="text" name="u_premoney" value="<%=Rs("u_premoney")%>" size="4" maxlength="7">
<br> δ��� <select name="u_checkmoney_S"> <option value="=">=</option> <option value="+">+</option> 
<option value="-">-</option> </select> <input type="text" name="u_checkmoney" value="<%=Rs("u_checkmoney")%>" size="4" maxlength="7"> 
,�����Ѷ <select name="u_resumesum_S"> <option value="=">=</option> <option value="+">+</option> 
<option value="-">-</option> </select> <input type="text" name="u_resumesum" value="<%=Rs("u_resumesum")%>" size="4" maxlength="7"> 
<input type="submit" name="Submitf" value="�޸�"> <input type="hidden" name="Act" value="ADJUST"> 
<input type="hidden" name="u_id" value="<%=u_id%>"><input type="hidden" value="0" name="u_remcount">
        (��ʾ�����ý�����Ϣֻ����߹���Ա����Ȩ��ֱ���޸�) <br>
        �Ż�ȯ�������������������ʾֵȲ�Ʒ�Ĺ��򣬲����������Ѻ�����ҵ��ƽʱһ�㲻ʹ�øù��ܡ� </td>
</tr> </form>
</table>
<br>
<table width="100%" cellPadding="0" cellSpacing="0" id="AutoNumber3">
<tr> 
            <td valign="top" bgcolor="#FFFFFF"> 
              <table border="1" borderColor="#FFFFFF" cellPadding="0" cellSpacing="0" id="AutoNumber4" style="border-collapse: collapse" width="100%" height="233">
                    <tbody> 
                    <tr> <td align="center" valign="top">
            <table width="100%" border="0" align="left" cellpadding="3" cellspacing="0" class="border">
              <form name="form3" method="post" action="detail.asp">
                <tr> 
                  <td align="right" class="tdbg">�û���:</td>
                  <td class="tdbg"><%=rs("u_name")%></td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">�ܷ�ͨ��������:</td>
                  <td class="tdbg"> 
                    <%
								Auditing=trim(rs("u_Auditing"))
								if Auditing&""="" then Auditing=0
								%>
                    <input type="radio" name="Auditing" <%if cint(Auditing)=1 then response.write "checked "%> value="1">
                    ���� 
                    <input  type="radio" name="Auditing" <%if cint(Auditing)=0 then response.write "checked "%> value="0">
                    ��</td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">ע��ʱ�õ�IP:</td>
                  <td class="tdbg">&nbsp;<%=logip%></td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">�޸����룺<a href="/reg/forget.asp" target="_blank"></a></td>
                  <td class="tdbg"> 
                    <input type="text" name="u_password">
                    <input type="hidden" name="myact" value="chgpass">
                    <input type="hidden" name="u_ids" value="<%=rs("u_id")%>">
                    <br>
                    ������޸�����Ͳ�����д���� <a href="/reg/forget.asp" target="_blank"><font color="#0000FF">��������</font></a></td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">�ֻ�:</td>
                  <td class="tdbg"> 
                    <input type="text" name="msn_msg" value="<%=rs("msn_msg")%>" />
                    <a href="../sendSMS/index.asp?sendNum=<%=rs("msn_msg")%>" target="_blank"><img src="/Template/Tpl_01/images/photo/mobile.gif" width="17" height="16" border="0" alt="������"></a>
					
					
					<%if rs("isauthmobile") then%>
						<button onclick="isauthmobile(0,<%=rs("u_id")%>)" style="color:green">��ͨ��ʵ��(���ȡ��)</button>  
					<%else%>
						<button onclick="isauthmobile(1,<%=rs("u_id")%>)"  style="color:red">δͨ��ʵ��(���ͨ��)</button>  
					<%end if%>
					</td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">Email:</td>
                  <td class="tdbg"> 
                    <input type="text" value="<%=rs("u_email")%>" name="u_email" />
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">��ַ:</td>
                  <td class="tdbg"> 
                    <input type="text" name="u_address" value="<%=rs("u_address")%>" />
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">ע��ʱ�䣺</td>
                  <td class="tdbg"><%=rs("u_regdate")%></td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">���:</td>
                  <td class="tdbg"><label><input type="radio" name="u_class" value="�����û�" <%if rs("u_class")="�����û�" then response.Write "checked"%>>�����û�</label> <label><input type="radio" name="u_class" value="��˾�û�" <%if rs("u_class")="��˾�û�" then response.Write "checked"%>>��˾�û�</label></td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">�Ƿ�VCP���û�:</td>
                  <td class="tdbg"> 
                    <%if rs("f_id")>0 then 
 Response.write "<font color=red>��</font>"
else
 Response.write "��"
end if%>
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">����</td>
                  <td class="tdbg"><%=rs("u_levelName")%></td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg"> QQ:</td>
                  <td class="tdbg"> 
                    <input type="text" name="qq_msg" value="<%=rs("qq_msg")%>" />
                    <%
qq_num=rs("qq_msg")
if isNull(qq_num) then qq_num=""
if len(qq_num)>4 then
%>
                    <a target=blank href=http://wpa.qq.com/msgrd?V=1&Uin=<%=qq_num%>&Site=www.west263.com&Menu=yes><img border="0" src=http://wpa.qq.com/pa?p=1:<%=qq_num%>:4 alt="���������Ϣ���Է�"><%=qq_num%></a> 
                    <%	
else
 Response.write "&nbsp;"
end if

%>
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">����(����):</td>
                  <td class="tdbg"> 
                    <input type="text" name="u_namecn" value="<%=rs("u_namecn")%>">
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">����(Ӣ��):</td>
                  <td class="tdbg"> 
                    <input type="text" name="u_nameen" value="<%=rs("u_nameen")%>">
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">��λ��:</td>
                  <td class="tdbg"> 
                    <input type="text" value="<%=rs("u_company")%>" name="u_company" />
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">��ϵ��:</td>
                  <td class="tdbg"> 
                    <input type="text" name="u_contract" value="<%=rs("u_contract")%>">
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">���֤:</td>
                  <td class="tdbg"> 
                    <input type="text" name="u_trade" value="<%=rs("u_trade")%>">
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">����:</td>
                  <td class="tdbg"> 
                    <input type="text" name="u_contry" value="<%=rs("u_contry")%>">
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">ʡ��:</td>
                  <td class="tdbg"> 
                    <input type="text" name="u_province" value="<%=rs("u_province")%>">
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">����:</td>
                  <td class="tdbg"> 
                    <input type="text" name="u_city" value="<%=rs("u_city")%>">
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">�ʱ�:</td>
                  <td class="tdbg"> 
                    <input type="text" name="u_zipcode" value="<%=rs("u_zipcode")%>">
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">�绰:</td>
                  <td class="tdbg"> 
                    <input type="text" value="<%=rs("u_telphone")%>" name="u_telphone" />
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">����:</td>
                  <td class="tdbg"> 
                    <input type="text" name="u_fax" value="<%=rs("u_fax")%>">
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">��Ϣ��Դ:</td>
                  <td class="tdbg"> 
                    <input type="text" name="u_know_from" value="<%=rs("u_know_from")%>">
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">ϣ���ط�:</td>
                  <td class="tdbg"> 
                    <%if Rs("u_meetonce") then 
  Response.write "<span style=""color:red"">��</span>"
else
  Response.write "��"
end if%>
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">��������</td>
                  <td nowrap class="tdbg"> 
                    <%
							  question=trim(rs("u_question")&"")
							  mylo=false
							  myqu=""
							  if isselfquestion(question) then 
							  	mylo=true
								myqu=question
							  end if
							  answer=rs("u_answer")
							  %>
                    <select id="question" name="question" class="text" title="���뱣������" onChange="doquestion(this.form,this.value)">
                      <%if not mylo and question<>"" then%>
                      <option value="<%=question%>" selected><%=question%></option>
                      <%end if%>
                      <option value="">==��ѡ��һ������==</option>
                      <option value="�ҾͶ��ĵ�һ��ѧУ�����ƣ�">�ҾͶ��ĵ�һ��ѧУ�����ƣ�</option>
                      <option value="�ҵ�ѧ��(�򹤺�)��ʲô?">�ҵ�ѧ��(�򹤺�)��ʲô?</option>
                      <option value="�Ҹ��׵�������">�Ҹ��׵�������</option>
                      <option value="�Ҹ��׵�ְҵ��">�Ҹ��׵�ְҵ��</option>
                      <option value="�ҵĳ������ǣ�">�ҵĳ������ǣ�</option>
                      <option value="��ĸ�׵�������">��ĸ�׵�������</option>
                      <option value="��ĸ�׵�ְҵ��">��ĸ�׵�ְҵ��</option>
                      <option value="�ҳ��а����ε������ǣ�">�ҳ��а����ε������ǣ�</option>
                      <option value="������˵����֣�">������˵����֣�</option>
                      <option value="�Ұְֵ����գ�">�Ұְֵ����գ�</option>
                      <option value="����������գ�">����������գ�</option>
                      <option <%if mylo then response.write "selected"%> value="�ҵ��Զ�������">*�ҵ��Զ�������</option>
                    </select>
                    <input id="myQuestion" name="myQuestion" type="text" class="inputbox" title="�Զ�������" <%if not mylo then%>style="display:none"<%end if%> maxlength="30" value="<%=myqu%>" />
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">��:</td>
                  <td class="tdbg"> 
                    <input name="answer"  type="text"  size=20 value="<%=answer%>">
                  </td>
                </tr>
                <tr> 
                  <td align="right" class="tdbg">IP����:</td>
                  <%
							  ipfilter=rs("ipfilter")
							  allowIP=rs("allowIP")
							  %>
                  <td class="tdbg"> 
                    <input type="checkbox" name="ipfilter" value="yes" <%if ipfilter then response.write " checked"%>  onClick="if (this.checked) {this.form.allowIP.disabled=false;this.form.allowIP.focus();this.form.allowIP.style.background='#FFFFFF';} else {this.form.allowIP.disabled=true;this.form.allowIP.style.background='#E2E2E2';}">
                    <input type="text" name="allowIP" size="50" value="<%=allowIP%>" <% if not ipfilter then Response.write "style=""background-color: #E2E2E2""  disabled "%>>
                  </td>
                </tr>
                <tr>
                  <td align="right" class="tdbg">&nbsp;</td>
                  <td class="tdbg">
                    <input type="submit" name="Submit2" value="�޸Ļ�Ա����" />
                  </td>
                </tr>
              </form>
              <tr> 
                <td colspan="2" class="tdbg"> 
                  <%
If rs("u_type")=0 Then
%>
                  <BR>
                  <form name="form1" method="post" action="<%=Request("script_name")%>">
                    <textarea name="userinfo" cols="40" rows="3"><%=Rs("u_memo")%></textarea>
                    <input type="submit" name="MEMO" value="��ע">
                    <input type="hidden" name="u_id" value="<%=u_id%>">
                  </form>
                  <BR>
                  <a href="deleteuser.asp?u_id=<%=Requesta("u_id")%>" onClick="return confirm('ȷ��Ҫɾ��?')"><font color="#FF0000">ɾ������û�</font></a> 
                  <BR>
                  <BR>
                  <%
End If
%>
                </td>
              </tr>
              <tr> 
                <td colspan="2" class="tdbg"> 
                  <form name="form2" method="post" action="<%=Request("SCRIPT_NAME")%>">
                    <table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" class="border">
                      <tr> 
                        <td align="right">���⣺</td>
                        <td> 
                          <input type="text" name="subject" size="20" maxlength="50">
                          <a name="sendmail"></a> </td>
                      </tr>
                      <tr> 
                        <td align="right">����</td>
                        <td>
                          <textarea name="content" cols="40" rows="4"></textarea>
                          <input type="hidden" name="u_id2" value="<%=Requesta("u_id")%>">
                          <input type="hidden" name="Email" value="<%=rs("u_email")%>">
                        </td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>
                          <input type="submit" name="Submit" value="���͵����ʼ�">
                        </td>
                      </tr>
                    </table>
                  </form>
                </td>
              </tr>
            </table>
          </td></tr> </tbody> </table></td></tr>
            <td></tbody>
</table>
<%

OutString=""
outTime1="1730"
outTime5="0830"
outTime2=split(now()," ")
outTime3=split(outTime2(1),":")
outTime4=outTime3(0)&outTime3(1)

if int(outTime4)>int(outTime1) or int(outTime4)<int(outTime5) then
OutString=" <font color=ff0000><�ǹ���ʱ��></font>"
end if
 
'WriteLogIn "other",session("user_name"),"�鿴�û���ϸ���û���:"&rs("u_name")&",ʱ��"&Now()&" IP:"&request.ServerVariables("REMOTE_ADDR")&" "&OutString
rs.close

conn.close

%>
<script language=javascript>
function doquestion(f,v){
	if(v=="�ҵ��Զ�������"){
		f.myQuestion.style.display="";
	}else{
		f.myQuestion.style.display="none";
	}
}
function isauthmobile(t,u_id)
{
	var msg="��ȷ��Ҫ�ֹ�ȡ�����ʺŵ�ʵ��״̬?"
	if(t==1){msg="��ȷ��Ҫ�ֹ�ʵ�����ʺ�?"}
	if(confirm(msg))
	{
		$.post("detail.asp",{"act":"isauth","u_id":u_id,"t":t},function(data){
			alert(data.msg)		
		},"json")
		
	}
	return false
}
</script><!--#include virtual="/config/bottom_superadmin.asp" -->
