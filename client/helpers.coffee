Handlebars.registerHelper 'match', (options) ->
  # Match a key-value hash against the current scope and act as an if/else
  # block, depending on their equality
  for k, v of options.hash
    if v isnt this[k]
      # Return false if any of the compared keys have a different value in the
      # current scope
      return options.inverse(this)
  return options.fn(this)

Handlebars.registerHelper 'markdown', (text, options) ->
  if options.hash.root
    # Extract the root element of each block (which would be paragraphs) and
    # replace it with a different DOM element
    tree = markdown.toHTMLTree(text)
    # Ignore the first tree element, which is "html"
    block[0] = options.hash.root for block in tree[1...]
    return markdown.renderJsonML(tree)
  else
    return markdown.toHTML(text)
