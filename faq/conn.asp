<%@LANGUAGE="VBSCRIPT"%>
<%
	Response.Buffer = True  
'	Response.ExpiresAbsolute = Now() - 1  
'	Response.Expires = 0  
	Response.CacheControl = "no-cache"  
	Response.AddHeader "Pragma", "No-Cache" 
	
	dim conn
	dim connstr
	dim db
	Dim Qcdn
	db="data/global.asa"
	Set conn = Server.CreateObject("ADODB.Connection")
	connstr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath(db)
	'connstr="driver={Microsoft Access Driver (*.mdb)};dbq=" & Server.MapPath(""&db&"")
	conn.Open connstr
	
	Set Qcdn=New Qcdn_newsFun


function check_is_master(this_level)
	  if(session("u_type")="" or IsNull(session("u_type"))) then
		response.write  "登录超时！"
	    response.end

	end if
  if(mid(session("u_type"),this_level,1)<>"1") then
		response.write  "没有权限！"
	    response.end
  end if
end function



Function Requesta(strRequest)
	Requesta = sqlincode(Request(strRequest))	
End Function
Function Requestf(strRequest)
	Requestf = sqlincode(Request.Form(strRequest))	
End Function

Function sqlincode(byval strRequest)
	sqlincode=strRequest
	If Not isNumeric(sqlincode) and sqlincode<>"" Then
		Set oRegExp_ = new RegExp		
		oRegExp_.IgnoreCase = True
		oRegExp_.Global = True		
		sqlincode=replace(sqlincode,"'","")
		sqlincode=replace(sqlincode,">","&gt;")	
		sqlincode=replace(sqlincode,"<","&lt;")

		Request_tmp=sqlincode
		BadWord="exec,execute,master,user,cmd.exe,insert,xp_cmdshell,mid,update,select,delete,drop," & _
				"char,unicode,asc,left,or,where,backup,chr,nchar,cast,substring,/*,;,set,(,from,into,values,and,declare,exists," & _
				"truncate,join,create,substring"
		wordCount=0:HaveBadWord=false
		BadWordArr=split(BadWord,",")
		for each word_item in BadWordArr
			if trim(word_item)<>"" then
				oRegExp_.Pattern="^[\w]+$"
				if oRegExp_.Test(word_item) then
					oRegExp_.Pattern="\b"& word_item &"\b"
					if oRegExp_.Test(sqlincode) then
						wordCount=wordCount+1
						Request_tmp=replace(Request_tmp,word_item,"sqlin",1,-1,1)
					end if
				elseif instr(1,sqlincode,word_item,1)>0 then
						wordCount=wordCount+1
						Request_tmp=replace(Request_tmp,word_item,"sqlin",1,-1,1)
				end if
				if wordCount>=2 then
					HaveBadWord=true
				end if
			end if
		next
		if HaveBadWord then
			sqlincode=Request_tmp
		end if
		Set oRegExp_ = Nothing
		sqlincode=trim(sqlincode)
	end if	
End Function
%>