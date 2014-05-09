`/** @jsx React.DOM */`

AuthorView = React.createClass

  handleClick: (challengeName) ->
    challenge = samples.getChallenge challengeName
    playerTrigger 'setLearnerState', { challengeName }
    window.challengesApi.setChallenges [challenge]
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

window.AuthorView = AuthorView
