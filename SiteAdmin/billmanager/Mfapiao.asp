<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<%Check_Is_Master(2)%>

<%

function getsendtype(sendtype)
	select case sendtype
		case 0
			getsendtype="�Һ�"
		case 1
			getsendtype="���"
		case 2
			getsendtype="��ݵ���"
		case 3
			getsendtype="ƽ��"
		case else
			getsendtype="�Һ�"
	end select
end function

sub UpdateInvoiceStatus()
    If isdbsql Then
    set lrs=conn.Execute("select f_id,f_username from fapiao where (f_status=0 or f_status=1) and f_fid>0 and not f_fid is null")
	else
	set lrs=conn.Execute("select f_id,f_username from fapiao where (f_status=0 or f_status=1) and f_fid>0 and not isnull(f_fid)")
    End if
	do while not lrs.eof
		CmdString="other" & vbcrlf & "get" & vbcrlf & "entityname:invoice" & vbcrlf & "identity:" & lrs("f_id") & vbcrlf & "." & vbcrlf
		runRet=PCommand(CmdString,lrs("f_username"))
		lrs.moveNext
	loop
	lrs.close
	set lrs=nothing
end Sub

sub check_bill()
  if session("user_name")<>"guofang520" then 
	url_return "��Ǹ��Ȩ�޲���",-1
  end if
end sub

conn.open constr
check_is_master(6)


Function NotNull(ValueIs)
if isNull(ValueIs) or isEmpty(ValueIs) then
	NotNull="&nbsp;"
else
	ValueIs=Trim(ValueIs)
	if isDate(ValueIs) then
		NotNull=formatDateTime(ValueIs,2)
	else
		NotNull=ValueIs
	end if
end if
End Function

sub OutFile(IDString,DataBase)
 if IDString<>"" then

if DataBase<>"" then
 Set connS=Server.CreateObject("ADODB.Connection")
 DBPath=Server.MapPath("./Address.mdb")
 connS.Open "driver={Microsoft Access Driver (*.mdb)};dbq=" & DBPath
 Sql="Delete from Address"
 connS.execute(Sql)
end if

 ArrayID=split(IDString,",")
 tab="&nbsp;&nbsp;&nbsp;&nbsp;"
 Brvar="<br>"
 Saddress=tab & tab & tab & tab & tab & tab & "�ɶ������·90���������4¥5�š�{companyname}"
 Szip=tab & tab & tab & tab & tab & tab & tab & tab & "�ʱ�:610031"
  Response.write "<p></p>"
  for each IDNo in ArrayID
    Sql="Select * from FaPiao where f_id=" & IDno
    Set FRs=conn.Execute(Sql)
    if not FRs.eof then
		Response.write Brvar & "�ʱ�:" & FRs("f_zip") & Brvar
 		Response.write tab & tab &  FRs("f_address") & Brvar
		Response.write tab & tab & tab & "�ռ���:" & FRs("f_receive") & Brvar
        Response.write Saddress & Brvar
 		Response.write Szip & Brvar
		Response.write "--<br>"
	 if DataBase<>"" then
		Sql="Insert into Address (PostCode,Address,Name) Values ('" & FRs("f_zip") & "','" & FRs("f_address") & "','" & FRs("f_receive") & "')"
		connS.Execute(Sql)
	 end if		
    end if
      FRs.close
      Set FRs=nothing
  next
  Response.write "<br><br><br><br><hr><br>"
  for each IDNo in ArrayID
    Sql="select * from fapiao where f_id=" & IDno
    Set FRs=conn.Execute(Sql)
    if not FRs.eof then

		Response.write Brvar & "��Ʊ̧ͷ:" & FRs("f_title")
		Response.write Brvar & "��Ʊ���:" & FRs("f_money") 
		Response.write Brvar & "��Ʊ����:" & FRs("f_content") 
		Response.write Brvar & "<br>�û���:" & FRs("f_username")
		Response.write Brvar & "�������:" & FRs("f_PayDate") 
		Response.write Brvar & "��ϵ�绰:" & FRs("f_telphone") 
		Response.write Brvar & "��ʽ:" & FRs("f_Method") 
		Response.write Brvar & "�ύ����:" & FRs("f_Date")
		Response.write "<br><br>--<br>"

    end if
      FRs.close
      Set FRs=nothing
  next

  if DataBase<>"" then Response.write "<script language=javascript>window.open('./Address.mdb','','');</script>"
 end if
