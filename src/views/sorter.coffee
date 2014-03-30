`/** @jsx React.DOM */`

AuthorView = React.createClass

  handleClick: (challengeName) ->
    challenge = samples.getChallenge challengeName
    vent.trigger 'setLearnerState', { challengeName }
    vent.trigger 'setChallenges', [challenge]
    @props.handleReset()

  render: ->
    status = if @props.challenges.length
      `<div>
        <strong>{this.props.challengeName}</strong> challenge loaded
      </div>`
    else
      `<div></div>`

    `<div>
      {status}
      <div>
        <button onClick={this.handleClick.bind(this, 'versalers')}>Use versalers challenge</button>
      </div>
      <div>
        <button onClick={this.handleClick.bind(this, 'spanish phrases')}>Use Spanish phrase challenge</button>
      </div>
      <div>
        <button onClick={this.handleClick.bind(this, 'colors')}>Use colors challenge</button>
      </div>
    </div>`

TextView = React.createClass
  render: ->
    `<div className="text">{this.props.data.value}</div>`

ImageView = React.createClass
  render: ->
    `<img className="image" src={this.props.data.value}></img>`

ColorView = React.createClass
  componentDidMount: ->
    @refs.color.getDOMNode().style.backgroundColor = "#{@props.data.value}"
  componentDidUpdate: ->
    @refs.color.getDOMNode().style.backgroundColor = "#{@props.data.value}"

  render: ->
    `<div className="color" ref="color">&nbsp;</div>`

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

SorterView = React.createClass
  getInitialState: ->
    currentPairIndex: 0
    challenges: []
    editable: false
    totalScore: 0
    responses: []

  componentWillMount: ->
    @handleLearnerStateChanged @props.learnerState
    vent.on 'scoresChanged', @handleScoresChanged
    vent.on 'setEditable', @handleEditableness
    vent.on 'challengesChanged', @handleChallenges
    vent.on 'learnerStateChanged', @handleLearnerStateChanged

  componentDidMount: ->
    vent.trigger 'setHeight', pixels: 260

  componentWillUnmount: ->
    vent.off 'scoresChanged', @handleScoresChanged
    vent.off 'setEditable', @handleEditableness
    vent.off 'challengesChanged', @handleChallenges
    vent.off 'learnerStateChanged', @handleLearnerStateChanged

  handleChallenges: ({ challenges }) ->
    @setState { challenges }

  handleEditableness: ({ editable }) ->
    @setState { editable }

  handleScoresChanged: ({ scores, totalScore, responses }) ->
    currentPairIndex = _.first(responses)?.length || 0
    @setState { currentPairIndex, scores, totalScore, responses }

  handleLearnerStateChanged: (learnerState) ->
    @setState _.pick learnerState, 'challengeName'

  handleResponse: (response) ->
    @scoreChallenge response.value

  handleReset: ->
    # NOTE might be something we want the API to do for us, e.g. { event: 'resetScores' }
    vent.trigger 'scoreChallenges', [[]]

  scoreChallenge: (_response) ->
    responses = _.clone @state.responses
    response = _.first(responses) || []

    response[@state.currentPairIndex] = _response
    vent.trigger 'scoreChallenges', [response]

  render: ->
    if @state.editable
      `<AuthorView
        challenges={this.state.challenges}
        challengeName={this.state.challengeName}
        handleReset={this.handleReset} />`

    else if @state.challenges.length
      challenge = _.first @state.challenges
      pairs = challenge.prompt

      learnerDisplay = if @state.currentPairIndex < pairs.length
        `<LearnerView
          currentPairIndex={this.state.currentPairIndex}
          pairs={pairs}
          handleResponse={this.handleResponse} />`
      else
        `<div></div>`

      resetDisplay =
        `<button className="reset" onClick={this.handleReset}>Reset</button>`

      score = Math.floor @state.totalScore * 100
      scoreDisplay = if @state.currentPairIndex
        if @state.currentPairIndex < pairs.length
          `<div>
            <div className="score">{score}%</div>
            { resetDisplay }
          </div>`
        else
          `<div>
            <div className="score">{score}% Done!</div>
            { resetDisplay }
          </div>`
      else
        `<div></div>`

      display =
        `<div>
          { learnerDisplay }
          { scoreDisplay }
        </div>`

      return display

    else
      `<div>Edit the gadget to add some challenges!</div>`

window.SorterView = SorterView
