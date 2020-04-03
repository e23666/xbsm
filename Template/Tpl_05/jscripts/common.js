function switchTab(objTab){
	f_id=objTab.parentNode.id;
	li_list=objTab.parentNode.getElementsByTagName("li");
	tagClass="tab_";
	tagIndex=-1;
	for (i=0;i<li_list.length;i++){
		if (li_list[i]==objTab)
		{
			tagIndex=i;
			break;
		}
	}
	if (tagIndex==-1)
		return;

	for (i=0;i<li_list.length;i++){

		if (i==0){
			z_tagClass=tagClass+"left_";
		}
		else if (i==li_list.length-1){
			z_tagClass=tagClass+"right_";
		}
		else{
			z_tagClass=tagClass+"center_";
		}

		objTag=li_list[i];
		objTagDiv=document.getElementById(f_id+"_"+(i+1));

		if (tagIndex==i){
			z_tagClass=z_tagClass+"on";
			round_class="round_on";
			objTagDiv.style.display='block';
		}else{
			z_tagClass=z_tagClass+"off";
			round_class="round_off";
			objTagDiv.style.display='none';
		}
		objTag.className=z_tagClass;
		if (objTag.getElementsByTagName("span").length>0)
			objTag.getElementsByTagName("span")[0].className=round_class;
	}
}

function scrollElement(eleid){
	ele=document.getElementById(eleid);
	eleDiv=ele.getElementsByTagName("ul")[0];
	eleClone=eleDiv.cloneNode(true);
	ele.appendChild(eleClone);
	flgStop=false;
	var scrollTop=0;
	ele.onmouseover=function(){
		flgStop=true;
	}
	ele.onmouseout=function(){
		flgStop=false;
	}

	this.startUp=function(){
		if (flgStop)
			return;
		scrollTop++;
		if (scrollTop>=eleClone.offsetHeight){
			scrollTop=0;
		}
		ele.scrollTop=scrollTop;
	}
	this.start=function(xname){
		var intval=setInterval(xname+".startUp();",50);		
	}
}

function switch_mail_Tab(objTab){
	f_id="mail_box_list_";
	li_list=objTab.parentNode.getElementsByTagName("li");
	tagClass="mail_tab_";
	tagIndex=-1;
	for (i=0;i<li_list.length;i++){
		if (li_list[i]==objTab)
		{
			tagIndex=i;
			break;
		}
	}
	if (tagIndex==-1)
		return;


	for (i=0;i<li_list.length;i++){
		
		z_tagClass=tagClass+"center_";
		objTagDiv=document.getElementById(f_id+(i+1));
		
		objTag=li_list[i];

		if (tagIndex==i){
			z_tagClass=z_tagClass+"on";
			objTagDiv.style.display='block';
		}else{
			z_tagClass=z_tagClass+"off";
			objTagDiv.style.display='none';
		}
		objTag.className=z_tagClass;
		
	}
}


function switchTab_domain(objTab){
	f_id=objTab.parentNode.id;
	li_list=objTab.parentNode.getElementsByTagName("li");
	tagClass="tab_";
	tagIndex=-1;
	for (i=0;i<li_list.length;i++){
		if (li_list[i]==objTab)
		{
			tagIndex=i;
			break;
		}
	}
	if (tagIndex==-1)
		return;

	for (i=0;i<li_list.length;i++){

		if (i==0){
			z_tagClass=tagClass+"left_domain_";
		}
		else if (i==li_list.length-1){
			z_tagClass=tagClass+"right_domain_";
		}
		else{
			z_tagClass=tagClass+"center_domain_";
		}

		objTag=li_list[i];
		objTagDiv=document.getElementById(f_id+"_"+(i+1));


		if (tagIndex==i){
			z_tagClass=z_tagClass+"on";
			//round_class="round_on";  
			objTagDiv.style.display='block';
		}else{
			z_tagClass=z_tagClass+"off";
			//round_class="round_off";
			objTagDiv.style.display='none';
		}
		objTag.className=z_tagClass;
//		if (objTag.getElementsByTagName("span").length>0)
//			objTag.getElementsByTagName("span")[0].className=round_class;
	}
}