end sub

sub SetFlagP(IDString)
 if IDString<>"" then
   ArrayID=split(IDString,",")
   for each IDNo in ArrayID
     Sql="Update FaPiao Set f_status=1 where f_id=" & IDNo
     conn.Execute(Sql)
   next
 end if
end sub

sub SetFlagS(IDString)
 if IDString<>"" then
   ArrayID=split(IDString,",")
   for each IDNo in ArrayID
     Sql="Update FaPiao Set f_status=2,f_SendDate='" & now() & "' where f_id=" & IDNo
     conn.Execute(Sql)
   next
 end if
end sub

Function PStatus(Status)
  if Status=0 then PStatus="<font color=red>��ȷ��</font>"
  if Status=1 then PStatus="��ȷ��"
  if Status=2 then PStatus="�Ѽĳ�"
  if Status=3 then PStatus="<font color=#0000ff>�Ѿܾ�</font>"
end Function

Function Txt2Sng(Txt)
Select Case Txt
	Case "eq"
		Txt2Sng="="
	Case "gt"
		Txt2Sng=">"
	Case "lt"
		Txt2Sng="<"
	Case "gteq"
		Txt2Sng=">="
	Case "lteq"
		Txt2Sng="<="
	Case "$"
		Txt2Sng="Like"
	Case "ne"
		Txt2Sng="<>"
 end Select
End Function

Dim SearchItem,Signal,SearchValue,Act,OptNo,OptValue,FaPiaoID,PageSize,Page,Status1,Status2,Status3
Dim Sql,Express,Status(3),i,TotalMoney,ConutSql,SearchSql,PageCount,RecordCount

'����״̬

Call UpdateInvoiceStatus()

SearchItem=Trim(Requesta("SearchItem"))
Signal=Trim(Requesta("Signal"))
SearchValue=Trim(Requesta("SearchValue"))
Act=Trim(Requesta("Act"))
OptNo=Trim(Requesta("OptNo"))
OptValue=Trim(Requesta("OptValue"))
FaPiaoID=Trim(Requesta("FaPiaoID"))
PageSize=Trim(Requesta("PageSize"))
Page=Trim(Requesta("Page"))
DataBase=Trim(Requesta("DataBase"))

Status(0)=0
Status(1)=0
status(2)=0
status(3)=0

if isNumeric(Requesta("Status1")) then Status(0)=Cint(Requesta("Status1"))
if isNumeric(Requesta("Status2")) then Status(1)=Cint(Requesta("Status2"))
if isNumeric(Requesta("Status3")) then Status(2)=Cint(Requesta("Status3"))
if isNumeric(Requesta("Status4")) then Status(3)=Cint(Requesta("Status4"))

if not isNumeric(PageSize) then PageSize=10
if not isNumeric(Page) then Page=1
PageSize=Cint(PageSize)
Page=Cint(Page)

