`/** @jsx React.DOM */`

ImageView = React.createClass
  render: ->
    `<img className="image" src={this.props.data.value}></img>`

window.ImageView = ImageView
