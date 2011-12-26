
/*--------------------------------------------------------------------------
--
-- LOAD EVENTS
--
--------------------------------------------------------------------------*/


$(document).ready(function(e) {
	
	// show/hide screens based on user being logged in or not
	setupUI();
	
	// show the settings window
	$("#btnSettings").fancybox({
		showCloseButton: false,
		onComplete: function(e) {
			if (!isLoggedIn) {
				$("#username").focus();
			} // end else
		}
	});
	
	// swap the UI and raise some events
	$("#btnLogOut").click(function(e) {
		$.fancybox.close();
		isLoggedIn = false;
		logout(logout_Handler);
		localStorage.username = null;
		localStorage.password = null;
	});
	
	/**
	 *	save user settings to the web database from the settings screen
	 **/
	$("#btnSaveSettings").live('click', function(e) {
		localStorage.username = $("#username").val();
		localStorage.password = $("#password").val();
		
		attemptLogin(attemptLogin_Handler, localStorage.username, localStorage.password);
		
		$.fancybox.close();
	});
	
	/**
	 *	close the fancybox when a modal close button is clicked
	 **/
	$(".close-button").live('click', function(e) {
		$.fancybox.close();
		
	});
	
	
});



/*--------------------------------------------------------------------------
--
-- METHODS
--
--------------------------------------------------------------------------*/

/**
 * when the app starts, check to see if the user had previously logged
 * in and left their credentials in the local database
 */
function attemptPreLogin() {
	if (localStorage.username != null && localStorage.password != null) {
		showSpinny($middle);
		attemptLogin(attemptLogin_Handler, localStorage.username, localStorage.password);	
	} // end if
} // end attemptPreLogin


/**
 *	attemptLogin_Handler
 **/
function attemptLogin_Handler(json) {
	
	//var result = JSON.stringify(json);
	isLoggedIn = json.json.errors.length == 0;
	//isLoggedIn = (result.indexOf(".recover-password") == -1); 
	setupUI();
	hideSpinny($middle);
	authChange();

} // end attemptLogin_Handler method

/**
 * logout_Handler
 */
function logout_Handler(json) {
	
	setupUI();
	$("#username").val('');
	$("#password").val('');
	authChange();
	
} // end logout_Handler function

/**
 * tweak the UI based on the user logging in or out
 */
function setupUI() {
	if (isLoggedIn) {
		$("#loggedOut").css('display', 'none');
		$("#loggedUserName").val(localStorage.username);
		$("#loggedIn").css('display','');
	} else {
		$("#loggedIn").css('display','none');
		$("#loggedOut").css('display', '');
	} // end else
} // end setupUI method
