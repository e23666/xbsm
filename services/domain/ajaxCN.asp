<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<%response.Charset="gb2312"
  response.Buffer=true
%>
<!--#include virtual="/config/config.asp" -->
<%

function punycode(strdomain)
  on error resume next
	  PHPURL="http://beianmii.gotoip1.com/idna/api.php?a=encode&p="&server.URLEncode(strdomain) & "&pasd="& timer()
	  Set XMLobj=Server.CreateObject("WinHttp.WinHttpRequest.5.1")
	  XMLobj.setTimeouts 10000, 10000, 10000, 30000  
	  XMLobj.open "GET",PHPURL,false
	  XMLobj.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	  XMLobj.send
	  retCode=XMLobj.ResponseText
	  Set XMLobj=nothing
	  punycode=retCode
end function

function urldecode(encodestr)
on error resume next
newstr=""
havechar=false
lastchar=""
for i=1 to len(encodestr)
  char_c=mid(encodestr,i,1)
  if char_c="+" then
	newstr=newstr & " "
  elseif char_c="%" then
	next_1_c=mid(encodestr,i+1,2)
	next_1_num=cint("&H" & next_1_c)
	
	if havechar then
	    havechar=false
	    newstr=newstr & chr(cint("&H" & lastchar & next_1_c))
	else
	  if abs(next_1_num)<=127 then
		newstr=newstr & chr(next_1_num)
	  else
		havechar=true
		lastchar=next_1_c
	  end if
	end if
	i=i+2
  else
	newstr=newstr & char_c
  end if

next
urldecode=newstr
end function


