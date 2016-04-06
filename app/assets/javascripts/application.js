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
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

$(document).ready(function() {

  //displaying welcome/intro messages based on which page the user is on
  if ($(".new-user")[0]) {
    message = "Welcome to Charma! Your character limit is equal to the Charma you attain. Increase your Charma as users follow you or like your posts. Like someones post? Throw them some Charma if you have some to spend! Go ahead and get started!"
    setTimeout(typeMessage, 75)
  } else if ($(".welcome")[0]) {
    message = "where your character limit directly correlates to how many people care to read your thoughts";
    setTimeout(typeMessage, 75);
  }

  //creating a character count that updates in text field to show user how many characters
  //they have to work with
  if ($('.new-post')[0]) {
    var textInput = $('.new-post')[0];
    var charLimit = parseInt($('.charma_value')[0].innerText);
    textInput.addEventListener("keyup", function() {
      document.getElementsByClassName("character_count")[0].innerText = charLimit - countEmojis(textInput.value);
    });
  }

  //setting up infinite scroll for post_feed as user scrolls to the bottom of the page
  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url = $('.pagination .next_page a').attr('href')
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 10) {
        $('.pagination').text("Please Wait...");
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }

})

//creating a function that mimics typing of a string. sets initial speed to 75ms
//if character is '.', '!', '?', it changes the delay of the timeout to better mimic typing
var typingSpeed = 75;
var counter = 0;
var typeMessage = function() {
  if (counter <= message.length - 1) {
    $(".typing").show();
    $(".welcome").append(message[counter])
    if ((message[counter] == '.') || (message[counter] == '!')) {
      typingSpeed = 1000;
    } else if (message[counter] == '?') {
      typingSpeed = 500;
    } else {
      typingSpeed = 75;
    }
    counter++;
    setTimeout(typeMessage, typingSpeed)
  } else {
    clearInterval(typeMessage);
    $(".typing").hide();
  }
};

//creating countEmojis function to better calculate string lengths based on javascripts
//handling of emojis
var emojiRegex = /[\uD800-\uDBFF][\uDC00-\uDFFF]/g;

function countEmojis(string) {
  return string.replace(emojiRegex, '_').length;
}
