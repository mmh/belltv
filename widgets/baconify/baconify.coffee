root = exports ? this

class Dashing.Baconify extends Dashing.Widget

	ready: ->

	onData: (data) ->
		baconate() if data.value is 'baconify'
		restoreBackgrounds() if data.value isnt 'baconify'

	root.restoreBackgrounds = () ->
		$(".widget").each ->
			w = $(this)
			restoreColor = w.attr("backgroundColorBk")
			restoreImage = w.attr("backgroundImageBk")
			restoreRepeat = w.attr("backgroundRepeatBk")
			restoreAttachment = w.attr("backgroundAttachmentBk")
			restorePosition = w.attr("backgroundPositionBk")
			restoreBackground = w.attr("backgroundBk")
			w.css('background-color': restoreColor)
			w.css('background-image': restoreImage)
			w.css('background-repeat': restoreRepeat)
			w.css('background-attachment': restoreAttachment)
			w.css('background-position': restorePosition)
			# w.css('background': restoreBackground)
			return
		$("#baconification-link").attr('href', 'javascript:baconate()')	
		return
  
	backupBackgrounds = () ->
    		# We don't want to permanently delete backgrounds - just store them away
		$(".widget").each ->
			w = $(this)
			w.attr("backgroundColorBk", w.css("background-color"))
			w.attr("backgroundImageBk", w.css("background-image"))
			w.attr("backgroundRepeatBk", w.css("background-repeat"))
			w.attr("backgroundAttachmentBk", w.css("background-attachment"))
			w.attr("backgroundPositionBk", w.css("background-position"))
			w.attr("backgroundBk", w.css("background"))
			w.css({"background-color": "", "background-image": "", "background-repeat": "", "background-attachment": "", "background-position": "", "background": "" })
			

	root.baconate = () ->
	# BACONATE ALL THE BACKGROUNDS
		backupBackgrounds()
		$(".widget").each ->
			sizetarget = $(this).parent()
			target = $(this)
			newimageheight = sizetarget.height() - Math.floor(Math.random() * 20)
			newimagewidth = sizetarget.width() - Math.floor(Math.random() * 20)
			targetUrl = 'http://baconmockup.com/' + newimagewidth + '/' + newimageheight + '/'
			# Even with prefetching, larger dashboards seem to have troubles picking up all their images correctly
			# I suspect that this is a problem on baconmockup's side: it only seems to happen after repeated
			# attempts to rebackground those dashboards
			$('#prefetch').attr('src', targetUrl).load -> 
				target.css("background-image","url('" + targetUrl + "')")
				target.css("background-size", "cover")
				return
			return
		$("#baconification-link").attr('href', 'javascript:restoreBackgrounds()')	
		return
		
