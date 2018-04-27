//
// a losing proposition, but attempt to figure out
// the true name of our user agent
//
function Navigator_prototype_trueVendor() {
    this.trueName();
    return this.myTrueVendor;
}
function Navigator_prototype_trueVersion() {
    this.trueName();
    return this.myTrueVersion;
}
function Navigator_prototype_trueName() {
    if (Navigator.myTrueVendor == null) {
	// Opera
	// userAgent = Mozilla/4.0 (compatible; Opera/3.0; Windows 95) 3.51 [en]
	if (this.userAgent.indexOf('Opera') > 0) {
	    Navigator.myTrueVendor = 'op';
	    Navigator.myTrueVersion = parseFloat(this.userAgent.substr(this.userAgent.indexOf(')')+2));
	    return Navigator.myTrueVendor+Navigator.myTrueVersion;
	}
	// Explorer
	// appVersion = 4.0 (compatible; MSIE 4.01; Windows 95)
	// appVersion = 4.0 (compatible; MSIE 5.0; Windows 95)
	if (this.appVersion.indexOf('MSIE') > 0) {
	    Navigator.myTrueVendor = 'ie';
	    Navigator.myTrueVersion = parseFloat(this.appVersion.substr(this.appVersion.indexOf('MSIE ')+5));
	    return Navigator.myTrueVendor+Navigator.myTrueVersion;
	}
	// WebTV simulator
	// appCodeName = 
	// appName = 
	// appVersion = 
	// mimeTypes = 
	// plugins = 
	// userAgent = 
	if (this.appVersion == '') {
	    Navigator.myTrueVendor = 'tv';
	    Navigator.myTrueVersion = 0;
	    return Navigator.myTrueVendor+Navigator.myTrueVersion;
	}
	// Navigator
	// appVersion = 4.05 [en] (X11; I; Linux 2.0.35 i586)
	// appVersion = 4.51 [en] (Win95; U)
	if (this.appName == 'Netscape') {
	    Navigator.myTrueVendor = 'nn';
	    Navigator.myTrueVersion = parseFloat(this.appVersion);
	    return Navigator.myTrueVendor+Navigator.myTrueVersion;
	}
	// who knows?
	Navigator.myTrueVendor = '??';
	Navigator.myTrueVersion = 0;
	return Navigator.myTrueVendor+Navigator.myTrueVersion;
    }
    return Navigator.myTrueVendor+Navigator.myTrueVersion;
}
Navigator.prototype.trueVendor = Navigator_prototype_trueVendor;
Navigator.prototype.trueVersion = Navigator_prototype_trueVersion;
Navigator.prototype.trueName = Navigator_prototype_trueName;
