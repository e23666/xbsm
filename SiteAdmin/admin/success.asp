<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/md5_16.asp" -->
 <%Check_Is_Master(6)%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>资料修改</strong></td>
  </tr>
</table>
<br />
<table width="100%" border="0" cellpadding="20" cellspacing="0" class="border">
                          <tr> 
                            <td colspan="2" align="center"> 
                                <%
	conn.open constr
	Sql="Select u_freeze from userdetail where u_id=" & Session("u_sysid")
	Rs.open Sql,conn,1,1
	if not Rs.eof then
		if Rs("u_freeze") then url_return "此帐户资料已被管理员锁定，不能修改资料!",-1
	end if
	Rs.close
	actiontype=requesta("actiontype")
	u_province=requesta("u_province")
	u_fax=requesta("u_fax")
'	u_name=requesta("u_name")
	u_zipcode=requesta("u_zipcode")
	u_password=requesta("u_password")
	u_question=trim(requestf("question"))
	myquestion=trim(requestf("myquestion"))
	u_answer=trim(requestf("answer"))
	if u_question="我的自定义问题" then u_question=myquestion
	if u_question="" then u_answer=""
	if u_answer="" then u_question="":myquestion=""
	If u_password="" Then
		u_password="no"
	  else
			u_password= md5_16(u_password)
		Set conn1=nothing
	End If

	qq=Requesta("qq")
	msn = Requesta("msn")
	u_namecn=Requesta("u_namecn")
	u_company=requesta("u_company")

	u_introduce=requesta("u_introduce")
	u_contract=requesta("u_contract")
	u_address=requesta("u_address")
	u_trade=requesta("u_trade")
	u_contry=requesta("u_contry")
	u_email=requesta("u_email")
	u_city=requesta("u_city")
	u_telphone=requesta("u_telphone")
	u_website=requesta("u_website")
	u_employees=requesta("u_employees")
	u_know_from=requesta("u_know_from")
	u_father=session("bizbid")
	u_nameen=Requesta("u_nameen")
	ipfilter=Trim(Requesta("ipfilter"))
	allowIP=Trim(Requesta("allowIP"))

	If u_trade="" Then u_trade=""
	If u_employees="" Then u_employees=""
	If u_know_from="" Then u_know_from=""
	If u_website="" Then u_website=""
	If u_introduce="" Then u_introduce=""
	if allowIP="" Then allowIP=""
	if ipfilter<>"" then
		ipfilter=1
	else
		ipfilter=0
	end if
	
	if u_password="no" then
		sql="update userdetail set [qq_msg] ='"&qq&"', [msn_msg] ='"&msn&"',[u_province]='"&u_province&"',[u_fax]='"&u_fax&"', [u_zipcode]='"&u_zipcode&"',[u_company]='"&u_company&"', [u_introduce]='"&u_introduce&"',[u_contract]='"&u_contract&"' ,[u_address]='"&u_address&"', [u_trade]='"&u_trade&"',[u_email]='"&u_email&"',[u_contry]='"&u_contry&"',[u_know_from]='"&u_know_from&"', [u_employees]='"&u_employees&"',[u_website]='"&u_website&"',[u_telphone]='"&u_telphone&"',[u_city]='"&u_city&"' ,[u_namecn]='"&u_namecn&"' ,[u_nameen]='"&u_nameen&"',[ipfilter]='"&ipfilter&"',[allowIP]='"&allowIP&"', [u_question]='"&u_question&"',[u_answer]='"&u_answer&"' where [u_id]="&session("u_sysid")
	else
		sql="update userdetail set [qq_msg] ='"&qq&"', [msn_msg] ='"&msn&"',[u_province]='"&u_province&"',[u_fax]='"&u_fax&"', [u_zipcode]='"&u_zipcode&"',[u_company]='"&u_company&"', [u_introduce]='"&u_introduce&"',[u_contract]='"&u_contract&"' ,[u_address]='"&u_address&"', [u_trade]='"&u_trade&"',[u_email]='"&u_email&"',[u_contry]='"&u_contry&"',[u_know_from]='"&u_know_from&"', [u_employees]='"&u_employees&"',[u_website]='"&u_website&"',[u_telphone]='"&u_telphone&"',[u_city]='"&u_city&"' ,[u_namecn]='"&u_namecn&"' ,[u_nameen]='"&u_nameen&"',[ipfilter]='"&ipfilter&"',[allowIP]='"&allowIP&"', [u_question]='"&u_question&"',[u_answer]='"&u_answer&"',u_password='"&u_password&"' where [u_id]="&session("u_sysid")
	end if
	
	conn.execute(sql)
	conn.execute "update userDetail set u_clue='"& date() &"' where u_id="& trim(session("u_sysid"))
%>
                                <p><img src="../images/succeed64_64.gif" width="64" height="64"> 
                                  <br>
                              </p>
                                <center>
                                  <b><%=companyname%>提示：</b><br>
                                  个人资料修改成功<font size="2">！</font> 
                                  <hr size="1">
                                  <br>
                                  您可以继续以下操作： <br>
                                  <li><a href="default2.asp" target="main">返回管理中心</a></li>
                                
                               
                                </center>

</td>
                          </tr>
</table>
