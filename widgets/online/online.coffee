class Dashing.Online extends Dashing.Widget

  onData: (data) ->
    # Handle incoming data
    $(@node).fadeOut(600).fadeIn(600)
