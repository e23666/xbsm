
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<html>
<head>
<title>����֤��</title>
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
if trim(u_id)&""="" then alert_redirect "�Բ��𣬲�����ʧ!","/default.asp"
if d_id="" or not isnumeric(d_id) then alert_redirect "�Բ��𣬴������!","/default.asp"
sqlstring="select * from domainlist where  d_id = "& d_id & " and userid=" &  u_id
conn.open constr
rs.open sqlstring ,conn,1,1
if rs.eof then url_return "û���ҵ�������",-1
if instr(",domwang,domcn,domchina,domcn,domgs,domhzcn,domchina,domhzcn,domgovcn,",","&rs("proid")&",")=0 then
response.redirect "cer.asp?DomainID="&d_id&"&u_id="&u_id
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
                              <div align="center"><img width="382" height="100" src="../../images/cerimg/cncertificate.gif"></div>
                            </td>
                            <td height="76"> 
                              <div align="center"><img src="../../images/cerimg/cnniclogo10.gif" width="139" height="52"></div>
                            </td>
                          </tr>
                          <tr> 
                            <td height="36" valign="middle"> 
                              <div align="center"><font color="#666666">CNNIC 
                                ��־��<br>
                                �й�����������Ϣ��������</font></div>
                            </td>
                          </tr>
                        </table>

                        <table width="80%" border="0" cellspacing="0" cellpadding="3">

                          <tr> 
                            <td> 
                              <p>��֤�����й�����������Ϣ����CNNIC��China Internet Network Information 
                                Center����Ȩ<%=companyname%>����<%=companyname%>�� <%=replace(companynameurl,"http://","")%>���������䷢��֤��<b><br>
                                <br>
                                ֤��</b>��<br>
                                <br>
                                <b>����<font color="#FF0000"> <font face="Arial, Helvetica, sans-serif"><%= rs("strDomain") %></font> 
                                </font>����<font color="#FF0000"> <font face="Arial, Helvetica, sans-serif"><%= rs("dom_org") %></font></font> 
                                ע�ᣬ�����ڹ��ʶ����������ݿ��м�¼��</b></p>
                            </td>
                          </tr>
                        </table>
                        <br>
                        <table width="80%" border="0" cellpadding="2" cellspacing="1" bordercolor="#FFFFFF" bgcolor="#999999" >
                          <tr bgcolor="#FFFFFF"> 
                            <td width="45%" align="right"> 
                              <div align="left"><font face="Arial, Helvetica, sans-serif">����(Domain 
                                Name)��</font></div>
                            </td>
                            <td width="55%" align="left" valign="middle"><font face="Arial, Helvetica, sans-serif"><%= rs("strDomain") %></font></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td width="45%" align="right"> 
                              <div align="left"><font face="Arial, Helvetica, sans-serif">����ע����(Registrant,����)��</font></div>
                            </td>
                            <td width="55%" align="left" valign="middle"><font face="Arial, Helvetica, sans-serif">
							<%=Rs("dom_org_m")%>

							</font></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td width="45%" align="right"> 
                              <div align="left"><font face="Arial, Helvetica, sans-serif">����ע����(Registrant,English)��</font></div>
                            </td>
                            <td width="55%" align="left" valign="middle"><font face="Arial, Helvetica, sans-serif"><b><font color="#FF0000"><font face="Arial, Helvetica, sans-serif"><%= rs("dom_org") %></font></font></b> 
                              </font></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td width="45%" align="right"> 
                              <div align="left"><font face="Arial, Helvetica, sans-serif">ע��ʱ��(Registration 
                                Date)��</font></div>
                            </td>
                            <td width="55%" align="left" valign="middle"><font face="Arial, Helvetica, sans-serif"><%= formatDateTime(rs("regdate") ,2)%> 
                              </font></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td width="45%" align="right"> 
                              <div align="left"><font face="Arial, Helvetica, sans-serif">����ʱ��(Expiration 
                                Date)��</font></div>
                            </td>
                            <td width="55%" align="left" valign="middle"><font face="Arial, Helvetica, sans-serif"> 
                              <%= formatDateTime(rs("rexpiredate") ,2)%></font></td>
                          </tr>


                          <tr bgcolor="#FFFFFF"> 
                            <td width="45%" align="right"> 
                              <div align="left"><font face="Arial, Helvetica, sans-serif">����������(Domain 
                                Name Server)1��</font></div>
                            </td>
                            <td width="55%" align="left" valign="middle"><font face="Arial, Helvetica, sans-serif"> 
                              <%= rs("dns_host1") %> </font></td>
                          </tr>
		 

                          <tr bgcolor="#FFFFFF"> 
                            <td width="45%" align="right"> 
                              <div align="left"><font face="Arial, Helvetica, sans-serif">����������(Domain 
                                Name Server)2��</font></div>
                            </td>
                            <td width="55%" align="left" valign="middle"><font face="Arial, Helvetica, sans-serif"><%= rs("dns_host2") %> 
                              </font></td>
                          </tr>
		 
                          </table>
                            <%
						  if getcercoin(imgsrc) then
						%>    
                    <div id="Layer2" style="position:absolute; width:115.5pt; height:114.75pt; z-index:2000; right: 100px;top:330px;"><img src="<%=imgsrc%>" width="153" height="153"></div>
                           
						<%end if%>
                        <br>
                        <br>
                        <table width="80%" border="0" align="center">
                          <tr> 
                            <td> <p align="left" >����˵���뱾֤������һ�𹹳ɱ�֤��ͳһ���壬���ɷָ<br>
                                <br>
                                <font style="font-size:9pt;line-height:13pt"> 
                                1����֤�����֤�����г�����֯���߸������г��������ĺϷ�ע���ˡ���ע�����������и���������֮����Ȩ����<br>
                                 <%
								if len(trim(company_Name))<=0 then company_Name=companyname
								%>
                                2����֤�鲢������<%=companyname%>����Ӫ��---<%=company_Name%>�Ա�֤�����������Ƿ��⡢�ֺ�������κε�����֮�Ϸ�Ȩ�������������κ���ʾ��Ĭʾ֮���С�ȷ�ϡ������������������κ���ʽ֮��˼��ʾ��<%=companyname%>�����κ����λ�������������֮���С�ȷ�ϡ������������������κ���ʽ֮��˼��ʾ��<br>
                                3����֤������������֮ע���ʹ�ö������������κε�����֮���׻��ͻ,���ɸ�����ע���˱��˳е���<%=companyname%>���е��κη������Ρ�<%=companyname%>�಻�ڴ�����׻��ͻ�г䵱֤�ˡ���ͣ�˻�������ʽ֮�����ˡ�<br>
                                4����֤�鲻�����ڷǷ�Ŀ�ģ�<%=companyname%>���е��κ��ɴ˶���������ܷ���֮�������Ρ�</font></p>
                              <p align="left" > ����֤����С����ߡ�չʾ���������κ���ʽʹ��ʱ����������֤��֮�����˻�Ӵ������������Ⲣͬ�����ϸ�����֮�涨��</p>
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
                              <div align="center">���������������������ѯ  <%=replace(companynameurl,"http://","")%></div>
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
