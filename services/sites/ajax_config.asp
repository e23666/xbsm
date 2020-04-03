<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%response.Charset="gb2312"
conn.open constr
u_level=session("u_levelid")
If Not isnumeric(u_level&"") Then u_level=1

sql="select   * from pricelist where left(p_proid,3)='ez_' and p_u_level="&u_level&" order by p_proid asc"
Set drs=conn.execute(sql)
Do While Not drs.eof
	p_price=drs("p_price")
	p_price_renew=drs("p_price_renew")
	If Not isnumeric(p_price_renew&"") Then p_price_renew=p_price
	Response.write("var "&lcase(drs("p_proid"))&"=["&p_price&","&p_price_renew&"];"&vbcrlf)
drs.movenext
loop
%> 

$(function(){
	$("select[name='room']").each(function(){
		var obj_=$(this)
		var xh=obj_.attr("data-xh");
		var lx=obj_.attr("data-lx");
		GetWebsitesYears(xh,lx,obj_.val(),5)
	})

	$("select[name='room']").change(function(){
		var obj_=$(this)
		var xh=obj_.attr("data-xh");
		var lx=obj_.attr("data-lx");
		GetWebsitesYears(xh,lx,obj_.val(),5)
	})

	$("#J_buyTplBtn,.J_buy-btn,.J-config-btn").click(function(){
		showbuy()
	})
})
function GetWebsitesYears(xh,bb,jf,num)
{
	console.log(xh+"	"+bb)
	var p_="";
	if(xh!="mobile")
	{
	var obj_=$('#price_'+bb+"_"+xh);
	}
	else{
	var obj_=$('#price_'+bb);
	}
	
	obj_.empty();
	
	if(xh=="mobile" && bb=="pro" && jf!="cn")
	{
		p_=ez_promblhk;
	}else if(xh=="mobile"  && bb=="pro" )
	{
		p_=ez_prombl;
	}else if(xh=="mobile" && bb=="ulti" && jf!="cn")
	{
		p_=ez_ultimblhk;
	}else if(xh=="mobile"  && bb=="ulti" )
	{
		p_=ez_ultimbl;
	}else if(xh=="mobile" && bb=="shop" && jf!="cn")
	{
		p_=ez_shopmblhk;
	}else if(xh=="mobile"  && bb=="shop" )
	{
		p_=ez_shopmbl;
	}else if(xh=="pc" && bb=="shop" && jf!="cn")
	{
		p_=ez_shophk;
	}else if(xh=="pc"  && bb=="shop" )
	{
		p_=ez_shop;
	}else if(xh=="pc" && bb=="pro" && jf!="cn")
	{
		p_=ez_prohk;
	}else if(xh=="pc"  && bb=="pro" )
	{
		p_=ez_professional;
	}else if(xh=="pc" && bb=="ulti" && jf!="cn")
	{
		p_=ez_ultihk;
	}else if(xh=="pc"  && bb=="ulti" )
	{
		p_=ez_ultimate;
	}else if(xh=="all" && bb=="shop" && jf!="cn")
	{
		var p=ez_shopmblhk[0]+ez_shopmblhk[0]*0.5;
		var p1=ez_shopmblhk[1]+ez_shopmblhk[1]*0.5;
		p_=[p,p1];
	}else if(xh=="all"  && bb=="shop" )
	{
		var p=ez_shop[0]+ez_shopmbl[0]*0.5;
		var p1=ez_shop[1]+ez_shopmbl[1]*0.5;
		p_=[p,p1];
	}else if(xh=="all" && bb=="pro" && jf!="cn")
	{
		var p=ez_prohk[0]+ez_promblhk[0]*0.5;
		var p1=ez_prohk[1]+ez_promblhk[1]*0.5;
		p_=[p,p1];
	}else if(xh=="all"  && bb=="pro" )
	{
		var p=ez_professional[0]+ez_prombl[0]*0.5;
		var p1=ez_professional[1]+ez_prombl[1]*0.5;
		p_=[p,p1];
	}else if(xh=="all" && bb=="ulti" && jf!="cn")
	{
		var p=ez_ultihk[0]+ez_ultimblhk[0]*0.5;
		var p1=ez_ultihk[1]+ez_ultimblhk[1]*0.5;
		p_=[p,p1];
	}else if(xh=="all"  && bb=="ulti" )
	{
		var p=ez_ultimate[0]+ez_ultimbl[0]*0.5;
		var p1=ez_ultimate[1]+ez_ultimbl[1]*0.5;
		p_=[p,p1];
	}else if(xh=="mobile"  && bb=="weishop" )
	{
		 
		p_=ez_weishop;
	}else if(xh=="all" && bb=="supreme" && jf!="cn"){
		var p=ez_tcsupremehk10[0]+ez_tcsupremehk10[0]*0.5;
		var p1=ez_tcsupremehk10[1]+ez_tcsupremehk10[1]*0.5;
		p_=[p,p1]; 
	}else if(xh=="all" && bb=="supreme"){
		var p=ez_tcsupreme10[0]+ez_tcsupreme10[0]*0.5;
		var p1=ez_tcsupreme10[1]+ez_tcsupreme10[1]*0.5;
		p_=[p,p1]; 
	}




	if(p_.length==2)
	{
		 
		for(var i=0;i<num;i++)
		{
	 
			obj_.append('<option value="'+(i+1)+'">'+(p_[0]*(i+1))+'元/'+(i+1)+'年</option>')
		}
		 
	}
	
	
}


function showbuy()
{
	var qqstr="<%=oicq%>"
	msg="<div style='color:red;font-size:16px;margin-bottom:15px;'>请联系在线客服购买</div><div style='line-height:35px;font-size:14px;'>"
	if(qqstr!="")
	{
		t_=qqstr.split(",")
		for(var i=0;i<t_.length;i++)
		{
		msg+='<p><a href="http://wpa.qq.com/msgrd?v=3&uin='+t_[i]+'&Site=-&Menu=no" target="_blank" class="link"><img border="0" src="http://wpa.qq.com/pa?p=1:'+t_[i]+':4" alt="点击发送消息给对方" >与客服对话</a></p>'
		}
	}
	msg+='</div>'
	$.dialog({"title":"联系在线客服购买","content":msg,id:"showbuy1111"})


}