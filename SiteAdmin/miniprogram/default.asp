<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/class/Page_Class.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%Check_Is_Master(6)
response.Charset="gb2312"
response.Buffer=true
conn.open constr
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>С�������</title>
<script type="text/javascript" src="/jscripts/check.js"></script>
<script type="text/javascript" src="/jscripts/dateinput.min.js"></script>
<link href="/jscripts/dateinput.min.css" rel="stylesheet">
<link href="../css/Admin_Style.css" rel="stylesheet">  
<script type="text/javascript" src="/template/Tpl_2016/jscripts/lhgdialognew.min.js?skin=agent&self=true"></script>
<script type="text/javascript" src="/noedit/template.js"></script>
<script type="text/javascript">
$(function(){
	var fs=document.frmsearch;
	$("#datalist tbody tr:odd").addClass("ghbg");
	$("input[name=startime],input[name=overtime]").dateinput({
		format: 'yyyy-mm-dd',selectors: true,speed: '',	firstDay: 0
	}).addClass("inputbox");
	 
	

});	 
function getcheckval(nm){
	var chk_value =[];    
	var obj=$("input[name='" + nm + "']:checkbox:checked").each(function(){    
		chk_value.push($(this).val());    
	});
	return chk_value;
}
function selectItem(nm){
	$(':checkbox[name=' + nm + ']').each(function(){
		this.checked= !this.checked;
	})
}


function buysms(id)
	{
		 

		buybox=$.dialog({
			title:"���Ź���",
				content:template("tpl_buysms",{id:id}),
				width:"500px",
				height:"240px",
			})

			$("input[name='numtype']").on("click",function(){
				$("#buysmscount").attr("disabled","disabled")
				if($(this).val()=="-1"){
					$("#buysmscount").removeAttr("disabled")
				}
			})
		$.post("load.asp",{act:"getsmscount",appid:id},function(data){
			$("#msgcount").text(data.count);		
		},"json")
		
	}

	function myapppwd(id){
		$.post("load.asp",{appid:id,act:"getpwd"},function(data){ 
			buybox=$.dialog({
			title:"APP��½�������",
				content:template("tpl_getapppwd",{id:id,password:data.password}),
				width:"300px",
				height:"140px",
				id:"getpwdbox"
			})  
		},"json")
	}
	function del(id){
		$.dialog.confirm("��ȷ��Ҫɾ��",function(){
			$.post("load.asp",{appid:id,act:"del"},function(data){ 
				 $.dialog.tips(data.msg)
		},"json")
		
		})
	}

	function ywgh(){
		var gh_u_name=$("input[name='gh_u_name']").val();
		var appid=[];
		$.each($("input[name='appid']:checked"),function(i){
				appid.push($(this).val());
		})
		if(appid.length==0){
			$.dialog.alert("����ѡ��Ҫ������С����");
			return false;
		}

		$.dialog.confirm("��ȷ��Ҫ��ѡ�����ݹ�����["+gh_u_name+"]?",function(){
				$.ajax({
					type: "POST",
					url: "load.asp",
					data: {act:"guohu",appids:appid.join(","),gh_u_name:gh_u_name},
					dataType: "json",
					success: function (response) {
						$.dialog.alert(response.msg);
					},
					error:function (a,b,c) {
						$.dialog.alert("������"+a+b+c);
					  }
				});
			 

		})

	}

