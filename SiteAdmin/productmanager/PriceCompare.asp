<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" --> 
<!--#include virtual="/config/ParseCommand.asp" -->
<%Check_Is_Master(1)%> 
<%
productid=requesta("prodid")
getproduct=productid
backpage=request.ServerVariables("HTTP_REFERER")
if getproduct="" then getproduct="all_product"
   		conn.open constr
		optCode="other" & vbcrlf
		optCode=optCode & "get" & vbcrlf
		optCode=optCode & "entityname:pricecompare" & vbcrlf
		optCode=optCode & "getproduct:"& getproduct & vbcrlf & "." & vbcrlf
		retCode=Pcommand(optCode,Session("user_name"))
		if left(retcode,3)="200" then
			noteInfo="<font color=red>成本价获取成功!</font>"
		else
			noteInfo="成本价获取失败!" & retCode
		end if
		response.write noteinfo
		conn.close	
%>
<hr size="1" color="#666666">
<input type="button" onClick="javascript:location.href='<%=backpage%>'" value=" 返 回 ">
