<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)
Response.Charset="gb2312"



if requesta("act")="ywgh"  then
	conn.open constr
	if Check_as_Master(1) then
		
		u=trim(requesta("u"))
		set u_rs=conn.execute("select u_id,u_name from UserDetail where u_name='"&u&"'")
		if u_rs.eof then
			die "��ѯ�û�����ʧ�ܣ�"
		else
			u_id=u_rs("u_id")
			u_name=u_rs("u_name")
			u_rs.close
			set u_rs=nothing
		end if
		d_id=checkNumArray(trim(requesta("id")))
		'conn.execute("update vhhostlist set S_ownerid="&u_id&" where s_sysid in("&d_id&")")
		set hrs=Server.Createobject("adodb.recordset")
		sql="select * from databaselist where dbsysid in("&d_id&")"
		hrs.open sql,conn,1,3
		do while not hrs.eof
			if hrs("dbu_id")<>u_id then
			mname=hrs("dbname")
  			hrs("dbu_id")=u_id
			hrs.update
			call Add_Event_logs(session("user_name"),4,mname,"�����߱����["&u_name&"]["&u_id&"]")
			end if
		hrs.movenext
		loop

		die 200
	 else
          die "Ȩ�޲���"
	 end if
end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<script type="text/javascript" src="/jscripts/check.js"></script>
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>SQL �� �� �� �� ��</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="default.asp">SQL���ݿ����</a> | <a href="adddatabase.asp">�ֹ����SQL���ݿ�</a> | <a href="../admin/HostChg.asp">ҵ����� </a> | <a href="syn.asp">ͬ���ϼ����ݿ� </a></td>
  </tr>
</table>
<br />
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" bgcolor="#000000" class="border">
<form name="search" method="post" action="default.asp">
            <tr bgcolor="#FFFFFF"> 
              <td width="38%" align="right" bgcolor="#FFFFFF" class="tdbg"> 
              <p style="margin-left: 9;">�������ݿ�:              </td>
              <td width="62%" bgcolor="#FFFFFF" class="tdbg"> 
                <p style="margin-left: 9;"> 
                  <input name="dbname" type="text" class="textfield" >
              </td>
    </tr>
            <tr bgcolor="#FFFFFF"> 
              <td align="right" bgcolor="#FFFFFF" class="tdbg"> 
              <p style="margin-left: 9;">�������ݿ��û���:              </td>
              <td bgcolor="#FFFFFF" class="tdbg"> 
                <p style="margin-left: 9;"> 
                  <input name="dbloguser" type="text" class="textfield" id="dbloguser" >
              </td>
    </tr>
            <tr bgcolor="#FFFFFF"> 
              <td align="right" bgcolor="#FFFFFF" class="tdbg"> 
              <p style="margin-left: 9;">�����û���:              </td>
              <td bgcolor="#FFFFFF" class="tdbg"> 
                <p style="margin-left: 9;"> 
                  <input name="u_name" type="text" class="textfield" id="u_name" >
              </td>
    </tr>
            <tr bgcolor="#FFFFFF"> 
              <td align="right" bgcolor="#FFFFFF" class="tdbg"> 
              <p style="margin-left: 9;">����IP:              </td>
              <td bgcolor="#FFFFFF" class="tdbg"> 
                <p style="margin-left: 9;"> 
                  <input name="dbserverip" type="text" class="textfield" id="dbserverip" >
              </td>
    </tr>
            <tr bgcolor="#FFFFFF"> 
              <td bgcolor="#FFFFFF" class="tdbg">&nbsp;</td>
              <td bgcolor="#FFFFFF" class="tdbg">
                <p style="margin-left: 9;"> <input type="submit" name="button" id="button" value="����ʼ���ҡ�" />
              <input type="hidden" name="module" value="search" /></td>
    </tr>
          </form>
        </table>      
<br />
      <%

sqlstring="select temp.*,giftabout.gcomment from (SELECT  productlist.p_name, databaselist.dbname, UserDetail.u_name, databaselist.dbserverip, databaselist.dbloguser, databaselist.dbbuydate, databaselist.dbexpdate, databaselist.dbstatus, databaselist.dbsysid FROM (databaselist INNER JOIN productlist ON databaselist.dbproid = productlist.P_proId) INNER JOIN [UserDetail] ON databaselist.dbu_id = UserDetail.u_id   where databaselist.dbsysid>0) as temp  left join [giftabout] on ([giftabout].gname=[temp].dbname and  [giftabout].gtype=1) where 1=1 "
If Requesta("module")="search" Then
	If  Requesta("pages")<>"" Then
		pages =strtonum(Requesta("Pages")) 
		conn.open constr
		rs.open session("sqlsearch") ,conn,3
	  else
		dbname=trim(Requesta("dbname"))
		u_name=trim(Requesta("u_name"))
		dbloguser=trim(Requesta("dbloguser"))
		u_name=trim(Requesta("u_name"))
		dbserverip=trim(Requesta("dbserverip"))
		sqllimit =""
 		If dbname<>"" Then sqllimit=sqllimit & " and dbname like '%"&dbname&"%'"
		If u_name<>"" Then sqllimit=sqllimit & " and u_name like '%"&u_name&"%'"
		If dbloguser<>"" Then sqllimit=sqllimit & " and dbloguser like '%"&dbloguser&"%'"
		If dbserverip<>"" Then sqllimit=sqllimit & " and dbserverip = '"&dbserverip&"'"
 		sqlcmd= sqlstring & sqllimit  & "  order by dbbuydate desc"
		'���²���  �ֱ���Ҫ���� �������Ĳ����ȵ����
		conn.open constr
	 
		session("sqlsearch")=sqlcmd 
		rs.open session("sqlsearch") ,conn,3
	End If
  else
	conn.open constr
	sqlcmd= sqlstring
	session("sqlsearch")=sqlcmd & "  order by dbbuydate desc"
	rs.open session("sqlsearch"),conn,3
