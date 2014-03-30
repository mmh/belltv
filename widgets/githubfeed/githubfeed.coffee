class Dashing.Githubfeed extends Dashing.Widget

  onData: (data) ->
    # Handle incoming data
    $(@node).fadeOut().fadeIn()
