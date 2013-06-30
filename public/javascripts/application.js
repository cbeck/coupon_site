// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


var Images = {
  select: function(id, dom_id) {
    $('coupon_template_image_id').value = id;
    Application.makeActive(dom_id);
  }
}

var Application = {
  makeActive: function(element)	{
      $$(".active").invoke("removeClassName","active");
      $(element).addClassName("active");
  }
}





/*-------------------- Messenger Functions ------------------------------*/
// The following object and code was taken and modified from Jaded 
// Pixel's Shopify system. (http://www.myshopify.com/javascripts/shopify.js)
//
// Messenger is used to manage error messages and notices
//
var Messenger = {
  autohide_error: null,
  autohide_notice: null,
  // When given an error message, wrap it in a list 
  // and show it on the screen.  This message will auto-hide 
  // after a specified amount of miliseconds
  error: function(message) {
    $('flasherrors').update(message);
    new Effect.Appear('flasherrors', {duration: 0.3});
    
    if (this.autohide_error != null) {clearTimeout(this.autohide_error);}
    this.autohide_error = setTimeout(Messenger.fadeError.bind(this), 2000);
  },

  // Notice-level messages.  See Messenger.error for full details.
  notice: function(message) {
    $('flashnotice').update(message);
    new Effect.Appear('flashnotice', {duration: 0.3});

    if (this.autohide_notice != null) {clearTimeout(this.autohide_notice);}
    this.autohide_notice = setTimeout(Messenger.fadeNotice.bind(this), 1000);
  },
  
  // Responsible for fading notices level messages in the dom    
  fadeNotice: function() {
    new Effect.Fade('flashnotice', {duration: 0.3});
    this.autohide_notice = null;
  },
  
  // Responsible for fading error messages in the DOM
  fadeError: function() {
    new Effect.Fade('flasherrors', {duration: 0.3});
    this.autohide_error = null;
  }
}
