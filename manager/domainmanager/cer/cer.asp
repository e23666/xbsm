<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%call needregSession()
response.Charset="gb2312"
response.Buffer=true
%>
<html>
<head>
<title>域名证书</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<style type="text/css">
<!--
td,p{font-size:9pt}
a:active{text-decoration:none; color: #000000}
a:hover{text-decoration:underline; color: #000000}
a:link{text-decoration:none; color: #000000}
a:visited{text-decoration:none; color: #000000}
td{font-size:9pt}
--></style>
</head>
<%
d_id=requesta("DomainID")
u_id=requesta("u_id")
if u_id="" then u_id=session("u_sysid")
if trim(u_id)&""="" then alert_redirect "对不起，参数丢失!","/default.asp"

if d_id="" or not isnumeric(d_id) then alert_redirect "对不起，错误操作!","/default.asp"
sqlstring="select * from domainlist where  d_id = "& d_id & " and userid=" &  u_id
conn.open constr
rs.open sqlstring ,conn,1,1
if rs.eof then url_return "没有找到此域名",-1
If Trim(rs("dom_org"))="" Then 
	Call doUserSyn("domain",rs("strDomain")) 
End if
'CNNIC
if instr(",domwang,domcn,domchina,domcn,domgs,domhzcn,domchina,domhzcn,domgovcn,",","&rs("proid")&",")>0 then
response.redirect "cercn.asp?DomainID="&d_id&"&u_id="&u_id
end if

%>
<body bgcolor="#FFFFFF" text="#000000" link="#FFFF00" >
<br>
<div style="width:710px; margin:0 auto;position:relative;">
<table border="1" align="center" bordercolorlight="#000000" bordercolordark="#000000" cellspacing="0" cellpadding="0" width="640">
  <tr> 
    <td>
      <table border="0" cellspacing="0" cellpadding="0" align="center" width="100%">
        <tr bgcolor="#CC3333"> 
          <td colspan="3" height="14">&nbsp;</td>
        </tr>
        <tr> 
          <td rowspan="2" width="14" bgcolor="#CC3333">&nbsp;</td>
          <td width="610"> 
            <table width="610" border="0" cellspacing="0" cellpadding="0" align="center">
              <tr> 
                <td height="76">

                  <table border="0" cellspacing="0" cellpadding="0" align="center" width="100%" background="/default/images/100u.gif">
                    <tr> 
                      <td colspan="3" align="center" bgcolor="#FFFFFF"> <br>
                        <table width="90%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td rowspan="2" valign="middle"> 
                              <div align="center"><img src="../../images/cerimg/certificate.gif" width="350" height="100"></div>
                            </td>
                            <td> 
                              <div align="center"><img src="../../images/cerimg/coin.gif" width="139" height="115"></div>
                            </td>
                          </tr>
                          <tr> 
                            <td height="36" valign="middle"> 
                              <div align="center"><font color="#666666" size="1" face="Arial, Helvetica, sans-serif">ICANN 
                                标志由互联网<br>
                                名称与数字地址分配机构所有</font></div>
                            </td>
                          </tr>
                        </table>

                        <table width="80%" border="0" cellspacing="0" cellpadding="3">

                          <tr> 
                            <td> 
                              <p>本证书由互联网名称与数字地址分配机构<font face="Arial, Helvetica, sans-serif">ICANN(The 
                                Internet Corporation for Assigned Names and Numbers)</font>授权<font face="Arial, Helvetica, sans-serif">REGISTRARS.COM</font>并由<%=companyname%>（<font face="Arial, Helvetica, sans-serif"><%=replace(companynameurl,"http://","")%></font>)制作并颁发此证。<b><br>
                                <br>
                                证明</b>：<br>
                                <br>
                                <b>域名<font color="#FF0000"> <font face="Arial, Helvetica, sans-serif"><%if instr(rs("strDomain"),"xn--")=0 then
  Response.write  rs("strDomain") 
	else
  Response.write  rs("strDomain") & "("&rs("s_memo")&")"
	end if%></font> 
                                </font>已由<font color="#FF0000"> <font face="Arial, Helvetica, sans-serif"><%= rs("dom_org") %></font></font> 
                                注册，并已在国际顶级域名数据库中记录。</b></p>
                            </td>
                          </tr>
                        </table>
                        <br>
                        <table width="80%" border="0" cellpadding="2" cellspacing="1" bordercolor="#FFFFFF" bgcolor="#999999" >
                          <tr bgcolor="#FFFFFF"> 
                            <td width="45%" align="right"> 
                              <div align="left"><font face="Arial, Helvetica, sans-serif">域名(Domain 
                                Name)：</font></div>
                            </td>
                            <td width="55%" align="left" valign="middle"><font face="Arial, Helvetica, sans-serif"><%if instr(rs("strDomain"),"xn--")=0 then
  Response.write  rs("strDomain") 
	else
  Response.write  rs("strDomain") & "("&rs("s_memo")&")"
	end if%></font></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td width="45%" align="right"> 
                              <div align="left"><font face="Arial, Helvetica, sans-serif">域名注册人(Registrant,中文)：</font></div>
                            </td>
                            <td width="55%" align="left" valign="middle"><font face="Arial, Helvetica, sans-serif">
							<%If  isnull(rs("dom_org_m")) Then%>
							    <%= rs("dom_org") %>
							<%else%>
							    <%= rs("dom_org_m") %>
						    <%End  if%>

							</font></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td width="45%" align="right"> 
                              <div align="left"><font face="Arial, Helvetica, sans-serif">域名注册人(Registrant,English)：</font></div>
                            </td>
                            <td width="55%" align="left" valign="middle"><font face="Arial, Helvetica, sans-serif">
							<%If  isnull(rs("dom_org")) Then%>
							<%= rs("dom_org_cn") %>
							<%else%>
							<%= rs("dom_org") %>
                             <%End   if%>
							</font></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td width="45%" align="right"> 
                              <div align="left"><font face="Arial, Helvetica, sans-serif">注册时间(Registration 
                                Date)：</font></div>
                            </td>
                            <td width="55%" align="left" valign="middle"><font face="Arial, Helvetica, sans-serif"><%= rs("regdate") %> 
                              </font></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td width="45%" align="right"> 
                              <div align="left"><font face="Arial, Helvetica, sans-serif">到期时间(Expiration 
                                Date)：</font></div>
                            </td>
                            <td width="55%" align="left" valign="middle"><font face="Arial, Helvetica, sans-serif"> 
                              <%= rs("rexpiredate") %> </font></td>
                          </tr>


                          <tr bgcolor="#FFFFFF"> 
                            <td width="45%" align="right"> 
                              <div align="left"><font face="Arial, Helvetica, sans-serif">域名服务器(Domain 
                                Name Server)1：</font></div>
                            </td>
                            <td width="55%" align="left" valign="middle"><font face="Arial, Helvetica, sans-serif"> 
                              <%= rs("dns_host1") %> </font></td>
                          </tr>
		 

                          <tr bgcolor="#FFFFFF"> 
                            <td width="45%" align="right"> 
                              <div align="left"><font face="Arial, Helvetica, sans-serif">域名服务器(Domain 
                                Name Server)2：</font></div>
                            </td>
                            <td width="55%" align="left" valign="middle"><font face="Arial, Helvetica, sans-serif"><%= rs("dns_host2") %> 
                              </font></td>
                          </tr>
		 
                          </table>
                        <%
						if getcercoin(imgsrc) then
						%>     
                           <div id="Layer2" style="position:absolute; width:115.5pt; height:114.75pt; z-index:200; right: 100px;top:330px;"><img src="<%=imgsrc%>" width="153" height="153"></div>
                        <%
						end if
						%>   

                        <br>
                        <br>
                        <table width="80%" border="0" align="center">
                          <tr> 
                            <td> <p align="left" >以下说明与本证书主文一起构成本证书统一整体，不可分割：<br>
                                <br>
                                <font style="font-size:9pt;line-height:13pt"> 
                                1．本证书表明证书上列出的组织或者个人是列出的域名的合法注册人。该注册人依法享有该域名项下之各项权利。<br>
                                <%
								if len(trim(company_Name)&"")<=0 then company_Name=companyname
								%>
                                2．本证书并不表明<%=companyname%>的运营商---<%=company_Name%>对本证书所列域名是否贬斥、侵害或毁损任何第三人之合法权利或利益作出任何明示或默示之评判、确认、担保，或作出其它任何形式之意思表示。<%=companyname%>亦无任何责任或义务作出上述之评判、确认、担保，或作出其它任何形式之意思表示。<br>
                                3．因本证书中所列域名之注册或使用而可能引发与任何第三人之纠纷或冲突,均由该域名注册人本人承担，<%=companyname%>不承担任何法律责任。<%=companyname%>亦不在此类纠纷或冲突中充当证人、调停人或其它形式之参与人。<br>
                                4．本证书不得用于非法目的，<%=companyname%>不承担任何由此而发生或可能发生之法律责任。</font></p>
                              <p align="left" > 当本证书持有、出具、展示或以其它任何形式使用时，即表明本证书之持有人或接触人已审读、理解并同意以上各条款之规定。</p>
                            </td>
                          </tr>
                        </table>
                        <br>
                      </td>
                    </tr>
                    <tr> 
                      <td colspan="3" height="20" rowspan="2"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="20">
                          <tr bgcolor="#CCCCCC"> 
                            <td> 
                              <div align="center">关于域名的相关情况，请查询 <%=replace(companynameurl,"http://","")%></div>
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </table>

                </td>
              </tr>
            </table>
          </td>
          <td rowspan="2" width="14" bgcolor="#CC3333">&nbsp;</td>
        </tr>
        <tr> 
          <td width="610" height="14" bgcolor="#CC3333">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</div>
</body>
<%function getcercoin(byref imgsrc)
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
</html>
