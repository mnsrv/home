function setCookie(name, value, options) {
  options = options || {};

  var expires = options.expires;

  if (typeof expires == "number" && expires) {
    var d = new Date();
    d.setTime(d.getTime() + expires * 1000);
    expires = options.expires = d;
  }
  if (expires && expires.toUTCString) {
    options.expires = expires.toUTCString();
  }

  value = encodeURIComponent(value);

  var updatedCookie = name + "=" + value;

  for (var propName in options) {
    updatedCookie += "; " + propName;
    var propValue = options[propName];
    if (propValue !== true) {
      updatedCookie += "=" + propValue;
    }
  }

  document.cookie = updatedCookie;
}
function getCookie(name) {
  var matches = document.cookie.match(new RegExp(
    "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
  ));
  return matches ? decodeURIComponent(matches[1]) : undefined;
}

var darkmoon = ['🌑', '🌘', '🌗', '🌖', '🌕']
var lightmoon = ['🌕', '🌔', '🌓', '🌒', '🌑']

$(document).ready(function() {
  var $moon = $('#daynnite')
  var rotate = function(moon, i) {
    setTimeout(function() {
      $moon.text(moon[moon.length - i])
      if (--i) {
        rotate(moon, i)
      }
    }, 300 / moon.length)
  }
  $moon.on('click', function() {
    if (getCookie('home_theme') === 'dark') {
      setCookie('home_theme', 'dark', {expires: -1})
      $('.body').removeClass('body_dark')
      rotate(lightmoon, lightmoon.length)
    } else {
      setCookie('home_theme', 'dark')
      $('.body').addClass('body_dark')
      rotate(darkmoon, darkmoon.length)
    }
  })
})
