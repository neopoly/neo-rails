(function($){
  var SEL = {
    list : "neo-rails-scenarios-list",
    open : "neo-rails-scenarios-list-open"
  };

  var url_param = function(name){
    var results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec(window.location.href);
    return results !== null && results[1];
  };

  $(function(){
    $("."+SEL.list).each(function(){
      var ui = $(this);
      ui.on("click", "h2", function(evt){
        ui.toggleClass(SEL.open);
      });

      var active_scenario = url_param("scenario");
      if (active_scenario){
        ui.addClass(SEL.open);
      };
    });
  })
})(jQuery);
