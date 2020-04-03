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
patchList=getremotePatch(listall) '全部补丁
If listall Then patchList=dxArray(patchList)'倒序排列已打补丁
patch_okay=getPatchList() '已打补丁

if patch_okay<>"" then
	patchOkArray=split(patch_okay,",")
else
	patchOkArray=Array()
end if

if doAct="GO" then
	if patchNo<>"" then
		Set oItem=seekItem(patchList,patchNo)'得到要打的补丁对像
		if listType="old" then
			if reapplyPatch(patchNo,oItem.info,nowVer,blManual,packstr) then
					xInfo="补丁[" & patchNo & "]重新升级成功"
			else
					xInfo="补丁[" & patchNo & "]重新升级失败的有:<br>" & replace(packstr,vbcrlf,"<br>")
			end if
		else
			if applyPatch(patchNo,oItem.path,oItem.applyver,blManual) then
				if dohulue="hulue" then
					xInfo="补丁[" & patchNo & "]已忽略"
				else
					xInfo="补丁[" & patchNo & "]升级成功"
				end if
			else
				xInfo="补丁[" & patchNo & "]升级失败"
			end if
		end if
	end if

	'-----------------更新已打补丁列表
	patchList=getremotePatch(listall) '全部补丁
	If listall Then patchList=dxArray(patchList)'倒序排列已打补丁
	patch_okay=getPatchList() '已打补丁
	if patch_okay<>"" then
		patchOkArray=split(patch_okay,",")
	else
		patchOkArray=Array()
	end if
	'-----------------更新已打补丁列表

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
    <td height='30' align="center" ><strong>系 统 在 线 升 级</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td>当前版本:<%=nowVer%>,最新版本:<%=session("Rver")%></td>
  </tr>
</table> <br>
<form name="form1" method="post" action="<%=request("script_name")%>">
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='tdbg'>
    <td height='30' align="center" >
      <input name="listType" type="radio" value="new" <%if listType="new" then Response.write "checked"%> onClick="this.form.patchNo.value='';this.form.submit();">
    未打补丁列表,
    <input type="radio" name="listType" value="old" <%if listType="old" then Response.write "checked"%> onClick="this.form.patchNo.value='';this.form.submit();">
    已打补丁列表, 
    <br>
    <font color="red">* 请按需要打相应的补丁，如果有多个连续未能显示出来的补丁包，则必须先打该补丁最近已存在的一个补丁</font>
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
''''''''''''分页'''''''''''''''''''
xlistcount=iIndex
xpagesize=5'设置每页记录数
xpageNocount=round2((xlistcount+1)/xpagesize)'总页数
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
				warning="警告!您应该先打" & pnote & "，若您直接升级补丁" & oInfo.name & ",这些补丁将被忽略,"
			else
				warning=""
			end if
%>

  <table width="95%" border="0" align="center" cellpadding="5" cellspacing="0">
    <tr>
      <td width="6%" align="right" ><img src="/images/patch.jpg" width="32" height="32"></td>
      <td width="94%" ><table width="100%" border="0" cellpadding="2" cellspacing="1" bgcolor="#CCCCCC">
        <tr>
          <td width="12%" align="right" bgcolor="#F4FCFF"><span class="STYLE4">〖补丁名称〗</span></td>
          <td width="26%" bgcolor="#F4FCFF"><%=oInfo.name%><span class="STYLE5">(版本号:v<%=oInfo.applyver%>)</span></td>
          <td width="21%" align="right" bgcolor="#F4FCFF"><span class="STYLE4">〖发布日期〗</span></td>
          <td width="41%" bgcolor="#F4FCFF"><%=oInfo.pdate%></td>
        </tr>
        <tr>
          <td align="right" bgcolor="#F4FCFF"><span class="STYLE4">〖补丁标题〗</span></td>
          <td bgcolor="#F4FCFF"><%=oInfo.title%></td>
          <td align="right" bgcolor="#F4FCFF"><span class="STYLE4">〖是否必选〗</span></td>
          <td bgcolor="#F4FCFF"><%=iif(oInfo.must="true","<font color=red>必须</font>","可选")%></td>
        </tr>
        <tr>
          <td align="right" bgcolor="#F4FCFF"><span class="STYLE4">〖详细说明〗</span></td>
          <td colspan="3" bgcolor="#F4FCFF"><PRE style="display:inline"><%=oInfo.info%></PRE></td>
          </tr>
        <tr>
          <td colspan="2" bgcolor="#F4FCFF">
          <%if listType="old" then %>
          <input type="button" name="Submit" value="重新升级此补丁" onClick="if (confirm('您确定升级此补丁')){this.form.patchNo.value='<%=oInfo.name%>';this.form.patchauto.value=this.form.ck_<%=oInfo.name%>.checked;this.form.submit();}">
          <%else%>
          <input type="button" name="Submit" value="升级此补丁" onClick="if (confirm('<%=warning%>您确定升级此补丁')){this.form.patchNo.value='<%=oInfo.name%>';this.form.patchauto.value=this.form.ck_<%=oInfo.name%>.checked;this.form.submit();}">
          <%end if%>
           <%if oInfo.must<>"true" and listType<>"old" then %>
           <input type="button" name="Submit1" value="忽略此补丁" onClick="if (confirm('忽略此补丁')){this.form.patchNo.value='<%=oInfo.name%>';this.form.patchauto.value=this.form.ck_<%=oInfo.name%>.checked;this.form.dohulue.value='hulue';this.form.submit();}">
           <%end if%>
            <input name="ck_<%=oInfo.name%>" type="checkbox" checked onClick="if (!this.checked){alert('您选择的是手动升级，点升级补丁后，系统将所有文件解压到<%=manualSavePath%>/<%=oInfo.name%>目录，请自行覆盖相关文件')}" <%if listType="old" then Response.write "disabled "%>>
            自动</td>
          <td colspan="2" align="right" bgcolor="#F4FCFF"></td>
          </tr>
      </table></td>
    </tr>
  </table>
  <hr size="1" noshade>
