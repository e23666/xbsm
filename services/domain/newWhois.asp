<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
response.Charset="gb2312"
searchedDomainName=requestf("searchedDomainName")
suffix=trim(requestf("suffix"))
str=trim(cstr(requesta("str")))
searchType=trim(cstr(requesta("searchType")))
freeid=requestf("freeid")
session("whoisValue")=""
conn.open constr
suffixlist=lcase(getfreedomainsuffix(freeid,isfree))

if str="2" then
	if trim(requesta("searchedDomainName_custom"))="" then
		if searchedDomainName<>"" then
			newdomains=""
			for each mydomain in split(searchedDomainName,vbcrlf)
				 
				if mydomain<>"" then
					newdomains=newdomains & trim(mydomain) & ","
				end if
			next
			searchedDomainName=newdomains
			if right(searchedDomainName,1)="," then searchedDomainName=left(searchedDomainName,len(searchedDomainName)-1)
		end if
		if len(suffix)>1 then
			if right(suffix,1)="," then suffix=left(suffix,len(suffix)-1)
		end if
	else
		searchedDomainName_custom=requesta("searchedDomainName_custom")
		if trim(searchedDomainName_custom)<>"" then
			for each line in split(searchedDomainName_custom,vbcrlf)
				if isDomain(line&"") then
					if searchedDomainName="" then 
						searchedDomainName=mid(line,1,instr(line,".")-1)	
						suffix=mid(line,instr(line,"."),len(line))	
					else
						searchedDomainName=searchedDomainName&","&mid(line,1,instr(line,".")-1)
						suffix=suffix&","&mid(line,instr(line,"."),len(line))		

					end if
				end if
			 
			next
			 
		end if

	end if
end if
scriptStr=""

if str="2" and searchedDomainName<>"" and suffix<>"" then
	scriptStr=			"<script language=""javascript"">" & vbcrlf
	scriptStr=scriptStr&"submitchecken2('"& searchedDomainName &"','"& suffix &"');" & vbcrlf
	scriptStr=scriptStr&"</script>" & vbcrlf
else
	scriptStr=			"<script language=""javascript"">" & vbcrlf
	scriptStr=scriptStr&"document.getElementById('contentID').innerHTML='<b>请输入您要查询的域名</b>';document.getElementById('hrefimg0').disabled=false;" & vbcrlf
	scriptStr=scriptStr&"</script>" & vbcrlf
end If

'die searchedDomainName&"||"&suffix
tpl.set_unknowns "remove"
call setHeaderAndfooter()
call setDomainLeft()
tpl.set_file "main",USEtemplate&"/services/domain/newWhois.html"
if scriptStr<>"" then
	tpl.set_var "searchedJSscript",scriptStr,false
end if
if isfree then tpl.set_var "freeid",freeid,false


tpl.set_block "main", "suffixlist", "mylist"
trcur=1
buttontype="checkbox"
if isfree then buttontype="radio"
for each suffixstr in split(suffixlist,",")
	if trim(suffixstr)<>"" and left(trim(suffixstr),1)="." then
		trstr=""
		selectedstr=""
		if trcur mod 6 =0 then trstr="</tr><tr>"
		if instr(".com,.cn,.net",trim(suffixstr))>0 then selectedstr=" checked "
		tpl.set_var "trstr",trstr,false
		tpl.set_var "keyword",searchedDomainName,false
		tpl.set_var "buttontype",buttontype,false
		tpl.set_var "selectedstr",selectedstr,false
		tpl.set_var "suffixstr",suffixstr,false
		tpl.parse "mylist", "suffixlist", true
		trcur=trcur+1
		
	end if
next

'tpl.set_block "main", "osuffixlist", "omylist"
'trcur=1
' 
'buttontype="radio"
'for each suffixstr in split(suffixlist,",")
'	if trim(suffixstr)<>"" and left(trim(suffixstr),1)="." then
'		trstr=""
'		selectedstr=""
'	'	if trcur mod 5 =0 then trstr="</tr><tr>"
'		if instr(".com",trim(suffixstr))>0 then selectedstr=" checked "
'		tpl.set_var "trstr",trstr,false
'		tpl.set_var "buttontype",buttontype,false
'		tpl.set_var "selectedstr",selectedstr,false
'		tpl.set_var "suffixstr",suffixstr,false
'		tpl.parse "omylist", "osuffixlist", true
'		trcur=trcur+1
'		
'	end if
'next
'



