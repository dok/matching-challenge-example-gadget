`/** @jsx React.DOM */`

ColorView = React.createClass
  componentDidMount: ->
    @refs.color.getDOMNode().style.backgroundColor = "#{@props.data.value}"
  componentDidUpdate: ->
    @refs.color.getDOMNode().style.backgroundColor = "#{@props.data.value}"

  render: ->
    `<div className="color" ref="color">&nbsp;</div>`

window.ColorView = ColorView
