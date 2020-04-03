<!--#include virtual="/config/config.asp" -->
<%
domainid=requesta("domainid")

conn.open constr

ACT=requesta("ACT")
if ACT="modi" then
	sql="select * from PreDomain where d_id="&domainid
	rs.open sql,conn,1,3
	if not rs.eof then
		strdomain=rs("strdomain")
		p_proid=GetDomainType(strdomain)
		for each variables_name in request.form
			if inStr(variables_name,"_")>0 and "cndom_st_m"<>variables_name then
				
					rs(variables_name)=Requesta(variables_name)
				
			end if
		next
		rs("strDomainpwd")=requesta("strDomainpwd")
		rs("years")=requesta("years")
		if p_ProId="domcn" then rs("dom_st_m")=requesta("cndom_st_m")
		rs.update
	end if
	rs.close
	response.Write("<script>alert(""订单修改成功！"");location.href='PreDomain.asp'</script>")
	response.End()
end if

sql="select * from PreDomain where d_id="&domainid
rs.open sql,conn,1,3
if rs.eof then
	url_return "域名定单不存在",-1
end if
p_proid=GetDomainType(rs("strdomain"))
if p_proid="domhk" then
ishkdom=True
else
ishkdom=false
end if

if p_proid="dom公司" or p_proid="dom网络" then
iszhdom=True
else
iszhdom=false
end if

%>




<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../../css/Admin_Style.css" rel=stylesheet>
<script language="javascript" src="/jscripts/check.js"></script>
<script>
var ishkdom="<%=ishkdom%>";
var iszhdom="<%=iszhdom%>";
var ishkmb="4";
var xz_reg_contact_type="<%=rs("reg_contact_type")%>"
var xz_custom_reg1="<%=rs("custom_reg1")%>"
var xz_custom_reg2="<%=rs("custom_reg2")%>"
var xz_dom_idnum="<%=rs("dom_idnum")%>"
var xz_dom_idtype="<%=rs("dom_idtype")%>"
</script>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>域名订单管理</strong></td>
  </tr>
