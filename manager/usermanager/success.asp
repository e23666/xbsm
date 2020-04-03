<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/md5_16.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-账号资料修改成功</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
        <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
        <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
        <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
        <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
</HEAD>

<body>
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			   <li>域名管理</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
<div class="new_right">
        <div class="main_table">
          <div class="tab">账号资料修改成功</div>
          <div class="table_out">

          <table width="100%" border="0" cellpadding="20" cellspacing="0" class="border">
                          <tr>
                            <td colspan="2" align="center">
                                <%

								function glsyh(s_str)
								  glsyh=s_str
								  if instr(s_str,"""")>0 then
								      glsyh=regReplace(s_str&"","([\""]+)","")

								  end if
								end function
	conn.open constr
	Sql="Select * from userdetail where u_id=" & Session("u_sysid")
	Rs.open Sql,conn,1,1
	readonly="readonly"
	if not Rs.eof then
		if Rs("u_freeze") then url_return "此帐户资料已被管理员锁定，不能修改资料!",-1
		if Session("priusername")="" then
			if rs("alipay_userid")<>"" or rs("u_company")&""="" or rs("u_namecn")&""="" then readonly=""
		else
			readonly=""
		end if
	end if
	Rs.close
	actiontype=glsyh(requesta("actiontype"))
	u_province=glsyh(requesta("u_province"))
	u_fax=glsyh(requesta("u_fax"))
'	u_name=requesta("u_name")
	u_zipcode=glsyh(requesta("u_zipcode"))
	u_password=glsyh(requesta("u_password"))
	u_question=glsyh(trim(requestf("question")))
	myquestion=glsyh(trim(requestf("myquestion")))
	u_answer=glsyh(trim(requestf("answer")))
	if u_question="我的自定义问题" then u_question=glsyh(myquestion)
	if u_question="" then u_answer=""
	if u_answer="" then u_question="":myquestion=""
	If u_password="" Then
		u_password="no"
	  else

	 if isBad(session("user_name"),u_password,errinfo) then
		   die url_return(replace(replace(errinfo,"ftp用户名","会员帐号"),"用户名","用户名"),-1)
	end if

	   u_password= md5_16(u_password)

	End If

	qq=glsyh(Requesta("qq"))
	msn = glsyh(Requesta("msn"))

	if readonly="" then
		u_namecn=glsyh(Requesta("u_namecn"))
		u_company=glsyh(requesta("u_company"))
   	else
		u_company=replace(Session("u_company"),"'","")
		u_namecn=replace(Session("u_namecn"),"'","")
    end if
	u_introduce=glsyh(requesta("u_introduce"))
	u_contract=glsyh(requesta("u_contract"))
	u_address=glsyh(requesta("u_address"))
	u_trade=glsyh(requesta("u_trade"))
	u_contry=glsyh(requesta("u_contry"))
	u_email=glsyh(requesta("u_email"))
	u_city=glsyh(requesta("u_city"))
	u_telphone=glsyh(requesta("u_telphone"))
	u_website=glsyh(requesta("u_website"))
	u_employees=glsyh(requesta("u_employees"))
	u_know_from=glsyh(requesta("u_know_from"))
	u_father=session("bizbid")
	u_nameen=glsyh(Requesta("u_nameen"))
	ipfilter=glsyh(Trim(Requesta("ipfilter")))
	allowIP=glsyh(Trim(Requesta("allowIP")))

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
	dim renauthmobile
	renauthmobile=""			
	if isrenauthmobile(session("u_sysid"),msn) then
		renauthmobile=",[isauthmobile]=0"
	end if

	if u_password="no" then
		sql="update userdetail set [qq_msg] ='"&qq&"', [msn_msg] ='"&msn&"',[u_province]='"&u_province&"',[u_fax]='"&u_fax&"', [u_zipcode]='"&u_zipcode&"',[u_company]='"&u_company&"', [u_introduce]='"&u_introduce&"',[u_contract]='"&u_contract&"' ,[u_address]='"&u_address&"', [u_trade]='"&u_trade&"',[u_email]='"&u_email&"',[u_contry]='"&u_contry&"',[u_know_from]='"&u_know_from&"', [u_employees]='"&u_employees&"',[u_website]='"&u_website&"',[u_telphone]='"&u_telphone&"',[u_city]='"&u_city&"' ,[u_namecn]='"&u_namecn&"' ,[u_nameen]='"&u_nameen&"',[ipfilter]='"&ipfilter&"',[allowIP]='"&allowIP&"', [u_question]='"&u_question&"',[u_answer]='"&u_answer&"'"&renauthmobile&" where [u_id]="&session("u_sysid")
	else
		sql="update userdetail set [qq_msg] ='"&qq&"', [msn_msg] ='"&msn&"',[u_province]='"&u_province&"',[u_fax]='"&u_fax&"', [u_zipcode]='"&u_zipcode&"',[u_company]='"&u_company&"', [u_introduce]='"&u_introduce&"',[u_contract]='"&u_contract&"' ,[u_address]='"&u_address&"', [u_trade]='"&u_trade&"',[u_email]='"&u_email&"',[u_contry]='"&u_contry&"',[u_know_from]='"&u_know_from&"', [u_employees]='"&u_employees&"',[u_website]='"&u_website&"',[u_telphone]='"&u_telphone&"',[u_city]='"&u_city&"' ,[u_namecn]='"&u_namecn&"' ,[u_nameen]='"&u_nameen&"',[ipfilter]='"&ipfilter&"',[allowIP]='"&allowIP&"', [u_question]='"&u_question&"',[u_answer]='"&u_answer&"',u_password='"&u_password&"'"&renauthmobile&" where [u_id]="&session("u_sysid")
	end if
	session("u_email")=u_email
	session("msn")=msn
	conn.execute(sql)
	conn.execute "update userDetail set u_clue='"& date() &"' where u_id="& trim(session("u_sysid"))
%>
                                <p><img src="../images/succeed64_64.gif" width="64" height="64">
                                  <br>
                              </p>
                                <center style="font-size: 14px">
                                  <b><%=companyname%>提示：</b><br>
                                  个人资料修改成功！
                                 <div style="background-color: #eee;margin-top: 15px; height: 1px"></div>
                                  <br>
                                  您可以继续以下操作： <br>
                                 <a href="default2.asp" class="manager-btn">返回管理中心</a>


                                </center>

</td>
                          </tr>
</table>








          </div>
        </div>
      </div>
		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>

</html>
