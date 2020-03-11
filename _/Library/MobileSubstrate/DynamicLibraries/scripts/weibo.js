
if (ObjC.available) {
    var showAds = ObjC.classes.WOSplashAdsInfo['- showAds'];
    var uve_feed_ad = ObjC.classes.WOAppAnnouncement['- uve_feed_ad'];
    var uve_hot_ad = ObjC.classes.WOAppAnnouncement['- uve_hot_ad'];

    // Intercept the method
    Interceptor.attach(showAds.implementation, {
        onEnter: function (args) {
            var text = ObjC.classes.NSString.stringWithString_("FRIDA: WOSplashAdsInfo showAds get called.");
            var NSLog = new NativeFunction(Module.findExportByName('Foundation', 'NSLog'), 'void', ['pointer', '...']);
            NSLog(text);
        },
        onLeave: function(retVal) {
            retVal.replace(0);
        }
    });

    Interceptor.attach(uve_feed_ad.implementation, {
        onEnter: function (args) {
            var text = ObjC.classes.NSString.stringWithString_("FRIDA: WOAppAnnouncement uve_feed_ad get called.");
            var NSLog = new NativeFunction(Module.findExportByName('Foundation', 'NSLog'), 'void', ['pointer', '...']);
            NSLog(text);
        },
        onLeave: function(retVal) {
            retVal.replace(0);
        }
    });

    Interceptor.attach(uve_hot_ad.implementation, {
        onEnter: function (args) {
            var text = ObjC.classes.NSString.stringWithString_("FRIDA: WOAppAnnouncement uve_hot_ad get called.");
            var NSLog = new NativeFunction(Module.findExportByName('Foundation', 'NSLog'), 'void', ['pointer', '...']);
            NSLog(text);
        },
        onLeave: function(retVal) {
            retVal.replace(0);
        }
    });
    
}

