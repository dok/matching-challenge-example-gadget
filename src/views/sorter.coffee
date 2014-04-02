`/** @jsx React.DOM */`

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
