<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.buffer=true
response.charset="gb2312"
%>
<script language="javascript" src="/config/ajax.js"></script>
<script language="javascript">
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
<%
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

<HEAD>
<title>�û������̨-��ҵ�ʾ�����</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link href="<%=managercss1%>" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=managercss2%>" type="text/css" />
</HEAD>
<body id="thrColEls">

<div class="Style2009"> 
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV"> 
    <!--#include virtual="/manager/manageleft.asp" -->
    <div id="MainRight">
      <div class="new_right"> 
        <!--#include virtual="/manager/pulictop.asp" -->
        
        <div class="main_table">
          <div class="tab">��ҵ�ʾ�����</div>
          <div class="table_out">
          
          
<table width="100%" border="0" cellpadding="4" cellspacing="0" class="border managetable tableheight">
<form name="form1" method="post" action="../config/renew.asp" >
                <tbody>
                  <tr>
                    <td width="36%" align="right" nowrap class="tdbg">�� ��</td>
                    <td width="64%" height="15" class="tdbg"><%=m_bindname%></td>
                  </tr>
                  <tr>
                    <td align="right" nowrap class="tdbg"><font color="#000000"> �� �ޣ�</font></td>
                    <td height="16" class="tdbg"><%=m_years%></td>
                  </tr>
                  <tr>
                    <td align="right" nowrap class="tdbg"><p align="right">ע�����ڣ�</p></td>
                    <td height="2" class="tdbg"><%=m_buydate%></td>
                  </tr>
                  <tr>
                    <td align="right" nowrap class="tdbg"><p align="right">�������ڣ�</p></td>
                    <td height="26" class="tdbg"><%=m_expiredate%></td>
                  </tr>
<tr> 
            <td colspan="2" align="center" BGCOLOR="#FFFFFF" class="tdbg">
              <div class="redAlert_Box RedLink">Ϊ��ʹ���ܿ�ݡ�׼ȷ���յ�����֪ͨ����Ϣ�����ʵ�����ֻ�Ϊ��<span class="GreenColor"><%=usr_mobile%></span>������Ϊ��<span class="GreenColor"><%=usr_email%></span>�������ԣ��뼰ʱ<a href="/manager/usermanager/default2.asp" class="Link_Blue">�޸�</a>�� </div>
            </td>
          </tr>                  <tr>
                    <td height="26" colspan="2" nowrap class="tdbg">&nbsp;</td>
                  </tr>
                  <tr>
                    <td height="26" align="right" nowrap class="tdbg"> ѡ�񽻷���ͷ��</td>
                    <td height="26" class="tdbg">
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
                    <td height="26" align="right" nowrap class="tdbg"> ���ѽ�</td>
                    <td height="26" class="tdbg">
                    <span id="needprice"><b><font color=red><%=renewprice%></font></b>��/1��</span>                    </td>
                  </tr>
                  <tr>
                    <td height="1" colspan="2" align="center" class="tdbg">
                    
		  <input type="hidden" value="<%=mailid%>" name="p_id">
          <input type="hidden" name="productType" value="mail">
          <span id="loadspan" style="display:none"><img src="../images/load.gif" border=0><br>����ִ��,���Ժ�..<br></span>
          <INPUT NAME="C1" TYPE="button" CLASS="app_ImgBtn_Big"  VALUE="��ȷ�����ѡ�" onClick="return dosub(this.form)">          </tr>
                </tbody>
  </form>
              </table>



          </div>
        </div>
      </div>
    </div>
  </div>
  <!--#include virtual="/manager/bottom.asp" --> 
</div>


</body>

</html>

