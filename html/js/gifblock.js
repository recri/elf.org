//
// gif data string for:
//  0 arguments, a 1x1 gif of transparent
//  1 arguments, a 1x1 gif of specified grey
//  2 arguments, a 2x2 checkerboard gif of specified greys
//  3 arguments, a 1x1 image of specified r, g, b color
//  6 arguments, a 2x2 checkerboard of the two specified r,g,b colors
// this would typically be used directly in a javascript: url as an image source,
// eg <img src="javascript:gifblock()" height="1" width="640" alt="">
//
function gifblock(r1,g1,b1,r2,g2,b2) {
  var rgb = String.fromCharCode;
  if (arguments.length == 0)	/* 1x1 transparent */
    return 'GIF89a\1\0\1\0\200\0\0\377\377\377\0\0\0!\371\4\1\0\0\0\0,\0\0\0\0\1\0\1\0\0\2\2D\1\0;';
  if (arguments.length == 1)	/* 1x1 gray solid */
    return 'GIF87a\1\0\1\0\200\0\0'+rgb(r1,r1,r1)+'\0\0\0,\0\0\0\0\1\0\1\0\0\2\2D\1\0;';
  if (arguments.length == 2)	/* 2x2 gray checkerboard */
    return 'GIF87a\2\0\2\0\200\0\0'+rgb(r1,r1,r1)+rgb(g1,g1,g1)+',\0\0\0\0\2\0\2\0\0\2\3D\2\5\0;';
  if (arguments.length == 3)	/* 1x1 color solid */
    return 'GIF87a\1\0\1\0\200\0\0'+rgb(r1,g1,b1)+'\0\0\0,\0\0\0\0\1\0\1\0\0\2\2D\1\0;';
  if (arguments.length == 6)	/* 2x2 color checkerboard */
    return 'GIF87a\2\0\2\0\200\0\0'+rgb(r1,g1,b1)+rgb(r2,g2,b2)+',\0\0\0\0\2\0\2\0\0\2\3D\2\5\0;';
  return gifblock();		/* no harm? */
}

//
// convert a string, such as returned by gifblock, into a javascript url
// this only appears to work in Netscape Versions 4+
//
function javascriptUrl(string) {
  return "javascript:"+string;
}

//
// convert a string, such as returned by gifblock, into a data url
// the mime type must be supplied, the encoding will be base64
// note that this will exceed the limits on tag data eventually
// this generates an invalid url error if used to modify an Image.src
// property in Netscape 4+, but it's okay in the html itself
//
function dataUrl(mimetype, string) {
  return "data:"+mimetype+";base64,"+base64(string);
}

//
// encode a string into base64
//
function base64(s) {
  var basis = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  function base64x3(c1, c2, c3) {
    return basis.charAt(c1 >> 2) + 
      basis.charAt(((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4)) +
      basis.charAt(((c2 & 0xF) << 2) | ((c3 & 0xC0) >> 6)) +
      basis.charAt(c3 & 0x3F);
  }
  function base64x2(c1, c2) {
    return basis.charAt(c1 >> 2) + 
      basis.charAt(((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4)) +
      basis.charAt(((c2 & 0xF) << 2)) +
      '=';
  }
  function base64x1(c1) {
    return basis.charAt(c1 >> 2) + 
      basis.charAt(((c1 & 0x3) << 4)) +
      '=' +
      '=';
  }
  // R0lGODdhJgAmAMIAAAAAAH9/fz8/P////7+/vwAAAAAAAAAAACwAAAAAJgAmAAADhzi63CvB
  // 01234567890123456789012345678901234567890123456789012345678901234567890123456789
  //           1         2         3         4         5         6         7
  var b = '';
  for (var i = 0; i+3 < s.length; i += 3) {
    b += base64x3(s.charCodeAt(i), s.charCodeAt(i+1), s.charCodeAt(i+2));
    // insert newline after each 54 in == 72 out characters
    if (((i+3)%54)==0) b += '\n';
  }
  if (i+3 == s.length) b += base64x3(s.charCodeAt(i), s.charCodeAt(i+1), s.charCodeAt(i+2)) + '\n';
  if (i+2 == s.length) b += base64x2(s.charCodeAt(i), s.charCodeAt(i+1)) + '\n';
  if (i+1 == s.length) b += base64x1(s.charCodeAt(i)) + '\n';
  if (i+0 == s.length) b += '\n';
  return b;
}
