<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%
response.Charset="gb2312"
response.Buffer=false
conn.open constr
id=Trim(Requesta("id"))
act=Trim(requesta("act"))
newproid=requesta("newproid")
newserverRoom=requesta("serverroom")
newcdntype=requesta("cdntype")
blday=requesta("blday")
if not isNumeric(id) or id&""="" then url_return "pleaes input ID !"&id,-1
set bs=new buyServer_Class:bs.setUserid=session("u_sysid"):bs.oldhostid=id
call bs.getHostdata(id)
if act="needprice" then	
		call bs.getUpInfo(newproid,newserverRoom,blday)
		bs.newproid=newproid
		bs.newRoom=newserverRoom
		bs.newcdn=newcdntype
		bs.blday=blday
		upprice=bs.getupneedprice()
		money_daycj=round(bs.money_daycj,2)
		if money_daycj<1 and money_daycj>0 then money_daycj=formatnumber(money_daycj,2,-1)
		blmsgstr="":if bs.blprice>0 then blmsgstr="�����ݱ�����["& bs.blprice &"]"
		response.write "(�¼۸�["& bs.newprice &"]-ԭ�۸�["& bs.oldprice &"])��������["& bs.all_day &"]��"& money_daycj & "Ԫ" & vbcrlf
		response.write bs.souxvfei &"Ԫ"& vbcrlf
		response.write "ÿ��Ĳ��["& money_daycj &"]��δʹ������["& bs.leavings_day &"]"& blmsgstr &"+������["& bs.souxvfei &"]��<font class=""price"">" & upprice & "</font>Ԫ" & vbcrlf
		if bs.newRoom<>bs.oldRoom or bs.isXtoV(bs.newproid,bs.oldproid) then response.write "chg"
		conn.close:set bs=nothing
		response.End()
elseif act="roomlist" then
	call bs.getUpInfo(newproid,bs.oldRoom,blday)
	response.write bs.up_selectroomlist
	conn.close
	set bs=nothing
	response.End()
elseif act="upgrade" then
	result=bs.upgrade(newproid,newserverRoom,newcdntype,blday,errstr)
	if result then		
		alert_redirect "��ϲ�������ɹ�",requesta("script_name")&"?id="&id
	else
		alert_redirect "����ʧ�� "&errstr,requesta("script_name") & "?id="& id
	end if	
end if
call bs.getUpInfo(bs.oldproid,bs.serverRoom,0)
if bs.upstate>0 then gowithwin "update_state.asp?id="& id & "&act="& bs.upstate
call doUserSyn("server",bs.allocateip)   
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>����IP��������</title>
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>

<link href="/images/CloudHost/jqtransform.css" rel="stylesheet" type="text/css" />
<link href="/images/CloudHost/cloud.css" rel="stylesheet" type="text/css" />
<link href="/images/CloudHost/diyserver.css" rel="stylesheet" type="text/css" />
<script language="javascript" src="/jscripts/jq.js"></script>
<script language="javascript" src="/jscripts/upserver.js"></script>
<style>
.linebox dd{ float: none; padding:20px 0; display: inline-block; width: 100%}
.linebox dd.clearfix label{ text-align: left; font-weight: normal; width: 500px}
.linebox dd.clearfix label.title{ font-weight: bold; text-align: right; margin-right: 20px; width: 120px}
</style>
</HEAD>
<body>
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV"> 
    <!--#include virtual="/manager/manageleft.asp" -->
    <div id="ManagerRight" class="ManagerRightShow">
     <div id="SiteMapPath">
                                                      			 <ul>
                                                      			   <li><a href="/">��ҳ</a></li>
                                                      			   <li><a href="/Manager/">��������</a></li>
                                                      			   <li><a href="/Manager/servermanager/">����IP��������</a></li>
                                                      			   <li>����IP��������</li>
                                                      			 </ul>
         </div>
      <div class="manager-right-bg">
        <div class="main_table">

          <div class="table_out">
            <form name="form_uphost" action="<%=requesta("script_name")%>" method="post">
              <dl class="linebox" style="width:700px; margin:10px;">
                <dd class="clearfix">
                  <label class="title">ԭ������IP:</label>
                  <label><%=bs.allocateip%></label>
                </dd>
                <dd class="clearfix">
                  <label class="title">���ʽ:</label>
                  <label><%=bs.getpaymethodName(bs.PayMethod)%></label>
                </dd>
                <dd class="clearfix">
                  <label class="title">ʹ��ʱ��:</label>
                  <label><%=formatdatetime(bs.starttime,2)%>��<%=formatdatetime(bs.oldexpiredate,2)%></label>
                </dd>
                <dd class="clearfix">
                  <label class="title">ԭ�ͺ�:</label>
                  <label><%=bs.oldproid%></label>
                </dd>
                <dd class="clearfix">
                  <label class="title">ԭ����:</label>
                  <label><%=getroomname_(bs.oldRoom,"","")%></label>
                </dd>
                <dd class="clearfix" id="newp_proid">
                  <label class="title">���ͺ�:</label>
                  <label><%=bs.up_proidlist%></label>
                </dd>
                <dd class="clearfix" id="newcdntype">
                  <label class="title">��CDN����:</label>
                  <label>
                    <select name="cdntype">
                    </select>
                  </label>
                </dd>
                <dd class="clearfix" id="newroomlist">
                  <label class="title">�»���:</label>
                  <label><%=bs.up_selectroomlist%></label>
                </dd>
                <dd class="clearfix" id="bldaymsg" style="display:none">
                  <label class="title">��������:</label>
                  <label><%=bs.up_baoliuday%></label>
                </dd>
                <dd class="clearfix" id="cjprice">
                  <label class="title">ÿ����:</label>
                  <label></label>
                </dd>
                <dd class="clearfix" id="sxprice">
                  <label class="title">������:</label>
                  <label></label>
                </dd>
                <dd class="clearfix" id="upprice">
                  <label class="title">�ϼ�:</label>
                  <label style="width:auto"></label>
                </dd>
                <dd class="buttonmsg">
                  <input type="button" class="manager-btn l-btn" style="margin-left: 140px" value="ȷ������" name="up_button" />
                  <div id="loadsubinfo" style="display:none"><img src="/images/mallload.gif">����ִ����,����ˢ�»�رո�ҳ��..</div>
                </dd>
              </dl>
              <input type="hidden" name="id" value="<%=id%>" />
              <input type="hidden" name="oldcdntype" value="<%=bs.oldcdn%>" />
              <input name="act" type="hidden" value="upgrade">
              <input type="hidden" name="oldproid" value="<%=bs.oldproid%>" />
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!--#include virtual="/manager/bottom.asp" --> 

</body>
</html>
