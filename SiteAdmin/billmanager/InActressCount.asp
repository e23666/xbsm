<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%Check_Is_Master(3)%>
<%
c_date=now()
c_memo="�Ż����"
substrings="<input type=submit name=Submit1 value=ȷ�� onClick=""javascript:document.form1.module.value='incount';"">"
module=Requesta("module")
If module="incount" Then
 		u_countid=Requesta("sid1")

		u_name=Requesta("sid2")
		u_out=Requesta("sid3")
		if not isnumeric(u_out) then url_return "��������",-1
		if u_out<=0 then  url_return "����Ϊ������",-1

		c_date=Requesta("sid4")
		c_memo=Requesta("sid5")
		If u_out="" Then u_out=0
		If Not isdate(c_date&"") Then c_date=now()

		substrings="<input type=submit name=Submit1 value=�������ȷ�� onClick=""javascript:document.form1.module.value='check';"">"
End If
If module="check" Then
	substrings="<input type=submit name=Submit1 value=�ٴ�ȷ�� onClick=""javascript:document.form1.module.value='check';"">"
	u_countid=Ucase(left(session("user_name"),4)) & "-" & Requesta("sid1")

	u_name=Requesta("sid2")
	u_out=Requesta("sid3")
	c_date=Requesta("sid4")
	c_memo=Requesta("sid5")
	'response.Write(u_out)
	'response.End()
	If u_out="" Then u_out=0
	If Not isdate(c_date&"") Then c_date=now()
	if instr(c_memo,"�Ż����")<>0 then
		needcheck=1
	else
		needcheck=0
	end if

	conn.open constr
	sql="select u_countid from countlist where u_countid = '"&u_countid&"'"
	rs.open sql,conn,1,3
	if not rs.eof then
		ssmsg= "ƾ֤����ظ�"
	end if
	rs.close
	
	sql="select u_id from userdetail where u_name = '"&u_name&"'"
	rs.open sql,conn,1,3
	
	if not rs.eof then
		u_id=rs(0)
	else
		ssmsg= "�����û�ʧ��"
	end if
	rs.close
	
	if ssmsg="" then
		sql="update Userdetail set u_remcount =  u_remcount + "&u_out&" , u_usemoney = u_usemoney  + "&u_out&" ,u_resumesum=u_resumesum - "&u_out&"  where u_name ='"&u_name&"'"
		conn.execute(sql)
		
		'��ʾ����
		u_Balance=conn.execute("select u_usemoney from Userdetail  where u_name = '"&u_name&"'")(0)
		
		sql="insert into countlist (u_id,u_moneysum,u_in,u_out, u_countid , c_memo ,c_date ,c_dateinput ,c_datecheck,c_check,c_type,o_id,p_proid,u_Balance) values ("&u_id&", -"&u_out&", 0, -"&u_out&", '"&u_countid&"' , '"&c_memo&"', '"&c_date&"','"&now()&"', '"&now()&"',"&needcheck&",9,0,'',"&u_Balance&")"
		conn.execute(sql)
		
		
		conn.execute("update UserDetail set u_checkmoney=u_checkmoney+"&u_out&" where u_name='"&u_name&"'")
		ssmsg= "�Ż����ɹ�"
		u_countid=""

		u_name=""
		u_out=""
		c_date=now()
		c_memo="����"
		substrings="<input type=submit name=Submit1 value=ȷ�� onClick=""javascript:document.form1.module.value='incount';"">"
		conn.close
		
	end if

End If


if u_countid="" then u_countid="-" &getDateTimeNumber()
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong> �Ż����</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="<%=SystemAdminPath%>/billmanager/incount.asp" target="main">�û����</a>| <a href="InActressCount.asp" target="main">�Ż����</a><a href="outcount.asp"></a> | <a href="returncount.asp" target="main">�����뻧</a><a href="returncount.asp"></a> | <a href="comsume.asp" target="main">�ֹ��ۿ�</a><a href="comsume.asp"></a> | <a href="outOurMoney.asp" target="main">��¼��֧</a><a href="checkcount.asp"></a> | <a href="ViewOurMoney.asp" target="main">�鿴��ˮ��</a><a href="checkmoney.asp"></a> | <a href="InActressCount.asp">�Ż����</a> | <a href="OurMoney.asp">����ˮ��</a></td>
  </tr>
</table><br>

<table width="100%" cellPadding="0" cellSpacing="0"   borderColor="#FFFFFF" id="AutoNumber3" style="border-collapse: collapse" >
<tr>
						<td valign="top"  align="center">
				    <%
						Response.Write ssmsg
						%>


						    <FORM action="InActressCount.asp" method=post name=form1>
						    <table width="100%" border=0 align=center cellpadding=3 cellspacing=0 bordercolordark=#FFFFFF class="border">
					          <TR>
						           
            <TD width="40%" align="right" class="tdbg">&nbsp;</TD>
						           
            <TD width="60%" class="tdbg">&nbsp;</TD>
				              </TR>
					          <TR>
						           
            <TD width="40%" align="right" class="tdbg">ƾ֤��ţ�<%=Ucase(left(session("user_name"),4))%>-</TD>
						           
            <TD width="60%" class="tdbg"> 
<INPUT name=sid1 size="20" value="<%=u_countid%>">
                                <input name=module type=hidden value=incount></TD>
				              </TR>
						         <TR>
						           
            <TD align="right" class="tdbg">�� ����</TD>
						           
            <TD class="tdbg">
<INPUT name=sid2 size="20"  value="<%=u_name%>">  </TD>
				              </TR>
						         <TR>
						           
            <TD align="right" class="tdbg">���</TD>
						           
            <TD class="tdbg">
<INPUT name=sid3 size="20"  value="<%=u_out%>"> Ԫ</TD>
				              </TR>
						 		<TR>
						           
            <TD align="right" class="tdbg">�������ͣ�</TD>
						           
            <TD class="tdbg">
              <INPUT name=sid5 size="20"  value="<%=c_memo%>:" >            </TD>
				              </TR>
						 		<TR>
						           
            <TD align="right" class="tdbg">ʱ���䣺</TD>
						           
            <TD class="tdbg">
<INPUT name=sid4 size="20"  value="<%=c_date%>">(yyyy-mm-dd)</TD>
				              </TR>
						         <TR>
						           <TD align=center class="tdbg">&nbsp;</TD>

						           <TD class="tdbg"><%= substrings  %></TD>
						         </TR>
						         <TR>
						           <TD colspan="2" class="tdbg"><br>
              <strong>��ʾ��</strong><br>
              �Ż����������û��Żݵģ�����ĳ�ռ��ֵ300Ԫ��ʵ�ʸ��û�̸��ֻ��280Ԫ���� ��Ҫ�������ŻݵĿ�ӵ��û��ʺ��ϣ��ᵼ�¿��ý�����ӣ��ܽ��䡣 
              <br>
						             �Ż�����ڿ������ʹ����룺���Ż���<font color="#FF0000">�ռ�������600Ԫ��9��</font>�� �����ֲ���Ҫ�滻)
					               <!--#include virtual="/config/bottom_superadmin.asp" -->
					               <br>
					               <br></TD>
				              </TR>
							  </table>  
					      </form>



						</td>
  </tr>
					</table>
  

<br>