function GbToBig(content)
 dim s,t,c,d,i
 s="��,��,��,ר,ҵ,��,��,˿,��,��,��,ɥ,��,��,��,��,Ϊ,��,��,ô,��,��,��,��,ϰ,��,��,��,��,��,��,��,��,ب,��,��,Ķ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,ɡ,ΰ,��,��,��,��,��,α,��,��,��,Ӷ,��,��,��,��,��,��,��,��,٭,ٯ,ٶ,ٱ,ٲ,��,ٳ,��,ծ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,д,��,ũ,ڣ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,ƾ,��,��,��,��,ۻ,��,��,��,��,��,ɾ,��,�i,��,��,��,��,��,��,��,��,��,Ȱ,��,��,۽,��,��,��,��,��,ѫ,��,��,��,��,��,��,ҽ,��,Э,��,��,¬,±,��,��,ȴ,��,��,��,��,��,ѹ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,˫,��,��,��,��,Ҷ,��,̾,ߴ,��,��,��,��,��,��,��,��,��,��,߼,߽,Ż,߿,��,Ա,��,Ǻ,��,ӽ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,Ӵ,��,�y,��,�|,��,��,��,��,��,��,��,��,��,��,Х,��,�,�,�,��,��,��,��,��,��,��,��,��,��,԰,��,Χ,��,��,ͼ,Բ,ʥ,��,��,��,��,��,��,̳,��,��,��,��,׹,¢,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,ǵ,��,�G,ܫ,ǽ,׳,��,��,��,��,��,��,��,��,ͷ,��,��,��,��,ۼ,��,��,��,ױ,��,��,��,��,�,�,��,¦,�,�,��,�,��,�,�,�O,Ӥ,�,��,��,��,��,��,��,��,ѧ,��,��,��,ʵ,��,��,��,��,��,��,��,��,Ѱ,��,��,��,��,��,��,Ң,��,ʬ,��,��,��,��,��,��,��,��,��,��,��,�,��,�,�,�,��,��,��,�,��,�N,�,Ͽ,�i,�,�,��,��,��,��,ո,��,��,��,��,��,��,��,��,��,˧,ʦ,��,��,��,��,��,֡,��,��,��,��,��,�,��,��,��,��,ׯ,��,®,��,��,Ӧ,��,��,��,��,��,��,��,��,��,��,��,��,��,ǿ,��,��,¼,��,��,��,��,��,��,��,��,��,��,��,̬,��,��,��,��,��,��,��,�,��,��,��,��,��,��,��,��,��,�,��,�,��,�,��,��,��,��,��,��,�,��,��,��,�,�,��,�,Ը,��,�\,��,�,��,��,�,�,Ϸ,�,ս,�,��,��,��,Ǥ,ִ,��,��,ɨ,��,��,��,��,��,��,��,��,��,��,��,��,£,��,ӵ,��,š,��,��,��,ֿ,��,��,��,̢,Ю,��,��,��,��,��,��,��,��,��,��,��,��,��,��,°,��,��,��,��,��,��,��,��,��,��,§,��,Я,��,��,��,ҡ,��,̯,��,��,��,ߢ,ߣ,ߥ,��,��,��,��,��,ի,�,��,ն,��,��,��,ʱ,��,�D,�,��,�o,��,��,ɹ,��,��,��,��,��,��,��,��,��,��,ɱ,��,Ȩ,��,��,��,�,��,��,��,��,��,��,��,��,��,ǹ,��,��,��,��,��,��,դ,��,ջ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,׮,��,��,��,��,��,�,��,��,�,��,¥,�,�,�,�,��,��,��,��,��,��,ӣ,��,��,��,��,��,��,��,�,ŷ,��,��,��,��,��,��,��,��,Ź,��,�,��,��,ձ,�,�,��,��,�,�,��,��,��,��,��,�,��,û,��,Ž,��,��,��,�h,��,��,�m,Ţ,��,�,��,��,��,к,��,��,��,��,��,��,�,ǳ,��,��,�,��,��,��,�,��,�,��,��,�,Ũ,�,��,Ϳ,ӿ,��,��,�,��,�,��,��,��,��,��,��,��,ɬ,��,Ԩ,��,��,��,��,��,��,��,��,��,��,��,ʪ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,̲,��,��,��,��,��,Ϋ,Ǳ,��,��,��,��,�,��,��,��,��,��,�,¯,��,�,��,��,��,��,˸,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,ү,�,��,ǣ,��,��,��,��,״,��,��,��,��,��,�A,��,��,��,ʨ,��,��,��,��,��,��,�,�,��,è,�,��,̡,��,�_,�`,��,��,��,��,�o,��,��,��,��,��,��,��,�Q,��,��,��,��,�,�,�,�,��,�,��,��,��,�,��,��,��,ű,��,��,��,��,��,��,��,Ӹ,��,��,��,��,��,��,��,��,�},��,��,��,̱,�,�,�,Ѣ,�,�,��,��,��,յ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,�,��,��,�,��,ש,�,��,�,��,��,��,��,�n,��,˶,��,��,�},�~,ȷ,��,��,��,��,��,��,��,��,�t,��,��,��,��,��,»,��,��,ͺ,��,��,��,��,��,��,��,˰,��,��,�,��,��,��,Ҥ,��,��,��,�,��,��,��,��,��,��,��,��,��,��,��,��,ɸ,�Y,��,��,ǩ,��,��,��,��,��,��,��,��,��,¨,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,Լ,��,��,��,��,��,γ,�,��,��,�,ɴ,��,��,��,��,��,��,ֽ,��,��,��,��,Ŧ,�,��,�,�,�,��,��,��,ϸ,֯,��,�,��,�,�,��,��,��,�,��,��,��,�,��,��,�,��,��,Ѥ,�,��,��,��,ͳ,�,�,��,��,��,��,��,��,�,��,��,�,��,��,�,�,��,�,�,��,ά,��,�,��,��,��,�,�,��,��,�,��,׺,�,�,�,��,��,��,�,�,��,��,��,��,�,��,��,��,��,��,��,��,��,��,��,Ե,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,ӧ,��,��,��,��,��,��,��,��,��,��,��,��,��,�,��,��,��,��,�,�,��,��,��,��,��,��,��,��,��,��,��,ְ,��,��,��,��,��,��,��,��,��,��,��,в,��,ʤ,��,��,��,��,��,��,��,��,��,��,ŧ,��,��,��,��,��,��,��,�N,��,��,��,��,��,��,�H,��,��,��,��,��,��,��,ܳ,��,��,��,ܼ,��,«,��,έ,��,��,��,��,��,��,��,ƻ,��,��,��,��,��,��,��,��,�Q,��,��,��,��,��,��,��,��,��,��,��,ӫ,ݡ,ݣ,ݥ,��,ݤ,ݦ,ݧ,ҩ,ݰ,ݯ,��,��,ݪ,ݫ,ݲ,��,ݵ,Ө,ݺ,ݻ,�[,��,ө,Ӫ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,Ǿ,��,��,��,ޭ,��,޴,޻,޺,²,��,��,��,�,�,��,Ϻ,�,ʴ,��,��,��,�,�,��,��,��,��,��,��,��,��,��,��,��,��,Ӭ,��,��,Ы,��,��,΅,��,�],��,��,��,��,��,��,��,Є,��,Ϯ,�B,װ,��,�T,��,��,��,��,��,��,��,�[,��,��,�_,��,��,��,��,��,��,��,��,��,�`,��,��,��,��,��,��,��,Ԁ,��,��,ڥ,��,��,��,��,��,ڦ,ڧ,��,��,ڨ,��,ѵ,��,Ѷ,��,ך,��,��,ک,ڪ,��,ګ,��,��,��,כ,��,��,��,��,��,֤,ڬ,ڭ,��,��,ʶ,ל,թ,��,��,ڮ,��,��,ڰ,گ,ם,��,ڱ,ڲ,ڳ,��,ڴ,ʫ,ڵ,ڶ,��,��,ڷ,��,��,ڸ,ڹ,��,ѯ,��,ں,��,��,��,ڻ,ڼ,מ,��,��,��,ڽ,��,ھ,��,��,ڿ,˵,��,��,��,��,��,ŵ,��,��,��,��,��,��,˭,��,��,��,��,׻,��,̸,��,ı,��,��,��,��,г,��,��,ν,��,��,��,��,��,��,��,��,��,��,נ,��,��,��,л,ҥ,��,��,ǫ,��,��,á,��,��,��,̷,��,��,��,��,��,��,Ǵ,��,��,��,�k,��,��,��,�O,��,��,��,��,��,��,��,��,��,̰,ƶ,��,��,��,��,��,��,��,��,��,��,��,��,ó,��,��,��,��,��,��,��,��,��,¸,��,��,��,��,��,��,��,��,��,��,��,��,��,��,�P,�Q,��,��,��,��,�R,׸,��,׬,��,��,��,��,�S,��,��,Ӯ,��,�W,��,��,��,��,��,Ծ,��,��,��,��,�Q,��,��,��,��,ӻ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,�a,��,ת,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,�b,��,��,��,��,��,��,��,��,��,��,��,�c,�,�,�,��,��,�d,��,��,ԯ,Ͻ,շ,�,��,�,��,��,��,��,��,��,Ǩ,��,��,��,��,��,��,Զ,Υ,��,��,��,��,��,��,ѡ,ѷ,��,��,��,��,ң,��,��,��,��,��,��,��,��,ۧ,ۣ,ۦ,֣,۩,۪,��,��,��,�N,��,��,��,��,��,��,�,��,��,��,��,��,��,��,��,��,��,��,ǥ,��,��,�,��,��,��,��,�,��,�,��,��,��,��,��,��,��,��,��,��,��,Կ,��,��,��,��,��,��,��,��,ť,��,��,Ǯ,��,ǯ,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,Ǧ,í,��,��,��,��,��,��,��,�,��,��,��,�,�,��,��,��,��,��,�,��,ͭ,��,��,��,��,ա,��,ϳ,��,��,�,��,��,�,��,�,��,��,�,�,��,ҿ,��,�,�,�,��,�,��,�,��,�,�,�,��,�,��,��,�,�,��,��,�,�,��,�,�,��,п,�,�,�,��,��,�,�,�,�,�,��,�,��,ê,�,�,�,�,�,�,��,��,��,��,׶,��,�@,��,��,��,��,��,��,��,��,��,��,��,�A,��,��,��,��,��,��,��,��,��,�B,��,��,��,þ,��,�C,��,��,��,��,�D,��,��,�E,��,��,��,��,��,��,��,��,��,�F,��,��,��,��,�G,��,��,��,��,��,�H,��,��,��,��,��,��,��,��,��,��,��,��,��,�I,��,��,��,��,��,�J,�K,��,��,��,��,��,��,�\,��,��,��,��,��,��,��,��,��,��,��,բ,��,��,��,��,��,��,�],��,��,��,��,��,��,��,�^,��,��,��,��,��,��,��,��,��,��,��,�_,��,��,��,��,�`,��,��,�a,��,��,��,��,��,��,½,¤,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,ù,��,��,��,��,��,��,��,��,Τ,��,�,��,�,�,�,��,ҳ,��,��,��,��,˳,��,��,��,��,��,��,��,��,��,Ԥ,­,��,��,��,�,��,�F,�,�,�G,�,��,Ƶ,�H,��,�,�I,ӱ,��,��,�J,�,�,��,��,�,�,��,�,�,�K,��,�,�,ȧ,��,�r,�s,�,�,�,�t,�,�u,�v,Ʈ,�,�,��,��,��,�,��,�,�,�,�,�,��,��,��,��,��,��,��,��,�,��,��,��,��,�,�,��,�,��,��,�,��,��,��,�,�,��,��,��,��,��,�,��,��,�@,��,�A,��,��,��,��,��,��,��,��,Ԧ,��,ѱ,��,��,�R,��,¿,��,ʻ,��,��,��,��,פ,��,��,��,��,��,��,��,�S,��,��,��,��,��,�T,��,��,��,�U,�V,��,��,��,��,��,�W,�X,��,ƭ,��,�Y,ɧ,��,��,��,�,��,��,��,��,��,��,��,�Z,��,��,��,��,��,��,��,��,��,��,��,��,³,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,�@,��,�,��,�,��,�\,Ÿ,ѻ,�],�,�,�,�,�,Ѽ,�^,��,�_,�,�,ԧ,�`,��,�,�,�,�,�,�a,�b,��,�,��,�c,�,�,��,��,��,��,��,��,��,ȵ,��,��,�d,��,��,�e,��,�f,�g,�h,��,�i,��,��,�j,��,��,��,�k,��,�l,�m,�n,�o,��,��,�p,��,��,��,��,��,��,��,��,�r,ӥ,��,�s,��,�t,��,��,��,��,��,�d,��,��,��,��,��,��,ػ,��,��,��,�,��,��,��,��,��,��,��,��,��,��,��,��,ȣ,��,��,��,��,��"
 t="�f,�c,�h,��,�I,��,�|,�z,�G,��,��,��,��,��,�S,�R,��,��,�e,�N,�x,��,��,��,��,�l,��,�I,�y,��,�,̝,�,��,��,�a,��,�H,�C,��,�|,�H,��,��,�},�x,��,�r,��,��,�,��,��,��,��,��,��,�t,��,��,��,��,�w,�N,��,�L,�b,�H,�e,��,��,�S,�~,��,�z,�R,��,��,�z,��,��,��,�A,��,�E,�f,��,��,��,��,��,��,��,��,�h,�m,�P,�d,Ɲ,�B,�F,��,��,��,��,��,܊,�r,�V,�T,�_,�Q,�r,��,�Q,�D,��,�R,�p,��,�C,��,�P,�D,�{,�P,��,��,�,�c,��,��,�t,��,��,�h,�e,�},�q,��,��,��,��,��,��,��,��,��,�k,��,��,��,��,��,��,��,��,��,��,��,�Q,�T,�^,�t,�A,�f,��,�u,�R,�u,�P,�l,�s,��,�S,�d,��,��,��,��,��,��,��,��,�B,�N,��,�P,�h,��,��,�a,�^,�p,�l,׃,��,�B,�~,̖,�U,�\,�n,��,��,��,��,�w,��, ,��,��,�`,��,�I,��,�h,�T,�J,��,��,ԁ,�U,��,��,�z,߸,�j,�y,��,�,��,�},�^,��,��,�W,��,��,��,��,�O,��,�Z,��,��,�r,��,��,�K,��,��,�m,��,�c,�[,��,�D,��,��,��,��,�u,��,��,��,��,��,�o,�F,�@,��,��,��,��,�D,�A,�},��,��,��,��,�K,��,��,��,��,�],��,��,��,��,��,��,��,�s,��,�|,��,��,��,�N,��,�P,�_,��,�|,��,�q,��,��,ԭ,��,��,,��,��,��,̎,��,�},��,�^,�F,�A,�Z,�Y,�J,�^,��,�W,�y,�D,��,��,��,��,��,�K,��,�I,��,��,�D,��,�z,��,��,��,��,��,��,��,��,��,��,�O,�W,�\,��,��,��,��,��,��,�m,��,�e,��,��,��,��,��,��,��,�m,�L,��,��,��,�M,��,��,��,��,��,��,��,�Z,�q,�M,��,��,�s,�S,��,�u,�X,�[,��,�h,�G,�F,�{,�A,��,��,�n,��,��,�M,��,�V,��,��,��,��,�p,�,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,�L,��,�K,ô,�V,�f,�c,�],�T,��,��,�R,��,�U,�F,�[,�_,��,��,��,��,��,��,��,��,�w,��,�,��,��,��,��,��,�R,��,��,�n,��,��,�B,�Z,��,�Y,��,��,�z,��,��,��,��,��,��,�Q,��,��,��,��,��,��,��,��,�a,��,�@,��,�K,��,�v,��,�M,��,�T,��,�C,��,�|,�,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,�L,��,�U,��,��,�P,�_,��,��,��,��,��,��,�o,��,��,�M,�n,��,��,�r,�Q,��,��,��,��,��,��,��,��,��,��,��,��,��,�D,�],��,��,�p,��,�Q,�v,��,��,��,��,�S,��,��,��,��,��,��,�v,�R,��,��,�y,�z,�d,�[,�u,�P,��,�t,��,�f,�X,�],�x,�\,��,��,��,��,�S,��,�Y,��,��,�o,�f,�r,��,��,��,��,��,�@,�x,��,��,��,��,��,��,��,��,�g,��,�C,��,�s,��,�l,��,��,�q,��,�O,��,��,��,��,��,�g,��,��,��,�n,��,��,�f,�d,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,�E,�n,��,��,��,�u,��,��,��,��,��,�z,��,��,��,��,��,�E,��,��,��,��,��,�x,��,��,��,�M,�{,��,��,��,��,��,��,�_,�g,�e,�W,��,�{,��,��,��,��,��,��,��,��,ݞ,��,��,��,��,��,��,��,��,��,��,�h,�@,��,��,�e,��,�],��,�a,�r,�S,��,�t,��,��,��,��,�I,��,�{,�o,�T,�a,��,��,��,��,��,�D,��,�\,�{,��,��,��,��,�y,��,��,�g,�I,��,�G,��,��,��,�T,��,��,��,�Z,�i,��,�u,��,�o,��,��,��,�q,��,��,�Y,�O,�n,�^,�u,��,�O,�c,�B,��,�[,��,��,��,�R,�s,�U,��,�L,��,��,��,�M,�],�V,�E,��,�I,��,��,�E,�u,�t,��,�H,��,�z,��,�|,�l,��,��,��,�`,��,�N,��,�t,��,��,��,�c,��,��,�q,��,�N,�T,��,��,��,��,�Z,�C,�a,��,��,�F,�c,��,��,��,��,��,��,��,��,��,��,��,��,Ȯ,��,�E,�w,�q,�N,��,��,��,��,�M,�{,��,�b,�z,�s,��,�C,�J,�M,�i,؈,�o,�I,�H,�^,�m,��,��,�|,�h,�F,��,�t,�z,�k,�m,��,�c,�q,�\,�I,��,��,��,�a,�v,��,��,�Y,�T,�,��,��,��,��,�X,��,��,�O,��,�,��,��,��,��,�b,�d,�W,�{,�A,��,�B,�V,�D,��,��,��,�T,�c,�a,�`,�],�_,�d,ğ,�},��,��,�K,�},�O,�w,�I,�P,�g,�{,��,��,��,�A,��,�m,��,�C,��,�\,�V,�X,�a,�u,��,��,�^,�Z,�a,�[,�A,��,��,�T,��,��,�o,��,�_,�|,�K,��,�~,�A,��,�L,�Y,�B,�[,��,�\,��,�A,��,�U,�x,�d,��,�N,�e,�Q,�x,�v,��,��,�d,��,�w,�F,�`,�[,�G,�Z,�C,�Q,�],�M,�Q,��,�V,�S,�P,�a,�{,�\,�e,�B,�`,�Y,��,�~,�I,��,��,�U,�j,�D,�X,�j,��,��,��,�t,�@,�h,�f,�[,�e,�,�i,�g,�c,��,�S,�Z,�R,�f,�o,�{,��,�m,�u,�t,�q,�w,�v,�s,��,�w,�k,�o,�x,��,��,��,��,��,��,�V,�{,��,�v,�],��,��,�y,��,��,��,�~,��,��,�C,�X,��,��,�M,��,��,��,�K,�U,�O,�E,�I,�B,�[,��,�H,��,�q,�Y,�f,�@,�x,�W,�L,�o,�k,�{,�j,�^,�g,�y,��,��,��,�C,��,��,�d,�^,��,��,�w,�c,�x,�m,�_,�p,�b,�y,�i,�K,�S,�d,�R,��,�I,�T,�^,�J,�C,�`,�U,�G,�Y,�l,�~,�|,�},��,�|,��,��,��,�Z,�D,��,�E,��,��,��,��,�P,��,��,�|,��,��,��,�N,�`,�d,�b,�p,�\,�c,�p,�r,�O,�V,�_,�~,�z,�w,�t,�s,��,��,�i,��,��,��,�\,�`,�R,�Q,�U,�y,��,�W,�_,�P,�T,�`,�b,�u,�w,�N,�P,�E,�g,�e,,�u,,�@,,,,,,�C,�c,�w,�d,�I,�[,Û,�{,đ,��,�V,�L,�F,Ä,�z,�},Ē,�v,Ě,�X,ē,�L,�_,Ó,�T,Ę,�D,�Z,�s,�|,ā,�t,�e,�v,Ĝ,�N,ݛ,Ŝ,Ş,œ,�A,�D,�W,�H,ˇ,��,�d,�G,ʏ,�J,ɐ,Ȕ,˞,�{,�O,�n,�r,�K,��,�O,�o,�d,�\,�L,��,�O,�G,�],�R,�v,ʁ,ɜ,�w,�C,�j,ʎ,�s,ȝ,��,��,��,�n,�|,�p,�a,�{,ȇ,Ȓ,ˎ,�W,ɉ,�R,ɏ,�P,�n,�W,�@,�~,��,�L,ɔ,�E,�},Ξ,�I,�M,ʒ,�_,�[,�r,ʉ,�Y,�V,�{,�E,�y,ʚ,�v,�,�N,�`,�A,�@,�I,�N,˒,��,�\,̔,�],̓,�x,�A,�l,�m,�r,ϊ,�g,ρ,Λ,�Q,ϖ,͘,�M,Ϡ,�|,�U,�U,͐,�u,·,ϓ,͑,΁,Ϟ,ω,�X,�s,ϐ,�N,ϔ,�Q,�\,�D,�,�,�a,�r,Ж,�\,��,ы,�m,�u,�U,�b,�d,т,ў,�c,ѝ,�M,�@,�h,��,�w,Ҋ,�^,ҍ,Ҏ,Ғ,ҕ,җ,�[,�X,�J,Ҡ,�],�C,�D,�M,�P,�U,�x,�|,�z,ׄ,�u,�`,Ӆ,Ӌ,ӆ,Ӈ,�J,�I,ӓ,ӏ,ӑ,׌,Ә,ә,Ӗ,�h,Ӎ,ӛ,ӕ,�v,�M,֎,�n,Ӡ,�G,�S,Ӟ,Փ,�K,�A,�S,�O,�L,�E,�C,�b,�X,�u,�{,�R,�w,�p,�V,�\,�g,�a,�~,�x,�t,�v,�g,�r,�E,�C,ԇ,ԟ,Ԋ,ԑ,Ԝ,�\,�D,Ԗ,Ԓ,�Q,ԍ,ԏ,Ԏ,ԃ,Ԅ,Պ,ԓ,Ԕ,Ԍ,՟,Ԃ,�p,�],�_,�Z,�V,�`,�a,�T,�d,�N,�f,�b,�O,Ո,�T,Ռ,�Z,�x,Վ,�u,�n,Ն,՘,�l,Ք,�{,�~,Տ,Ձ,�r,Մ,�x,�\,�R,ՙ,�e,�G,�C,�o,�],�^,�@,�I,�X,׋,�J,�O,�V,�B,�i,՛,՚,փ,ו,�q,�x,�{,�r,՞,�t,�k,֔,֙,ֆ,�v,և,�T,�P,�S,׎,�V,�H,ח,�l,�d,׏,�Y,�r,ؐ,ؑ,ؓ,ؒ,ؕ,ؔ,؟,�t,��,�~,؛,�|,؜,؝,ؚ,�H,ُ,�A,؞,�E,�v,�S,�B,�N,�F,�L,�J,�Q,�M,�R,�O,�\,ٗ,�Z,�V,�D,�U,�T,�E,�Y,�W,�B,�g,�c,�l,�d,�x,ـ,�V,�H,�p,�n,�F,�k,�s,�r,�y,ه,و,٘,َ,ٍ,ِ,ّ,�I,ٝ,ٚ,ٛ,٠,�A,�M,�X,�w,�s,څ,ڎ,�O,�S,ۄ,ە,�V,�`,�J,�E,ۋ,�],�Q,�x,�P,ۙ,�W,�U,�b,ۘ,�X,�f,�k,�g,�|,܇,܈,܉,܎,܍,ܐ,�D,ܗ,݆,ܛ,�Z,�M,�V,�_,�S,�T,�W,ܠ,�F,�],�U,�p,�Y,�d,�e,�I,�c,�b,�`,�^,�m,�o,�v,݂,݅,�x,݁,�y,݈,�z,�w,ݏ,ݗ,݋,ݜ,ݔ,�\,�@,ݠ,ݚ,�A,�H,�O,�o,�q,�p,߅,�|,�_,�w,�^,�~,�\,߀,�@,�M,�h,�`,�B,�t,߃,ޟ,�E,�m,�x,�d,�f,ߊ,߉,�z,�b,��,��,�w,�],�u,��,��,�d,�S,�P,��,��,�i,�B,�y,��,�j,�w,�u,�,�,�,�,�Y,��,�b,�,�Y,�,�,�,�,�,�,�,�Q,�T,�A,�,�l,�C,�,�{,�S,�,�O,�],�},�b,�,�g,�n,�R,�c,�^,�,�k,�j,�,�J,�x,�u,�^,�,�[,�,�^,�o,�Z,�,�X,�`,�Q,�,��,�,�O,�,�,�X,�,�f,�g,�,�,�,�F,�K,�,�p,�U,�T,�,�C,�B,�G,�,�,�I,�o,�D,�,�s,�,�E,�B,�,�e,�y,�t,�,�K,�~,�X,�H,�,�z,�,�,�,�b,�A,�,�f,�,�|,�x,�,�t,�,�P,�C,�q,�,�P,�|,�|,�@,�y,�,�T,�,�,�o,�n,�,�,�H,�N,�i,�,�{,�z,�,�,�~,�n,�S,�s,�h,�\,�,�,�,�J,�R,�Z,�u,�|,�H,�,�N,�,�e,�^,�Q,�W,�u,�,�K,�_,�a,�d,�,�N,�F,�\,�e,�v,�,�x,�,�U,�V,�I,�,�i,�O,�,�},�|,�I,�J,�,�,�@,�R,�,�},�,�D,�X,�,�V,�U,�t,�,�[,�,�,�n,�k,�,�,�,�,�,�y,�,�^,�,�,�\,�g,�S,�M,�N,�,�a,�O,�R,�C,�,�,�B,�,�,�,�h,�u,�,�|,�,�,�j,�,�Z,�D,�G,�C,�,�O,�d,�s,�n,�,�,�L,�T,�V,�W,�Z,�\,�],��,�J,�c,�,�e,�b,�g,�h,�`,��,�l,�[,�|,,�Y,�},�,�G,�y,�w,�u,�,�b,�,�,�A,�,�,�,�],�,�,�,�,�U,�@,�,�T,�,�,�H,�D,�F,�I,�R,�X,�,�,�,�,�A,�H,�,�],�,�,�,�,�E,�U,�S,�[,�`,�h,�y,�r,ׇ,�Z,�F,�V,�q,�\,�n,�o,�v,�^,�X,�d,�x,�f,�g,�h,�n,�t,�y,�w,�,�,�,�,�,�,�,�,�,�B,�,�D,�,�C,�,�@,�A,�B,�I,�H,�i,�R,�a,�c,�M,�},��,�W,�U,�l,�_,�j,�h,�e,�f,�w,�},�,�,�,�,�~,�D,�,�,�,�,�h,�,�,�A,�E,�L,�^,�Q,�R,�S,�Z,�\,�`,�_,�d,�h,�j,�j,�w,��,�,�},��,�,�h,�,�q,�,�,�,�,�,�T,�,�,�,�,�,�D,��,�A,�,�E,�,�F,�,�G,�L,�I,�N,�H,�K,�R,�Q,�W,�^,�l,��,�k,�t,�,�v,�x,�o,�s,�},�~,�z,��,��,�,�R,�S,�W,�Z,�Y,�,�_,�g,�H,�z,�,�,�,�x,�|,�v,�,�w,�{,�A,�~,�,�R,�,�,�,�,�,�,�Q,�P,�G,�,�H,�,�E,�U,�T,�S,�K,�R,�,�,�_,�s,�j,�},�\,�,�t,�q,�~,�,�,�,�,�E,�K,�L,�J,�t,�y,�x,�W,�|,�u,�~,�,�,��,�,��,��,��,�E,�G,�T,�|,�O,�W,�V,�N,�U,�c,�Q,�T,�q,�^,�w,�n,�b,�j,�f,�`,�d,�q,�o,�r,�~,��,�\,��,�~,��,��,��,��,��,��,��,��,�z,�a,��,��,�N,��,�O,�E,�H,�K,�A,�F,�T,��,�L,�Y,�X,��,�a,�l,�s,�l,�[,��,�g,�w,�{,�q,�v,�m,�e,�F,�c,��,��,��,��,��,��,��,��,��,�B,�L,�M,��,��,�I,�@,�Z,�X,�[,�V,�s,�h,�k,�g,�B,�F,�u,�S,�Q,�O,�t,�f,�I,�d,�c,��,��,�R,��,�{,��,�o,�|,�z,�x,��,�r,��,�v,��,��,��,��,�@,��,�[,��,�M,�P,�Z,�N,�],�Z,�O,��,�Y,�^,�o,��,�g,�A,�l,�i,�k,��,��,�t,��,��,��,��,�X,��,�\,�B,�F,�g,�_,�O,�V,�W,�^,�Y,�Q,�s,�W,�p,�w,��,��,��,��,��,�D,��,�I,�L,�X,�U,�z,��,��,�S,�Z,�s,�t,�o,�w,�x,�{,��,�,�B,�O,�R,�W,�X,�Z,�[,�],�e,�g,�_,�f,�b,�l,�r,�p,�x,�},��,��,��,��"
