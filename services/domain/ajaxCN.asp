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
 s="ÕÚ,”Î,≥Û,◊®,“µ,¥‘,∂´,Àø,∂™,¡Ω,—œ,…•,∏ˆ,„‹,∑·,¡Ÿ,Œ™,¿ˆ,æŸ,√¥,“Â,Œ⁄,¿÷,««,œ∞,œÁ, È,¬Ú,¬“,’˘,”⁄,ø˜,‘∆,ÿ®,—«,≤˙,ƒ∂,«◊,ŸÙ,Åè,“⁄,Ωˆ,¥”,¬ÿ,≤÷,“«,√«,º€,÷⁄,”≈,ªÔ,ª·,ÿÒ,…°,Œ∞,¥´,…À,ÿˆ,¬◊,ÿ˜,Œ±,ÿ˘,ÃÂ,”‡,”∂,Ÿ›,œ¿,¬¬,Ωƒ,’Ï,≤‡,«»,øÎ,Ÿ≠,ŸØ,Ÿ∂,Ÿ±,Ÿ≤,¡©,Ÿ≥,ºÛ,’Æ,«„,ŸÃ,ŸÕ,Ÿ«,≥•,ŸŒ,Ÿœ,¥¢,Ÿ–,∂˘,∂“,Ÿ,µ≥,¿º,πÿ,–À,◊»,—¯, ﬁ,ŸÊ,ƒ⁄,∏‘,≤·,–¥,æ¸,≈©,⁄£,∑Î,≥Â,æˆ,øˆ,∂≥,æª,∆‡,¡π,¡Ë,ºı,¥’,¡›,º∏,∑Ô,ŸÏ,∆æ,ø≠,ª˜,€ ,‘‰,€ª,ªÆ,¡ı,‘Ú,∏’,¥¥,…æ,±,Ñi,ÿŸ,πÙ,ÿ€,ÿ‹,º¡,π–,Ω£,∞˛,æÁ,»∞,∞Ï,ŒÒ,€Ω,∂Ø,¿¯,æ¢,¿Õ, ∆,—´,€¬,Ñ÷,‘»,ÿ–,ÿ—,«¯,“Ω,ª™,–≠,µ•,¬Ù,¬¨,¬±,Œ‘,Œ¿,»¥,⁄·,≥ß,Ã¸,¿˙,¿˜,—π,—·,ÿ«,≤ﬁ,œ·,ÿ…,œ√,≥¯,æ«,ÿÀ,œÿ,»˛,≤Œ,Ö•,Ö¶,À´,∑¢,±‰,–,µ˛,“∂,∫≈,Ãæ,ﬂ¥,”ı,∫Û,œ≈,¬¿,¬,ﬂƒ,∂÷,Ã˝,∆Ù,Œ‚,ﬂº,ﬂΩ,≈ª,ﬂø,ﬂ¬,‘±,ﬂ√,«∫,Œÿ,”Ω,ﬂ«,¡¸,ﬂÃ,ﬂ–,ﬂÂ,ﬂ‘,œÃ,ﬂﬂ,œÏ,—∆,ﬂ’,ﬂÿ,ﬂŸ,ﬂ‹,ª©,ﬂ‡,ﬂ‚,ﬂÊ,”¥,ﬂÈ,Üy,ﬂÎ,Ü|,ﬂÔ,ﬂ,ªΩ,ﬂ¸,ﬂı,ÿƒ,ﬂ˘,ƒˆ,Ü™,ÜÆ,–•,≈Á,‡∂,‡∑,‡ø,‡¿,‡»,–Í,‡”,÷ˆ,‡‡,‡Ë,œ˘,‡Î,Õ≈,‘∞,¥—,Œß,‡,π˙,Õº,‘≤, •,€€,≥°,€‡,ªµ,øÈ,º·,Ã≥,€ﬁ,∞”,ŒÎ,∑ÿ,◊π,¬¢,€‚,€‰,¿›,ø—,€,€—,µÊ,€Î,àô,àõ,€Ó,€Ò,€ı,€˜,€ˆ,€˛,€˚,«µ,∂È,âG,‹´,«Ω,◊≥,…˘,ø«,∫¯,â◊,¥¶,±∏,∏¥,πª,Õ∑,ø‰,º–,∂·,ﬁ∆,€º,∑‹,Ω±,∞¬,◊±,∏æ,¬Ë,Â¸,Â˝,Ê£,Ê©,Ω™,¬¶,Ê´,Ê¨,Ωø,ÊÆ,”È,Ê¥,Êµ,ãO,”§,Êø,…Ù,Ê¡,Ê»,Ê…,ÊÕ,Ê÷,ÀÔ,—ß,¬œ,ƒ˛,±¶, µ,≥Ë,…Û,œ‹,π¨,øÌ,±ˆ,«ﬁ,∂‘,—∞,µº, Ÿ,Ω´,∂˚,≥æ,≥¢,“¢,ﬁœ, ¨,æ°,≤„,å¡,ÃÎ,ΩÏ, Ù,¬≈,Â,”Ï,ÀÍ,∆Ò,·´,∏⁄,·≠,·Æ,·∞,µ∫,¡Î,‘¿,·¥,ø˘,çN,·ª,œø,çi,·Ω,·ø,¬Õ,·¿,·¡,çÅ,’∏,·…,ç¬,·Œ,·–,·’,·€,πÆ,€œ,±“,Àß, ¶,‡¯,’ ,¡±,÷ƒ,¥¯,÷°,∞Ô,‡¸,‡˝,‡˛,√›,·•,∏…,≤¢,Á€,π„,◊Ø,«Ï,¬Æ,‚–,ø‚,”¶,√Ì,≈”,∑œ,éˆ,‚ﬁ,ø™,“Ï,∆˙,’≈,√÷,ÂÚ,Õ‰,µØ,«ø,πÈ,µ±,¬º,è¶,—Â,≥π,æ∂,·‚,”˘,“‰,‚„,”«,‚È,ª≥,Ã¨,ÀÀ,‚‰,‚Ê,‚Í,‚Î,¡Ø,◊‹,Ì°,‚¯,¡µ,ø“,∂Ò,‚˙,‚˚,‚˝,‚¸,ƒ’,„¢,‘√,Ì®,–¸,„•,√ı,æ™,æÂ,≤“,≥Õ,±π,„´,≤—,µ¨,πﬂ,Ì™,„≥,∑ﬂ,„¥,‘∏,…Â,ë\,„¿,ÌØ,¿¡,„¡,Ì∞,Íß,œ∑,Í®,’Ω,ÍØ,ªß,‘˙,∆À,«§,÷¥,¿©,ﬁ—,…®,—Ô,»≈,∏ß,≈◊,ﬁ“,øŸ,¬’,«¿,ª§,±®,µ£,ƒ‚,¬£,º,”µ,¿π,≈°,≤¶,‘Ò,π“,÷ø,¬Œ,í•,ŒŒ,Ã¢,–Æ,ƒ”,µ≤,ﬁÿ,’ı,º∑,ª”,í¶,¿Ã,À,ºÒ,ªª,µ∑,æ›,ƒÌ,¬∞,ﬁ‚,÷¿,µß,≤Ù,ﬁË,ﬁÍ,¿ø,ﬁÏ,≤Û,∏È,¬ß,Ω¡,–Ø,…„,ﬁÛ,∞⁄,“°,±˜,ÃØ,ﬁ¸,≥≈,ƒÏ,ﬂ¢,ﬂ£,ﬂ•,À”,‘‹,µ–,¡≤, ˝,’´,Ïµ,∂∑,’∂,∂œ,Œﬁ,æ…, ±,øı,ïD,Íº,÷Á,ïo,œ‘,Ω˙,…π,œ˛,Í ,‘Œ,ÍÕ,‘›,Í”,‘˝, ı,∆”,ª˙,…±,‘”,»®,Ãı,¿¥,—Ó,Ëø,Ω‹,º´,ππ,Ë», ‡,‘Ê,Ë¿,Ë≈,Ë«,«π,∑„,Ë…,πÒ,ƒ˚,Ëﬂ,ËŸ,’§,±Í,’ª,ËŒ,Ë–,∂∞,Ë”,Ë›,¿∏, ˜,∆‹,—˘,ËÔ,Ë,Ë‚,Ë„,ËÂ,µµ,ËÁ,«≈,ËÎ,ËÌ,Ω∞,◊Æ,√Œ,óÉ,óÖ,ºÏ,Ë˘,È§,Ë¸,Ë˝,È°,Õ÷,¬•,È≠,È¥,Èµ,È∑,òñ,º˜,Èƒ,È∆,∫·,È…,”£,ÈÕ,≥˜,È÷,È⁄,È‹,È›,ª∂,Ï£,≈∑,ºﬂ,È‚,È‰,≤–,ÈÊ,ÈÁ,ÈÈ,ÈÎ,≈π,ªŸ,Ï±,±œ,±–,’±,Îß,Î™,∆¯,«‚,Î≤,Îµ,ª„,∫∫,Œ€,Ã¿,–⁄,Ì≥,πµ,√ª,„„,≈Ω,¡§,¬Ÿ,≤◊,õh,„Ì,ª¶,õm,≈¢,¿·,Ì¥,„Ò,„Ú,„¯,–∫,∆√,‘Û,„˛,Ω‡,»˜,Õ›,‰§,«≥,Ω¨,ΩΩ,‰•,õ∏,◊«,≤‚,‰´,º√,‰Ø,õ∫,ªÎ,‰∞,≈®,‰±,õª,Õø,”ø,ÃŒ,¿‘,‰µ,¡∞,‰∂,Œ–,õÈ,ª¡,µ”,»Û,Ωß,’«,…¨,µÌ,‘®,‰À,◊’,‰¬,Ω•,‰≈,”Ê,‰…,…¯,Œ¬,”Œ,ÕÂ, ™,¿£,Ω¶,‰”,úæ,‰‰,πˆ,÷Õ,‰Ÿ,‰‹,¬˙,‰ﬁ,¬À,¿ƒ,¬–,±ı,Ã≤,ú˘,‰Ì,‰Î,‰Ï,‰Ú,Œ´,«±,‰Û,¿Ω,‰˛,±Ù,Â∞,√,µ∆,¡È,‘÷,≤”,Ïæ,¬Ø,Ï¿,Ïø,Ï¡,µ„,¡∂,≥„,À∏,¿√,Ã˛,÷Ú,—Ã,∑≥,…’,Ï«,ª‚,ÃÃ,Ω˝,»»,ª¿,ÏÀ,Ï‚,Ï—,ÏŒ,Ï’,Ï÷,∞Æ,“Ø,Îπ,ÍÛ,«£,Œ˛,∂ø,ÍÒ,·Î,◊¥,·Ó,·Ô,”Ã,±∑,·Û,™A,ƒ¸,∂¿,œ¡, ®,·ˆ,’¯,”¸,·¯,·˝,¡‘,‚®,‚§,÷Ì,√®,‚¨,œ◊,Ã°,Á·,´_,´`,¬Í,Á‚,ª∑,œ÷,´o,ÁÙ,ÁÎ,ÁÂ,∑©,ÁÁ,´ö,Áı,¨Q,Áˆ,Àˆ,«Ì,—˛,Ë®,ËØ,Ë¨,Ë∂,ŒÕ,Í±,µÁ,ª≠,≥©,Ó¥,≥Î,‹,¡∆,≈±,›,—Ò,ﬂ,¥Ø,∑Ë,Â,‚,”∏,æ∑,—˜,È,Ï,ªæ,Ô,≥’,˜,Ø},˘,¸,±Ò,Ã±,Ò´,Ò®,ÒÆ,—¢,Ò≤,Ò≥,∞®,÷Â,Ò‰,’µ,—Œ,º‡,∏«,µ¡,≈Ã,ÌÓ,Ìˆ,±Ä,◊≈,’ˆ,Ì˘,Ì˙,¬˜,÷ı,Ω√,Ì∂,∑Ø,øÛ,Ì∏,¬Î,◊©,Ì∫,—‚,Ìø,Ì¬,Ì√,¿˘,¥°,≥n,πË,À∂,ÌÃ,ÌÕ,≥},≥~,»∑,ºÔ,∞≠,Ì”,Ì◊,ºÓ,Ì€,Ìﬁ,¿Ò,µt,ÏÚ,Ïı,µª,ªˆ,Ÿ˜,¬ª,Ï¯,¿Î,Õ∫,∏—,÷÷,ª˝,≥∆,ª‡,∂å,Ô˘,À∞,ˆ’,Œ»,£,«Ó,«‘,«œ,“§,¥‹,Œ—,ø˙,Òº,Ò¿, ˙,æ∫,Û∆,ÀÒ,± ,Û»,º„,¡˝,Û÷,÷˛,ÛŸ,…∏,πY,Û›,≥Ô,«©,ºÚ,πÇ,ÛÂ,ÛÊ,ÛÍ,¬·,ÛÏ,ÛÔ,ÛÒ,¬®,¿∫,¿È,Û˝,Ù•,Ÿ·,¿‡,ÙÃ,Ù–,Ùœ,‘¡,∑‡,¡∏,Ù÷,Ù◊,ΩÙ,ÙÍ,Ê˘,æ¿,Ê˙,∫Ï,Ê˚,œÀ,Ê¸,‘º,º∂,Ê˝,Ê˛,ºÕ,»“,Œ≥,Á°,¿Ä,¥ø,Á¢,…¥,∏Ÿ,ƒ…,¿Å,◊›,¬⁄,∑◊,÷Ω,Œ∆,∑ƒ,¿Ç,¿É,≈¶,Á£,œﬂ,Á§,Á•,Á¶,¡∑,◊È,…,œ∏,÷Ø,÷’,Áß,∞Ì,Á®,Á©,…‹,“Ô,æ≠,Á™,∞Û,»ﬁ,Ω·,Á´,»∆,¿Ñ,Á¨,ªÊ,∏¯,—§,Á≠,¬Á,æ¯,Ω ,Õ≥,ÁÆ,ÁØ,æÓ,–Â,¿Ö,ÀÁ,Ã–,ºÃ,Á∞,º®,–˜,Á±,¿Ü,–¯,Á≤,Á≥,¥¬,Á¥,Áµ,…˛,Œ¨,√‡,Á∑,±¡,≥Ò,¿á,Á∏,Áπ,◊€,’¿,Á∫,¬Ã,◊∫,Áª,Áº,ÁΩ,ºÍ,√Â,¿¬,Áæ,Áø,º©,¿à,Á¿,Á¡,Á∂,∂–,Á¬,¿â,Á√,Áƒ,ª∫,µﬁ,¬∆,±‡,Á≈,‘µ,Á∆,∏ø,Á»,Á«,∑Ï,¿ä,Á…,≤¯,Á ,ÁÀ,ÁÃ,ÁÕ,ÁŒ,Áœ,Á–,”ß,Àı,Á—,Á“,Á”,Á‘,……,Á’,Á÷,Á◊,Áÿ,ÁŸ,Ω…,Á⁄,Ûø,Õ¯,¬ﬁ,∑£,∞’,Óº,Óø,Ù«,œ€,«Ã,¡ô,¡ö,ÒÏ,ÒÔ,À ,≥‹,ƒÙ,¡˚,÷∞,Ò˜,¡™,Ò˘,¥œ,À‡,≥¶,∑Ù,Î…,…ˆ,÷◊,’Õ,–≤,µ®, §,Î ,ÎÀ,ÎÕ,Î÷,Ω∫,¬ˆ,Î⁄,‘‡,∆Í,ƒ‘,≈ß,Ÿı,Ω≈,Õ—,Î·,¡≥,¿∞,ÎÁ,ƒN,ÎÒ,ƒÂ,ÎÔ,Î,Ã⁄,Î˜,≈H,”ﬂ,ÙØ,Ω¢,≤’,Ùµ,ºË,—ﬁ,‹≥,“’,Ω⁄,ÿ¬,‹º,Œﬂ,¬´,‹ ,Œ≠,‹¬,‹»,‹…,≤‘,‹—,À’,‹‹,∆ª,æ•,‹◊,‹‡,‹„,‹‰,ºÎ,æ£,ºˆ,«Q,º‘,‹È,‹Í,‹Ò,‹ˆ,‹˘,µ¥,»Ÿ,ªÁ,‹˛,‹˝,”´,›°,›£,›•,“Ò,›§,›¶,›ß,“©,›∞,›Ø,¿≥,¡´,›™,›´,›≤,ªÒ,›µ,”®,›∫,›ª,»[,¬‹,”©,”™,›”,œÙ,»¯,¥–,›€,›ﬁ,ΩØ,›‰,¿∂,ºª,›Ò,›˜,›ˆ,›Î,«æ,›¸,›˛,∞™,ﬁ≠,‘Ã,ﬁ¥,ﬁª,ﬁ∫,¬≤,¬«,–È,≥Ê,Ú∞,Ú±,À‰,œ∫,Ú≤, ¥,“œ,¬Ï,≤œ,Ú∫,Úπ,π∆,Ú√,Ú…,¬˘,’›,ÚÃ,ÚÕ,Úœ,Ú”,Õ…,Œœ,¿Ø,”¨,ÚÂ,≤ı,–´,Ú˜,ÚÓ,ŒÖ,Ú˝,œ],–∆,œŒ,≤π,≥ƒ,ŸÚ,∞¿,Ù¡,–Ñ,Õ‡,œÆ,—B,◊∞,Ò…,—T,ÒÕ,Òœ,ø„,Ò–,Ò⁄,Ò‹,Òﬂ,“[,º˚,π€,”_,πÊ,√Ÿ, ”,ÍË,¿¿,æı,ÍÈ,ÍÍ,ÍÎ,”`,ÍÏ,ÍÌ,ÍÓ,ÍÔ,ı¸,¥•,ˆ£,‘Ä,”˛,Ã‹,⁄•,º∆,∂©,∏º,»œ,º•,⁄¶,⁄ß,Ã÷,»√,⁄®,∆˝,—µ,“È,—∂,º«,◊ö,Ω≤,ª‰,⁄©,⁄™,—»,⁄´,–Ì,∂Ô,¬€,◊õ,Àœ,∑Ì,…Ë,∑√,æ˜,÷§,⁄¨,⁄≠,∆¿,◊Á, ∂,◊ú,’©,Àﬂ,’Ô,⁄Æ,÷ﬂ,¥ ,⁄∞,⁄Ø,◊ù,“Î,⁄±,⁄≤,⁄≥, ‘,⁄¥, ´,⁄µ,⁄∂,≥œ,÷Ô,⁄∑,ª∞,µÆ,⁄∏,⁄π,πÓ,—Ø,“Ë,⁄∫,∏√,œÍ,≤Ô,⁄ª,⁄º,◊û,ΩÎ,Œ‹,”Ô,⁄Ω,ŒÛ,⁄æ,”’,ªÂ,⁄ø,Àµ,À–,⁄¿,«Î,÷Ó,⁄¡,≈µ,∂¡,⁄¬,∑Ã,øŒ,⁄√,⁄ƒ,À≠,⁄≈,µ˜,⁄∆,¡¬,◊ª,⁄«,Ã∏,“Í,ƒ±,⁄»,µ˝,ª—,⁄…,–≥,⁄ ,⁄À,ŒΩ,⁄Ã,⁄Õ,⁄Œ,≤˜,⁄—,⁄œ,—Ë,⁄–,√’,⁄“,◊†,⁄”,⁄‘,⁄’,–ª,“•,∞˘,⁄÷,«´,⁄◊,Ω˜,√°,⁄ÿ,⁄Ÿ,√˝,Ã∑,⁄⁄,⁄€,¿æ,∆◊,⁄‹,⁄›,«¥,⁄ﬁ,⁄ﬂ,π»,ÿk,±¥,’Í,∏∫,⁄O,π±,≤∆,‘,œÕ,∞‹,’À,ªı,÷ ,∑∑,Ã∞,∆∂,±·,π∫,÷¸,π·,∑°,º˙,Í⁄,Í€,Ã˘,πÛ,Í‹,¥˚,√≥,∑—,∫ÿ,Í›,‘Ù,Íﬁ,º÷,ªﬂ,Íﬂ,¡ﬁ,¬∏,‘ﬂ,◊ ,Í‡,Í·,Í‰,Í‚,Í„,…ﬁ,∏≥,∂ƒ,ÍÂ, Í,…Õ,¥Õ,⁄P,⁄Q,‚Ÿ,≈‚,ÍÊ,¿µ,⁄R,◊∏,ÍÁ,◊¨,»¸,ÿ”,ÿÕ,‘ﬁ,⁄S,‘˘,…ƒ,”Æ,∏”,⁄W,’‘,∏œ,«˜,Ùı,ıª,‘æ,ıƒ,ı≈,ı»,º˘,€Q,ıŒ,ıœ,ı—,ı“,”ª,≥Ï,◊Ÿ,ıŸ,ı‹,ıÊ,ıÁ,ıÈ,¥⁄,ıÔ,ıÚ,«˚,≥µ,‘˛,πÏ,–˘,ﬁa,ÈÌ,◊™,ÈÓ,¬÷,»Ì,∫‰,ÈÔ,È,ÈÒ,÷·,ÈÚ,ÈÛ,Èı,ÈÙ,Èˆ,È˜,«·,È¯,‘ÿ,È˘,ΩŒ,ﬁb,È˙,È˚,Ωœ,È¸,∏®,¡æ,È˝,±≤,ª‘,πı,È˛,ﬁc,Í°,Í¢,Í£,∑¯,º≠,ﬁd, ‰,‡Œ,‘Ø,œΩ,’∑,Í§,’ﬁ,Í•,¥«,±Á,±Ë,±ﬂ,¡…,¥Ô,«®,π˝,¬ı,êÅ,ªπ,’‚,Ω¯,‘∂,Œ•,¡¨,≥Ÿ,Â«,Â…,º£,  ,—°,—∑,µ›,ÂŒ,¬ﬂ,“≈,“£,µÀ,⁄˜,⁄˘,” ,◊ﬁ,⁄˛,¡⁄,”Ù,€ß,€£,€¶,÷£,€©,€™,‘«,µ¶,‘Õ,·N,Ω¥,ı¶,ıß,ƒ, Õ,¿Ô,‚†,º¯,ˆ«,ˆ…,Ó≈,Ó∆,’Î,∂§,Ó»,Ó«,Ó…,Ó ,«•,ÓÀ,ÓÃ,Ëï,∑∞,µˆ,ÓÕ,Óœ,Ëñ,ÓŒ,Ëó,∏∆,Ó–,Ó—,∂€,≥Æ,÷”,ƒ∆,±µ,∏÷,Ó”,Ó‘,‘ø,«’,æ˚,ŒŸ,π≥,Ó÷,Ó’,Óÿ,Ó◊,≈•,ÓŸ,Ó⁄,«Æ,Ó€,«Ø,Ó‹,≤ß,Ó›,Óﬁ,Óﬂ,Ó‡,Ó·,◊Í,Ó‚,Ó„,ºÿ,Ó‰,”À,Ã˙,≤¨,¡Â,ÓÂ,«¶,√≠,ÓÊ,ÓÁ,ÓË,ÓÈ,ÓÍ,ÓÎ,ÓÏ,Ëô,ÓÌ,ÓÓ,ÓÔ,Ëö,Ëõ,Ó,ÓÒ,ÓÚ,ÓÙ,ÓÛ,Ëú,Óı,Õ≠,¬¡,Óˆ,Ó˜,Ó¯,’°,Ó˘,œ≥,Ó˙,Ó˚,Ëù,Ó¸,Ó˝,Ô°,Ó˛,Ô¢,∏ı,√˙,Ô£,Ô§,Ω¬,“ø,≤˘,Ô•,Ô¶,Ôß,“¯,Ô®,÷˝,Ô©,∆Ã,Ëû,Ô™,Ô´,¡¥,Ô¨,œ˙,À¯,ÔÆ,Ô≠,≥˙,π¯,ÔØ,Ô∞,–‚,Ô±,Ô≤,∑Ê,–ø,Ô≥,Ô¥,Ôµ,»Ò,Ã‡,Ô∂,Ô∑,Ô∏,Ôπ,Ô∫,’‡,Ôª,¥Ì,√™,Ôº,Ëü,ÔΩ,Ôæ,Ôø,Ë†,Œ˝,Ô¿,¬‡,¥∏,◊∂,Ωı,È@,œ«,Ô√,Ô¡,Ô¬,Ôƒ,∂ß,º¸,æ‚,√Ã,Ô≈,Ô∆,ÈA,Ô«,Ôœ,Ô»,Ô…,Ô ,«¬,ÔÒ,∂Õ,ÔÀ,ÈB,ÔÃ,ÔÕ,∂∆,√æ,ÔŒ,ÈC,Ô–,Ô—,Ô“,’Ú,ÈD,Ô”,ƒ˜,ÈE,Ô‘,ƒ¯,Ô’,Ô÷,∏‰,∞˜,Ô◊,Ôÿ,ÔŸ,ÈF,Ô⁄,Ô€,Ô‹,Ô›,ÈG,Ôﬁ,æµ,Ô·,Ôﬂ,Ô‡,ÈH,Ô‚,Ô„,¡Õ,Ô‰,ÔÂ,ÔÊ,ÔÁ,ÔË,ÔÈ,ÔÍ,ÔÎ,ÔÏ,¿ÿ,ÈI,ÔÌ,¡≠,ÔÓ,ÔÔ,Ô,ÈJ,ÈK,œ‚,≥§,√≈,„≈,…¡,„∆,Í\,±’,Œ ,¥≥,»Ú,„«,œ–,„»,º‰,„…,„ ,√∆,’¢,ƒ÷,πÎ,Œ≈,„À,√ˆ,„Ã,Í],∑ß,∏Û,∫“,„Õ,„Œ,‘ƒ,„œ,Í^,„–,—À,„—,„“,„”,„‘,—÷,„’,≤˚,¿ª,„÷,Í_,¿´,„◊,„ÿ,„Ÿ,Í`,„⁄,„€,Ía,∂”,—Ù,“ı,’Û,Ω◊,º ,¬Ω,¬§,≥¬,⁄Í,…¬,⁄Ì,‘…,œ’,ÀÊ,“˛,¡•,ˆ¡,ƒ—,≥˚,ˆ≈,ˆ®,ŒÌ,ˆ´,√π,ˆ∞,ˆ¶,æ≤,ÿÃ,˜≤,˜≥,˜µ,˜π,Œ§,»Õ,ÌÇ,∫´,Ë∏,Ëπ,Ë∫,‘œ,“≥,∂•,«Í,Ò¸,œÓ,À≥,–Î,ÁÔ,ÕÁ,πÀ,∂Ÿ,Ò˝,∞‰,ÀÃ,Ò˛,‘§,¬≠,¡Ï,∆ƒ,æ±,Ú°,º’,ÔF,Ú¢,Ú£,ÔG,Ú§,“√,∆µ,ÔH,Õ«,Ú•,ÔI,”±,ø≈,Ã‚,ÔJ,Ú¶,Úß,—’,∂Ó,Ú®,Ú©,µﬂ,Ú™,Ú´,ÔK,≤¸,Ú¨,Ú≠,»ß,∑Á,Ôr,Ôs,Ï©,Ï™,Ï´,Ôt,Ï¨,Ôu,Ôv,∆Æ,Ï≠,ÏÆ,∑…,˜œ,˜–,ó,º¢,ò,‚º,‚Ω,‚æ,‚ø,‚¿,‚¡,∑π,“˚,Ω§, Œ,±•,À«,ô,‚¬,∂¸,»ƒ,‚√,ö,õ,Ω»,ú,±˝,‚ƒ,ù,∂ˆ,‚≈,ƒŸ,û,ü,‚∆,œ⁄,π›,‚«,¿°,†,‚»,≤ˆ,Ò@,‚…,ÒA,¡Û,‚ ,‚À,¬¯,‚Ã,‚Õ,‚Œ,¬Ì,‘¶,Õ‘,—±,≥€,«˝,ÛR,≤µ,¬ø,Ê‡, ª,Ê·,Ê‚,æ‘,Ê„,◊§,Õ’,ÊÂ,º›,Ê‰,ÊÊ,ÊÁ,¬Ó,ÛS,Ωæ,ÊË,¬Ê,∫ß,ÊÈ,ÛT,ÊÍ,≥“,—È,ÛU,ÛV,ø•,ÊÎ,∆Ô,ÊÏ,ÊÌ,ÛW,ÛX,ÊÓ,∆≠,ÊÔ,ÛY,…ß,Ê,ÊÒ,ÊÚ,Âπ,ÊÛ,ÊÙ,¬‚,Êı,Êˆ,÷Ë,Ê˜,ÛZ,Ê¯,˜√,˜≈,˜∆,˜ﬁ,˜ ,˜À,”„,˜Å,˜Ç,ˆœ,˜É,¬≥,ˆ–,˜Ö,ˆ—,ˆ“,ˆ”,ˆ‘,˜Ü,˜á,ˆ÷,˜à,±´,ˆ◊,˜â,ˆÿ,ˆŸ,ˆ⁄,˜ä,ˆ€,ˆ‹,˜ã,˜å,˜ç,˜é,ˆ›,ˆﬁ,œ ,˜è,ˆﬂ,ˆ‡,ˆ·,ˆ‚,ˆ„,ˆ‰,¿,ˆÂ,ˆÊ,ˆÁ,ˆË,ˆÈ,˜ê,ˆÍ,˜ë,ˆÎ,ˆÏ,˜í,ˆÌ,ˆÓ,ˆÔ,ˆ,ˆÒ,ˆÚ,ˆÛ,ˆÙ,æ®,˜ì,ˆı,ˆˆ,ˆ˜,ˆ¯,˜î,˜ï,˜ñ,˜ó,˜ò,»˙,ˆ˘,ˆ˙,ˆ˚,ˆ¸,˜ô,˜ö,ˆ˝,ˆ˛,˜°,˜¢,˜£,˜§,˜•,˜õ,˜ú,˜¶,˜ß,˜®,±Ó,˜©,˜™,˜´,˜û,˜¨,˜≠,¡€,˜Æ,˜ü,˜†,˜Ø,¯@,ƒÒ,Ø,º¶,∞,√˘,˚\,≈∏,—ª,˚],±,≤,≥,¥,µ,—º,˚^,—Ï,˚_,∑,∂,‘ß,˚`,Õ“,∏,∫,π,ª,º,˚a,˚b,∏Î,Ω,∫Ë,˚c,æ,ø,æÈ,¿,∂Ï,¡,¬,√,ƒ,»µ,≈,∆,˚d,«,≈Ù,˚e,»,˚f,˚g,˚h,…,˚i, ,˜Ω,˚j,À,Ã,Õ,˚k,Œ,˚l,˚m,˚n,˚o,œ,∫◊,˚p,–,—,“,”,‘,’,÷,ÿ,˚r,”•,◊,˚s,Ÿ,˚t,ı∫,¬Û,ÙÔ,ª∆,Ÿ‰,¸d,˜Ú,˜ı,ˆº,ˆΩ,¸Ö,ˆæ,ÿª,˜˙,˜˛,∆Î,Ï¥,≥›,ˆ≥,˝Ü,˝á,ˆ¥,¡‰,ˆµ,ˆ∂,ˆ∑,ˆ∏,ˆπ,ˆ∫,»£,ˆª,¡˙,π®,ÌË,πÍ"
 t="»f,≈c,·h,å£,òI,Ö≤,ñ|,Ωz,ÅG,É…,á¿,Ü ,ÇÄ,„›,ÿS,≈R,ûÈ,˚ê,≈e,¸N,¡x,ûı,ò∑,ÜÃ,¡ï,‡l,ï¯,ŸI,Åy,†é,Ï∂,Ãù,ÎÖ,ÅÉ,ÅÜ,Æa,ÆÄ,”H,“C,áæ,É|,ÉH,èƒ,Åˆ,Ç},Éx,ÇÉ,Ér,±ä,Éû,‚∑,ï˛,Ç¯,Ç„,Ç•,Ç˜,Ç˚,Çt,Çê,Ç·,ÇŒ,Å–,Ûw,N,ÇÚ,ÉL,Çb,ÇH,Ée,Ç…,Ç»,ÉS,É~,Éä,Éz,ÇR,Éâ,É∞,Çz,É´,ÉÄ,Ç˘,ÉA,ÇÙ,ÉE,Éf,Éî,ÉØ,ÉÜ,É¶,ÉÆ,É∫,É∂,Éº,¸h,Ãm,ÍP,≈d,∆ù,B,´F,áœ,É»,å˘,É‘,åë,‹ä,ﬁr,âV,ÒT,õ_,õQ,õr,Éˆ,úQ,úD,õˆ,úR,úp,úê,ÑC,é◊,¯P,¯D,ë{,ÑP,ìÙ,öÎ,Ëè,∆c,Ñù,Ñ¢,Ñt,ÑÇ,Ñì,Ñh,Ñe,Ñ},Ñq,Ñ£,Ñ•,Ñí,Ñ©,Ñé,Ñ¶,ÑÉ,Ñ°,ÑÒ,ﬁk,Ñ’,ÑÍ,Ñ”,ÑÓ,Ñ≈,Ñ⁄,Ñ›,ÑÏ,√Õ,Ñ„,ÑÚ,ÖQ,ÖT,Ö^,·t,»A,Öf,ÜŒ,Ÿu,±R,˚u,≈P,–l,Ös,éÑ,èS,èd,ï—,Öñ,â∫,Öí,Öá,é˙,é˚,Öò,èB,èN,é˝,èP,øh,»˝,Ö¢,Ïa,Ï^,Îp,∞l,◊É,î¢,ØB,»~,Ãñ,öU,á\,ªn,··,áò,ÖŒ,Ü·,Üw,áç,¬†,Ü¢,Ö«,á`,á“,áI,á≥,Üh,ÜT,ÜJ,Ü‹,ÜË,‘Å,ÜU,áµ,áì,áz,ﬂ∏,áj,˚y,ﬂ…,Ìë,Ü°,á},á^,ÜÙ,áÇ,áW,áà,áù,áÅ,Ü—,áO,Üﬂ,áZ,Ü§,ÜÓ,Ür,Üæ,∫Ù,áK,Ü›,á ,˝m,á”,ác,á[,áä,áD,áø,áÀ,∫«,áÜ,áu,á¬,á⁄,á£,≈¸,áÃ,÷o,àF,à@,áË,á˙,á˜,á¯,àD,àA,¬},âø,àˆ,⁄Ê,âƒ,âK,à‘,âØ,â»,âŒ,â],âû,âã,â≈,â≈,â¿,âæ,â®,às,à◊,â|,à∫,â°,â≥,âN,àﬂ,âP,â_,àÂ,â|,àù,âq,âô,âœ,‘≠,†ù,â—,¬ï,ö§,âÿ,â⁄,Ãé,Ç‰,—},âÚ,Ó^,’F,äA,äZ,äY,äJ,ä^,™Ñ,äW,äy,ãD,ãå,ã≥,ãû,ãÇ,äô,ÀK,ä‰,ãI,ã∆,ã…,åD,ä ,ãz,ãπ,ãΩ,ãÎ,ã»,ã,ãã,ã‹,ãÂ,ã‘,ãﬂ,åO,åW,å\,åé,åö,åç,åô,åè,ëó,åm,åí,Ÿe,åã,å¶,å§,åß,â€,å¢,†ñ,âm,áL,àÚ,å¿,å∆,±M,å”,å⁄,åœ,å√,åŸ,å“,å’,éZ,öq,ÿM,çÁ,çè,çs,éS,çπ,çu,éX,é[,çñ,éh,éG,éF,ç{,éA,ç˛,çò,én,ç˜,çà,éM,ç‰,éV,çÙ,ç£,ç‚,ºπ,ép,Ïñ,éÄ,é≈,éõ,éü,éÆ,é§,∫ü,é√,éß,é¨,éÕ,éŒ,éæ,éΩ,ÉÁ,“L,é÷,ÅK,√¥,èV,«f,ëc,è],èT,éÏ,ë™,èR,˝ã,èU,èF,è[,È_,Æê,óâ,èà,èõ,èÜ,èù,èó,èä,öw,Æî,‰õ,èß,è©,èÿ,èΩ,è∆,∂R,ëõ,ë‘,ën,ê˜,ë—,ëB,ëZ,ëì,ëY,êù,êÌ,ëz,øÇ,ëª,ë´,ëŸ,ë©,ê∫,ëQ,ë√,ê,ê≈,ê¿,ê¡,êÇ,ê‚,ë“,ëa,ëë,Û@,ë÷,ëK,ëÕ,ëv,ê‹,ëM,ëÑ,ëT,ú°,ëC,ëç,ë|,Óä,ëÿ,ëÄ,‚,ëø,ë–,ë¨,ëﬂ,ë‚,ëÚ,ëÍ,ë,ëÏ,ëÙ,ºô,ì‰,íL,àÃ,îU,í–,íﬂ,ìP,î_,ì·,íÅ,ìª,ì∏,í‡,ìå,◊o,àÛ,ì˙,îM,în,í˛,ìÌ,îr,îQ,ì‹,ìÒ,íÏ,ì¥,îÅ,íÈ,ìÎ,ìÈ,í∂,ìœ,ìı,ì◊,íÍ,îD,ì],ìÕ,ì∆,ìp,ìÏ,ìQ,ìv,ì˛,ì”,ìÔ,ìù,îS,ì€,ìΩ,ì•,ì´,îà,ìÂ,îv,îR,ìß,îá,îy,îz,îd,î[,ìu,îP,îÇ,ît,ìŒ,îf,îX,î],îx,î\,îÄ,î≥,îø,îµ,˝S,îÃ,ÙY,îÿ,î‡,üo,≈f,ïr,ïÁ,ï™,ï“,ïÉ,ïÓ,Ô@,ïx,ïÒ,ï‘,ïœ,ïû,ïü,ï∫,ï·,Ñû,–g,ò„,ôC,ö¢,Îs,ô‡,ól,ÅÌ,óÓ,òq,Ç‹,òO,òã,ò∫,ò–,óó,ô¿,óg,óñ,òå,ó˜,ón,ôô,ôé,ôf,ód,ñ≈,òÀ,ó£,ô±,ô…,óù,ôæ,ôµ,ô⁄,ò‰,ó´,ò”,ôË,ó®,óø,òÔ,òE,ôn,òÅ,òÚ,òÂ,ôu,ò™,ò∂,âÙ,ôÑ,óÆ,ôz,ôÙ,ò°,ô≥,ò†,ôÂ,ôE,ò«,ôÏ,ô¬,ô∞,ôŒ,ôx,ôë,ôâ,ôΩ,ôM,ô{,ô—,ô¡,ôª,ô©,ô¥,∫ô,ô_,ög,öe,öW,öû,ö{,öë,öà,öå,öö,öó,öõ,ö™,öß,›û,ÆÖ,î¿,ö÷,ö–,ö⁄,ö‚,ö‰,öÂ,öË,è°,ùh,õ@,ú´,õ∞,ﬂe,úœ,õ],ûñ,ùa,ûr,úS,úÊ,út,úø,ú˚,ù,ùÙ,úI,ùÕ,û{,ûo,ûT,ûa,ùä,ù…,õ‹,ùç,û¢,∏D,õ—,ú\,ù{,ù≤,úù,ú€,ù·,úy,ù“,ù˙,ûg,ùI,úÜ,ùG,ù‚,ù°,ù¯,âT,ú•,ù˝,ù≥,úZ,ùi,ù¨,úu,ú›,úo,úÏ,ùô,ùæ,ùq,ù≠,ù’,úY,úO,ùn,û^,ùu,ù∆,ùO,ûc,ùB,úÿ,ﬂ[,û≥,ùÒ,ù¢,ûR,ùs,ùU,ùß,ùL,ú˛,ûπ,ûó,ùM,û],ûV,ûE,û¥,ûI,û©,ùÀ,ûE,ûu,ût,ûá,ûH,ùì,ûz,ûë,û|,ûl,ûÆ,úÁ,üÙ,Ï`,ûƒ,†N,ü¨,†t,üı,üò,üÕ,¸c,üí,üÎ,†q,†Ä,üN,†T,üü,ü©,ü˝,üÓ,†Z,†C,†a,ü·,ü®,†F,†c,üè,∫˝,ÕÀ,¡Ô,ê€,†î,†©,†”,†ø,†ﬁ,†Ÿ,èä,»Æ,†Ó,´E,™w,™q,™N,˚É,™û,™ü,™ö,™M,™{,™ú,™b,™z,™s,™ù,´C,´J,´M,ÿi,ÿà,Œo,´I,´H,≠^,≠m,¨Ñ,¨î,¨|,≠h,¨F,¨ö,≠t,¨z,´k,¨m,≠á,≠c,¨q,≠\,≠I,¨ç,≠Ç,¨é,≠a,≠v,≠ã,≠ë,ÆY,ÆT,Îä,Æã,ï≥,Ÿ‹,Æ†,∞X,Øü,Øë,∞O,ØÉ,Ûú,Øè,ØÇ,∞í,ÂÌ,∞b,Ød,∞W,Ø{,∞A,Øà,∞B,∞V,∞D,Øî,Øé,Øõ,∞T,∞c,∞a,∞`,∞],∞_,∞d,ƒü,∞},∞ô,∞ó,±K,˚},±O,…w,±I,±P,≤g,±{,≤î,÷¯,±†,≤A,≤Ä,≤m,≤ö,≥C,¥â,µ\,µV,¥X,¥a,¥u,≥å,≥é,¥^,µZ,µa,µ[,µA,≥Å,Œ˘,¥T,≥à,¥ì,¥o,¥ô,¥_,˚|,µK,¥É,¥~,âA,Ô‡,ùL,∂Y,∂B,∂[,µù,∂\,µú,∑A,µì,∂U,Îx,∂d,∂í,∑N,∑e,∑Q,∑x,∑v,∑Ñ,∂ê,∑d,∑Ä,∑w,∏F,∏`,∏[,∏G,∏Z,∏C,∏Q,∏],∏M,ÿQ,∏Ç,∫V,πS,πP,πa,π{,ª\,ªe,∫B,∫`,∫Y,∫ö,π~,ªI,∫û,∫Ü,ªU,∫j,∫D,ªX,ªj,∫Ñ,∫ç,∫à,∫t,ª@,ªh,ªf,ª[,ºe,Óê,∂i,ºg,ºc,ªõ,ºS,ºZ,ºR,f,æo,ø{,ÙÈ,ºm,ºu,ºt,ºq,¿w,ºv,ºs,ºâ,ºw,¿k,ºo,ºx,æï,ºã,ºá,ºÉ,ºÑ,ºÜ,æV,º{,ºå,øv,æ],ºä,ºà,ºy,ºè,ºü,ºÖ,º~,ºÇ,æÄ,ΩC,ΩX,ºõ,æö,ΩM,ºù,ºö,øó,ΩK,øU,ΩO,ΩE,ΩI,ΩB,¿[,Ωõ,ΩH,Ωâ,Ωq,ΩY,Ωf,¿@,Ωx,ΩW,¿L,Ωo,Ωk,Ω{,Ωj,Ω^,Ωg,Ωy,Ωé,Ωã,ΩÅ,¿C,Ωî,Ωó,Ωd,¿^,Ωê,øÉ,æw,æc,æx,¿m,æ_,æp,æb,æy,æi,¿K,æS,æd,æR,øá,æI,æT,æ^,æJ,æC,æ`,æU,æG,æY,æl,æ~,æ|,æ},æí,¿|,æü,æò,æÉ,øZ,¿D,æå,æE,æÑ,æú,æÄ,æó,øP,æè,æÜ,ø|,æé,æá,æâ,øN,ø`,ød,øb,øp,ø\,øc,¿p,ør,øO,øV,¿_,ø~,øz,øw,¿t,øs,øä,øâ,¿i,øù,øò,øï,Ì\,¿`,¿R,¿Q,¿U,¿y,¿õ,æW,¡_,¡P,¡T,¡`,¡b,¡u,¡w,¬N,¬P,¬E,¬g,¬e,¬ñ,êu,¬ô,√@,¬ö,¬ú,¬ì,¬ò,¬î,√C,ƒc,ƒw,ƒd,ƒI,ƒ[,√õ,√{,ƒë,ÑŸ,ñV,ƒL,≈F,√Ñ,ƒz,√},ƒí,Ûv,ƒö,ƒX,ƒì,≈L,ƒ_,√ì,ƒT,ƒò,≈D,·Z,ƒs,˝|,ƒÅ,Ït,ƒe,Úv,ƒú,≈N,›õ,≈ú,≈û,≈ì,∆A,∆D,ÿW,∆H,Àá,πù,¡d,ÀG, è,ÃJ,…ê,»î,Àû,«{,»O,…n,∆r,ÃK,ôî,ÃO,«o,Ãd, \,âL,ü¶,¿O,«G,À],ÀR,«v, Å,…ú, w,ÀC,Àj, é,òs,»ù,úÓ,†Œ,ü…, n,À|,…p, a, {,»á,»í,Àé,…W,…â,»R,…è,…P,»n,ÀW,´@, ~,¨ì,˙L,…î,ÃE,Ã},Œû,†I,øM, í,À_, [, r, â, Y, V,À{,ÀE,Ãy, ö,Êv,Úá,ÀN,Ã`,ÃA,Ã@,ÃI,ÃN,Àí,È¬,Ã\,Ãî,ë],Ãì,œx,ÕA,œl,Îm,Œr,œä,Œg,œÅ,Œõ,–Q,œñ,Õò,–M,œ†,œ|,–U,œU,Õê,œu,Œá,œì,Õë,ŒÅ,œû,œâ,œX,œs,œê,œN,œî,œQ,œ\,–D,·Ö,„ï,—a,“r,–ñ,“\,ãñ,—ã,“m,“u,“U,—b,“d,—Ç,—û,“c,—ù,“M,“@,“h,øã,“w,“ä,”^,“ç,“é,“í,“ï,“ó,”[,”X,”J,“†,”],”C,”D,”M,”P,”U,”x,”|,”z,◊Ñ,◊u,÷`,”Ö,”ã,”Ü,”á,’J,◊I,”ì,”è,”ë,◊å,”ò,”ô,”ñ,◊h,”ç,”õ,”ï,÷v,÷M,÷é,‘n,”†,‘G,‘S,”û,’ì,‘K,‘A,÷S,‘O,‘L,‘E,◊C,‘b,‘X,‘u,‘{,◊R,‘w,‘p,‘V,‘\,‘g,÷a,‘~,‘x,‘t,‘v,◊g,‘r,’E,’C,‘á,‘ü,‘ä,‘ë,‘ú,’\,’D,‘ñ,‘í,’Q,‘ç,‘è,‘é,‘É,‘Ñ,’ä,‘ì,‘î,‘å,’ü,‘Ç,◊p,’],’_,’Z,’V,’`,’a,’T,’d,’N,’f,’b,’O,’à,÷T,’å,÷Z,◊x,’é,’u,’n,’Ü,’ò,’l,’î,’{,’~,’è,’Å,’r,’Ñ,’x,÷\,÷R,’ô,÷e,÷G,÷C,÷o,÷],÷^,÷@,÷I,÷X,◊ã,÷J,÷O,÷V,÷B,÷i,’õ,’ö,÷É,◊ï,÷q,÷x,÷{,÷r,’û,÷t,÷k,÷î,÷ô,÷Ü,◊v,÷á,◊T,◊P,◊S,◊é,◊V,◊H,◊ó,◊l,◊d,◊è,∑Y,ÿr,ÿê,ÿë,ÿì,ÿí,ÿï,ÿî,ÿü,Ÿt,î°,Ÿ~,ÿõ,Ÿ|,ÿú,ÿù,ÿö,ŸH,Ÿè,ŸA,ÿû,ŸE,Ÿv,ŸS,ŸB,ŸN,ŸF,ŸL,ŸJ,ŸQ,ŸM,ŸR,ŸO,Ÿ\,Ÿó,ŸZ,ŸV,ŸD,ŸU,ŸT,⁄E,ŸY,ŸW,⁄B,Ÿg,Ÿc,Ÿl,Ÿd,Ÿx,ŸÄ,˝V,⁄H,Ÿp,Ÿn,⁄F,Ÿk,Ÿs,Ÿr,Ÿy,Ÿá,Ÿà,Ÿò,Ÿé,Ÿç,Ÿê,Ÿë,⁄I,Ÿù,Ÿö,Ÿõ,Ÿ†,⁄A,⁄M,⁄X,⁄w,⁄s,⁄Ö,⁄é,‹O,‹S,€Ñ,€ï,‹V,€`,‹J,‹E,€ã,‹],‹Q,€x,‹P,€ô,‹W,‹U,‹b,€ò,‹X,‹f,‹k,‹g,‹|,‹á,‹à,‹â,‹é,‹ç,‹ê,ﬁD,‹ó,›Ü,‹õ,ﬁZ,›M,›V,ﬁ_,›S,›T,›W,‹†,›F,ﬁ],›U,›p,›Y,›d,›e,ﬁI,›c,›b,›`,›^,›m,›o,›v,›Ç,›Ö,›x,›Å,›y,›à,›z,›w,›è,›ó,›ã,›ú,›î,ﬁ\,ﬁ@,›†,›ö,ﬁA,ﬁH,ﬁO,ﬁo,ﬁq,ﬁp,ﬂÖ,ﬂ|,ﬂ_,ﬂw,ﬂ^,ﬂ~,ﬂ\,ﬂÄ,ﬂ@,ﬂM,ﬂh,ﬂ`,ﬂB,ﬂt,ﬂÉ,ﬁü,€E,ﬂm,ﬂx,ﬂd,ﬂf,ﬂä,ﬂâ,ﬂz,ﬂb,‡á,‡ó,‡w,‡],‡u,‡í,‡è,Ùd,‡S,‡P,‡î,‡ç,‡i,·B,‡y,‡ê,·j,·w,·u,·â,·á,·Ñ,·å,—Y,Ó“,Ëb,Ëé,ÁY,·è,·ê,·ò,·î,·ì,·ï,·ë,‚Q,‚T,‚A,·ü,‚l,‚C,·û,Â{,‚S,Âê,‚O,‚],‚},‚b,‚Å,‚g,‚n,ÊR,‚c,‰^,‰ì,‚k,‚j,ËÄ,öJ,‚x,Êu,„^,‚Ç,‚[,‚Ä,‚^,‚o,‚Z,‚ï,ÂX,„`,„Q,‚í,¿è,‚é,„O,‚ò,‚ì,„X,Ëç,„f,„g,‚õ,‚ö,‚ô,ËF,„K,‚è,Ëp,„U,„T,‚ã,„C,„B,„G,‚â,‚î,ËI,„o,‰D,„ô,„s,‰Ä,ÂE,‰B,‰Ö,‰e,‰y,Át,„á,ËK,„~,‰X,‰H,„ü,Êz,Âé,„è,„ä,‰b,‰A,„î,Áf,„å,Ê|,„x,„ì,„t,„ë,ÂP,‰C,„q,„û,ÁP,„|,Á|,‰@,„y,„ú,ËT,ÁÑ,‰Å,‰o,Ân,‰à,Êú,ÁH,‰N,Êi,‰á,‰{,‰z,ÂÅ,‰Ü,‰~,Án,‰S,‰s,‰h,‰\,‰ç,Áò,Áô,‰J,‰R,‰Z,‰u,‰|,ÂH,‰ù,ÊN,Âü,Âe,Â^,ÂQ,ÂW,Âu,‰ò,ÂK,Â_,Âa,Âd,Ëå,ÂN,ÂF,Â\,Ëe,Âv,‰ü,Âx,‰û,ÂU,ÂV,ÊI,‰è,Âi,ÂO,Âõ,Â},Â|,ÁI,ÊJ,Âä,Âö,Ê@,ÊR,Âë,Ê},Âñ,ÊD,ÊX,ÂÉ,ÊV,ÁU,Êt,Áö,Ê[,Êü,ÊÇ,Ên,Êk,Ëá,Ëí,Áù,Êá,Êì,Êy,ÊÄ,Ê^,ÊÑ,Êâ,Ë\,Êg,ÁS,ÁM,ÁN,Ê†,Áa,ÁO,ÁR,ÁC,Êó,Êõ,ÁB,ÁÜ,Ëë,ÁÇ,Áh,Ëu,ÁÖ,Ë|,Áí,Ëâ,Áj,Áã,ËZ,ËD,ËG,ËC,Á†,ËO,Ëd,Ës,Ën,ËÅ,ËÇ,ÈL,ÈT,ÈV,ÈW,ÈZ,È\,È],Üñ,ÍJ,Èc,Èù,Èe,Èb,Èg,Èh,È`,êû,Èl,Ù[,È|,¬Ñ,ÍY,È},ÈÇ,ÍG,Èy,Èw,Èu,ÈÄ,Ùb,ÈÜ,ÈÅ,ÍA,Èì,Èé,Èã,Ù],Èî,Èí,Èê,Èë,ÍU,Í@,Èò,ÍT,Èü,È†,ÍH,ÍD,ÍF,ÍI,ÍR,ÍX,Í†,Íñ,Íé,Íá,ÎA,ÎH,Íë,Î],Íê,ÍÄ,ÍÑ,Íü,ÎE,ÎU,ÎS,Î[,Î`,Îh,Îy,Îr,◊á,ÏZ,ÏF,ÏV,¸q,Ï\,Ïn,Ïo,Ïv,Ì^,ÌX,Ìd,Ìx,Ìf,Ìg,Ìh,Ìn,Ìt,Ìy,Ìw,Ìç,Ìì,Ìî,Ìï,Ìô,Ìó,Ìò,Ìö,Ìú,ÓB,Óô,ÓD,Ì†,ÓC,Ìû,Ó@,ÓA,ÔB,ÓI,ÓH,Ói,ÓR,Óa,Óc,ÓM,ù},ü‚,ÓW,ÓU,Ól,Ó_,Ój,Óh,Óe,∑f,Ów,Ó},ÓÑ,ÓÄ,ÓÖ,ÓÅ,Ó~,ÔD,Óî,Óç,Óã,Óó,¿h,Óù,Óû,ÔA,ÔE,ÔL,Ô^,ÔQ,ÔR,ÔS,ÔZ,Ô\,Ô`,Ô_,Ôd,Ôh,Ôj,Ôj,Ôw,ã,ê,Ô},á,ÔÄ,h,ÔÇ,q,ÔÉ,ÔÑ,ÔÜ,Ôà,Ôã,T,Ôó,Ôñ,Ôï,Ôò,Ôç,D,à,A,Ôù,E,Ôú,F,Ôû,G,L,I,N,H,K,R,Q,W,^,l,Å,k,t,í,v,x,o,s,},~,z,Ä,Ç,ñ,ÒR,ÒS,ÒW,ÒZ,ÒY,Úå,Ò_,Òg,ÛH,Òz,ÒÇ,ÒÜ,ÒÄ,Òx,Ú|,Òv,ÒÑ,Òw,Ò{,ÛA,Ò~,Úî,¡R,Òó,Úú,Úë,Òò,Òî,Òâ,ÛQ,ÛP,ÚG,Úû,ÚH,Òü,ÚE,ÚU,ÚT,ÚS,ÚK,ÚR,Úì,Úâ,Ú_,Ús,Új,Ú},Ú\,Úà,Út,Úq,Ú~,Úä,ÚÖ,Úã,Úñ,ÛE,ÛK,ÛL,ÛJ,Ût,Ûy,Ûx,ÙW,Ù|,Ùu,Ù~,ÙÄ,Ùá,Ùú,Ùç,Ùî,Ùô,Ùü,ıE,ıG,ˆT,˜|,ıO,ıW,ıV,ıN,ıU,˜c,ıQ,ıT,ıq,ı^,ıw,ın,ıb,ıj,ˆf,ı`,˜d,˜q,ıo,ır,ı~,ıú,˜\,ıÜ,˜~,ˆñ,ˆû,ıé,ˆà,ˆú,ıÖ,ıè,ıå,ız,ˆa,ıó,ıõ,ˆN,ıö,ˆO,ˆE,ˆH,ˆK,ˆA,ˆF,ˆT,ı†,ˆL,ˆY,ˆX,ıô,˜a,ˆl,ˆs,˜l,ˆ[,ˆì,ˆg,ˆw,˜{,ˆq,ˆv,ˆm,ˆe,˜F,ˆc,ˆÖ,¸Å,ˆí,ˆç,ˆä,ˆé,ˆÑ,ˆÅ,ˆò,˜B,˜L,˜M,ˆ†,ˆö,˜I,˜@,˜Z,˜X,˜[,˜V,˜s,˜h,˜k,˜g,¯B,¯F,Îu,¯S,¯Q,¯O,˙t,¯f,˙I,¯d,¯c,¯Å,˘Ö,˚R,¯Ü,¯{,¯Ñ,¯o,¯|,¯z,¯x,¯ä,¯r,˙É,˙v,¯ç,¯é,¯†,¯í,˘@,¯ù,˚[,¯ô,˘M,˘P,˚Z,˘N,˘],˘Z,˘O,˙ë,˘Y,˘^,˘o,˘ë,˘g,˙A,˘l,˘i,˘k,˘á,˘à,˘t,˙â,˘ñ,˘ü,˘ò,˙X,˘î,˙\,˙B,˙F,˙g,˙_,˙O,˙V,˙W,˙^,˙Y,˙Q,˙s,˚W,˙p,˙w,˙ç,˙Ñ,˙ê,˙ñ,˙ò,˚D,˙ó,˚I,˚L,˚X,˚U,˚z,˚ú,˚ü,¸S,¸Z,¸s,¸t,¸o,¸w,¸x,¸{,¸É,Ïä,˝B,˝O,˝R,˝W,˝X,˝Z,˝[,˝],˝e,˝g,˝_,˝f,˝b,˝l,˝r,˝p,˝x,˝},˝à,˝è,˝ê,˝î"
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
if domain_name="" then url_return "«ÎÃÓ–¥≤È≤È—Øµƒ”Ú√˚",-1
suffix=replace(suffix," ","")
splitsuffix=split(suffix,",")

