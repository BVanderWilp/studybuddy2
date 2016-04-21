$(function() {
	$(document.body).on('click', '#logoutButton', function(){
		$('#logoutForm').submit();
	})
})

// form validation for saving profile information
$(document.body).on('click', '#submit-button', function(){
	if($('#first-name').val().length > 0 && $('#last-name').val().length > 0) {
		if ($('#password').val() == $('#password2').val()) {
			$('#form').submit();
		}
		else {
			$('#passwords-dont-match').append("Passwords do not match.");
			$('#password').val("");
			$('#password2').val("");
		}
	}
})