<%

function keepKeyword(ByVal QState)
	keepKeyword=QState
	keyTable=",add,all,alphanumeric,alter,and,any,application,as,asc,assistant,autoincrement,avg,between,binary,bit,boolean,by,byte,char,character,column,compactdatabase,constraint,container,count,counter,create,createdatabase,createfield,creategroup,createindex,createobject,createproperty,createrelation,createtabledef,createuser,createworkspace,currency,currentuser,database,date,datetime,delete,desc,description,disallow,distinct,distinctrow,document,double,drop,echo,else,end,eqv,error,exists,exit,false,field,fields,fillcache,float,float4,float8,foreign,form,forms,from,full,function,general,getobject,getoption,gotopage,group,groupby,guid,having,idle,ieeedouble,ieeesingle,if,ignore,imp,in,index,index,indexes,inner,insert,inserttext,int,integer,integer1,integer2,integer4,into,is,join,key,lastmodified,left,level,like,logical,logical1,long,longbinary,longtext,macro,match,max,min,mod,memo,module,money,move,name,newpassword,no,not,note,null,number,numeric,object,oleobject,off,on,openrecordset,option,or,order,orientation,outer,owneraccess,parameter,parameters,partial,percent,pivot,primary,procedure,property,queries,query,quit,real,recalc,recordset,references,refresh,refreshlink,registerdatabase,relation,repaint,repairdatabase,report,reports,requery,right,screen,section,select,set,setfocus,setoption,short,single,smallint,some,sql,stdev,stdevp,string,sum,table,tabledef,tabledefs,tableid,text,time,timestamp,top,transform,true,type,union,unique,update,user,value,values,var,varp,varbinary,varchar,where,with,workspace,xor,year,yes,yesno,"
	spacePos=instr(QState," ")
	if spacePos=0 then
		exit function
	end if
	sqlcmd=left(QState,spacePos-1)
	select case sqlcmd
		case "select"
			fromPos=instr(QState,"from")
			if fromPos=0 then exit function
			fieldlist=mid(QState,spacePos+1,fromPos-spacePos-1)
			firstPart=left(QState,spacePos)
			thirdPart=mid(QState,fromPos)
		case "insert"
			iPos=instr(QState,"(")
			jPos=instr(QState,")")

			if iPos>0 and jPos>iPos then
				fieldlist=mid(QState,iPos+1,jPos-iPos-1)
				firstPart=left(QState,iPos)
				thirdPart=mid(QState,jPos)
			else
				exit function
			end if
		case else
			exit function
	end select

	fd_ok=""

	if fieldlist<>"" then
		fieldlist=Lcase(fieldlist)
		fdArray=split(fieldlist,",")
		for k=0 to Ubound(fdArray)
			fdname=fdArray(k)
			if instr(keyTable,"," & fdname & ",")>0 then
				fd_ok=fd_ok & "[" & fdname & "]"
			else
				fd_ok=fd_ok & fdname
			end if
		
			if k<Ubound(fdArray) then
				fd_ok=fd_ok & ","
			end if
		next
		keepKeyword=firstPart & fd_ok & thirdPart
	end if
end function


function isConstStr(strCheckStr,Byval iPos)
	comma=0
	intPos=1
	clen=len(strCheckStr)

	do while intPos<=iPos and intPos<=clen
		sChar=mid(strCheckStr,intPos,1)
		if sChar="'" then
			comma=comma+1
		end if
		intPos=intPos+1
	Loop

	if comma mod 2 =0 then
		isConstStr=false
	else
		isConstStr=true
	end if
end function

sub stack_push(arrStack,strValue)
	StackTop=UBound(arrStack)
	ReDim preserve arrStack(StackTop+1)
	arrStack(StackTop+1)=strValue
End sub

Function stack_pop(arrStack)
	StackTop=UBound(arrStack)
	If StackTop=0 Then
		stack_pop=".EMPTY."
	Else
		stack_pop= arrStack(StackTop)
		StackTop=StackTop-1
		ReDim preserve arrStack(StackTop)
	End if
End Function

Function stack_empty(arrStack)
	If UBound(arrStack)=0 Then
		stack_empty=True
	Else
		stack_empty=false
	End if
End function

Function stack_init()
	Dim s_stack()
	ReDim s_stack(0)
	stack_init=s_stack
End Function

