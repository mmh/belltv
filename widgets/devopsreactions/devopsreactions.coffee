class Dashing.Devopsreactions extends Dashing.Widget

  onData: (data) ->
    # Handle incoming data
    $(@node).fadeOut().fadeIn()
