


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%
response.charset="gb2312"
mailID=Trim(Requesta("id"))
act=trim(lcase(requesta("act")))
nolook=false
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
m_size=rs("m_size")
m_mxuser=rs("m_mxuser")
if m_buytest then
	Url_return "��Ǹ�������ʾ��޷�����",-1
end if
'''''''''''''''''''����''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

select case act
       case "tocountsize"  'diy
			   userNum=requesta("userNum")
			   MailSize=requesta("MailSize")
			   s_price=getDiyMailprice(m_size/m_mxuser,m_mxuser)
			   T_price=getDiyMailprice(MailSize,userNum)

			   UsedDays=DateDiff("d",s_buyDate,Now)'������ͬ���ڵı�
			   LeftDays=DateDiff("d",Now,DateAdd("yyyy",s_year,s_buyDate))'����ʱ������ڵı�
			   TotalDays=UsedDays+LeftDays'��ʱ��
		    NeedPrice=clng((T_price-s_price)/365*LeftDays)  'clng((T_price/365)*LeftDays-(s_Price*s_year)*(1-UsedDays/TotalDays))
			if NeedPrice<20 then NeedPrice=20
			   %>
			(�¼�[<font color="#FF0000"><%=T_price%></font>]-ԭ��[<font color="#FF0000"><%=s_price%></font>])��������[365]��ʣ������[<font color="#FF0000"><%=LeftDays%></font>]=<font color="#FF0000"><%=NeedPrice%></font>

			   <%
		response.end

	   case "needtargetprice"

	   		targetProid=trim(requesta("targetProid"))
			updateType=trim(requesta("upType"))

			u_levelid=trim(requesta("u_levelid"))
			if targetProid<>"" then
			  Sql="Select p_price from pricelist where p_u_level=" &  u_levelid & " and p_proid='" & targetProid & "'"

			  set TestRs=conn.execute(Sql)
			  if not TestRs.eof then T_price=TestRs("p_price")'������ļ۸�
			  TestRs.close
			  set TestRs=nothing

			  	UsedDays=DateDiff("d",s_buyDate,Now)'������ͬ���ڵı�
				LeftDays=DateDiff("d",Now,DateAdd("yyyy",s_year,s_buyDate))'����ʱ������ڵı�
				TotalDays=UsedDays+LeftDays'��ʱ��

				if updateType="OldupdateType" then
	 					 NeedPrice=clng((T_price/365)*LeftDays-(s_Price*s_year)*(1-UsedDays/TotalDays))
				elseif updateType="NewupdateType"  then
						 'NeedPrice=clng(T_price-s_price*(1-UsedDays/365))

						 dayprice=T_price/365-s_price/365


						 NeedPrice=clng(dayprice*LeftDays)

						 dayprice=Formatnumber(dayprice,2,-1)
				end if

				if NeedPrice<50 then NeedPrice=50
				if updateType="OldupdateType" then
					%>
                    ��ǰ�۸�[<font color="#FF0000"><%=T_price%></font>]��365����ʣ����[<font color="#FF0000"><%=LeftDays%></font>]-ԭ�۸�[<font color="#FF0000"><%=s_price*s_year%></font>]��(1-ʹ������[<font color="#FF0000"><%=UsedDays%></font>]��<%=TotalDays%>)=<font color="#FF0000"><%=NeedPrice%></font>
                    <%
				else
					%>
                      ÿ����[<font color="#FF0000"><%=dayprice%></font>]��ʣ������[<font color="#FF0000"><%=LeftDays%></font>]=
                    <font color="#FF0000"><%=needPrice%></font>Ԫ
                    <%
				end if
				response.write "<input type=""hidden"" name=""needprice"" value="""& NeedPrice &""">"
			else
				response.write "����ȷѡ��"
			end if
			response.end

end select
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

if DateDiff("d",Now,DateAdd("yyyy",s_year,s_buyDate))<0 then trstr="disabled=""disabled"""
OneYear=true
if s_year>1 then OneYear=False

%>

<HEAD>
<title>�û������̨-��ҵ�ʾ�</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<style>
.redAlert_Box {
    background-color: #FFFDE4;
    border: 1px solid #FF9900;
    padding: 10px;
    margin: 0px 1px 0px 2px;
    font-size: 14px;
    color: #F30;
    font-weight: bold;
    line-height: 22px;
}
</style>