selectstr=""
if instr(suffixlist,"[save]")>0 then
	
	        selectstr="<select name=""suffix"" id=""p_domain"">" & _
					  "<option value=""""><strong>各省域名</strong></option>" & vbcrlf & _
                      "<option value="".ac.cn""><strong>.ac.cn </strong></option>" & vbcrlf & _
                      "<option value="".bj.cn""><strong>.bj.cn</strong></option>" & vbcrlf & _
                      "<option value="".sh.cn""><strong>.sh.cn</strong></option>" & vbcrlf & _
                      "<option value="".tj.cn""><strong>.tj.cn</strong></option>" & vbcrlf & _
                      "<option value="".cq.cn""><strong>.cq.cn</strong></option>" & vbcrlf & _
                      "<option value="".he.cn""><strong>.he.cn</strong></option>" & vbcrlf & _
                      "<option value=""sn.cn""><strong>.sn.cn</strong></option>" & vbcrlf & _
                      "<option value="".sx.cn""><strong>.sx.cn</strong></option>" & vbcrlf & _
                      "<option value="".nm.cn""><strong>.nm.cn</strong></option>" & vbcrlf & _
                      "<option value="".ln.cn""><strong>.ln.cn</strong></option>" & vbcrlf & _
                      "<option value="".jl.cn""><strong>.jl.cn</strong></option>" & vbcrlf & _
                      "<option value="".hl.cn""><strong>.hl.cn</strong></option>" & vbcrlf & _
                      "<option value="".js.cn""><strong>.js.cn</strong></option>" & vbcrlf & _
                      "<option value="".zj.cn""><strong>.zj.cn</strong></option>" & vbcrlf & _
                      "<option value="".ah.cn""><strong>.ah.cn</strong></option>" & vbcrlf & _
                      "<option value="".fj.cn""><strong>.fj.cn</strong></option>" & vbcrlf & _
                      "<option value="".jx.cn""><strong>.jx.cn</strong></option>" & vbcrlf & _
                      "<option value="".sd.cn""><strong>.sd.cn</strong></option>" & vbcrlf & _
                      "<option value="".ha.cn""><strong>.ha.cn</strong></option>" & vbcrlf & _
                      "<option value="".hb.cn""><strong>.hb.cn</strong></option>" & vbcrlf & _
                      "<option value="".hn.cn""><strong>.hn.cn</strong></option>" & vbcrlf & _
                      "<option value="".gd.cn""><strong>.gd.cn</strong></option>" & vbcrlf & _
                      "<option value="".gx.cn""><strong>.gx.cn</strong></option>" & vbcrlf & _
                      "<option value="".hi.cn""><strong>.hi.cn</strong></option>" & vbcrlf & _
                      "<option value="".sc.cn""><strong>.sc.cn</strong></option>" & vbcrlf & _
                      "<option value="".gz.cn""><strong>.gz.cn</strong></option>" & vbcrlf & _
                      "<option value="".yn.cn""><strong>.yn.cn</strong></option>" & vbcrlf & _
                      "<option value="".gs.cn""><strong>.gs.cn</strong></option>" & vbcrlf & _
                      "<option value="".qh.cn""><strong>.qh.cn</strong></option>" & vbcrlf & _
                      "<option value="".nx.cn""><strong>.nx.cn</strong></option>" & vbcrlf & _
                      "<option value="".xj.cn""><strong>.xj.cn</strong></option>" & vbcrlf & _
                      "<option value="".tw.cn""><strong>.tw.cn</strong></option>" & vbcrlf & _
                      "<option value="".hk.cn""><strong>.hk.cn</strong></option>" & vbcrlf & _
                      "<option value="".mo.cn""><strong>.mo.cn</strong></option>" & vbcrlf & _
                      "<option value="".xz.cn""><strong>.xz.cn</strong></option>" & vbcrlf & _
                      "</select>"
					  
					
end if
tpl.set_function "main","Price","tpl_function"
tpl.set_var "savelist",selectstr,false
tpl.parse "mains", "main",false
tpl.p "mains" 
set tpl=nothing


%>

