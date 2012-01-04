

FrinkBrowser.prototype = new SimpleBrowser();
FrinkBrowser.prototype.constructor=FrinkBrowser;

function FrinkBrowser() {
    
}

FrinkBrowser.prototype.createSimpleBrowser = function(url, x, y, w, h) {
    var $fb = $("#frinkBrowser");
    if ($fb.length == 0) {
        var $c = $("<iframe id=\"frinkBrowser\" src=\"" + url + "\" style=\"position:absolute; top: " + y + "px; left: " + x + "px; width: " + w + "px; height: " + h + "px; z-index: 100;\" />");
        console.log($("body"));
        $("body").append($c);
    } else {
        $("#frinkBrowser").attr('src', url)
        .css('display', '')
        .css("top", y)
        .css("left", x)
        .css("width", w)
        .css("height", h);
    }
    console.log($("#frinkBrowser"));
};

FrinkBrowser.prototype.resize = function (x, y, w, h) {
    var $fb = $("#frinkBrowser");
    if ($fb.length == 1)
        $("#frinkBrowser").css("top", y)
                    .css("left", x)
                    .css("width", w)
                    .css("height", h);
    
};

FrinkBrowser.prototype.hide = function () {
    var $fb = $("#frinkBrowser");
    if ($fb.length == 1)
        $fb.css("display", "none");
};


function getBrowser() {
    return (window.device == undefined) ? new FrinkBrowser() : window.plugins.simpleBrowser;
}