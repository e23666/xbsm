var freepro="";
$(function(){
 freepro=$("input[name='freeid']:hidden").val();
 var os=$("select[name='dbversion']").val();
 var proid=$("input[name='productid']:hidden").val();
 var newsize=proid.toLowerCase().replace("mssql","");
	$("select[name='room']").change(function(){
		getver()
	})


getver()



})

function getver()
{
	 roomid=$("select[name='room']").val();
 
	if(freepro=="")
	{
	$.post("buy.asp","module=ver&roomid="+roomid,function(d){
	   if(d!="err")
	   {
		  temp=d.split(",");
		  verobj=$("select[name='dbversion']");
		  verobj.empty();
		  tempstr="<option value=''>��ѡ�����ݿ�汾</option>";
		  for(var i=0;i<temp.length;i++)
		  {
		    tempstr+="<option value='"+temp[i]+"'>MSSQL "+temp[i]+"</option>"
		  }
		 
		  verobj.append(tempstr);
	   }
	})
	}else
	{

		 temp="2000,2005,2008,2012".split(",");
		  verobj=$("select[name='dbversion']");
		  verobj.empty();
		  tempstr="<option value=''>��ѡ�����ݿ�汾</option>";
		  for(var i=0;i<temp.length;i++)
		  {
		    tempstr+="<option value='"+temp[i]+"'>MSSQL "+temp[i]+"</option>"
		  }
		 
		  verobj.append(tempstr);
	}
}
function getroom(){
	   if(freepro==""){
		   pro=$("input[name='productid']:hidden").val();
		   $.post("buy.asp","module=getroomlist&Productid="+pro+"",function(data){
		   $("#setroomlist").html(data)
		   })
		   getprice()
	   }else{
	   
	   }
}


function getprice(){
       pro=$("input[name='productid']:hidden").val();
	   $.post("buy.asp","module=getprice&Productid="+pro+"",function(data){
	   
	   $("#showprice").html(data)
	   })
}

function shopcheck()
{
    bString="abcdefghijklmnopqrstuvwxyz0123456789";
    var freepro=$("input[name='freeid']:hidden");

	if(document.form1.dbversion.value=="")
	{
		alert("��ѡ��Mssql�İ汾,һ��ȷ�ϲ��ɸ�����������ѡ��")
		document.form1.dbversion.focus();
		return false;
	}


    if(document.form1.dbname.value.length <3 || document.form1.dbname.value.length > 16)
		{
			alert("\n\n���ݿ���������3-16λ����ĸ�����ֻ����ϡ�");
			document.form1.dbname.focus();
			return false;
		}
 
	 for (ii = 0;ii<document.form1.dbname.value.length; ii ++)
	 {

		if (bString.indexOf(document.form1.dbname.value.substring(ii,ii+1))==-1)
		{
			alert("\n\n���ݿ�����������ĸ�����ֵĻ����ϡ���");
			document.form1.dbname.focus();
			return false;
		}

     }

	if (document.form1.dbpasswd.value=="")
	{
		alert ("\n\n�����������ݿ����룡");
		document.form1.dbpasswd.focus();
		return false;
	}
	if ( document.form1.dbpasswd.value.length < 5)
	{
		alert("\n\n������������5λ");
		document.form1.dbpasswd.focus();
		return false;
	}

	

	return true;
}
function checkneedprice(username,productid,years,form){

	var url='buy.asp?str=checkprice';
	var sinfo='myyears='+years+'&username='+username+'&productid='+productid;
	var divID='newDiv';
	if (!isNaN(years)){
	makeRequestPost(url,sinfo,divID);
	}
}
function chechftpname(mailname){
		var url='buy.asp?module=checkdbname';
		var sinfo='dbname='+mailname;
		var divID='checkdiv';
		document.getElementById('checkdiv').style.display='';
		makeRequestPost1(url,sinfo,divID);
	}
 
