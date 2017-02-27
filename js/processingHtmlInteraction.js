var firstHue;
var secondHue;
var compHue;
var firstSatHSB;
var firstBriHSB;
var firstSatHSL;
var firstLumHSL;
var secondSatHSB;
var secondBriHSB;
var secondSatHSL;
var secondLumHSL;
var compSatHSB;
var compBriHSB;
var compSatHSL;
var compLumHSL;
var hueInc;
var satInc;
var briInc;
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
		firstSatHSL = getRandomInt(70, 100);
		firstLumHSL = getRandomInt(40, 60);
		secondSatHSL = firstSatHSL;
		secondLumHSL = firstLumHSL;
		compSatHSL = firstSatHSL;
		compLumHSL = firstLumHSL;
		var HSB = SLtoSB(firstSatHSL, firstLumHSL);
		firstSatHSB = HSB[0];
		firstBriHSB = HSB[1];
		secondSatHSB = firstSatHSB;
		secondBriHSB = firstBriHSB;
		compSatHSB = firstSatHSB;
		compBriHSB = firstBriHSB;
	}
	if(firstHue > secondHue) hueInc = Math.ceil(((360 - firstHue) + (secondHue))/15);
	else hueInc = Math.ceil((secondHue - firstHue)/15);
	satInc = Math.ceil((secondSatHSB - firstSatHSB)/15);
	briInc = Math.ceil((secondBriHSB - firstBriHSB)/15);
	if(init){
		compHue = makeValidHue((firstHue + hueInc * 8) + getRandomInt(160, 200));
		compSatHSL = Math.ceil((firstSatHSL + secondSatHSL)/2);
		compLumHSL = Math.ceil((firstLumHSL + secondLumHSL)/2);
		var compHSB = SLtoSB(compSatHSL, compLumHSL);
		compSatHSB = compHSB[0];
		compBriHSB = compHSB[1];
	}
  	initPicker('grad1_picker', 'grad1_display', firstHue, firstSatHSL, firstLumHSL);
  	initPicker('grad2_picker', 'grad2_display', secondHue, secondSatHSL, secondLumHSL);
  	initPicker('comp_picker', 'comp_display', compHue, compSatHSL, compLumHSL);
  	initPreview('grad_preview');
}

function initPicker(pickerId, displayId, hue, sat, lum){
	var table = document.createElement("table");
	var row = document.createElement("tr");
	for(var i = 0; i < 360; i++){
		var td = document.createElement("td");
		td.setAttribute('hue', i);
		var display = lum;
		if(i == hue) display = 0;
		td.setAttribute('style', 'background-color: hsl(' + i + ',' + sat + '%,' + display +'%);');
		td.addEventListener('click', function(){
			handlePickerClick(this, pickerId, displayId, sat, lum);
		});
		row.appendChild(td);
	}
	table.appendChild(row);
	$('#' + pickerId).empty();
	$('#' + pickerId).append(table);
	$('#' + displayId).attr('style', 'background-color: hsl(' + hue + ',' + sat + '%,' + lum +'%);');
}

function initPreview(previewId){
	var table = document.createElement("table");
	var row = document.createElement("tr");
	var prevHueInc;
	if(firstHue > secondHue) prevHueInc = ((360 - firstHue) + (secondHue))/360;
	else prevHueInc = (secondHue - firstHue)/360;		
	prevSatInc = (secondSatHSL - firstSatHSL)/360;
	prevLumInc = (secondLumHSL - firstLumHSL)/360;
	for(var i = 0; i < 360; i++){
		var td = document.createElement("td");
		td.setAttribute('style', 'background-color: hsl(' + Math.ceil(firstHue+i*prevHueInc) + ',' + Math.ceil(firstSatHSL+i*prevSatInc) + '%,' + Math.ceil(firstLumHSL+i*prevLumInc) +'%);');
		row.appendChild(td);
	}
	table.appendChild(row);
	$('#' + previewId).empty();
	$('#' + previewId).append(table);
}

function handlePickerClick(td, pickerId, displayId, sat, lum){
	var newHue = parseInt(td.getAttribute('hue'));
	var changedGrad = true;
	if(pickerId == 'grad1_picker') firstHue = newHue;
	else if(pickerId == 'grad2_picker') secondHue = newHue;
	else{
		chargedGrad = false;
		compHue = newHue;
	}
	if(changedGrad){
		initPreview('grad_preview');
	}
	initPicker(pickerId, displayId, newHue, sat, lum);
	var processing = Processing.getInstanceById('processing');
	processing.setupChargeToColorMapping(false);
}

