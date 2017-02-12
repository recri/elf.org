/*
** Copyright (C) 2006 by Roger E Critchlow Jr,
** Santa Fe, New Mexico, USA
** rec@elf.org
**
** This program is free software; you can redistribute it and/or
** modify it under the terms of the GNU General Public License
** as published by the Free Software Foundation; either version 2
** of the License, or (at your option) any later version.
** 
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
** 
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
**
** The home page for this code is
**	http://www.elf.org/quantum-classical-clock/
** a copy of the GNU GPL may be found at
**	http://www.gnu.org/copyleft/gpl.html,
*/
//
// parse a window.location.search string into an object.
// use the proto object to supply aliases
// and the set of allowed parameters.
// optionally merge defaults
// optionally validate values
//

function parse_search(x, search) {
  var params = new Object();

  //
  // merge default values into the params arrays
  //
  function merge_defaults() {
	if (x.defaults !== undefined) {
	  for (var i in x.defaults) {
		if (params[i] == null) {
		  if (x.defaults[i] === undefined)
			alert("default for "+i+" is undefined?");
		  params[i] = x.defaults[i];
		}
	  }
	}
	return params;
  }
  //
  // validate values in params
  //
  function validate_values() {
	if (x.validations != null) {
	  for (var i in params) {
		if (params[i] === undefined)
		  alert("param for "+i+" is undefined?");
		else if (x.validations[i] === undefined)
		  alert("validation function for "+i+" is undefined?");
		else
		  params[i] = x.validations[i](params[i]);
                
	  }
	}
	return params;
  }
    
  if (search !== undefined) {
	x.c.search = search;
  } else if (window.location.search != '') {
	x.c.search = window.location.search;
	// alert("search from window.location.search: "+x.c.search);
  } else if (window.parent.location.search != '') {
	x.c.search = window.parent.location.search;
	// alert("taking search from window.parent.location.search: "+search);
  } else {
	var search = [];
	for (i in x.defaults)
	  search.push(i+"="+x.defaults[i]);
	x.c.search = "?"+search.join('&');
  }
  var vals = unescape(x.c.search.substr(1).replace(/\+/g, ' ')).split('&');
  // alert("decoding params from: "+search);
  // alert("split into "+vals.length+" values");
  for (var i in vals) {
	var nv = vals[i].split('=');
	var name = nv[0];
	var value = nv[1];
	// alert("parsing parameter "+i+" from string: "+vals[i]+", decoded name='"+name+"' and value='"+value+"'");
	if (x.proto[name] !== undefined) {
	  if (x.proto[name] != name)
		name = x.proto[name];
	  params[name] = value;
	} else {
	  alert("unrecognized parameter: '"+name+"' with value '"+value+"'");
	}
  }
  params = merge_defaults();
  params = validate_values();
  return params;
}
