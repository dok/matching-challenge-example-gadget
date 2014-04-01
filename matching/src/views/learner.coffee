`/** @jsx React.DOM */`

LearnerView = React.createClass
  handleClick: (index) ->
    @props.handleResponse @lineup[index]

  renderComponent: (config) ->
    switch config.type
      when 'text'
        `<TextView data={config.data} />`
      when 'color'
        `<ColorView data={config.data} />`
      when 'image'
        `<ImageView data={config.data} />`

  render: ->
    currentPair = @props.pairs[@props.currentPairIndex]

    # a lineup of pairs to choose from
    _lineup = [currentPair]

    # get a couple more criminals into the lineup
    allOtherPairs = _.without @props.pairs, currentPair
    allOtherPairs = _.shuffle allOtherPairs
    _lineup.push allOtherPairs.pop()
    allOtherPairs = _.shuffle allOtherPairs
    _lineup.push allOtherPairs.pop()

    # mix em up
    @lineup = _.shuffle _lineup

    `<div>
      <table className="matcher">
        <tbody>
          <tr>
            <td className="question" rowSpan="3">
              <div>Find <strong>{this.renderComponent(currentPair.name)}</strong> on the right.</div>
            </td>
            <td className="choice" onClick={this.handleClick.bind(this, 0)}>
              {this.renderComponent(this.lineup[0].value)}
            </td>
          </tr>
          <tr>
            <td className="choice" onClick={this.handleClick.bind(this, 1)}>
              {this.renderComponent(this.lineup[1].value)}
            </td>
          </tr>
          <tr>
            <td className="choice" onClick={this.handleClick.bind(this, 2)}>
              {this.renderComponent(this.lineup[2].value)}
            </td>
          </tr>
        </tbody>
      </table>
    </div>`

window.LearnerView = LearnerView
