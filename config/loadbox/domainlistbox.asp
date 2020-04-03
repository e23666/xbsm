<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>域名选择</title>
</head>
<body>
	<form name="frmsearch" method="post">
		<style type="text/css">
		ul.search_box{display:block; margin:5px auto; padding:5px;border:1px #ECECEC solid;font-family: Microsoft YaHei,Arial,Microsoft Yahei,"微软雅黑","宋体"}
		ul.search_box:after{content:"."; display:block; height:0; clear:both; visibility:hidden;}
		ul.search_box li.line input{ display:inline-block; margin:-2px 2px 2px 2px; padding:4px 5px; border:1px solid #ccc;vertical-align: middle; width:100px;}
		ul.search_box li.line input.minbox{ display:inline-block; margin:0 2px 2px 2px; padding:0; width:auto;}
		ul.search_box li.line select{ display:inline-block; margin:-2px 2px 2px 2px; padding:3px 0; border:1px solid #ccc;vertical-align: middle; width:112px;}
		ul.search_box li.line{display:block; margin:5px; padding:0; float:left;list-style:none; border:none;}
		ul.search_box li.line:after{content:"."; display:block; height:0; clear:both; visibility:hidden;}
		ul.search_box li.bottom {position:relative;display:block;text-align:center; padding:5px 0 2px 0; margin:5px auto 0 auto; border-top:1px solid #E5E5E5; clear:both; float:none }
		ul.search_box li .title {display:block;float:left; width:auto; font-size:14px; margin:0 2px; text-align:right; color:#000; vertical-align: middle; padding-top:4px;}
		ul.search_box li .msg {display:block;float:left; width:auto; font-size:14px; margin:0 2px; text-align:left; color:#000; vertical-align: middle;padding-top:4px }
		ul.search_box li.bottom .bluebtn{  color:#fff; font-size:14px; display:inline-block; height:30px; line-height:30px; text-align:center; border-radius:3px;background:#438ec7;color:#fff; padding:0 10px; min-width:60px; margin:5px; border:none}
		ul.search_box li.bottom .orangebtn{ color:#fff; font-size:14px; display:inline-block; height:30px; line-height:30px; text-align:center; border-radius:3px;background:#ff8a00;color:#fff;padding:0 10px; min-width:60px;margin:5px;border:none}
		ul.search_box li.bottom .graybtn{ color:#fff; font-size:14px; display:inline-block; height:30px; line-height:30px; text-align:center; border-radius:3px;background:#ddd;color: #666;padding:0 10px; min-width:60px;margin:5px;border:none}
		ul.search_box li.bottom .bluebtn:hover{ background:#4d9cd9;}
		ul.search_box li.bottom .orangebtn:hover{ background:#fb9926;}
		ul.search_box li.bottom .bluebtn:hover{ background:#4d9cd9;}
		ul.search_box li.bottom .graybtn:hover{background: #E5E5E5;}
		ul.search_box li.line input.dropdate{background:url(/newimages/Manager/045631164.gif) no-repeat 2px center; padding-left:20px; width:85px}
		</style>

		<ul class="search_box" style="width:740px">	
			<li class="line" style="clear:both">		
				<label class="title" style="width:120px">域名关键字：</label>
				<label class="msg"><input type="text" name="domkey"></label>		
				
				<label class="title" style="width:120px">我的分组:</label>
				<label class="msg">				
					<select name="groupid">
						<option value="-">不限分组</option>
					</select>
				</label>
				<label class="title" style="width:120px">全选：</label>
				<label class="msg"><input class="minbox" type="checkbox" name="alldombcheck" checked="">	</label> 
			</li> 
			<li class="bottom" undefined="">
				<input type="button" name="searchbtn" value="搜 索" class="orangebtn"><input type="reset" value="重置" class="graybtn">
			</li> 
		</ul>
		</form>
	



<form name="formdata" method="post">
 <style type="text/css">
ul.search_box{display:block; margin:5px auto; padding:5px;border:1px #ECECEC solid;font-family: Microsoft YaHei,Arial,Microsoft Yahei,"微软雅黑","宋体"}
ul.search_box:after{content:"."; display:block; height:0; clear:both; visibility:hidden;}
ul.search_box li.line input{ display:inline-block; margin:-2px 2px 2px 2px; padding:4px 5px; border:1px solid #ccc;vertical-align: middle; width:100px;}
ul.search_box li.line input.minbox{ display:inline-block; margin:0 2px 2px 2px; padding:0; width:auto;}
ul.search_box li.line select{ display:inline-block; margin:-2px 2px 2px 2px; padding:3px 0; border:1px solid #ccc;vertical-align: middle; width:112px;}
ul.search_box li.line{display:block; margin:5px; padding:0; float:left;list-style:none; border:none;}
ul.search_box li.line:after{content:"."; display:block; height:0; clear:both; visibility:hidden;}
ul.search_box li.bottom {position:relative;display:block;text-align:center; padding:5px 0 2px 0; margin:5px auto 0 auto; border-top:1px solid #E5E5E5; clear:both; float:none }
ul.search_box li .title {display:block;float:left; width:auto; font-size:14px; margin:0 2px; text-align:right; color:#000; vertical-align: middle; padding-top:4px;}
ul.search_box li .msg {display:block;float:left; width:auto; font-size:14px; margin:0 2px; text-align:left; color:#000; vertical-align: middle;padding-top:4px }
ul.search_box li.bottom .bluebtn{  color:#fff; font-size:14px; display:inline-block; height:30px; line-height:30px; text-align:center; border-radius:3px;background:#438ec7;color:#fff; padding:0 10px; min-width:60px; margin:5px; border:none}
ul.search_box li.bottom .orangebtn{ color:#fff; font-size:14px; display:inline-block; height:30px; line-height:30px; text-align:center; border-radius:3px;background:#ff8a00;color:#fff;padding:0 10px; min-width:60px;margin:5px;border:none}
ul.search_box li.bottom .graybtn{ color:#fff; font-size:14px; display:inline-block; height:30px; line-height:30px; text-align:center; border-radius:3px;background:#ddd;color: #666;padding:0 10px; min-width:60px;margin:5px;border:none}
ul.search_box li.bottom .bluebtn:hover{ background:#4d9cd9;}
ul.search_box li.bottom .orangebtn:hover{ background:#fb9926;}
ul.search_box li.bottom .bluebtn:hover{ background:#4d9cd9;}
ul.search_box li.bottom .graybtn:hover{background: #E5E5E5;}
ul.search_box li.line input.dropdate{background:url(/newimages/Manager/045631164.gif) no-repeat 2px center; padding-left:20px; width:85px}
</style>

<ul class="search_box" >
</ul>

</form>




</body> 

<script id="domboxload_tmp" type="text/html">
	<div style="text-align:center"><img src="/jscripts/layui/css/modules/layer/default/loading-0.gif"</div>
</script>

<script id="pagesize_tmp" type="text/html">
	<select name="pagesize">
			<option value="10">10条/页</option>
			<option value="20">20条/页</option>
			<option value="30">30条/页</option>
			<option value="50">50条/页</option>
			<option value="100" selected>100条/页</option>
			<option value="200">200条/页</option>
			<option value="300">300条/页</option>
			<option value="500">500条/页</option>
			<option value="1000">1000条/页</option>
	</select>
</script>
 

<script id="bodylist_tmp" type="text/html">
<style type="text/css">
ul.bodyline{display:block; margin:5px auto; padding:5px;border:1px #ccc solid; width:740px; max-height:240px; overflow:auto;font-family: Microsoft YaHei,Arial,Microsoft Yahei,"微软雅黑","宋体"}
ul.bodyline li.line{display:block; margin:2px; padding:0; float:left;list-style:none;}
ul.bodyline li.line:hover{ background-color:#efefef}
ul.bodyline li .title {display:block;float:left; width:auto; font-size:14px; margin:0 2px; text-align:right; color:#000; vertical-align: middle; padding-top:4px;}
ul.bodyline li .msg {display:block;float:left; width:170px; font-size:14px; margin:0 2px; text-align:left; color:#000; height:30px; line-height:30px;  overflow:hidden }
#pagejsonbox{width:740px; margin:0 auto; padding:0}
</style>
	<ul class="bodyline clearfix">
		{{if datalist.length>0}}
			{{each datalist}}
				<li class="line clearfix">
					<label class="msg">
						<input name="sysid"   title="{{$value.domain}}" type="checkbox" value="{{$value.did}}" checked>{{$value.domain}}
					</label>
				</li>
			{{/each}}
		{{else}}
			<li><div style="text-align:center; font-size:18px; color:#ccc;">无数据</div></li>
		{{/if}}
	</ul>	
	{{if datalist.length>0}}
	{{if pagelist}}
		{{include "pageloadmin_tmp" pagelist}}
	{{/if}}
	{{/if}}
</script>


<script id="pageloadbig_tmp" type="text/html">
<div id="pagejsonbox">	
	<div class="pageinfo">
	<select name="setpagesize" class="manager-select s-select">
			<option value="10">每页10条</option>
			<option value="20">每页20条</option>
			<option value="30">每页30条</option>
			<option value="50">每页50条</option>
			<option value="100">每页100条</option>
			<option value="200">每页200条</option>
			<option value="300">每页300条</option>
			<option value="500">每页500条</option>
			<option value="1000">每页1000条</option>
	</select>
	</div>
	<ul class="pagenavlist">
			{{if pageno>(1+midsize)}}
			{{if pageno>(2+midsize)}}					
			<li><a data-tagpgn="{{pageno-1}}">&lsaquo;</a></li>	
			{{/if}}
			<li><a data-tagpgn="1">1</a></li>	
				{{if pageno>(2+midsize)}}		
				<li><a data-tagpgn="{{for_first}}">..</a></li>
				{{/if}}
			{{/if}}
			{{each pg_first}}
			<li><a data-tagpgn="{{$value}}">{{$value}}</a></li>
			{{/each}}
			<li class="active"><a>{{pageno}}</a></li>
			{{each pg_last}}
			<li><a data-tagpgn="{{$value}}">{{$value}}</a></li>
			{{/each}}
			{{if pageno+midsize<pagecount}}
				{{if pageno+midsize<pagecount-1}}
				<li><a data-tagpgn="{{for_last}}">..</a></li>
				{{/if}}
			<li><a data-tagpgn="{{pagecount}}">{{pagecount}}</a></li>
			{{if pageno+midsize<pagecount-1}}
			<li><a data-tagpgn="{{pageno+1}}">&rsaquo;</a></li>
			{{/if}}
			{{/if}}			
	</ul>
	<div class="pageinfo"><input type="text" class="mintxt" value="{{pageno}}" name="topageno"><input type="button" class="minbtn" name="topagenobtn" value="GO"></div>
	<div class="pageinfo">共<span class="jcount">{{linecount}}</span>条 共{{pagecount}}页</div>
</div>
</script>
<script id="pageloadmin_tmp" type="text/html">
<div id="pagejsonbox">	
	<ul class="pagenavlist">
			{{if pageno>(1+midsize)}}
			{{if pageno>(2+midsize)}}					
			<li><a data-tagpgn="{{pageno-1}}">&lsaquo;</a></li>	
			{{/if}}
			<li><a data-tagpgn="1">1</a></li>	
				{{if pageno>(2+midsize)}}		
				<li><a data-tagpgn="{{for_first}}">..</a></li>
				{{/if}}
			{{/if}}
			{{each pg_first}}
			<li><a data-tagpgn="{{$value}}">{{$value}}</a></li>
			{{/each}}
			<li class="active"><a>{{pageno}}</a></li>
			{{each pg_last}}
			<li><a data-tagpgn="{{$value}}">{{$value}}</a></li>
			{{/each}}
			{{if pageno+midsize<pagecount}}
				{{if pageno+midsize<pagecount-1}}
				<li><a data-tagpgn="{{for_last}}">..</a></li>
				{{/if}}
			<li><a data-tagpgn="{{pagecount}}">{{pagecount}}</a></li>
			{{if pageno+midsize<pagecount-1}}
			<li><a data-tagpgn="{{pageno+1}}">&rsaquo;</a></li>
			{{/if}}
			{{/if}}			
	</ul>
	<div class="pageinfo"><input type="text" class="mintxt" value="{{pageno}}" name="topageno"><input type="button" class="minbtn" name="topagenobtn" value="GO"></div>
	<div class="pageinfo">共<span class="jcount">{{linecount}}</span>条 共{{pagecount}}页</div>
</div>
</script>
<script id="pageload_tmp" type="text/html">
<link href="/css/pageload.css" rel="stylesheet" type="text/css" />
<div id="pagejsonbox">
	<div class="pageinfo">共有<span class="jcount">{{linecount}}</span>条记录</div>
	<ul class="pagenavlist">
			{{if pageno>(1+midsize)}}
			{{if pageno>(2+midsize)}}					
			<li><a data-tagpgn="{{pageno-1}}">&lsaquo;</a></li>	
			{{/if}}
			<li><a data-tagpgn="1">1</a></li>	
				{{if pageno>(2+midsize)}}		
				<li><a data-tagpgn="{{for_first}}">..</a></li>
				{{/if}}
			{{/if}}
			{{each pg_first}}
			<li><a data-tagpgn="{{$value}}">{{$value}}</a></li>
			{{/each}}
			<li class="active"><a>{{pageno}}</a></li>
			{{each pg_last}}
			<li><a data-tagpgn="{{$value}}">{{$value}}</a></li>
			{{/each}}
			{{if pageno+midsize<pagecount}}
				{{if pageno+midsize<pagecount-1}}
				<li><a data-tagpgn="{{for_last}}">..</a></li>
				{{/if}}
			<li><a data-tagpgn="{{pagecount}}">{{pagecount}}</a></li>
			{{if pageno+midsize<pagecount-1}}
			<li><a data-tagpgn="{{pageno+1}}">&rsaquo;</a></li>
			{{/if}}
			{{/if}}		
	</ul>
</div>
</script>
<script id="pageload_m_tmp" type="text/html">
<link href="/css/pageload.css" rel="stylesheet" type="text/css" />
<div id="pagejsonbox">
	<div class="pageinfo">共有<span class="jcount">{{linecount}}</span>条记录</div>
	<ul class="pagenavlist">

			{{if pageno>1}}		
			<li><a data-tagpgn="1">&laquo;</a></li>	
			<li><a data-tagpgn="{{pageno-1}}">&lsaquo;</a></li>			
			{{/if}}
			<li class="active"><a>{{pageno}}</a></li>
			{{if pageno<pagecount}}
			<li><a data-tagpgn="{{pageno+1}}">&rsaquo;</a></li>
			<li><a data-tagpgn="{{pagecount}}">&raquo;</a></li>
			{{/if}}
		
	</ul>
</div>
</script>

<script id="pageload_tmp_en" type="text/html">
<link href="/css/pageload.css" rel="stylesheet" type="text/css" />
<div id="pagejsonbox">
	<div class="pageinfo">A total of <span class="jcount">{{linecount}}</span> records</div>
	<ul class="pagenavlist">
			{{if pageno>(1+midsize)}}
			{{if pageno>(2+midsize)}}					
			<li><a data-tagpgn="{{pageno-1}}">&lsaquo;</a></li>	
			{{/if}}
			<li><a data-tagpgn="1">1</a></li>	
				{{if pageno>(2+midsize)}}		
				<li><a data-tagpgn="{{for_first}}">..</a></li>
				{{/if}}
			{{/if}}
			{{each pg_first}}
			<li><a data-tagpgn="{{$value}}">{{$value}}</a></li>
			{{/each}}
			<li class="active"><a>{{pageno}}</a></li>
			{{each pg_last}}
			<li><a data-tagpgn="{{$value}}">{{$value}}</a></li>
			{{/each}}
			{{if pageno+midsize<pagecount}}
				{{if pageno+midsize<pagecount-1}}
				<li><a data-tagpgn="{{for_last}}">..</a></li>
				{{/if}}
			<li><a data-tagpgn="{{pagecount}}">{{pagecount}}</a></li>
			{{if pageno+midsize<pagecount-1}}
			<li><a data-tagpgn="{{pageno+1}}">&rsaquo;</a></li>
			{{/if}}
			{{/if}}		
	</ul>
</div>
</script>

</html>