<script language=javascript src="/config/ajax.js"></script>
<script language=javascript>
var m_id=<%=mailID%>;
function dochangeProid(v)
{
	var url="<%=request("script_name")%>?act=needtargetprice";
	var divID="needpriceid";
	var f=document.form1.updateType;
	var upType="NewupdateType";
	for(i=0;i<f.length;i++){
		if(document.form1.updateType[i].checked){
			upType=document.form1.updateType[i].value;
			break;
		}

	}
	if(v!=''){
		var sinfo="targetProid=" + v + "&upType="+ upType +"&id=<%=mailid%>&u_levelid=<%=session("u_levelid")%>";

		makeRequestPost(url,sinfo,divID);
	}
}
function dochangeType(){

	var proid=document.form1.TargetT;
	var t=proid.options[proid.selectedIndex].value;
	dochangeProid(t);
}
function dosub(f){
	p="<%=s_ProductId%>";
	if(p=="freemail"){
		str="������ʾ��\n���ʾִ�����������շ��ʾ�����outlook��������ʼ����ݵ����غ��ύ���ʱش���������ʾֵ��շ��ʾ�ר�÷�������������ԭ�ʼ��������������ʺź�����ᱣ����ȷ���˲�����"
		}else{
		str	='ȷ���˲�����?'
			}
	if(confirm(str)){
		document.getElementById('loadspan').style.display='';
		f.C1.disabled=true;
		f.submit();
		return true;
	}
	return false;
}

function getneedmoney(){
		var userNumObj=document.form1.userNum;
		var userNumValue=userNumObj.value;
		if(isNaN(userNumValue)){
			userNumObj.value=5;
			userNumValue=5;
		}
		if(userNumValue<5){
			userNumObj.value=5;
			userNumValue=5;
		}
		if(userNumValue>10000){
			userNumObj.value=10000;
			userNumValue=10000;
		}
		var MailSizeValue=getRadioValue();
		if(MailSizeValue==""){
			alert("��ѡ��ÿ�������С");
			return false;
		}
		var divid="upneedpricespan";
		var divid1="upm_sizespan";
		var postinfo="act=toCountSize&ID=<%=mailID%>&userNum=" + userNumValue + "&MailSize="+ MailSizeValue;

		$.ajax({
			   type:"POST",
			   url:window.location.pathname,
			   data:postinfo,
			   cache:false,
			   timeout:10000,
			   success:function(data){
				    $("#needpriceid").html(data)
				   }
			   });
}
function getRadioValue(){
		var MailSizeObj=document.form1.MailSize;
		for(t=0;t<MailSizeObj.length;t++){
			if(MailSizeObj[t].checked){
				return MailSizeObj[t].value;
				break;
			}
		}
		return "";
}

