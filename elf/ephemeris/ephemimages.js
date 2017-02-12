var images = new Object();
function Myimage(width, height, src, alt) {
  this.width = width;
  this.height = height;
  this.src = src;
  this.alt = alt;
  this.image = new Image();
  this.image.src = src;
}
Myimage.prototype.data = function(name) {
  var img = 'height="'+this.height+'" width="'+this.width+'" src="'+this.src+'" border="0" alt="'+(this.alt || '')+'"';
  if (name) img += ' name="'+name+'"';
  return img;
}
Myimage.prototype.position = function(x, y) {
  return 'position: absolute; x: '+x+'px; y: '+y+'px; ';
}
Myimage.prototype.img = function(name) {
  return '<img '+this.data(name)+'>';
}
Myimage.prototype.imgat = function(name, x, y) {
  return '<img '+this.data(name)+' style="'+this.position(x,y)+'">';
}  
// images of symbols for the sun, the planets, and the signs of the zodiac
images.Sun = new Myimage(21, 20, "/elf/ephemeris/images/Sun.gif", 'Sun');
images.Mercury = new Myimage(21, 20, "/elf/ephemeris/images/Mercury.gif", 'Mercury');
images.Venus = new Myimage(21, 20, "/elf/ephemeris/images/Venus.gif", 'Venus');
images.Mars = new Myimage(21, 20, "/elf/ephemeris/images/Mars.gif", 'Mars');
images.Jupiter = new Myimage(21, 20, "/elf/ephemeris/images/Jupiter.gif", 'Jupiter');
images.Saturn = new Myimage(21, 20, "/elf/ephemeris/images/Saturn.gif", 'Saturn');
images.Uranus = new Myimage(21, 20, "/elf/ephemeris/images/Uranus.gif", 'Uranus');
images.Neptune = new Myimage(21, 20, "/elf/ephemeris/images/Neptune.gif", 'Neptune');
images.Pluto = new Myimage(21, 20, "/elf/ephemeris/images/Pluto.gif", 'Pluto');
images.Aries = new Myimage(22, 20, "/elf/ephemeris/images/Aries.gif", 'Aries');
images.Taurus = new Myimage(17, 20, "/elf/ephemeris/images/Taurus.gif", 'Taurus');
images.Gemini = new Myimage(20, 20, "/elf/ephemeris/images/Gemini.gif", 'Gemini');
images.Cancer = new Myimage(23, 20, "/elf/ephemeris/images/Cancer.gif", 'Cancer');
images.Leo = new Myimage(23, 20, "/elf/ephemeris/images/Leo.gif", 'Leo');
images.Virgo = new Myimage(24, 20, "/elf/ephemeris/images/Virgo.gif", 'Virgo');
images.Libra = new Myimage(23, 20, "/elf/ephemeris/images/Libra.gif", 'Libra');
images.Scorpio = new Myimage(24, 20, "/elf/ephemeris/images/Scorpio.gif", 'Scorpio');
images.Saggitarius = new Myimage(22, 20, "/elf/ephemeris/images/Saggitarius.gif", 'Saggitarius');
images.Capricorn = new Myimage(23, 20, "/elf/ephemeris/images/Capricorn.gif", 'Capricorn');
images.Aquarius = new Myimage(23, 20, "/elf/ephemeris/images/Aquarius.gif", 'Aquarius');
images.Pisces = new Myimage(20, 20, "/elf/ephemeris/images/Pisces.gif", 'Pisces');
// 28 different moon phase images
images.Moon0 = new Myimage(20, 20, '/elf/ephemeris/images/Moon0.gif', 'Moon 0th Day');
images.Moon1 = new Myimage(20, 20, '/elf/ephemeris/images/Moon1.gif', 'Moon 1st Day');
images.Moon2 = new Myimage(20, 20, '/elf/ephemeris/images/Moon2.gif', 'Moon 2nd Day');
images.Moon3 = new Myimage(20, 20, '/elf/ephemeris/images/Moon3.gif', 'Moon 3rd Day');
images.Moon4 = new Myimage(20, 20, '/elf/ephemeris/images/Moon4.gif', 'Moon 4th Day');
images.Moon5 = new Myimage(20, 20, '/elf/ephemeris/images/Moon5.gif', 'Moon 5th Day');
images.Moon6 = new Myimage(20, 20, '/elf/ephemeris/images/Moon6.gif', 'Moon 6th Day');
images.Moon7 = new Myimage(20, 20, '/elf/ephemeris/images/Moon7.gif', 'Moon 7th Day');
images.Moon8 = new Myimage(20, 20, '/elf/ephemeris/images/Moon8.gif', 'Moon 8th Day');
images.Moon9 = new Myimage(20, 20, '/elf/ephemeris/images/Moon9.gif', 'Moon 9th Day');
images.Moon10 = new Myimage(20, 20, '/elf/ephemeris/images/Moon10.gif', 'Moon 10th Day');
images.Moon11 = new Myimage(20, 20, '/elf/ephemeris/images/Moon11.gif', 'Moon 11th Day');
images.Moon12 = new Myimage(20, 20, '/elf/ephemeris/images/Moon12.gif', 'Moon 12th Day');
images.Moon13 = new Myimage(20, 20, '/elf/ephemeris/images/Moon13.gif', 'Moon 13th Day');
images.Moon14 = new Myimage(20, 20, '/elf/ephemeris/images/Moon14.gif', 'Moon 14th Day');
images.Moon15 = new Myimage(20, 20, '/elf/ephemeris/images/Moon15.gif', 'Moon 15th Day');
images.Moon16 = new Myimage(20, 20, '/elf/ephemeris/images/Moon16.gif', 'Moon 16th Day');
images.Moon17 = new Myimage(20, 20, '/elf/ephemeris/images/Moon17.gif', 'Moon 17th Day');
images.Moon18 = new Myimage(20, 20, '/elf/ephemeris/images/Moon18.gif', 'Moon 18th Day');
images.Moon19 = new Myimage(20, 20, '/elf/ephemeris/images/Moon19.gif', 'Moon 19th Day');
images.Moon20 = new Myimage(20, 20, '/elf/ephemeris/images/Moon20.gif', 'Moon 20th Day');
images.Moon21 = new Myimage(20, 20, '/elf/ephemeris/images/Moon21.gif', 'Moon 21st Day');
images.Moon22 = new Myimage(20, 20, '/elf/ephemeris/images/Moon22.gif', 'Moon 22nd Day');
images.Moon23 = new Myimage(20, 20, '/elf/ephemeris/images/Moon23.gif', 'Moon 23rd Day');
images.Moon24 = new Myimage(20, 20, '/elf/ephemeris/images/Moon24.gif', 'Moon 24th Day');
images.Moon25 = new Myimage(20, 20, '/elf/ephemeris/images/Moon25.gif', 'Moon 25th Day');
images.Moon26 = new Myimage(20, 20, '/elf/ephemeris/images/Moon26.gif', 'Moon 26th Day');
images.Moon27 = new Myimage(20, 20, '/elf/ephemeris/images/Moon27.gif', 'Moon 27th Day');
// the stars for each 30 degree chunk of longitude
images.Star0 = new Myimage(60, 120, '/elf/ephemeris/images/Star0.gif', 'Star0');
images.Star30 = new Myimage(60, 120, '/elf/ephemeris/images/Star30.gif', 'Star30');
images.Star60 = new Myimage(60, 120, '/elf/ephemeris/images/Star60.gif', 'Star60');
images.Star90 = new Myimage(60, 120, '/elf/ephemeris/images/Star90.gif', 'Star90');
images.Star120 = new Myimage(60, 120, '/elf/ephemeris/images/Star120.gif', 'Star120');
images.Star150 = new Myimage(60, 120, '/elf/ephemeris/images/Star150.gif', 'Star150');
images.Star180 = new Myimage(60, 120, '/elf/ephemeris/images/Star180.gif', 'Star180');
images.Star210 = new Myimage(60, 120, '/elf/ephemeris/images/Star210.gif', 'Star210');
images.Star240 = new Myimage(60, 120, '/elf/ephemeris/images/Star240.gif', 'Star240');
images.Star270 = new Myimage(60, 120, '/elf/ephemeris/images/Star270.gif', 'Star270');
images.Star300 = new Myimage(60, 120, '/elf/ephemeris/images/Star300.gif', 'Star300');
images.Star330 = new Myimage(60, 120, '/elf/ephemeris/images/Star330.gif', 'Star330');
// horizontal line
images.Horizontal = new Myimage(780,1,'/elf/ephemeris/images/horizontal.gif');
// vertical line
images.Vertical = new Myimage(1,120,'/elf/ephemeris/images/vertical.gif');
// Ecliptic, Top, and Bottom are horizontal lines
images.Ecliptic = images.Top = images.Bottom = images.Horizontal;
// 30 degree boundaries in longitude are vertical lines
for (var i = 0; i <= 13; i += 1) images['Z'+i] = images.Vertical;
// the easternmost sun image
images.Sunrise = images.Sun;
// the westernmost sun image
images.Sunset = images.Sun;