</table>
<br>
<table width="99%" border="0" cellpadding="3" cellspacing="0">
              <form name=domainreg onSubmit="return CheckInput()" action="<%=Request("script_name")%>" method=post>
                <tr> 
                  <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="100%" height="2" bgcolor="#000000"></td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td valign="top">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td width="22%"  bgcolor="f7f7f7">
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>要注册的域名：</strong></td>
                            </tr>
                          </table>                        </td>
                        <td width="38%">
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td><%= rs("strdomain") %></td>
                            </tr>
                          </table>                        </td>
                        <td width="40%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td  bgcolor="f7f7f7">
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>域名管理密码：</strong></td>
                            </tr>
                          </table>                        </td>
                        <td>
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td>
                                <input name="strDomainpwd"  type="text" class="inputbox" value="<%=rs("strDomainpwd")%>" size="30" maxlength=16>                              </td>
                            </tr>
                          </table>                        </td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td  bgcolor="f7f7f7">
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>选择注册年限：</strong></td>
                            </tr>
                          </table>                        </td>
                        <td>
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td width="24%"><select name="years"  size="1" class="selectbox" onChange="GetRenewDomainPrice()">
                                <option value="<%=rs("years")%>" selected><%=rs("years")%></option>
                                  <%
							if instr(lcase(strdomain),".Pasia")<=0 then
								If vyears<>0 And vyears<>1 Then
								%>
                                  <option value="<%=vyears%>"><%= vyears %></option>
                                  <%
								Else
								%>
                                  <option value=1>1</option>
                                <%
								End If
							 getyear=1
							else
							 getyear=2
							end if
								%>
                                  <option value=2>2</option>
                                  <option value=3>3</option>
                                  <option value=4>4</option>
                                  <option value=5>5</option>
                                  <option value=6>6</option>
                                  <option value=7>7</option>
                                  <option value=8>8</option>
                                  <option value=9>9</option>
                                  <option value=10>10</option>
                                </select></td>
                              <td width="76%">&nbsp;</td>
                            </tr>
                          </table>                        </td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td  bgcolor="f7f7f7">
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>域名控制面板：</strong></td>
                            </tr>
                          </table>                        </td>
                        <td>
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td>免费提供</td>
                            </tr>
                          </table>                        </td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td  bgcolor="f7f7f7">
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>域名DNS管理器：</strong></td>
                            </tr>
                          </table>                        </td>
                        <td>
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td>免费提供</td>
                            </tr>
                          </table>                        </td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td  bgcolor="f7f7f7">
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>域名服务器(DNS)：</strong></td>
                            </tr>
                          </table>                        </td>
                        <td>
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <%
								  If dns_host1="" Then dns_host1 = DNSHOST1_SetIn
								  %>
                                <input name="dns_host1"  type="text" class="inputbox" value="<%=rs("dns_host1")%>" size="45">                              </td>
                            </tr>
                          </table>                        </td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td  bgcolor="f7f7f7">
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>域名服务器IP：</strong></td>
                            </tr>
                          </table>                        </td>
                        <td>
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <%
								  If dns_ip1="" Then dns_ip1=DNSIP1_SetIn
								  %>
                                <input name="dns_ip1"  type="text" class="inputbox" value="<%=rs("dns_ip1")%>" size="45">                              </td>
                            </tr>
                          </table>                        </td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td  bgcolor="f7f7f7">
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>域名服务器(DNS)：</strong></td>
                            </tr>
                          </table>                        </td>
                        <td>
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <%
								  If dns_host2="" Then dns_host2 = DNSHOST2_SetIn
								  %>
                                <input name="dns_host2"  type="text" class="inputbox" value="<%=rs("dns_host2")%>" size="45">                              </td>
                            </tr>
                          </table>                        </td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr background="/images/sens_mainbg2.gif"> 
                        <td colspan="3"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td  bgcolor="f7f7f7">
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>域名服务器IP：</strong></td>
                            </tr>
                          </table>                        </td>
                        <td>
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <%
								  If dns_ip2="" Then dns_ip2=DNSIP2_SetIn
								  %>
                                <input  type="text" name="dns_ip2" value="<%=rs("dns_ip2")%>" size="45" class="inputbox">                              </td>
                            </tr>
                          </table>                        </td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="22%" height="19">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td width="24%" align="center">&nbsp;</td>
                              <td width="76%" valign="bottom" class="DropShadow2"><b><font class="14pxfont">域名中文资料</font></b></td>
                            </tr>
                          </table>
                        </td>
                        <td width="78%" bgcolor="#f7f7f7">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="2" colspan="2" bgcolor="#000000"></td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td valign="top" height="191"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td width="22%" bgcolor="f7f7f7"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>域名所有者：</strong></td>
                            </tr>
                          </table>
                        </td>
                        <td width="38%"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <input name="dom_org_m" type="text" class="inputbox" value="<%=rs("dom_org_m")%>" size="45" maxlength="45">
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td width="40%">填单位名称，个人填姓名。必须是中文</td>

                     </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td width="22%" bgcolor="f7f7f7"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>姓：</strong></td>
                            </tr>
                          </table>
                        </td>
                        <td width="38%"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <input name="dom_ln_m" type="text" class="inputbox" value="<%=rs("dom_ln_m")%>" size="45" maxlength="8">
                              </td>
                            </tr>

                          </table>
                        </td>
                        <td width="40%">联系人的姓，如：张</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td width="22%" bgcolor="f7f7f7"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>名：</strong></td>
                            </tr>
                          </table>
                        </td>
                        <td width="38%"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <input name="dom_fn_m" type="text" class="inputbox" value="<%=rs("dom_fn_m")%>" size="45" maxlength="8">
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td width="40%">联系人的名字，如：小三</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>

                      <tr> 
                        <td bgcolor="f7f7f7"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>省份：</strong></td>
                            </tr>
                          </table>
                        </td>
                        <td width="38%"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                              <%
							  if p_ProId="domcn" then
							  	%>
                                <input type="text" value="<%=rs("dom_st_m")%>" name="cndom_st_m">
                                <%
							  else
							  %>
                                <select name="dom_st_m" class="selectbox" onChange="docnst(this)">
                                  <option label="请选择" value <%if rs("dom_st_m")="" then response.write "selected"%>>请选择</option>
                                  <option label="北京" value="BJ" <%if rs("dom_st_m")="BJ" then response.write "selected"%>>北京</option>
                                  <option label="香港" value="HK" <%if rs("dom_st_m")="HK" then response.write "selected"%>>香港</option>
                                  <option label="澳门" value="MO" <%if rs("dom_st_m")="MO" then response.write "selected"%>>澳门</option>
                                  <option label="台湾" value="TW" <%if rs("dom_st_m")="TW" then response.write "selected"%>>台湾</option>
                                  <option label="上海" value="SH" <%if rs("dom_st_m")="SH" then response.write "selected"%>>上海</option>
                                  <option label="深圳特区" value="SZ" <%if rs("dom_st_m")="SZ" then response.write "selected"%>>深圳特区</option>
                                  <option label="广东" value="GD" <%if rs("dom_st_m")="GD" then response.write "selected"%>>广东</option>
                                  <option label="山东" value="SD" <%if rs("dom_st_m")="SD" then response.write "selected"%>>山东</option>
                                  <option label="四川" value="SC" <%if rs("dom_st_m")="SC" then response.write "selected"%>>四川</option>
                                  <option label="福建" value="FJ" <%if rs("dom_st_m")="FJ" then response.write "selected"%>>福建</option>
                                  <option label="江苏" value="JS" <%if rs("dom_st_m")="JS" then response.write "selected"%>>江苏</option>
                                  <option label="浙江" value="ZJ" <%if rs("dom_st_m")="ZJ" then response.write "selected"%>>浙江</option>
                                  <option label="天津" value="TJ" <%if rs("dom_st_m")="TJ" then response.write "selected"%>>天津</option>
                                  <option label="重庆" value="CQ" <%if rs("dom_st_m")="CQ" then response.write "selected"%>>重庆</option>
                                  <option label="河北" value="HE" <%if rs("dom_st_m")="HE" then response.write "selected"%>>河北</option>
                                  <option label="河南" value="HA" <%if rs("dom_st_m")="HA" then response.write "selected"%>>河南</option>
                                  <option label="黑龙江" value="HL" <%if rs("dom_st_m")="HL" then response.write "selected"%>>黑龙江</option>
                                  <option label="吉林" value="JL" <%if rs("dom_st_m")="JL" then response.write "selected"%>>吉林</option>
                                  <option label="辽宁" value="LN" <%if rs("dom_st_m")="LN" then response.write "selected"%>>辽宁</option>
                                  <option label="内蒙古" value="NM" <%if rs("dom_st_m")="NM" then response.write "selected"%>>内蒙古</option>
                                  <option label="海南" value="HI" <%if rs("dom_st_m")="HI" then response.write "selected"%>>海南</option>
                                  <option label="山西" value="SX" <%if rs("dom_st_m")="SX" then response.write "selected"%>>山西</option>
                                  <option label="陕西" value="SN" <%if rs("dom_st_m")="SN" then response.write "selected"%>>陕西</option>
                                  <option label="安徽" value="AH" <%if rs("dom_st_m")="AH" then response.write "selected"%>>安徽</option>
                                  <option label="江西" value="JX" <%if rs("dom_st_m")="JX" then response.write "selected"%>>江西</option>
                                  <option label="甘肃" value="GS" <%if rs("dom_st_m")="GS" then response.write "selected"%>>甘肃</option>
                                  <option label="新疆" value="XJ" <%if rs("dom_st_m")="XJ" then response.write "selected"%>>新疆</option>
                                  <option label="湖北" value="HB" <%if rs("dom_st_m")="HB" then response.write "selected"%>>湖北</option>
                                  <option label="湖南" value="HN" <%if rs("dom_st_m")="HN" then response.write "selected"%>>湖南</option>
                                  <option label="云南" value="YN" <%if rs("dom_st_m")="YN" then response.write "selected"%>>云南</option>
                                  <option label="广西" value="GX" <%if rs("dom_st_m")="GX" then response.write "selected"%>>广西</option>
                                  <option label="宁夏" value="NX" <%if rs("dom_st_m")="NX" then response.write "selected"%>>宁夏</option>
                                  <option label="贵州" value="GZ" <%if rs("dom_st_m")="GZ" then response.write "selected"%>>贵州</option>
                                  <option label="青海" value="QH" <%if rs("dom_st_m")="QH" then response.write "selected"%>>青海</option>
                                  <option label="西藏" value="XZ" <%if rs("dom_st_m")="XZ" then response.write "selected"%>>西藏</option>
                                  <option label="外国" value="WG" <%if rs("dom_st_m")="WG" then response.write "selected"%>>外国</option>
                                </select>
                                <input type="hidden" name="cndom_st_m">
                                <script language=javascript>
								var getv1=document.domainreg.dom_st_m.options[document.domainreg.dom_st_m.selectedIndex].innerText;	
								document.domainreg.cndom_st_m.value=getv1;
								var stm=document.domainreg.dom_st_m;
								
								for (var ii=0;ii<stm.options.length;ii++){
									
									if (stm.options[ii].value=='{dom_st_m}'){
										stm.selectedIndex=ii;
									}
								}
								</script>
                                <%end if%>
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td width="40%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td width="22%" bgcolor="f7f7f7"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>城市：</strong></td>
                            </tr>
                          </table>
                        </td>
                        <td width="38%"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <input name="dom_ct_m" type="text" class="inputbox" value="<%=rs("dom_ct_m")%>" size="45" maxlength="30">
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td width="40%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td width="22%" bgcolor="f7f7f7"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>地址：</strong></td>
                            </tr>
                          </table>
                        </td>
                        <td width="38%"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <input name="dom_adr_m" type="text" class="inputbox" value="<%=rs("dom_adr_m")%>" size="45" maxlength="95">
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td width="40%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="22%" height="19">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td width="24%" align="center">&nbsp;</td>
                              <td width="76%" valign="bottom" class="DropShadow2"><b><font class="14pxfont">域名英文资料</font></b></td>
                            </tr>
                          </table>
                        </td>
                        <td width="78%" align="right" bgcolor="#f7f7f7">&nbsp; </td>
                      </tr>
                      <tr> 
                        <td height="2" colspan="2" bgcolor="#000000"></td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td valign="top" height="185"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="22%" bgcolor="f7f7f7"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>域名所有者：</strong></td>
                            </tr>
                          </table>
                        </td>
                        <td width="38%"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <input name="dom_org"  type="text" class="inputbox" value="<%=rs("dom_org")%>" size="45" maxlength="50">
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td width="40%">填写公司名称英文或者拼音，个人注册的填写拼音全称</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td width="22%" bgcolor="f7f7f7"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>姓：</strong></td>
                            </tr>
                          </table>
                        </td>
                        <td width="38%"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <input name="dom_ln"  type="text" class="inputbox" value="<%=rs("dom_ln")%>" size="45" maxlength="15">
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td width="40%">请填英文或拼音</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td width="22%" bgcolor="f7f7f7"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>名：</strong></td>
                            </tr>
                          </table>
                        </td>
                        <td width="38%"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <input name="dom_fn"  type="text" class="inputbox" value="<%=rs("dom_fn")%>" size="45" maxlength="15">
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td width="40%">请填英文或拼音</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td width="22%" bgcolor="f7f7f7"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>国家代码：</strong></td>
                            </tr>
                          </table>
                        </td>
                        <td width="38%"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <select name="dom_co" class="selectbox" style="width:170pt">
                                <option value="<%=rs("dom_co")%>"  selected><%=rs("dom_co")%></option>
								   <%       dom_co=""    
										  if dom_co ="" then
										  %>
                                  <option value="cn"  selected>China</option>
                                  <%
										   else
										 %>
                                  <option value="<%=dom_co%>"  selected><%=dom_co%></option>
                                  <%
										 end if
										 %>
                                  <option value="ac">Ascension Island</option>
                                  <option value="ad">Andorra</option>
                                  <option value="ae">United Arab Emirates</option>
                                  <option value="af">Afghanistan</option>
                                  <option value="ag">Antigua and Barbuda</option>
                                  <option value="ai">Anguilla</option>
                                  <option value="al">Albania</option>
                                  <option value="am">Armenia</option>
                                  <option value="an">Netherlands Antilles</option>
                                  <option value="ao">Angola</option>
                                  <option value="aq">Antartica</option>
                                  <option value="ar">Argentina</option>
                                  <option value="as">American Samoa</option>
                                  <option value="at">Austria</option>
                                  <option value="au">Australia</option>
                                  <option value="aw">Aruba</option>
                                  <option value="az">Azerbaijan</option>
                                  <option value="ba">Bosnia and Herzegovina</option>
                                  <option value="bb">Barbados</option>
                                  <option value="bd">Bangladesh</option>
                                  <option value="be">Belgium</option>
                                  <option value="bf">Burkina Faso</option>
                                  <option value="bg">Bulgaria</option>
                                  <option value="bh">Bahrain</option>
                                  <option value="bi">Burundi</option>
                                  <option value="bj">Benin</option>
                                  <option value="bm">Bermuda</option>
                                  <option value="bn">Brunei Darussalam</option>
                                  <option value="bo">Bolivia</option>
                                  <option value="br">Brazil</option>
                                  <option value="bs">Bahamas</option>
                                  <option value="bt">Bhutan</option>
                                  <option value="bv">Bouvet Island</option>
                                  <option value="bw">Botswana</option>
                                  <option value="by">Belarus</option>
                                  <option value="bz">Belize</option>
                                  <option value="ca">Canada</option>
                                  <option value="cc">Cocos (Keeling) Islands</option>
                                  <option value="cd">Congo, Democratic Republic 
                                  of the</option>
                                  <option value="cf">Central African Republic</option>
                                  <option value="cg">Congo, Republic of</option>
                                  <option value="ch">Switzerland</option>
                                  <option value="ci">Cote d'Ivoire</option>
                                  <option value="ck">Cook Islands</option>
                                  <option value="cl">Chile</option>
                                  <option value="cm">Cameroon</option>
                                  <option value="cn" >China</option>
                                  <option value="co">Colombia</option>
                                  <option value="cr">Costa Rica</option>
                                  <option value="cu">Cuba</option>
                                  <option value="cv">Cap Verde</option>
                                  <option value="cx">Christmas Island</option>
                                  <option value="cy">Cyprus</option>
                                  <option value="cz">Czech Republic</option>
                                  <option value="de">Germany</option>
                                  <option value="dj">Djibouti</option>
                                  <option value="dk">Denmark</option>
                                  <option value="dm">Dominica</option>
                                  <option value="do">Dominican Republic</option>
                                  <option value="dz">Algeria</option>
                                  <option value="ec">Ecuador</option>
                                  <option value="ee">Estonia</option>
                                  <option value="eg">Egypt</option>
                                  <option value="eh">Western Sahara</option>
                                  <option value="er">Eritrea</option>
                                  <option value="es">Spain</option>
                                  <option value="et">Ethiopia</option>
                                  <option value="fi">Finland</option>
                                  <option value="fj">Fiji</option>
                                  <option value="fk">Falkland Islands (Malvina)</option>
                                  <option value="fm">Micronesia, Federal State 
                                  of</option>
                                  <option value="fo">Faroe Islands</option>
                                  <option value="fr">France</option>
                                  <option value="ga">Gabon</option>
                                  <option value="gd">Grenada</option>
                                  <option value="ge">Georgia</option>
                                  <option value="gf">French Guiana</option>
                                  <option value="gg">Guernsey</option>
                                  <option value="gh">Ghana</option>
                                  <option value="gi">Gibraltar</option>
                                  <option value="gl">Greenland</option>
                                  <option value="gm">Gambia</option>
                                  <option value="gn">Guinea</option>
                                  <option value="gp">Guadeloupe</option>
                                  <option value="gq">Equatorial Guinea</option>
                                  <option value="gr">Greece</option>
                                  <option value="gs">South Georgia and the South 
                                  Sandwich Islands</option>
                                  <option value="gt">Guatemala</option>
                                  <option value="gu">Guam</option>
                                  <option value="gw">Guinea-Bissau</option>
                                  <option value="gy">Guyana</option>
                                  <option value="hk">Hong Kong</option>
                                  <option value="hm">Heard and McDonald Islands</option>
                                  <option value="hn">Honduras</option>
                                  <option value="hr">Croatia/Hrvatska</option>
                                  <option value="ht">Haiti</option>
                                  <option value="hu">Hungary</option>
                                  <option value="id">Indonesia</option>
                                  <option value="ie">Ireland</option>
                                  <option value="il">Israel</option>
                                  <option value="im">Isle of Man</option>
                                  <option value="in">India</option>
                                  <option value="io">British Indian Ocean Territory</option>
                                  <option value="iq">Iraq</option>
                                  <option value="ir">Iran (Islamic Republic of)</option>
                                  <option value="is">Iceland</option>
                                  <option value="it">Italy</option>
                                  <option value="je">Jersey</option>
                                  <option value="jm">Jamaica</option>
                                  <option value="jo">Jordan</option>
                                  <option value="jp">Japan</option>
                                  <option value="ke">Kenya</option>
                                  <option value="kg">Kyrgyzstan</option>
                                  <option value="kh">Cambodia</option>
                                  <option value="ki">Kiribati</option>
                                  <option value="km">Comoros</option>
                                  <option value="kn">Saint Kitts and Nevis</option>
                                  <option value="kp">Korea, Democratic People's 
                                  Republic</option>
                                  <option value="kr">Korea, Republic of</option>
                                  <option value="kw">Kuwait</option>
                                  <option value="ky">Cayman Islands</option>
                                  <option value="kz">Kazakhstan</option>
                                  <option value="la">Lao People's Democratic Republic</option>
                                  <option value="lb">Lebanon</option>
                                  <option value="lc">Saint Lucia</option>
                                  <option value="li">Liechtenstein</option>
                                  <option value="lk">Sri Lanka</option>
                                  <option value="lr">Liberia</option>
                                  <option value="ls">Lesotho</option>
                                  <option value="lt">Lithuania</option>
                                  <option value="lu">Luxembourg</option>
                                  <option value="lv">Latvia</option>
                                  <option value="ly">Libyan Arab Jamahiriya</option>
                                  <option value="ma">Morocco</option>
                                  <option value="mc">Monaco</option>
                                  <option value="md">Moldova, Republic of</option>
                                  <option value="mg">Madagascar</option>
                                  <option value="mh">Marshall Islands</option>
                                  <option value="mk">Macedonia, Former Yugoslav 
                                  Republic</option>
                                  <option value="ml">Mali</option>
                                  <option value="mm">Myanmar</option>
                                  <option value="mn">Mongolia</option>
                                  <option value="mo">Macau</option>
                                  <option value="mp">Northern Mariana Islands</option>
                                  <option value="mq">Martinique</option>
                                  <option value="mr">Mauritania</option>
                                  <option value="ms">Montserrat</option>
                                  <option value="mt">Malta</option>
                                  <option value="mu">Mauritius</option>
                                  <option value="mv">Maldives</option>
                                  <option value="mw">Malawi</option>
                                  <option value="mx">Mexico</option>
                                  <option value="my">Malaysia</option>
                                  <option value="mz">Mozambique</option>
                                  <option value="na">Namibia</option>
                                  <option value="nc">New Caledonia</option>
                                  <option value="ne">Niger</option>
                                  <option value="nf">Norfolk Island</option>
                                  <option value="ng">Nigeria</option>
                                  <option value="ni">Nicaragua</option>
                                  <option value="nl">Netherlands</option>
                                  <option value="no">Norway</option>
                                  <option value="np">Nepal</option>
                                  <option value="nr">Nauru</option>
                                  <option value="nu">Niue</option>
                                  <option value="nz">New Zealand</option>
                                  <option value="om">Oman</option>
                                  <option value="pa">Panama</option>
                                  <option value="pe">Peru</option>
                                  <option value="pf">French Polynesia</option>
                                  <option value="pg">Papua New Guinea</option>
                                  <option value="ph">Philippines</option>
                                  <option value="pk">Pakistan</option>
                                  <option value="pl">Poland</option>
                                  <option value="pm">St. Pierre and Miquelon</option>
                                  <option value="pn">Pitcairn Island</option>
                                  <option value="pr">Puerto Rico</option>
                                  <option value="ps">Palestinian Territories</option>
                                  <option value="pt">Portugal</option>
                                  <option value="pw">Palau</option>
                                  <option value="py">Paraguay</option>
                                  <option value="qa">Qatar</option>
                                  <option value="re">Reunion Island</option>
                                  <option value="ro">Romania</option>
                                  <option value="ru">Russian Federation</option>
                                  <option value="rw">Rwanda</option>
                                  <option value="sa">Saudi Arabia</option>
                                  <option value="sb">Solomon Islands</option>
                                  <option value="sc">Seychelles</option>
                                  <option value="sd">Sudan</option>
                                  <option value="se">Sweden</option>
                                  <option value="sg">Singapore</option>
                                  <option value="sh">St. Helena</option>
                                  <option value="si">Slovenia</option>
                                  <option value="sj">Svalbard and Jan Mayen Islands</option>
                                  <option value="sk">Slovak Republic</option>
                                  <option value="sl">Sierra Leone</option>
                                  <option value="sm">San Marino</option>
                                  <option value="sn">Senegal</option>
                                  <option value="so">Somalia</option>
                                  <option value="sr">Suriname</option>
                                  <option value="st">Sao Tome and Principe</option>
                                  <option value="sv">El Salvador</option>
                                  <option value="sy">Syrian Arab Republic</option>
                                  <option value="sz">Swaziland</option>
                                  <option value="tc">Turks and Caicos Islands</option>
                                  <option value="td">Chad</option>
                                  <option value="tf">French Southern Territories</option>
                                  <option value="tg">Togo</option>
                                  <option value="th">Thailand</option>
                                  <option value="tj">Tajikistan</option>
                                  <option value="tk">Tokelau</option>
                                  <option value="tm">Turkmenistan</option>
                                  <option value="tn">Tunisia</option>
                                  <option value="to">Tonga</option>
                                  <option value="tp">East Timor</option>
                                  <option value="tr">Turkey</option>
                                  <option value="tt">Trinidad and Tobago</option>
                                  <option value="tv">Tuvalu</option>
                                  <option value="tw">Taiwan</option>
                                  <option value="tz">Tanzania</option>
                                  <option value="ua">Ukraine</option>
                                  <option value="ug">Uganda</option>
                                  <option value="uk">United Kingdom</option>
                                  <option value="um">US Minor Outlying Islands</option>
                                  <option value="us">United States</option>
                                  <option value="uy">Uruguay</option>
                                  <option value="uz">Uzbekistan</option>
                                  <option value="va">Holy See (City Vatican State)</option>
                                  <option value="vc">Saint Vincent and the Grenadines</option>
                                  <option value="ve">Venezuela</option>
                                  <option value="vg">Virgin Islands (British)</option>
                                  <option value="vi">Virgin Islands (USA)</option>
                                  <option value="vn">Vietnam</option>
                                  <option value="vu">Vanuatu</option>
                                  <option value="wf">Wallis and Futuna Islands</option>
                                  <option value="ws">Western Samoa</option>
                                  <option value="ye">Yemen</option>
                                  <option value="yt">Mayotte</option>
                                  <option value="yu">Yugoslavia</option>
                                  <option value="za">South Africa</option>
                                  <option value="zm">Zambia</option>
                                  <option value="zw">Zimbabwe</option>
                                </select>
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td width="40%">请直接选择</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td bgcolor="f7f7f7"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>省份：</strong></td>
                            </tr>
                          </table>
                        </td>
                        <td width="38%"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td>
                                <select name="dom_st" class="selectbox">
                                  <option label="请选择" value <%if rs("dom_st")="" then response.write "selected"%>>请选择</option>
                                  <option label="北京" value="BJ" <%if rs("dom_st")="BJ" then response.write "selected"%>>北京</option>
                                  <option label="香港" value="HK" <%if rs("dom_st")="HK" then response.write "selected"%>>香港</option>
                                  <option label="澳门" value="MO" <%if rs("dom_st")="MO" then response.write "selected"%>>澳门</option>
                                  <option label="台湾" value="TW" <%if rs("dom_st")="TW" then response.write "selected"%>>台湾</option>
                                  <option label="上海" value="SH" <%if rs("dom_st")="SH" then response.write "selected"%>>上海</option>
                                  <option label="深圳特区" value="SZ" <%if rs("dom_st")="SZ" then response.write "selected"%>>深圳特区</option>
                                  <option label="广东" value="GD" <%if rs("dom_st")="GD" then response.write "selected"%>>广东</option>
                                  <option label="山东" value="SD" <%if rs("dom_st")="SD" then response.write "selected"%>>山东</option>
                                  <option label="四川" value="SC" <%if rs("dom_st")="SC" then response.write "selected"%>>四川</option>
                                  <option label="福建" value="FJ" <%if rs("dom_st")="FJ" then response.write "selected"%>>福建</option>
                                  <option label="江苏" value="JS" <%if rs("dom_st")="JS" then response.write "selected"%>>江苏</option>
                                  <option label="浙江" value="ZJ" <%if rs("dom_st")="ZJ" then response.write "selected"%>>浙江</option>
                                  <option label="天津" value="TJ" <%if rs("dom_st")="TJ" then response.write "selected"%>>天津</option>
                                  <option label="重庆" value="CQ" <%if rs("dom_st")="CQ" then response.write "selected"%>>重庆</option>
                                  <option label="河北" value="HE" <%if rs("dom_st")="HE" then response.write "selected"%>>河北</option>
                                  <option label="河南" value="HA" <%if rs("dom_st")="HA" then response.write "selected"%>>河南</option>
                                  <option label="黑龙江" value="HL" <%if rs("dom_st")="HL" then response.write "selected"%>>黑龙江</option>
                                  <option label="吉林" value="JL" <%if rs("dom_st")="JL" then response.write "selected"%>>吉林</option>
                                  <option label="辽宁" value="LN" <%if rs("dom_st")="LN" then response.write "selected"%>>辽宁</option>
                                  <option label="内蒙古" value="NM" <%if rs("dom_st")="NM" then response.write "selected"%>>内蒙古</option>
                                  <option label="海南" value="HI" <%if rs("dom_st")="HI" then response.write "selected"%>>海南</option>
                                  <option label="山西" value="SX" <%if rs("dom_st")="SX" then response.write "selected"%>>山西</option>
                                  <option label="陕西" value="SN" <%if rs("dom_st")="SN" then response.write "selected"%>>陕西</option>
                                  <option label="安徽" value="AH" <%if rs("dom_st")="AH" then response.write "selected"%>>安徽</option>
                                  <option label="江西" value="JX" <%if rs("dom_st")="JX" then response.write "selected"%>>江西</option>
                                  <option label="甘肃" value="GS" <%if rs("dom_st")="GS" then response.write "selected"%>>甘肃</option>
                                  <option label="新疆" value="XJ" <%if rs("dom_st")="XJ" then response.write "selected"%>>新疆</option>
                                  <option label="湖北" value="HB" <%if rs("dom_st")="HB" then response.write "selected"%>>湖北</option>
                                  <option label="湖南" value="HN" <%if rs("dom_st")="HN" then response.write "selected"%>>湖南</option>
                                  <option label="云南" value="YN" <%if rs("dom_st")="YN" then response.write "selected"%>>云南</option>
                                  <option label="广西" value="GX" <%if rs("dom_st")="GX" then response.write "selected"%>>广西</option>
                                  <option label="宁夏" value="NX" <%if rs("dom_st")="NX" then response.write "selected"%>>宁夏</option>
                                  <option label="贵州" value="GZ" <%if rs("dom_st")="GZ" then response.write "selected"%>>贵州</option>
                                  <option label="青海" value="QH" <%if rs("dom_st")="QH" then response.write "selected"%>>青海</option>
                                  <option label="西藏" value="XZ" <%if rs("dom_st")="XZ" then response.write "selected"%>>西藏</option>
                                  <option label="外国" value="WG" <%if rs("dom_st")="WG" then response.write "selected"%>>外国</option>
                                </select>
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td width="40%">请直接选择</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td width="22%" bgcolor="f7f7f7"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>城市：</strong></td>
                            </tr>
                          </table>
                        </td>
                        <td width="38%"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <input name="dom_ct"  type="text" class="inputbox" size="45" maxlength="30" value="<%=rs("dom_ct")%>">
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td width="40%">请填英文或拼音</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td width="22%" bgcolor="f7f7f7"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>地址：</strong></td>
                            </tr>
                          </table>
                        </td>
                        <td width="38%"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <input name="dom_adr1"  type="text" class="inputbox" size="45" maxlength="95" value="<%=rs("dom_adr1")%>">
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td width="40%">请填英文或拼音</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td width="22%" bgcolor="f7f7f7"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>邮编：</strong></td>
                            </tr>
                          </table>
                        </td>
                        <td width="38%"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <input name="dom_pc"  type="text" class="inputbox" value="<%=rs("dom_pc")%>" size="45" maxlength="6">
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td width="40%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td width="22%" bgcolor="f7f7f7"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>电话：</strong></td>
                            </tr>
                          </table>
                        </td>
                        <td width="38%"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <input name="dom_ph"  type="text" class="inputbox" value="<%=rs("dom_ph")%>" size="45" maxlength="20">
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td width="40%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td width="22%" bgcolor="f7f7f7"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>传真：</strong></td>
                            </tr>
                          </table>
                        </td>
                        <td width="38%"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <input name="dom_fax"  type="text" class="inputbox" value="<%=rs("dom_fax")%>" size="45" maxlength="20">
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td width="40%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
                      <tr> 
                        <td width="22%" bgcolor="f7f7f7"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td align="right"><strong>电子邮件：</strong></td>
                            </tr>
                          </table>
                        </td>
                        <td width="38%"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr> 
                              <td> 
                                <input name="dom_em"  type="text" class="inputbox" value="<%=rs("dom_em")%>" size="45">
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td width="40%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" background="/images/sens_mainbg2.gif"><img src="/images/sens_mainbg2.gif" width="3" height="1"></td>
                      </tr>
						<script src="/jscripts/hkdomain.js"></script>
					</table>
                  </td>
                </tr>
                <tr> 
                  <td valign="top">&nbsp; </td>
                </tr>
                <tr align="center"> 
                  <td><label>
                    <input type="submit" name="button" id="button" value=" 确定修改 ">
                    <input type="reset" name="button2" id="button2" value=" 放弃重写 ">
                    <input type="button" name="button3" id="button3" value="返回上页" onClick="javascript:history.back();">
                    <input name="ACT" type="hidden" id="ACT" value="modi">
                    <input name="domainid" type="hidden" id="domainid" value="<%=domainid%>">
                  </label></td>
                </tr>
                <tr> 
                  <td align="center"><br>
                    <table width="99%" border="0">
                      <tr> 
                        <td align="center">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td><font color="#0000FF">正式开通</font>　1、如果您的帐户上面有足够的资金，则可以选择正式开通，系统会扣除相应款项之后立即注册您的域名，实时生效。(适合于代理商及老客户等）<br>
                          <font color="#0000FF">只下订单申请</font> 2、如果您的帐户资金不足，可以选择只下订单申请，系统将为该业务生成一个订单，然后你需要将相关款项汇至我司；我们收到后将款项加在你的会员帐号下，根据该订单开通业务；您自己也可以在管理中心自行开通。（适合于首次购买的直接客户）</td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </form>
</table>
</body>
</html>
