var day="";
var month="";
var ampm="";
var ampmhour="";
var myweekday="";
var year="";
mydate=new Date();
myweekday=mydate.getDay();
mymonth=mydate.getMonth()+1;
myday= mydate.getDate();
myyear= mydate.getYear();
year=(myyear > 200) ? myyear : 1900 + myyear;
if(myweekday == 0)
weekday=" ������ ";
else if(myweekday == 1)
weekday=" ����һ ";
else if(myweekday == 2)
weekday=" ���ڶ� ";
else if(myweekday == 3)
weekday=" ������ ";
else if(myweekday == 4)
weekday=" ������ ";
else if(myweekday == 5)
weekday=" ������ ";
else if(myweekday == 6)
weekday=" ������ ";
document.write(year+"��"+mymonth+"��"+myday+"�� "+weekday);
