<%
Class Qcdn_newsFun
Public function HTMLcode(fString)
if not isnull(fString) then
    fString = Replace(fString, ">", "&gt;")
    fString = Replace(fString, "<", "&lt;")

    fString = Replace(fString, CHR(32), " ")
    fString = Replace(fString, CHR(9), "&nbsp;")
    fString = Replace(fString, CHR(34), "&quot;")
    fString = Replace(fString, CHR(39), "&#39;")
    fString = Replace(fString, CHR(13), "")
    fString = Replace(fString, CHR(10) & CHR(10), "</P><P> ")
    fString = Replace(fString, CHR(10), "<BR> ")

    HTMLcode = fString
end if
end function

function sqlcheck(Str)
	if Instr(LCase(Str),"select ") > 0 or Instr(LCase(Str),"insert ") > 0 or Instr(LCase(Str),"delete ") > 0 or Instr(LCase(Str),"delete from ") > 0 or Instr(LCase(Str),"count(") > 0 or Instr(LCase(Str),"drop table") > 0 or Instr(LCase(Str),"update ") > 0 or Instr(LCase(Str),"truncate ") > 0 or Instr(LCase(Str),"asc(") > 0 or Instr(LCase(Str),"mid(") > 0 or Instr(LCase(Str),"char(") > 0 or Instr(LCase(Str),"xp_cmdshell") > 0 or Instr(LCase(Str),"exec master") > 0 or Instr(LCase(Str),"net localgroup administrators") > 0  or Instr(LCase(Str),"and ") > 0 or Instr(LCase(Str),"net user") > 0 or Instr(LCase(Str),"or ") > 0 then
		 Call Qcdn.Err_List("请不要在参数中包含非法字符尝试注入！",1)
		 Response.End
		 exit function
	end if
	Str=Replace(Str,"_","")     '过滤SQL注入_
	Str=Replace(Str,"*","")     '过滤SQL注入*
	Str=Replace(Str," ","")     '过滤SQL注入空格
	Str=Replace(Str,chr(34),"")   '过滤SQL注入"
	Str=Replace(Str,chr(39),"")            '过滤SQL注入'
	Str=Replace(Str,chr(91),"")            '过滤SQL注入[
	Str=Replace(Str,chr(93),"")            '过滤SQL注入]
	Str=Replace(Str,chr(37),"")            '过滤SQL注入%
	Str=Replace(Str,chr(58),"")            '过滤SQL注入:
	Str=Replace(Str,chr(59),"")            '过滤SQL注入;
	Str=Replace(Str,chr(43),"")            '过滤SQL注入+
	Str=Replace(Str,"{","")            '过滤SQL注入{
	Str=Replace(Str,"}","")            '过滤SQL注入}
	sqlcheck=Str            '返回经过上面字符替换后的Str
end function

Public Sub Toplist(num,field,id)
	if num = "" or field = "" then exit Sub
		if field = "week" then
			SqlT="SELECT top "& num &" Unid,Title,Nclassid,classid,pic FROM article_info where flag = 0 and DateDiff('d',intime,date())<=7 and Audit = 0 order by hits desc,title"
		else
			SqlT = "Select top "& num &" Unid,Title,Nclassid,classid,pic from article_info where flag = 0 and Audit = 0 order by "& field &" desc,title"
		end if	
	Set Rst = Conn.execute(SqlT)
	if Rst.eof and Rst.bof then
		Response.write "还没有添加文章。"
	else
		do while not Rst.eof
			Response.Write(bullet)
			if id = 1 then 
				Response.Write("[<a href=2j.asp?id="& Rst(3) &"&cid="& Rst(2) &" title="& Qcdn.ReplaceP(Rst(1)) &">"& Qcdn.Classlist(Rst(2)) &"</a>] ")
			end if
			Response.Write "<a href=list.asp?unid=" & Rst(0) &" target='"& AddOpenWin &"' title="& Qcdn.ReplaceP(Rst(1)) &">" & HTMLcode(GetString(Rst(1),60)) & "</a><br>"
		Rst.movenext
		loop
	end if
	Rst.close
end Sub