c=split(s,",")
d=split(t,",")
for i=0 to 2555
content=replace(content,c(i),d(i))
next
GbToBig=content
end function
Function bstr(vIn)

	Dim strReturn,i,ThisCharCode,innerCode,Hight8,Low8,NextCharCode
	strReturn = ""
	
	For i = 1 To LenB(vIn)
		ThisCharCode = AscB(MidB(vIn,i,1))
		If ThisCharCode < &H80 Then
			strReturn = strReturn & Chr(ThisCharCode)
		Else
			NextCharCode = AscB(MidB(vIn,i+1,1))
			strReturn = strReturn & Chr(CLng(ThisCharCode) * &H100 + CInt(NextCharCode))
			i = i + 1
		End If
	Next
	
	bstr = strReturn 	
End Function

sub writelog(mess)
	logFiles="d:\autosystemlog\" & year(now()) & "_" & month(now()) & "_" &  day(now()) & "bizcn.txt"
	set fileobj=server.createObject("scripting.filesystemobject")
	set fhd=fileobj.opentextfile(logFiles,8,true)
	fhd.writeline(mess)
	fhd.close
	set fhd=nothing
end sub

Function GetURL(url)
    Set Retrieval = Server.CreateObject("Microsoft.XMLHTTP")
	
          With Retrieval
          .Open "GET", url, false
		  .setRequestHeader "Content-Type","application/x-www-form-urlencoded"
          .Send

		  GetURL =.ResponseBody
		  End With
    Set Retrieval = Nothing
	GetURL=bstr(GetURL)
