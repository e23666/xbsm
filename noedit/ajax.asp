<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<%response.charset="gb2312"
act=requesta("act")
userid=session("u_sysid")
user_name=session("user_name")
If Not isnumeric(userid&"") Then userid=0

Select Case Trim(act)
Case "gettopnews"
	Call gettopnews()
Case "getmyyeweuinfo"   '
	Call getmyyeweuinfo()
End Select
Sub gettopnews()
	conn.open constr
	sql="select top 5 newstitle,newsman,newpubtime,newsshow,newpic,html,newsid from news order by newsid desc"
	Set trs=conn.execute(sql)
	tempstr=""
	Set arr=newarray()

	Do While Not trs.eof
		title_=trs("newstitle")
		time_=FormatDateTime(trs("newpubtime"),2)
		day_=datediff("D",trs("newpubtime"),now())
		id_=trs("newsid")
		Set newsdicline=newoption()
		newsdicline.add "title",title_
		newsdicline.add "time",time_
		newsdicline.add "day",day_
		newsdicline.add "id",id_
		arr.push(newsdicline)
'		If Trim(tempstr)="" Then
'			tempstr="{""title"":"""&vbsEscape(trs("newstitle"))&""",""time"":"""&FormatDateTime(trs("newpubtime"),2)&""",""day"":"&datediff("D",trs("newpubtime"),now())&",""id"":"&trs("newsid")&"}"
'		Else
'			tempstr=tempstr&",{""title"":"""&vbsEscape(trs("newstitle"))&""",""time"":"""&FormatDateTime(trs("newpubtime"),2)&""",""day"":"&datediff("D",trs("newpubtime"),now())&",""id"":"&trs("newsid")&"}"
'		End if
	trs.movenext
	Loop
	Set retdic=newoption()
	retdic.add "result","200"
	retdic.add "datas",arr
	die aspjsonprint(retdic)
End Sub

