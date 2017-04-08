# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

setCookie = (name, value, options) ->
  options = options or {}
  expires = options.expires
  if typeof expires == 'number' and expires
    d = new Date
    d.setTime d.getTime() + expires * 1000
    expires = options.expires = d
  if expires and expires.toUTCString
    options.expires = expires.toUTCString()
  value = encodeURIComponent(value)
  updatedCookie = name + '=' + value
  for propName of options
    updatedCookie += '; ' + propName
    propValue = options[propName]
    if propValue != true
      updatedCookie += '=' + propValue
  document.cookie = updatedCookie
  return

getCookie = (name) ->
  matches = document.cookie.match(new RegExp('(?:^|; )' + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + '=([^;]*)'))
  if matches then decodeURIComponent(matches[1]) else undefined

pressTimer = null

doAfterTimer = ->
  if getCookie('home_theme') == 'dark'
    setCookie('home_theme', 'dark', {expires: -1})
    $('.body').removeClass 'body_dark'
  else
    setCookie('home_theme', 'dark')
    $('.body').addClass 'body_dark'

mouseUp = ->
  clearTimeout(pressTimer)
  return false

mouseDown = ->
  pressTimer = window.setTimeout(doAfterTimer, 1000)
  return false

$('.header__logo').mouseup(mouseUp).mousedown(mouseDown)