End Function
	



Class postForm
public posturl
function addItem(key,value)
  if posturl="" then
  	posturl=key &"=" & Server.UrlEncode(value)
  else
	posturl=posturl & "&" & key & "=" & Server.UrlEncode(value)
  end if
end function
end class
domain_Name_ok=Requesta("domain_name")
domain_Name=Requesta("domain_name")
suffix=Requesta("suffix")
if domain_name="" then url_return "����д���ѯ������",-1
suffix=replace(suffix," ","")
splitsuffix=split(suffix,",")

dim BadStr,ActStr,UnRegStr
dim sBadStr,sActStr,sUnRegStr
conn.open constr

for each sufname in splitsuffix
  if sufname=".tv" then
	mydomain=domain_Name
			if netcnwhois(mydomain,trim(sufname))="100" then
			ActStr=ActStr&domain_Name_ok&sufname&"|"  '��ѯ�ɹ�-��ע��
			else
				UnRegStr=UnRegStr&domain_Name_ok&sufname&"|"  '��ѯ�ɹ�-����ע��

			end if
  elseif sufname=".cc" then
	        mydomain=domain_Name
			if netcnwhois(mydomain,trim(sufname))="100" then
			ActStr=ActStr&domain_Name_ok&sufname&"|"  '��ѯ�ɹ�-��ע��
			else
				UnRegStr=UnRegStr&domain_Name_ok&sufname&"|"  '��ѯ�ɹ�-����ע��

			end if
  else

    whois_source=GetWhoisFrom()

	if whois_source="bizcn" then
			Return_big=trim(GetReturn2(GbToBig(domain_Name)))
			Return=trim(GetReturn2(domain_Name_ok))
	elseif  whois_source="netcn" then
			Return_big=trim(netcnwhois(GbToBig(domain_Name),sufname))
			Return=trim(netcnwhois(domain_Name_ok,sufname))

	elseif  whois_source="xinet" then
			Return_big=trim(GetReturn(GbToBig(domain_Name),sufname))
			Return=trim(GetReturn(domain_Name_ok,sufname))
	else 
	  Return_big=trim(nowcnwhois(GbToBig(domain_Name),sufname))
	  Return=trim(nowcnwhois(domain_Name_ok,sufname))
	end if
		if trim(Return)="100" then
			if Return_big="100" then
			ActStr=ActStr&domain_Name_ok&sufname&"|"  '��ѯ�ɹ�-��ע��

			else
					UnRegStr=UnRegStr&domain_Name_ok&sufname&"|"  '��ѯ�ɹ�-����ע��

			end if
         
		elseif Return="-100" or Return_big="-100" then
			UnRegStr=UnRegStr&domain_Name_ok&sufname&"|"  '��ѯ�ɹ�-����ע��
		else
			BadStr=BadStr&domain_Name_ok&sufname&"|"  '��ѯʧ��
		end if

  end if