Sub getmyyeweuinfo()
conn.open constr
	Dim dm,vh,ser,mail,db
	dm=Array(0,0,0)
	vh=Array(0,0,0)
	ser=Array(0,0,0)
	mail=Array(0,0,0)
	db=Array(0,0,0)
	 
	If CLng(userid)>0 then
	tsql="select 'dm' as ywname,count(1) as tj  from domainlist where userid="&userid&" union "&_
			  "select 'vh' as ywname,count(1) as tj from vhhostlist where S_ownerid="&userid&" union "&_
			  "select 'ser' as ywname,count(1) as tj from hostrental where start="&PE_True&" and u_name='"&user_name&"' union "&_
			  "select 'mail'  as ywname,count(1) as tj from mailsitelist where m_ownerid="&userid&" union "&_
			  "select 'db'  as ywname,count(1) as tj from databaselist where dbu_id="&userid
	Set trs=conn.execute(tsql)
	Do While Not trs.eof
		Select Case Trim(trs("ywname"))
		Case "dm"
			dm(0)=trs("tj")
		Case "vh"
			vh(0)=trs("tj")
		Case "ser"
			ser(0)=trs("tj")
		Case "mail"
			mail(0)=trs("tj")
		Case "db"
			db(0)=trs("tj")
		End select
	trs.movenext
	Loop
	trs.close
	If isdbsql Then
		tsql="select 'dm' as ywname,count(1) as tj  from domainlist where userid="&userid&"  and dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_Y&",years,regdate)) between 1 and 30  union "&_
		"select 'vh' as ywname,count(1) as tj from vhhostlist where S_ownerid="&userid&" and  dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_Y&",s_year,s_buydate)) between 1 and 30  union "&_
		"select  'ser' as ywname,count(1) as tj from hostrental where start="&PE_True&" and u_name='"&user_name&"' and dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_D&",isnull(preday,0),DateAdd("&PE_DatePart_M&",AlreadyPay,starttime))) between 1 and 30   union "&_
		"select 'mail'  as ywname,count(1) as tj from mailsitelist where m_ownerid="&userid&" and  m_free=0 and dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_Y&",m_years,m_buydate)) between 1 and 30   union "&_
		"select 'db'  as ywname,count(1) as tj from databaselist where dbu_id="&userid&" and dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_Y&",dbyear,dbbuydate)) between 1 and 30"


	else
		tsql="select 'dm' as ywname,count(1) as tj  from domainlist where userid="&userid&"  and dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_Y&",years,regdate)) between 1 and 30  union "&_
		"select 'vh' as ywname,count(1) as tj from vhhostlist where S_ownerid="&userid&" and  dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_Y&",s_year,s_buydate)) between 1 and 30  union "&_
		"select  'ser' as ywname,count(1) as tj from hostrental where start="&PE_True&" and u_name='"&user_name&"' and dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_D&",iif(isnull(preday),0,preday),DateAdd("&PE_DatePart_M&",AlreadyPay,starttime))) between 1 and 30   union "&_
		"select 'mail'  as ywname,count(1) as tj from mailsitelist where m_ownerid="&userid&" and  m_free=0 and dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_Y&",m_years,m_buydate)) between 1 and 30   union "&_
		"select 'db'  as ywname,count(1) as tj from databaselist where dbu_id="&userid&" and dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_Y&",dbyear,dbbuydate)) between 1 and 30"
	End if
	Set trs=conn.execute(tsql)
	Do While Not trs.eof
		Select Case Trim(trs("ywname"))
		Case "dm"
	 
			dm(1)=trs("tj")
		Case "vh"
			vh(1)=trs("tj")
		Case "ser"
			ser(1)=trs("tj")
		Case "mail"
			mail(1)=trs("tj")
		Case "db"
			db(1)=trs("tj")
		End select
	trs.movenext
	Loop
	trs.close
	If isdbsql Then
		tsql="select 'dm' as ywname,count(1) as tj  from domainlist where userid="&userid&"  and dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_Y&",years,regdate))<=0  union "&_
		"select 'vh' as ywname,count(1) as tj from vhhostlist where S_ownerid="&userid&" and  dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_Y&",s_year,s_buydate))<=0  union "&_
		"select  'ser' as ywname,count(1) as tj from hostrental where start="&PE_True&" and u_name='"&user_name&"' and dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_D&",isnull(preday,0),DateAdd("&PE_DatePart_M&",AlreadyPay,starttime))) <=0   union "&_
		"select 'mail'  as ywname,count(1) as tj from mailsitelist where m_ownerid="&userid&" and  m_free=0 and dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_Y&",m_years,m_buydate))<=0   union "&_
		"select 'db'  as ywname,count(1) as tj from databaselist where dbu_id="&userid&" and dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_Y&",dbyear,dbbuydate))<=0"
	else
		tsql="select 'dm' as ywname,count(1) as tj  from domainlist where userid="&userid&"  and dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_Y&",years,regdate))<=0  union "&_
		"select 'vh' as ywname,count(1) as tj from vhhostlist where S_ownerid="&userid&" and  dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_Y&",s_year,s_buydate))<=0  union "&_
		"select  'ser' as ywname,count(1) as tj from hostrental where start="&PE_True&" and u_name='"&user_name&"' and dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_D&",iif(isnull(preday),0,preday),DateAdd("&PE_DatePart_M&",AlreadyPay,starttime))) <=0   union "&_
		"select 'mail'  as ywname,count(1) as tj from mailsitelist where m_ownerid="&userid&" and  m_free=0 and dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_Y&",m_years,m_buydate))<=0   union "&_
		"select 'db'  as ywname,count(1) as tj from databaselist where dbu_id="&userid&" and dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_Y&",dbyear,dbbuydate))<=0"
	End if
	Set trs=conn.execute(tsql)
	Do While Not trs.eof
		Select Case Trim(trs("ywname"))
		Case "dm"
			dm(2)=trs("tj")
		Case "vh"
			vh(2)=trs("tj")
		Case "ser"
			ser(2)=trs("tj")
		Case "mail"
			mail(2)=trs("tj")
		Case "db"
			db(2)=trs("tj")
		End select
	trs.movenext
	Loop
	trs.close
 
	 
   
	End If
	conn.close
	 die "{""result"":""200"",""msg"":"""",""datas"":[{""domain"":["&join(dm,",")&"]},{""vhost"":["&join(vh,",")&"]},{""server"":["&join(ser,",")&"]},{""mail"":["&join(mail,",")&"]},{""db"":["&join(db,",")&"]}]}"
End sub


Function vbsEscape(str) 
	vbsEscape=Str
	Exit function
    dim i,s,c,a 
    s="" 
    For i=1 to Len(str) 
        c=Mid(str,i,1) 
        a=ASCW(c) 
        If (a>=48 and a<=57) or (a>=65 and a<=90) or (a>=97 and a<=122) Then 
            s = s & c 
        ElseIf InStr("@*_+-./",c)>0 Then 
            s = s & c 
        ElseIf a>0 and a<16 Then 
            s = s & "%0" & Hex(a) 
        ElseIf a>=16 and a<256 Then 
            s = s & "%" & Hex(a) 
        Else 
            s = s & "%u" & Hex(a) 
        End If 
    Next 
    vbsEscape = s 
End Function

Function vbsUnEscape(str) 
    dim i,s,c 
    s="" 
    For i=1 to Len(str) 
        c=Mid(str,i,1) 
        If Mid(str,i,2)="%u" and i<=Len(str)-5 Then 
            If IsNumeric("&H" & Mid(str,i+2,4)) Then 
                s = s & CHRW(CInt("&H" & Mid(str,i+2,4))) 
                i = i+5 
            Else 
                s = s & c 
            End If 
        ElseIf c="%" and i<=Len(str)-2 Then 
            If IsNumeric("&H" & Mid(str,i+1,2)) Then 
                s = s & CHRW(CInt("&H" & Mid(str,i+1,2))) 
                i = i+2 
            Else 
                s = s & c 
            End If 
        Else 
            s = s & c 
        End If 
    Next 
    vbsUnEscape = s 
End Function 
%>