</script>
<style type="text/css">
a.ftpname:link,a.ftpname:visited{
	color:#ff6600;
	font-size:12px;
	font-family: Verdana, Microsoft YaHei, Arial, Helvetica, sans-serif;
}
a.ftpname:hover{text-decoration:underline;color:#000;}
#datalist tbody td{text-align:center}
#datalist tbody td div{text-align:left;}
#datalist tbody tr:hover{color:#00F}
#datalist thead th{
	font-size:12px;
	height:25px;
	color:#fff;
}
#datalist .Title img{cursor:pointer}
a.focus:link,a.focus:visited{background:#B0D8FF}
.black{color:#000000;}
.ghbg{background-color:#EAF5FC}
.bred{color:red;font-weight:bold;}


.manager-table {
	margin-top:15px;
	text-align:center;
	border:1px solid #ececec
}
.fixed-table {
	table-layout:fixed
}
.manager-table tr {
	height:50px
}
.manager-table tr:hover {
	background-color:#f7f7f7
}
.manager-table thead tr {
}.manager-table tr th {
	 background:#f3f3f3;
	 border-bottom:1px solid #ececec;
	 border-top:1px solid #ececec;
	 font-size:14px;
	 font-weight:700;
	 color:#3e3e3e
 }
.manager-table tr td {
	border:1px solid #ececec;
	font-size:14px;
	color:#4e4e4e;
	padding:8px;
	word-break:break-all
}
.manager-table tr td.text-overflow {
	text-overflow:ellipsis;
	overflow:hidden;
	white-space:nowrap
}
</style>

<body style="padding:0 5px;">
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='0' style="margin:1px 0">
  <tr class='topbg'>
    <th height="25" style="font-weight:bold;font-size:14px;">΢��С�������</th>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td ><strong>��������</strong><a href="default.asp"> ΢��С�������</a>  | <a href="syn.asp">ͬ��</a> </td>
  </tr>
</table>
<br />
<% 
sqlArray=Array("u_name,��Ա�ʺ�,str","appID,APPID,int","appName,APP����,str","buyDate,��ͨ����,date","expireDate,��������,date","p_name,��Ʒ��,str")
newsql=searchEnd(searchItem,condition,searchValue,othercode)

sqlstring="select a.*,b.u_name from wx_miniprogram_app as a inner join userdetail as b on a.userid=b.u_id where datediff("&PE_DatePart_D&",a.expireDate,"&PE_Now&")<30  "& newsql & " order by id desc" 
 
rs.open sqlstring,conn,1,1
setsize=20
cur=1
pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)

%>

	<form action="" method="get" id="managerform" target="_blank"></form>
				 <form name="form1" action="<%=request("script_name")%>" method="post">
					 <%=searchlist%>
				 </form>

				<table width="100%" border="0" cellpadding="2" cellspacing="1" class="border" id="datalist">
        <thead>

					<tr class="Title">
            <th><input type="checkbox"  onclick="selectItem('appid')"></th>
						<th>APPID</th>
						<th>С��������</th>
						<th>�ͺ�</th>
            <th>��Ա�ʺ�</th>
						<th>��ͨʱ��</th>
						<th>����ʱ��</th>
						<th>״̬</th>
						<th>����</th>
					</tr>
          </thead>
              <tbody>
					<%Do While Not rs.eof and cur<=setsize
               		  		tdcolor="#ffffff"
               				if cur mod 2=0 then tdcolor="#efefef"
               		  %>
					  <tr>
           				<td height="25">
							<input type="checkbox" name="appid" value="<%=rs("appid")%>" />
						</td>
						 <td><%=rs("appid")%></td>
						 <td align="left"> <%=rs("appname")%><br><span id="remark_bak_<%=rs("appid")%>" class="hui333"><%=rs("bakAppName")%></span></td>
						 <td><%=rs("proid")%></td>
             			 <td><%=rs("u_name")%></td>
						 <td><%=rs("buyDate")%></td>
						 <td><%=rs("expireDate")%></td>
						 <td><%=rs("paytype")%></td>
						 <td> 
							<a href="load.asp?appid=<%=rs("appid")%>&act=getmanager" target="_blank" class="mt-btn" >����</a>
							<a href="javascript:;" class="mt-btn" onclick="myapppwd(<%=rs("appid")%>)">����</a> 
							<a href="javascript:;"  class="mt-btn" onclick="del(<%=rs("appid")%>)" >ɾ�� </a>
						 </td>
					  </tr>					 
					 <%rs.movenext
               		   cur=cur+1
               		  loop %>
			 		 
					<tbody>
				 </table>
				 <div style="marign:10px;line-height:35px;">��ѡ��ҵ���ƶ���:<input name="gh_u_name" id="gh_u_name"><input type="button" value="ȷ������" onclick="ywgh()"></div>
        <div class="pagenav"><center><%=pagenumlist%></center></div>
</body>
</html>



<script type="text/html" id="tpl_getapppwd">
	<div style="width:350px;height:160px;">
	<table  width="100%"  border="0" cellpadding="2" cellspacing="1" class="manager-table" >
		<tr><th colspan=2 class="Title"   align="center">�������</th></tr>
		<tr>
			<th class="Title" >APPID</th>
			<td align="left" id="myapppasswordbox">{{appid}}</td>
		</tr>
		<tr >
			<th class="Title" >��½����</th>
			<td align="left" id="myapppasswordbox">{{password}}</td>
		</tr>
		 
	</table>
	</div>
</script>

<script id="tpl_buyapp" type="text/html">
	<div style="width:700px;">
	�¼ӹ���:
	<select id="addnewproductid" class="manager-select s-select">
		{{each datas as item index}} 
			{{if item.isbuy=="0" && item.proid!=""}}
				<option value="{{item.id}}" data-name="{{item.name}}"  data-price="{{item.price}}">{{item.name}}</option> 
			{{/if}}
		{{/each}}
	<select>
	��������:
				<select id="addnewyear" class="manager-select s-select">
				<option value="1" selected>1��</option>
				<option value="2">2��</option>
				<option value="3">3��</option>
			</select> 
	����ʽ:<select id="addnewpaytype" class="manager-select s-select">
				<option value="1">����</option>
				<option value="0">��ʽ</option>
			 <select>
	<input type="button" class="manager-btn  mr-10" value="ȷ������" onclick="surebuyapp('{{id}}',this)">
	<input type="button" value="ȡ��"  class="manager-btn  mr-10" onclick="buybox.close()">
	<table class="manager-table" style="width:100%" id="myapptableinfo">
		<tr><th colspan=6>�ѿ�ͨ�����б�</th></tr>
		<tr>
			<th>��Ʒ���</th>
			<th>��������</th>
			<th>�ײͰ���</th>
			<th>��Ʒ�۸�</th>
			<th>����ʱ��</th>
			<th>����</th>
			
		</tr>
		{{each datas as item index}} 
			{{if item.isbuy=="1"}}
				<tr>
					<td>{{item.id}}</td>
					<td>{{item.name}}</td>
					<td>{{if item.isdefault=="1"}}<font color=green>��</font>{{else}}<font color=red>��</font>{{/if}}</td>
					<td style="color:red">&yen; {{item.price}}</td>
					<td>{{item.expiredate}}</td>
					<td>
						{{if item.isdefault=="1"}}
							-				
						{{else}}
							<input type="button" class="manager-btn  mr-10" value="����/����" onclick="renewonlyapp('{{item.id}}','{{id}}','{{item.price}}')">
						{{/if}}
					</td>


					
				</tr>
			{{/if}}
		{{/each}}
	</table>

	</div>
</script>