Public Function ReplaceP(str)
	ReplaceP = Replace(str,"""",chr(34))
End Function

Public sub Searchlist()
	Response.Write("<table align=center>")
	Response.Write("<tr>")
	Response.Write("<form method=post action=search.asp name=frmSearch>")
	Response.Write("<td align=center height=30>")
	Response.Write("<!----------- Search Start----------->")
	Response.Write("文章搜索：<input type=text name=keyword size=20>")
	Response.Write("<input type=radio name=where value=title checked>标题")
	Response.Write("<input type=radio name=where value=content>内容")
	Response.Write("<input type=radio name=where value=writer>作者")
	Response.Write("&nbsp;<script>function proLoadimg(){var i=new Image;i.src='image/search_over.gif';}proLoadimg();			  </script><input type='image' src='image/search.gif' onmouseover=""this.src='image/search_over.gif'"" onmouseout=""this.src='image/search.gif'"" align=absmiddle>")
	Response.Write("<!----------- Search End----------->")
	Response.Write("</td>")
	Response.Write("</form>")
	Response.Write("</tr>")
	Response.Write("</table>")
end sub

Public Function IsObjInstalled(strClassString)
	On Error Resume Next
	IsObjInstalled = False
	Err = 0
	Dim xTestObj
	Set xTestObj = Server.CreateObject(strClassString)
	If 0 = Err Then IsObjInstalled = True
	Set xTestObj = Nothing
	Err = 0
End Function

Public function isInteger(para)
       dim str
       dim l,i
       if isNUll(para) then 
          isInteger=false
          exit function
       end if
       str=cstr(para)
       if trim(str)="" then
          isInteger=false
          exit function
       end if
       l=len(str)
       for i=1 to l
           if mid(str,i,1)>"9" or mid(str,i,1)<"0" then
              isInteger=false 
              exit function
           end if
       next
       isInteger=true
end function


Public function GetString(str,strlen)
	dim l,t,c, i
	l=len(str)
	t=0
	for i=1 to l
	c=Abs(Asc(Mid(str,i,1)))
	if c>255 then
	t=t+2
	else
	t=t+1
	end if
	if t>=strlen then
	GetString=left(str,i)&"..."
	exit for
	else
	GetString=str&" "
	end if
	next
end function

Public function Classlist(id)
	if id = "" or isnull(id) then
		Classlist = ""
	else
		Sqld = "Select classname from article_class where unid = " & id
		Set rsd = conn.execute(Sqld)
		if not rsd.eof then
			Classlist = rsd(0)
		else
			Classlist = ""
		end if
		rsd.close
	end if
End function

Public function checkStr(str)
	if isnull(str) then
		checkStr = ""
		exit function 
	end if
	checkStr=replace(str,"'","''")
end function

Public sub Err_List(errmsg,var)
	Response.write"<BR><BR><table width=413 border=0 align=center cellpadding=0 cellspacing=0 bgcolor=#EEEAD6>"
Response.write"    <tr>"
Response.write"      <td height=29 colspan=3 background=image/topbg.gif> <table width=95% align=right border=0 cellspacing=0 cellpadding=0>"
Response.write"          <tr> "
Response.write"            <td align=left valign=middle><font color=#FFFFFF><B>系统提示信息</B></font></td>"
Response.write"            <td width=8% align=right><a href=# onclick=javascript:window.open('readme.htm','','width=640,height=300,left=100,top=10,scrollbars=yes')><img src=image/help.gif align=middle border=0 alt=帮助文档></a>&nbsp;</td>"
Response.write"          </tr>"
Response.write"        </table></td>"
Response.write"    </tr>"
Response.write"    <tr>"
Response.write"      <td width=3 background=image/link.GIF></td>"
Response.write"      <td><table width=100% border=0 cellspacing=0 cellpadding=0>"
Response.write"          <tr>"
Response.write"            <td height=50 background=image/bgtop.gif valign=top>"
Response.write"			<table width=100% height=75 border=0 cellpadding=0 cellspacing=0>"
Response.write"        <tr>"
Response.write"          <td width=30% align=left valign=bottom> <font color=#FFFFFF><img src=image/xpbg.gif width=409></td>"
Response.write"				</tr>"
Response.write"				</table>"
Response.write"</td>"
Response.write"          </tr>"
Response.write"          <tr>"
Response.write"            <td><table width=95% border=0 align=center> "
Response.write"	  <tr><td>"
Response.write"	  <fieldset><legend align=left>提示内容</legend> "
Response.write"	          <table width=100% border=0 cellspacing=2 cellpadding=2>"
Response.write"                <tr> "
Response.write"                  <td colspan=3 style=line-height:150% align=left>"& errmsg &"</td>"
Response.write"                </tr>"
Response.write"                <tr> "
	if var = 1 then
		Response.write "<tr><td colspan=3 align=center><input type=button name=button value=' 返 回 ' onclick=javascript:history.go(-1); class=tbutton></td></tr>"
	elseif var = 2 then
		Response.write "<tr><td colspan=3 align=center><input type=button name=button value=' 返 回 ' onclick=location.href='"& Request.ServerVariables("HTTP_REFERER") &"'  class=tbutton></td></tr>"
	elseif var = 3 then
		Response.write "<tr><td colspan=3 align=center><input type=button name=button value=' 关 闭 ' onclick=javascript:window.close(); class=tbutton></td></tr>"
	end if
Response.write"                </tr>"
Response.write"              </table>"
Response.write"	  </fieldset> "
Response.write"	  &nbsp;</td></tr>"
Response.write"	  </table></td>"
Response.write"          </tr>"
Response.write"        </table></td>"
Response.write"      <td width=3 background=image/link.GIF></td>"
Response.write"    </tr>"
Response.write"	<tr><td height=3 background=image/linkbom.GIF colspan=3></td></tr>"
Response.write"  </table> <body></html>"
End Sub

Public Sub OptionList(id)
	SqlS = "Select top 50 setname from article_setting where flag = "& id &" order by Unid desc"
	Set RsS = Conn.execute(SqlS)
	if RsS.eof and RsS.bof then
		Response.Write("<option></option>")
	else
		do while not RsS.eof
			Response.Write("<option value='"& HTMLcode(RsS(0)) &"'>"& HTMLcode(RsS(0)) &"</option>")
		RsS.movenext
		loop
	end if
	RsS.close : set RsS = nothing
End Sub

Public Sub ClassOptionlist()
			sqlc = "Select Unid,Classname,flag from article_class where flag <> 0 order by Unid asc"
			Set Rsc = Conn.execute(sqlc)
			if not Rsc.eof then
				do while not Rsc.eof
					Response.write "<option value="& Rsc(0) &"|"& Rsc(2) &">---|"& Rsc(1) &"</option>"
				Rsc.movenext
				loop
			else
				Response.write "<option value=>还没有添加栏目</option>"
			end if
			Rsc.close
End Sub

Public function Ubbcode(strContent)


dim re,ii,po
dim reContent
Set re=new RegExp
re.IgnoreCase =true
re.Global=True

	strContent=Replace(strContent,"file:","file :")
	strContent=Replace(strContent,"files:","files :")
	strContent=Replace(strContent,"script:","script :")
	strContent=Replace(strContent,"js:","js :")

re.Pattern="\[IMG\](http|https|ftp):\/\/(.[^\[]*)\[\/IMG\]"
strContent=re.Replace(strContent,"<a onfocus=this.blur() href=""$1://$2"" target=_blank><IMG SRC=""$1://$2"" border=0 alt=按此在新窗口浏览图片 onload=""javascript:if(this.width>screen.width-333)this.width=screen.width-333""></a>")

re.Pattern="\[UPLOAD=(gif|jpg|jpeg|bmp)\](.[^\[]*)(gif|jpg|jpeg|bmp)\[\/UPLOAD\]"
strContent= re.Replace(strContent,"<br><IMG SRC=""image/$1.gif"" border=0>此主题相关链接如下：<br><A HREF=""$2$1"" TARGET=_blank><IMG SRC=""$2$1"" border=0 alt=按此在新窗口浏览图片 onload=""javascript:if(this.width>screen.width-333)this.width=screen.width-333""></A>")

re.Pattern="\[UPLOAD=(doc|xls|ppt|htm|swf|rar|zip|exe)\](.[^\[]*)(doc|xls|ppt|htm|swf|rar|zip|exe)\[\/UPLOAD\]"
strContent= re.Replace(strContent,"<br><IMG SRC=""image/$1.gif"" border=0>此主题相关链接如下：<br><a href=""$2$1"" target='_blank'>点击浏览该文件</a>")


re.Pattern="(\[FLASH\])(http://.[^\[]*(.swf))(\[\/FLASH\])"
strContent= re.Replace(strContent,"<a href=""$2"" TARGET=_blank><IMG SRC=image/swf.gif border=0 alt=点击开新窗口欣赏该FLASH动画! height=16 width=16>[全屏欣赏]</a><br><center><OBJECT codeBase=http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=4,0,2,0 classid=clsid:D27CDB6E-AE6D-11cf-96B8-444553540000 width=500 height=400><PARAM NAME=movie VALUE=""$2""><PARAM NAME=quality VALUE=high><embed src=""$2"" quality=high pluginspage='http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash' type='application/x-shockwave-flash' width=500 height=400>$2</embed></OBJECT></center>")

re.Pattern="(\[FLASH=*([0-9]*),*([0-9]*)\])(http://.[^\[]*(.swf))(\[\/FLASH\])"
strContent= re.Replace(strContent,"<a href=""$4"" TARGET=_blank><IMG SRC=image/swf.gif border=0 alt=点击开新窗口欣赏该FLASH动画! height=16 width=16>[全屏欣赏]</a><br><center><OBJECT codeBase=http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=4,0,2,0 classid=clsid:D27CDB6E-AE6D-11cf-96B8-444553540000 width=$2 height=$3><PARAM NAME=movie VALUE=""$4""><PARAM NAME=quality VALUE=high><embed src=""$4"" quality=high pluginspage='http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash' type='application/x-shockwave-flash' width=$2 height=$3>$4</embed></OBJECT></center>")


re.Pattern="(\[URL\])(.[^\[]*)(\[\/URL\])"
strContent= re.Replace(strContent,"<A HREF=""$2"" TARGET=_blank>$2</A>")
re.Pattern="(\[URL=(.[^\[]*)\])(.[^\[]*)(\[\/URL\])"
strContent= re.Replace(strContent,"<A HREF=""$2"" TARGET=_blank>$3</A>")

re.Pattern="(\[EMAIL\])(\S+\@.[^\[]*)(\[\/EMAIL\])"
strContent= re.Replace(strContent,"<img align=absmiddle src=image/email1.gif><A HREF=""mailto:$2"">$2</A>")
re.Pattern="(\[EMAIL=(\S+\@.[^\[]*)\])(.[^\[]*)(\[\/EMAIL\])"
strContent= re.Replace(strContent,"<img align=absmiddle src=image/email1.gif><A HREF=""mailto:$2"" TARGET=_blank>$3</A>")

'自动识别网址
re.Pattern = "^((http|https|ftp|rtsp|mms):(\/\/|\\\\)[A-Za-z0-9\./=\?%\-&_~`@[\]\':+!]+)"
strContent = re.Replace(strContent,"<img align=absmiddle src=image/url.gif border=0><a target=_blank href=$1>$1</a>")
re.Pattern = "((http|https|ftp|rtsp|mms):(\/\/|\\\\)[A-Za-z0-9\./=\?%\-&_~`@[\]\':+!]+)$"
strContent = re.Replace(strContent,"<img align=absmiddle src=image/url.gif border=0><a target=_blank href=$1>$1</a>")
re.Pattern = "([^>=""])((http|https|ftp|rtsp|mms):(\/\/|\\\\)[A-Za-z0-9\./=\?%\-&_~`@[\]\':+!]+)"
strContent = re.Replace(strContent,"$1<img align=absmiddle src=image/url.gif border=0><a target=_blank href=$2>$2</a>")

'自动识别www等开头的网址
re.Pattern = "([^(http://|http:\\)])((www|cn)[.](\w)+[.]{1,}(net|com|cn|org|cc)(((\/[\~]*|\\[\~]*)(\w)+)|[.](\w)+)*(((([?](\w)+){1}[=]*))*((\w)+){1}([\&](\w)+[\=](\w)+)*)*)"
strContent = re.Replace(strContent,"<img align=absmiddle src=image/url.gif border=0><a target=_blank href=http://$2>$2</a>")


re.Pattern="\[color=(.[^\[]*)\](.[^\[]*)\[\/color\]"
strContent=re.Replace(strContent,"<font color=$1>$2</font>")
re.Pattern="\[face=(.[^\[]*)\](.[^\[]*)\[\/face\]"
strContent=re.Replace(strContent,"<font face=$1>$2</font>")
re.Pattern="\[align=(center|left|right)\](.*)\[\/align\]"
strContent=re.Replace(strContent,"<div align=$1>$2</div>")

re.Pattern="\[SHADOW=*([0-9]*),*(#*[a-z0-9]*),*([0-9]*)\](.[^\[]*)\[\/SHADOW]"
strContent=re.Replace(strContent,"<table width=$1 ><tr><td style=""filter:shadow(color=$2, strength=$3)"">$4</td></tr></table>")
re.Pattern="\[GLOW=*([0-9]*),*(#*[a-z0-9]*),*([0-9]*)\](.[^\[]*)\[\/GLOW]"
strContent=re.Replace(strContent,"<table width=$1 ><tr><td style=""filter:glow(color=$2, strength=$3)"">$4</td></tr></table>")

re.Pattern="\[MP=*([0-9]*),*([0-9]*)\](.[^\[]*)\[\/MP]"
strContent=re.Replace(strContent,"<object align=middle classid=CLSID:22d6f312-b0f6-11d0-94ab-0080c74c7e95 class=OBJECT id=MediaPlayer width=$1 height=$2 ><param name=ShowStatusBar value=-1><param name=Filename value=$3><embed type=application/x-oleobject codebase=http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701 flename=mp src=$3  width=$1 height=$2></embed></object>")


re.Pattern="\[RM=*([0-9]*),*([0-9]*)\](.[^\[]*)\[\/RM]"
strContent=re.Replace(strContent,"<OBJECT classid=clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA class=OBJECT id=RAOCX width=$1 height=$2><PARAM NAME=SRC VALUE=$3><PARAM NAME=CONSOLE VALUE=Clip1><PARAM NAME=CONTROLS VALUE=imagewindow><PARAM NAME=AUTOSTART VALUE=true></OBJECT><br><OBJECT classid=CLSID:CFCDAA03-8BE4-11CF-B84B-0020AFBBCCFA height=32 id=video2 width=$1><PARAM NAME=SRC VALUE=$3><PARAM NAME=AUTOSTART VALUE=-1><PARAM NAME=CONTROLS VALUE=controlpanel><PARAM NAME=CONSOLE VALUE=Clip1></OBJECT>")

re.Pattern="\[CENTER](.[^\[]*)\[\/CENTER]"
strContent=re.Replace(strContent,"<center>$1</center>")
re.Pattern="\[i\](.[^\[]*)\[\/i\]"
strContent=re.Replace(strContent,"<i>$1</i>")
re.Pattern="\[u\](.[^\[]*)(\[\/u\])"
strContent=re.Replace(strContent,"<u>$1</u>")
re.Pattern="\[b\](.[^\[]*)(\[\/b\])"
strContent=re.Replace(strContent,"<b>$1</b>")
re.Pattern="\[size=([1-4])\](.[^\[]*)\[\/size\]"
strContent=re.Replace(strContent,"<font size=$1>$2</font>")
strContent=replace(strContent,"<I></I>","")
set re=Nothing
Ubbcode=strContent
end function


    Public sub Jmail(YouMail,SendEmail,topic,mailbody)
	on error resume next
	dim JMail

	Set JMail=Server.CreateObject("JMail.SMTPMail")
	JMail.Logging=True
	JMail.Charset="gb2312"
	JMail.ContentType = "text/html"
	JMail.ServerAddress=Smtp
	JMail.Sender=YouMail
	JMail.Subject=topic
	JMail.Body=mailbody
	JMail.AddRecipient SendEmail
	JMail.Priority=1
	'JMail.MailServerUserName = "qcsky@qcsky.com" '您的邮件服务器登录名
	'JMail.MailServerPassword = "admin" '登录密码
	JMail.Execute 
	Set JMail=nothing 
	if err then 
	MailStr=err.description
	err.clear
	else
	MailStr="OK"
	end if
    end sub

    Public sub Cdonts(YouMail,SendEmail,topic,mailbody)
	on error resume next
	dim  objCDOMail
	Set objCDOMail = Server.CreateObject("CDONTS.NewMail")
	objCDOMail.From =YouMail
	objCDOMail.To =SendEmail
	objCDOMail.Subject =topic
	objCDOMail.BodyFormat = 0 
	objCDOMail.MailFormat = 0 
	objCDOMail.Body =mailbody
	objCDOMail.Send
	Set objCDOMail = Nothing
	if err then 
	MailStr=err.description
	err.clear
	else
	MailStr="OK"
	end if
    end sub

    Public sub aspemail(YouMail,SendEmail,topic,mailbody)
	on error resume next
	dim mailer,recipient,sender,subject,message
	dim mailserver,result
	Set mailer=Server.CreateObject("ASPMAIL.ASPMailCtrl.1")  
	recipient=SendEmail
	sender=YouMail
	subject=topic
	message=mailbody
	mailserver=Forum_info(4)
	result=mailer.SendMail(mailserver, recipient, sender, subject, message)
	if err then 
	MailStr=err.description
	err.clear
	else
	MailStr="OK"
	end if
    end sub

Public function IsValidEmail(email)

dim names, name, i, c

	IsValidEmail = true
	names = Split(email, "@")
	if UBound(names) <> 1 then
	   IsValidEmail = false
	   exit function
	end if
	for each name in names
	   if Len(name) <= 0 then
		 IsValidEmail = false
	     exit function
	   end if
	   for i = 1 to Len(name)
		 c = Lcase(Mid(name, i, 1))
	     if InStr("abcdefghijklmnopqrstuvwxyz_-.", c) <= 0 and not IsNumeric(c) then
	       IsValidEmail = false
		   exit function
	     end if
	   next
	   if Left(name, 1) = "." or Right(name, 1) = "." then
		  IsValidEmail = false
	      exit function
	   end if
	next
	if InStr(names(1), ".") <= 0 then
	   IsValidEmail = false
	   exit function
	end if
	i = Len(names(1)) - InStrRev(names(1), ".")
	if i <> 2 and i <> 3 then
	   IsValidEmail = false
	   exit function
	end if
	if InStr(email, "..") > 0 then
	   IsValidEmail = false
	end if
end function

public Sub MenuJsList()
	Response.write "<script language=javascript1.2>"
	Sql = "SELECT flag from article_class where flag<>0 group by flag "
	Set Rs = conn.execute(Sql)
	if not rs.eof then
		do while not rs.eof
			Response.write "linkset["& Rs(0) &"]=new Array()" & vbcrlf
			SqlStr = "Select Unid,Classname from article_class where flag = "& Rs(0) &" order by orderflag asc"
			Set RsStr = conn.execute(SqlStr)
			if not RsStr.eof then
				dim i 
				i = 0
				do while not RsStr.eof
					Response.write "linkset["& Rs(0) &"]["& i &"]='<div class=""menuitems""><a href=""2j.asp?id="& Rs(0) &"&cid="& RsStr(0) &""">"& RsStr(1) &"</a></div>'" & vbcrlf
				RsStr.movenext
				i = i + 1
				loop
			end if
			RsStr.close
		rs.movenext
		loop
	end if
	rs.close
	Response.write "</script>"
end Sub


Public Function FormatTime(str)
	dim s,t
	s = Month(str)
	if len(s)<2 then
		s = "0" & s
	end if
	t = Day(str)
	if len(t)<2 then
		t = "0" & t
	end if
	FormatTime = s & "-" & t
end function

Public Function StrLength(str)
		If IsNull(str) or Str = "" Then
			StrLength = 0
			Exit Function
		End If
		Dim WINNT_CHINESE
		WINNT_CHINESE=(len("青创")=2)
		If WINNT_CHINESE then
			Dim l,t,c
			Dim i
			l=len(str)
			t=l
			For i=1 to l
				c=asc(mid(str,i,1))
				If c<0 Then c=c+65536
				If c>255 Then
					t=t+1
				End If
			Next
			strLength=t
		Else 
			strLength=Len(str)
		End If
	End Function

Public Function UnFixStrs(Vari)
    If Vari = "" Then
      UnFixStrs = ""
      Exit Function
   End If
     UnFixStrs = Replace(Vari, "&quot;","""" )
     UnFixStrs = Replace(UnFixStrs, "&#39","'" )
     UnFixStrs = Replace(UnFixStrs, "&lt","<" )
     UnFixStrs = Replace(UnFixStrs, "&gt",">" )
     UnFixStrs = Replace(UnFixStrs, "&#124","|" )
     UnFixStrs = Replace(UnFixStrs,"&#44" ,"," )
     UnFixStrs = Replace(UnFixStrs,"&nbsp;" ," " )
     UnFixStrs = Replace(UnFixStrs,"&#40;" ,"(" ) 
     UnFixStrs = Replace(UnFixStrs,"&#41;" ,")" )
     UnFixStrs = Replace(UnFixStrs,"<BR>" ,CHR(13))
	 UnFixStrs = Replace(UnFixStrs,"</P><P>" ,CHR(10) & CHR(10))
End Function

Public Function RemarkCount(userstr)
	sqlus = "Select count(Unid) from article_remark where username = '"& userstr &"'"
	set rsus = conn.execute(sqlus)
	if rsus.eof and rsus.bof then
		RemarkCount = 0
	else
		RemarkCount = rsus(0)
	end if
	rsus.close : set rsus = nothing
End Function

End Class
%>