<SCRIPT type=text/javascript>              
var waitting = 1;              
var secondLeft = waitting;              
var timer;                              
var sourceObj;              
var number;              
function getObject(objectId)//��ȡid�ĺ���               
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
function SetTimer()//������ʱ���ӳٵĺ���              
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
function CheckTime()//����ʱ���ӳٺ�              
    {              
        secondLeft--;              
        if ( secondLeft == 0 )              
        {              
        clearInterval(timer);                                      
        SetTimer();                      
        }              
    }              
function showM(thisobj,Num)//��������껬������,��ʱ���ӳ�              
    {              
        number = Num;              
        sourceObj = thisobj;              
        secondLeft = 1;              
        timer = setTimeout('CheckTime()',100);              
    }              
function OnMouseLeft()//����������Ƴ�����,���ʱ�亯��              
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
          <li id="tel">���ȵĻ�����Ӧ�÷����ṩ��</li>
          <li><img src="/Template/Tpl_05/newimages/tabicons_122.gif" width=12 height=12>&nbsp;<a href="/bagshow/">���ﳵ</a></li>
          <li><img src="/Template/Tpl_05/newimages/tabicons_122.gif" width=12 height=12>&nbsp;<a href="/customercenter/buystep.asp">��������</a></li>
          <li><img src="/Template/Tpl_05/newimages/tabicons_122.gif" width=12 height=12>&nbsp;<a href="/customercenter/howpay.asp">���ʽ</a></li>
          <li><img src="/Template/Tpl_05/newimages/tabicons_122.gif" width=12 height=12>&nbsp;<a href="/faq">��������</a></li>
          <li><img src="/Template/Tpl_05/newimages/tabicons_122.gif" width=12 height=12>&nbsp;<a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp">��������</a></li>         
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
          <div id="lblManager"><a href="<%=managerurl%>" class="Link_Blue">[��������]</a> </div>
          <div id="LogLevelName"> ���ļ�����:<span class="redColor"><%=session("u_level")%></span> </div>
          <div id="LoginUnameOk"> ����:<span class="OrangeText"><%=session("user_name")%> </span></div>
        </div>
      </div>
      <%else%>
      	  <script language="JavaScript">
	  function checkLogin()
	  {
	  	if(myform.u_name.value=="")
		{
			alert("�û�������Ϊ�գ�");
			myform.u_name.focus();
			return false;
		}
	  	if(myform.u_password.value=="")
		{
			alert("���벻��Ϊ�գ�");
			myform.u_password.focus();
			return false;
		}
	  }
	  </script>
	  <div id="TitleLogin">
        <form name="myform" action="/chklogin.asp" method="post" onSubmit="return checkLogin()">
          <div id="LoginUname"> �û���:
            <input name="u_name" type="text" class="inputbox" value="" size="16">
          </div>
          <div id="LoginPass"> �ܡ���:
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
      <li><a href="/">�� ҳ
        <p>HOME</p>
        </a></li>
      <li><a href="/services/domain/">����ע��
        <p>DOMAIN</p>
        </a></li>
      <li><a href="/services/webhosting/">��������
        <p>WEB HOST</p>
        </a></li>
      <li><a href="/services/webhosting/sites.asp">��Ʒ��վ����
        <p>AUTO SITE</p>
        </a>
        
      </li>
      <li><a href="/services/vpsserver/">VPS����
        <p>VPS SERVER</p>
        </a></li>
      <li><a href="/services/webhosting/sitebuild.asp">��վ����
        <p>SITE BUILD</p>
        </a> </li>
      <li><a href="/services/cloudhost/">������
        <p>SERVER</p>
        </a>
        <div class="main_menu_new_ico"><img src="/Template/Tpl_05/newimages/default/icon_new_24x18.gif" width="24" height="18" /></div>
         </li>
      <li><a href="/services/webhosting/twhost.asp">��������
        <p>TAIWAN HOST</p>
        </a></li>
      <li><a href="/services/mail/">��ҵ�ʾ�
        <p>MAIL</p>
        </a></li>
      <li><a href="/agent/">����ר��
        <p>AGENT</p>
        </a></li>
      <li><a href="/customercenter/">�ͷ�����
        <p>SERVICE</p>
        </a></li>
    </ul>
  </DIV>
  <DIV id="menu_bottom">
    <ul id="menu_bottom_list">
      <li home="y">��ӭ����<%=companyname%>�����ǽ��߳�Ϊ���ṩ�����ʵķ���</li>
      <li><a href="/services/domain/">Ӣ������</a> <a href="/services/domain/defaultcn.asp">��������</a> <a href="/services/domain/dns.asp">DNS����</a>  <a href="/services/domain/transfer.asp">����ת��</a></li>
      <li> <a href="/services/webhosting/hostlist.asp">��Ⱥ����</a> <a href="/services/webhosting/twolinevhost.asp">˫������</a> <a href="/services/webhosting/basic.asp">��������</a> <a href="/services/webhosting/twhost.asp">��̨����</a>  <a href="/services/webhosting/linux_host.asp">Linux����</a> <a href="/services/webhosting/superg.asp">��G������</a> <a href="/services/webhosting/asp_net.asp">ASP.net����</a> <a href="/services/webhosting/java.asp">Java����</a> <a href="/services/webhosting/StoreHost.asp">��������</a> <a href="/services/webhosting/usa.asp">��������</a> <a href="/services/webhosting/database.asp">���ݿ�</a> </li>
      <li><a href="/services/webhosting/sites.asp">��Ʒ��վ����</a> 
      </li>
      <li><a href="/services/vpsserver/">��ȺVPS����</a> <a href="/services/vpsserver/">����VPS����</a> <!-- <a href="/services/vpsserver/twvps.asp">̨��VPS����</a>--> </li>
      <li><a href="/services/webhosting/sitebuild.asp">��վ����</a> <a href="/services/search/">��վ�ƹ�</a> <a href="/services/webhosting/seo.asp">��վ�Ż�</a></li>
      <li><a href="/services/server/default.asp">����������</a> <a href="/services/trusteehost/default.asp">�����й�</a> </li>
      <li><a href="/services/webhosting/twhost.asp">��̨����</a> <a href="/services/webhosting/usa.asp">��������</a></li>
      <li><a href="/services/mail/default.asp">��ɫG��</a> <a href="/services/mail/default.asp">��ɫM��</a> <a href="/services/mail/default.asp">��ֵ��</a> <a href="/services/mail/default.asp">�����ʾ�</a></li>
      <li><a href="/agent/liuchen.asp">��������</a> <a href="/agent/level.asp">������</a> <a href="/agent/default.asp">����ģʽ</a> <a href="/agent/youshi.asp">��������</a> <a href="/agent/apply.asp">��������</a></li>
      <li><a href="/faq">��������</a> 
      <a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp">���ʱش�</a> 
      <a href="/manager/question/allquestion.asp?module=search&amp;qtype=myall">��������</a> 
      <a href="/customercenter/buystep.asp">��������</a> 
      <a href="/customercenter/howpay.asp">���ʽ</a> 
      <a href="http://beian.vhostgo.com" target="_blank">��վ����</a> 
      <a href="/customercenter/renew.asp">�������</a> 
      <a href="/manager/useraccount/payend.asp">���ȷ��</a> 
      <a href="/customercenter/file.asp">����ĵ�</a> 
      <a href="/aboutus/contact.asp">��ϵ����</a>
      <a href="/agent/youshi.asp">��������</a> 
      <a href="/agent/level.asp">������</a>
      <a href="/customercenter/productprice.asp">��Ʒ�۸�</a>
      </li>
    </ul>
  </DIV>
</DIV>
  <script language=javascript src="/Template/Tpl_05/jscripts/menu.js"></script> 