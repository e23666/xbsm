<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
conn.open constr
''''''''''''''''''''''sort''''''''''''''''''''''''''
act=requesta("act")
if act="" then act="setg"
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-域名分组管理</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language="javascript">
function dosort(v){
 	if(v!=''){
		var sorttype="<%=request("sorttype")%>";
		if (sorttype=="") sorttype="desc";
		if (sorttype=="desc")
			sorttype="asc";
		else if(sorttype=="asc") 
			sorttype="desc";
     	document.form1.action="<%=request("script_name")%>?pageNo=<%=Requesta("pageNo")%>&sorttype="+ sorttype +"&sorts="+ v ;
		document.form1.submit();
	  }
}
</script>
<style>
 .tab_menu{ border-bottom:1px solid #ccc; line-height:35px; height:30px;}
 .tab_menu li{ float:left; margin:0 10px; border:1px solid #dbdbdb; border-bottom:none; line-height:30px; height:30px; padding:0 10px; cursor:pointer;}
 .tab_menu li.hover{ background-color:#efefef;  font-weight: 700  }
.clearfix {
display: block;
}
.fzb{border:1px #dbdbdb solid; margin:10px; padding:5px;}
.molddiv {
float: left;
width: auto;
border: 1px solid #ccc;
padding: 2px 0 2px 5px;
margin: 2px;
}
.sbox{border:1px #dbdbdb solid; margin:10px; padding:5px;}
.table{ border-top:1px #dbdbdb solid; border-left:1px #dbdbdb solid; width:100%;}
.table td{border-right:1px #dbdbdb solid; border-bottom:1px #dbdbdb solid; padding:5px;}
		</style>
		<script>

$(function(){
    $("input[name='group_addbutton']").click(function(){
	    val=$(this).val();
		g_name=$("input[name='g_name']");
		g_id=$("input[name='g_id']");
        g_id_v=g_id.val();
		if(isNaN(g_id_v))
		{
		g_id.val(0)
		}
	    if(val=="添加")
		{
		   if(g_name.val()==="" || g_id.val()>0 || g_id.val()==="")
		   {
		     alert("分组名不能为空！");
			 g_name.focus();
			 return false;
		   }
           url="groupAction.asp?act=addDomain&g_name="+escape(g_name.val())+"&g_id="+g_id.val();
		   $.get(url,"",function(date){
		       if(date==="200 ok")
			   {
			      $(".fzb").find("#glist").append("<div class=\"molddiv\" id=\""+g_name.val()+"\"><span style=\"cursor:pointer\" onclick=\"javascript:void(0)\">"+g_name.val()+"</span>&nbsp;&nbsp;<img name=\"delmoldbutton\" src=\"/newimages/web_icon_009.gif\" style=\"cursor:pointer\" onclick=\"javascript:delGroup('"+g_name.val()+"',this)\"></div>")
				  g_name.val('');
			   }else
			   {
			   alert(date);
			   return false;
			   }
		       
		   })
		}
	})
	
<%if act="setv" then%>
	inittable();
<%end if%>
 
})


function delGroup(g_name,obj)
{

   if(confirm("您确定要删除【"+g_name+"】"))
   {
   
     url="groupAction.asp?act=delDomain&g_name="+escape(g_name);
	  $.get(url,"",function(date){
	      if(date==="200 ok")
		  {
		    $("#"+g_name).remove();
		    alert("删除成功!")
			return false;
		  }else{
		    alert(date)
		  }
	  
	  })
     // alert("ok")
   }
}
function checkALL(obj)
{
     $("input[name='d_id']").attr("checked",obj.checked); 
}
function gotodomain()
{
   obj=$("input[name='d_id']:checkbox");
   g_name=$("select[name='goto_gid'] option:selected").text();
   g_id=$("select[name='goto_gid'] option:selected").val();
   strarray=""
   for(var i=0;i<obj.length;i++)
   {
	  
	  if(obj[i].checked)
	  {
		  
		  if(strarray==="") 
		  {
			 strarray=obj[i].value;			 
		  }
		  else
		  {
		     strarray+=","+obj[i].value;			    
		  }
	  }
   }
    
   if(strarray!="")
   {
	  if(confirm("您确定要将选择域名移到【"+g_name+"】分组下面"))
	   {
		    url="groupAction.asp?act=addgroupdomain&g_name="+escape(g_name)+"&g_id="+g_id+"&did="+strarray;
			 $.get(url,"",function(date){
				  if(date==="200 ok")
				  {
					alert("移动成功!");
					inittable();
					return false;
				  }else{
					alert(date)
				  }
			  
			  })
	   }
	}
	else
	{
		alert("未选择域名!");
		return false;
	}
   

}

<%
if act="setv" then
%>
function gettable(k,gid,p)
{
	
   	url="groupAction.asp?act=gettable&k="+escape(k)+"&g_id="+gid+"&page="+p+"&r="+Math.random();
			 $.get(url,"",function(date){
		      $(".domainlist").html(date)			  
			  })
}
function inittable()
{
	keyword=$("input[name='keyword']").val();
	g=$("select[name=gid]").val();
	gettable(keyword,g,1)
	//gettable(keyword,g,1)	
}
 
<%end if%>

		</script>
</HEAD>
<body>
  <!--#include virtual="/manager/top.asp" -->
 
  <div id="MainContentDIV">
	
	   
      <!--#include virtual="/manager/manageleft.asp" -->
	
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			   <li>域名管理</li>
			 </ul>
		  </div>
		  <ul class="manager-tab ">
          				<li <%if act="setg" then response.write("class=""liactive""")%>  ><a href="?act=setg">组名设置</a></li>
          				<li <%if act="setv" then response.write("class=""liactive""")%>  ><a href="?act=setv">业务分组</a></li>
          			  </ul>
		<div class="manager-right-bg">
		  <!--选项卡 开始-->



			   <%
		  select case trim(act)
		  case "setg"
		  setg
		  case "setv"
		  setv
		  end select

		  sub setg
		  %>
		  <div class="fzb">
		       <div id="glist">
				  <%
				  set d_rs=conn.execute("select * from groupUser where G_type=0 and G_UserID=" &  session("u_sysid"))
				  do while not d_rs.eof
				  %>
		 
<div class="molddiv" id="<%=d_rs("G_name")%>">
<span style="cursor:pointer" onclick="javascript:void(0)"><%=d_rs("G_name")%></span>&nbsp;&nbsp;<img name="delmoldbutton" src="/newimages/web_icon_009.gif" style="cursor:pointer" onclick="javascript:delGroup('<%=d_rs("G_name")%>',this)">
</div>



				  <%
				  d_rs.movenext
				  loop
				  %>
			   </div>
                <div style="clear:both; "></div>
				  <div class="clearfix mt-15">
				  <label class="title">新增组名:</label>
				  <label class="msg"><input type="text" name="g_name" class="manager-input s-input" maxlength="25"><input type="hidden" name="g_id" maxlength="25" value="0"></label>
				  <label class="msg"><input type="button" class="manager-btn s-btn" value="添加" name="group_addbutton"></label>
				  </div>
		  </div>
		  <%end sub
		  
		  sub setv
		  %>
          
		  
		      <div class="sbox">
				  关键字&nbsp;&nbsp;<INPUT TYPE="text" class="manager-input s-input" NAME="keyword"> 分组&nbsp;&nbsp;<select name="gid" class="manager-select s-select">
				  <option value="-1">未分配</option>
				  <%
				   sql="select  * from groupUser where   G_UserID=" &  session("u_sysid")&" and G_Type=0"
				   set grs=conn.execute(sql)
				   isdb=false
				   do while not grs.eof
				   isdb=true
				   %>
				   <option value="<%=grs("gid")%>"><%=grs("g_name")%></option>
				   <%
				   grs.movenext
				   loop
				   %>
				  </select>
				  <INPUT TYPE="button" value="搜索" class="manager-btn s-btn" onclick="inittable()">
			  
			  </div>
		   <div class="domainlist">
              
		

		   </div>
           
           <div class="mt-20">将以上选中域名归到&nbsp;&nbsp;<SELECT NAME="goto_gid" class="manager-select s-select">
                 <option value=0>未分配</option>
				  <%
				  if isdb then
				   grs.movefirst
				  end if
				   do while not grs.eof
				   %>
				   <option value="<%=grs("gid")%>"><%=grs("g_name")%></option>
				   <%
				   grs.movenext
				   loop
				   %>
				  </SELECT>
                  
                  <input  value="确定移动" class="manager-btn s-btn" type="button" onclick="gotodomain()"/>
                  </div>

		  <%
		  end sub
		  %>
     
        </div>

		 </div>


 
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>