Function GetArrayBySymbol(ByVal strSource)
	strSource=strSource & ","
	strTmp=""
	strLen=Len(strSource)
	stackSpace=stack_init()
	elementCount=-1
	Dim returnArray()
	For i=1 To strLen
		sigChar=Mid(strSource,i,1)
		if sigChar="(" then
			stack_push stackSpace,"("
		end if
		
		if sigChar=")" then
			Zzz=stack_pop(stackSpace)
		end if
		
		if sigChar="," and stack_empty(stackSpace) then
				elementCount=elementCount+1
				ReDim preserve returnArray(elementCount)
				returnArray(elementCount)=Trim(strTmp)
				strTmp=""
		else		
				strTmp=strTmp & sigChar
		end if
	next
	GetArrayBySymbol=returnArray
End Function

function GetExpress(nType,Kvalue) '根据字段类型返回不同的表达式
	select case Trim(nType)
		case 16,2,3,20,17,18,19,21,4,5,6,14,131,12 '数字类型
			if not isNumeric(Trim(Kvalue)) and Kvalue<>"" then
				tsql_die Kvalue & "不是数字"
			end if
			if Kvalue<>"" then
				GetExpress=Kvalue '完整返回
			else
				GetExpress="null"
			end if
		case 11 '逻辑值
			if isNumeric(Kvalue) then
				if Cint(Kvalue)=0 then
					GetExpress=PE_False
				else
					GetExpress=PE_True
				end if
			else
				Kvalue=Lcase(Kvalue)
				if Kvalue="true" then
					GetExpress=PE_True
				else
					GetExpress=PE_False
				end if
			end if
		case 7,133,134,135,64 '日期值
			if not isDate(Kvalue) and Kvalue<>"" then
				tsql_die Kvalue & "不是日期"
			end if
			if Kvalue<>"" then
				GetExpress="'" & Kvalue & "'"
			else
				GetExpress="null"
			end if
		case 8,129,200,201,130,202,203,128,204,205,136,8192,139,132,9,10 '字符串或其它值
			if Kvalue<>"" then Kvalue=replace(Kvalue,"'","")
			GetExpress="'" & Kvalue & "'"
	end select
end function

Sub loadFDType(tbName,ByRef FdDict) '得到一个表的所有字段类型
	sql="select * from " & tbName & " where 1=2"
	Set localRs=conn.Execute(sql)
	for i=0 to localRs.fields.count-1
		FdDict.Add localRs.fields(i).name,localRs.fields(i).type
	next
	localRs.close
	Set localRs=nothing
end Sub

function getTbName(ByVal SQL) '从SQL中获取表名
	Set MYREG=New RegExp
	MYREG.Pattern="^[0-9a-zA-Z\[\]_]$"
	SQL=Lcase(Trim(SQL))
	iPos=instr(SQL," ")
	sqlCMD=left(SQL,iPos-1)
	lenSQL=len(SQL)

	select case sqlCMD
		case "select","delete"
			iPosFrom=instr(SQL,"from")
		case "update"
			iPosFrom=instr(SQL,"update")			
		case "insert"
			iPosFrom=instr(SQL,"into")
		case else
			tsql_die "invalid sql"
	end select
	iPosFrom=instr(iPosFrom,SQL," ")
	jPos=iPosFrom
	do while (mid(SQL,jPos,1)=" " and jPos<=lenSQL)
		jPos=jPos+1
	Loop
	iPosFrom=jPos
	do while (MYREG.test(mid(SQL,jPos,1)) and jPos<=lenSQL)
		jPos=jPos+1
	Loop
	getTbName=mid(SQL,iPosFrom,jPos-iPosFrom)
	Set MYREG=nothing
end function

Sub LoadInsertArgs(ByVal sql,ByRef oDict,ByRef oFieldType) '根据insert语句括号中的字段得到相关变量的类型

	iPos=instr(sql,"values")
	fd_flag_start=instr(sql,"(")+1
	fd_flag_end=instrRev(sql,")",iPos)
	

	va_flag_start=instr(iPos,sql,"(")+1
	va_flag_end=instrRev(sql,")")

	fd_list=mid(sql,fd_flag_start,fd_flag_end-fd_flag_start)
	va_list=mid(sql,va_flag_start,va_flag_end-va_flag_start)
	fd_list_arr=GetArrayBySymbol(fd_list)
	va_list_arr=GetArrayBySymbol(va_list)

	if Ubound(fd_list_arr)<>Ubound(va_list_arr) then
		tsql_die "insert statements error." & sql
	end if
	
	for i=0 to Ubound(va_list_arr)
		f_value=va_list_arr(i)
		if left(f_value,1)="@" then
			Kname=mid(f_value,2)
			Fname=fd_list_arr(i)
			if oFieldType.Exists(Fname) then
				If Not oDict.Exists(Kname) Then oDict.Add Kname,oFieldType(Fname)
			end if
		end if
	next
