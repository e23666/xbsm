var hkconfig=[{"name":"����","value":"0","data":[{"name":"��½���֤", "value":"OTHID"},{"name":"������֤","value":"HKID"},{"name":"���պ���","value":"PASSNO"},{"name":"����֤��","value":"BIRTHCERT"}]},{"name":"��ҵ", "value":"1", "data":[{"name":"Ӫҵִ��","value":"CI"},{"name":"��۹�˾�Ǽ�֤","value":"BR"}]}]
if(ishkdom=="True"){
    showhkdominput()
}

if(iszhdom=="True")
{
showzhdominput()
}
$(function(){
	 if(ishkdom=="True"){

     $("select[name='reg_contact_type']").change(function(){
	 sethkzj($(this).val());
	 })
	 sethkzj(0); 
	 
	 if(xz_reg_contact_type!="") {$("select[name='reg_contact_type']").val(xz_reg_contact_type);sethkzj(xz_reg_contact_type)}
	 if(xz_custom_reg2!="") {$("select[name='custom_reg2']").val(xz_custom_reg2);$("input[name='custom_reg1']").val(xz_custom_reg1);}
	 }

    if(iszhdom=="True")
	{
	 	 if(xz_dom_idtype!="") {$("select[name='dom_idtype']").val(xz_dom_idtype);}
		 if(xz_dom_idnum!="") {$("input[name='dom_idnum']").val(xz_dom_idnum);}
	}
	
})

function showhkdominput()
{
	
		if (ishkmb=="4")
		{
			document.write("<tr><td width=\"22%\" bgcolor=\"f7f7f7\">")
			document.write("<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"4\"><tr> ")
			document.write("<td align=\"right\"><strong>ע�������</strong></td></tr></table></td>")			
			document.write("<td width=\"38%\"><table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"4\"><tr> <td> ")			  
			document.write("<select name=\"reg_contact_type\">"+gethkconfig("")+"</select></td></tr></table>")					
			document.write("</td><td width=\"40%\">ע��HK��������д</td></tr><tr> <td colspan=\"3\" background=\"/template/Tpl_04/images/sens_mainbg2.gif\"><img src=\"/template/Tpl_04/images/sens_mainbg2.gif\" width=\"3\" height=\"1\"></td></tr>")
			
			document.write("<tr><td width=\"22%\" bgcolor=\"f7f7f7\">")
			document.write("<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"4\"><tr> ")
			document.write("<td align=\"right\"><strong>֤�����ͣ�</strong></td></tr></table></td>")			
			document.write("<td width=\"38%\"><table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"4\"><tr> <td> ")			  
			document.write("<select name=\"custom_reg2\"></select></td></tr></table>")					
			document.write("</td><td width=\"40%\">ע��HK��������д</td></tr><tr> <td colspan=\"3\" background=\"/template/Tpl_04/images/sens_mainbg2.gif\"><img src=\"/template/Tpl_04/images/sens_mainbg2.gif\" width=\"3\" height=\"1\"></td></tr>")

			document.write("<tr><td width=\"22%\" bgcolor=\"f7f7f7\">")
			document.write("<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"4\"><tr> ")
			document.write("<td align=\"right\"><strong>֤�����룺</strong></td></tr></table></td>")			
			document.write("<td width=\"38%\"><table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"4\"><tr> <td> ")			  
			document.write("<input name=\"custom_reg1\"  type=\"text\"  class=\"oldbg\" value=\"\" size=\"23\" maxlength=\"30\" ></td></tr></table>")					
			document.write("</td><td width=\"40%\">ע��HK��������д</td></tr><tr> <td colspan=\"3\" background=\"/template/Tpl_04/images/sens_mainbg2.gif\"><img src=\"/template/Tpl_04/images/sens_mainbg2.gif\" width=\"3\" height=\"1\"></td></tr>")
		}
		
		if(ishkmb=="5")
		{
			
			document.write("<dd><label>ע�������:</label> <h1>&nbsp;&nbsp;<select name=\"reg_contact_type\" datatype=\"*1-20\" id=\"reg_contact_type\" errormsg=\"ע��HK��������ѡ��ע�������\"  nullmsg=\"ע��HK��������ѡ��ע�������\">"+gethkconfig("")+"</select></h1> <h2><div class=\"Validform_checktip\"></div></h2></dd><dd><label>֤������:</label> <h1>&nbsp;&nbsp;<select name=\"custom_reg2\" datatype=\"*1-20\" id=\"reg_contact_type\" errormsg=\"ע��HK��������ѡ��֤������\"  nullmsg=\"ע��HK��������ѡ��֤������\"></select></h1> <h2><div class=\"Validform_checktip\"></div></h2></dd><dd><label>֤������:</label> <h1>&nbsp;&nbsp;<input name=\"custom_reg1\"  type=\"text\"  class=\"oldbg\" value=\"\" size=\"23\" maxlength=\"30\" datatype=\"*1-20\"errormsg=\"������������ȷ֤�����룡\"  nullmsg=\"֤������Ϊ�գ�\"></h1> <h2><div class=\"Validform_checktip\"></div></h2></dd>")
		}

		if(ishkmb=="2016")
		{
	 
			document.write("<dd><label class='dmbuymore-section-title'>ע�������:</label><label><select name=\"reg_contact_type\" datatype=\"*1-20\" class='common-select reg-area-select' id=\"reg_contact_type\" errormsg=\"ע��HK��������ѡ��ע�������\"  nullmsg=\"ע��HK��������ѡ��ע�������\">"+gethkconfig("")+"</select></label> <label><div class=\"Validform_checktip\" style='margin-left: 130px'></div></label></dd><dd><label  class='dmbuymore-section-title'>֤������:</label> <label><select name=\"custom_reg2\" datatype=\"*1-20\" id=\"reg_contact_type\" errormsg=\"ע��HK��������ѡ��֤������\"  nullmsg=\"ע��HK��������ѡ��֤������\" class='common-select reg-area-select'></select></label> <label><div class=\"Validform_checktip\" style='margin-left: 130px'></div></label></dd><dd><label  class='dmbuymore-section-title'>֤������:</label> <label><input name=\"custom_reg1\"  type=\"text\"  class=\"oldbg common-input\" value=\"\" size=\"23\" maxlength=\"30\" datatype=\"*1-20\"errormsg=\"������������ȷ֤�����룡\"  nullmsg=\"֤������Ϊ�գ�\"></label> <label><div class=\"Validform_checktip\" style='margin-left: 130px'></div></label></dd>")
		}

}

