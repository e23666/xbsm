<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%
Check_Is_Master(6)
conn.open constr
sid=requesta("sid")
sql="select * from mailsitelist where m_sysid ="&sid
set dbrs=conn.execute(sql)
if dbrs.eof then url_return "您的企业邮局不存在" , -1
'Fields
for i=0 to dbrs.fields.Count-1
    execute(dbrs.Fields(i).Name & "=dbrs.Fields(" & i & ").value")
Next



%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<script type="text/javascript" src="/jscripts/check.js"></script>
<style type="text/css">
<!--
.STYLE4 {color: #FF0000}
#datalist tr{border-top:1px #999999 solid;border-left:1px #999999 solid;}
#datalist td{border-right:1px #999999 solid;border-bottom:1px #999999 solid; line-height:35px;padding:0 10px;}
-->
</style>
<body>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong> 企业邮局管理</strong></td>
  </tr>
</table>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="default.asp">企业邮局管理</a> | <a href="syn.asp">同步上级邮局</a> 
      | <a href="../admin/HostChg.asp">业务过户 </a></td>
  </tr>
</table>

    <form method="post" id="mailform" name="mailform" onsubmit="return false">
        <table width="100%" border="0" cellpadding="2" cellspacing="1" class="border" id="datalist">
            <thead>
                <tr class="Title"> 
                    <th colspan=2>邮局详细信息</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td  width="240" align="right">邮箱域名:</td>
                    <td> <%=m_bindname%>&nbsp;&nbsp;&nbsp;<%If m_productId<>"yunmail" then%><a href="//www.myhostadmin.net/mail/checkloginsign.asp?userid=<%=m_bindname%>&sign=<%=WestSignMd5(m_bindname,m_password)%>" target="_blank"><span class="STYLE4">进入并且管理此邮局</span></a><%End if%></td>
                </tr>
                <tr>
                    <td  width="240" align="right">邮局型号:</td>
                    <td> <%=m_productId%></td>
                </tr>
                <tr>
                    <td  width="240" align="right">购买时间:</td>
                    <td> <%=formatdatetime(m_buydate,2)%></td>
                </tr>
                <tr>
                    <td  width="240" align="right">到期时间:</td>
                    <td> <%=formatdatetime(m_expiredate,2)%></td>
                </tr>
            
                <tr>
                    <td  width="240" align="right">是否试用:</td>
                    <td> <%=iif(m_buytest,"试版","正式")%></td>
                </tr>
                <%if m_productId="yunmail" then%>
                <tr>
                    <td  width="240" align="right">邮局型号:</td>
                    <td> <%=iif(m_free,"基础版","专业版")%></td>
                </tr>
                <tr>
                    <td  width="240" align="right">开通月份:</td>
                    <td><input type="text" name="alreadypay" value="<%=alreadypay%>">月</td>
                </tr> 
                <tr>
                    <td  width="240" align="right">赠送天数:</td>
                    <td> <input type="text" name="preday" value="<%=preday%>">天</td>
                </tr> 
                <%else%>
                <tr>
                    <td  width="240" align="right">购买年份:</td>
                    <td> <input type="text" name="m_years" value="<%=m_years%>">年</td>
                </tr> 
				 <tr>
                    <td  width="240" align="right">登陆密码:</td>
                    <td> <%=m_password%>&nbsp;&nbsp;</td>
                </tr> 
                <%end if%>
                <tr>
                    <td colspan=2>
						<center>
                    <input type="hidden" name="m_id" value="<%=m_sysid%>">
                    <input type="hidden" name="act" value="update">
                    <input type="hidden" name="m_productId" value="<%=m_productId%>">
                    <input type="button" value="提交修改" onclick="editsave(this)">
                    <input type="button" value="同步上级数据" onclick="syn(<%=m_sysid%>)">
						</center>
                    </td>
                </tr>

            </tbody>
        </table>
    </form>
    <script>
    function editsave(obj){
        if(confirm("您确定要修改此数据!")){
            $.post("load.asp",$("#mailform").serialize(),function(data){
                    alert(data.msg)
                    if(data.result=="200"){
                            location.reload();
                    }
            },"json")
        } 
    }
    function syn(m_id){
          $.post("load.asp",{act:"syn",m_id:m_id},function(data){
                    alert(data.msg)
                    if(data.result=="200"){
                            location.reload();
                    }
            },"json")

    }
    </script>
</body>
</html>