end Sub

sub tsql_die(x)
	Response.write "500 发生错误:" & x
	Response.end
end sub


function ext_sql(Byval Qstate,byRef arg) '扩展一个SQL,将@XXX扩展为具体的变量
	Set oRepl=new regExp
	Set oDict=CreateObject("Scripting.Dictionary"):oDict.compareMode=1
	Set insertMaps=CreateObject("Scripting.Dictionary"):insertMaps.compareMode=1

	localStr=Lcase(trim(Qstate))
	outStr=Qstate
	Set tmReg = new regExp
	tmReg.Global=true
	tmReg.Pattern="([a-zA-Z0-9_]+)\s*(=|\<\>|\>|\<)\s*@([a-zA-Z0-9_]+)"

	strTableName=getTbName(Qstate)
	Call loadFDType(strTableName,oDict)

	iposSpace=instr(localStr," ")
	sword=left(localStr,iposSpace-1)

	select case sword
		case "select","delete"
			iPosWhere=instr(localStr,"where")
			if iPosWhere>0 then
				localStr=mid(Qstate,iPosWhere+5)
			else
				ext_sql=Qstate
				exit function
			end if			
		case "update"
			localStr=Qstate
		case "insert"
			localStr=Qstate
			tmReg.Pattern="@([a-zA-Z0-9_]+)"
			Call LoadInsertArgs(Qstate,insertMaps,oDict)
	end select
	Set params=tmReg.Execute(localStr)
	for each objMatch in params
		if sword<>"insert" then
			fieldName=objMatch.subMatches(0)
			varName=objMatch.subMatches(2)

			if oDict.Exists(fieldName) then
				fdType=oDict(fieldName)
			else
				fdType=12 '默认作为数字处理
			end if
		else
			'insert 语句，单独处理
			varName=objMatch.subMatches(0)
			if insertMaps.exists(varName) then
				fdType=insertMaps(varName)
			else
				fdType=12
			end if
		end if
		if arg.Exists(varName) then
			expval=GetExpress(fdType,arg(varName))
			if varName="qq" then
				oRepl.Pattern="@" & varName & ","
				expval=expval & ","
			else
				oRepl.Pattern="@" & varName & "\b"
			end if
			expval=Replace(expval,"$","[$]")
			outStr=oRepl.Replace(outStr,expval)
			outStr=Replace(outStr,"[$]","$")
		else
			tsql_die "Miss @" & varName
		end if
	next
	
	'处理遗漏的标记 ,DateAdd('yyyy',@year,now()),

	tmReg.Pattern="@([a-zA-Z0-9_]+)"

	if sword="select" then
		toCkStr=localStr
	else
		toCkStr=outStr
	end if

	Set params=tmReg.Execute(toCkStr)

	for each objMatch in params
		Kname=objMatch.subMatches(0)
		if not isConstStr(toCkStr,objMatch.FirstIndex) then
			if arg.Exists(Kname) then
				oRepl.Pattern="@" & Kname & "\b"
				'Response.write(Kname&"<BR>")
				outStr=oRepl.replace(outStr,arg(Kname&""))
			else
				tsql_die "_Miss @" & Kname
			end if
		end if
	next
		'--------------
	ext_sql=outStr
end function

