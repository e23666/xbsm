<%
response.charset="gb2312"
response.buffer=true
%>
<!--#include virtual="/config/asp_md5.asp" -->
<!--#include virtual="/config/config.asp"-->
<%Check_Is_Master(6)%>
<script language="javascript" src="/config/ajax.js"></script>
<script language="javascript">
  function dosub(myform)
  {
     var userspd="";
	 var alertstr="";
     var contents=myform.content;
	

	 for (var i=0;i< myform.u_level.length;i++)
	 {
	   if (myform.u_level[i].checked==true)
	   {
	     userspd="ok";
		 break;
	   }
	 }
	 if(userspd==""){
	   alertstr +="-请选择发送对象!\n";
	 }
	 if(contents.value==""){
	    alertstr +="-发送内容不能为空\n";
	 }
	 if (contents.value.length>60){
	    alertstr +="-发送内容不能超过60个字符!\n";
	 }
	 
	 if (alertstr!==""){
	   alert(alertstr);
	   return false;
	 }
	 else
	 {
	   return true;
	 }
    
  }
function dokey(v)
{
  var vv=v.value;
 var num = vv.length;
  document.getElementById('lenStr').innerText=num;
 if (num>=60)
 {
  v.value=vv.substring(0,63);
  document.getElementById('lenStr').innerText=63;
  return false;
 }
 
// document.getElementById('lenStr').innerText=vv.length;

}
function dosearch(myform){
   var v=myform.userNumsearch.value;
   if (v!==''){
   		makeRequest('index.asp?str=l&content=' + v,'userNums');
		return true;
   }else{
   return false;
   }

}
function setusernum(nums){
   var v=document.form1.sendNum.value;
   var vv;
   var pd=true;
   (v!=='')?vv=v+'\n':vv=''
   if(v!==''){
   		if(v.indexOf(nums)>=0){
		 pd=false;
		}
   }
   if(pd) document.form1.sendNum.value=vv+nums;
}
function doback(pd){
    if (pd==1 || pd==2){
	document.getElementById('backpage').innerHTML='<img src="/Template/Tpl_01/images/load.gif" border="0" id="loadimg" />';
	document.getElementById('sendpage').style.display='none';
	document.getElementById('backpage').style.display='';
	
	makeRequest('sendlog.asp?str=' + pd,'backpage');
	}else{
	document.getElementById('backpage').style.display='none';
	document.getElementById('sendpage').style.display='';
	
	}
}
function Goto(the,str) {

	makeRequestPost("sendlog.asp?pageno=" + the.value + "&str="+str,'','backpage');
}
function Gotoxmlpage(href){

	makeRequestPost('sendlog.asp'+href,'','backpage');
}
</script>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet><body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>短信发送</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="index.asp">群发短信</a> | <a href="sendlog.asp?str=1">短信发送日志</a></td>
  </tr>
</table>
<br>
<%

conn.open constr
if requesta("str")="s" then
	pds=false
  if len(trim(session("timeSMS")))>0 then   
		     if DateDiff("s",session("timeSMS"),now())>=10   then
			 	session("timeSMS")=now()
			 	pds=true
			 end if	
  else
				session("timeSMS")=now()   
				pds=true
  end   if
  'if not pds then url_return "10秒后才能再次发送",-1
    content=trim(requestf("content"))
	u_levelform=trim(requestf("u_level"))
	if u_levelform&""="" then url_return "请选择用户",-1 :response.end
	if content&""="" then url_return "请输入内容",-1 :response.end
	
	if instr(u_levelform,"0")>0 or instr(u_levelform,"1")>0 then 
		if left(session("u_type"),1)<>"1" then
			url_return "权限不足",-1
		end if
	end if
	
	sendnum=""
	for each u_levelpd in split(u_levelform,",")
	     sql=""
		
	    if trim(u_levelpd)<>"" then
			  select case trim(u_levelpd)
				case "0" '代理商

				  sql="select u_telphone,u_level,u_name,u_contract,msn_msg from userdetail where u_level>=2"
				  set rsSms=conn.execute(sql)
				  if not rsSms.eof then
					do while not rsSms.eof
								sendNum1=""
								if not IsValidMobileNo(trim(rsSms("msn_msg"))) then
									 if IsValidMobileNo(trim(rsSms("u_telphone"))) then
										sendNum1=trim(rsSms("u_telphone"))
									 else
										sendNum1=""
									 end if
								else
								   sendNum1=trim(rsSms("msn_msg"))
								end if
						if sendNum1<>"" then
						  sendNum=sendNum & sendNum1 & ","
						end if
					rsSms.movenext
					loop
				  end if
				  rsSms.close
				  set rsSms=nothing
				case "1" '独立主机用户
				  	sql="Select distinct a.Fax,b.msn_msg,b.u_telphone from HostRental a left join userdetail b on a.email=b.u_email  where a.start=1"
				 	 set rsSms=conn.execute(sql)
					  if not rsSms.eof then
						do while not rsSms.eof
									sendNum1=""
									if not IsValidMobileNo(trim(rsSms("fax"))) then
											if not IsValidMobileNo(trim(rsSms("msn_msg"))) then
												 if IsValidMobileNo(trim(rsSms("u_telphone"))) then
													sendNum1=trim(rsSms("u_telphone"))
												 else
													sendNum1=""
												 end if
											else
												 sendNum1=trim(rsSms("msn_msg"))
											end if
									else
									   sendNum1=trim(rsSms("fax"))
									end if
									if sendNum1<>"" then
									  sendNum=sendNum & sendNum1 & ","
									end if
						rsSms.movenext
						loop
					 end if
					 rsSms.close
					 set rsSms=nothing
				case "2" '指定的手机号
					sendNum_array=trim(requesta("sendNum"))
					
					for each sendNum1 in split(sendNum_array,vbcrlf)
					  if IsValidMobileNo(trim(replace(trim(sendNum1),chr(32),""))) then
						sendnum=sendnum & sendNum1 & ","
					  end if
				    next
					
			  end select
		end if
	next
	if sendnum<>"" and content<>"" then
				
		returnstr = httpSendSMS(sendNum,content)
		if left(returnstr,3)<>"200" then pds=pds&"有错误:"& returnstr &"<br>"
		response.Write(returnstr)
	end if