next

function GetReturn(d_name,sufx)'����
	URL="http://www.paycenter.com.cn/cgi-bin/Check"
	Set MyForm=new postForm
	MyForm.addItem "name",d_name
	MyForm.addItem "suffix",sufx
	MyForm.AddItem "enc","G"
	MyForm.addItem "client","agent5958"
	
	Set XMLOBJ=Server.CreateObject("Microsoft.XMLHTTP")
	'Set XMLOBJ = server.CreateObject("Msxml2.XMLHTTP")
	XMLOBJ.open "POST",URL,false
	XMLOBJ.Send(MyForm.posturl)
	GetReturn=XMLOBJ.ResponseText
	Set XMLOBJ=nothing
end function

function GetReturn2(d_name)'�����й�
	URL="http://www.bizcn.com"
							Set objURL2=new PostForm
							objURL2.AddItem "module","chinaintersearch"
							objURL2.AddItem  "searchType","IntDomain"
							objURL2.AddItem  "action","check"
							objURL2.AddItem  "domain_name",d_name
							objURL2.AddItem  "domain_name_ext",".tv"
	
	Set XMLOBJ=Server.CreateObject("Microsoft.XMLHTTP")
	XMLOBJ.open "POST",URL,false
	XMLOBJ.Send(objURL2.posturl)
	GetReturn2=XMLOBJ.ResponseText
	Set XMLOBJ=nothing
