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

serverid=getloastdmid("serverid")
If Not isnumeric(serverid&"") Then serverid=0
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>同步上级服务器</title>
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


function synserver(){
    var serverid=$("input[name='serverid']")
    var msg_=$("#synmsg")
    if(!isNaN(serverid)){
        serverid=0;
    }
    bh++;
    msg_.html("正常进行第<font color=red>"+bh+"</font>次数据同步")
     $.ajax({
        type: "post",
        url: "../admin/synload.asp",
        data:{act:"synserver",serverid:serverid.val()},
        dataType: "json",
        success: function (response) {
            if(response.result=="200"){
                if(response.serverid==0){
                    msg_.html("同步数据成功!")
                }else{
                    serverid.val(response.serverid);
                     msg_.html("请稍后...");
                     setTimeout("synserver()", 1000);
                }
            }else{
                msg_.html("出错了,"+response.msg);
            }
        },
        error:function(a,b,c){
            errnum++
            if(errnum<maxerr) {
                msg_.html("出错了,准备重试请稍后...");
                setTimeout("synserver()", 3000);
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
    <th height="25" style="font-weight:bold;font-size:14px;">虚拟主机同步</th>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td ><strong>管理导航：</strong><a href="default.asp">服务器/VPS管理</a> | <a href="ServerListnote.asp">查看新订单</a> | <a href="ServerWarn.asp">查看过期订单</a> | <a href="syn.asp">同步上级服务器</a></td>
  </tr>
</table>
<br />
<div class="synbox">
<div id="synmsg"></div>
开始ID:<input type="text" name="serverid" value="<%=serverid%>"> <input type="button" value="开始同步" onclick="synserver()">
<BR>
如要全部同步请将ID设置为0
</div>
</body>
</html>