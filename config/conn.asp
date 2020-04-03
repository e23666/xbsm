<%

If isdbsql then
	 constr = "Provider = Sqloledb; User ID = " & SqlUsername & "; Password = " & SqlPassword & "; Initial Catalog = " & SqlDatabaseName & "; Data Source = " & SqlHostIP & ";"
		PE_True = "1"
		PE_False = "0"
		PE_Now = "GetDate()"
		PE_OrderType = " desc"
		PE_DatePart_D = "d"
		PE_DatePart_Y = "yyyy"
		PE_DatePart_M = "m"
		PE_DatePart_W = "ww"
		PE_DatePart_H = "hh"
		PE_DatePart_S = "s"
		PE_DatePart_Q = "q"
else
	DBPath = Server.MapPath("/database/global.asa") 
	'Microsoft.ACE.OLEDB.12.0
	'Microsoft.Jet.OLEDB.4.0
	constr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & DBPath
		PE_True = "True"
		PE_False = "False"
		PE_Now = "Now()"
		PE_OrderType = " asc"
		PE_DatePart_D = "'d'"
		PE_DatePart_Y = "'yyyy'"
		PE_DatePart_M = "'m'"
		PE_DatePart_W = "'ww'"
		PE_DatePart_H = "'h'"
		PE_DatePart_S = "'s'"
		PE_DatePart_Q = "'q'"
End If
%>