end function
function netcnwhois(Byval Domain,sufx)'����
'����������ĵ�����ѯ��
	Domain=punycode(Trim(Domain))
	
	TakenHTML = GetURL("http://panda.www.net.cn/cgi-bin/check.cgi?area_domain=" & Domain & trim(sufx))
	if instr(TakenHTML,"210") then
		netcnwhois="100"
	else
		netcnwhois="-100"
	end if
	TakenHTML=""
	

end function

function nowcnwhois(Byval Domain,sufx)'ʱ������
	
	Domain=punycode(Domain)

	TakenHTML = GetURL("http://now.net.cn/domain/domaincheck.php?query="&trim(Domain)&trim(sufx))
	if instr(TakenHTML,"��ϲ")>0 then
		    nowcnwhois="100"
	else
			if instr(TakenHTML,"�ѱ�")>0 then
			nowcnwhois="-100"
			else
			nowcnwhois="0"
			end if
	end if
	TakenHTML=""
	
end function

function checkdomains(Domain,sufx)
  set s=server.CreateObject("cmodex.Edward_NowCN")
  re=split(s.checkdomain(trim(Domain)&trim(sufx)),":")

  if re(1)="available" then
    checkdomains="100"
  elseif re(1)="notavailable" then
    checkdomains="-100"
  else
    checkdomains="0"
  end if