if Act<>"" then
Check_Is_Master(2)
  if Act="DelFapiao" then
  	sql="update userdetail set u_invoice=(u_usemoney+u_resumesum)"
	conn.execute(sql)
	url_return "�����ɹ��������û���Ʊ�Ѿ����㡣",-1
  elseif Act="Erase" then
	Sql="Select f_username,f_money,f_special from FaPiao Where F_id=" & OptNo
	Rs.open Sql,conn,1,1
	if Rs.eof then url_return "Error:δ�ҵ��˷�Ʊ",-1
	u_f_name=Rs("f_username")
	u_f_money=Rs("f_money")
	f_special=Rs("f_special")
	Rs.close
	Sql="Update UserDetail Set u_invoice=u_invoice-" & u_f_money & " where u_name='" & u_f_name & "'"
	conn.Execute(Sql)

	if f_special then
		Sql="Select u_invoice_str from userdetail where u_name='" & u_f_name & "'"
		Rs.open Sql,conn,1,1
			if isNull(Rs("u_invoice_str")) then
				u_invoice_str="," & Cstr(u_f_money)
			else
				u_invoice_str=Rs("u_invoice_str") & "," & Cstr(u_f_money)
			end if
		Rs.close
		Sql="update userdetail set u_invoice_str='" & u_invoice_str & "' where u_name='" & u_f_name & "'"
		conn.Execute(Sql)
	end if

    Sql="Delete from FaPiao Where F_id=" & OptNo
    conn.Execute(Sql)
  elseif Act="Drop" then
	 killWhy=Requesta("killWhy")  
	 sql="select userdetail.u_email,userdetail.u_contract,fapiao.f_title from userdetail left join fapiao on userdetail.u_name=fapiao.f_username where fapiao.f_id=" & OptNO
	 rs1.open sql,conn,1,1
	 if not rs1.eof then
		 mailbody="�𾴵�" & rs1("u_contract") & "����" & vbcrlf & "      ������˾�����̧ͷΪ" & rs1("f_title") & "����˾�ܾ���ԭ����" & killWhy
		 mailbody=mailbody & vbcrlf & "�������ʣ�������˾������ϵ " &vbcrlf
		 mailbody=mailbody & "       ��" & vbcrlf & "��" & vbcrlf &  companyname & vbcrlf
		call sendMail(rs1("u_email"),"��Ʊ�ܾ�֪ͨ",mailbody)
	 end if
	 rs1.close

    Sql="Update FaPiao Set f_status=3 where F_id=" & OptNo
    conn.Execute(Sql)
	
	Sql="Select f_username,f_money,f_special from FaPiao Where F_id=" & OptNo
	Rs.open Sql,conn,1,1
	if Rs.eof then url_return "Error:δ�ҵ��˷�Ʊ",-1
	u_f_name=Rs("f_username")
	u_f_money=Rs("f_money")
	f_special=Rs("f_special")
	Rs.close
	
	Sql="Update UserDetail Set u_invoice=u_invoice-" & u_f_money & " where u_name='" & u_f_name & "'"
	conn.Execute(Sql)
	
  elseif Act="AdujectM" then
    Sql="Update FaPiao Set f_money=" & OptValue & " Where F_id=" & OptNO
    conn.Execute(Sql)
  elseif act="AdujectT" then
    Sql="Update FaPiao Set f_title='" & OptValue & "' Where F_id=" & OptNO
    conn.Execute(Sql)
  elseif Act="O" then
    OutFile FaPiaoID,DataBase
    Response.end
  elseif Act="P" then
    SetFlagP FaPiaoID
  elseif Act="S" then
    SetFlagS FaPiaoID
  elseif Act="SetFNO" then
	Sql="Update FaPiao set f_no='" & OptValue & "' Where F_id=" & OptNo
    conn.Execute(Sql)
  end if
end if

'if Status(0)<>1 and Status(1)<>1 and Status(2)<>1 then Status(0)=1
if Status(0)+Status(1)+Status(2)+Status(3)=0 then Status(0)=1
OrCondition=""
for  i=0 to 3
  if Status(i)=1 then OrCondition=OrCondition & " f_status=" & i & " or "
next
OrCondition=OrCondition & " 1=2"

Express=""

if SearchValue="" then
  Express="1=1"
else
  if SearchItem="f_SendDate" or SearchItem="f_Date" then
    Express=" DateDiff(d,'" & SearchValue & "'," & SearchItem & ")" & Txt2Sng(Signal) & "0"
  elseif SearchItem="f_money" then
    Express=SearchItem & Txt2Sng(Signal) & SearchValue
  else
    if Signal="$" then
      Express=SearchItem &" " & Txt2Sng(Signal) & " '%" & SearchValue & "%'"
    else
      Express=SearchItem & Txt2Sng(Signal) & "'" & SearchValue & "'"
    end if
  end if
end if
CountSql="Select Sum(f_money) as TotalMoney from FaPiao Where " & Express & " and (" & OrCondition & ")"
SearchSql="Select * from FaPiao Where " & Express & " and (" & OrCondition & ") order by f_status,f_Date desc"
Rs.Open CountSql,conn,1,1

TotalMoney=0
PageCount=0
RecordCount=0

if isNumeric(Rs("TotalMoney")) then TotalMoney=Rs("TotalMoney")
Rs.close
Rs.open SearchSql,conn,1,3

if not Rs.eof then
  Rs.PageSize=PageSize
  RecordCount=Rs.RecordCount
  PageCount=Rs.pageCount
  if Page>PageCount then Page=PageCount
  if Page<1 then page=1
  Rs.AbsolutePage=Page
end if


%>
<script language=javascript>
function isIPAddress(data,text){
var reg=/\b([1,2]?[0-9]?[0-9]?)\.([1,2]?[0-9]?[0-9])\.([1,2]?[0-9]?[0-9])\.([1,2]?[0-9]?[0-9])\b/
if (reg.exec(data.value)!=null) {
	return true;
	}
else {
	alert("��Ǹ��"+text+"��ʽ�������������һ����Ч��IP��ַ");
	data.focus();
	data.select();
	return false;
	}
}

