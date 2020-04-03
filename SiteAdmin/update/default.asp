<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/patch_inc.asp" -->
<%
check_is_master(1)

listType=Request("listType")
if listType="" then listType="new"
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
			Set oItem=seekItem(patchList,patchNo)


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
<HEAD>
<TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<script src="/jscripts/jq.js"></script>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>系 统 在 线 升 级</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td>当前版本:<%=getVer()%>,最新版本:<%=session("Rver")%></td>
  </tr>
</table>
<br>
<form name="form1" method="post" action="<%=request("script_name")%>">
  <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
    <tr class='tdbg'>
      <td height='30' align="center" ><input name="listType" type="radio" value="new" <%if listType="new" then Response.write "checked"%> onClick="this.form.patchNo.value='';this.form.submit();">
        未打补丁列表,
        <input type="radio" name="listType" value="old" <%if listType="old" then Response.write "checked"%> onClick="this.form.patchNo.value='';this.form.submit();">
        已打补丁列表, <br>
        <font color="red">*请严格按照顺序从上到下，一个一个的打补丁</font> <br />
        <font color="red">*提示:系统在线升级会覆盖您当前的文件,如果您自己对程序或者模版进行了修改,那么升级可能会覆盖您修改的文件,建议您在升级前进行备份,如果您没有自行修改则直接使用升级即可.</font></td>
    </tr>
  </table>
 <div id="gxlog" name="gxlog" style="display:none">批量更新操作：<BR></div>
<%If listType="new" then%>
  <input type="button"  value="一键更新本页所有补丁" id="plbt" name="plbt" onClick="gopl(this)">
  <%
End if
Dim PlPatch


if xInfo<>"" then
	Response.write "<HR>" & Replace(Xinfo,",","<BR>") & "<HR>"
end if

disNum=0
pnote=""
iIndex=UBound(patchList)
''''''''''''分页'''''''''''''''''''
xlistcount=iIndex
xpagesize=100'设置每页记录数
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


'Response.write(disp(oInfo.name))
'Response.end

		if disp(oInfo.name) then
			disNum=disNum+1
			if pnote<>"" then
			'pnote=scanPrevious(patchList,patchOkArray,oInfo.name,oInfo.applyver)
			'if pnote<>"" then
				'warning="警告!您应该先打" & pnote & "，若您直接升级补丁" & oInfo.name & ",这些补丁将被忽略,"
				warning="警告!您应该先打" & pnote 
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
            <td colspan="2" bgcolor="#F4FCFF"><input type="button" name="Submit" value="升级此补丁" <%if listType="old" then Response.write "disabled "%>onClick="if ('<%=warning%>'!=''){alert('<%=warning%>')}else{if (confirm('您确定升级此补丁')){this.form.patchNo.value='<%=oInfo.name%>';this.form.patchauto.value=this.form.ck_<%=oInfo.name%>.checked;this.form.submit();}}">
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
  PlPatch=PlPatch&oInfo.name&","
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
    <tr>
      <td align="center">&nbsp;<a href="default.asp?xpageNo=1&listType=<%=listType%>"><b>首页</b></a>&nbsp;
        &nbsp;<a href="default.asp?xpageNo=<%=xpageNo-1%>&listType=<%=listType%>"><b>上一页</b></a>&nbsp;
        &nbsp;<a href="default.asp?xpageNo=<%=xpageNo+1%>&listType=<%=listType%>"><b>下一页</b></a>&nbsp;
        &nbsp;<a href="default.asp?xpageNo=<%=xpageNocount%>&listType=<%=listType%>"><b>尾页</b></a>&nbsp;
        第
        <input type="text" id="pageput" size="4" value="<%=xpageNo%>">
        页
        <input type=button value="跳转" onClick="javascript:location.href='default.asp?xpageNo='+document.getElementById('pageput').value+'&listtype=<%=listType%>'">
        &nbsp;当前第<b><%=xpageNo%></b>页/共<%=xpageNocount%>页
        &nbsp;共<%=xlistcount+1%>条记录
        &nbsp;每页<%=xpagesize%>条 </td>
    </tr>
  </table>

  <%end if%>
    <input type="hidden" value="<%=PlPatch%>" id="plbd" name="plbd">
  <input name="dohulue" type="hidden" id="dohulue">
  <input name="patchNo" type="hidden" id="patchNo">
  <input name="patchauto" type="hidden" id="patchauto">
  <input name="doAct" type="hidden" id="doAct" value="GO">
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
end Function


If listType="new" then
%>


<script>



var ni=0;
var v=$("#plbd").val();
var temp=v.split(",");
var objlog=document.getElementById("gxlog");
var bt;
function gopl(obj)
{

   if (confirm("此操作将一键更新本页所有补丁！"))
   {
	   bt=obj;
   obj.disabled=true;
   obj.value="正在批量执行，请稍等"
  gotopl();
   }
}

function gotopl()
{




   objlog.style.display="block";
   if(ni<temp.length-1)
   {
     getupdate(ni)
	 ni++;
   }else{
   location.reload();
   }
}








function getupdate(li)
{
$.ajax({url:'plupdate.asp',
type:'post',
data:{listType:"new",doAct:"GO",patchNo:temp[li]},
dataType:'html',
timeout:60000,
error:function(){
	objlog.innerHTML+="<font color=red>出现错误，可能超时了，请刷新本页再重试，谢谢！</font><BR>";
	bt.disabled=false;
	bt.value="重试批量补丁更新"
    },
success:function(result){
 switch(result)
 {
   case "200":
  str=temp[li]+"<font color=green>升级成功</font><BR>"
  isnext=true;
   break
   case "100":
  str=temp[li]+"<font color=green>已忽略</font><BR>"
  isnext=true;
   case "500":
 str=temp[li]+"<font color=red>升级失败</font><BR>"
  isnext=false;
   case "400":
 str=temp[li]+"<font color=red>未找到</font><BR>"
  isnext=false;
   break;
   default:
    location.reload();
   return false;
 }
   if (isnext)
   {
	objlog.innerHTML+=str;
	gotopl()
   }
   else{
    location.reload();
   return false;
   }
 }
})

}
</script>
<%end  if%>