attached = false
attributes = learnerState = null

# Handle incoming events from the player
window.addEventListener 'message', (event) ->

  message = event.data

  if message.event == 'attached'
    attached = true
    sorter = SorterView { attributes, learnerState }
    React.renderComponent sorter, document.body
  else if attached
    # Once we're attached broadcast all incoming
    # events over the global event bus
    vent.trigger message.event, message.data
  else
    # Queue up state change events ahead of attachment
    # so we can simply send in attributes + learnerState
    # as properties when it's time create the view
    switch message.event
      when 'attributesChanged'
        attributes = message.data
      when 'learnerStateChanged'
        learnerState = message.data

# Rebroadcast all internal events to the player
vent.on 'all', (event, data) ->
  window.parent.postMessage { event, data }, '*'
