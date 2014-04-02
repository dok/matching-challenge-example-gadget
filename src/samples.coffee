samples =
  'spanish phrases': ->
    prompt = _.map spanishPhrases, (phrase) ->
      name:
        type: 'text'
        data:
          value: phrase.spanish
      value:
        type: 'text'
        data:
          value: phrase.english

    answers = _.map spanishPhrases, (phrase) ->
      type: 'text'
      data:
        value: phrase.english

    scoring = 'partial'

    { prompt, answers, scoring }

  colors: ->
    prompt = _.map colors, (color) ->
      name:
        type: 'text'
        data:
          value: color
      value:
        type: 'color'
        data:
          value: color

    answers = _.map colors, (color) ->
      type: 'color'
      data:
        value: color

    scoring = 'partial'

    { prompt, answers, scoring }

  versalers: ->
    prompt = _.map versalers, (versaler) ->
      name:
        type: 'text'
        data:
          value: _.first versaler.name.split(' ')
      value:
        type: 'image'
        data:
          value: "https://versal.com/assets/img/about/#{versaler.image}"

    answers = _.map versalers, (versaler) ->
      type: 'image'
      data:
        value: "https://versal.com/assets/img/about/#{versaler.image}"

    scoring = 'partial'

    { prompt, answers, scoring }

window.samples =
  getChallenge: (name) ->
    return samples[name]()