End If
%>
<%
If Not (rs.eof And rs.bof) Then
MaxPerPage=20
if Requesta("page")<>"" then
     currentPage=cint(Requesta("page"))
   	else
      currentPage=1
end if
totalPut=rs.recordcount                           
if currentpage<1 then                           
	currentpage=1                           
end if                           
                          
      		if (currentpage-1)*MaxPerPage>totalput then                           
	   		if (totalPut mod MaxPerPage)=0 then                           
	     			currentpage= totalPut \ MaxPerPage                           
	   		else                           
	      			currentpage= totalPut \ MaxPerPage + 1                           
	   		end if                           
      		end if                           
       		if currentPage=1 then                           
            		showContent                           
            		showpage totalput,MaxPerPage,"default.asp"                           
       		else                           
          		if (currentPage-1)*MaxPerPage<totalPut then                           
            			rs.move  (currentPage-1)*MaxPerPage                           
            			dim bookmark                           
            			bookmark=rs.bookmark                           
            			showContent                           
             			showpage totalput,MaxPerPage,"default.asp"                           
        		else                           
	        		currentPage=1                           
           			showContent                           
           			showpage totalput,MaxPerPage,"default.asp"                           
	      		end if                           
	   	end if                           
   	rs.close                                                   
   	sub showContent                           
       	dim i                           
	i=0                        
%>
        <TABLE width="100%" border=0 align=center cellPadding=2 cellSpacing=1 class="border">
          <TR align=middle> 
		   <td align="center" class="Title"><input type="checkbox" onClick="selectItem('s_sysid')" /></td>
            <td align="center" nowrap class="Title"><strong>��Ʒ��</strong></td>
            <td align="center" nowrap class="Title"><strong>���ݿ���</strong></td>
            <td align="center" nowrap class="Title"><strong>�û���</strong></td>
            <td align="center" nowrap class="Title"><strong>IP��ַ</strong></td>
            <td align="center" nowrap class="Title"><strong>��ͨ����</strong></td>
            <td align="center" nowrap class="Title"><strong>��������</strong></td>
            <td align="center" nowrap class="Title"><strong>״̬</strong></td>
            <td align="center" nowrap class="Title"><strong>����</strong></td>
          </TR>
          <%Do While Not rs.eof %>
          <TR align=center bgColor="#EAF5FC"> 
		   <td nowrap bgcolor="#FFFFFF" class="tdbg"><input type="checkbox" name="s_sysid" value="<%=Rs("dbsysid")%>" /></td>
            <td nowrap bgcolor="#FFFFFF" class="tdbg"><a href="m_default.asp?module=detail&sid=<%=rs("dbsysId")%>"><%= rs("p_name")%></a>
			
			</td>
            <td nowrap bgcolor="#FFFFFF" class="tdbg"><a href="m_default.asp?module=detail&sid=<%=rs("dbsysId")%>"><%= replace(rs("dbname"),",","<br>") %></a><%
			if trim(rs("gcomment"))<>"" then
			response.write("(<font color=red>��Ʒ</font>)")
			end if
			%></td>
            <td nowrap bgcolor="#FFFFFF" class="tdbg"><%= rs("u_name") %></td>
            <td nowrap bgcolor="#FFFFFF" class="tdbg"><%= rs("dbserverip") %></td>
            <td nowrap bgcolor="#FFFFFF" class="tdbg"><%= formatDateTime(rs("dbbuydate"),2)%></td>
            <td nowrap bgcolor="#FFFFFF" class="tdbg"><%= formatDateTime(rs("dbexpdate"),2)%></td>
            <td nowrap bgcolor="#FFFFFF" class="tdbg"><%
			if datediff("d",now(),rs("dbexpdate"))<0 then
            response.write " <img border=""0"" src=""/images/fei1.gif"">"
			else
			response.write showstatus(rs("dbstatus"))
			end if%></td>
            <td nowrap bgcolor="#FFFFFF" class="tdbg"><a href="m_default.asp?module=detail&sid=<%=rs("dbsysId")%>">����</a>|<a href="RenewDatabase.asp?dataID=<%=rs("dbsysId")%>">����</a>|<a href="Updatabase.asp?dataID=<%=rs("dbsysId")%>">����</a></td>
          </tr>
          <%
	 i=i+1     
	 if i>=MaxPerPage then exit do     
	 rs.movenext     
	 loop
	%>
	 <tr>
            <td colspan="9" class="tdbg">
			<form name="form3" method="post" action="<%=Request.ServerVariables("SCRIPT_NAME")%>">
			��ѡ���ʾֹ�����:<INPUT TYPE="text" NAME="gh_u_name" id="gh_u_name"><INPUT TYPE="button" value="ȷ������" onclick="ywgh()">&nbsp;&nbsp;
			 
            </form>
            </td>
	 </tr>
          <tr bgcolor="#FFFFFF"> 
            <form method=Post action="default.asp">
              <td colspan="11" align="center"> 
                <%end sub %>
                <%     
	function showpage(totalnumber,maxperpage,filename)     
  	dim n  
  	if totalnumber mod maxperpage=0 then     
     		n= totalnumber \ maxperpage     
  	else     
     		n= totalnumber \ maxperpage+1     
  	end if     
  	
  	if CurrentPage<2 then     
    		response.write "���м�¼ "&totalnumber&" ��&nbsp;��ҳ ��һҳ&nbsp;"     
  	else     
    		response.write "���м�¼ "&totalnumber&" ��&nbsp;<a href="&filename&"?module=search&page=1&dbname="&dbname&"&u_name="&u_name&">��ҳ</a>&nbsp;"     
    		response.write "<a href="&filename&"?module=search&page="&CurrentPage-1&"&dbname="&dbname&"&u_name="&u_name&">��һҳ</a>&nbsp;"     
  	end if     
     
  	if n-currentpage<1 then     
    		response.write "��һҳ βҳ"     
  	else     
    		response.write "<a href="&filename&"?module=search&page="&(CurrentPage+1)&"&dbname="&dbname&"&u_name="&u_name&">"       
    		response.write "��һҳ</a> <a href="&filename&"?module=search&page="&n&"&dbname="&dbname&"&u_name="&u_name&">βҳ</a>"     
  	end if     
