<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.buffer=true
response.charset="gb2312"
conn.open constr
dim usr_mobile
dim usr_email
call getusrinfo()
p_id=requesta("id")
if not isnumeric(p_id) or p_id="" then url_return "�������ݴ���",-1
sqlstring="select * from databaselist where dbsysid="&p_id&" and dbu_id=" & session("u_sysid")
rs.open sqlstring,conn,1,1
if rs.eof and rs.bof then url_return "û���ҵ���mssql���ݿ�",-1
dbname=rs("dbname")
dbyear=rs("dbyear")
dbbuydate=formatDateTime(rs("dbbuydate"),2)
dbexpdate=formatdateTime(rs("dbexpdate"),2)
dbproid=rs("dbproid")
'm_buytest=rs("m_buytest")
'if s_buytest then response.redirect "paytest.asp?p_id=" & hostid & "&productType=vhost":response.end
renewprice=getneedprice(session("user_name"),dbproid,1,"renew")
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-��������</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language="javascript" src="/config/ajax.js"></script>
<script language="javascript">
	function doneedprice(myvalue,u_name,proid){
		var url='../config/renewneedprice.asp?str=needprice';
		var sinfo='years='+myvalue+'&u_name='+escape(u_name)+'&proid='+ proid;
		var divID='needprice';
		makeRequestPost1(url,sinfo,divID)
	}
function dosub(f){
	if(confirm('ȷ���˲�����?')){
		document.getElementById('loadspan').style.display='';
		f.C1.disabled=true;
		f.submit();
		return true;
	}
	return false;
}
</script>

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
			   			   <li><a href="/manager/sqlmanager/">Mssql���ݿ����</a></li>
               			   <li>Mssql����</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
		   <div style="border:dashed 1px #ff0000; padding:7px; background:#ffff99; width:99%; margin:10px auto; margin-bottom:5px;color:red">����ͨ������������ͨ���������ݿ��벻Ҫ��������,ֻ�ý���Ӧ�����������Ѽ�������ʹ��</div>
		    <form name="form1" method="post" action="../config/renew.asp" >
               <table class="manager-table">

                               <tbody>
                                 <tr>
                                   <th width="19%" align="right" nowrap bgcolor="#FFFFFF" class="tdbg">MSSQL����</th>
                                   <td width="81%" height="15" bgcolor="#FFFFFF" align="left" class="tdbg"><%=dbname%></td>
                                 </tr>
                                 <tr>
                                   <th align="right" nowrap bgcolor="#FFFFFF" class="tdbg"><font color="#000000"> �� �ޣ�</font></th>
                                   <td height="16" bgcolor="#FFFFFF"align="left" class="tdbg"><%=dbyear%></td>
                                 </tr>
                                 <tr>
                                   <th align="right" nowrap bgcolor="#FFFFFF" class="tdbg"><p align="right">ע�����ڣ�</p></th>
                                   <td height="2" bgcolor="#FFFFFF" align="left" class="tdbg"><%=dbbuydate%></td>
                                 </tr>
                                 <tr>
                                   <th align="right" nowrap bgcolor="#FFFFFF" class="tdbg"><p align="right">�������ڣ�</p></th>
                                   <td height="26" bgcolor="#FFFFFF" align="left" class="tdbg"><%=dbexpdate%></td>
                                 </tr>
                                 <tr>
                                   <td colspan="2" align="center" BGCOLOR="#FFFFFF" class="tdbg"><div class="redAlert_Box RedLink">Ϊ��ʹ���ܿ�ݡ�׼ȷ���յ�����֪ͨ����Ϣ�����ʵ�����ֻ�Ϊ��<span class="GreenColor"><%=usr_mobile%></span>������Ϊ��<span class="GreenColor"><%=usr_email%></span>�������ԣ��뼰ʱ<a href="/manager/usermanager/default2.asp" class="Link_Blue">�޸�</a>�� </div></td>
                                 </tr>
                                 <tr>
                                   <th height="26" align="right" nowrap bgcolor="#FFFFFF" class="tdbg"> ѡ�񽻷���ͷ��</th>
                                   <td height="26" bgcolor="#FFFFFF" class="tdbg" align="left"><select name="RenewYear"  ONCHANGE="doneedprice(this.value,'<%=session("user_name")%>','<%=dbproid%>')">
                                       <%
               						showArray=split("|(��2����1��)|(��3����2��)|(��5����5��)|(��10����10��)","|")
               						xb=0
               						for each i in split("1,2,3,5,10",",")%>
                                       <OPTION VALUE="<%=i%>"><%=i%> ��<%=showArray(xb)%></OPTION>
                                       <%
               						xb=xb+1
               						next%>
                                     </select></td>
                                 </tr>
                                 <tr>
                                   <th height="26" align="right" nowrap bgcolor="#FFFFFF" class="tdbg"> ���ѽ�</th>
                                   <td height="26" bgcolor="#FFFFFF" class="tdbg" align="left"><span id="needprice"><b><font color=red><%=renewprice%></font></b>��/1��</span></td>
                                 </tr>
                                 <tr>
                                   <td height="1" colspan="2" align="center" bgcolor="#FFFFFF" class="tdbg"><input type="hidden" value="<%=p_id%>" name="p_id">
                                     <input type="hidden" name="productType" value="mssql">
                                     <span id="loadspan" style="display:none"><img src="../images/load.gif" border=0><br>
                                     ����ִ��,���Ժ�..<br>
                                     </span>
                                     <INPUT NAME="C1" TYPE="button" class="manager-btn s-btn" VALUE="��ȷ�����ѡ�" onClick="return dosub(this.form)">
                                 </tr>
                               </tbody>

                           </table>
                            </form>
		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>