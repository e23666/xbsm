<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/parsecommand.asp" --> 
<%
response.Charset="gb2312"
call needregsession()
conn.open constr
sql="select * from userdetail where u_name='" & session("user_name") & "'"
rs.open sql,conn,1,1
if  rs.eof then url_return "未知用户",-1
vps=requesta("vps")
vr_room=requesta("vr_room")
hostid=requesta("HostID")
cpu=requesta("cpu")
Memory=requesta("Memory")
HardDisk=requesta("HardDisk")
p_proid=requesta("productid")
vr_room=requesta("vr_room")
if hostid="" then url_return "服务器型号不能空",-1
tpl.set_unknowns "remove"
call setHeaderAndfooter()
if vps="okay" then
	isvps=true
	call setvpsserverLeft()
	serverroom=getcacheRoom(p_proid)
else
	isvps=false
	call setserverLeft()
	serverroom=getserverRoom__()
end if
serverroom=replace(serverroom,"selected","")
serverroom=replace(serverroom,""""&vr_room&"""",""""&vr_room&""" selected")
tpl.set_file "main", USEtemplate&"/services/server/Order.html"
tpl.set_var "vps",vps,false
tpl.set_var "hostid",HostID,false
tpl.set_var "cpu",cpu,false
tpl.set_var "memory",Memory,false
tpl.set_var "harddisk",HardDisk,false
tpl.set_var "p_proid",p_proid,false
tpl.set_var "CHOICE_OS",setOs(p_proid),false
tpl.set_var "vr_room",vbcrlf&"选择机房:"&vr_room,false
tpl.set_var "setroomlist",serverroom,false
tpl.set_var "servicetype",getservicetype(isvps),false
call setusercontent(rs)

tpl.parse "mains","main",false
tpl.p "mains" 
set tpl=nothing
rs.close
conn.close
sub setusercontent(byval domainRs)
	for Ri=0 to domainRs.fields.count-1
			tplname=trim(lcase(domainRs.Fields(Ri).Name))
			tplvalue=trim(domainRs(Ri))
			if trim(tplvalue)&""<>"" then
				tpl.set_var lcase(tplname),trim(tplvalue),false
			end if
	next
end sub
function setOs(byval p_proid)
	 osstr="<input name=""CHOICE_OS"" type=""radio"" value=""win"" checked>Windows2003 (含sqlserver2000，及常用软件+安全配置，强烈推荐)<br>"
	 if p_proid<>"vps000" then
	 osstr=osstr & "<input type=""radio"" name=""CHOICE_OS"" value=""win_2005"">Win2003 (含sqlserver2005，及常用软件+安全配置)<br>"
	 end if
	 osstr=osstr & "<input type=""radio"" name=""CHOICE_OS"" value=""win_clean"">Win2003 (纯净版，无任何安全设置，一般不推荐)<br>"
	 osstr=osstr & "<input name=""CHOICE_OS"" type=""radio"" id=""radio3"" value=""win_2008_64"">	              Windows Server 2008 64位(预装php+sql2008等网站集成环境,推荐使用)<br>"
	 osstr=osstr & "<input type=""radio"" name=""CHOICE_OS"" value=""win_2008"">Windows Server 2008纯净版(64位)<br>"
	 osstr=osstr & "<input type=""radio"" name=""CHOICE_OS"" value=""linux_wd""> Linux(32位CentOS6.2)-预装wd控制面板<br>"
	 osstr=osstr & "<input type=""radio"" name=""CHOICE_OS"" value=""linux_ubuntu"">Linux(ubuntu-11.10-server)-适合专业人士使用<br>"
	' if instr(lcase(p_proid),"xcloud")>0 or instr(lcase(p_proid),"yun")>0 then
	 osstr=osstr & "<input type=""radio"" name=""CHOICE_OS"" value=""win_64"">Win2003(纯净版，64位操作系统)<br>"
	 osstr=osstr & "<input type=""radio"" name=""CHOICE_OS"" value=""linux_64"">Linux(64位Centos6.2)-预装wd控制面板<br>"
	' end if
	 setOs=osstr
end function
function getserverRoom__()
	result="<select name=""serverRoom"">" & vbcrlf & _
		  "<option value=""1"" selected>中国电信机房</option>" & vbcrlf & _
		 "<option value=""22"">成都电信机房</option>" & vbcrlf & _
		  "<option value=""20"">香港机房</option>" & vbcrlf & _
		  "<option value=""17"">河南网通</option>" & vbcrlf & _
		  "<option value=""11"">郑州多线</option>" & vbcrlf & _
		  "<option value=""26"">美国机房</option>" & vbcrlf & _
		  "<option value=""99"">其他</option>" & vbcrlf & _
		"</select>"
	getserverRoom__=result
end function
function getservicetype(byval isvps)
	result="<div><input type=""radio"" name=""servicetype"" value="""& companyname &"基础服务""><font color=""#0000FF"">"& companyname &"基础服务</font>&nbsp;&nbsp;免费(适合专业级客户，不提供人工技术支持)</div>" & _
    "<div><input type=""radio"" name=""servicetype"" value="""& companyname &"铜牌服务"" checked><font color=""#0000FF"">"& companyname &"铜牌服务</font>&nbsp;&nbsp;加"&  getOtherPrice("铜牌服务",isvps) &"元/月(适合一般客户，提供标准技术支持)<div>" & _
	"<input type=""radio"" name=""servicetype"" value="""& companyname &"银牌服务""><font color=""#0000FF"">"& companyname &"银牌服务</font>&nbsp;&nbsp;加"&  getOtherPrice("银牌服务",isvps) &"元/月(适合初级客户，提供优先技术支持)</div>" & _
    "<div><input type=""radio"" name=""servicetype"" value="""& companyname &"金牌服务""><font color=""#0000FF"">"& companyname &"金牌服务</font>&nbsp;&nbsp;加"&  getOtherPrice("金牌服务",isvps) &"元/月(适合VIP客户，提供全方位技术支持)</div>"
	getservicetype=result
end function
%>