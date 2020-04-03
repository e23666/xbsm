//by west263.com (sjwxl)
function getLeft(e){
var offset=e.offsetLeft;
if(e.offsetParent!=null) offset+=getLeft(e.offsetParent);
return offset;
}

function menushow(defaultid){
	var selectedId=defaultid;
	var count=0;
	var menulist=[];
	
	return function(mainMenu,subMenu){
		menulist.push([mainMenu,subMenu]);
		if (count==defaultid){
			menuset(mainMenu,'on');
			subMenuset(subMenu,mainMenu);
			}
		if (window.attachEvent){
			mainMenu.attachEvent('onmouseover',eventHandler(count));
			
		}else{
			mainMenu.addEventListener('mouseover',eventHandler(count),false);
			
		}
		count++;
	}

	function eventHandler(menuid){
		return function(){
			//还原原来的菜单状态
			ori_obj=menulist[selectedId][0];
			ori_sub_obj=menulist[selectedId][1];
			menuset(ori_obj,'off');
			ori_sub_obj.style.display='none';

			//选中当前状态

			cur_obj=menulist[menuid][0];
			cur_sub_obj=menulist[menuid][1];

			menuset(cur_obj,'on');
			subMenuset(cur_sub_obj,cur_obj);
			
			selectedId=menuid;
			
		}
	}

	function menuset(menuobj,flg){
			var tagA=menuobj.getElementsByTagName("a")[0];
			var tagP=tagA.getElementsByTagName("p")[0];
			if (flg=='on'){
				menuobj.className='act_menu';
				tagA.className=tagP.className='pcolor';
			}else{
				menuobj.className=tagA.className=tagP.className='';
			}
		}

	function subMenuset(subObj,refObj){
			subObj.style.display='inline';
			//var refLeft=refObj.offsetLeft;
			var refWidth=subObj.parentNode.scrollWidth;
			var subWidth=subObj.offsetWidth;
			var dx=15;
			var basepos=getLeft(subObj.parentNode);
			var ppos=getLeft(refObj)

//alert('ppos:'+ppos+',refLeft:'+refLeft+',basepos:'+basepos);
			//refLeft=(ppos+refLeft)-basepos;


			refLeft=ppos-basepos;
			refLeft=refLeft<0?0:refLeft;

			xx=refWidth-refLeft-dx-subWidth;
			if (xx<=0){
					pxLeft=refLeft-dx*2+xx;
					pxLeft=pxLeft<0?0:pxLeft;
				}
			else{
				if (subObj.getAttribute("home")=="y")
					pxLeft=30;
				else
					pxLeft=refLeft-dx;
				}
				//alert('refleft:'+refLeft+',left:'+pxLeft);
			subObj.style.left=pxLeft+'px';

	}
}

function init_menu(){

	pageUrl=document.URL.toLowerCase();

	if (pageUrl.indexOf("/domain")>=0)
		dftMenu=1;
	else if (pageUrl.indexOf("/webhosting/sites")>=0)
		dftMenu=3;
	else if (pageUrl.indexOf("/services/webhosting/twhost.asp")>=0 || pageUrl.indexOf("/services/webhosting/usa.asp")>=0)
		dftMenu=7;
	else if (pageUrl.indexOf("/services/webhosting/sitebuild.asp")>=0 || pageUrl.indexOf("/services/search/")>=0 || pageUrl.indexOf("/services/webhosting/seo.asp")>=0)
		dftMenu=5;
	else if (pageUrl.indexOf("/webhosting")>=0)
		dftMenu=2;
	else if (pageUrl.indexOf("/diysite")>=0)
		dftMenu=3;
	else if (pageUrl.indexOf("/server")>=0 || pageUrl.indexOf("/services/cloudhost/")>=0)
		dftMenu=6;
	else if (pageUrl.indexOf("/vpsserver")>=0)
		dftMenu=4;
	else if (pageUrl.indexOf("/trusteehost")>=0 || pageUrl.indexOf("/server")>=0)
		dftMenu=6;
	else if (pageUrl.indexOf("/mail")>=0)
		dftMenu=8;
	else if (pageUrl.indexOf("/agent")>=0)
		dftMenu=9;
	else if (pageUrl.indexOf("/application")>=0)
		dftMenu=9;
	else if (pageUrl.indexOf("/customercenter")>=0 || pageUrl.indexOf("/faq")>=0)
		dftMenu=10;
	else
		dftMenu=0;

	var menu_obj=menushow(dftMenu);
	menus=document.getElementById("menu_top_list").getElementsByTagName("li");
	submenus=document.getElementById("menu_bottom_list").getElementsByTagName("li");
	for (k=0;k<menus.length;k++){
		menu_obj(menus[k],submenus[k]);
	}
}
init_menu();