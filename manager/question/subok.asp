<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
conn.open constr
subject=server.htmlencode(Request("subject"))
subject=Replace(subject,"'","��")
content=server.htmlencode(Request("content"))
content=Replace(content,vbcrlf,"<br>")
content=Replace(content,"<br>","��br��")
content=Replace(content,"'","��")
content=Replace(content," ","&nbsp;")

stype=Requesta("type")
ip=Requesta("ip")
uploadFileName=session("upfileFileName")   'Requesta("uploadFileName")
domain=Requesta("domain")
session("upfileFileName")=""
keyword=Requesta("keyword")
q_fid=Requesta("q_fid")
module=Requesta("module")'postquestion
if not isnumeric(stype&"") then echoString "�����������!","r"
If subject<>"" Then		
	Xcmd="other" & vbcrlf
	Xcmd=Xcmd & "add" & vbcrlf
	Xcmd=Xcmd & "entityname:question" & vbcrlf
	Xcmd=Xcmd & "subject:" & subject & vbcrlf
	Xcmd=Xcmd & "domain:" & domain & vbcrlf
	Xcmd=Xcmd & "type:" & stype & vbcrlf
	Xcmd=Xcmd & "fid:" & q_fid & vbcrlf
	Xcmd=Xcmd & "pic:" & uploadFileName & vbcrlf
	Xcmd=Xcmd & "content:" & content & vbcrlf & "." & vbcrlf

	Xdo=Pcommand(Xcmd,Session("user_name"))
	if left(Xdo,4)="200 " then
	
	   if questionMail<>"" then
	   mailtitle="�û�"&Session("user_name")&"�ύ���ʱش�"&subject
	   mailcontent=left(decodehtml(content&""),500)
	   call sendMail(questionMail,mailtitle,mailcontent)
	   end if
		
		echoString "�����ύ�ɹ�","r"
		
	else
		echoString "�����ύʧ��" & Xdo,"r"
	end if
else
	echoString "��û����ȷ��д����","e"
End If

conn.close
%>
