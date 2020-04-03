function Dokey(addkey) { 
var revisedkey; 
revisedkey = addkey; 
document.form1.nkey.value=revisedkey; 
document.form1.nkey.focus(); 
return; }

function Dowriter(addwriter) { 
var revisedwriter; 
revisedwriter = addwriter; 
document.form1.writer.value=revisedwriter; 
document.form1.writer.focus(); 
return; }

function Dowritefrom(addwritefrom) { 
var revisedwritefrom; 
revisedwritefrom = addwritefrom; 
document.form1.writefrom.value=revisedwritefrom; 
document.form1.writefrom.focus(); 
return; }

function Dotitle(addtitle) { 
var revisedtitle; 
revisedtitle = addtitle; 
document.form1.title.value=revisedtitle + document.form1.title.value; 
document.form1.title.focus(); 
return; }
