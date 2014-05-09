# Handle incoming events from the player
window.addEventListener 'message', (event) ->
  message = event.data

  # Broadcast all incoming
  # events over the global event bus
  vent.trigger message.event, message.data

window.playerTrigger = (event, data) ->
  window.parent.postMessage { event, data }, '*'


document.addEventListener 'DOMContentLoaded', ->
  React.renderComponent SorterView(attributes: {}, learnerState: {}), document.body
  playerTrigger 'startListening'
