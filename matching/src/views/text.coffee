`/** @jsx React.DOM */`

TextView = React.createClass
  render: ->
    `<div className="text">{this.props.data.value}</div>`

window.TextView = TextView