response.write "&nbsp;ҳ�Σ�<strong><font color=red>"&CurrentPage&"</font>/"&n&"</strong>ҳ "     
response.write "&nbsp;<b>"&maxperpage&"</b>��/ҳ "   
%>
                <% end function  %>              </td>
            </form>
          </tr>
        </table>
<%
  else
End If
conn.close
%>
        
        <%
Function showstatus(svalues)
	Select Case svalues
	  Case 0   '����
		showstatus="<img src=../images/green1.gif width=17 height=17>"
	  Case -1'
		showstatus="<img src=../images/nodong.gif width=17 height=17>"
	  Case else
		showstatus="<img src=../images/nodong.gif width=17 height=17>"
	End Select
End Function
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
<br>
<table border="0" cellpadding="0" cellspacing="1" width="100%" bgcolor="#999999" height="45">
  <tr> 
    <td width="100%" bgcolor="#C2E3FC" height="21">&nbsp;���ݿ�״̬ͼ��˵��:</td>
  </tr>
  <tr> 
    <td width="100%" bgcolor="#FFFFFF" height="21"> 
      <p align="center"><img border="0" src="/images/green1.gif">��������<img border="0" src="/images/green2.gif">������ͣ&nbsp; 
        <img border="0" src="/images/fei1.gif">�ѹ���&nbsp;&nbsp; <img border="0" src="/images/sysstop.gif">��ϵͳֹͣ 
        <img src="/manager/images/nodong.gif" width="17" height="17">δ����ɹ� 
    </td>
  </tr>
</table>
<script>

function selectItem(nm){
	$(':checkbox[name=' + nm + ']').each(function(){
		this.checked= !this.checked;
	})
}
function ywgh()
{
domstr=""
obj=$("input[name='s_sysid']:checkbox")
u=$("input[name=gh_u_name]");
if(u.val()==="")
{
alert("ҵ�������Ϊ��!")
u.focus()
return false;
}
 for(var i=0;i<obj.length;i++)
 {
    if(obj[i].checked)
	{
	   if(domstr==="")
	   {
		   domstr=obj[i].value;
	   }else{
	      domstr+=","+obj[i].value;
	   }
	}
 }
 if(domstr==="")
 {
 alert("��ѡ��Ҫ����������!")
 return false;
 }
  if(confirm("���붨Ҫ��ѡ��ҵ���Ƶ�["+u.val()+"]�ʻ��£�"))
  
  {

		 url="?act=ywgh&u="+u.val()+"&id="+domstr

		 $.get(url,"",function(date){
			  if(date=="200")
			  {
			  location.reload()
			  }else
			  {
			  alert(date);
			  }
		 })
}
}  

</script>
<%

function checkNumArray(str)
   temparray=split(str,",")
   newArray=""
   for i=0 to ubound(temparray)
      if isnumeric(temparray(i)&"") then
	  		if newArray="" then
				newArray=temparray(i)
			else
				newArray=newArray&","&temparray(i)
			end if
	  end if
   next
   if newArray="" then newArray=0
   checkNumArray=newArray
end function
%>