function isDate(data,text){
var reg=/\b(((19|20)\d{2})-((0?[1-9])|(1[012]))-((0?[1-9])|([12]\d)|(3[01])))\b/
if (reg.exec(data.value)==null) {
	alert("��Ǹ��"+text+"�����ڸ�ʽ����,��ȷ�ĸ�ʽ��yyyy-MM-dd");
	//data.value=dateObj.getUTCFullYear()+"-"+dateObj.getUTCMonth()+"-"+dateObj.getUTCDay();
	dateObj=new Date();
	data.value="2002-11-30"
	data.focus();
	data.select();
	return false;
}
else{
	return true;
	}
}

function isGreat(number,text){
		if (parseFloat(number)>9999999||parseFloat(number)<0){
			alert("��Ǹ���ύʧ�ܣ�["+text+"]��ֵ����ϵͳ��ʾ��Χ0-9999999");
			return true;
			}
	return false;
}
function isNumber(number){
var i,str1="0123456789.";
	for(i=0;i<number.value.length;i++){
	if(str1.indexOf(number.value.charAt(i))==-1){
		return false;
		break;
			}
		}
return true;
}
function checkNull(data,text){
	if (data.value==""){
		alert("��Ǹ!�ύʧ�ܣ�"+text+"����Ϊ��!");
		data.focus();
	   return false;
			}
	else{ 
		return true;}
}
function isDigital(data,text){
if (data.value!=""){
	if (!isNumber(data)) {
	alert("��Ǹ!["+text+"]����������,�����޷��ύ");
	data.focus();
	data.select();
	return false;
	}
}
return true;
}

function FindIt(form){
if (form.SearchValue.value!=""){
	if (form.SearchItem.value=="f_money"&&!isDigital(form.SearchValue,"��Ʊ���")) return false;
    if ((form.SearchItem.value=="f_Date"||form.SearchItem.value=="f_SendDate")&&!isDate(form.SearchValue,form.SearchItem[form.SearchItem.selectedIndex].text)) return false;
    if ((form.SearchItem.value=="f_money"||form.SearchItem.value=="f_Date"||form.SearchItem.value=="f_SendDate")&&form.Signal.value=="$") {
			alert("ʱ��������ִ�а�������"); 
			return false;
			}
		}
    if (form.SearchItem.value=="f_SendDate"&&form.SearchItem.value!="") form.Status3.checked=true;

if (form.Act.value=="O"){ form.target="_blank";}
else {form.target="_self";}
form.submit();
}


function Go(form){
  form.Act.value="";
  if (!checkNull(form.Page,"ҳ��")) return false;
  if (!isDigital(form.PageSize,"ÿҳ��ʾ")) return false;
  if (!isDigital(form.Page,"ҳ��")) return false;
  FindIt(form);
  return true;
}

function Prepage(form){
  if (!isDigital(form.Page,"ҳ��")) return false;
  form.Page.value=parseInt(form.Page.value)-1;
  Go(form);
  return true;
}

function Nextpage(form){
  if (!isDigital(form.Page,"ҳ��")) return false;
  form.Page.value=parseInt(form.Page.value)+1;
  Go(form);
  return true;
}


function All(form){
for (i=0;i<form.elements.length;i++){
strName=form.elements[i].name;
if (strName=="FaPiaoID") form.elements[i].checked=!form.elements[i].checked;
}
return true;
}

function EditMoney(CHID){
form=document.form1;
if (!isDigital(eval("form.Price_"+CHID),"���")) return false;
form.Act.value="AdujectM";
form.OptNo.value=CHID;
form.OptValue.value=eval("form.Price_"+CHID).value;
if (form.OptValue.value==""){alert("����Ϊ��");eval("form.Price_"+CHID).focus();return false;};
FindIt(form);
return true;
}
function EditTitle(CHID){
	var form=document.form1;
	form.Act.value="AdujectT";
	form.OptNo.value=CHID;
	form.OptValue.value=eval("form.title_"+CHID).value;
	FindIt(form);
	return true;
}

function setFNo(FID){
form=document.form1;
 if (!checkNull(eval("form.F_No_"+FID),"��Ʊ���")) return false;
form.Act.value="SetFNO";
form.OptNo.value=FID;
form.OptValue.value=eval("form.F_No_"+FID).value;
FindIt(form);
return true;
}

