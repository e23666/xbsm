<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
response.Charset="gb2312"
response.Buffer=true
freeid=requesta("freeid")
conn.open constr
suffixlist=lcase(getfreedomainsuffix(freeid,isfree))

call setHeaderAndfooter()
call setDomainLeft()
tpl.set_file "main",USEtemplate&"/services/domain/default.html"
if isfree then 
	tpl.set_var "freeid",freeid,False
	if lcase(USEtemplate)="tpl_2016" then
		tpl.set_var "suffixlist",suffixlist,False
	End If
Else
	tpl.set_var "freeid","",False
	if lcase(USEtemplate)="tpl_2016" then
		tpl.set_var "suffixlist","",False
	End If
End if

tpl.set_block "main", "suffixlist", "mylist"
trcur=1
buttontype="checkbox"
if isfree then buttontype="radio"
for each suffixstr in split(suffixlist,",")
	if trim(suffixstr)<>"" and left(trim(suffixstr),1)="." then
		trstr=""
		selectedstr=""
		if trcur mod 6 =0 then trstr="</tr><tr>"
		if instr(",.com,.cn,.net,.vip,",","&trim(suffixstr)&",")>0 then selectedstr=" checked "
		tpl.set_var "trstr",trstr,false
		tpl.set_var "buttontype",buttontype,false
		tpl.set_var "selectedstr",selectedstr,false
		tpl.set_var "suffixstr",suffixstr,false
		tpl.parse "mylist", "suffixlist", true
		trcur=trcur+1
		
	end if
next
 
 '
' 
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
'selectstr=selectstr&"</td><td style=""position:absolute;z-index:5""><a href='#'>更多后缀</a><div class=""moresuffix""><ul><li><input type=""checkbox"" name=""suffix"" value="".em"">.em</li><li><input type=""checkbox"" name=""suffix"" value="".em"">.em</li><li><input type=""checkbox"" name=""suffix"" value="".em"">.em</li><li><input type=""checkbox"" name=""suffix"" value="".em"">.em</li><li><input type=""checkbox"" name=""suffix"" value="".em"">.em</li><li><input type=""checkbox"" name=""suffix"" value="".em"">.em</li><li><input type=""checkbox"" name=""suffix"" value="".em"">.em</li><li><input type=""checkbox"" name=""suffix"" value="".em"">.em</li><li><input type=""checkbox"" name=""suffix"" value="".em"">.em</li><li><input type=""checkbox"" name=""suffix"" value="".em"">.em</li><li><input type=""checkbox"" name=""suffix"" value="".em"">.em</li><li><input type=""checkbox"" name=""suffix"" value="".em"">.em</li><li><input type=""checkbox"" name=""suffix"" value="".em"">.em</li><li><input type=""checkbox"" name=""suffix"" value="".em"">.em</li><li><input type=""checkbox"" name=""suffix"" value="".em"">.em</li><li><input type=""checkbox"" name=""suffix"" value="".em"">.em</li></ul><div style=""clear:both""></div></div></td>"


tpl.set_var "savelist",selectstr,false
tpl.set_function "main","Price","tpl_function"
tpl.set_function "main","cnPrice","tpl_cnfunction"
tpl.set_function "main","cnrenewPrice","tpl_cnrenewfunction"
tpl.parse "mains", "main",false
tpl.p "mains" 
set tpl=nothing
conn.close

function tpl_cnrenewfunction(v)

		renewprices=GetNeedPrice(session("user_name"),v,1,"renew")

	tpl_cnrenewfunction=renewprices
end function
function tpl_cnfunction(v)

 	tpl_cnfunction=GetNeedPrice(session("user_name"),v,1,"new")

	
end function

%>