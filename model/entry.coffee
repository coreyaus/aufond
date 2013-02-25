class EntryCollection extends MeteorCollection
  toJSON: ->
    entries = super()
    for entry, i in entries
      entry.index = i + 1
    return entries


class Entry extends MeteorModel
  @collection: EntryCollection
  @mongoCollection: new Meteor.Collection 'entries'

  @getByYears: ->
    ###
      Create list with year separators and entry items aggregated into a single
      collection. The items share a common _type_ key ("post" or "year")
    ###
    items = []
    year = null
    for entry in @get({}, sort: {time: -1}).toJSON()
      # Push the year entry before the first entry from that year
      if entry.year isnt year
        year = entry.year
        items.push
          type: 'year'
          year: year
      # Add the type key to the entry data
      items.push _.extend {type: 'post'}, entry
    return items

  update: (data) ->
    if data.hasOwnProperty('date')
      data.time = @getTimeFromDate(data.date)
    super(data)

  toJSON: ->
    data = super()
    data.year = @getYear()
    return data

  validate: ->
    return "Headline can't be empty" unless @get('headline').length
    return "Invalid date" if isNaN(@getTimeFromDate(@get('date')))

  getYear: ->
    return new Date(@get('time')).getFullYear()

  getTimeFromDate: (date) ->
    return Date.parse(date)