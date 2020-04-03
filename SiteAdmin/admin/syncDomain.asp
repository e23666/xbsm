<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" --> 
<%Check_Is_Master(1)
If requesta("act")="sync" Then
	conn.open constr
  starid=requesta("starid")
  If Not isnumeric(starid&"") Then starid=0
  
strCmd="other"&vbcrlf&_
	   "sync"&vbcrlf&_
	   "entityname:domainnew"&vbcrlf&_
	   "starid:"&starid&""&vbcrlf&_
	   "."&vbcrlf
	   
strReturn=connectToUp(strcmd)
'response.Write(strReturn)
starid=getReturn(strReturn,"starid")
countsize=getReturn(strReturn,"countsize")
countnum=0
if starid="-1" then  die "-1,0,0"
countnum=getReturn(strReturn,"count")
fdlist=split(getReturn(strReturn,"fdlist"),",")
fieldlist=split(getReturn_rrset(strReturn,"fieldlist"),vbcrlf&"$")

set drs=server.CreateObject("adodb.recordset")
for	di=0 to ubound(fieldlist)-1
	dtemp=split(fieldlist(di),"^|$|^")
	starid=dtemp(0)
	'd_id,strDomain,regdate,rexpiredate,strDomainpwd,years
	sql="select top 1 * from domainlist where strdomain='"&dtemp(1)&"' or s_memo='"&dtemp(1)&"'"
	drs.open sql,conn,1,3
	if drs.eof then
	drs.addnew()
	drs("userid")=session("u_sysid")  '没有的数据
	drs("strdomain")=dtemp(1)
	end if
		for zdi=2 to ubound(fdlist)
		    'response.Write(dtemp(zdi)&"<BR>")
			execute "drs(fdlist(zdi))=dtemp(zdi)"
		next
	
	drs.update
	drs.close
	'response.Write("<hr>")
next
 ' application("updomstrid")=starid
  call setloastdmid("domainid",starid)
  die starid&","&countsize&","&countnum&""
  
End if







 








%> <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> <HTML><HEAD> 
<TITLE></TITLE>
<script src="/jscripts/jq.js"></script>
<script>
var count=0;
var size=0;
var starid=0;
var isend=false
var num=1

function sysdomain()
{
	setTxt("开始同步数据请稍后...");
	isend=false;
	starid=$("#sid").val();
	if(starid==""){starid=0};
	starsyn()
}

function starsyn()
{
	if(size>0){
	setTxt("每次同步"+size+"条数据，当前已经同步"+num+"次数据，每次共"+count+"条数据，请稍后.."+starid);}
	else{
		setTxt("数据同步中请稍后，稍后显示详细数据！！")
		}
	if(!isend)
	{
	url="?act=sync&starid="+starid+"&m="+Math.random();
		$.get(url,"",function(d){
			temp=d.split(",")
			if (temp[0]>0)
			{
				if (count==0)
				{
				count=temp[2];
				size=temp[1];
				}
				num++;
				starid=temp[0];
				window.setTimeout("starsyn()",500)
			}
			else
			{
			setTxt("域名信息同步结束！");
			isend=true;
			}
		})
	
	
	//
	}else{
	setTxt("域名信息同步结束！");
	}

}

function setTxt(t)
{
$("#showtxt").html(t);
}
</script>
<META http-equiv=Content-Type content="text/html; charset=gb2312"> 
<LINK href="../css/Admin_Style.css" rel=stylesheet> <body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'> 
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'> 
<tr class='topbg'> <td height='30' align="center" ><strong>业　务　同　步</strong></td></tr> 
</table><TABLE WIDTH="100%" BORDER="0" CELLPADDING="8" CELLSPACING="0" CLASS="border"> 
<TR> <TD CLASS="tdbg">说明:本功能将自动读取您在上级服务商中存在的，但在您的代理平台中不存在的域名等业务，并转入到<%=session("user_name")%>名下</TD></TR> 
</TABLE><br>

<div style="padding:20px;">
<div id="showtxt">数据同步</div>
开始ID:<input type="text" name="sid" id="sid" value="<%=getloastdmid("domainid")%>" size=5>
<input type="button" value="开始同步域名" onClick="sysdomain()">
<BR>
如要同步所有业务到本地请填写开始ID为0
</div>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
