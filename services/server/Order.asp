<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/parsecommand.asp" --> 
<%
response.Charset="gb2312"
call needregsession()
conn.open constr
sql="select * from userdetail where u_name='" & session("user_name") & "'"
rs.open sql,conn,1,1
if  rs.eof then url_return "δ֪�û�",-1
vps=requesta("vps")
vr_room=requesta("vr_room")
hostid=requesta("HostID")
cpu=requesta("cpu")
Memory=requesta("Memory")
HardDisk=requesta("HardDisk")
p_proid=requesta("productid")
vr_room=requesta("vr_room")
if hostid="" then url_return "�������ͺŲ��ܿ�",-1
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
tpl.set_var "vr_room",vbcrlf&"ѡ�����:"&vr_room,false
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
	 osstr="<input name=""CHOICE_OS"" type=""radio"" value=""win"" checked>Windows2003 (��sqlserver2000�����������+��ȫ���ã�ǿ���Ƽ�)<br>"
	 if p_proid<>"vps000" then
	 osstr=osstr & "<input type=""radio"" name=""CHOICE_OS"" value=""win_2005"">Win2003 (��sqlserver2005�����������+��ȫ����)<br>"
	 end if
	 osstr=osstr & "<input type=""radio"" name=""CHOICE_OS"" value=""win_clean"">Win2003 (�����棬���κΰ�ȫ���ã�һ�㲻�Ƽ�)<br>"
	 osstr=osstr & "<input name=""CHOICE_OS"" type=""radio"" id=""radio3"" value=""win_2008_64"">	              Windows Server 2008 64λ(Ԥװphp+sql2008����վ���ɻ���,�Ƽ�ʹ��)<br>"
	 osstr=osstr & "<input type=""radio"" name=""CHOICE_OS"" value=""win_2008"">Windows Server 2008������(64λ)<br>"
	 osstr=osstr & "<input type=""radio"" name=""CHOICE_OS"" value=""linux_wd""> Linux(32λCentOS6.2)-Ԥװwd�������<br>"
	 osstr=osstr & "<input type=""radio"" name=""CHOICE_OS"" value=""linux_ubuntu"">Linux(ubuntu-11.10-server)-�ʺ�רҵ��ʿʹ��<br>"
	' if instr(lcase(p_proid),"xcloud")>0 or instr(lcase(p_proid),"yun")>0 then
	 osstr=osstr & "<input type=""radio"" name=""CHOICE_OS"" value=""win_64"">Win2003(�����棬64λ����ϵͳ)<br>"
	 osstr=osstr & "<input type=""radio"" name=""CHOICE_OS"" value=""linux_64"">Linux(64λCentos6.2)-Ԥװwd�������<br>"
	' end if
	 setOs=osstr
end function
function getserverRoom__()
	result="<select name=""serverRoom"">" & vbcrlf & _
		  "<option value=""1"" selected>�й����Ż���</option>" & vbcrlf & _
		 "<option value=""22"">�ɶ����Ż���</option>" & vbcrlf & _
		  "<option value=""20"">��ۻ���</option>" & vbcrlf & _
		  "<option value=""17"">������ͨ</option>" & vbcrlf & _
		  "<option value=""11"">֣�ݶ���</option>" & vbcrlf & _
		  "<option value=""26"">��������</option>" & vbcrlf & _
		  "<option value=""99"">����</option>" & vbcrlf & _
		"</select>"
	getserverRoom__=result
end function
function getservicetype(byval isvps)
	result="<div><input type=""radio"" name=""servicetype"" value="""& companyname &"��������""><font color=""#0000FF"">"& companyname &"��������</font>&nbsp;&nbsp;���(�ʺ�רҵ���ͻ������ṩ�˹�����֧��)</div>" & _
    "<div><input type=""radio"" name=""servicetype"" value="""& companyname &"ͭ�Ʒ���"" checked><font color=""#0000FF"">"& companyname &"ͭ�Ʒ���</font>&nbsp;&nbsp;��"&  getOtherPrice("ͭ�Ʒ���",isvps) &"Ԫ/��(�ʺ�һ��ͻ����ṩ��׼����֧��)<div>" & _
	"<input type=""radio"" name=""servicetype"" value="""& companyname &"���Ʒ���""><font color=""#0000FF"">"& companyname &"���Ʒ���</font>&nbsp;&nbsp;��"&  getOtherPrice("���Ʒ���",isvps) &"Ԫ/��(�ʺϳ����ͻ����ṩ���ȼ���֧��)</div>" & _
    "<div><input type=""radio"" name=""servicetype"" value="""& companyname &"���Ʒ���""><font color=""#0000FF"">"& companyname &"���Ʒ���</font>&nbsp;&nbsp;��"&  getOtherPrice("���Ʒ���",isvps) &"Ԫ/��(�ʺ�VIP�ͻ����ṩȫ��λ����֧��)</div>"
	getservicetype=result
end function
%>