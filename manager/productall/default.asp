<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312" 

if session("u_levelid")="" then session("u_levelid")=1
'sqlstring="select * from v_pricelist where p_fatherid='"&session("bizbid")&"' and p_u_level='" & session("u_levelid") & "'"
sqlstring="SELECT productlist.p_name,productlist.p_price as ppprice, productlist.P_proId, pricelist.p_price, producttype.pt_name, productlist.p_size, productlist.p_type FROM (productlist INNER JOIN pricelist ON productlist.P_proId = pricelist.p_proid) INNER JOIN producttype ON productlist.p_type = producttype.pt_id WHERE (pricelist.p_u_level = "&session("u_levelid")&")"

p_type=strtonum(Requesta("p_type"))
str=trim(requesta("str"))
p_proid=trim(requesta("search_p_proid"))
p_name=trim(requesta("search_p_name"))
s=requesta("s")
newsqlstr=""
sorts=""

if len(trim(s))<=0 then 
	sortsql=" order by productlist.p_proid"
	s=0
	
else

	if s=0 then
	sortsql=" order by pricelist.p_price"
	sorts=""
	else
	sorts=" desc"
	sortsql=" order by pricelist.p_price desc"
	end if
If trim(requesta("pd"))="m" Then
	if s=0 then 
		s=1
	else
		s=0
	end if
end if
end if

If Requesta("module")="search" Then
	If  Requesta("pages")<>"" Then
		pages =strtonum(Requesta("Pages"))
		conn.open constr
		if instr(sortsql,"pricelist.p_price")>0 then
			sqlstr1=replace(session("sqlsearch"),"productlist.p_name","pricelist.p_price")
			
		else
			sqlstr1=session("sqlsearch")
		end if
		
		rs.open sqlstr1 &" "&sorts ,conn,3
	else
		
		
		sqllimit=""
		if p_proid<>"" then sqllimit=sqllimit & " and productlist.p_proid like '%"& lcase(p_proid) &"%'"
		if p_name<>"" then sqllimit=sqllimit & " and productlist.p_name like '%"& lcase(p_name) &"%'"
		If p_type<>"" and p_type>0 Then sqllimit= sqllimit & " and productlist.p_type="&p_type
		sqlcmd= sqlstring & sqllimit
		'���²���  �ֱ���Ҫ���� �������Ĳ����ȵ����
		conn.open constr
		session("sqlsearch")=sqlcmd & sortsql
		rs.open session("sqlsearch") ,conn,3
	End If
else
	conn.open constr
	p_type=3
	newsqlstr=" and productlist.p_type=3 "
	sqlcmd= sqlstring & newsqlstr
	session("sqlsearch")=sqlcmd & sortsql


	rs.open session("sqlsearch"),conn,3
End If

function getYuanjia(pid)
	getYuanjia="δ֪"
	sql="select p_price from pricelist where p_proid='" & pid & "' and p_u_level=1"
	set trs=conn.execute(sql)
	if not trs.eof then  getYuanjia=trs("p_price")
	trs.close
end function
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-��Ʒ�۸�</title>
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
        <li><a href="/">��ҳ</a></li>
        <li><a href="/Manager/">��������</a></li>
        <li><a href="/manager/productall/default.asp">��Ʒ�۸�</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <div>
        <form name="searchform" action="<%=request("script_name")%>" method="post">
          <strong>��������</strong> <a href="/manager/productall/default.asp?module=search&amp;p_type=1" class="manager-btn s-btn">�� ��</a> <a href="/manager/productall/default.asp?module=search&amp;p_type=3"  class="manager-btn s-btn">�� ��</a> <a href="/manager/productall/default.asp?module=search&amp;p_type=2"  class="manager-btn s-btn"> �� �� </a> <a href="/manager/productall/default.asp?module=search&amp;p_type=7"  class="manager-btn s-btn">MSSQL���ݿ�</a> <a href="/manager/productall/default.asp?module=search&amp;p_type=4" class="manager-btn s-btn">��������</a> &nbsp;&nbsp;&nbsp;&nbsp; <strong>������</strong> ��ƷID:
          <input name="search_p_proid" type="text" class="manager-input s-input" value="<%=p_proid%>">
          &nbsp;&nbsp;
          ��Ʒ����:
          <input type="hidden" value="search"  name="module" />
          &nbsp;&nbsp;
          <input name="search_p_name" type="text" class="manager-input s-input" value="<%=p_name%>">
          <input type="submit" class="manager-btn s-btn" style="height:30px;"  value="  �� ��  ">
        </form>
      </div>
      <%
If Not (rs.eof And rs.bof) Then
    Rs.PageSize = 20
    rsPageCount = rs.PageCount
    flag = pages - rsPageCount
    If pages < 1 or flag > 0 then pages = 1
    Rs.AbsolutePage = pages
%>
      <form action="../usermanager/default.asp" method=post>
        <table class="manager-table">
          <tr>
            <th>��Ʒ����</th>
            <th>��ƷID</th>
            <th>���ۼ۸�</th>
            <th>���ļ۸�</th>
            <%if requesta("p_type")="3" or requesta("p_type")="" or requesta("p_type")="0" then%>
            <th>���Ѽ۸�</th>
            <%end if%>
            <th><strong>��Ʒ���</th>
            <th>��Ʒ��С
              </td>
          </tr>
          <%
Do While Not rs.eof And i<21

productid=rs("p_proid")
%>
          <tr>
            <td><%= rs("p_name") %></td>
            <td><%= rs("p_proid") %></td>
            <td><%= getYuanjia( rs("p_proid") ) %>Ԫ
              </p></td>
            <td><%= GetNeedPrice(session("user_name"),rs("p_proid"),1,"new") %>Ԫ
              </p></td>
            <%if requesta("p_type")="3" or requesta("p_type")="" or requesta("p_type")="0" then%>
            <td><%= GetNeedPrice(session("user_name"),rs("p_proid"),1,"renew") %>Ԫ
              </p></td>
            <%end if%>
            <td><%=rs("pt_name")%></td>
            <td><%if(rs("p_type")=1 or rs("p_type")=2)then%>
              <%= rs("p_size") %>Mb
              <%else%>
              -
              <%end if%>
              </p></td>
          </tr>
          <%
		rs.movenext
		i=i+1
	Loop
	rs.close
	conn.close
	%>
          <tr>
            <td colspan =7 align="center"><a href="default.asp?module=search&amp;pages=1&amp;p_type=<%=p_type%>" class="z_next_page">��һҳ</a> &nbsp; <a href="default.asp?module=search&amp;pages=<%=pages-1%>&amp;p_type=<%=p_type%>" class="z_next_page">��һҳ</a>&nbsp; <a href="default.asp?module=search&pages=<%=pages+1%>&p_type=<%=p_type%>" class="z_next_page">��һҳ</a>&nbsp; <a href="default.asp?module=search&pages=<%=rsPageCount%>&p_type=<%=p_type%>" class="z_next_page">βҳ</a>&nbsp; 
              ��<%=pages%>ҳ</td>
          </tr>
        </table>
      </form>
      <br>
      <%
  else
	rs.close
	conn.close
End If
%>
    </div>
  </div>
</div>

<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
