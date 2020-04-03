<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/upfile_class.asp" -->
<%Check_Is_Master(1)%>
<%
act=requesta("act")
if act<>"" and isnumeric(act) then
	set upfile=new upfile_class
	savem=5 '最大设为5M
	maxfilesize=savem * 1024 * 1024
	allowfiletype="gif;jpg;bmp;jpeg;png"
	upfile.GetData maxfilesize
	upfile.AllowExt=allowfiletype
	if not echoupfileerr(upfile,errstr) then url_return errstr,-1
	
	select case act
		case 1'logo
				formname="file1"
				focpath="/images"
				FileName="logo"'将保存的文件名
				FSPath=server.mappath(focpath) & "/"
				set oFile=upfile.file(formname)
				oldFileName=oFile.filename
				oldFilesuffix=upfile.GetFileExt(oldFileName)'文件后辍
				if not upfile.isAllowExt(oldFilesuffix) then url_return "抱歉,上传类型错误,只允许:"& allowfiletype,-1
				set oFile=nothing
				FileName=FileName & "." & oldFilesuffix
				upfile.SaveToFile formname,FSPath & FileName  ''保存文件
				 if upfile.iserr then 
				 	set upfile=nothing
					url_return upfile.errmessage,-1
				 else
				 	set upfile=nothing
				 	returnstr=setlogoconfig(focpath & "/" & FileName)
					alert_redirect "恭喜,您网站的logo图片上传成功.刷新首页后将看到效果","logoupload.asp"
				 end if
		case 2'印章
			 	formname="file2"
				focpath="/manager/images/cerimg"
				FileName="stamp"'如果没有输入新的文件名,就用原来的文件名
				FSPath=server.mappath(focpath) & "/"
				set oFile=upfile.file(formname)
				oldFileName=oFile.filename
				oldFilesuffix=trim(upfile.GetFileExt(oldFileName))'文件后辍
				if not upfile.isAllowExt(oldFilesuffix) then url_return "抱歉,上传类型错误,只允许:"& allowfiletype,-1
				set oFile=nothing
				FileName=FileName & "." & oldFilesuffix
				upfile.SaveToFile formname,FSPath & FileName  ''保存文件
				 if upfile.iserr then 
				 	set upfile=nothing
					url_return upfile.errmessage,-1
				 else
				 	set upfile=nothing
				 	returnstr=setCoinconfig(focpath & "/" & FileName)
					alert_redirect "恭喜,您网站的logo图片上传成功.刷新首页后将看到效果","logoupload.asp"
				 end if
	end select
	
