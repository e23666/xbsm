<!--#include virtual="/config/config.asp" -->
<%
function searchlist()

     	searchItemstr=" <select name=""searchItem"" class=""manager-select s-select"">" & vbcrlf
		for each searchitems in sqlArray
			selected=""
			searchArray=split(searchitems,",")
			searchV=trim(searchArray(0))
			searchT=trim(searchArray(1))
			if searchV=searchItem then selected=" selected "
			searchItemstr=searchItemstr & "<option value="""& searchV &""" "& selected &" >"& searchT &"</option>" & vbcrlf
		next
 	    searchItemstr=searchItemstr & "</select>"
	select case trim(condition)
		case "eq"
			cselected1=" selected "
		case "gt"
			cselected2=" selected "
		case "ge"
			cselected3=" selected "
		case "lt"
			cselected4=" selected "
		case "le"
			cselected5=" selected "
		case "ne"
			cselected6=" selected "
		case "$"
			cselected7=" selected "
		case else
			cselected1=" selected "
	end select
      	conditionstr= " <select name=""condition"" class=""manager-select s-select"">" & _
					  "<option value=""eq"" "& cselected1 &">=</option>" & _
					  "<option value=""gt"" "& cselected2 &">&gt;</option>" & _
					  "<option value=""ge"" "& cselected3 &">&gt;=</option>" & _
					  "<option value=""lt"" "& cselected4 &">&lt;</option>" & _
					  "<option value=""le"" "& cselected5 &">&lt;=</option>" & _
					  "<option value=""ne"" "& cselected6 &">&lt;&gt;</option>" & _
					  "<option value=""$"" "& cselected7 &" selected>包含</option>" & _
					  "</select>"
    	searchValuestr=" <input name=""searchValue"" type=""text"" value="""& SearchValue &""" size=""20"" maxlength=""100"" class=""manager-input s-input"">"
   		buttonstr=     " <input type=""submit"" name=""serarchsubmit"" value=""查 询"" class=""manager-btn s-btn"">"
					
		searchlist=searchItemstr &  conditionstr & searchValuestr & buttonstr
end function

function searchEnd(byref searchItem,byref condition,byref searchValue,byref otherhrefstr)
	searchItem=requesta("searchItem")
	condition=requesta("condition")
	searchValue=requesta("searchValue")
	otherhrefstr=""
	sqlstr11=""
	searchEnd=""
	if searchValue="" then exit function
	cond=txt2Sig(condition)
	MyIndex = Filter(sqlArray, searchItem)

	if trim(MyIndex (0)) & "" <>"" then
		myarray=split(MyIndex(0),",")
		if ubound(myarray)>=2 then
			myCtype=lcase(trim(myarray(2)))
		else
			exit function
		end if
	else
		exit function
	end if
	
	Fno="'":Eno="'"
	if myCtype="int" then Fno="":Eno=""
	if myCtype="int" and not isnumeric(searchValue) then searchValue="":exit function
	if cond="Like" then Fno="'%":Eno="%'"

	select case myCtype
		case "date"
			  if cond="Like" then cond="="
			  if not isdate(searchValue) then searchValue="":exit function
			  sqlstr11=" and dateDiff("&PE_DatePart_D&",'"& searchValue &"',"& searchItem &")"& cond &"0"  
			
		case else
			  sqlstr11=" and "& searchItem & " "  & cond & " " &  Fno &  trim(searchValue)  & Eno
			  if searchItem="strdomain" then
			  	sqlstr11=sqlstr11&" or s_memo  like '%"&trim(searchValue)&"%'"
			  end if
	end select
	
	otherhrefstr="&searchItem="&searchItem&"&condition="&condition&"&searchValue="&searchValue
	searchEnd=sqlstr11
end function
function txt2Sig(byval strSig)
	select case trim(strSig)
	  case "eq"
		 txt2Sig="="
	  case "gt"
		 txt2Sig=">"
	   case "ge"
		 txt2Sig=">="
	   case "lt"
		 txt2Sig="<"
	   case "le"
		 txt2Sig="<="
	   case "ne"
		 txt2Sig="<>"
	   case "$"
		 txt2Sig="Like"
	end select
end function

Function showstatus(svalues,buytest,expiredate )
	if cdate(expiredate) < date() then msg="<img src=/images/fei1.gif alt=""过期"">"
	If not buytest Then
		Select Case svalues
		  Case 0   '运行
			showstatus="<img src=../images/green1.gif alt=""运行"">" & msg
		  Case 1   '暂停
			showstatus="<img src=../images/green2.gif alt=""暂停"">"   & msg
		  case 2 '管理员停止
			showstatus="<img src=../images/sysstop.gif alt=""管理员停止"">"   & msg
		  case -1 '未开设
			showstatus="<img src=../images/nodong.gif alt=""未开设"">"   & msg
		  Case -2'已经删除
			showstatus="<img src=../images/delvho.gif alt=""已删除"">"   & msg
		  case else
			showstatus="<img src=../images/nodong.gif alt=""未知状态"">"   & msg
		End Select
	else
		Select Case svalues
		  Case 0   '运行
			showstatus="<img src=/images/yell1.gif>"   & msg
		  Case 1   '暂停
			showstatus="<img src=/images/yell2.gif>"   & msg
		  case 2 '管理员停止
			showstatus="<img src=/images/sysstop.gif>"  & msg
		  case -1 '未开设
			showstatus="<img src=/images/nodong.gif>"   & msg
		  Case -2'已经删除
			showstatus="<img src=/images/delvho.gif>"   & msg
		  case else
			showstatus="<img src=/images/nodong.gif>"   & msg
		End Select
	End If

End Function
Function showdomainstatus(regdate,regyears)
	If isnull(regdate)  Then
		showdomainstatus = "注册失败"
		exit function
	End If
	expiredate =  dateadd("yyyy",regyears,cdate(regdate))
	showdomainstatus = "过期"
	If cdate(expiredate) >= Date Then showdomainstatus = "正常"
End Function
function domainlook(byval strdomain)
	if left(strdomain,4)<>"xn--" then
  			domainlook=strdomain
	else
  			domainlook=Gbkcode(strdomain)
	end if
end function
function echoString(byval str,byval p)
	conn.close
	response.Redirect "/manager/config/echo.asp?str="& server.urlEncode(str)&"&p=" & p 'p=r/e
	response.end
end function
function isbindings(mydomain,byref s_year,byref s_buydate)
	isbindings=false
	s_year=1
   bsql="select s_bindings,s_year,s_buydate from vhhostlist where s_ownerid="& session("u_sysid") &" and s_buytest=0"
   set brs=conn.execute(bsql)
   if not brs.eof then
   		do while not brs.eof
			for each dbbind in split(brs("s_bindings"),",")
				if trim(dbbind)<>"" then
					dbbind=GetsRoot(trim(dbbind))
					
					if trim(mydomain)=dbbind then
						    isbindings=true
							s_year=brs("s_year")
							s_buydate=brs("s_buydate")
						    brs.close
   							set brs=nothing
							exit function
					end if
				end if
			next
		brs.movenext
		loop
   end if
   brs.close
   set brs=nothing
end function
function doUserSyn(byval p_type,byval p_name)
	select case trim(lcase(p_type))
		case "domain"
			syn_table="domainlist"
			sysfd="d_id"
			syn_fd=getTableFdlist(syn_table,sysfd)
		case "vhost"
			syn_table="vhhostlist"
			sysfd="s_sysid"
			syn_fd=getTableFdlist(syn_table,sysfd)
		case "server"
			syn_table="hostrental"
			sysfd="id"
			syn_fd=getTableFdlist(syn_table,sysfd)
		case "mail"
			syn_table="mailsitelist"
			sysfd="m_sysid"
			syn_fd=getTableFdlist(syn_table,sysfd)
		case "mssql"
			syn_table="databaselist"
			sysfd="dbsysid"
			syn_fd=getTableFdlist(syn_table,sysfd)
		case else
			dousersyn="404 标识参数出错":exit function
	end select
	commandstr= "other" & vbcrlf & _
				"sync" & vbcrlf & _
				"entityname:record" & vbcrlf & _
				"tbname:" & syn_table & vbcrlf & _
				"fdlist:" & syn_fd & vbcrlf & _
				"ident:" & p_name & vbcrlf & _
				"." & vbcrlf
		 
	doUserSyn=pcommand(commandstr,session("user_name"))
end function

%>