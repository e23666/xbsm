<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
function dvHTMLEncode(fString)
if not isnull(fString) then
    fString = replace(fString, ">", "&gt;")
    fString = replace(fString, "<", "&lt;")

    fString = Replace(fString, CHR(9), "&nbsp;")
    fString = Replace(fString, CHR(34), "&quot;")
    fString = Replace(fString, CHR(39), "&#39;")
    fString = Replace(fString, CHR(13), "")
    fString = Replace(fString, CHR(10) & CHR(10), "</P><P> ")
    fString = Replace(fString, CHR(10), "<BR> ")

    dvHTMLEncode = fString
end if
end function
function HTMLCode(SString)
if SString<>"" then


    SString = replace(SString, "&gt;",">")
    SString = replace(SString,  "&lt;","<")

   SString = Replace(SString, "&nbsp;", CHR(9))
   SString = Replace(SString, "&quot;", CHR(34))
   SString = Replace(SString, "&#39;",  CHR(39))
   SString = Replace(SString, "</P><P> ", CHR(10) & CHR(10))
   SString = Replace(SString,  "<BR> ",CHR(10))

    HTMLCode = SString
end if
end function

function gltx(p)
    p = Replace(p,"\""", "&quot;")
    p = Replace(p,"'", "")
	gltx=p
end function

conn.open constr
q_id=Requesta("qid")
If Not isnumeric(q_id&"") Then q_id=0

Act=Requesta("Act")
q_score=Requesta("q_score")
if Act="Rank" and not isNumeric(q_score) then url_return "分数结果不对",-1
if Act="Rank" then
	if session("priusername")<>"" then url_return "管理员不能代用户评分",-1
	Sql="update question set q_score=" & q_score & " where q_id=" & q_id & " and q_user_name='" & session("user_name") & "'"
	conn.Execute(Sql)
	Response.write "<script language=javascript>alert('评分保存成功，感谢您的宝贵意见，谢谢');</script>"
end if

idSet=Cstr(q_id)
Csearch=True
Do While Csearch
	Sql="Select q_fid from question where q_id=" & q_id
	Rs.open Sql,conn,1,1
	if Rs.eof Then 
		Csearch=False
	else
		if Rs("q_fid")>0 then
			idSet=idSet & "," & Rs("q_fid")
			q_id=Rs("q_fid")
		else
			Csearch=False
		end if
	end if
	Rs.close
Loop
If q_id<1 Then url_return "数据查询失败！",-1
'Sql="Select * from question where q_id in (" & idSet & ") and q_user_name='" & Session("user_name") & "' order by q_id"
Sql="Select * from Question Where (q_fid="&q_id&" or q_id="&q_id&") and q_user_name='" & Session("user_name") & "' and q_id>0 order by q_id asc"
Rs.open Sql
If rs.eof Then   url_return "数据查询失败！",-1
Function showqtype(q_type)
	Select Case q_type
		case 0101
		showqtype="售前咨询"
		case 0102
		showqtype="虚拟主机问题"
		case 0103
		showqtype="域名问题"
		case 0104
		showqtype="企业邮箱问题"
		case 0201
		showqtype="数据库问题"
		case 0202
		showqtype="主机租用/托管问题"
		case 0203
		showqtype="VPS相关问题"
		case 0204
		showqtype="财务相关问题"
		case 0301
		showqtype="续费问题"
		case 0302
		showqtype="网站备案问题"
		case 0302
		showqtype="网站推广问题"
		case 0304
		showqtype="渠道代理相关问题"
		case 0304
		showqtype="代理平台相关问题"
		case 0701
		showqtype="投诉建议"
		case 0801
		showqtype="其他"
	End Select
End Function
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-有问必答</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language="javascript">
function check_user(form){
    isrank=false;
    for (i=0;i<form.q_score.length;i++){
		if (form.q_score[i].checked){isrank=true;qscore=form.q_score[i].value;break;}
	}
	if (!isrank){alert('尊敬的用户，请选择您对该问题回答结果所评分数值,谢谢');return false;}
	   if (confirm('您确定对该问题的回复评' + qscore + '分吗?')) form.submit();
	   return false;
 }


function checkstr()
{
	if(document.form1.subject.value==""){
		alert("提示：\n\n请输入问题题目！");
		document.form1.subject.focus();
		return false;
	}
	if(document.form1.content.value==""){
		alert("提示：\n\n请输入问题内容！");
		document.form1.content.focus();
		return false;
	}
	
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
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			   <li><a href="/manager/question/allquestion.asp">有问必答</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">


<%
do while not Rs.eof
	if rs("q_fid")&""="0" and rs("q_parentID")&""<>"" and rs("q_parentID")&""<>"0" then q_parentID=rs("q_parentID")
%>
 
 
     <table  class="manager-table">
              <tr>
                <th width="20%"  align="right" valign="middle" >状态：</th>
                <td width="30%"  align="left"><%if Not rs("q_status") then
  Response.write "已回复"
else
  Response.write "<font color=red>未回复</font>"
end if%></td>
                <th width="20%"  align="right" valign="middle" >来自：</th>
                <td width="30%"   align="left"><%if rs("q_from")<>"" then 
  Response.write "[<a href=http://www.myhostadmin.net target=_blank><u>独立控制面板</u></a>]"
else
  Response.write rs("q_user_name")
end if%></td>
              </tr>
              <tr>
                <th  align="right" valign="middle" >问题题目：</th>
                <td  colspan="3"  align="left"><%=rs("q_subject")%></td>
              </tr>
              <tr>
                <th  align="right" valign="middle" >问题类别：</th>
                <td  align="left"><%=showqtype(rs("q_type")) %></td>
                <th  align="right" valign="middle" >相关域名：</th>
                <td  align="left"><%=rs("q_user_domain")%></td>
              </tr>
              <tr>
                <th  align="right" valign="middle" >相关IP地址：</th>
                <td  align="left"><%=rs("q_user_ip")%></td>
                <th  align="right" valign="middle" >提问时间：</th>
                <td align="left"><%=rs("q_reg_time")%></td>
              </tr>
              <tr>
                <th  align="right" valign="middle" >问题关键字：</th>
                <td  align="left"><%=rs("q_keyword")%></td>
                <th  align="right" valign="middle" >答复时间：</th>
                <td  align="left" ><%=rs("q_reply_time")%></td>
              </tr>
              <tr>
                <th  align="right" valign="middle" >问题描述：</th>
                <td  colspan="3" class="BlueColor"><%=rs("q_content")%></td>
              </tr>
              <tr>
                <th  align="right" valign="middle" >问题答复：</th>
                <td  align="left" colspan="3" class="OrangeText"><font color="red"><%=replace(rs("q_reply_content")&"","<img ","<img onclick='window.open(this.src)' title='点击查看大图' ")%></font></td>
              </tr>
              <tr>
                <th  align="right" valign="middle" >回复附图：</th>
                <td  colspan="3">&nbsp;

                </td>
              </tr><%
q_pic=rs("q_pic")
if q_pic<>"" then
%>
              <tr>
                <th align="right" valign="middle" >附图1：</th>
                <td colspan="3" align="left">
<div class="ac_pic"><a href="<%=q_pic%>" target=_blank><img src=<%=gltx(q_pic)%> border=0 width="350"  alt="点击看大图"></a></div>
                </td>
              </tr>
              <%end if%>
  <%if not rs("q_status") then %>
      <form name="form<%=rs("q_id")%>" action="<%=Request("script_name")%>" method="post">
          <tr>
            <th align="right" valign="top"  >回答评分： </th>
          <td colspan="3"  align="left" > <%
							if rs("q_score")=-1 then
%>
                    <input type="radio" name="q_score" value="0">
                    0分,
                    <input type="radio" name="q_score" value="1">
                    1分,
                    <input type="radio" name="q_score" value="2">
                    2分,
                    <input type="radio" name="q_score" value="3">
                    3分,
                    <input type="radio" name="q_score" value="4">
                    4分,
                    <input type="radio" name="q_score" value="5">
                    5分
                    <input type=hidden name=Act value=Rank>
                    <input type=hidden name=qid value="<%=q_id%>">
                   
                    <input type="button" name="Button" value="评分" onClick="check_user(this.form);" class="manager-btn s-btn">
                    <%
							else
								Response.write rs("q_score") & "分"
							end if
							%>                 </td>
          </tr>
 </form>
 
        <%
end if
%>
            </table>

  
<%
Rs.MoveNext
Loop
%>

<%
q_cmd="other" & vbcrlf & "get" & vbcrlf & "entityname:question" & vbcrlf & "q_id:" & q_parentID & vbcrlf & "." & vbcrlf
retcode=connectToUp(q_cmd)
if left(retcode,3)="200" Then
	if getReturn(retcode,"islock")="1" then islock = "1"
end if
if islock<>"1" then
%>
<br/><br/>
 <strong>相关链接：</strong> 
      <input type="button" name="Button2" value="我对此还有疑问" class="manager-btn s-btn" onClick="window.location.href='subquestion.asp?q_fid=<%=Requesta("qid")%>';"> 
<%end if%>










		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>














 