function Erase(CHID){
form=document.form1;
form.Act.value="Erase"
form.OptNo.value=CHID;
FindIt(form);
return true;
}

function Drop(CHID){
var killWhy=prompt('������ܾ�ԭ�򣬸�ԭ�����ʼ���ʽ���͸��û���','��Ʊ̧ͷ��Ҫ��д��˾����֯��������');
if (killWhy==null||killWhy==''){return;}
form=document.form1;
form.Act.value="Drop"
form.OptNo.value=CHID;
form.killWhy.value=killWhy;
FindIt(form);
return true;
}

function Process(form,Opt){
form.Act.value=Opt;
FindIt(form);
return true;
}
</script>

<script language="JavaScript">
<!--
function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}

//-->
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>��Ʊ����(��������:<%=NotNull(now)%>)</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="incount.asp" target="main">�û����</a>| <a href="InActressCount.asp" target="main">�Ż����</a><a href="outcount.asp"></a> | <a href="returncount.asp" target="main">�����뻧</a><a href="returncount.asp"></a> | <a href="comsume.asp" target="main">�ֹ��ۿ�</a><a href="comsume.asp"></a> | <a href="outOurMoney.asp" target="main">��¼��֧</a><a href="checkcount.asp"></a> | <a href="ViewOurMoney.asp" target="main">�鿴��ˮ��</a><a href="checkmoney.asp"></a> | <a href="InActressCount.asp">�Ż����</a> | <a href="OurMoney.asp">����ˮ��</a> | <a href="mfapiao.asp?act=DelFapiao" 
     onClick="return confirm('��Ʊ����ͨ��������ĩ����û��ɿ���Ʊ��һ��ִ�У��������û��Ŀɿ���Ʊ����Ϊ�㣬ֻ�����´���ſ����¿���Ʊ�������ã�')" >��Ʊ����</a></td>
  </tr>
</table><br>
  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<form method="post" action="Mfapiao.asp" name="form1">
    <tr> 
      <td valign="top"> 
        <table width="100%" border="0" align="center" cellpadding="2" cellspacing="1" class="border">
          <tr> 
            <th align="center" class="Title"><strong>No.</strong></th>
            <th align="center" class="Title"><strong>�ύʱ��</strong></th>
            <th align="center" class="Title"><strong>�û�</strong></th>
            <th align="center" class="Title"><strong>�ܽ��</strong></th>
            <th align="center" class="Title"><strong>����</strong></th>
            <th align="center" class="Title"><strong>��Ʊ̧ͷ</strong></th>
            <th colspan="2" align="center" class="Title"><strong>���</strong></th>
            <th align="center" class="Title"><strong>��Ʊ����</strong></th>
            <th align="center" class="Title"><strong>��Ʊ��</strong></th>
            <th align="center" class="Title"><strong>�ʼķ�ʽ</strong></th>
            <th align="center" class="Title"><strong>�ĳ�����</strong></th>
            <th colspan="2" align="center" class="Title"><strong>״̬</strong></th>
          </tr>
          
          <%
