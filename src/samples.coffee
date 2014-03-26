samples =
  spanishPhrases: ->
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

window.samples =
  getChallenge: (name) ->
    return samples[name]()
