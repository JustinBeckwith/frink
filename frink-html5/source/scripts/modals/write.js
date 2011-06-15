
/*--------------------------------------------------------------------------
--
-- LOAD EVENTS
--
--------------------------------------------------------------------------*/


$(document).ready(function(e) {
	/**
	 *	show the new post window
	 **/
	$("#btnWritePost").fancybox({
		showCloseButton: false,
	});
	
	/**
	 *	write a new post
	 **/
	$("#btnWrite").live('click', function(e) {
		alert('write new post');
	});
});


/*--------------------------------------------------------------------------
--
-- METHODS
--
--------------------------------------------------------------------------*/


/**
 *	loadWriteTab
 **/
function loadWriteTab() {
	$("#txtWrite").focus();
}

