<!--#include file="upload.asp"-->
<%
response.Charset="gb2312" 
allowsuffix=".gif,.bmp,.jpg,.jpeg,.png"

allowsuffix_com=".jpg,.jpeg"
allowsuffix_zdns=".jpg,.jpeg"
uploadFilepath="/noedit/webuploader/zjfile/"&session("u_sysid")&"/"&session.sessionid
 

allowsuffix=".jpg,.jpeg"
fileMinSize=15  '��λKB
fileMaxSize=1024*5

set robj=getloadrequest(errstr)	
if trim(errstr)="" then
	
	errstr=upfileObjSave(robj("file"),robj("Upload"),Server.Mappath(uploadFilepath),allowsuffix,fileMinSize,fileMaxSize,contactfilepath)
	if trim(errstr)="" then
		response.write("{""result"":200,""urlpath"":"""&robj("urlpath")&""",""imgurl"":"""&robj("imgurl")&""",""url"":"""&uploadFilepath&contactfilepath&"""}")
	else
		response.write("{""result"":500,""msg"":"""&errstr&"""}")
	end if 
else
	response.write("{""result"":500,""msg"":"""&errstr&"""}")
end if


function backkeyname(byval key)
	dim rpcstr,str
	backkeyname=key
	rpcstr="urlpath,imgurl"
	for each str in split(rpcstr,",")
		str=trim(str)
		if trim(lcase(key))=lcase(str) then
			backkeyname=str
			exit for
		end if
	next
end function

function getloadrequest(byref errstr)
	dim robj,formkey,Upload,formkeybig
	errstr=""
	set robj=server.CreateObject("Scripting.Dictionary")
	set Upload = new westUpload
	Upload.AllowMaxFileSize=fileMaxSize&"kb"
	Upload.AllowFileTypes=allowsuffix
	'Upload.CharSet="utf-8"'�����������ļ���������
	If Not Upload.GetData() Then 
		errstr=Upload.Description
	else		
		for each formkey in Upload.Post("-1")
			formkeybig=backkeyname(formkey)		
			'response.write(formkeybig&"="&Upload.Post(formkey)&"<BR>")
			robj.item(formkeybig)=Upload.Post(formkey)	
		next
		for each formkey in Upload.files("-1")	
			'response.write(formkey&"=key<BR>")		
			set fileCls=Upload.files(formkey) 
			set robj.item(backkeyname(fileCls.FormName))=fileCls
			set fileCls=nothing
		next
	end if
	set robj.item("Upload")=Upload
	set getloadrequest=robj
	set Upload =nothing	
	set robj=nothing 
end function
 
function upfileObjSave(byval filebody,byval Upload,byval uppathname,byval allowsuffix,byval minsize,byval maxsize,byref indbpath)
	dim result,fileName,fileSize,fileSuffix,upRootpath,saveresult,datefilepath,upRootpath_s,fileSizestr,upfilepath
	result="":indbpath=""
	if filebody.IsImage   then
		'datefilepath=year(date())&"-"&month(date())		
		upRootpath=uppathname&datefilepath
		'upRootpath_s=uppathname&"smaillPic\"&datefilepath
		fileSize=cdbl(filebody.Size/1024)
				
		fileSizestr=filebody.Sizestr		
		fileSuffix=filebody.Extend
		Upload.SavePath = upRootpath
		'Upload.smallpath = upRootpath_s '����ͼpath	
		
		if instr(","&lcase(trim(allowsuffix))&",",",."&lcase(trim(fileSuffix))&",")=0 then
			result="��׺��������"& allowsuffix &"����һ��"		
		elseif CDbl(fileSize)>CDbl(maxsize) then												
			result="��С������"&minsize&"KB��"&maxsize&"KB֮��,��ǰ��С:"&fileSizestr&",���û�ͼ���߽�ͼƬ��С��"&minsize&"KB��"&maxsize&"KB���ϴ�"		
		elseif  CDbl(fileSize)<CDbl(minsize) then
			result="��С������"&minsize&"KB��"&maxsize&"KB֮��,��ǰ��С:"&fileSizestr&",���û�ͼ���߽�ͼƬ�Ŵ�"&minsize&"KB��"&maxsize&"KB���ϴ�"						
		elseif Upload.Save(filebody,0,true,90).Succeed then
			indbpath=datefilepath&"/"&filebody.FileName			
		else
			result=filebody.Exception
		end if	
		set filebody=nothing
		set Upload=nothing
	else
		result="�ļ�����ΪͼƬ"
	end if
	upfileObjSave=result
end function

%>