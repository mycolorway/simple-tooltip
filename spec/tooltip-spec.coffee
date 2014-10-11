describe "tooltip", ->

  opts =
    content: "test string"
    position: "auto"
    el: ".tooltip"

  html = """
    <div class='tooltip'>Test Tooltip</div>
  """
  $(html).appendTo 'body'

  beforeEach: ->
    $('.simple-tooltip').remove()

  it "should show when method show method call", ->
    tooltip = simple.tooltip opts
    tooltip.show()
    expect($('.simple-tooltip').length).toBe(1)

  it "should destroy when hide destroy call", ->
    tooltip = simple.tooltip opts
    tooltip.show()
    tooltip.destroy()
    expect($('.simple-tooltip').length).toBe(0)

  it "should show different class when different position give", ->
    opts.position = 'top'
    tooltip = simple.tooltip opts
    tooltip.show()
    expect($('.arrow').hasClass('down')).toBe(true)

    tooltip.destroy()
    opts.position = 'bottom'
    tooltip = simple.tooltip opts
    tooltip.show()
    expect($('.arrow').hasClass('up')).toBe(true)

    tooltip.destroy()
    opts.position = 'left'
    tooltip = simple.tooltip opts
    tooltip.show()
    expect($('.arrow').hasClass('right')).toBe(true)

    tooltip.destroy()
    opts.position = 'right'
    tooltip = simple.tooltip opts
    tooltip.show()
    expect($('.arrow').hasClass('left')).toBe(true)