i=1
do while not Rs.eof And i<=PageSize
UMoney=0
Ftotal=0
Sql="Select u_usemoney+u_resumesum as TotalM from UserDetail where u_name='" & Rs("f_username") & "'"
Set URs=conn.Execute(Sql)
if not URs.eof then UMoney=URs("TotalM")
URs.close
Sql="Select count(f_id) as TotalF from FaPiao Where f_username='" & Rs("f_username") & "'"
URs.open Sql,conn,1,1
if isNumeric(URs("TotalF")) then Ftotal=URs("TotalF")
URs.close
Set URs=nothing
f_id=Rs("f_id")
f_No=Rs("f_no")
f_username=Rs("f_username")
f_title=Rs("f_title")
f_money=Rs("f_money")
f_content=Rs("f_content")
f_content2=f_content
f_address=Rs("f_address")
f_receive=Rs("f_receive")
f_zip=Rs("f_zip")
f_telphone=rs("f_telphone")
if len(f_content)>7 then f_content2=left(f_content,5) & ".."
f_SendDate=NotNull(Rs("f_SendDate"))
f_status=PStatus(Rs("f_status"))
f_s=Rs("f_status")
if Rs("f_status")<>2 then f_SendDate="--"
f_sendtype=getsendtype(rs("f_sendtype"))
f_date=rs("f_date")
f_memo=rs("f_memo")
f_receive_cp=rs("f_receive_cp")
f_taxcode=rs("f_taxcode")
%>

          <tr> 
            <td align="center" class="tdbg"><%=(Page-1)*PageSize+i%></td>
            <td align="center" class="tdbg"><%=f_date%></td>
            <td align="center" class="tdbg"><%=f_username%></td>
            <td align="center" class="tdbg"><%=UMoney%></td>
            <% if Ftotal>1 then %>
            <td align="center" class="tdbg" ><a href="javascript:MM_openBrWindow('Uview.asp?f_username=<%=f_username%>&f_id=<%=f_id%>','View','scrollbars=yes,width=700,height=250')" >&lt;<%=Ftotal%>&gt;</a></td>
            <%else%>
            <td align="center" class="tdbg">&lt;<%=Ftotal%>&gt;</td>
            <%end if%>
            <td align="center" class="tdbg" <%if Rs("f_special") then Response.write " style=""filter:Glow(Color:#00ccff,Strength:2)"""%>>
			<input type="text" name="title_<%=f_id%>" value="<%=f_title%>"> <a href="#" onClick="EditTitle(<%=f_id%>);">�޸�</a></td>
            <td colspan="2" align="center" class="tdbg"> 
              <input type="text" name="Price_<%=f_id%>" size="6" maxlength="7" value="<%=f_money%>">
              <a href="#" onClick="EditMoney(<%=f_id%>);">�޸�</a> </td>
            <td align="center" class="tdbg" <% if len(f_content)>8 then Response.write "title=""" & f_content &""""%>><%=f_content2%></td>
            <td align="center" class="tdbg"> 
              <input type=text name="F_No_<%=f_id%>" value="<%=f_No%>" size=6>
              <a href="#" onClick="setFNo(<%=f_id%>)">&gt;&gt;</a> </td>
            <td align="center" class="tdbg"><%=f_sendtype%><br></td>
            <td align="center" class="tdbg"><%=f_SendDate%></td>
            <td align="center" class="tdbg"><%=f_status%></td>
          </tr>
          <tr>
            <td colspan="2" align="right" class="tdbg">��ַ:</td>
            <td colspan="5" class="tdbg"><%=f_address%> ��<%=f_zip%>��</td>
            <td align="right" class="tdbg">�ռ���:</td>
            <td class="tdbg"><%=f_receive%></td>
            <td align="right" class="tdbg">�绰:</td>
            <td class="tdbg"><%=f_telphone%></td>
            <td align="center" class="tdbg"> 
                    <input type="checkbox" name="FaPiaoID" value="<%=f_id%>">  
                    <input type="button" name="Button62" value="ɾ" onClick="if (confirm('��ȷ��ɾ���˷�Ʊ(̧ͷ:<%=f_title%>)?\n\nע�⣺ɾ�����û��Ŀɿ�������Ӧ����')){Erase(<%=f_id%>);}">  
                  
                    <input type="button" name="Button6" value="��" onClick="if (confirm('��ȷʵҪ�ܾ��˷�Ʊ(̧ͷ:<%=f_title%>)?\n\nע�⣺�ܾ����û��Ŀɿ�������Ӧ����')){Drop(<%=f_id%>);}" <%if f_s=2 or f_s=3 then Response.write " disabled"%>>              </td>
            <td class="tdbg">&nbsp;</td>
          </tr>
		  <tr  class="tdbg">
				<td>��ע��</td><td colspan=3><%=f_memo%></td>
				<td>�ռ���˾��:</td><td colspan=3><%=f_receive_cp%></td>
				<td>��˰ʶ���:</td><td colspan=4><%=f_taxcode%></td>
		  <tr>
          <%
Rs.MoveNext
i=i+1
Loop
Rs.close
%>
          <tr> 
            <td colspan="12" align="center"> 
              <table width="100%" border="0" cellspacing="1" cellpadding="2" class="css1" bordercolordark="#E1E1E1">
                <tr> 
                  <td width="12%"> 
                    <select name="SearchItem">
                      <option value="f_username" <% if SearchItem="f_username" then Response.write "  selected"%>>�û���</option>
                      <option value="f_no" <% if SearchItem="f_no" then Response.write "  selected"%>>��Ʊ���</option>
                      <option value="f_title" <% if SearchItem="f_title" then Response.write "  selected"%>>��Ʊ̧ͷ</option>
                      <option value="f_money" <% if SearchItem="f_money" then Response.write "  selected"%>>��Ʊ���</option>
                      <option value="f_content" <% if SearchItem="f_content" then Response.write "  selected"%>>��Ʊ����</option>
                      <option value="f_Date" <% if SearchItem="f_Date" then Response.write "  selected"%>>�ύ����</option>
                      <option value="f_SendDate" <% if SearchItem="f_SendDate" then Response.write "  selected"%>>�ĳ�����</option>
                      <option value="f_receive" <% if SearchItem="f_receive" then Response.write "  selected"%>>�ռ���</option>
                      <option value="f_address" <% if SearchItem="f_address" then Response.write "  selected"%>>��ַ</option>
                      <option value="f_zip" <% if SearchItem="f_zip" then Response.write "  selected"%>>�ʱ�</option>
                    </select>                  </td>
                  <td width="8%"> 
                    <select name="Signal">
                      <option value="eq" <% if Signal="eq" then Response.write "  selected"%>>=</option>
                      <option value="gt" <% if Signal="gt" then Response.write "  selected"%>>&gt;</option>
                      <option value="lt" <% if Signal="lt" then Response.write "  selected"%>>&lt;</option>
                      <option value="$" <% if Signal="$" then Response.write "  selected"%>>��</option>
                      <option value="gteq" <% if Signal="gteq" then Response.write "  selected"%>>&gt;=</option>
                      <option value="lteq" <% if Signal="lteq" then Response.write "  selected"%>>&lt;=</option>
                      <option value="ne" <% if Signal="ne" then Response.write "  selected"%>>&lt;&gt;</option>
                    </select>                  </td>
                  <td width="8%"> 
                    <input type="text" name="SearchValue" maxlength="30" size="6" value=<%=SearchValue%>>                  </td>
                  <td width="8%" align="center"> 
                    <input type="button" name="Button" value="����" onClick="this.form.Act.value='';FindIt(this.form);">                  </td>
                  <td width="39%"> 
                    <input type="checkbox" value="1" name="Status1" <%if Status(0)=1 then Response.write " checked" %>>
                    ��ȷ�� 
                    <input type="checkbox" name="Status2" value="1" <%if Status(1)=1 then Response.write " checked" %>>
                    ��ȷ�� 
                    <input type="checkbox" name="Status3" value="1" <%if Status(2)=1 then Response.write " checked" %>>
                    �Ѽĳ� 
                    <input type="checkbox" name="Status4" value="1" <%if Status(3)=1 then Response.write " checked" %>>
                    �Ѿܾ� 
                    <input type="button" name="Button5" value="ȫ" onClick="this.form.Status1.checked=true;this.form.Status2.checked=true;this.form.Status3.checked=true;this.form.Status4.checked=true;">                  </td>
                  <td width="25%" align="center"> 
                    <input type="button" name="Button2" value="ȷ��" onClick="Process(this.form,'P');">
                    <input type="button" name="Button2" value="�ĳ�" onClick="Process(this.form,'S');">
                    <input type="button" name="Button22" value="����" onClick="this.form.DataBase.value='';Process(this.form,'O');">
                    <input type="button" name="Button52" value="ȫ" onClick="All(this.form);">
                    <br>
                    <input type="button" name="Button3" value="&lt;" onClick="Prepage(this.form);">
                    <input type="button" name="Button32" value="&gt;" onClick="Nextpage(this.form);">
                    <input type="text" name="PageSize" size="1" maxlength="3" value="<%=PageSize%>">
                    /ҳ 
                    <input type="button" name="Button4" value="��" onClick="Go(this.form);">
                    <input type="text" name="Page" size="1" maxlength="3" value="<%=Page%>">
                    ҳ </td>
                </tr>
              </table>            </td>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td colspan="2" align="center">״̬��:</td>
            <td colspan="11">���ҵ�<%=RecordCount%>�ŷ�Ʊ���漰��<%=formatNumber(TotalMoney,2,-1,-1)%>Ԫ��ÿҳ<%=PageSize%>�ŷ�Ʊ����<%=Page%>ҳ����<%=PageCount%>ҳ 
              <input type="hidden" name="OptNo">
              <input type="hidden" name="OptValue">
              <input type="hidden" name="Act">
              <input type="hidden" name="DataBase">
              <input type="hidden" name="killWhy">            </td>
          </tr>
        </table>      </td>
    </tr>
</form>
  </table>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
