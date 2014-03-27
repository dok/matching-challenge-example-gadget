attached = false

window.addEventListener 'message', (event) ->
  try
    message = JSON.parse event.data
  catch error then console.error 'Error:', error
  return unless message

  if message.event == 'attached'
    sorter = SorterView()
    React.renderComponent sorter, document.body
  else
    vent.trigger message.event, message.data

vent.on 'all', (event, data) ->
  message = JSON.stringify { event, data }
  window.parent.postMessage message, '*'
