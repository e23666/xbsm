<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
<style type="text/css">
<!--
p {  font-size: 9pt}
td {  font-size: 9pt}
a:active {  text-decoration: none; color: #000000}
a:hover {  text-decoration: blink; color: #FF0000}
a:link {  text-decoration: none; color: #660000}
a:visited {  text-decoration: none; color: #990000}
.line {  background-image: url(dotline2.gif); background-repeat: repeat-y}
-->
</style>
<%Check_Is_Master(6)%>
<%
E_Q_id=Requesta("qid")
function dvHTMLEncode(fString)
if not isnull(fString) then
    fString = replace(fString, ">", "&gt;")
    fString = replace(fString, "<", "&lt;")

    fString = Replace(fString, " ", "&nbsp;")
    fString = Replace(fString, CHR(34), "&quot;")
    fString = Replace(fString, CHR(39), "&#39;")
    fString = Replace(fString, CHR(13), "")
    fString = Replace(fString, CHR(10) & CHR(10), "</P><P> ")
    fString = Replace(fString, CHR(10), "<BR> ")

    dvHTMLEncode = fString
end if
end function

Select Case Requesta("module")
  Case "reply"
	replyContent=server.htmlencode( Request("content") )
	replyContent=Replace(replyContent,"'","��")
	replyContent=Replace(replyContent,vbcrlf,"<br>")
	replyContent=replyContent & dvHTMLEncode(Requesta("addinfo"))

	if Trim(Replace(Requesta("content"),VbCrLf,""))="����!" then url_return "�����������",-1
	conn.open constr
	Sql="Select a.q_state_new,a.q_reply_name,a.q_status,a.q_from,b.u_level,b.u_email from question as a inner join userdetail as b on a.q_user_name=b.u_name where a.q_id=" & Requesta("qid") 
	Rs.open Sql,conn,1,1
	u_level=0
	q_from=""
	if not Rs.eof then
		if Rs("q_state_new")="3" then url_return Rs("q_reply_name") &"�����ȵ�,�ش���Ч!",-1
		u_level=Rs("u_level")
		q_from=Rs("q_from")
		u_email=Trim(rs("u_email"))
	end if
	Rs.close
	
	if q_from<>"" and u_level>1 then
		if inStr(Lcase(replyContent),"west263")>0 then url_return "����������壬���ܺ�����˾��ַ",-1
	end if
	q_public=Requesta("q_public")
	if q_public<>"1" then
		q_public="0"
	end if
	sql="select top 1 * from question where q_id=" & Requesta("qid")
	rs11.open sql,conn,3,3
	rs11("q_public")=q_public
	rs11("q_reply_content")=replyContent
	rs11("q_reply_name")=session("user_name")
	rs11("q_reply_time")=Now()
	rs11("q_status")=False
	rs11("q_state_new")=3
	q_fid = rs11("q_fid")
	rs11.update
	rs11.close
	if isnumeric(q_fid&"") then
		if q_fid>0 then
			conn.execute("update question set q_state_new=3 where q_id=" & q_fid)
		end if
	end if
'	Sql="update question set q_public=" & q_public & ",q_reply_content='" & replyContent & "',q_reply_name='" & session("user_name") & "',q_reply_time='"&now()&"',q_status=False where q_id=" & Requesta("qid") 
'	conn.Execute(Sql)

     if q_from<>"" then
		Alert_Redirect "�ɹ�[�����������]","default.asp"
	  else
	  	
		if u_email<>"" then
			mailBody="�𾴵Ŀͻ���"& vbcrlf & _
				"  ���ã�"& vbcrlf & _
				"  ���������Ѿ��õ���.���½"& companynameurl &"�鿴������⡣"& vbcrlf & _ 
				"   �ظ�ʱ��:"& now()
	  		call sendMail(u_email,"���������Ѿ��õ���",mailBody)
		end if
		application("E_Q_id")=replace(application("E_Q_id"),"|"&E_Q_id&"="&session("user_name"),"")
		Alert_Redirect "�ɹ�","default.asp"
   end if

  Case "toother"
	conn.open constr
	rs.open "SELECT * FROM question where q_id='"&Requesta("qid")&"' and q_state_new=3",conn,1,3
	If Not rs.eof Then
		rs("q_answeruser")=Requesta("toadmins")
		rs.update
		conn.close
		application("E_Q_id")=replace(application("E_Q_id"),"|"&E_Q_id&"="&session("user_name"),"")
		Alert_Redirect "�ɹ�","default.asp"
	  else
		rs.close
		conn.close
		application("E_Q_id")=replace(application("E_Q_id"),"|"&E_Q_id&"="&session("user_name"),"")
		Alert_Redirect "�Ѿ����˴����","default.asp"
	End If
End Select

%>
<%
Function showqtype(q_type)
	Select Case q_type
		case 0101
		showqtype="����������-����֪ʶ"
		case 0102
		showqtype="����������-ҵ�����"
		case 0103
		showqtype="����������-���Ͻ��"
		case 0104
		showqtype="����������-����"
		case 0201
		showqtype="�ռ�������-����֪ʶ"
		case 0202
		showqtype="�ռ�������-ҵ�����"
		case 0203
		showqtype="�ռ�������-���Ͻ��"
		case 0204
		showqtype="�ռ�������-����"
		case 0301
		showqtype="�����ʾ���-����֪ʶ"
		case 0302
		showqtype="�����ʾ���-ҵ�����"
		case 0303
		showqtype="�����ʾ���-���Ͻ��"
		case 0304
		showqtype="�����ʾ���-����"
		case 0401
		showqtype="��վ������-����֪ʶ"
		case 0402
		showqtype="��վ������-ҵ�����"
		case 0403
		showqtype="��վ������-���Ͻ��"
		case 0404
		showqtype="��վ������-����"
		case 0501
		showqtype="ϵͳ������-����֪ʶ"
		case 0502
		showqtype="ϵͳ������-ҵ�����"
		case 0503
		showqtype="ϵͳ������-���Ͻ��"
		case 0504
		showqtype="ϵͳ������-����"
		case 0601
		showqtype="������-����֪ʶ"
		case 0602
		showqtype="������-ҵ�����"
		case 0603
		showqtype="������-���Ͻ��"
		case 0604
		showqtype="������-����"
		case else
		showqtype="������-����"
	End Select
End Function
%>


<!--#include virtual="/config/bottom_superadmin.asp" -->
