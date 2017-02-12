// Wonderful little function from prototype.js
function dollar() {
    var elements = new Array();
  
    for (var i = 0; i < arguments.length; i++) {
        var element = arguments[i];
        if (typeof element == 'string')
          element = document.getElementById(element);

        if (arguments.length == 1) 
          return element;
        elements.push(element);
    }
  
    return elements;
}

var edge = 640;
var cuts = 5;

function setCuts(newCuts) {
    cuts = newCuts;
    return rewrite();
}
function setEdge(newEdge) {
    edge = newEdge;
    return rewrite();
}
function moreCuts() {
    return setCuts(cuts + 1);
}
function fewerCuts() {
    return (cuts > 0) ? setCuts(cuts - 1) : false;
}
function largerPuzzle() {
    return setEdge(edge + 50);
}
function smallerPuzzle() {
    return (edge > 50) ? setEdge(edge - 50) : false;
}
function rewrite() {
    var n = cuts+1;
	var e = edge;
	var b = Math.floor(edge/10);
	dollar('applet').innerHTML =
				'<applet \n'+
					'code="org.elf.earth.PuzzleEarthApplet.class" \n'+
					'archive="/elf/puzzle/puzzle.jar" \n'+
					'width="'+e+'" height="'+e+'">\n'+
						'<param name="border" value="'+b+'">\n'+
						'<param name="ncols" value="'+n+'">\n'+
						'<param name="nrows" value="'+n+'">\n'+
					'Your browser is completely ignoring the &lt;APPLET&gt; tag!\n'+
				'</applet>';
	return false;
}

