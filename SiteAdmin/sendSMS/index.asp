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
	   alertstr +="-��ѡ���Ͷ���!\n";
	 }
	 if(contents.value==""){
	    alertstr +="-�������ݲ���Ϊ��\n";
	 }
	 if (contents.value.length>60){
	    alertstr +="-�������ݲ��ܳ���60���ַ�!\n";
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
    <td height='30' align="center" ><strong>���ŷ���</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="index.asp">Ⱥ������</a> | <a href="sendlog.asp?str=1">���ŷ�����־</a></td>
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
  'if not pds then url_return "10�������ٴη���",-1
    content=trim(requestf("content"))
	u_levelform=trim(requestf("u_level"))
	if u_levelform&""="" then url_return "��ѡ���û�",-1 :response.end
	if content&""="" then url_return "����������",-1 :response.end
	
	if instr(u_levelform,"0")>0 or instr(u_levelform,"1")>0 then 
		if left(session("u_type"),1)<>"1" then
			url_return "Ȩ�޲���",-1
		end if
	end if
	
	sendnum=""
	for each u_levelpd in split(u_levelform,",")
	     sql=""
		
	    if trim(u_levelpd)<>"" then
			  select case trim(u_levelpd)
				case "0" '������

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
				case "1" '���������û�
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
				case "2" 'ָ�����ֻ���
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
		if left(returnstr,3)<>"200" then pds=pds&"�д���:"& returnstr &"<br>"
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
	response.write "�Բ���,û���ҵ��ֻ���"
	end if
	sendRs.close
	set sendRs=nothing
end if
%><table width="100%" border="0" cellpadding="3" cellspacing="0" class="border">
                <form name="form1" action="index.asp?str=s" method="post">
                  <tr> 
                    <td width="23%" align="right" bgcolor="#FFFFFF" class="tdbg"> 
                    <input name="u_level" type="checkbox" value="0" <%if left(session("u_type"),1)<>"1" then response.write "disabled='disabled'"%> />                    </td>
                    
      <td width="77%" align="left" class="tdbg">���д�����</td>
                  </tr>
                  <tr> 
                    <td align="right" bgcolor="#FFFFFF" class="tdbg"> 
                    <input name="u_level" type="checkbox" value="1" <%if left(session("u_type"),1)<>"1" then response.write "disabled='disabled'"%>  />                    </td>
                    
      <td align="left" bgcolor="#FFFFFF" class="tdbg">���ж��������û�</td>
                  </tr>
                  <tr> 
                    <td align="right" bgcolor="#FFFFFF" class="tdbg"> 
                    <input name="u_level" type="checkbox" value="2" checked />                    </td>
                    <td align="left" bgcolor="#FFFFFF" class="tdbg"> 
                      <table width="" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td>Ⱥ��(һ��һ��):</td>
                          <td> 
                            <textarea name="sendNum" cols="46" rows="5"><%=trim(requesta("sendNum"))%></textarea>                          </td>
                        </tr>
                    </table>                    </td>
                  </tr>
                  <tr>
                    <td align="right" bgcolor="#FFFFFF" class="tdbg">��������</td>
                    <td align="left" bgcolor="#FFFFFF" class="tdbg"><textarea name="content" cols="63" rows="6" onKeyUp="dokey(this)" onKeyDown="dokey(this)" onFocus="dokey(this)"></textarea><br>
��д��<span id=lenStr>0</span>���ַ�</td>
                  </tr>
                  <tr>
                    <td align="right" bgcolor="#FFFFFF" class="tdbg">&nbsp;</td>
                    <td align="left" bgcolor="#FFFFFF" class="tdbg">                <input type="submit" value="ȷ������" onClick="return dosub(this.form)" <%if not sms_note then response.write "disabled" %>>
                &nbsp;&nbsp; 
                <input type="button" value=" ��  �� " onClick="javascript:history.back();"></td>
                  </tr>
                  <tr>
                    <td colspan="2" class="tdbg"><br>
                     <%if not sms_note then response.write "<font color=red>�����Ҫ���Ͷ������� ϵͳ����&gt;�ʼ��Ͷ��� ��<b>��������֪ͨ</b></font><br>"%>
        ��ʾ�� ͨ���˹��ܿ���ֱ�Ӹ��û����ֻ����š�</td>
                  </tr>
  </form>
                </table>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
