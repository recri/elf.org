
//
// convert a string, such as returned by gifblock, into a data url
// the mime type must be supplied, the encoding will be base64
// note that this will exceed the limits on tag data eventually
// this generates an invalid url error if used to modify an Image.src
// property in Netscape 4+, but it's okay in the html itself
//
function dataUrl(mimetype, string) { return "data:"+mimetype+";base64,"+base64(string); }

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
