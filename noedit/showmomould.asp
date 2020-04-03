<!--#include virtual="/config/config.asp" -->
<%
Response.Charset="GB2312"
act=requesta("act")
conn.open constr
select case trim(act)
case "setmold"
setmold()
case "delmold"
delmold
case else
list
end select
sub list
%>
document.writeln("<style>");
document.writeln(".molddiv { float:left; width:auto; border:1px solid #ccc; padding:2px 0 2px 5px; margin:2px; }");
document.writeln(".moldset { background:url(/newimages/note_ok.gif) left center no-repeat; padding-left:20px; background-color:#E2FFE1; border:1px solid #090; }");
document.writeln(".molddiv:hover { background-color:#FFC; }");
document.writeln("</style>");
<%

sql="select top 10 * from  domainTemp where u_name='"&session("user_name")&"'"
rs.open sql,conn,1,1
do while not rs.eof
%>

document.writeln("<div class=\"molddiv\" id=\"mold_<%=rs("id")%>\">");
document.writeln("<span style=\"cursor:pointer\" onclick=\"javascript:dosetmold(\'<%=rs("id")%>\')\"><%=rs("dom_org_m")%></span>&nbsp;&nbsp;<img name=\"delmoldbutton\" src=\"/newimages/web_icon_009.gif\" style=\"cursor:pointer\" onclick=\"javascript:dodelmold(\'<%=rs("id")%>\')\">");
document.writeln("</div>");
<%
 
rs.movenext
loop
%>

function dodelmold(m_sysid){
	if(confirm("È·¶¨É¾³ý¸ÃÄ£°å")){
		var info="act=delmold&id="+ m_sysid;
		$.ajax({
			type:"POST",
			url:"/noedit/showmomould.asp",
			data:info,
			cache:false,
			timeout:10000,
			error:function(a,b,c){
				alert(a+b+c);
			},
			success:function(data){
				if(data=="200"){
					$("#mold_"+m_sysid).hide();
				}else{
					alert("É¾³ýÊ§°Ü:"+ data)
				}
			}
		});
	}
}
function dosetmold(m_sysid){
	$("div[id^='mold_'] img[name='delmoldbutton']").show();
	$("div[id^='mold_'] img[name='delmoldbutton']").attr("src","/newimages/web_icon_009.gif");
	
	if($("#mold_"+m_sysid).attr("class").indexOf("moldset")>=0){
		document.form1.reset();
		$("div[id^='mold_']").removeClass("moldset");
		CheckNameDomain();
	}else{
		$("div[id^='mold_']").removeClass("moldset");
		$("#mold_"+m_sysid +" img[name='delmoldbutton']").attr("src","/newimages/iquery.gif");
		var info="act=setmold&id="+ m_sysid;
		$.ajax({
			type:"POST",
			url:"/noedit/showmomould.asp",
			data:info,
			cache:false,
			timeout:20000,
			error:function(a,b,c){
				alert(a+b+c);
			},
			success:function(data){
				if(data.indexOf("\r\n")>=0){
					$.each(data.split("\r\n"),function(i,n){
						if(n.indexOf("=")>=0){
							contentArr=n.split("=");
							if(contentArr.length>0){
								var inputkey=$.trim(contentArr[0]);
								var inputval=$.trim(contentArr[1]);
								if(inputkey!="strdomainpwd"){
                            
                                
									$("input[name='"+ inputkey +"']:text,select[name='"+ inputkey +"'][name!='regdomain']").val(inputval);						
								}
							}
						}
					});		
					$("#mold_"+m_sysid).addClass("moldset");					
					$("#mold_"+m_sysid +" img[name='delmoldbutton']").hide();
 
                    chkxmName($("input[name='dom_org_m']").val());
				}else{
					alert("²Ù×÷Ê§°Ü:"+ data)
				}
			CheckNameDomain();
			}
		});
	}
	
}

<%end sub
sub  setmold()
id=requesta("id")
if not isnumeric(id) or trim(id)="" then id=0

set mrs=Server.CreateObject("adodb.recordset")
sql="select top 1 * from domainTemp where id="&id&" and u_name='"&session("user_name")&"'"
mrs.open sql,conn,1,1
if not mrs.eof then
	for i=2 to mrs.fields.Count-1
	response.write mrs(i).name&"="&mrs(i)&vbcrlf
	next
end if
end sub
sub delmold
id=requesta("id")
if not isnumeric(id) or trim(id)="" then id=0
conn.execute("delete from domainTemp where id="&id&" and u_name='"&session("user_name")&"'")
response.Write("200")
end sub
%>