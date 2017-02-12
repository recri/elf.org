var org = org || {};
org.elf = org.elf || {};
org.elf.mudcrack = org.elf.mudcrack || new function() {
  // parameters for mudcrack processing applet
  var coverage = 0.40;	// proportion of particles
  var eps_ll = 2.00;	// energy of liquid-liquid patch boundary (kT)
  var eps_nl = 3.00;  // energy of particle-liquid patch boundary (kT)
  var eps_nn = 4.00; // energy of particle-particle patch boundary (kT)
  var mu = -5.50;	 // potential of evaporation (kT)
  var pmove = 0.01;	 // probability of movement, given a particle
  var vaporColor = "#8a4c2d";	// color of vapor patches
  var liquidColor = "#cdb249";	// color of liquid patches
  var particleColor = "#ca9048"; // color of particle patches
  var iwidth = 201;				 // width of patch array
  var iheight = 201;			 // height of patch array
  var iframerate = 30;			 // framerate of update

  //
  // must rewrite
  // 
  this.setCoverage = function(val) {
	coverage = val;
	return this.rewrite();
  };
  this.moreCoverage = function() {
	if ((coverage += 0.05) >= 1) coverage = 0.5;
	return this.rewrite();
  };
  this.lessCoverage = function() {
	if ((coverage -= 0.05) < 0) coverage = 0.5;
	return this.rewrite();
  };
  //
  // can adjust in medius res
  //
  this.cooler = function() {
	eps_ll = 2*eps_ll;
	eps_nl = 2*eps_nl;
	eps_nn = 2*eps_nn;
	mu = 2*mu;
	return this.rewrite();
  };
  //
  // can adjust in medius res
  //
  this.hotter = function() {
	eps_ll = eps_ll/2;
	eps_nl = eps_nl/2;
	eps_nn = eps_nn/2;
	mu = mu/2;
	return this.rewrite();
  };
  this.setValues = function(tag) {
	if ("default" == tag) {
	  coverage = 0.40;
	  eps_ll = 2.00;
	  eps_nl = 3.00;
	  eps_nn = 4.00;
	  mu = -4.60;
	  pmove = 1.0/200.0;
	  vaporColor = "#8a4c2d";
	  liquidColor = "#cdb249";
	  particleColor = "#ca9048";
	  iwidth = 201;
	  iheight = 201;
	  iframerate = 30;
	}
	if ("fig2a" == tag) {
	  this.setValues("default");
	  coverage = 0.05;
	}
	if ("fig2b" == tag) {
	  this.setValues("default");
	  coverage = 0.30;
	}
	if ("fig2c" == tag) {
	  this.setValues("default");
	  coverage = 0.40;
	}
	if ("fig2d" == tag) {
	  this.setValues("default");
	  coverage = 0.60;
	}
	if ("fig4a" == tag) {
	  this.setValues("default");
	  eps_ll = 4.0;
	  coverage = 0.10;
	  pmove = 1.0/6500.0;
	}
	if ("fig4b" == tag) {
	  this.setValues("fig4a");
	  coverage = 0.20;
	  pmove = 1.0/800.0;
	}
	if ("fig4c" == tag) {
	  this.setValues("fig4a");
	  coverage = 0.30;
	  pmove = 1.0/150.0
	}
	if ("fig4d" == tag) {
	  this.setValues("default");
	  coverage = 0.20;
	  eps_ll = 4.0;
	}

  };
  this.run = function(tag) {
    this.setValues(tag);
	return this.rewrite();
  };
  this.init = function() {
	return org.elf.mudcrack.run('default');
  };
  this.rewrite = function() {
	$('#applet_container').html(
'<!--[if !IE]> -->'+
'  <object classid="java:mudcrack.class" id="applet_id" '+
'    type="application/x-java-applet"'+
'    archive="/elf/processing/mudcrack/applet/mudcrack.jar"'+
'    width="'+iwidth+'" height="'+iheight+'">'+
'    standby="Loading Processing software..." >'+
'      <param name="archive" value="/elf/processing/mudcrack/applet/mudcrack.jar" />'+
'      <param name="mayscript" value="true" />'+
'      <param name="scriptable" value="true" />'+
'      <param name="image" value="/elf/processing/mudcrack/applet/loading.gif" />'+
'      <param name="boxmessage" value="Loading Processing software..." />'+
'      <param name="boxbgcolor" value="#FFFFFF" />'+
'      <param name="test_string" value="outer" />'+
'      <param name="coverage" value="'+coverage+'">\n'+
'      <param name="eps_ll" value="'+eps_ll+'">\n'+
'      <param name="eps_nl" value="'+eps_nl+'">\n'+
'      <param name="eps_nn" value="'+eps_nn+'">\n'+
'      <param name="mu" value="'+mu+'">\n'+
'      <param name="pmove" value="'+pmove+'">\n'+
'      <param name="vaporColor" value="'+vaporColor+'">\n'+
'      <param name="liquidColor" value="'+liquidColor+'">\n'+
'      <param name="particleColor" value="'+particleColor+'">\n'+
'      <param name="iwidth" value="'+iwidth+'">\n'+
'      <param name="iheight" value="'+iheight+'">\n'+
'      <param name="iframerate" value="'+iframerate+'">\n'+
'<!--<![endif]-->'+
'  <object classid="clsid:8AD9C840-044E-11D1-B3E9-00805F499D93" id="ieapplet_id" '+
'    codebase="http://java.sun.com/update/1.5.0/jinstall-1_5_0_15-windows-i586.cab"'+
'    width="'+iwidth+'" height="'+iheight+'">'+
'    standby="Loading Processing software..."  >'+
'      <param name="code" value="mudcrack" />'+
'      <param name="archive" value="/elf/processing/mudcrack/applet/mudcrack.jar" />'+
'      <param name="mayscript" value="true" />'+
'      <param name="scriptable" value="true" />'+
'      <param name="image" value="/elf/processing/mudcrack/applet/loading.gif" />'+
'      <param name="boxmessage" value="Loading Processing software..." />'+
'      <param name="boxbgcolor" value="#FFFFFF" />'+
'      <param name="test_string" value="inner" />'+
'      <param name="coverage" value="'+coverage+'">\n'+
'      <param name="eps_ll" value="'+eps_ll+'">\n'+
'      <param name="eps_nl" value="'+eps_nl+'">\n'+
'      <param name="eps_nn" value="'+eps_nn+'">\n'+
'      <param name="mu" value="'+mu+'">\n'+
'      <param name="pmove" value="'+pmove+'">\n'+
'      <param name="vaporColor" value="'+vaporColor+'">\n'+
'      <param name="liquidColor" value="'+liquidColor+'">\n'+
'      <param name="particleColor" value="'+particleColor+'">\n'+
'      <param name="iwidth" value="'+iwidth+'">\n'+
'      <param name="iheight" value="'+iheight+'">\n'+
'      <param name="iframerate" value="'+iframerate+'">\n'+
'      <p><strong>This browser does not have a Java Plug-in.'+
'      <br />'+
'      <a href="http://java.sun.com/products/plugin/downloads/index.html" title="Download Java Plug-in">'+
'        Get the latest Java Plug-in here.</a></strong></p>'+
'  </object>'+
'<!--[if !IE]> -->'+
' </object>'+
'<!--<![endif]-->'+
'<p></p>\n'+
'<center>\n'+
'<i>Coverage</i> = '+coverage+'<br/>\n'+
'<i>&epsilon;<sub>l</sub></i> = '+eps_ll+' k<sub>B</sub>T<br/>\n'+
'<i>&epsilon;<sub>nl</sub></i> = '+eps_nl+' k<sub>B</sub>T<br/>\n'+
'<i>&epsilon;<sub>n</sub></i> = '+eps_nn+' k<sub>B</sub>T<br/>\n'+
'<i>&mu;</i> = '+mu+' k<sub>B</sub>T<br/>\n'+
'<i>P<sub>move</sub></i> = '+pmove+'<br/>');
	return false;
  }
};

// $(document).ready(org.elf.mudcrack.init);
