<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/patch_inc.asp" -->
<%
 Response.CodePage=936
Response.CharSet = "GB2312"


check_is_master(1)

listType=Request("listType")
if listType="" then listType="new"
patchNo=Request("patchNo")
patchauto=Request("patchauto")
blManual=not (patchauto="true")
patchUrl=Request("patchUrl")
doAct=Request("doAct")
p_no_list=Request("p_no_list")
xpageNo=request("xpageNo")
dohulue=Request("dohulue")
if listType="new" then
	listall=false
else
	listall=true
end if
blManual=False
patchList=getremotePatch(listall) 'ȫ������
If listall Then patchList=dxArray(patchList)'���������Ѵ򲹶�
patch_okay=getPatchList() '�Ѵ򲹶�

if patch_okay<>"" then
	patchOkArray=split(patch_okay,",")
else
	patchOkArray=Array()
end if
	

'Response.write("sdfsaf")
if doAct="GO" Then
 
	if patchNo<>"" Then
	

			Set oItem=seekItem(patchList,patchNo)


     

			'Response.end
			if applyPatch(patchNo,oItem.path,oItem.applyver,blManual) then
				if dohulue="hulue" then
					xInfo=100  '"����[" & patchNo & "]�Ѻ���"
				else
					xInfo=200 '"����[" & patchNo & "]�����ɹ�"
				end if
			else
				xInfo=500 '"����[" & patchNo & "]����ʧ��"
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
   Response.write(xInfo)
end if

 
















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
	'Response.write(arrList(i).name&"<BR>")
		if pName=arrList(i).name then
			Set seekItem=arrList(i)
			exit function
		end if
	next
	Response.write 400  '"���⣬" & pName & "δ�ҵ�"
	Response.end 
end function
%>