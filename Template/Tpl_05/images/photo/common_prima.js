/* v3.0.5 */

	/* ---------------- Common Prima UIC operations/ --------------- */
    function ReadCookie ( cookieName )
    {
        var theCookie=""+document.cookie;
        var ind=theCookie.indexOf(cookieName);
        if (ind==-1 || cookieName=="") return "";
        var ind1=theCookie.indexOf(';',ind);
        if (ind1==-1) ind1=theCookie.length;
        return unescape(theCookie.substring(ind+cookieName.length+1,ind1));
    }

    function SetCookie(cookieName,cookieValue,nDays)
    {
        var today = new Date();
        var expire = new Date();
        if (nDays==null || nDays==0) nDays=1;
        expire.setTime(today.getTime() + 3600000*24*nDays);
        document.cookie = cookieName+"="+escape(cookieValue)
                     + ";expires="+expire.toGMTString();
    }

    // every page need a frame like tab highlight feature MUST set following 2 vars in the top of the page
    // number of tabs
    var numberOfTabs = 0;
    // cookie name to store which tab is highlighted
    var tabCookieName = "" ;

    // reqire tab title table and tab content div named like tablink1, tablink2, .... and tabdiv1, tabdiv2, ...
    function doTab ( theHighlightTab )
    {
        if ( numberOfTabs <= 0 )
        {
            return;
        }
        var highlightTab = theHighlightTab;
        // if given tab index number less than 1
        // check first if we get fetch it from cookie
        // if no cookie, assume the first tab is highlighted
        if ( highlightTab < 1 )
        {
            if ( tabCookieName != "" )
            {
                highlightTab = ReadCookie ( tabCookieName ) ;
            }
        }
        if ( highlightTab < 1 )
        {
            highlightTab = 1 ;
        }
        if (document.getElementById)
        {
            for (var f = 1; f < numberOfTabs+1; f++)
            {
                document.getElementById('tabdiv'+f).style.display='none';
                document.getElementById('tablink'+f).className = 'framenormaltable';
            }
            document.getElementById('tabdiv'+highlightTab).style.display='block';
            document.getElementById('tablink'+highlightTab).className = 'frametitletable';
            if ( tabCookieName != "" )
            {
                SetCookie(tabCookieName,highlightTab,1);
            }
        }
    }


	// function and global variable to replace view area after form submit, requires viewPanel div element
	var imgProgressBar = new Image ( ) ;
	imgProgressBar.src = "images/zh-CN/progressbar.gif" ;

	function fn_AfterSubmit ( )
	{
		viewPanel.style.position = "absolute" ;
		viewPanel.style.overflow = "auto" ;
		viewPanel.style.top = document.body.clientHeight/2 ;
		viewPanel.style.left = document.body.clientWidth/2 - 398/2;
		viewPanel.innerHTML = "<table cellspacing='0' cellpadding='0' align='center' valign='middle'><tr><td align='center' valign='middle'><table cellspacing='0' cellpadding='2' style='font-size:9pt;'><tr><td style='border-width:2px; border-style: groove;'><img id='img_progressbar' border='0' width='398' height='4'></td></tr><tr><td style='border-width:0px;' align='center' height='10'></td></tr><tr><td style='border-width:0px; font-family:宋体; font-size: 9pt;' align='center'><b>请求已经发送，请稍候……</b></td></tr></table></td></tr></table>" ;
		img_progressbar.src = imgProgressBar.src ;
	}

    function fn_OpenNewWindow ( strUrl , strWindowName , strTheWindowProperties )
    {
        if ( strTheWindowProperties == "" )
            strWindowProperties = "height=400,width=600,status=yes,toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes";
        else
            strWindowProperties = strTheWindowProperties;
        window.open( strUrl , strWindowName , strWindowProperties ) ;
    }

    function fn_OpenNewWindowReturn ( strUrl , strWindowName , strTheWindowProperties )
    {
        if ( strTheWindowProperties == "" )
            strWindowProperties = "height=400,width=600,status=yes,toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes";
        else
            strWindowProperties = strTheWindowProperties;
        return window.open( strUrl , strWindowName , strWindowProperties ) ;
    }

    function fn_ImageOnMouseOver ( theImage )
    {
        theImage.className = 'imgonmouseover';
    }

    function fn_ImageOnMouseOut ( theImage )
    {
        theImage.className = 'imgonmouseout';

    }

    function fn_ToggleDisplay(theElementID)
    {
        if ( document.getElementById(theElementID) )
        {
            if ( document.getElementById(theElementID).style.display == 'none' )
                document.getElementById(theElementID).style.display = 'block';
            else
                document.getElementById(theElementID).style.display = 'none';
            SetCookie(theElementID,document.getElementById(theElementID).style.display,1);
        }
    }

    function fn_InitDisplay(theElementID)
    {
        if ( document.getElementById(theElementID) && ReadCookie ( theElementID ) )
        {
            document.getElementById(theElementID).style.display = ReadCookie ( theElementID );
        }
    }

    function fn_CheckFeatureLink(objLink,strFTDesc)
    {
        if ( objLink.disabled == 1 )
        {
            alert ( '抱歉，您的系统暂不支持"' + strFTDesc + '"功能！' ) ;
            return false;
        }
        return true;
    }
	/* ---------------- /Common Prima UIC operations --------------- */
