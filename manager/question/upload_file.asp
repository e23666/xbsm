<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/upfile_class.asp" -->
<%Check_Is_Master(1)%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>上传文件</title>
<LINK href="../css/Admin_Style.css" rel=stylesheet>
</head>
<script language="javascript">
function doecho(inputname,p){
	var inputobj=eval("parent.document.form1." + inputname);
	inputobj.value=p;

}
</script>
<%
act=requesta("act")
if act="up" then
	set upfile=new upfile_class
	file_size=request("filesize")
	file_name=request("filename")
	file_path=request("filepath")
	input_obj=request("inputobj")
	if not doupfile(errstr) then response.write "<script>doecho('"+ input_obj +"','');</script>":url_return errstr,-1
	
	response.write "恭喜,上传成功<a href='"& request.ServerVariables("script_name") &"?inputobj="& input_obj &"&filesize="& file_size &"&fileName="&file_name &"&filePath="& server.URLEncode(file_path) &"'><font color=blue>[重新上传]</font></a>"
	set upfile=nothing
	response.end
else
	response.write "<script language='javascript'>doecho('"& request("inputobj") &"','');</script>"
end if
%>
<body topmargin="0" bottommargin="0" leftmargin="0" rightmargin="0">
<table border="0" cellpadding="0" cellspacing="2">
 <form action="<%=request("script_name")%>?act=up&<%=Request.ServerVariables("QUERY_STRING")%>" method="post" enctype="multipart/form-data" name="upfileform">
<tr><td><input type="file" name="file1" /></td>
<td><input type="submit" value=" 上 传 " />
</td>
</tr>
</form>
</table>
<%
function doupfile(byref errstr)
				doupfile=false
				allowfiletype="gif;jpg;bmp;jpeg;png"
				
				savem=file_size '最大设为1M
				maxfilesize=int(savem) * 1024 * 1024
				upfile.GetData maxfilesize
				upfile.AllowExt=allowfiletype
				if upfile.isErr>0 then errstr=upfile.ErrMessage:exit function
				formname="file1"
				focpath=file_path
				FileName=file_name'生成文件名
				FSPath=server.mappath(focpath) & "/"
				set oFile=upfile.file(formname)
				oldFileName=oFile.filename
				oldFilesuffix=trim(upfile.GetFileExt(oldFileName))'文件后辍
				if not upfile.isAllowExt(oldFilesuffix) then errstr="抱歉,上传类型错误,只允许:"& allowfiletype:exit function
				set oFile=nothing
				FileName=FileName & "." & oldFilesuffix
				upfile.SaveToFile formname,FSPath & FileName  ''保存文件
				if upfile.iserr then 
				 	errstr=upfile.errmessage:exit function
				
				end if
				response.write "<script language='javascript'>doecho('"+ input_obj +"','"& file_path & "/" & FileName  &"');</script>"
				doupfile=true
				 
end function	
		
%>
</body>
</html>
