<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%
Check_Is_Master(6)
conn.open constr
sid=requesta("sid")
sql="select * from mailsitelist where m_sysid ="&sid
set dbrs=conn.execute(sql)
if dbrs.eof then url_return "������ҵ�ʾֲ�����" , -1
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
    <td height='30' align="center" ><strong> ��ҵ�ʾֹ���</strong></td>
  </tr>
</table>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="default.asp">��ҵ�ʾֹ���</a> | <a href="syn.asp">ͬ���ϼ��ʾ�</a> 
      | <a href="../admin/HostChg.asp">ҵ����� </a></td>
  </tr>
</table>

    <form method="post" id="mailform" name="mailform" onsubmit="return false">
        <table width="100%" border="0" cellpadding="2" cellspacing="1" class="border" id="datalist">
            <thead>
                <tr class="Title"> 
                    <th colspan=2>�ʾ���ϸ��Ϣ</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td  width="240" align="right">��������:</td>
                    <td> <%=m_bindname%>&nbsp;&nbsp;&nbsp;<%If m_productId<>"yunmail" then%><a href="//www.myhostadmin.net/mail/checkloginsign.asp?userid=<%=m_bindname%>&sign=<%=WestSignMd5(m_bindname,m_password)%>" target="_blank"><span class="STYLE4">���벢�ҹ�����ʾ�</span></a><%End if%></td>
                </tr>
                <tr>
                    <td  width="240" align="right">�ʾ��ͺ�:</td>
                    <td> <%=m_productId%></td>
                </tr>
                <tr>
                    <td  width="240" align="right">����ʱ��:</td>
                    <td> <%=formatdatetime(m_buydate,2)%></td>
                </tr>
                <tr>
                    <td  width="240" align="right">����ʱ��:</td>
                    <td> <%=formatdatetime(m_expiredate,2)%></td>
                </tr>
            
                <tr>
                    <td  width="240" align="right">�Ƿ�����:</td>
                    <td> <%=iif(m_buytest,"�԰�","��ʽ")%></td>
                </tr>
                <%if m_productId="yunmail" then%>
                <tr>
                    <td  width="240" align="right">�ʾ��ͺ�:</td>
                    <td> <%=iif(m_free,"������","רҵ��")%></td>
                </tr>
                <tr>
                    <td  width="240" align="right">��ͨ�·�:</td>
                    <td><input type="text" name="alreadypay" value="<%=alreadypay%>">��</td>
                </tr> 
                <tr>
                    <td  width="240" align="right">��������:</td>
                    <td> <input type="text" name="preday" value="<%=preday%>">��</td>
                </tr> 
                <%else%>
                <tr>
                    <td  width="240" align="right">�������:</td>
                    <td> <input type="text" name="m_years" value="<%=m_years%>">��</td>
                </tr> 
				 <tr>
                    <td  width="240" align="right">��½����:</td>
                    <td> <%=m_password%>&nbsp;&nbsp;</td>
                </tr> 
                <%end if%>
                <tr>
                    <td colspan=2>
						<center>
                    <input type="hidden" name="m_id" value="<%=m_sysid%>">
                    <input type="hidden" name="act" value="update">
                    <input type="hidden" name="m_productId" value="<%=m_productId%>">
                    <input type="button" value="�ύ�޸�" onclick="editsave(this)">
                    <input type="button" value="ͬ���ϼ�����" onclick="syn(<%=m_sysid%>)">
						</center>
                    </td>
                </tr>

            </tbody>
        </table>
    </form>
    <script>
    function editsave(obj){
        if(confirm("��ȷ��Ҫ�޸Ĵ�����!")){
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

