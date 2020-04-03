<SCRIPT type=text/javascript>              
var waitting = 1;              
var secondLeft = waitting;              
var timer;                              
var sourceObj;              
var number;              
function getObject(objectId)//获取id的函数               
    {              
        if(document.getElementById && document.getElementById(objectId)) {              
        // W3C DOM              
        return document.getElementById(objectId);              
        } else if (document.all && document.all(objectId)) {              
        // MSIE 4 DOM              
        return document.all(objectId);              
        } else if (document.layers && document.layers[objectId]) {              
        // NN 4 DOM.. note: this won't find nested layers              
        return document.layers[objectId];              
        } else {              
        return false;              
        }              
    }              
function SetTimer()//主导航时间延迟的函数              
    {              
        for(j=1; j <10; j++){              
            if (j == number){              
                if(getObject("mm"+j)!=false){              
                    getObject("mm"+ number).className = "menuhover";              
                    getObject("mb"+ number).className = "";              
                }              
            }              
            else{              
                 if(getObject("mm"+j)!=false){               
                    getObject("mm"+ j).className = "";              
                    getObject("mb"+ j).className = "hide";               
                }              
            }              
        }              
    }              
function CheckTime()//设置时间延迟后              
    {              
        secondLeft--;              
        if ( secondLeft == 0 )              
        {              
        clearInterval(timer);                                      
        SetTimer();                      
        }              
    }              
function showM(thisobj,Num)//主导航鼠标滑过函数,带时间延迟              
    {              
        number = Num;              
        sourceObj = thisobj;              
        secondLeft = 1;              
        timer = setTimeout('CheckTime()',100);              
    }              
function OnMouseLeft()//主导航鼠标移出函数,清除时间函数              
    {              
        clearInterval(timer);              
    }              
</SCRIPT>

<div id="EdwardYang">
  <div id="TitleContent"> <a href="/">
    <div id="TitleLogo"><img src="<%=logimgPath%>" width="194" height="66"></div>
    </a>
    <div id="TitleRight">
      <div class="siteLink">
        <UL>
          <li id="tel">领先的互联网应用服务提供商</li>
          <li><img src="/Template/Tpl_05/newimages/tabicons_122.gif" width=12 height=12>&nbsp;<a href="/bagshow/">购物车</a></li>
          <li><img src="/Template/Tpl_05/newimages/tabicons_122.gif" width=12 height=12>&nbsp;<a href="/customercenter/buystep.asp">购买流程</a></li>
          <li><img src="/Template/Tpl_05/newimages/tabicons_122.gif" width=12 height=12>&nbsp;<a href="/customercenter/howpay.asp">付款方式</a></li>
          <li><img src="/Template/Tpl_05/newimages/tabicons_122.gif" width=12 height=12>&nbsp;<a href="/faq">常见问题</a></li>
          <li><img src="/Template/Tpl_05/newimages/tabicons_122.gif" width=12 height=12>&nbsp;<a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp">在线提问</a></li>         
        </UL>
      </div>
      <div id="quickLink">
        <UL>
          <br>
        </UL>
      </div>
      <%
	  if len(session("user_name"))>0 then
	   managerurl=newInstallDir & "/manager"
		  If session("u_type")<>"0" Then
			managerurl=SystemAdminPath
		 End If
	  %>
       <div id="TitleLoginOk">
          <div id="Logout"><a href="/signout.asp"><img src="/Template/Tpl_05/newimages/LongButton_logout.gif" width="84" height="24" /></a></div>
          <div id="lblManager"><a href="<%=managerurl%>" class="Link_Blue">[管理中心]</a> </div>
          <div id="LogLevelName"> 您的级别是:<span class="redColor"><%=session("u_level")%></span> </div>
          <div id="LoginUnameOk"> 您好:<span class="OrangeText"><%=session("user_name")%> </span></div>
        </div>
      </div>
      <%else%>
      	  <script language="JavaScript">
	  function checkLogin()
	  {
	  	if(myform.u_name.value=="")
		{
			alert("用户名不能为空！");
			myform.u_name.focus();
			return false;
		}
	  	if(myform.u_password.value=="")
		{
			alert("密码不能为空！");
			myform.u_password.focus();
			return false;
		}
	  }
	  </script>
	  <div id="TitleLogin">
        <form name="myform" action="/chklogin.asp" method="post" onSubmit="return checkLogin()">
          <div id="LoginUname"> 用户名:
            <input name="u_name" type="text" class="inputbox" value="" size="16">
          </div>
          <div id="LoginPass"> 密　码:
            <input name="u_password" type="password" class="inputbox" size="16">
          </div>
          <div id="LoginButton">
            <input name="imageField" type="image" src="/Template/Tpl_05/newimages/default/shortButton_login.gif" border="0">
          </div>
          <div id="RegButton"><a href="/reg"><img src="/Template/Tpl_05/newimages/default/shortButton_reg.gif" width="54" height="24" /></a></div>
          <div id="FindPassButton"><a href="/reg/forget.asp"><img src="/Template/Tpl_05/newimages/default/LongButton_FindPass.gif" width="84" height="24" /></a></div>
        </form>
      </div>
      <%end if%>
  </div>
