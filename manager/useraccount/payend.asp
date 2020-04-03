<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
response.Charset="gb2312"
function Trims(varStr)
 varStr=Trim(varStr)
 Trims=replace(varStr,"'","＇")
end function

conn.open constr
name=Trims(Requesta("name"))
username=Trims(Requesta("username"))
hktype=Trims(Requesta("hktype"))
moneys=Trims(Requesta("money"))
uploadFileName=Requesta("uploadFileName")
PayDate=Requesta("year") & "-" & Requesta("months") & "-" & Requesta("day") & "  " & Requesta("time") & "时"
Orders=Trims(Requesta("ddnum"))
UseFor=Trims(Requesta("UseFor"))
Mem=Trims(Requesta("Mem"))
if Requesta("phone")<>"" then Mem=Mem & ",电话：" & Requesta("phone")

if name<>"" and username<>"" then
  Sql="Select u_id from userdetail where u_name='" & username & "'"
  Rs.open Sql,conn,1,1
  if Rs.eof then
		url_return "错误,您填写的会员用户名在我司系统中不存在,这将影响您业务的正常开通,所以请仔细填写!",-1
  end if
  Rs.close
  if not isnumeric(moneys&"") then url_return "请正确录入汇款金额",-1

  Sql="Insert into PayEnd ([name],[username],[PayMethod],[Amount],[PayDate],[Orders],[ForUse],p_state,[Memo],[Pdate],[SubIP],[P_Pic]) Values ("
  Sql=Sql & "'" & name &"','" & username & "','" & hktype &"'," & Moneys & ",'" & PayDate & "','" & Orders &"','" & UseFor & "',0,'" & Mem &"','" & Now & "','" & Request.ServerVariables("Remote_Addr") & "','" & uploadFileName & "')"
  conn.Execute(Sql)
  		getStr="username=" & username & "," & _
			  "name=" & name & "," & _
			  "hktype=" & hktype & "," & _
			  "Moneys=" & Moneys & "," & _
			  "PayDate=" & PayDate & "," & _
			  "phone=" & replace(Requesta("phone"),",","，") & "," & _
			  "Mem=" & replace(Requesta("Mem"),",","，")
		mailbody=redMailTemplate("payendtomanager.txt",getStr)
		if agentmail<>"" then
			call sendMail(agentmail,"汇款确认-"& username,mailbody)
		end if
  
  
  Response.write "<script language=javascript>alert('您的汇款确认已经提交成功，我们会在查帐后尽快开通您的业务，请注意查收邮件，如果您的注册资料不够详细，请马上修改，否则不能及时为您入款开通业务！');window.location.href='ViewPayEnd.asp';</script>"
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
<title>用户管理后台-汇款确认</title>
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
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			   <li><a href="/manager/useraccount/payend.asp">汇款确认</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">

  <FORM NAME="form1" METHOD="post" ACTION="PayEnd.asp" ONSUBMIT="return check(this);">
  <TABLE  class="manager-table">

    <TR>
      <TH width="35%" align="right">姓名：　</TH>
      <TD width="65%" align="left"><INPUT TYPE="text" NAME="name" class="manager-input s-input" value="<%=u_namecn%>">
        (汇款人真实姓名) </TD>
    </TR>
    <TR>
      <Th align="right">用户名：</Th>
      <TD align="left"><INPUT TYPE="text" NAME="username" class="manager-input s-input" value="<%=u_name%>">
        (在本站注册的用户名） </TD>
    </TR>
    <TR>
      <Th align="right">汇款方式：</Th>
      <TD align="left"><SELECT NAME="hktype" ONCHANGE="setInfo(this.value);">
          <option value="招商银行">招商银行</option>
          <option value="交通银行">交通银行</option>
          <option value="建设银行">建设银行</option>
          <option value="工商银行">工商银行</option>
          <option value="农业银行">农业银行</option>
          <option value="支付宝支付">支付宝支付</option>
          <option value="财富通支付">财富通支付</option>
          <option value="在线支付">在线支付(易宝)</option>
          <option value="公司转帐">公司转帐</option>
          <option value="西联国际汇款">西联国际汇款</option>
          <option value="公司转帐2">公司转帐2</option>
          <option value="邮政汇款">邮政汇款</option>
          <option value="邮政存折汇款">邮政存折汇款</option>
          <option value="云网支付">云网支付</option>
          <option value="快钱支付">快钱支付</option>
        </SELECT>
        <FONT SIZE=2 COLOR=green><SPAN ID=MESS> <BR>
        注:在线支付失败的用户,请直接选择云网支付或支付宝支付,不要选择付款时所采用的银行.</SPAN></FONT></TD>
    </TR>
    <SCRIPT LANGUAGE=javascript>
function setInfo(strValue){
   if (strValue=="邮政汇款"||strValue=="公司转帐") 
      MESS.innerHTML="(" + strValue +"不是实时到帐，建议传真汇款底单)";
  else
      MESS.innerHTML="";
}
</SCRIPT>
    <TR>
      <Th align="right">汇款金额：</Th>
      <TD align="left"><INPUT TYPE="text" NAME="money" class="manager-input s-input">
        元 </TD>
    </TR>
    <TR>
      <TH align="right">汇款时间：</TH>
      <TD align="left"><INPUT TYPE="text" NAME="year" class="manager-input s-input" VALUE="<%=year(now())%>" MAXLENGTH="4" SIZE="3">
        年
        <INPUT TYPE="text" NAME="months" VALUE="<%=month(now())%>" class="manager-input s-input" MAXLENGTH="4" SIZE="3">
        月
        <INPUT TYPE="text" NAME="day" SIZE="2" MAXLENGTH="3" class="manager-input s-input" value="<%=day(now())%>">
        日
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
        时 </TD>
    </TR>
    <TR>
      <TH align="right" VALIGN="top">订单号：</TH>
      <TD align="left"><INPUT TYPE="text" NAME="ddnum" class="manager-input s-input" VALUE="">
        (多个订单号请用逗号隔开,续费不用填写)</TD>
    </TR>
    <TR>
      <TH align="right" VALIGN="top">汇款用途：</TH>
      <TD align="left"><INPUT TYPE="radio" NAME="usefor"  VALUE="购买产品" ONCLICK="if (this.form.ddnum.value=='') alert('如果您未将业务订单填写在[订单号]处，我司仅负责将款加到您会员帐上,您需要自行开通业务');">
        购买产品
        <INPUT TYPE="radio" NAME="usefor" VALUE="升级">
        升级
        <INPUT TYPE="radio" NAME="usefor" VALUE="续费">
        续费
        <INPUT TYPE="radio" NAME="usefor" VALUE="追加预付款">
        追加预付款<BR>
        <INPUT TYPE="radio" NAME="usefor" VALUE="租用服务器">
        租用服务器
        <INPUT TYPE="radio" NAME="usefor" VALUE="申请代理">
        申请代理/合作伙伴</TD>
    </TR>
    <TR>
      <TH ALIGN="right" VALIGN="top">联系电话：</TH>
      <TD align="left"><INPUT TYPE="text" NAME="phone" class="manager-input s-input">
        （可以不填） </TD>
    </TR>
    <TR>
      <TH align="right" VALIGN="top">备注：</TH>
      <TD align="left"><INPUT TYPE="text" NAME="mem" class="manager-input s-input">
        （若续费，请填写要续费的业务） </TD>
    </TR>
    <TR>
      <TH ALIGN="right">汇款底单扫描:</TH>
      <TD ID="uploadLabel"><IFRAME FRAMEBORDER=0 SCROLLING="no"  WIDTH=100% height=24 SRC="/customercenter/post_upload.asp"></IFRAME></TD>
    </TR>
    <TR>
     
      <TD   ID="uploadLabel"colspan=2>如果没有不用选择,扩展名:jpg,gif,小于200K</TD>
    </TR>
    <TR>
      
      <TD colspan=2><INPUT TYPE="submit" NAME="Submit" VALUE="提交"  class="manager-btn s-btn">
        <INPUT TYPE="reset" NAME="Submit2" VALUE="清除"  class="manager-btn s-btn">
        <INPUT TYPE="hidden" NAME="uploadFileName" ID="uploadFileName">
      </TD>
    </TR>
    <TR>
      <TD align="left" colspan="2">提示：
        <P>续费的客户，请在备注栏注明你要续费的虚拟主机和域名，并在汇款用途处选择：续费。如果没有明确注明用途的，我们只负责将款项将至你的帐号上，需要自己到管理中心点击"续费"。<BR>
          <BR>
          请务必保证您在申请会员时所填写的用户资料是真实完整的,否则业务将暂不开通</P></TD>
    </TR>
  </FORM>
</TABLE>
          







		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>





 