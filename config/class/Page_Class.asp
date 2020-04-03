<%
dim pageNo
function searchlist()

     	searchItemstr="<select name=""searchItem"">" & vbcrlf
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
			cselected7=" selected "
	end select
      	conditionstr= "<select name=""condition"">" & _
					  "<option value=""eq"" "& cselected1 &">=</option>" & _
					  "<option value=""gt"" "& cselected2 &">&gt;</option>" & _
					  "<option value=""ge"" "& cselected3 &">&gt;=</option>" & _
					  "<option value=""lt"" "& cselected4 &">&lt;</option>" & _
					  "<option value=""le"" "& cselected5 &">&lt;=</option>" & _
					  "<option value=""ne"" "& cselected6 &">&lt;&gt;</option>" & _
					  "<option value=""$"" "& cselected7 &">包含</option>" & _
					  "</select> "
    	searchValuestr="<input name=""searchValue"" type=""text"" value="""& SearchValue &""" size=""20"" maxlength=""100"" class=""inputbox"">&nbsp;"
   		buttonstr=     "<input type=""submit"" name=""serarchsubmit"" value="" 查询 "" class=""btn_mini"">"
					
		searchlist=searchItemstr &  conditionstr & searchValuestr & buttonstr
end function

function searchEnd(byref searchItem,byref condition,byref searchValue,byref otherhrefstr)
	searchItem=requesta("searchItem")
	condition=requesta("condition")
	searchValue=requesta("searchValue")
	otherhrefstr=""
	sqlstr11=""
	searchEnd=""
	childSql=""
	if searchValue="" then exit function
	cond=txt2Sig(condition)
	MyIndex = Filter(sqlArray, searchItem)
	if trim(MyIndex (0)) & "" <>"" then
		myarray=split(MyIndex(0),",")
		if ubound(myarray)>=2 then
			myCtype=lcase(trim(myarray(2)))
			if ubound(myarray)>=3 then
				childSql=myarray(3)
				
			end if
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
			  sqlstr11=" and datediff(day,'"& searchValue &"',"& searchItem &")"& cond &"0"  
			
		case else
			  sqlstr11=" and "& searchItem & " "  & cond & " " &  Fno &  trim(searchValue)  & Eno
	end select
	if len(childSql)>0 then
		sqlstr11=" "& replace(childSql,"{}",sqlstr11) & " "
	end if
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

function GetPageClass(myrs,pageSizes,othercode,byref pageCounts,byref sUsers)
		 pageNo=request("pageNo")
		 if not isNumeric(pageNo) then pageNo=1
		 if pageNo<1 then PageNo=1
		 myrs.pageSize=pageSizes
		 if pageSizes>0 then myrs.CacheSize=pageSizes '记录缓存
		 pageCounts=myrs.pageCount
		 sUsers=myrs.RecordCount
		 if clng(pageNo)>clng(pageCounts) then pageNo=pageCounts
		 if not myrs.eof then myrs.AbsolutePage=pageNo
		 forstr1=clng(pageNo)-3
		 forstr2=clng(pageNo)+3
		 if forstr1<1 then forstr1=1
		 if forstr2>pageCounts then forstr2=pageCounts
		 pagestr=""

		 for ii=forstr1 to forstr2
		 	if clng(ii)<>clng(pageNo) then
				pagestr=pagestr & "<a href='"&request("script_name")&"?pageNo="& ii & othercode &"' class=""z_next_page"">"& ii & "</a> "
			else
				pagestr=pagestr &"<span class=""z_this_page"">"& ii &"</span> "
			end if
		 next

		 if forstr1>1 then lookother1="<a href='"&request("script_name")&"?pageNo="& (forstr1-(1+3)) & othercode &"'><b>...</b></a> "
		 if forstr2<pageCounts then lookother2="<a href='"&request("script_name")&"?pageNo="& (forstr2+(1+3)) & othercode &"'><b>...</b></a> "
		 
		 netstring="<a href='"& request("script_name") &"?pageNo=1"& othercode &"' class=""z_next_page"">&laquo;首页</a>&nbsp;"
    	 netstring=netstring & "<a href='"& request("script_name") &"?pageNo="& (clng(pageNo)-1) & othercode &"' class=""z_next_page"">上一页</a>&nbsp;"
    	netstring=netstring & lookother1 & pagestr & lookother2 & "&nbsp;"
   		netstring=netstring & "<a href='"& request("script_name") &"?pageNo="& (clng(pageNo)+1) & othercode &"' class=""z_next_page"">下一页</a>&nbsp;"
    	netstring=netstring & "<a href='"& request("script_name") &"?pageNo="& pageCounts & othercode &"' class=""z_next_page"">末页&raquo;</a>"
		netstring=netstring & "&nbsp;总页数:"& pageCounts
		netstring=netstring & "&nbsp;总条数:"& sUsers
		GetPageClass=netstring
end function
%>