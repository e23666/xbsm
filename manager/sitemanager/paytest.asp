<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr
hostid=requesta("hostid")
if not isnumeric(hostid) or hostid="" then url_return "�������ݴ���!",-1
sqlstring="SELECT * FROM vhhostlist where S_ownerid=" &  session("u_sysid") & " and s_buytest="&PE_True&" and s_sysid=" & hostid
 
rs.open sqlstring,conn,1,1
if rs.eof then url_return "û���ҵ�����������",-1
s_comment=rs("s_comment")
s_year=rs("s_year")

gift=0
select case clng(s_year)
case 3
s_year=2
gift=1
case 5
s_year=3
gift=2
case 8
s_year=5
gift=3
case 20
s_year=10
gift=10
end select

s_buydate=formatDateTime(rs("s_buydate"),2)
s_expiredate=formatdateTime(rs("s_expiredate"),2)
s_productid=rs("s_productid")
s_buytest=rs("s_buytest")
if not isnumeric(s_year) or s_year="" or s_year<1 then s_year=1
s_year=1
price=getneedprice(session("user_name"),s_productid,s_year,"new")
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-��������ת��</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language="javascript">
	function doneedprice(myvalue,u_name,proid){
		var url='../config/renewneedprice.asp?str=needprice';
		var sinfo='years='+myvalue+'&u_name='+u_name+'&proid='+ proid;
		var divID='needprice';
		$("#"+divID).html('<img src="/Template/Tpl_01/images/new/load1.gif" border="0" id="loadimg" />');
		$.post(url,sinfo,function(data){
			$("#"+divID).html(data)
		})
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
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			    <li><a href="/Manager/sitemanager/">����������</a></li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
          

 
  <form name="form1" method="post" action="../config/paytest.asp" >
 
              <table  class="manager-table">
                <tbody>
				  <tr><th colspan=2>��������ת��<th></tr>
                  <tr>
                    <th width="19%" align="right">��&nbsp; ����</th>
                    <td width="81%" align="left"><%=s_comment%></td>
                  </tr>
                 <tr>
                    <th align="right">ע�����ڣ�</th>
                    <td align="left"><%=s_buydate%></td>
                  </tr>
                  <tr>
                    <th align="right" >�� �ޣ�</th>
                    <td align="left">
                    <select name="buy_year">
                    <%
					for i=1 to 10 
					select case i
					case 2
					gift="��2����1��"
					case 3
					gift="��3����2�꡾ǿ���Ƽ���"
					case 5
					gift="��5����3��"
					case 10
					gift="��10����10��"
					case else
					gift=""
					end select
					
					if isNumeric(demoprice) then
					syfy=demoprice
					else
					syfy=0
					end if
					
					%>
                    <option value="<%=i%>"><%=(price*i)-syfy%>Ԫ/<%=i%>��&nbsp;<%=gift%></option>
                    <%
					next
					%>
                    </select>
                    
                    </td>
                  </tr>
              
                  <tr>
                 
                    <td colspan=2>
                  <input type="hidden" value="<%=hostid%>" name="p_id">
                  <input type="hidden" name="productType" value="vhost">
          <INPUT NAME="C1" TYPE="submit"  CLASS="manager-btn s-btn"  VALUE="��ȷ��ת����" onClick="return confirm('ȷ�����Ѳ�����?')">
                    
                  </tr>
                </tbody>
              </table>
        
  </form> 





		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>