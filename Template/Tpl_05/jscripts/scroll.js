function scrollObject(marqueesHeight, elemId) {
	var stopscroll = false;
	var scrollElem = document.getElementById(elemId);
	with (scrollElem) {
		style.height    = marqueesHeight;
		style.overflow  = 'hidden';
		noWrap          = true;
	}
	scrollElem.onmouseover = function() {
		stopscroll = true;
	}
	scrollElem.onmouseout = function() {
		stopscroll = false;
	}
	var divs = scrollElem.getElementsByTagName('div');
	var scrollmessage1;
	var scrollmessage2;
	if (divs.length > 0) {
		scrollmessage1 = divs[0];
		scrollmessage2 = scrollmessage1.cloneNode(true)
		scrollElem.appendChild(scrollmessage2);
	}
	var currentTop = 0;
	var stoptime   = 0;
	var delaytime  = 120;
	function init_srolltext() {
		scrollElem.scrollTop = 0;
	}
	this.start = function(s, delay) {
		init_srolltext();
		setDelay(delay);
		setInterval(s + '.scrollUp()', 10);
	}
	function setDelay(delay) {
		if (delay > 0) {
			delaytime = delay;
		}
	}
	this.scrollUp = function() {
		if (stopscroll) {
			return;
		}
		currentTop ++;
		if (currentTop == marqueesHeight + 1) {	//øÿ÷∆Õ£¡Ù ±º‰
			stoptime ++;
			currentTop --;
			if(stoptime == delaytime) {
				currentTop = 0;
				stoptime = 0;
			}
		} else {
			if (scrollmessage2.offsetHeight - scrollElem.scrollTop <= 0) {
				scrollElem.scrollTop -= scrollmessage1.offsetHeight;
				scrollElem.scrollTop ++ ;
			}
			else{
				scrollElem.scrollTop ++;
			}
		}
	}
}
if(typeof(queesHeight)=="undefined"){
	var queesHeight=24;
}
var scroll = new scrollObject(queesHeight, 'scrollText');
scroll.start('scroll',200);