# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready =>
	$('.codeblock').wrap('<div class=wrapper />')
	$('.codeblock').hide()
	$('.wrapper').append("<a href=\"javascript:$('.codeblock').show();\">show json code</a>")
	
	