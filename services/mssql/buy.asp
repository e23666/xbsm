<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/parsecommand.asp" --> 
<%
response.charset="gb2312"
conn.open constr
Select Case trim(requesta("module"))
  case "ver"
   roomid=requesta("roomid")
   if not isnumeric(roomid&"") then die "err"
   die trim(getmssqlver(roomid))

  case "getroomlist"
 
      die  setRoom(requesta("Productid"))
 
  case "getprice"
  Price=GetNeedPrice(session("user_name"),requesta("Productid"),1,"new")
  die Price
  Case "checkdbname"
	   		dbname=trim(requesta("dbname"))
	   		if not checkdbnameIn(dbname,errstr2) then
				response.write toerrStr(errstr2)
				response.write "<input type='hidden' name='isftppd' id='isftppd' value='0'>"
			else
				response.write torightStr("��ϲ,�����ݿ����ƿ���ʹ��")
				response.write "<input type='hidden' name='isftppd' id='isftppd' value='1'>"
			end if
			response.end
  Case "addshopcart"
		call needregsession()
		bcheck = true
		producttype=8
		productid=trim(requesta("productid"))
		freeid=requesta("freeid")
		dbversion=requesta("dbversion")
		 
		if freeid<>"" and dbversion="" then 
           call url_return("��ѡ�������ݿ�汾",-1)
		end if
		isfree=getFreedatebase(freeid,f_freeproid,f_content)
		vyears=trim(requesta("years"))
		dbname=lcase(trim(requesta("dbname")))
		dbloguser=lcase(trim(requesta("dbloguser")))
		dbpasswd=lcase(trim(requesta("dbpasswd")))
		databasesize=trim(requesta("databasesize"))
		paytype=requesta("paytype")''����ʽ
		room=trim(requesta("room"))
		if not checkdbnameIn(dbname,errstrs) then conn.close:url_return errstrs,-1
		if not ischeckdatabase(dbname,productid,vyears,productName,errstr1) then conn.close:url_return errstr1,-1
				if paytype=1 then
					price=5
				else
			    	Price=GetNeedPrice(session("user_name"),productid,1,"new")
				end if
				strContents = strContents & "mssql" & vbCrLf
				strContents = strContents & "add" & vbCrLf
				strContents = strContents & "entityname:mssql" & vbCrLf
				strContents = strContents & "producttype:" & productid & vbCrLf
				strContents = strContents & "room:" & room &";"& dbversion & vbCrLf
				strContents = strContents & "years:" & vyears & vbCrLf
				strContents = strContents & "databasename:" & dbname & vbCrLf
				strContents = strContents & "databaseuser:"& dbname & vbCrLf
				strContents = strContents & "dbupassword:" & dbpasswd & vbCrLf
				strContents = strContents & "paytype:" & paytype & vbCrLf '''''����ʽ
				strContents = strContents & "ppricetemp:" & price & vbCrLf
				strContents = strContents & "productnametemp:" & productName & vbCrLf
				strContents = strContents & f_content
				strContents = strContents & "." & vbCrLf

				ywtype="mssql"
				ywname=dbname
				call add_shop_cart(session("u_sysid"),ywtype,ywname,strContents)	
				'session("order") =  strContents & session("order")
				conn.close
				Response.redirect "/bagshow/"
			
End Select
		productid=trim(requesta("productid"))
		freeid=requesta("freeid")
		isfree=getFreedatebase(freeid,f_freeproid,f_content)
		if isfree then productid=f_freeproid
		rs.open "select top 1 *  from productlist where P_proId='" & productid &"' and p_type=7" ,conn
		If rs.eof And rs.bof Then 	rs.close : conn.close : errpage "��ǫ,�ò�Ʒ������"
		productName=rs("p_name")
		productid= rs("p_proID")
		databasesize = rs("p_size")
		rs.close

		Price=GetNeedPrice(session("user_name"),ProductID,1,"new")
		'-------------------------------------------------------------
		call setHeaderAndfooter()
		call setwebhostingLeft()
	 	tpl.set_file "main", USEtemplate & "/services/mssql/buy.html"
		tpl.set_var "productName",productName,false
		tpl.set_var "productid",productid,false
		tpl.set_var "freeid",freeid,false
		tpl.set_var "price",Price,false
		tpl.set_var "databasesize",databasesize,false
		tpl.set_var "setroomlist",getroomlist(Productid),false
		tpl.set_var "buyHostpriceList",buyHostpriceList,false
		tpl.parse "mains","main",false
		tpl.p "mains" 
		set tpl=nothing
		conn.close


function getroomlist(byval proid)
	if trim(requesta("freeid"))="" then
		getroomlist=setRoom(proid)
	else	
		getroomlist="<select name=room><option value=0>ϵͳ���ܷ���������·</option></select>"

	end if
end function

function buyHostpriceList()
	  islook=true
	  if isfree then
	  	hostpricelist=  "<select name=""years"" size=""1"">" & vbcrlf & _
						"<option value=""1"">��Ʒ���</option>" & vbcrlf & _
						"</select>"
	  else
			  selstr = getpricelist(session("user_name"),productid)
			  if selstr<>"" then
				strArray=split(selstr,"|")
				if ubound(strArray)>=10 then
					islook=false
					oneyearsprice=strArray(0)
							hostpricelist ="<select name=""years"" size=""1"">" & vbcrlf
						showArray=split("2,��2����1��|3,��3����2��|5,��5����5��|10,��10����10��","|")
						xzli=0
						for each ii in split("0,1,2,4,9",",") 
							needPrice=strArray(ii)
							savePrice=oneyearsprice*(ii+1)-needPrice
							saveStr=""

						    if xzli<=ubound(showArray) then
								showtemp=split(showArray(xzli),",")
									if clng(showtemp(0))=clng(ii+1) then
									showtxt="["&showtemp(1)&"]"
									xzli=xzli+1
									else
									showtxt=""
									end if
								end if


							if savePrice>0 then saveStr="����ʡ:"& FormatNumber(savePrice,2,,,0) & "Ԫ��"
			
							hostpricelist = hostpricelist & "<option value="""& (ii+1) &""">"& FormatNumber(needPrice,2,,,0) & "Ԫ/" & (ii+1)& "��"& showtxt &"</option>" & vbcrlf
							
						next
							hostpricelist = hostpricelist & "</select>"
							if trim(session("user_name"))&""="" then hostpricelist = hostpricelist & "<font color=""#999999"">��û�е�½,��ֱ�ӿͻ���ݼ���۸�</font>"
				end if
			  end if
	  end if
    buyHostpriceList=hostpricelist

end function
function checkdbnameIn(byval dbname,byref errstr)
	checkdbnameIn=false
	errstr=""
	
	hostcheckstr="mysql,root,mssql,sqlserver,sa,domainname,dnsresolve,system,administrator,pcj,fancy,TsInternetUser,service,network,replicator,client,guests,batch,dialup,interactive,everyone"
	
	if not checkRegExp(dbname,"^[A-Za-z]{1}[0-9A-ZA-z-_]{4,14}$") then errstr="ֻ����ĸ��ͷ������+��ĸ���(����:5-15)":exit function
	if len(dbname)<5 or len(dbname)>40 then errstr="����������Ӧ�ڣ�-60λ֮��":exit function
	if instr(","& lcase(hostcheckstr) &",",","& lcase(dbname) &",")>0 then errstr="���ݿ����н��ùؼ���":exit function


		Xcmd="other" & vbcrlf
		Xcmd=Xcmd & "get" & vbcrlf
		Xcmd=Xcmd & "entityname:mssqlexists" & vbcrlf
		Xcmd=Xcmd & "sitename:" & dbname & vbcrlf & "." & vbcrlf
		chk_userstr=Session("user_name")
		if len(Session("user_name"))<=0 then chk_userstr="AgentUserVCP"
		loadRet=Pcommand(Xcmd,chk_userstr)
		'die Xcmd
		if success(loadRet) then
			Xstatus=getReturn(loadRet,"status")
			if Xstatus="yes" then
				errstr="�����ݿ����Ѿ�����"
				exit function
			end if
		end if


 		sqls="select dbsysid from databaselist where dbname='"& dbname &"'"
		set rszxw=conn.execute(sqls)
		if not rszxw.eof then
			errstr="�����ݿ����Ѿ�����"
		else
			if isInbagshow(dbname,"database") then
				errstr="�����ݿ����Ѵ����ڹ��ﳵ��"
			else
				checkdbnameIn=true
			end if
		end if
		rszxw.close
		set rszxw=nothing
end function
function ischeckdatabase(byval dbname,byval productid,byval vyear,byref p_name,byref errstr)
		errstr=""
		ischeckdatabase=false
		if trim(productid)&""="" or len(productid)>10 then errstr="��Ʒ�ͺŴ���":exit function
		if not isnumeric(vyear) then errstr="���޴���":exit function
		
		if vyear>10 or vyear<1 then errstr="����Ӧ��1-10��֮��":exit function
		if not checkdbnameIn(dbname,dberrstr) then errstr=dberrstr:exit function

	psql="select top 1 *  from productlist where p_type=7 and P_proId='"& productid &"'"
	set prs=conn.execute(psql)
	if not prs.eof then
		p_name=prs("p_name")
		p_maxmen=prs("p_maxmen")
		p_size=prs("p_size")
		ischeckdatabase=true

	else
		errstr="û�д���������"
	end if
	prs.close
	set prs=nothing
end function
%>