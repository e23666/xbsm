<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.buffer=true
response.charset="gb2312"

 
conn.open constr
dim usr_mobile
dim usr_email
call getusrinfo()
mailid=requesta("id")
if not isnumeric(mailid) or mailid="" then url_return "�������ݴ���",-1
sqlstring="Select * from mailsitelist where m_sysid=" & MailID & " and m_ownerid=" & Session("u_sysid")
rs.open sqlstring,conn,1,1
if rs.eof and rs.bof then url_return "û���ҵ����ʾ�",-1
m_bindname=rs("m_bindname")
m_years=rs("m_years")
m_buydate=formatDateTime(rs("m_buydate"),2)
m_expiredate=formatdateTime(rs("m_expiredate"),2)
m_productid=rs("m_productid")
m_buytest=rs("m_buytest")
if s_buytest then response.redirect "paytest.asp?p_id=" & hostid & "&productType=vhost":response.end
	if trim(m_productid)="diymail" then
	renewprice=getDiyMailprice(rs("m_size")/rs("m_mxuser"),rs("m_mxuser"))
	else
	renewprice=getneedprice(session("user_name"),m_productid,1,"renew")
	end if
%>
 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-��ҵ�ʾ�</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language="javascript" src="/config/ajax.js"></script>
<style>
.redAlert_Box {
    background-color: #FFFDE4;
    border: 1px solid #FF9900;
    padding: 10px;
    margin: 0px 1px 0px 2px;
    font-size: 14px;
    color: #F30;
    font-weight: bold;
    line-height: 22px;
}
</style>
<script language="javascript">
	var m_id=<%=mailid%>
	function doneedprice(myvalue,u_name,proid){
		var url='../config/renewneedprice.asp?str=needprice';
		var sinfo='years='+myvalue+'&u_name='+escape(u_name)+'&proid='+ proid+'&mailid='+<%=requesta("id")%>;
		var divID='needprice';
		makeRequestPost1(url,sinfo,divID)
	}
function dosub(f){
	if(confirm('ȷ���˲�����?')){
		document.getElementById('loadspan').style.display='';
		f.C1.disabled=true;
		f.submit();
		return true;
	}
	return false;
}
</script>
<script src="upyun.js" type="text/javascript" ></script>


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
			   <li><a href="/Manager/mailmanager/">��ҵ�ʾ�</a></li>
			   <li>��ҵ�ʾ�����</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
			
			<div class="redAlert_Box RedLink" id="lockmsg" style="margin:10px 0;"> 
					ȫ�������𺳵ǳ�����Ⱥ�ܹ���ǿ����������ȫ�½��棬֧����ʮ�ǿ���ܣ�Эͬ�칫����Ч���Ƽ������� <a href="javascript:upyun()" class="manager-btn s-btn red-btn">һ���������������</a>
				</div>

<table class="manager-table">
<form name="form1" method="post" action="../config/renew.asp" >
                <tbody>
                  <tr>
                    <th width="36%" align="right" nowrap class="tdbg">�� �֣�</th>
                    <td width="64%" height="15" align="left" class="tdbg"><%=m_bindname%></td>
                  </tr>
                  <tr>
                    <th align="right" nowrap class="tdbg"><font color="#000000"> �� �ޣ�</font></th>
                    <td height="16" class="tdbg" align="left"><%=m_years%></td>
                  </tr>
                  <tr>
                    <th align="right" nowrap class="tdbg"><p align="right">ע�����ڣ�</p></th>
                    <td height="2" class="tdbg" align="left"><%=m_buydate%></td>
                  </tr>
                  <tr>
                    <th align="right" nowrap class="tdbg"><p align="right">�������ڣ�</p></th>
                    <td height="26" class="tdbg" align="left"><%=m_expiredate%></td>
                  </tr>
<tr>
            <td colspan="2"style="text-align: center" BGCOLOR="#FFFFFF" class="tdbg">
              <div class="redAlert_Box RedLink">Ϊ��ʹ���ܿ�ݡ�׼ȷ���յ�����֪ͨ����Ϣ�����ʵ�����ֻ�Ϊ��<span class="GreenColor"><%=usr_mobile%></span>������Ϊ��<span class="GreenColor"><%=usr_email%></span>�������ԣ��뼰ʱ<a href="/manager/usermanager/default2.asp" class="Link_Blue">�޸�</a>�� </div>
            </td>
          </tr>
                  <tr>
                    <th height="26" align="right" nowrap class="tdbg"> ѡ�񽻷���ͷ��</th>
                    <td height="26" class="tdbg" align="left">
                      <select name="RenewYear"  ONCHANGE="doneedprice(this.value,'<%=session("user_name")%>','<%=m_productId%>')">
                      <%for i=1 to 10
					saveStr=""
					    if i=2 then
						saveStr="���������һ�꡿"
					    elseif i=3 then
						saveStr="���������Ͷ��꡿"
						elseif i=5 then
						saveStr="�������������꡿"
						elseif i=10 then
						saveStr="�������������꡿"
						end if
					  %>
                      <OPTION VALUE="<%=i%>"><%=i%> ��<%=saveStr%></OPTION>
                      <%next%>
                      </select></td>
                  </tr>
                  <tr>
                    <th height="26" align="right" nowrap class="tdbg"> ���ѽ�</th>
                    <td height="26" class="tdbg" align="left">
                    <span id="needprice"><b><font color=red><%=renewprice%></font></b>��/1��</span>                    </td>
                  </tr>
                  <tr>
                    <td height="1" colspan="2" style="text-align: center"  class="tdbg">

		  <input type="hidden" value="<%=mailid%>" name="p_id">
          <input type="hidden" name="productType" value="mail">
          <span id="loadspan" style="display:none"><img src="../images/load.gif" border=0><br>����ִ��,���Ժ�..<br></span>
          <INPUT NAME="C1" TYPE="button" class="manager-btn s-btn"   VALUE="��ȷ�����ѡ�" onClick="return dosub(this.form)">        </td>  </tr>
                </tbody>
  </form>
              </table>

		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>