</script>
<script src="upyun.js" type="text/javascript" ></script>

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
			     <li><a href="/Manager/mailmanager/">��ҵ�ʾ�</a></li>
			   <li>��ҵ�ʾ�����</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
				<div class="redAlert_Box RedLink" id="lockmsg" style="margin:10px 0;"> 
					ȫ�������𺳵ǳ�����Ⱥ�ܹ���ǿ����������ȫ�½��棬֧����ʮ�ǿ���ܣ�Эͬ�칫����Ч���Ƽ������� <a href="javascript:upyun()" class="manager-btn s-btn red-btn">һ���������������</a>
				</div>
		        <form name="form1" method="post" action="../config/up.asp">
                 <table class="manager-table">

                 					<tbody>
                 					<tr>
                 					  <th align="right" class="tdbg">�ʾ�������</th>
                 					  <td height="15" class="tdbg" align="left"><%=Rs("m_bindname")%></td>
                 					</tr>
                 					 <tr bgcolor="#FFFFFF" <%=trstr%>>
                                                       <th align="right" class="tdbg">������ʽ<font color="#000000">��</font></th>
                                                       <td height="3" class="tdbg" align="left">
                 <%
                 '<input type="radio" id="updateType" name="updateType" value="NewupdateType" <%if not OneYear then response.write " disabled" else response.write "checked"  end if% onClick="dochangeType()">����ʱ�����Ϊ�������������<br>
                 '<input id="updateType" name="updateType" type="radio" value="OldupdateType" <%if not OneYear then response.write "checked" end if% onClick="dochangeType()">����ʱ�䲻��</td>
                 %>
                 <input id="updateType" name="updateType" type="radio" checked value="OldupdateType" onClick="dochangeType()">����ʱ�䲻��</td>

                                       </tr>

                 					<tr>
                 					  <th align="right" class="tdbg"><font color="#000000">�� �ޣ�</font></th>
                 					  <td height="16" align="left" class="tdbg"> <%=Rs("m_years")%></td>
                 					</tr>
                 					<tr>
                 					  <th align="right" class="tdbg">
                 					  <p align="right">��ͨ���ڣ�</p>                              </th>
                 					  <td height="2" align="left" class="tdbg"><%=formatDateTime(s_buydate,2)%></td>
                 					</tr>
                 					<tr>
                 					  <th align="right" class="tdbg">
                 					  <p align="right">�������ڣ�</p>                              </th>
                 					  <td height="26" align="left" class="tdbg"><%=formatDateTime(DateAdd("yyyy",s_year,s_buydate),2)%></td>
                 					</tr>
										<%If nolook then%>
                 					<tr>
                 					  <td height="26" colspan="2" bgcolor="#FFFFFF" class="tdbg" style="color:red;"><p align="left"  style="color:red;"><strong>������ʾ��</strong><br />
                 					    ���ʾִ�����������շ��ʾ�����outlook��������ʼ����ݵ����غ��ύ���ʱش���������ʾֵ��շ��ʾ�ר�÷�������������ԭ�ʼ��������������ʺź�����ᱣ����<br />
                 					  </p></td>
                 					</tr>
                 					<tr>
                 					  <th height="26" align="right" class="tdbg"> �ʾ�ԭ���ͣ�</th>
                 					  <td height="26" align="left" class="tdbg"><%=s_ProductId%></td>
                 					</tr>
								
                 					<%
                 					if s_ProductId="diymail" then
                 					%>
                 					<tr>
                 					  <th height="26" align="right" bgcolor="#FFFFFF" class="tdbg">��������</th>
                 					  <td height="26" align="left" bgcolor="#FFFFFF" class="tdbg"><%=m_mxuser%>��   ������ <input name="userNum"  class="manager-input s-input" id="userNum" type="text" class="inputbox" size="5" value="<%=m_mxuser%>" onkeyup="javascript:getneedmoney()"></td>
                 					<tr>
                 					<tr>
                 					  <th height="26" align="right" bgcolor="#FFFFFF" class="tdbg">ÿ�������С��</th>
                 					  <td height="26" align="left" bgcolor="#FFFFFF" class="tdbg"><%=formatSizeText(m_size/m_mxuser)%>��   ������
                 					  <%
                 					  mailstr=split(getdiymailconfig(),",")
                 					  for i=0 to ubound(mailstr)
                                          mailt=split(mailstr(i),":")
                 						 if mailt(0)>=1024 then
                                           %>
                 					      <input type="radio" class="manager-input s-input"  value="<%=mailt(0)%>" name="MailSize" <%if clng(mailt(0))=clng(m_size/m_mxuser) then response.write("checked")%> onclick="javascript:getneedmoney()"><%=formatSizeText(mailt(0))%>&nbsp;&nbsp;&nbsp;
                 						  <%
                 						 end if
                 					  next

                 					  %>

                 					  </td>
                 					<tr>
                 					<%else%>
								
                 					<tr>
                 					  <th height="26" align="right" bgcolor="#FFFFFF" class="tdbg">�ʾ������ͣ�</th>
                 					  <td height="26" align="left" bgcolor="#FFFFFF" class="tdbg" >
                 						<select name="TargetT" size="1" class="input" onChange="dochangeProid(this.value)">
                 						  <option value="">--ѡ�������ʾ�����--</option>
                 						  <%
                 						'  pSql="Select p_proId,p_name from productlist where p_type=2 and p_proId not in ('"& trim(s_ProductId) &"') order by p_proid"
                 						'2013 ly ���������ʾ�
                 					 pSql="Select p_proId,p_name from productlist where p_type=2 and p_proId  in ('MS5G','ms10G','ms25G','ms50G','ms100G','ms200G','gtmail') order by p_proid"
                 						  set Prs=conn.execute(psql)
                 						  do while not PRs.eof

                 						  if trim(s_ProductId)<>trim(PRs("p_proid")) then
                 						  %>
                 						  <option value="<%=PRs("p_proid")%>"><%=PRs("p_proid") & "-" & PRs("p_name")%></option>
                 						  <%
                 						  end if
                 							PRS.MoveNext
                 							Loop
                 							PRs.close
                 							Set PRS=nothing
                 %>
                 						</select>                        </td>
                 					</tr>
									<%End if%>
                 				 
                 					<tr>
                 					  <th height="26" align="right" bgcolor="#FFFFFF" class="tdbg">�����ۣ�</th>
                 					  <td height="26" align="left" bgcolor="#FFFFFF" class="tdbg">
                                       <span id="needpriceid" name="needpriceid">��ѡ�������ʾ�����</span>                      </td>
                 					</tr>
                 					<tr align="center">
                 					  <td height="1" colspan="2" class="tdbg">
                 						 <span id="loadspan" style="display:none"><img src="../images/load.gif" border=0><br>����ִ��,���Ժ�..<br></span>
                 						  <INPUT NAME="C1" TYPE="button"class="manager-btn s-btn"  VALUE="��ȷ��������" onClick="return dosub(this.form)">
                 						  <input type="hidden" name="p_id" value="<%=mailID%>">
                                           <input type="hidden" name="productType" value="mail">					 </td>
                 					</tr>
                                     <tr>
                 					<td colspan="2" align="center" class="tdbg">
                 					        <table width="100%" border="0" cellspacing="1" cellpadding="3" height="95">
                                               <tr>
                                                 <td width="82%"><ul>
                                                 <li>.�������ò���50Ԫ�ģ���50Ԫ���㡣</li>
                                                 <li>�������ܻ�ò��ֿ������͵����ݿ�������Ȳ�Ʒ����ѯ��˾�г�����</li>
                                                 </ul>                                </td>
                                               </tr>
                                             </table>					</td>
                 					</tr>
									<%End if%>
                 					</tbody>

                 				  </table>
                 				                           </form>
		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>