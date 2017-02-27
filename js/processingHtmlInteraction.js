var firstHue;
var secondHue;
var globalSatHSB;
var globalBriHSB;
var globalSatHSL;
var globalLumHSL;
var complement;
var increment;
var direction = 1;
var includeComplement = true;

function getRandomInt(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min)) + min;
}

function SBtoSL(s, b) {
	s = s/100;
	b = b/100;
    var l = (2 - s) * b / 2;
    var newS = l&&l<1 ? s*b/(l<0.5 ? l*2 : 2-l*2) : newS;
    l = Math.ceil(l*100);
    newS = Math.ceil(newS*100);
    return [newS, l];
}

function SLtoSB(s, l) {
	s = s/100;
	l = l/100;
    var t = s * (l<0.5 ? l : 1-l);
    var b = l+t;
    var newS = l>0 ? 2*t/b : newS ;
    b = Math.ceil(b*100);
    newS = Math.ceil(newS*100);
    return [newS, b];
}

function makeValidHue(hue){
	if(hue >= 360) return hue-360;
	return hue;
}

function initializeColors(init){
	if(init){
		firstHue = getRandomInt(0, 360);
		secondHue = makeValidHue(firstHue + getRandomInt(120, 160));
		globalSatHSL = getRandomInt(70, 100);
		globalLumHSL = getRandomInt(40, 60);
		var HSL = SLtoSB(globalSatHSL, globalLumHSL);
		globalSatHSB = HSL[0]
		globalBriHSB = HSL[1];
	}
	if(firstHue > secondHue){
		increment = Math.ceil(((360 - firstHue) + (secondHue))/15);
	}
	else if(secondHue > firstHue) increment = Math.ceil((secondHue - firstHue)/15);
	else increment = 0;
	if(init){
		complementHue = makeValidHue((firstHue + increment * 8) + getRandomInt(160, 200));
	}
  	initPicker('grad1_picker', 'grad1_display', firstHue);
  	initPicker('grad2_picker', 'grad2_display', secondHue);
  	initPicker('comp_picker', 'comp_display', complementHue);
  	initPreview('grad_preview');
}

function initPicker(pickerId, displayId, hue){
	var table = document.createElement("table");
	var row = document.createElement("tr");
	for(var i = 0; i < 360; i++){
		var td = document.createElement("td");
		td.setAttribute('index', i);
		var display = globalLumHSL;
		if(i == hue) display = 0;
		td.setAttribute('style', 'background-color: hsl(' + i + ',' + globalSatHSL + '%,' + display +'%);');
		td.addEventListener('click', function(){
			handlePickerClick(this, pickerId, displayId);
		});
		row.appendChild(td);
	}
	table.appendChild(row);
	$('#' + pickerId).empty();
	$('#' + pickerId).append(table);
	$('#' + displayId).attr('style', 'background-color: hsl(' + hue + ',' + globalSatHSL + '%,' + globalLumHSL +'%);');
}

function initPreview(previewId){
	var table = document.createElement("table");
	var row = document.createElement("tr");
	var prevIncrement;
	if(firstHue > secondHue){
		prevIncrement = ((360 - firstHue) + (secondHue))/360;
	}
	else if(secondHue > firstHue) prevIncrement = (secondHue - firstHue)/360;
	else prevIncrement = 0;
	for(var i = 0; i < 360; i++){
		var td = document.createElement("td");
		td.setAttribute('index', i);
		td.setAttribute('style', 'background-color: hsl(' + Math.ceil(firstHue+i*prevIncrement) + ',' + globalSatHSL + '%,' + globalLumHSL +'%);');
		row.appendChild(td);
	}
	table.appendChild(row);
	$('#' + previewId).empty();
	$('#' + previewId).append(table);
}

function handlePickerClick(td, pickerId, displayId){
	var newHue = parseInt(td.getAttribute('index'));
	var changedGrad = true;
	if(pickerId == 'grad1_picker') firstHue = newHue;
	else if(pickerId == 'grad2_picker') secondHue = newHue;
	else{
		chargedGrad = false;
		complementHue = newHue;
	}
	if(changedGrad){
		initPreview('grad_preview');
	}
	initPicker(pickerId, displayId, newHue);
	var processing = Processing.getInstanceById('processing');
	processing.setupChargeToColorMapping(false);
}

