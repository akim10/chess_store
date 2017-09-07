// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery_nested_form
//= require foundation.min
//= require_tree .  
//= require jquery-ui
//= require highcharts/highcharts
//= require highcharts/highcharts-more
//= require highcharts/highstock


$('.alert-box').delay(4000).fadeOut();

$('a.close').on('click', function(){
    $(this).parent().remove();
});


$(document).foundation();

$(function() {
  $(document).foundation('topbar', 'reflow');
});

$( function() {
  $( "#tabs" ).tabs().addClass( "ui-tabs ui-helper-clearfix" );
  $( "#tabs li" ).removeClass( "ui-corner-top" ).addClass( "ui-corner-left" );
} );

$( function() {
  var spinner = $( "#spinner" ).spinner();

  $( "#disable" ).on( "click", function() {
    if ( spinner.spinner( "option", "disabled" ) ) {
      spinner.spinner( "enable" );
    } else {
      spinner.spinner( "disable" );
    }
  });
  $( "#destroy" ).on( "click", function() {
    if ( spinner.spinner( "instance" ) ) {
      spinner.spinner( "destroy" );
    } else {
      spinner.spinner();
    }
  });
  $( "#getvalue" ).on( "click", function() {
    alert( spinner.spinner( "value" ) );
  });
  $( "#setvalue" ).on( "click", function() {
    spinner.spinner( "value", 5 );
  });

  $( "button" ).button();
} );

/* Set the width of the side navigation to 250px */
function openNav() {
    document.getElementById("mySidenav").style.width = "500px";
}

/* Set the width of the side navigation to 0 */
function closeNav() {
    document.getElementById("mySidenav").style.width = "0";
}