end function

function whoistv(strdomain)
		whoistv="100"		
end function


%>
      <table width="95%" border="0" cellspacing="0" cellpadding="3">
        <tr> 
        <td width="7%" align="center"><img src="/Template/Tpl_01/images/num.gif" width="29" height="20"></td>
        <td width="93%" class="14pxfont"><strong><font color="#669966">������������ע��</font></strong></td>
        </tr>
      </table>
      <table width="95%" border="0" cellpadding="0" cellspacing="0" bgcolor="f7f7f7">
      <form name="form1" action="dmbuy_chinese.asp" method="post">
	  <%
	  session("whoisValue")=""
	  href="/services/domain/dmbuymore.asp"
	  sActStr=split(ActStr,"|")
for i=0 to ubound(sActStr)-1
	  session_pd_str=session_pd_str&trim(sActStr(i))&"|"  
 	  %>
        <tr> 
          <td>
           <table width="100%" border="0" cellspacing="0" cellpadding="2">
           <tr> 
           <td width="15%" align="right"><img src="/Template/Tpl_01/images/drcr.gif" width="17" height="17"></td>
           <td width="47%">
            <input type="checkbox" name="domainsset" value="<%=sActStr(i)%>" checked>
           <a href="#" onclick="javascript:dosubmits('<%=href%>',<%=i%>)"><span style="color: #0066CC"><%=sActStr(i)%></span></a>
            <input type="hidden" name="domain<%=i%>" id="domain<%=i%>" value="<%=sActStr(i)%>" />
           </td>
           <td width="38%"><a href="#" onclick="javascript:javascript:dosubmits('<%=href%>',<%=i%>)"><img src="/Template/Tpl_01/images/button_r_domain_15.gif" width="80" height="21" border="0"></a></td>
           </tr>
           </table>
          </td>
        </tr>
        <tr> 
          <td background="/Template/Tpl_01/images/sens_mainbg2.gif"><img src="/Template/Tpl_01/images/sens_mainbg2.gif" width="3" height="1" border="0"></td>
        </tr>
		<%
