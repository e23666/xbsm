<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
response.charset="gb2312"
conn.open constr
module=trim(requesta("module"))
if module="needPrice" then
		Productid=requesta("Productid")
		if Productid<>"" and session("user_name")<>"" then 
			returnPrice=getpricelist(session("user_name"),Productid)
			if returnPrice<>"" then
				PriceArray=split(returnPrice,"|")
				%>
				<select name="years" class="selectbox">
               <%
				for ij=0 to ubound(PriceArray)-1
					
                    response.write "<option value="""& (ij+1) &""" >"& (ij+1) & " �꡾"& PriceArray(ij) &" ����" &"</option>"
                next
				%>
                </select>
                <%
			else
				response.write "û���ҵ����ͺ�"
			end if
		else
			response.write "���½���ٽ��в���"
		end if
		conn.close
		response.end
end if

call needregSession()


if session("user_name")="zhaomu3" then url_return "��Ǹ������������DNS������࣬�빺�򸶷�DNS����",-1

Select Case module
  Case "addshopcart"
				bcheck = true
				producttype=5
				productid=trim(requesta("productid"))
				vyears=trim(requesta("years"))
				domainname=Lcase(Requesta("domainname"))
				domainpwd=trim(requesta("domainpwd"))
				if not checkRegExp(domainpwd,"^[\w\-]{4,15}$") then url_return "��������Ӧ��4-15λ֮��,��û�������ַ�",-1
				
				if not isDomain(domainname) then url_return "������ʽ����,��ȷ����Ϊ:abc.com",-1
				if GetsRoot(domainname)<>domainname then url_return "ֻ����д��������",-1
				if isInbagshow(domainname,"dns") then url_return "�������Ѵ����ڹ��ﳵ��",-1
				
			sql="SELECT * FROM productlist WHERE p_type = 5 and p_proid='"& productid &"'"
			rs1.open sql,conn,3
			If not rs1.eof Then 
				productName=rs1("p_name")
				pprice=GetNeedPrice(session("user_name"),Productid,1,"new")
			end if
			rs1.close
			
		'''''''''''''''''''''''''�趨��������,�շ�dns����''''''''''''''''
		 
			if pprice<=0 then
				if Ccur(Session("u_resumesum"))+Ccur(session("u_usemoney"))<1 then url_return "��Ǹ,��δ����˾���κ�����,���ɹ���DNS",-1
				getlyear = isbindings(domainname,myyear)
				if cint(myyear)<cint(vyears) then
					url_return "�������Ĺ������޲��ܴ���"& myyear &"��" ,-1
				end if
			end if
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			If vyears<=0 Then vyears=1
			 pprice= vyears * pprice
			sql="select strdomain from domainlist where strdomain='"& domainname &"'"
			rs.open sql,conn,1,1
			if rs.eof and rs.bof then
		
				strContents = "dnsresolve" & vbCrLf & "add" & vbCrLf & "entityname:dnsdomain" & vbcrlf
				strContents =strContents & "domainname:"& domainname & vbcrlf
				strContents =strContents & "term:"& vyears  & vbcrlf
				strContents =strContents & "producttype:"& productid   & vbcrlf
				strContents = strContents & "ppricetemp:" & pprice & vbCrLf
				strContents = strContents & "domainpwd:" & domainpwd & vbCrLf
				strContents = strContents & "productnametemp:" & productName & vbCrLf
				strContents = strContents & "." & vbCrLf
				'response.write replace(strcontents,vbcrlf,"<br>")
				'response.end
				ywtype="DNS"
				ywname=lcase(domainname)
				call add_shop_cart(session("u_sysid"),ywtype,ywname,strContents)	
				'session("order") =  strContents & session("order")
				rs.close
				conn.close
				
				Response.redirect "/bagshow/"
				response.end
			else
				rs.close
				conn.close
				url_return "�������Ѿ��������������������롣",-1
			end if
  
End Select


call setHeaderAndfooter()
call setdomainLeft()
tpl.set_file "main", USEtemplate&"/services/domain/dns.html"

call setproductidlist(proid)
call setProductyears(proid)

tpl.parse "mains","main",false
tpl.p "mains" 

set tpl=nothing
conn.close


sub setproductidlist(byref fproductid)
	sql="select * from productlist where p_type=5 order by p_proid"
rs1.open sql,conn,3
	if not rs1.eof then
			tpl.set_block "main","productidlist", "plist"
			fproductid=rs1("p_proid")
			do while not rs1.eof
				productidValue=rs1("p_proid")
				p_info=rs1("p_info")
				productidText=ucase(productidValue) & "-" & p_info
				
				tpl.set_var "productidvalue",productidValue,false
				tpl.set_var "productidtext",productidText,false
				tpl.parse "plist", "productidlist", true
				
				rs1.movenext
			loop
	end if
	rs1.close
end sub
sub setProductyears(byval productid)
	tpl.set_block "main","yearslist", "ylist"
	returnPrice=getpricelist(session("user_name"),Productid)
	if returnPrice<>"" then
		PriceArray=split(returnPrice,"|")
		for ij=0 to ubound(PriceArray)-1
			tpl.set_var "yearsvalue",ij+1,false
			tpl.set_var "yearstext",(ij+1) & " �꡾"& PriceArray(ij) &" ����",false
			tpl.parse "ylist","yearslist",true
		next
	end if
end sub
function isbindings(mydomain,byref s_year)
	isbindings=false
	s_year=1
   If isdbsql Then
	   bsql="select isnull(s_bindings,'') as s_bindings,s_year from vhhostlist where s_ownerid="& session("u_sysid")
   else
       bsql="select iif(isnull(s_bindings),'',s_bindings) as s_bindings,s_year from vhhostlist where s_ownerid="& session("u_sysid")
   End if
   set brs=conn.execute(bsql)
   if not brs.eof then
   		do while not brs.eof
			for each dbbind in split(brs("s_bindings"),",")
				if trim(dbbind)<>"" then
					dbbind=GetsRoot(trim(dbbind))
					if trim(mydomain)=dbbind then
						    isbindings=true
							s_year=brs("s_year")
						    brs.close
   							set brs=nothing
							exit function
					end if
				end if
			next
		brs.movenext
		loop
   end if
   brs.close
   set brs=nothing
end function
%>	
