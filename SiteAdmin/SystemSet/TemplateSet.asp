<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(1)%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<script language=javascript>
function domanagertpl(){
	document.form1.Act.value="modemanager";
	document.form1.submit();
}
</script>

<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>系 统 设 置</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771">&nbsp;</td>
  </tr>
</table>

<br>
<%
set fso=server.CreateObject(objName_FSO)

Act=requesta("Act")
if Act="Modi" then
	set file=fso.opentextfile(server.mappath("/config/const.asp"),1)
	MB=file.readall
	file.close 
	set file = nothing
	
	Set rea = New RegExp
	rea.IgnoreCase=true
	rea.Pattern="(USEtemplate)\s*=\s*""([^'""\n\r]*)"""
	MB=rea.replace(MB,"$1=""" & requesta("TempName") & """")
	set file=fso.createtextfile(server.mappath("/config/const.asp"),true) 
	file.write MB
	file.close 
	set file = nothing 

	application("services_cloudhost_html_")=""
	application("services_cloudhost_html_1")=""
	application("services_cloudhost_html_2")=""
	application("services_cloudhost_html_3")=""
	application("services_cloudhost_html_4")=""
	application("services_cloudhost_html_5")=""
	application("services_cloudhost_html_7")=""

	alert_redirect "修改成功" ,"TemplateSet.asp"
elseif Act="modemanager" then
	set file=fso.opentextfile(server.mappath("/config/const.asp"),1)
	MB=file.readall
	file.close 
	set file = nothing
	
	Set rea = New RegExp
	rea.IgnoreCase=true
	rea.Pattern="(USEmanagerTpl)\s*=\s*""([^'""\n\r]*)"""
	MB=rea.replace(MB,"$1=""" & requesta("tpl_manager") & """")
	set file=fso.createtextfile(server.mappath("/config/const.asp"),true) 
	file.write MB
	file.close 
	set file = nothing
		call moditplCss(requesta("tpl_manager"))
	alert_redirect "修改成功" ,"TemplateSet.asp"
end if

TemplatePath=InstallDir&"Template/"
set FloObj=fso.getfolder(server.MapPath(TemplatePath))
set subFolderObj=FloObj.SubFolders

%>

<table width="100%" border="0" cellpadding="5" cellspacing="0" class="border">
  <form id="form1" name="form1" method="post" action="">
  	<tr>
    <td class="tdbg">前台界面模板设置
    </td>
    </tr>
    <tr> 
      <td class="tdbg">
        <table width="100%" border="0" cellpadding="4" cellspacing="2">

          <tr> 
            <%
i=0
for each subfolder in subFolderObj
	i=i+1
	TempFoderName=subfolder.name
	'set TempFolder=fso.getfolder(server.MapPath(TemplatePath&"/"&TempFoderName&"/"))
	VPicPath=server.MapPath(TemplatePath&TempFoderName&"/p_view.jpg")

	if fso.FileExists(VPicPath) then
		PicPath=TemplatePath&TempFoderName&"/p_view.jpg"
	else
		PicPath=TemplatePath&"p_view.jpg"
	end if
%>
            <td align="center"> 
              <table border="0" cellpadding="4" cellspacing="0" <%if USEtemplate=TempFoderName then%>bgcolor="#CCCCCC"<%end if%>>
                <tr> 
                  <td>
                    <table border="0" cellpadding="0" cellspacing="0" class="border">
                      <tr> 
                        <td><img src="<%=PicPath%>" alt="" width="135" height="97" /></td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td align="center"><%=TempFoderName%></td>
                </tr>
                <tr> 
                  <td align="center">
                    <input name="TempName" type="radio" id="radio" value="<%=TempFoderName%>" <%if USEtemplate=TempFoderName then%>checked<%end if%>>
                    使用此模板</td>
                </tr>
              </table>
            </td>
            <%
	if i mod 5 = 0 then
		response.Write("</tr>")
	end if
next
%>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td align="center" class="tdbg">
        <input type="submit" name="button" id="button" value="　确定使用选中模板　">
        <input name="Act" type="hidden" id="Act" value="Modi">
      </td>
    </tr>
    <tr>
      <td align="center" class="tdbg">
        <div align="left">模板设置说明：<br>
          本系统采用代码和网页模板分离的开发技术，使得网站的界面修改变得异常简单。通过切换系统内置的模板，可以直接改变网站前台的样式。<br>
          Tpl_01～Tpl_100是系统预留模板范围。如果您要开发自己特有的界面，请先将/Template/Tpl_01/目录的全部内容下载至您本地电脑，并将Tpl_01目录更名为：TPl_101。通过Dreamweaver和Photoshop等工具修改TPl_101目录的html文件和图片达到改版的目的。修改完毕后将TPl_101目录上传至网站的/Template/下，然后在这里设置为使用TPl_101模板即可。<a href="http://help.west.cn/help/list.asp?unid=366" target="_blank"><font color="#0000FF">模板修改指南</font></a></div>
      </td>
    </tr>
<!--    <tr>
    <td>前台用户管理中心模板设置
    </td>
    </tr>
    <tr>
    <td>
    <%
	if USEmanagerTpl="" then USEmanagerTpl="1"
	%>
    <input type="radio" value="1" name="tpl_manager" <%if USEmanagerTpl="1" then response.write " checked"%>>用户管理中心模板1
    <input type="radio" value="2" name="tpl_manager" <%if USEmanagerTpl="2" then response.write " checked"%>>用户管理中心模板2
    <input type=button value="确定使用选中模板" onClick="domanagertpl()">
    </td>
    </tr>
-->
  </form>
</table>
</body>
</html>
<%
Function FixName(UpFileExt)
	If IsEmpty(UpFileExt) Then Exit Function
	FixName = Lcase(Trim(UpFileExt))
	FixName = Replace(FixName,Chr(0),"")
	FixName = Replace(FixName,".","")
	FixName = Replace(FixName,"asp","")
	FixName = Replace(FixName,"asa","")
	FixName = Replace(FixName,"aspx","")
	FixName = Replace(FixName,"cer","")
	FixName = Replace(FixName,"cdx","")
	FixName = Replace(FixName,"htr","")
End Function

Private Function UserFaceName(FileExt)
	Dim RanNum
	Randomize
	RanNum = Int(90000*rnd)+10000
 	UserFaceName = Year(now)&Month(now)&Day(now)&Hour(now)&Minute(now)&Second(now)&RanNum&"."&FileExt
End Function

Private Function CheckFileExt(FileExt)
	Dim ForumUpload,i
	ForumUpload=UpFileType
	ForumUpload=Split(ForumUpload,",")
	CheckFileExt=False
	For i=0 to UBound(ForumUpload)
		If LCase(FileExt)=Lcase(Trim(ForumUpload(i))) Then
			CheckFileExt=True
			Exit Function
		End If
	Next
End Function

Private Function CheckFileType(FileType)
	CheckFileType = False
	If Left(Cstr(Lcase(Trim(FileType))),6)="image/" Then CheckFileType = True
End Function
function moditplCss(byval pp)
	cssstr=".topbg"
	newstr=" display:none;"
	cssfileName=server.mappath("/manager/css/admin_style.css")
	if pp="2" then
		call addconstrstr(cssfileName,cssstr,newstr)
	else
		call delconststr(cssfileName,newstr)
	end if
end function
function addconstrstr(byval Filename,byval seatstr,byval newstr)
	endstr=""
	Set fsoobj = CreateObject("Scripting.FileSystemObject")
	If fsoobj.FileExists(Filename) Then 
        set hndFile = fsoobj.OpenTextFile(Filename)
        LoadFile = hndFile.ReadAll
        Set hndFile = Nothing
	end if
	if not isnull(loadfile) and loadfile<>"" and instr(LoadFile,newstr)=0 then
		loadfile=trim(loadfile)
		allarr=split(loadFile,seatstr)
		if ubound(allarr)>0 then
			pos=instr(allarr(1),vbcrlf)
			
			if pos>0 then
				nstr=mid(allarr(1),1,pos)
				ostr=mid(allarr(1),pos)
				endstr=allarr(0) & seatstr & nstr & vbcrlf & newstr & ostr
				if instr(endstr,newstr)>0 then
				 Set OutStream = fsoobj.OpenTextFile(Filename,2,True)
					OutStream.Write endstr
				 set OutStream=nothing
				end if
			end if
		end if
		
	end if
    Set fsoobj = Nothing
end function
function delconststr(byval Filename,byval delarr)
	Set fsoobj = CreateObject("Scripting.FileSystemObject")
	If fsoobj.FileExists(Filename) Then 
        set hndFile = fsoobj.OpenTextFile(Filename)
        LoadFile = hndFile.ReadAll
        Set hndFile = Nothing
	end if


		delstritem=trim(delarr)
		if not isnull(loadfile) and loadfile<>"" and instr(LoadFile,delstritem)>0 then
			allarr=split(loadFile,delstritem)
			if ubound(allarr)>0 then
				pos=instr(allarr(1),vbcrlf)
				
				if pos>0 then
					nstr=mid(allarr(1),pos + 1)
					 LoadFile=allarr(0) & nstr
				end if
			end if
		end if

					if LoadFile<>"" then
					 Set OutStream = fsoobj.OpenTextFile(Filename,2,True)'打开文件并写入文件不存在就创建
						OutStream.Write LoadFile
					 set OutStream=nothing
					end if
    Set fsoobj = Nothing
end function
%>