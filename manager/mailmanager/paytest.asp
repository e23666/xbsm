<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%
response.charset="gb2312"
mailID=Trim(Requesta("m_id"))
act=trim(lcase(requesta("act")))

conn.open constr

if not isNumeric(mailID) or mailid="" then url_return "��������",-1
Sql="Select * from mailsitelist where m_sysid=" & mailID & " and m_ownerid=" & Session("u_sysid")
Rs.open Sql,conn,1,1
if Rs.eof then url_return "δ�ҵ�������",-1
s_buyDate=Rs("m_buyDate")		'ԭ����ʱ��
s_year=Rs("m_years")		 		'ԭ��������
s_ProductId=Rs("m_ProductId")	'ԭ�ͺ�
s_price=getneedprice(session("user_name"),s_ProductId,1,"renew")			'ԭ�۸�
m_bindname=rs("m_bindname")	
m_buytest=rs("m_buytest")

if not m_buytest then
	Url_return "��Ǹ����ʽ��������ת��",-1
end if	
'''''''''''''''''''����''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

%>

<HEAD>
<title>�û������̨-��ҵ�ʾ�ת��</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link href="<%=managercss1%>" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=managercss2%>" type="text/css" />
</HEAD>
<body id="thrColEls">

<div class="Style2009"> 
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV"> 
    <!--#include virtual="/manager/manageleft.asp" -->
    <div id="MainRight">
      <div class="new_right"> 
        <!--#include virtual="/manager/pulictop.asp" -->
        
        <div class="main_table">
          <div class="tab">��ҵ�ʾ�ת��</div>
          <div class="table_out">
          
          <table width="100%" border="0" align="center" cellpadding="6" cellspacing="0" class="border managetable tableheight">
<form name="form1" method="post" action="../config/paytest.asp">
					<tbody> 
					<tr> 
					  <td width="42%" align="right" class="tdbg">�ʾ�����</td>
					  <td width="58%" height="15" class="tdbg"><%=Rs("m_bindname")%></td>
					</tr>
                                    
					<tr> 
					  <td align="right" class="tdbg"><font color="#000000">�� ��</font></td>
					  <td height="16" class="tdbg"> <%=Rs("m_years")%></td>
					</tr>
					<tr> 
					  <td align="right" class="tdbg"> 
					  <p align="right">��ͨ���ڣ�</p>                              </td>
					  <td height="2" class="tdbg"><%=formatDateTime(s_buydate,2)%></td>
					</tr>
					<tr> 
					  <td align="right" class="tdbg"> 
					  <p align="right">�������ڣ�</p>                              </td>
					  <td height="26" class="tdbg"><%=formatDateTime(DateAdd("yyyy",s_year,s_buydate),2)%></td>
					</tr>
					
					<tr> 
					  <td height="26" align="right" class="tdbg"> ���ͣ�</td>
					  <td height="26" class="tdbg"><%=s_ProductId%></td>
					</tr>
					<tr> 
					  <td height="26" align="right" bgcolor="#FFFFFF" class="tdbg">ת�������</td>
					  <td height="26" bgcolor="#FFFFFF" class="tdbg" ><%=GetNeedPrice(Session("user_name"),s_ProductId,s_year,"new")%>Ԫ</td>
					</tr>
					<tr align="center"> 
					  <td height="1" colspan="2" class="tdbg"> 
    	              <input type="hidden" name="productType" value="mail">
	                  <input type="hidden" value="<%=mailID%>" name="p_id">					 
					  <INPUT NAME="act" TYPE="submit" CLASS="app_ImgBtn_Big" id="act" onClick="return confirm('ȷ��ת��������?')"  VALUE="ȷ��ת��">
					</tr>
					</tbody> 
        </form>
				  </table>      
                
          </div>
        </div>
      </div>
    </div>
  </div>
  <!--#include virtual="/manager/bottom.asp" --> 
</div>



</body>
</html>

