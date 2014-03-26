`/** @jsx React.DOM */`

AuthorView = React.createClass
  handleClick: ->
    challenges = _.clone @props.challenges
    challenges.push samples.getChallenge 'spanishPhrases'
    vent.trigger 'setChallenges', challenges

  render: ->
    if @props.challenges.length
      `<div>
        Challenge loaded, try learner view.
      </div>`
    else
      `<div>
        <div>Authoring placeholder</div>
        <button onClick={this.handleClick}>Add challenge</button>
      </div>`

LearnerView = React.createClass
  handleClick: (index) ->
    @props.handleResponse @lineup[index]

  render: ->
    console.log 'render learner view'
    currentPair = @props.pairs[@props.currentPairIndex]

    # a lineup of pairs to choose from
    _lineup = [currentPair]

    # get a couple more criminals into the lineup
    allOtherPairs = _.without @props.pairs, currentPair
    _lineup.push _.sample allOtherPairs
    _lineup.push _.sample allOtherPairs

    # mix em up
    @lineup = _.shuffle _lineup

    `<div>
      <table className="matcher">
        <tbody>
          <tr>
            <td className="question" rowSpan="3">
              <div>{currentPair.name.data.value}</div>
              <div className="spoiler">spoiler: {currentPair.value.data.value}</div>
            </td>
            <td className="choice" onClick={this.handleClick.bind(this, 0)}>
              {this.lineup[0].value.data.value}
            </td>
          </tr>
          <tr>
            <td className="choice" onClick={this.handleClick.bind(this, 1)}>
              {this.lineup[1].value.data.value}
            </td>
          </tr>
          <tr>
            <td className="choice" onClick={this.handleClick.bind(this, 2)}>
              {this.lineup[2].value.data.value}
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
    total: 0

  componentWillMount: ->
    @responses = []
    vent.on 'scoreChanged', @handleScoreChanged
    vent.on 'setEditable', @handleEditableness
    vent.on 'challengesChanged', @handleChallenges

  componentWillUnmount: ->
    vent.off 'scoreChanged', @handleScoreChanged
    vent.off 'setEditable', @handleEditableness
    vent.off 'challengesChanged', @handleChallenges

  handleChallenges: ({ challenges }) ->
    @setState { challenges }

  handleEditableness: ({ editable }) ->
    @setState { editable }

  handleScoreChanged: ({ scores, total }) ->
    currentPairIndex = @state.currentPairIndex + 1
    @setState { currentPairIndex, scores, total }

  handleResponse: (response) ->
    @scoreChallenge response.value

  scoreChallenge: (response) ->
    challenge = _.first @state.challenges
    @responses[@state.currentPairIndex] = response
    vent.trigger 'scoreChallenges', [ @responses ]

  render: ->
    if @state.editable
      `<AuthorView
        challenges={this.state.challenges}
        player={this.props.player} />`

    else if @state.challenges.length
      challenge = _.first @state.challenges
      pairs = challenge.prompt

      score = Math.floor @state.total * 100
      scoreDisplay = if @state.currentPairIndex
        if @state.currentPairIndex < pairs.length
          `<div className="score">{score}%</div>`
        else
          `<div className="score">{score}% Done!</div>`
      else
        `<div></div>`

      learnerDisplay = if @state.currentPairIndex < pairs.length
        `<LearnerView
          currentPairIndex={this.state.currentPairIndex}
          pairs={pairs}
          handleResponse={this.handleResponse} />`
      else
        `<div></div>`

      display =
        `<div>
          { learnerDisplay }
          { scoreDisplay }
        </div>`

      return display

    else
      `<div>Uh oh, needs a challenge!</div>`

window.SorterView = SorterView