dim BadStr,ActStr,UnRegStr
dim sBadStr,sActStr,sUnRegStr
conn.open constr

for each sufname in splitsuffix
  if sufname=".tv" then
	mydomain=domain_Name
			if netcnwhois(mydomain,trim(sufname))="100" then
			ActStr=ActStr&domain_Name_ok&sufname&"|"  '≤È—Ø≥…π¶-ø…◊¢≤·
			else
				UnRegStr=UnRegStr&domain_Name_ok&sufname&"|"  '≤È—Ø≥…π¶-≤ªø…◊¢≤·

			end if
  elseif sufname=".cc" then
	        mydomain=domain_Name
			if netcnwhois(mydomain,trim(sufname))="100" then
			ActStr=ActStr&domain_Name_ok&sufname&"|"  '≤È—Ø≥…π¶-ø…◊¢≤·
			else
				UnRegStr=UnRegStr&domain_Name_ok&sufname&"|"  '≤È—Ø≥…π¶-≤ªø…◊¢≤·

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
			ActStr=ActStr&domain_Name_ok&sufname&"|"  '≤È—Ø≥…π¶-ø…◊¢≤·

			else
					UnRegStr=UnRegStr&domain_Name_ok&sufname&"|"  '≤È—Ø≥…π¶-≤ªø…◊¢≤·

			end if
         
		elseif Return="-100" or Return_big="-100" then
			UnRegStr=UnRegStr&domain_Name_ok&sufname&"|"  '≤È—Ø≥…π¶-≤ªø…◊¢≤·
		else
			BadStr=BadStr&domain_Name_ok&sufname&"|"  '≤È—Ø ß∞‹
		end if

  end if