function showzhdominput()
{
		
		if (ishkmb=="4")
		{
		 
			document.write("<tr><td width=\"22%\" bgcolor=\"f7f7f7\">")
			document.write("<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"4\"><tr> ")
			document.write("<td align=\"right\"><strong>֤�����ͣ�</strong></td></tr></table></td>")			
			document.write("<td width=\"38%\"><table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"4\"><tr> <td> ")			  
			document.write("<select name=\"dom_idtype\" id=\"dom_idtype\" class=\"oldbg\"><option value=\"SFZ\">���֤</option></select></td></tr></table>")					
			document.write("</td><td width=\"40%\">ע�ṫ˾��������������д</td></tr><tr> <td colspan=\"3\" background=\"/template/Tpl_04/images/sens_mainbg2.gif\"><img src=\"/template/Tpl_04/images/sens_mainbg2.gif\" width=\"3\" height=\"1\"></td></tr>")

			document.write("<tr><td width=\"22%\" bgcolor=\"f7f7f7\">")
			document.write("<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"4\"><tr> ")
			document.write("<td align=\"right\"><strong>֤�����룺</strong></td></tr></table></td>")			
			document.write("<td width=\"38%\"><table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"4\"><tr> <td> ")			  
			document.write("<input name=\"dom_idnum\"  type=\"text\"  class=\"oldbg\" value=\"\" size=\"23\" maxlength=\"20\" ></td></tr></table>")					
			document.write("</td><td width=\"40%\">ע�ṫ˾��������������д</td></tr><tr> <td colspan=\"3\" background=\"/template/Tpl_04/images/sens_mainbg2.gif\"><img src=\"/template/Tpl_04/images/sens_mainbg2.gif\" width=\"3\" height=\"1\"></td></tr>")
		}
		
		if(ishkmb=="5")
		{
			document.write("<dd><label >֤������:</label> <h1>&nbsp;&nbsp;<select name=\"dom_idtype\" id=\"dom_idtype\" class=\"oldbg\"><option value=\"SFZ\">���֤</option></select></h1> <h2><div class=\"Validform_checktip\"></div></h2></dd><dd><label>֤������:</label> <h1>&nbsp;&nbsp;<input name=\"dom_idnum\"  type=\"text\"  class=\"oldbg\" value=\"\" size=\"23\" maxlength=\"30\" datatype=\"*1-20\"errormsg=\"������������ȷ֤�����룡\"  nullmsg=\"֤������Ϊ�գ�\"></h1> <h2><div class=\"Validform_checktip\"></div></h2></dd>")
		}
		if(ishkmb=="2016")
		{
			document.write("<dd><label  class='dmbuymore-section-title'>֤������:</label> <label><select name=\"dom_idtype\" id=\"dom_idtype\" class=\"common-select reg-area-select\"><option value=\"SFZ\">���֤</option></select></label> <label><div class=\"Validform_checktip\" style='margin-left: 130px'></div></label></dd><dd><label  class='dmbuymore-section-title'>֤������:</label> <label><input name=\"dom_idnum\"  type=\"text\"  class=\"oldbg common-input\" value=\"\" size=\"23\" maxlength=\"30\" datatype=\"*1-20\"errormsg=\"������������ȷ֤�����룡\"  nullmsg=\"֤������Ϊ�գ�\"></label> <label><div class=\"Validform_checktip\" style='margin-left: 130px'></div></label></dd>")
		}
} 

function gethkconfig(val_)
{
   hkstr="";
   if(val_=="")
   {
     for(var hki=0;hki<hkconfig.length;hki++)
	 {

		hkstr+="<option value=\""+hkconfig[hki].value+"\">"+hkconfig[hki].name+"</option>"
	 }
   }
   return hkstr;
}
function sethkzj(v)
{
	hkstr="";
	hkobj=$("select[name='custom_reg2']")
	hkobj.empty();
    for(var hki=0;hki<hkconfig.length;hki++)
	 {
	  
	    if(v==hkconfig[hki].value)
		{
		   for(var hkii=0;hkii<hkconfig[hki].data.length;hkii++)
			{
			
			hkstr+="<option value=\""+hkconfig[hki].data[hkii].value+"\">"+hkconfig[hki].data[hkii].name+"</option>"
		    }
		}
	 }
	 hkobj.append(hkstr);
}

