attached = false
attributes = learnerState = null

# Handle incoming events from the player
window.addEventListener 'message', (event) ->
  try
    message = JSON.parse event.data
  catch error then console.error 'Error:', error
  return unless message

  if message.event == 'attached'
    attached = true
    sorter = SorterView { attributes, learnerState }
    React.renderComponent sorter, document.body
  else if attached
    vent.trigger message.event, message.data
  else
    switch message.event
      when 'attributesChanged'
        attributes = message.data
      when 'learnerStateChanged'
        learnerState = message.data

# Handle outgoing events to the player
vent.on 'all', (event, data) ->
  message = JSON.stringify { event, data }
  window.parent.postMessage message, '*'
