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
	drs("userid")=session("u_sysid")  'û�е�����
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
	setTxt("��ʼͬ���������Ժ�...");
	isend=false;
	starid=$("#sid").val();
	if(starid==""){starid=0};
	starsyn()
}

function starsyn()
{
	if(size>0){
	setTxt("ÿ��ͬ��"+size+"�����ݣ���ǰ�Ѿ�ͬ��"+num+"�����ݣ�ÿ�ι�"+count+"�����ݣ����Ժ�.."+starid);}
	else{
		setTxt("����ͬ�������Ժ��Ժ���ʾ��ϸ���ݣ���")
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
			setTxt("������Ϣͬ��������");
			isend=true;
			}
		})
	
	
	//
	}else{
	setTxt("������Ϣͬ��������");
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
<tr class='topbg'> <td height='30' align="center" ><strong>ҵ����ͬ����</strong></td></tr> 
</table><TABLE WIDTH="100%" BORDER="0" CELLPADDING="8" CELLSPACING="0" CLASS="border"> 
<TR> <TD CLASS="tdbg">˵��:�����ܽ��Զ���ȡ�����ϼ��������д��ڵģ��������Ĵ���ƽ̨�в����ڵ�������ҵ�񣬲�ת�뵽<%=session("user_name")%>����</TD></TR> 
</TABLE><br>

<div style="padding:20px;">
<div id="showtxt">����ͬ��</div>
��ʼID:<input type="text" name="sid" id="sid" value="<%=getloastdmid("domainid")%>" size=5>
<input type="button" value="��ʼͬ������" onClick="sysdomain()">
<BR>
��Ҫͬ������ҵ�񵽱�������д��ʼIDΪ0
</div>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
