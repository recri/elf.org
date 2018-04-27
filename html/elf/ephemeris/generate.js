//
// generate header content
// instantiate dynamic elements
//
// var dyn = new Object(), date, tz, H, eph, sunSign;

function generateEphemeris(showChart, showTable, showText) {

  var date_string, date, tz, H, eph, sunSign, m;
  var zodiac = new Object();
  zodiac[0] = 'Aries';			zodiac['Aries'] = 0;
  zodiac[30] = 'Taurus';		zodiac['Taurus'] = 30;
  zodiac[60] = 'Gemini';		zodiac['Gemini'] = 60;
  zodiac[90] = 'Cancer';		zodiac['Cancer'] = 90;
  zodiac[120] = 'Leo';			zodiac['Leo'] = 120;
  zodiac[150] = 'Virgo';		zodiac['Virgo'] = 150;
  zodiac[180] = 'Libra';		zodiac['Libra'] = 180;
  zodiac[210] = 'Scorpio';		zodiac['Scorpio'] = 210;
  zodiac[240] = 'Saggitarius';	zodiac['Saggitarius'] = 240;
  zodiac[270] = 'Capricorn';	zodiac['Capricorn'] = 270;
  zodiac[300] = 'Aquarius';		zodiac['Aquarius'] = 300;
  zodiac[330] = 'Pisces';		zodiac['Pisces'] = 330;

  function generateHead() {
    if (window.location.search != '') {
	  date_string = unescape(window.location.search.substr(6)).replace(/\+/g, ' ');
	  date = new Date(date_string);
	  if (date.toString() == 'Invalid Date') {
		alert(date_string+" decoded to an invalid date!\n"+
	    	  "Switching to current date\n");
		date = new Date();
		date_string = ""+date;
	  }
    } else {
	  date = new Date();
	  date_string = ""+date;
    }
    tz = date.getTimezoneOffset()/60;
    H = date.getHours() + tz + ((date.getMinutes() + date.getSeconds()/60) / 60);
    eph = new Ephemerides(date.getFullYear(), date.getMonth()+1, date.getDate(), H);
    sunSign = Math.floor(eph.Sun.lonecl/30)*30;
    images['Extra'] = images[zodiac[sunSign]];
   	for (var i = 0; i < 13; i += 1) {
	  var sign = (360 + sunSign-(i*30)) % 360;
	  images['c'+i] = images['Star'+sign];
   	}
  }

  //
  // generate body content
  //
  function generateChart() {

	// define the location
	var left = 0;
	var top = 0;
	var height = 120;

	// where does the sun go
	var sunx = left+2*(30-(eph.Sun.lonecl-sunSign));
	var suny = top+height/2;

	// which moon gets drawn
	m = 'Moon'+Math.floor(28*(((360+eph.Moon.elong)/360)%1));

	// locate the tokens over the chart
	var divs = '';
	for (i in images) {
	  var x = null;
	  var y = null;
	  var z = 1;
	  var w = images[i].width;
	  var h = images[i].height;
	
	  if (i.indexOf('Star') == 0
		  || (i.indexOf('Moon') == 0 && i != m)
		  || i == 'Sun' || i == 'Horizontal' || i == 'Vertical')
		continue;

	  if (i == 'Sunrise') {
		x = sunx - w/2;
		y = suny - h/2;
		z = 4;
	  } else if (i == 'Sunset') {
		x = sunx + 2*360 - w/2;
		y = suny - h/2;
		z = 4;
	  } else if (i == 'Mercury' || i == 'Venus' || i == 'Mars' || i == 'Jupiter'
				 || i == 'Saturn' || i == 'Uranus' || i == 'Neptune' || i == 'Pluto') {
		x = sunx + 2 * ((eph[i].elong < 0) ? -eph[i].elong : 360 - eph[i].elong) - w/2;
		y = suny - 2 * eph[i].latecl - h/2;
		z = 6;
	  } else if (i == 'Aries' || i == 'Taurus' || i == 'Gemini' || i == 'Cancer' || i == 'Leo' || i == 'Virgo'
				 || i == 'Libra' || i == 'Scorpio' || i == 'Saggitarius' || i == 'Capricorn' || i == 'Aquarius' || i == 'Pisces'
				 || i == 'Extra') {
		if (i == 'Extra')
		  x = left + 60 - w + 2*360;
		else
		  x = left + 60 - w + 2*((360+sunSign-zodiac[i])%360);
		y = top + height - h - 1;
		z = 3;
	  } else if (i.indexOf('Moon') == 0) {
		if (i == m) {
		  x = sunx + 2 * ((eph.Moon.elong < 0) ? -eph.Moon.elong : 360 - eph.Moon.elong) - w/2 ;
		  y = suny - 2 * eph.Moon.latecl - h/2;
		} else
		  continue;
		z = 5;
	  } else if (i == 'Ecliptic') {
		x = left;
		y = top+height/2;
		z = 2;
	  } else if (i == 'Top') {
		x = left;
		y = top;
		z = 2;
	  } else if (i == 'Bottom') {
		x = left;
		y = top+height-1;
		z = 2;
	  } else if (i.indexOf('Z') == 0) {
		x = left+parseInt(i.substring(1))*60;
		y = top;
		z = 2;
	  } else if (i.indexOf('c') == 0) {
		x = left+parseInt(i.substring(1))*60;
		y = top;
		z = 1;
	  }

	  if (i == 'Top' || i == 'Bottom')
		continue;
	  if (i == 'Ecliptic') y -= 10;
	  if (x >= 0 && y >= 0 && z >= 0) {
		x = Math.round(x);
		y = Math.round(y);
		z = Math.round(z);
		var style = 'position:absolute;top:'+y+'px;left:'+x+'px;width:'+w+'px;height:'+h+'px;z-index:'+z+';visibility:visible;';
		// if (i == 'Ecliptic' || i == 'Top' || i == 'Bottom')
		// alert("style "+i+": "+style);
		divs += '<div id='+i+' style="'+style+'">'+images[i].img()+'</div>\n';
	  }
	}
	var chart_name = 'header';	// 'echart'
	var header = document.getElementById(chart_name);
	  // position:relative to allow absolute positioning of elements within the div
	header.innerHTML = divs;
	if (chart_name == 'header') {
	  header.setAttribute("style", "position:relative;margin:10px;width:780px;height:120px");
	}
  }

  function generateTable() {
	// Table
	var table = '<table align="left" border="0">\n'+
	  // '<tr><th>Symbol'+
	  // '</th><th>Name'+
	  // '</th><th>Longitude'+
	  // '</th><th>Latitude'+
	  // '</th></tr>'+
	  '\n';
	function row(img, text, lon, lat) {
	  function minutes(x) {
		var sign = x >= 0 ? '' : '-';
		var degrees = Math.floor(Math.abs(x));
		var minutes = Math.round(60*(Math.abs(x)-degrees));
		degrees = degrees.toString();
		minutes = ((minutes<10) ? '0' : '')+minutes;
		return sign+degrees+'&deg;'+minutes+"'";
	  }
	  table +=
		'<tr class="ephemeris_row '+text+'"><td align="center">'+img+
		'</td><td>'+text+
		'</td><td align="right">'+minutes(lon)+
		'</td><td align="right">'+minutes(lat)+
		'</td></tr>\n';
	  
	}
	row(images['Sun'].img(), 'Sun', eph.Sun.lonecl, 0);
	row(images[m].img(), 'Moon', eph.Moon.glonecl, eph.Moon.glatecl);
	row(images['Mercury'].img(), 'Mercury', eph.Mercury.glonecl, eph.Mercury.glatecl);
	row(images['Venus'].img(), 'Venus', eph.Venus.glonecl, eph.Venus.glatecl);
	row(images['Mars'].img(), 'Mars', eph.Mars.glonecl, eph.Mars.glatecl);
	row(images['Jupiter'].img(), 'Jupiter', eph.Jupiter.glonecl, eph.Jupiter.glatecl);
	row(images['Saturn'].img(), 'Saturn', eph.Saturn.glonecl, eph.Saturn.glatecl);
	row(images['Uranus'].img(), 'Uranus', eph.Uranus.glonecl, eph.Uranus.glatecl);
	row(images['Neptune'].img(), 'Neptune', eph.Neptune.glonecl, eph.Neptune.glatecl);
	row(images['Pluto'].img(), 'Pluto', eph.Pluto.glonecl, eph.Pluto.glatecl);

	for (var i = 0; i < 360; i += 30)
	  row(images[zodiac[i]].img(), zodiac[i], i, 0);
	table += '</table>\n';
	document.getElementById('etable').innerHTML = table;
  }

  function generateText() {
	// Text
	document.getElementById('etextspan').innerHTML = "<p>Bright lights in sky for "+ date.toLocaleString() + ",\n"+
	  "in a time zone "+ tz+ " hours ("+ (tz*15) + " degrees) west of Greenwich,\n" +
	  "a time also known as " + date.toUTCString() + ".\n";
  }

  if (showChart === undefined) showChart = true;
  if (showTable === undefined) showTable = true;
  if (showText === undefined) showText = true;
  generateHead();
  if (showChart) generateChart();
  if (showTable) generateTable();
  if (showText) generateText();
}

function generateEphemerisChart() {
  generateEphemeris(true,false,false);
}

function validateEphemeris() {
  if ((new Date(document.date.date.value)).toString() == 'Invalid Date') {
	alert("The date '"+document.date.date.value+"' is invalid.");
	return false;
  } else {
	return true;
  }
}

