<%
class ShengPayClass

       Private Sub Class_Initialize
	   
	   
	   end sub
       '时间转数字
       public Function NumTime(sDate)
			If Not IsDate(sDate) Then Exit Function
			NumTime = year(sDate)&Right("0"&Month(sDate),2)&Right("0"&Day(sDate),2)&_
						Right("0"&Hour(sDate),2)&Right("0"&Minute(sDate),2)& Right("0"&Second(sDate),2)
		End Function
		
	  '
	   public Function DeNumTime(intTime)
			If Not regTest(intTime,"^\d{14}$") Then Exit Function
			Dim oreg:Set oreg=New RegExp
			oreg.Global=true
			oreg.Pattern="(\d{4}?)(\d{2}?)(\d{2}?)(\d{2}?)(\d{2}?)(\d{2}?)"
			Set matches=oreg.Execute(intTime)
			For Each match In matches
				DeNumTime=match.Submatches(0) & "-" & match.Submatches(1) & "-" & match.Submatches(2) &_
				" " & match.Submatches(3) & ":" & match.Submatches(4) & ":" & match.Submatches(5)
			Next
			Set matches=Nothing:Set oreg=Nothing
		End Function
		'/*创建签名*/
		public Function BuildSign(origin)
			BuildSign = MD5(Origin,"UTF-8")
			BuildSign = UCase(BuildSign)
		End Function



end class
%>