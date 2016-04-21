$(function() {
	$("#panel").css("margin-top", (window.innerHeight*0.07));
	$("#panel").css("margin-bottom", (window.innerHeight*0.07));
	
	$(document.body).on('click', '#passwordResetSubmit', function(){
		if ($('#studentPassword1').val() == $('#studentPassword2').val()) {
			$('#passwordReset').submit();
		}
		else {
			$('#student-passwords-dont-match').append("Passwords do not match.");
			$('#studentPassword1').val("");
			$('#studentPassword2').val("");
		}
	})
})