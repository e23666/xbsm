<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/xml_class.asp" -->
<!--#include virtual="/config/patch_inc.asp" -->

<%
	u=requesta("u")
	p=requesta("p")
	call checkreg()
listType=Request("listType")
if listType="" then listType="old"
patchNo=Request.Form("patchNo")
patchauto=Request.Form("patchauto")
blManual=not (patchauto="true")
patchUrl=Request.Form("patchUrl")
doAct=Request.Form("doAct")
p_no_list=Request.Form("p_no_list")
xpageNo=request("xpageNo")
dohulue=request.Form("dohulue")
if listType="new" then
	listall=false
else
	listall=true
end if
nowVer=getVer()	
patchList=getremotePatch(listall) 'ȫ������
If listall Then patchList=dxArray(patchList)'���������Ѵ򲹶�
patch_okay=getPatchList() '�Ѵ򲹶�

if patch_okay<>"" then
	patchOkArray=split(patch_okay,",")
else
	patchOkArray=Array()
end if

if doAct="GO" then
	if patchNo<>"" then
		Set oItem=seekItem(patchList,patchNo)'�õ�Ҫ��Ĳ�������
		if listType="old" then
			if reapplyPatch(patchNo,oItem.info,nowVer,blManual,packstr) then
					xInfo="����[" & patchNo & "]���������ɹ�"
			else
					xInfo="����[" & patchNo & "]��������ʧ�ܵ���:<br>" & replace(packstr,vbcrlf,"<br>")
			end if
		else
			if applyPatch(patchNo,oItem.path,oItem.applyver,blManual) then
				if dohulue="hulue" then
					xInfo="����[" & patchNo & "]�Ѻ���"
				else
					xInfo="����[" & patchNo & "]�����ɹ�"
				end if
			else
				xInfo="����[" & patchNo & "]����ʧ��"
			end if
		end if
	end if

	'-----------------�����Ѵ򲹶��б�
	patchList=getremotePatch(listall) 'ȫ������
	If listall Then patchList=dxArray(patchList)'���������Ѵ򲹶�
	patch_okay=getPatchList() '�Ѵ򲹶�
	if patch_okay<>"" then
		patchOkArray=split(patch_okay,",")
	else
		patchOkArray=Array()
	end if
	'-----------------�����Ѵ򲹶��б�

end if

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>ϵ ͳ �� �� �� ��</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td>��ǰ�汾:<%=nowVer%>,���°汾:<%=session("Rver")%></td>
  </tr>
</table> <br>
<form name="form1" method="post" action="<%=request("script_name")%>">
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='tdbg'>
    <td height='30' align="center" >
      <input name="listType" type="radio" value="new" <%if listType="new" then Response.write "checked"%> onClick="this.form.patchNo.value='';this.form.submit();">
    δ�򲹶��б�,
    <input type="radio" name="listType" value="old" <%if listType="old" then Response.write "checked"%> onClick="this.form.patchNo.value='';this.form.submit();">
    �Ѵ򲹶��б�, 
    <br>
    <font color="red">* �밴��Ҫ����Ӧ�Ĳ���������ж������δ����ʾ�����Ĳ�������������ȴ�ò�������Ѵ��ڵ�һ������</font>
</td>
  </tr>
</table>
<%
if xInfo<>"" then
	Response.write "<HR>" & Replace(Xinfo,",","<BR>") & "<HR>"
end if