next

function GetReturn(d_name,sufx)'–¬Õ¯
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

function GetReturn2(d_name)'…ÃŒÒ÷–π˙
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
function netcnwhois(Byval Domain,sufx)'ÕÚÕ¯
'’‚∏ˆ «ÕÚÕ¯µƒµ•Ãı≤È—Øµƒ
	Domain=punycode(Trim(Domain))
	
	TakenHTML = GetURL("http://panda.www.net.cn/cgi-bin/check.cgi?area_domain=" & Domain & trim(sufx))
	if instr(TakenHTML,"210") then
		netcnwhois="100"
	else
		netcnwhois="-100"
	end if
	TakenHTML=""
	

end function

function nowcnwhois(Byval Domain,sufx)' ±¥˙ª•¡™
	
	Domain=punycode(Domain)

	TakenHTML = GetURL("http://now.net.cn/domain/domaincheck.php?query="&trim(Domain)&trim(sufx))
	if instr(TakenHTML,"πßœ≤")>0 then
		    nowcnwhois="100"
	else
			if instr(TakenHTML,"“—±ª")>0 then
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
        <td width="93%" class="14pxfont"><strong><font color="#669966">“‘œ¬”Ú√˚ø…“‘◊¢≤·</font></strong></td>
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
        <input name="allregsub" type="button" class="app_ImgBtn_Big" value="≈˙¡ø◊¢≤·" onClick="return doallsub(this.form)">
        </td></tr>
        <tr><td height="1" background="/Template/Tpl_01/images/sens_mainbg2.gif"></td></tr>
        </form>
      </table>
      <br>
      <table width="95%" border="0" cellspacing="0" cellpadding="3">
        <tr> 
          <td width="7%" align="center"><img src="/Template/Tpl_01/images/num.gif" width="29" height="20"></td>
          <td width="93%" class="14pxfont"><strong><font color="#CC0000">“‘œ¬”Ú√˚“—æ≠◊¢≤·</font></strong></td>
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
          <td width="93%" class="14pxfont"><strong><font color="#660099">“‘œ¬”Ú√˚≤È—Ø ß∞‹</font></strong></td>
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