next
session("whoisValue")=session_pd_str
		%>
         <tr><td align="center">
        <input name="allregsub" type="button" class="app_ImgBtn_Big" value="����ע��" onClick="return doallsub(this.form)">
        </td></tr>
        <tr><td height="1" background="/Template/Tpl_01/images/sens_mainbg2.gif"></td></tr>
        </form>
      </table>
      <br>
      <table width="95%" border="0" cellspacing="0" cellpadding="3">
        <tr> 
          <td width="7%" align="center"><img src="/Template/Tpl_01/images/num.gif" width="29" height="20"></td>
          <td width="93%" class="14pxfont"><strong><font color="#CC0000">���������Ѿ�ע��</font></strong></td>
        </tr>
      </table>
      <table width="95%" border="0" cellpadding="0" cellspacing="0" bgcolor="f7f7f7">
        <%
		sUnRegStr=split(UnRegStr,"|")
	  	for i=0 to ubound(sUnRegStr)-1
		%>
        <tr> 
          <td><table width="100%" border="0" cellspacing="0" cellpadding="2">
              <tr> 
                <td width="15%" align="right"><img src="/Template/Tpl_01/images/20050703091647167.gif" width="14" height="11"></td>
                <td width="85%">&nbsp;<%=sUnRegStr(i)%></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td background="/Template/Tpl_01/images/sens_mainbg2.gif"><img src="/Template/Tpl_01/images/sens_mainbg2.gif" width="3" height="1" border="0"></td>
        </tr>
        <%next%>
      </table>
      <br>
      <table width="95%" border="0" cellspacing="0" cellpadding="3">
        <tr> 
          <td width="7%" align="center"><img src="/Template/Tpl_01/images/num.gif" width="29" height="20"></td>
          <td width="93%" class="14pxfont"><strong><font color="#660099">����������ѯʧ��</font></strong></td>
        </tr>
      </table>
      <table width="95%" border="0" cellpadding="0" cellspacing="0" bgcolor="f7f7f7">
        <%
		sBadStr=split(BadStr,"|")
	  for i=0 to ubound(sBadStr)-1
	  href=""
	  cDoFux=split(sBadStr(i),".")
	  
		%>
        <tr> 
          <td><table width="100%" border="0" cellspacing="0" cellpadding="2">
              <tr> 
                <td width="15%" align="right"><img src="/Template/Tpl_01/images/20050703091648248.gif" width="14" height="11"></td>
                <td width="85%">&nbsp;&nbsp;<%=sBadStr(j)%></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td background="/Template/Tpl_01/images/sens_mainbg2.gif"><img src="/Template/Tpl_01/images/sens_mainbg2.gif" width="3" height="1" border="0"></td>
        </tr>
        <%next%>
      </table>