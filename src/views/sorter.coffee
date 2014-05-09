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
    vent.on 'setEditable', @handleEditableness
    vent.on 'learnerStateChanged', @handleLearnerStateChanged
    vent.on 'updateChallenges', @handleChallenges

  componentDidMount: ->
    playerTrigger 'setHeight', pixels: 260

  componentWillUnmount: ->
    window.challengesApi.destroy()
    vent.off 'setEditable', @handleEditableness
    vent.off 'learnerStateChanged', @handleLearnerStateChanged
    vent.off 'updateChallenges', @handleChallenges

  handleChallenges: ({challenges, scoring}) ->
    { scores, totalScore, responses } = scoring
    currentPairIndex = _.first(responses)?.length || 0
    @setState { challenges, currentPairIndex, scores, totalScore, responses }

  handleEditableness: ({ editable }) ->
    @setState { editable }

  handleLearnerStateChanged: (learnerState) ->
    @setState _.pick learnerState, 'challengeName'

  handleResponse: (response) ->
    @scoreChallenge response.value

  handleReset: ->
    # NOTE might be something we want the API to do for us, e.g. { event: 'resetScores' }
    window.challengesApi.scoreChallenges [[]]

  scoreChallenge: (_response) ->
    responses = _.clone @state.responses
    response = _.first(responses) || []

    response[@state.currentPairIndex] = _response
    window.challengesApi.scoreChallenges [response]

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
