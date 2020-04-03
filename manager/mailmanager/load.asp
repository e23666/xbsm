<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/class/yunmail_class.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312" 
Server.ScriptTimeout=240000
conn.open constr
set yun=new yunmail_class
	yun.setuid=session("u_sysid")
	act=Trim(requesta("act"))
Select Case Trim(act)
	Case "info":getinfo()
	case "upprice":getupprice()
	case "upsure":upsure()
	case "getrenewprice":getrenewprice()
	case "renewsure":renewsure()
	case "syn":syn()
	Case "upyun":upyun()
	Case "repwdsave":repwdsave()
	Case Else
		die echojson("500","","")
End select


Sub repwdsave()
	m_id=requesta("m_id")
	if not isnumeric(m_id&"") then die echojson("500","��������","")
	set yun=new yunmail_class
	yun.setuid=session("u_sysid")
	if not  yun.isnext then die echojson("500",yun.errarr.Join(","),"")
	yun.setmailid=m_id
	if Not yun.isnext Then die echojson("500",yun.errarr.Join(","),"")
	pwd=requesta("pwd")
	repwd=requesta("repwd")
	Set p=newoption()
	p.add "pwd",pwd
	p.add "repwd",repwd
	yun.chgpwd(p)
	if yun.isnext then
		die echojson("200","�����޸ĳɹ�!","")
	Else
		die echojson("500",yun.errarr.Join(","),"")
	end if
End sub

Sub upyun()
	m_id=requesta("m_id")
	if not isnumeric(m_id&"") then die echojson("500","��������","")
	set yun=new yunmail_class
	yun.setuid=session("u_sysid")
	if not  yun.isnext then die echojson("500",yun.errarr.Join(","),"")
	yun.setmailid=m_id
	if Not yun.isnext Then die echojson("500",yun.errarr.Join(","),"")
	yun.upyun()
	if yun.isnext then
		die echojson("200","���������ʾֳɹ�!","")
	Else
		die echojson("500",yun.errarr.Join(","),"")
	end if

End Sub

sub syn()
	m_id=requesta("m_id")
	if not isnumeric(m_id&"") then die echojson("500","��������","")
	yun.setmailid=m_id
	if not  yun.isnext then die echojson("500",yun.errarr.join(","),"")
	set p=newoption()
	yun.mysynmail()
	if yun.isnext then
		die echojson("200","ͬ���ɹ�","")
	Else
		die echojson("500",yun.errarr.join(","),"")
	end if

end sub
'�������ʾ�
sub renewsure()
	m_id=requesta("m_id")
	alreadypay=Requesta("alreadypay")
	if not isnumeric(alreadypay&"") or not isnumeric(m_id&"") then die echojson("500","��������","")
	yun.setmailid=m_id
	set dic=newoption()
	dic.add "alreadypay",alreadypay 
	price=yun.renewsure(dic)
	if yun.isnext then
		die echojson("200","���ѳɹ�","")
	Else
		die echojson("500",yun.errarr.join(","),"")
	end if
end sub

'��ȡ�۸�
sub getrenewprice()
	m_id=requesta("m_id")
	alreadypay=Requesta("alreadypay")
	if not isnumeric(alreadypay&"") or not isnumeric(m_id&"") then die echojson("500","��������","")
	yun.setmailid=m_id
	set dic=newoption()
	dic.add "alreadypay",alreadypay 
	price=yun.getrenewprice(dic,pricemsg)
	if yun.isnext then
		die echojson("200","ok",",""datas"":{""price"":"&price&",""pricemsg"":"""&pricemsg&"""}")
	Else
		die echojson("500",yun.errarr.join(","),"")
	end if
end sub

'��ȡ�����۸�
sub getupprice()
	m_id=requesta("m_id")
	m_free=requesta("m_free")
	postnum=requesta("postnum")
	if not isnumeric(postnum&"") or not isnumeric(m_free&"") or not isnumeric(m_id&"") then die echojson("500","��������","")
	yun.setmailid=m_id
	set dic=newoption()
	dic.add "postnum",postnum
	dic.add "m_free",m_free
	price=yun.getupgradeprice(dic,pricemsg)
	if yun.isnext then
		die echojson("200","ok",",""datas"":{""price"":"&price&",""pricemsg"":"""&pricemsg&"""}")
	Else
		die echojson("500",yun.errarr.join(","),"")
	end if
end sub

sub upsure()
	m_id=requesta("m_id")
	m_free=requesta("m_free")
	postnum=requesta("postnum")
	if not isnumeric(postnum&"") or not isnumeric(m_free&"") or not isnumeric(m_id&"") then die echojson("500","��������","") 
	yun.setmailid=m_id
	set dic=newoption()
	dic.add "postnum",postnum
	dic.add "m_free",m_free
 	yun.upsure(dic)
	if yun.isnext then
	 	die echojson("200","�����ɹ�","")
	Else
		die echojson("500",yun.errarr.join(","),"")
	end if
end sub

'��ȡ������Ϣ
sub getinfo()
	m_id=requesta("m_id")
	if not isnumeric(m_id&"") then die echojson("500","��������["&m_id&"]","")
	yun.setmailid=m_id
	if yun.isnext then
		die echojson("200","ok",",""datas"":"&aspjsonPrint(yun.dbdic)&"")
	Else
		die echojson("500",yun.errarr.join(","),"")
	end if
end sub
%>