end if

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<script language="javascript">
function doupfilebutton(f,thetype){
	if(thetype==1){
		var v1=f.file1;
		if(v1.value!=''){
			f.action +='?act=' + thetype;
			return true;
		}else{
			alert('请选择要上传的网站logo');
		}
	}else if(thetype==2){
		var v2=f.file2;
		if(v2!=''){
			f.action +='?act=' + thetype;
			return true;
		}else{
			alert('请选要上传的域名印章');
		}
		
	}
	return false
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
<table width="100%" border="0" cellpadding="4" cellspacing="1" bordercolordark="#ffffff" class="border">
  <form action="<%=request("script_name")%>" method="post" enctype="multipart/form-data" name="form1">
    <tr bgcolor="#efefef">
      <td width="12%">网站LOGO</td>
      <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td align="center">
            <%if logimgPath<>"" then %>
           		 <img src="<%=logimgPath%>" border=0>
             <%
			 else 
			 	response.write "--"
			 end if%></td>
            <td width="83%">
              <input type="file" name="file1" size="30">
              <input type="submit" name="button1" id="button1" value="提交" onclick="return doupfilebutton(this.form,1)">
            </td>
          </tr>
          <tr>
            <td colspan="2"> 上传的Logo图片必须为gif;jpg;bmp;jpeg;png格式,图片大小建议为：200x80 ,</td>
          </tr>
        </table></td>
    </tr>
    <tr><td colspan="2" height="2"><hr size="1" color="#0066CC"></td></tr>
    <tr bgcolor="#ffffff">
      <td width="12%">域名证书公司印章</td>
      <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td align="center">
            <%
			if getcercoin(coinpath) then
			%>
            <img src="<%=coinpath%>" border=0>
            <%
			else
			response.write "--"
			end if
			%>
            </td>
            <td width="83%"><input type="file" name="file2" size="30">
              <input type="submit" name="button2" id="button2" value="提交" onclick="return doupfilebutton(this.form,2)">
            </td>
          </tr>
          <tr>
            <td colspan="2"> 上传的印章图片必须为gif;jpg;bmp;jpeg;png格式,图片大小建议为：153x153</td>
          </tr>
        </table></td>
    </tr>
  </form>
</table>
</body>
</html>
<%
function echoupfileerr(byval upfile,byref errstr)
	echoupfileerr=false
	if upfile.isErr then
		 select case upfile.err
		   case 1
			 errstr = "抱歉,上传数据为空"
		   case 2
			 errstr = "抱歉,上传的文件超出我们的限制,最大"& savem &"M"
		   
		 end select
	else
		echoupfileerr=true
	end if
end function
function setlogoconfig(byval nfileName)
		set file=fso.opentextfile(server.mappath("/config/const.asp"),1)
		MB=file.readall
		file.close 
		set file = nothing
		
		nfilepath=replace(replace(nfileName,"\","/"),"//","/")
		Set rea = New RegExp
		rea.IgnoreCase=true
		rea.Pattern="(logimgPath)\s*=\s*""([^'""\n\r]*)"""
		nfilepath=replace(nfilepath,chr(34),"")
		if rea.test(MB) then
			MB=rea.replace(MB,"$1=""" & nfilepath & """")
		else
			rea.pattern="(logimgPath)\s*=\s*[a-zA-Z0-9]+"
			MB=rea.replace(MB,"$1=" & nfilepath)
		end if
		set rea=nothing
		
		set file=fso.createtextfile(server.mappath("/config/const.asp"),true) 
		file.write MB
		file.close 
		set file = nothing 
		set fso=nothing
end function
function setCoinconfig(byval nfilename)
						nfileName=replace(replace(nfileName,"\","/"),"//","/")
						xmlpath=server.mappath("/database/data.xml")
						set objDoms=Server.CreateObject("Microsoft.XMLDOM")
						if fso.fileExists(server.MapPath(nfilename)) then
							set myobject=isnodes("pageset","cercoin",xmlpath,1,objDoms)
							myobject.setAttribute "imgsrc",nfilename
							objDoms.save(xmlpath)
							set myobject=nothing
						end if
						set fso=nothing
						set objDoms=nothing
end function
function getcercoin(byref imgsrc)
				getcercoin=false
				imgdll="gif;jpg;bmp;jpeg;png"
						xmlpath=server.mappath("/database/data.xml")
						set objDoms=Server.CreateObject("Microsoft.XMLDOM")
						set fileobj=server.createobject("scripting.filesystemobject")
						
						set myobject=isnodes("pageset","cercoin",xmlpath,1,objDoms)
						set mytype=myobject.selectSingleNode("@imgsrc")
						if mytype is nothing then
								myobject.setAttribute "imgsrc",""
								objDoms.save(xmlpath)
						end if
						set mytype=nothing
						imgsrc=myobject.attributes.getNamedItem("imgsrc").nodeValue
						set myobject=nothing
						set objDoms=nothing
						
						if imgsrc<>"" then
							if fileobj.fileExists(server.MapPath(imgsrc)) then
								imgarr=split(imgsrc,".")
								imgsuffixindex=ubound(imgarr)
								if imgsuffixindex>0 then
									imgsuffix=imgarr(imgsuffixindex)
									if instr(imgdll,imgsuffix)>0 then
										getcercoin=true
									end if
								end if
								
							end if
							
						end if
						set fileobj=nothing
end function
%>
