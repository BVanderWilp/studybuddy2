$(function() {
	$(document.body).on('click', '#logoutButton', function(){
		$('#logoutForm').submit();
	})
})

$(function() {
	$(document.body).on('click', '#changePriceButton', function(){
		if (isNaN($("#newPrice").val())) {
			$("#info").empty();
			$("#info").html("Error: Your hourly rate needs to be a number.");
		}
		else {
			$('#changePriceForm').submit();
		}
	})
})