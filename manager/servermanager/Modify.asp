<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%
response.Charset="gb2312"
dim httpstr:httpstr="http"
if ishttps() then  httpstr="https"
function getHostType(ByVal xxx,ByVal p)
	select case xxx
		case 0
			getHostType="��������"
		case 1
		    if instr(lcase(p),"vps")>0 then
			getHostType="VPS����"
			exit function
			end if
			if instr(lcase(p),"ebscloud")>0 then
			getHostType="����������"
			exit function
			end if
			if instr(lcase(p),"cloud")>0 then
			getHostType="�ײ�������"
			exit function
			end if
			
			
		case 2
			getHostType="�����й�"
	end select
end function

conn.open constr
id=Trim(Requesta("id"))
pdsmod=Trim(requestf("pdsmod"))
if not isNumeric(id) then url_return "pleaes input ID",-1
set bs=new buyServer_Class:bs.setUserid=session("u_sysid"):bs.oldhostid=id


userip = httpstr&"://" & request.ServerVariables("SERVER_NAME") & request.ServerVariables("PATH_INFO")
'die userip

if trim(pdsmod)="add" and id<>"" then
	call bs.getHostdata(id)
	bs.getPostvalue()
	result=bs.modifyInfo()
	if left(result,3)="200" then
	Alert_redirect "���³ɹ�", request("script_name") &"?id="&id
	else
		url_return "����ʧ��:"&result,-1
	end if
	response.end
end if
sql="select top 1 * from hostrental where u_name='"& session("user_name") &"' and id="& id
set zxwRS=conn.execute(sql)
if not zxwRs.eof then
	userName=zxwRs("Name")
	company=zxwRs("company")
	telephone=zxwRs("telephone")
	address=zxwRs("address")
	Email=zxwRs("Email")
	QQ=zxwRs("QQ")
	u_name=zxwRs("u_name")
	fax=zxwRs("fax")
	startTime=zxwRs("startTime")
	alreadypay=zxwRs("alreadypay")
	start=zxwRS("start")
	hosttype=zxwRS("hosttype")
	allocateIp=zxwRS("allocateIp")
	RamdomPass=zxwRS("RamdomPass")
	p_proid=zxwRS("p_proid")
	prodtype=zxwRs("prodtype")
	
		if isnull(zxwRs("preday")) Or zxwRs("preday")="" then 
		  preday=0
		  else
		  preday=clng(zxwRs("preday"))
		  end If

	if trim(allocateIp)&""="" then allocateIp="δ��ͨ"
else
	url_return "��������",-1
end if
zxwRs.close
set zxwRs=nothing

sText=getHostType(hosttype,p_proid)
sing = ASP_MD5(allocateIp & userip & RamdomPass)
'Response.write(allocateip)
 
call doUserSyn("server",allocateip)
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-���������й���ϸ����</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
 

</HEAD>
<body>
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			   <li><a href="/Manager/servermanager/">����IP��������</a></li>
			   <li>���������й���ϸ����</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
		  <form name="form1" action="<%=request("script_name")%>" method="post">
<table class="manager-table">              
                <tbody>
                  <tr>
                    <th colspan="2">�������Ϲ���[��������:<%=sText%>]</th>
                  </tr>
                  <tr>
                    <th align="right">������ip:</th>
                    <td align="left"><%=allocateIp%></td>
                  </tr>
				   <tr>
                    <th align="right">����������:</th>
                    <td align="left">
					<%Select Case Trim(prodtype&"")
					Case "1"
						Response.write "��ƵCPU��"
					Case else
						Response.write "��ͨ��"
					End select
					%>
					</td>
                  </tr>
                  <tr>
                    <th align="right" >Ĭ�ϳ���:</th>
                    <td align="left">Administrator</td>
                  </tr>
                  <tr>
                    <th align="right" >��˾����:</th>
                    <td align="left"><%=company%></td>
                  </tr>
                  <tr>
                    <th align="right" >�û�:</h>
                    <td align="left"><%=u_name%></td>
                  </tr>
                  <tr>
                    <th align="right" >��ϵ��:</th>
                    <td align="left"><input type=text value="<%=userName%>" name="Name"  class="manager-input s-input"></td>
                  </tr>
                  <tr>
                    <th align="right" >�绰</th>
                    <td align="left"><input type=text value="<%=telephone%>" name="telephone"  class="manager-input s-input"></td>
                  </tr>
                  <tr>
                    <th align="right" >�ֻ�:</th>
                    <td align="left"><input type=text value="<%=fax%>" name="fax"  class="manager-input s-input"></td>
                  </tr>
                  <tr>
                    <th align="right" >Email:</th>
                    <td align="left"><input type=text value="<%=email%>" name="Email"  class="manager-input s-input"></td>
                  </tr>
                  <tr>
                    <th align="right" >QQ:</th>
                    <td align="left"><input type=text value="<%=QQ%>" name="QQ"  class="manager-input s-input"></td>
                  </tr>
                  <tr>
                    <th align="right" >��ַ:</th>
                    <td align="left"><input type=text value="<%=address%>" name="address"  class="manager-input s-input"></td>
                  </tr>
                  <%if start then%>
                  <tr>
                    <th align="right" >��ʼ����:</th>
                    <td align="left"><input type="text" value="<%=RamdomPass%>" name="ramdompass"  class="manager-input s-input" /></td>
                  </tr>
                  <tr>
                    <th align="right" >��ͨʱ��:</th>
                    <td align="left"><%=startTime%></td>
                  </tr>
                  <tr>
                    <th align="right" >����ʱ��:</th>
                    <td align="left"><% Response.write(formatDateTime(DateAdd("d",preday,DateAdd("m",alreadypay,startTime)),2)) %></td>
                  </tr>
                  <% end if	%>
                  <tr>
                    <td colspan="2" ><input name="C1" type="submit" class="manager-btn s-btn"   value=" ȷ���޸� ">
                     
                      <input type="button" value="�߼��������" onClick="document.j.submit()" class="manager-btn s-btn" >
                      <input type=button value=" �� �� " onClick="javascript:location.href='default.asp';" class="manager-btn s-btn">
                      <input type="hidden" name="id" value="<%=id%>">
                      <input type="hidden" name="pdsmod" value="add"></td>
                  </tr>
                </tbody>
              </form>
              <form style="display:none"  target="_blank" method="post" action="<%=httpstr%>://www.myhostadmin.net/server/checklogin.asp" name="j">
                <input type="hidden" name="serverip" value="<%=allocateIp%>">
                <input type="hidden" name="sing" value="<%=sing%>">
              </form>
            </table>
            <%conn.close%>


		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>