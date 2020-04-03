<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<%
Set faqconn = Server.CreateObject("ADODB.Connection")
faqconnstr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath("/faq/data/global.asa") 
faqconn.Open faqconnstr
conn.open constr 
 
 faqconn.execute("update article_info set title='如何为企业品牌选择域名' where title='如何为企业品牌选择最佳域名'")
 %> 