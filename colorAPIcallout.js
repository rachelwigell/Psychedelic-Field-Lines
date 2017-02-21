function getColorsFromAPI(){
	$.ajax(
		{
			url: "http://thecolorapi.com/scheme",
		    jsonp: "callback",
		    dataType: "jsonp",
			data: { 
		        "rgb": seedColor,
		        "mode": "analogic-complement",
		        "count": 17,
		        "format": "json"
		    },
			success: function(result){
				apiColors = result;
				var processing = Processing.getInstanceById('processing');
				processing.setupChargeToColorMapping(true);
    		},
    		error: function(error){
    			var processing = Processing.getInstanceById('processing');
    			processing.setupChargeToColorMapping(false);
    		}

    	}
    );
}