Sub select_sql(byval strSql,byref arg) '处理select @xxx=yyy from tbname,并将xxx作为arg字典对象的项返回
 	strSql=ext_sql(strSql,arg)
	localStr=trim(lcase(strSql))
	Set tmReg = new regExp
	tmReg.Pattern="@([a-zA-Z0-9_]+)\s*=\s*(.+)"
	lenSQL=len(strSql)
	
	iPos=instr(localStr," ")
	if iPos=0 then
		tsql_die "无效的sql"
	end if

	sword=left(localStr,iPos-1)

	if sword<>"select" then
		tsql_die "expect select"
	end if

	iPosFrom=instr(localStr,"from")
	if iPosFrom=0 then
		tsql_die "expect from"
	end if

	'处理select top N 这种情况
	jPos=iPos
	do while (mid(localStr,jPos,1)=" " And jPos<=lenSQL)
		jPos=jPos+1
	Loop
	if mid(localStr,jPos,4)="top " then
		jPos=instr(jPos,localStr," ")
		do while (mid(localStr,jPos,1)=" " and jPos<=lenSQL )
			jPos=jPos+1
		Loop

		do while (isNumeric(mid(localStr,jPos,1)) and jPos<=lenSQL)
			jPos=jPos+1
		Loop

		iPos=jPos
	end if

	firstStr=left(strSql,iPos)
	midStr=Trim(mid(strSql,iPos+1,iPosFrom-iPos-1))
	suffixStr=mid(strSql,iPosFrom)	

	fields=GetArrayBySymbol(midStr)
	fdlist=""
	store_list=""

	for i=0 to Ubound(fields)
		field=fields(i)
		if tmReg.test(field) then
			Set oMatch=tmReg.Execute(field)(0)
			Kname=oMatch.subMatches(0)
			fdName=oMatch.subMatches(1)
			fdlist=fdlist & fdName & ","
			store_list=store_list & Kname & "=" & i & ","
		else
			fdlist=fdlist & field & ","
		end if
	next

	if right(store_list,1)="," then store_list=left(store_list,len(store_list)-1)
	if right(fdlist,1)="," then fdlist=left(fdlist,len(fdlist)-1)
	strNewSql=firstStr & fdlist & " " & suffixStr
	Set localRs=conn.Execute(strNewSql)
	arg_list=split(store_list,",")
	for each arg_item in arg_list
		pairs=split(arg_item,"=")
		Kname=pairs(0)
		Kindex=Cint(pairs(1))
		
		if not localRs.eof then
			arg.add Kname,localRs(Kindex).value
		else
			arg.add Kname,""
		end if
	next
	localRs.close
	Set localRs=nothing
	Set tmReg=nothing
end Sub

function exists_sql(sql)
	Set tmRs=conn.Execute(sql)
	if tmRs.eof then
		exists_sql=false
	else
		exists_sql=true
	end if
	tmRs.close
	Set tmRs=nothing
end function

Sub exec_sql(Byval sql)
	conn.Execute(Sql)
end sub

function exists_sql_arg(sql,Byref arg)
	Sql2=ext_sql(sql,arg)
	Set tmRs=conn.Execute(sql2)
	exists_sql_arg=not tmRs.eof
	tmRs.close
	Set tmRs=nothing	
end function

Sub exec_sql_arg(Byval sql,ByRef arg)
    If InStr(sql,"orderlist")>0 Then
		

	End if
	Sql=ext_sql(Sql,arg)
	Sql=keepKeyword(Sql)
	conn.Execute(Sql)
end sub

'部分可选参数请先使用该方法添加默认值
Sub SetOption(Kname,Kvalue,ByRef objArg) '设置可选参数的默认值
	if not objArg.Exists(Kname) then
		objArg.Add Kname,Kvalue
	end if
end Sub

Sub SetValue(Kname,Kvalue,ByRef Arg) '设置一个字典对象的值
	if left(Kname,1)="@" then
		tsql_die "Setvalue @" & Kname & ",Error!"
	end if
	if not Arg.Exists(Kname) then
		Arg.Add Kname,Kvalue
	else
		Arg(Kname)=Kvalue
	end if
end Sub


Function Gets(Kname,ByRef Arg) '获取字典对象中一个项的值
	if not Arg.Exists(Kname) then
		tsql_die "缺少参数:" & Kname
	end if
	Gets=Arg(Kname)
end Function

function GetFieldValue(Exp1,Tbname,FdSearch,FdValue) '获取一个表中一个字段的值

	if Exp1 ="@@identity" then
		If isdbsql Then
		sql="select IDENT_CURRENT('"&Tbname&"')"
	    else
		Sql="select @@identity from " & Tbname
		End if
	else
		Sql="select " & Exp1 & " from " & Tbname & " where " & FdSearch & "='" & FdValue & "'"
	end if
	Set localRs=conn.Execute(Sql)
	if not localRs.eof then
		GetFieldValue=localRs(0).value
	else
		GetFieldValue=""
	end if
	localRs.close
	Set localRs=nothing
end function


%>