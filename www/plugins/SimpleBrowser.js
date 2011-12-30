
if (typeof PhoneGap !== "undefined") {

    function SimpleBrowser(){ 
    
    }

    SimpleBrowser.prototype.createSimpleBrowser = function(url, x, y, w, h) {
        PhoneGap.exec("SimpleBrowser.createSimpleBrowser", url, x, y, w, h);
    };
    
    SimpleBrowser.prototype.resize = function (x, y, w, h) {
        PhoneGap.exec("SimpleBrowser.resize", x, y, w, h);
    };
    
    SimpleBrowser.prototype.hide = function () {
        PhoneGap.exec("SimpleBrowser.hide");
    };

    PhoneGap.addConstructor(function(){
        if(!window.plugins) window.plugins = {};
        window.plugins.simpleBrowser = new SimpleBrowser();
    });

}