$(document).ready(function() {
    window.addEventListener("message", function(event) {
        if (event.data.update == true) {		
			setImageIcon(event.data.url)			
        };  
		if (event.data.display == true){	
			$("#m").html = "";			
			$(".hud").fadeIn();
			$('#ten').html('Tên: ' + event.data.ten);
			$('#id').html('ID: ' + event.data.id);
			$('#lydo').html('Lí Do: ' + event.data.lydo);	
			$('#sao').html('Cấp độ: ' + event.data.sao);		
			$('#m').html('Thời Gian: ' +event.data.m+ ' Phút');									
		}else if (event.data.display == false){
			$(".hud").fadeOut();
		};		
    });	
	function setImageIcon(value){
		$('#photo').attr("src", value);
	} 
});