<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%
response.buffer=true
response.Charset="gb2312"
conn.open constr
dim usr_mobile
dim usr_email
call getusrinfo()
hostid=requesta("hostid")
if not isnumeric(hostid) or hostid="" then url_return "�������ݴ���",-1
sqlstring="SELECT * FROM vhhostlist where S_ownerid=" &  session("u_sysid") & " and s_sysid=" & hostid

rs.open sqlstring,conn,1,1
if rs.eof and rs.bof then url_return "û���ҵ�������",-1
s_comment=rs("s_comment")
s_year=rs("s_year")
s_buydate=formatDateTime(rs("s_buydate"),2)
s_expiredate=formatdateTime(rs("s_expiredate"),2)
s_productid=rs("s_productid")
s_buytest=rs("s_buytest")
s_ssl=rs("s_ssl")
s_sslprice=0
if not isnumeric(s_ssl&"") then s_ssl=0
if ccur(s_ssl)>0 then
	s_sslprice=getneedprice(session("user_name"),"vhostssl",1,"renew")
end if

if s_buytest then response.redirect "paytest.asp?hostid=" & hostid & "&productType=vhost":response.end


renewprice=ccur(getneedprice(session("user_name"),s_productid,1,"renew"))+ccur(s_sslprice)
otherip=getOtherip(s_comment,session("user_name"))
if isip(otherip) then
	if lcase(left(s_productid,2))="tw" then
		ipproid="twaddip"
		else
		ipproid="vhostaddip"
	end if

	 
		ipprice=getneedprice(session("user_name"),ipproid,1,"renew")
	 
	if ipprice&""="" or not isnumeric(ipprice) then ipprice=0
	renewprice=cdbl(renewprice)+cdbl(ipprice)
end if
if not isnumeric(ipprice&"") then ipprice=0

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-������������</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language="javascript">
var ipprice=<%=ipprice%>;

	function doneedprice(myvalue,u_name,proid,s_comment){
		var url='../config/renewneedprice.asp?str=needprice';
		var sinfo='years='+myvalue+'&u_name='+escape(u_name)+'&proid='+ proid +"&p_name="+escape(s_comment);
		var divID='needprice';
		$("#"+divID).html('<img src="/Template/Tpl_01/images/new/load1.gif" border="0" id="loadimg" />');
		$.post(url,sinfo,function(data){
			$("#"+divID).html(data)
		})
		//makeRequestPost1(url,sinfo,divID);
		if(ipprice>0)
		{
		 $("#others_ip_msg").html("&nbsp;&nbsp;<font color=red> ������IP����"+ myvalue+"�� </font>");
		}
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

$(function(){
	if(ipprice>0)
	{
     $("#others_ip_msg").html("&nbsp;&nbsp;<font color=red> ������IP����"+ipprice+"Ԫ </font>");
	}
})

$(function(){
	if(ipprice>0)
	{
     $("#others_ip_msg").html("&nbsp;&nbsp;<font color=red> ������IP����1�� </font>");
	}
})

</script>

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
			    <li><a href="/Manager/sitemanager/">����������</a></li>
				<li>������������</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">


 <form name="form1" method="post" action="../config/renew.asp" >
  <div style="border:dashed 1px #ff0000; padding:7px; background:#ffff99; width:99%; margin:10px auto; margin-bottom:5px;">
������ʾ:��2018��5��5��������������������ͬ���ӳ���Ʒ�ʾֵ�ʱ�䡣���͵��������ʾ�ʱ��Ϊ1�꣬���ں��赥�����ѡ�
 </div>
              <table class="manager-table">
                <tbody>
                  <tr>
                    <th width="19%" align="right">�� &nbsp;  ����</th>
                    <td width="81%" height="15" align="left"><%=s_comment%></td>
                  </tr>
                  <tr>
                    <th align="right" > �� �ޣ� </th>
                    <td height="16" align="left"><%=s_year%></td>
                  </tr>
				  <%if ccur(s_sslprice)>0 then%>
				   <tr>
                    <th align="right"  ><p align="right">SSL�۸�</p></th>
                    <td height="2" align="left"><font color="red"><%=s_sslprice%></font>Ԫ/��  </td>
                  </tr>

				  <%end if%>
                  <tr>
                    <th align="right"  ><p align="right">ע�����ڣ�</p></th>
                    <td height="2" align="left"><%=s_buydate%></td>
                  </tr>
                  <tr>
                    <th align="right"  ><p align="right">�������ڣ�</p></th>
                    <td height="26" align="left"><%=s_expiredate%></td>
                  </tr>
<tr> 
            <td colspan="2" align="center"  class="tdbg">
              <div class="redAlert_Box RedLink">Ϊ��ʹ���ܿ�ݡ�׼ȷ���յ�����֪ͨ����Ϣ�����ʵ�����ֻ�Ϊ��<span class="GreenColor"><%=usr_mobile%></span>������Ϊ��<span class="GreenColor"><%=usr_email%></span>�������ԣ��뼰ʱ<a href="/manager/usermanager/default2.asp" class="Link_Blue">�޸�</a>�� </div>
            </td>
          </tr> 
                  <tr>
                    <th height="26" align="right"  > ѡ�񽻷���ͷ��</th>
                    <td height="26" align="left" >
                      <select name="RenewYear" class="manager-select s-select" ONCHANGE="doneedprice(this.value,'<%=session("user_name")%>','<%=s_productid%>','<%=s_comment%>')">
                        <OPTION VALUE="1">��ѡ���������ޣ��Ƽ������꣡</OPTION>
					  <%
					  '2013 8-29 ����������/��������ʱ��
					  dim xzli
					  xzli=0
					  showArray=split("2,��2����1��|3,��3����2��|5,��5����5��|10,��10����10��","|")
					 for each i in split("1,2,3,5,10",",") 

					   if xzli<=ubound(showArray) then
                            showtemp=split(showArray(xzli),",")
								if clng(showtemp(0))=clng(i) then
									showtxt="["&showtemp(1)&"]"
									xzli=xzli+1
									else
									showtxt=""
								end if
							end if
					  
					  %>
                      <OPTION VALUE="<%=i%>"><%=i%> ��<%=showtxt%><%if clng(i)=3 then response.write("��ǿ���Ƽ���")%></OPTION>
                      <%next%>
                      </select>
					  <LABEL id="others_ip_msg"></LABEL></td>
					  </td>
                  </tr>
                  <tr>
                    <th height="26" align="right"  > ���ѽ�</th>
                    <td height="26" align="left">
                    <span id="needprice"><b><font color=red><%=renewprice%></font></b>��/1��</span><font color=red>(��������������ͬ���ӳ���Ʒ�ʾ�ʱ��)</font></td>
                  </tr>
                  <tr>
                    <td height="1" colspan="2" align="center" >
                    
		  <input type="hidden" value="<%=hostid%>" name="p_id">
          <input type="hidden" name="productType" value="host">
          <span id="loadspan" style="display:none"><img src="../images/load.gif" border=0><br>����ִ��,���Ժ�..<br></span>
          <INPUT NAME="C1" TYPE="button" CLASS="manager-btn s-btn"  VALUE="��ȷ�����ѡ�" onClick="return dosub(this.form)">                  </tr>
                </tbody>
              </table>
            
  </form>





		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>