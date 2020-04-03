<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/class/Page_Class.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%Check_Is_Master(6)
response.Charset="gb2312"
response.Buffer=true
conn.open constr

function getmaxappid()
    getmaxappid=conn.execute("select max(appid) from wx_miniprogram_app")(0)
end Function

m_id=getloastdmid("mailid")
If Not isnumeric(m_id&"") Then m_id=0
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>企业邮局管理</title>
<script type="text/javascript" src="/jscripts/check.js"></script>
<script type="text/javascript" src="/jscripts/dateinput.min.js"></script>
<link href="/jscripts/dateinput.min.css" rel="stylesheet">
<link href="../css/Admin_Style.css" rel="stylesheet">  
<script type="text/javascript" src="/template/Tpl_2016/jscripts/lhgdialognew.min.js?skin=agent&self=true"></script>
<script type="text/javascript" src="/noedit/template.js"></script>
<script>
var errnum=0;
var maxerr=10;
var bh=0;


function synmail(){
    var m_id=$("input[name='m_id']")
    var msg_=$("#synmsg")
    if(!isNaN(m_id)){
        m_id=0;
    }
    bh++;
    msg_.html("正常进行第<font color=red>"+bh+"</font>次数据同步")
     $.ajax({
        type: "post",
        url: "load.asp",
        data:{act:"synlist",m_id:m_id.val()},
        dataType: "json",
        success: function (response) {
            if(response.result=="200"){
                if(response.m_id==0){
                    msg_.html("同步数据成功!")
                }else{
                    m_id.val(response.m_id);
                     msg_.html("请稍后...");
                     setTimeout("synmail()", 1000);
                }
            }else{
                msg_.html("出错了,"+response.msg);
            }
        },
        error:function(a,b,c){
            errnum++
            if(errnum<maxerr) {
                msg_.html("出错了,准备重试请稍后...");
                setTimeout("synmail()", 3000);
            }else{
                 msg_.html("出错了,"+a+b+c);
            }
        }
    });

}



   
</script>
<style>
.synbox{    BORDER: #449ae8 1px solid; margin:10px; line-height:35px;    BACKGROUND: #f0f0f0; padding:20px;}
#synmsg{color:blue}
</style>
</head>
<body>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='0' style="margin:1px 0">
  <tr class='topbg'>
    <th height="25" style="font-weight:bold;font-size:14px;">企业邮局管理同步</th>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td ><strong>管理导航：</strong><a href="default.asp"> 企业邮局管理管理</a>  | <a href="syn.asp">同步</a> </td>
  </tr>
</table>
<br />
<div class="synbox">
<div id="synmsg"></div>
开始ID:<input type="text" name="m_id" value="<%=m_id%>"> <input type="button" value="开始同步" onclick="synmail()">
<BR>
如要同步所有请将开始ID设置为0
</div>
</body>
</html>