</div>
<DIV id="menu">
  <DIV id="menu_top">
    <ul	id="menu_top_list">
      <li><a href="/">首 页
        <p>HOME</p>
        </a></li>
      <li><a href="/services/domain/">域名注册
        <p>DOMAIN</p>
        </a></li>
      <li><a href="/services/webhosting/">虚拟主机
        <p>WEB HOST</p>
        </a></li>
      <li><a href="/services/webhosting/sites.asp">成品网站超市
        <p>AUTO SITE</p>
        </a>
        
      </li>
      <li><a href="/services/vpsserver/">VPS主机
        <p>VPS SERVER</p>
        </a></li>
      <li><a href="/services/webhosting/sitebuild.asp">网站建设
        <p>SITE BUILD</p>
        </a> </li>
      <li><a href="/services/cloudhost/">云主机
        <p>SERVER</p>
        </a>
        <div class="main_menu_new_ico"><img src="/Template/Tpl_05/newimages/default/icon_new_24x18.gif" width="24" height="18" /></div>
         </li>
      <li><a href="/services/webhosting/twhost.asp">海外主机
        <p>TAIWAN HOST</p>
        </a></li>
      <li><a href="/services/mail/">企业邮局
        <p>MAIL</p>
        </a></li>
      <li><a href="/agent/">代理专区
        <p>AGENT</p>
        </a></li>
      <li><a href="/customercenter/">客服中心
        <p>SERVICE</p>
        </a></li>
    </ul>
  </DIV>
  <DIV id="menu_bottom">
    <ul id="menu_bottom_list">
      <li home="y">欢迎光临<%=companyname%>，我们将竭诚为您提供最优质的服务！</li>
      <li><a href="/services/domain/">英文域名</a> <a href="/services/domain/defaultcn.asp">中文域名</a> <a href="/services/domain/dns.asp">DNS管理</a>  <a href="/services/domain/transfer.asp">域名转入</a></li>
      <li> <a href="/services/webhosting/hostlist.asp">集群主机</a> <a href="/services/webhosting/twolinevhost.asp">双线主机</a> <a href="/services/webhosting/basic.asp">基本主机</a> <a href="/services/webhosting/twhost.asp">港台主机</a>  <a href="/services/webhosting/linux_host.asp">Linux主机</a> <a href="/services/webhosting/superg.asp">超G型主机</a> <a href="/services/webhosting/asp_net.asp">ASP.net主机</a> <a href="/services/webhosting/java.asp">Java主机</a> <a href="/services/webhosting/StoreHost.asp">网店主机</a> <a href="/services/webhosting/usa.asp">美国主机</a> <a href="/services/webhosting/database.asp">数据库</a> </li>
      <li><a href="/services/webhosting/sites.asp">成品网站超市</a> 
      </li>
      <li><a href="/services/vpsserver/">集群VPS主机</a> <a href="/services/vpsserver/">国内VPS主机</a> <!-- <a href="/services/vpsserver/twvps.asp">台湾VPS主机</a>--> </li>
      <li><a href="/services/webhosting/sitebuild.asp">网站建设</a> <a href="/services/search/">网站推广</a> <a href="/services/webhosting/seo.asp">网站优化</a></li>
      <li><a href="/services/server/default.asp">服务器租用</a> <a href="/services/trusteehost/default.asp">主机托管</a> </li>
      <li><a href="/services/webhosting/twhost.asp">港台主机</a> <a href="/services/webhosting/usa.asp">美国主机</a></li>
      <li><a href="/services/mail/default.asp">绿色G邮</a> <a href="/services/mail/default.asp">绿色M邮</a> <a href="/services/mail/default.asp">超值邮</a> <a href="/services/mail/default.asp">海外邮局</a></li>
      <li><a href="/agent/liuchen.asp">步骤流程</a> <a href="/agent/level.asp">代理级别</a> <a href="/agent/default.asp">代理模式</a> <a href="/agent/youshi.asp">代理优势</a> <a href="/agent/apply.asp">在线申请</a></li>
      <li><a href="/faq">常见问题</a> 
      <a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp">有问必答</a> 
      <a href="/manager/question/allquestion.asp?module=search&amp;qtype=myall">跟踪提问</a> 
      <a href="/customercenter/buystep.asp">购买流程</a> 
      <a href="/customercenter/howpay.asp">付款方式</a> 
      <a href="http://beian.vhostgo.com" target="_blank">网站备案</a> 
      <a href="/customercenter/renew.asp">续租服务</a> 
      <a href="/manager/useraccount/payend.asp">汇款确认</a> 
      <a href="/customercenter/file.asp">相关文档</a> 
      <a href="/aboutus/contact.asp">联系我们</a>
      <a href="/agent/youshi.asp">代理优势</a> 
      <a href="/agent/level.asp">代理级别</a>
      <a href="/customercenter/productprice.asp">产品价格</a>
      </li>
    </ul>
  </DIV>
</DIV>
  <script language=javascript src="/Template/Tpl_05/jscripts/menu.js"></script> 