class Dashing.Spammails extends Dashing.Widget

  onData: (data) ->
    # Handle incoming data
    $(@node).fadeOut().fadeIn()