disNum=0
pnote=""
iIndex=UBound(patchList)
''''''''''''��ҳ'''''''''''''''''''
xlistcount=iIndex
xpagesize=5'����ÿҳ��¼��
xpageNocount=round2((xlistcount+1)/xpagesize)'��ҳ��
if not isnumeric(xpageNo) or Trim(xpageNo)&""="" then xpageNo=1
xpageNo=cint(xpageNo)
xpageNocount=cint(xpageNocount)
if xpageNo>xpageNocount then xpageNo=xpageNocount
if xpageNo<=0 then xpageNo=1
''''''''''''''''''''''''''''''''''
	
	for iNo=0 to xpagesize-1
		k=(xpageNo-1)*xpagesize+iNo
        if   k>xlistcount   then   exit for
		Set oInfo=patchList(k)
		if disp(oInfo.name) then
			disNum=disNum+1
			if pnote<>"" then
			'pnote=scanPrevious(patchList,patchOkArray,oInfo.name,oInfo.applyver)
			'if pnote<>"" then
				warning="����!��Ӧ���ȴ�" & pnote & "������ֱ����������" & oInfo.name & ",��Щ������������,"
			else
				warning=""
			end if
%>

  <table width="95%" border="0" align="center" cellpadding="5" cellspacing="0">
    <tr>
      <td width="6%" align="right" ><img src="/images/patch.jpg" width="32" height="32"></td>
      <td width="94%" ><table width="100%" border="0" cellpadding="2" cellspacing="1" bgcolor="#CCCCCC">
        <tr>
          <td width="12%" align="right" bgcolor="#F4FCFF"><span class="STYLE4">���������ơ�</span></td>
          <td width="26%" bgcolor="#F4FCFF"><%=oInfo.name%><span class="STYLE5">(�汾��:v<%=oInfo.applyver%>)</span></td>
          <td width="21%" align="right" bgcolor="#F4FCFF"><span class="STYLE4">���������ڡ�</span></td>
          <td width="41%" bgcolor="#F4FCFF"><%=oInfo.pdate%></td>
        </tr>
        <tr>
          <td align="right" bgcolor="#F4FCFF"><span class="STYLE4">���������⡽</span></td>
          <td bgcolor="#F4FCFF"><%=oInfo.title%></td>
          <td align="right" bgcolor="#F4FCFF"><span class="STYLE4">���Ƿ��ѡ��</span></td>
          <td bgcolor="#F4FCFF"><%=iif(oInfo.must="true","<font color=red>����</font>","��ѡ")%></td>
        </tr>
        <tr>
          <td align="right" bgcolor="#F4FCFF"><span class="STYLE4">����ϸ˵����</span></td>
          <td colspan="3" bgcolor="#F4FCFF"><PRE style="display:inline"><%=oInfo.info%></PRE></td>
          </tr>
        <tr>
          <td colspan="2" bgcolor="#F4FCFF">
          <%if listType="old" then %>
          <input type="button" name="Submit" value="���������˲���" onClick="if (confirm('��ȷ�������˲���')){this.form.patchNo.value='<%=oInfo.name%>';this.form.patchauto.value=this.form.ck_<%=oInfo.name%>.checked;this.form.submit();}">
          <%else%>
          <input type="button" name="Submit" value="�����˲���" onClick="if (confirm('<%=warning%>��ȷ�������˲���')){this.form.patchNo.value='<%=oInfo.name%>';this.form.patchauto.value=this.form.ck_<%=oInfo.name%>.checked;this.form.submit();}">
          <%end if%>
           <%if oInfo.must<>"true" and listType<>"old" then %>
           <input type="button" name="Submit1" value="���Դ˲���" onClick="if (confirm('���Դ˲���')){this.form.patchNo.value='<%=oInfo.name%>';this.form.patchauto.value=this.form.ck_<%=oInfo.name%>.checked;this.form.dohulue.value='hulue';this.form.submit();}">
           <%end if%>
            <input name="ck_<%=oInfo.name%>" type="checkbox" checked onClick="if (!this.checked){alert('��ѡ������ֶ�������������������ϵͳ�������ļ���ѹ��<%=manualSavePath%>/<%=oInfo.name%>Ŀ¼�������и�������ļ�')}" <%if listType="old" then Response.write "disabled "%>>
            �Զ�</td>
          <td colspan="2" align="right" bgcolor="#F4FCFF"></td>
          </tr>
      </table></td>
    </tr>
  </table>
  <hr size="1" noshade>
<%
			pnote=oInfo.name & "(�汾��:v" & oInfo.applyver & ")"
		end if
		
	next
%>  
  <%
if disNum=0 then
	if listType="new" then
		Xnote="����ƽ̨�Ѿ������°汾��û����Ҫ���µĲ���"
	else
		Xnote="δ���κβ���"
	end if
	Response.write "<BR><BR><BR><table width='100%'><tr><td><CENTER><B><font color=blue>" & Xnote & "</font></B></center></td></tr></table>"
end if
if disNum>0 then
  %>
  <table width='100%' border="0" cellpadding="0" cellspacing="0" bgcolor="#efefef">
    <tr><td align="center">
  &nbsp;<a href="<%=request("script_name")%>?xpageNo=1&listType=<%=listType%>"><b>��ҳ</b></a>&nbsp;
  &nbsp;<a href="<%=request("script_name")%>?xpageNo=<%=xpageNo-1%>&listType=<%=listType%>&p=<%=p%>&u=<%=u%>"><b>��һҳ</b></a>&nbsp;
  &nbsp;<a href="<%=request("script_name")%>?xpageNo=<%=xpageNo+1%>&listType=<%=listType%>&p=<%=p%>&u=<%=u%>"><b>��һҳ</b></a>&nbsp;
  &nbsp;<a href="<%=request("script_name")%>?xpageNo=<%=xpageNocount%>&listType=<%=listType%>&p=<%=p%>&u=<%=u%>"><b>βҳ</b></a>&nbsp;
  ��<input type="text" id="pageput" size="4" value="<%=xpageNo%>">ҳ<input type=button value="��ת" onClick="javascript:location.href='<%=request("script_name")%>?xpageNo='+document.getElementById('pageput').value+'&listtype=<%=listType%>&p=<%=p%>&u=<%=u%>'">
  &nbsp;��ǰ��<b><%=xpageNo%></b>ҳ/��<%=xpageNocount%>ҳ
  &nbsp;��<%=xlistcount+1%>����¼
  &nbsp;ÿҳ<%=xpagesize%>��
  </td></tr></table>
<%end if%>
  <input name="dohulue" type="hidden" id="dohulue">
  <input name="patchNo" type="hidden" id="patchNo">
  <input name="patchauto" type="hidden" id="patchauto">
  <input name="doAct" type="hidden" id="doAct" value="GO">
  <input name="xpageNo" type="hidden" value="<%=xpageNo%>">
  <input name="p" type="hidden" id="p" value="<%=p%>">
  <input name="u" type="hidden" id="u" value="<%=u%>">
</form>
</body>
</html>
<%
function iif(a,b,c)
	if a then
		iif=b
	else
		iif=c
	end if
end function
Function dxArray(ByVal arr)
	maxarrline=UBound(arr)
	curii=0
	reDim newArr(0)
	While maxarrline>=0
		Set newArr(curii)=arr(maxarrline)
		If curii<UBound(arr) then 
			curii=curii+1
			Redim preserve newArr(curii)
		End if
	maxarrline=maxarrline-1
	wend
	dxArray=newArr
End function
function disp(pname)
		blInArr=inArray(patchOkArray,pname)
		if listType="new" then
			disp=not blInArr
		else
			disp=blInArr
		end if
end function

function seekItem(arrList,pName)
	for i=0 to Ubound(arrList)
		if pName=arrList(i).name then
			Set seekItem=arrList(i)
			exit function
		end if
	next
	Response.write "���⣬" & pName & "δ�ҵ�"
	Response.end 
end function

sub checkreg()

	if lcase(u)<>lcase(api_username) or p<>api_password then 
		%>
        <form name="form1" action="<%=request.ServerVariables("SCRIPT_NAME")%>" method="post">
        <div align="center" style="border:#F93 solid 1px; width:400px">
        <ul style="list-style:none;overflow:hidden; width:300px">
        <li style="white-space:nowrap">�û���:<input type="text" name="u" style="width:150px"></li>
        <li style="white-space:nowrap">��&nbsp;&nbsp;��:<input type="password" name="p"  style="width:150px"></li>
        <li style=" text-align:center"><input type="submit" value=" �� ½ "></li>
        </ul>
        </div>
        </form>
        <%
		response.end
	end if
end sub

%>