elseif trim(requesta("str"))="l" then
	username=trim(requesta("content"))
	
	sql="select top 1 a.msn_msg,a.u_telphone,c.mobile from userDetail a left join vhhostlist b on b.s_ownerid=a.u_id left join icpinfo c on b.s_comment=c.s_comment and len(c.mobile)>=11 where a.u_name='"& username &"'"
	set sendRs=conn.execute(sql)
	if not sendRs.eof then
								if not IsValidMobileNo(trim(sendRs("msn_msg"))) then
									 if IsValidMobileNo(trim(sendRs("u_telphone"))) then
										sendNum1=trim(sendRs("u_telphone"))
									 else
											if not IsValidMobileNo(trim(sendRs("mobile"))) then
												sendNum1=""
										    else
												sendNum1=trim(sendRs("mobile"))
											end if
									 end if
								else
								   sendNum1=trim(sendRs("msn_msg"))
								end if
	end if
	if sendNum1<>"" then
	response.write "<a href=# onclick=""javascript:setusernum('"& sendNum1 &"')"">"& sendNum1 &"</a>"
	else
	response.write "对不起,没有找到手机号"
	end if
	sendRs.close
	set sendRs=nothing
end if
%><table width="100%" border="0" cellpadding="3" cellspacing="0" class="border">
                <form name="form1" action="index.asp?str=s" method="post">
                  <tr> 
                    <td width="23%" align="right" bgcolor="#FFFFFF" class="tdbg"> 
                    <input name="u_level" type="checkbox" value="0" <%if left(session("u_type"),1)<>"1" then response.write "disabled='disabled'"%> />                    </td>
                    
      <td width="77%" align="left" class="tdbg">所有代理商</td>
                  </tr>
                  <tr> 
                    <td align="right" bgcolor="#FFFFFF" class="tdbg"> 
                    <input name="u_level" type="checkbox" value="1" <%if left(session("u_type"),1)<>"1" then response.write "disabled='disabled'"%>  />                    </td>
                    
      <td align="left" bgcolor="#FFFFFF" class="tdbg">所有独立主机用户</td>
                  </tr>
                  <tr> 
                    <td align="right" bgcolor="#FFFFFF" class="tdbg"> 
                    <input name="u_level" type="checkbox" value="2" checked />                    </td>
                    <td align="left" bgcolor="#FFFFFF" class="tdbg"> 
                      <table width="" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td>群发(一号一行):</td>
                          <td> 
                            <textarea name="sendNum" cols="46" rows="5"><%=trim(requesta("sendNum"))%></textarea>                          </td>
                        </tr>
                    </table>                    </td>
                  </tr>
                  <tr>
                    <td align="right" bgcolor="#FFFFFF" class="tdbg">发送内容</td>
                    <td align="left" bgcolor="#FFFFFF" class="tdbg"><textarea name="content" cols="63" rows="6" onKeyUp="dokey(this)" onKeyDown="dokey(this)" onFocus="dokey(this)"></textarea><br>
已写入<span id=lenStr>0</span>个字符</td>
                  </tr>
                  <tr>
                    <td align="right" bgcolor="#FFFFFF" class="tdbg">&nbsp;</td>
                    <td align="left" bgcolor="#FFFFFF" class="tdbg">                <input type="submit" value="确定发送" onClick="return dosub(this.form)" <%if not sms_note then response.write "disabled" %>>
                &nbsp;&nbsp; 
                <input type="button" value=" 返  回 " onClick="javascript:history.back();"></td>
                  </tr>
                  <tr>
                    <td colspan="2" class="tdbg"><br>
                     <%if not sms_note then response.write "<font color=red>如果需要发送短信请在 系统设置&gt;邮件和短信 里<b>开启短信通知</b></font><br>"%>
        提示： 通过此功能可以直接给用户发手机短信。</td>
                  </tr>
  </form>
                </table>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
