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
if not isnumeric(p_id) or p_id="" then url_return "参数传递错误",-1
sqlstring="select * from databaselist where dbsysid="&p_id&" and dbu_id=" & session("u_sysid")
rs.open sqlstring,conn,1,1
if rs.eof and rs.bof then url_return "没有找到此mssql数据库",-1
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
<title>用户管理后台-Mssql数据库续费</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link href="/manager/css/admin.css" rel="stylesheet" type="text/css" />
<link href="/manager/css/style.css" rel="stylesheet" type="text/css" />
<link href="<%=managercss1%>" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=managercss2%>" type="text/css" />
<script language="javascript" src="/config/ajax.js"></script>
<script language="javascript">
	function doneedprice(myvalue,u_name,proid){
		var url='../config/renewneedprice.asp?str=needprice';
		var sinfo='years='+myvalue+'&u_name='+escape(u_name)+'&proid='+ proid;
		var divID='needprice';
		makeRequestPost1(url,sinfo,divID)
	}
function dosub(f){
	if(confirm('确定此操作吗?')){
		document.getElementById('loadspan').style.display='';
		f.C1.disabled=true;
		f.submit();
		return true;
	}
	return false;
}		
</script>
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
          <div class="tab">Mssql数据库续费</div>
          <div class="table_out">
            <table width="100%" border="0" cellpadding="4" cellspacing="1" class="border managetable tableheight">
              <form name="form1" method="post" action="../config/renew.asp" >
                <tbody>
                  <tr>
                    <td width="19%" align="right" nowrap bgcolor="#FFFFFF" class="tdbg">MSSQL名</td>
                    <td width="81%" height="15" bgcolor="#FFFFFF" class="tdbg"><%=dbname%></td>
                  </tr>
                  <tr>
                    <td align="right" nowrap bgcolor="#FFFFFF" class="tdbg"><font color="#000000"> 年 限：</font></td>
                    <td height="16" bgcolor="#FFFFFF" class="tdbg"><%=dbyear%></td>
                  </tr>
                  <tr>
                    <td align="right" nowrap bgcolor="#FFFFFF" class="tdbg"><p align="right">注册日期：</p></td>
                    <td height="2" bgcolor="#FFFFFF" class="tdbg"><%=dbbuydate%></td>
                  </tr>
                  <tr>
                    <td align="right" nowrap bgcolor="#FFFFFF" class="tdbg"><p align="right">到期日期：</p></td>
                    <td height="26" bgcolor="#FFFFFF" class="tdbg"><%=dbexpdate%></td>
                  </tr>
                  <tr>
                    <td colspan="2" align="center" BGCOLOR="#FFFFFF" class="tdbg"><div class="redAlert_Box RedLink">为了使您能快捷、准确地收到续费通知等信息，请核实您的手机为：<span class="GreenColor"><%=usr_mobile%></span>，邮箱为：<span class="GreenColor"><%=usr_email%></span>，若不对，请及时<a href="/manager/usermanager/default2.asp" class="Link_Blue">修改</a>！ </div></td>
                  </tr>
                  <tr>
                    <td height="26" colspan="2" nowrap bgcolor="#FFFFFF" class="tdbg">&nbsp;</td>
                  </tr>
                  <tr>
                    <td height="26" align="right" nowrap bgcolor="#FFFFFF" class="tdbg"> 选择交费年头：</td>
                    <td height="26" bgcolor="#FFFFFF" class="tdbg"><select name="RenewYear"  ONCHANGE="doneedprice(this.value,'<%=session("user_name")%>','<%=dbproid%>')">
                        <%
						showArray=split("|(买2年送1年)|(买3年送2年)|(买5年送5年)|(买10年送10年)","|")
						xb=0
						for each i in split("1,2,3,5,10",",")%>
                        <OPTION VALUE="<%=i%>"><%=i%> 年<%=showArray(xb)%></OPTION>
                        <%
						xb=xb+1
						next%>
                      </select></td>
                  </tr>
                  <tr>
                    <td height="26" align="right" nowrap bgcolor="#FFFFFF" class="tdbg"> 交费金额：</td>
                    <td height="26" bgcolor="#FFFFFF" class="tdbg"><span id="needprice"><b><font color=red><%=renewprice%></font></b>￥/1年</span></td>
                  </tr>
                  <tr>
                    <td height="1" colspan="2" align="center" bgcolor="#FFFFFF" class="tdbg"><input type="hidden" value="<%=p_id%>" name="p_id">
                      <input type="hidden" name="productType" value="mssql">
                      <span id="loadspan" style="display:none"><img src="../images/load.gif" border=0><br>
                      正在执行,请稍候..<br>
                      </span>
                      <INPUT NAME="C1" TYPE="button" CLASS="app_ImgBtn_Big"  VALUE="　确定续费　" onClick="return dosub(this.form)">
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