<%
			pnote=oInfo.name & "(版本号:v" & oInfo.applyver & ")"
		end if
		
	next
%>  
  <%
if disNum=0 then
	if listType="new" then
		Xnote="代理平台已经是最新版本，没有需要更新的补丁"
	else
		Xnote="未打任何补丁"
	end if
	Response.write "<BR><BR><BR><table width='100%'><tr><td><CENTER><B><font color=blue>" & Xnote & "</font></B></center></td></tr></table>"
end if
if disNum>0 then
  %>
  <table width='100%' border="0" cellpadding="0" cellspacing="0" bgcolor="#efefef">
    <tr><td align="center">
  &nbsp;<a href="<%=request("script_name")%>?xpageNo=1&listType=<%=listType%>"><b>首页</b></a>&nbsp;
  &nbsp;<a href="<%=request("script_name")%>?xpageNo=<%=xpageNo-1%>&listType=<%=listType%>&p=<%=p%>&u=<%=u%>"><b>上一页</b></a>&nbsp;
  &nbsp;<a href="<%=request("script_name")%>?xpageNo=<%=xpageNo+1%>&listType=<%=listType%>&p=<%=p%>&u=<%=u%>"><b>下一页</b></a>&nbsp;
  &nbsp;<a href="<%=request("script_name")%>?xpageNo=<%=xpageNocount%>&listType=<%=listType%>&p=<%=p%>&u=<%=u%>"><b>尾页</b></a>&nbsp;
  第<input type="text" id="pageput" size="4" value="<%=xpageNo%>">页<input type=button value="跳转" onClick="javascript:location.href='<%=request("script_name")%>?xpageNo='+document.getElementById('pageput').value+'&listtype=<%=listType%>&p=<%=p%>&u=<%=u%>'">
  &nbsp;当前第<b><%=xpageNo%></b>页/共<%=xpageNocount%>页
  &nbsp;共<%=xlistcount+1%>条记录
  &nbsp;每页<%=xpagesize%>条
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
	Response.write "意外，" & pName & "未找到"
	Response.end 
end function

sub checkreg()

	if lcase(u)<>lcase(api_username) or p<>api_password then 
		%>
        <form name="form1" action="<%=request.ServerVariables("SCRIPT_NAME")%>" method="post">
        <div align="center" style="border:#F93 solid 1px; width:400px">
        <ul style="list-style:none;overflow:hidden; width:300px">
        <li style="white-space:nowrap">用户名:<input type="text" name="u" style="width:150px"></li>
        <li style="white-space:nowrap">密&nbsp;&nbsp;码:<input type="password" name="p"  style="width:150px"></li>
        <li style=" text-align:center"><input type="submit" value=" 登 陆 "></li>
        </ul>
        </div>
        </form>
        <%
		response.end
	end if
end sub

%>