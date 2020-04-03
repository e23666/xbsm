<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->

<!--#include virtual="/config/Template.inc.asp" --> 
<%
conn.open constr
response.Charset="gb2312"
domain_name=requestf("domain_name")
suffix=requestf("suffix")
module2=decodehtml(requestf("module2"))
searchType2=decodehtml(requestf("searchType2"))
action2=decodehtml(requestf("action2"))
 

for each suffixItem in split(suffix,",")

	for each mydomain in split(domain_name,vbcrlf)
	
	  if not isDomain(mydomain & trim(suffixItem)) then
			url_return "域名输入错误请检查后重输" & mydomain & trim(suffixItem),-1
		end if
				if mydomain<>"" then
				   if newdomains="" then
				   newdomains=trim(mydomain) 
				   else
					newdomains=newdomains & ","& trim(mydomain) 
					end if
				end if
	next

    
next
if newdomains<>"" then
domain_name=newdomains
end if


ajaxurlstr="newAjax.asp?searcheddomainname='+escape("""& trim(domain_name) &""")+'&suffix='+escape("""& replace(suffix,chr(32),"") &""")+'&module2="&module2&"&searchType2="&searchType2&"&action2="&action2
'response.Write(ajaxurlstr)
	scriptStr=			"<script language=""javascript"">" & vbcrlf
	scriptStr=scriptStr&"makeRequest('"& ajaxurlstr &"','contentID');" & vbcrlf
	scriptStr=scriptStr&"</script>" & vbcrlf

tpl.set_unknowns "remove"
call setHeaderAndfooter()
call setDomainLeft()
tpl.set_file "main",USEtemplate&"/services/domain/whoisCN.html"
tpl.set_var "searchedJSscript",scriptStr,false
tpl.set_function "main","Price","tpl_function"
tpl.parse "mains", "main",false
tpl.p "mains" 
set tpl=nothing

%>
