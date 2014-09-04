class Tooltip extends Widget

  opts:
    el:""
    content:""
    position:"auto"


  tpl: """
    <div class="simple-tooltip">
      <div class="arrow"></div>
      <div class="content"></div>
    </div>
  """

  #arrow三角形的底与高,与scss文件中保持一致
  arrowHeight:5
  arrowBase: 10

  #tooltip show的时候相对于target的偏移距离
  offset:10

  #position代表tooltip相对于element的方向,top,bottom,left,right
  _init: () ->
    @target = $(@opts.el).first()
    if @target.length == 0
      throw "Must provide a valid selector"

    if @opts.content == ""
      throw "Tooltip's content can't  be empty"

    if @target.data('simple-tooltip')
      @target.data('simple-tooltip').destroy()


    @position = null
    @top = 0
    @left = 0

    @_render()

  _render: () ->
    @el = $(@tpl)
    @el.find('.content').html(@opts.content)
    @arrow = @el.find('.arrow')
    @target.data "simple-tooltip", @

  setPosition:()->
    viewportWidth = $(window).width()
    scrollTop = $(window).scrollTop()
    viewportHeigth = $(window).height()
    scrollLeft = $(window).scrollLeft()

    @targetOffset = @target.offset()
    @targetWidth = @target.outerWidth()
    @targetHeight = @target.outerHeight()

    @tooltipWidth = @el.outerWidth()
    @tooltipHeight = @el.outerHeight()

    @position = @opts.position
    if @position == "auto"
      if @targetOffset.top + @targetHeight + @tooltipHeight + @arrowHeight + @offset < viewportHeigth + scrollTop
        @position = 'bottom'
      else if @targetOffset.top - @tooltipHeight - @arrowHeight - @offset > 0
        @position = 'top'
      else if @targetOffset.left - @tooltipWidth - @arrowHeight - @offset > 0
        @position = 'left'
      else if @targetOffset.left + @targetWidth + @tooltipWidth + @arrowHeight + @offset < viewportWidth + scrollLeft
        @position = 'right'

    switch @position
      when 'bottom'
        @left = @targetOffset.left + (@targetWidth - @tooltipWidth)*0.5
        @top = @targetOffset.top + @targetHeight + @arrowHeight
        @setArrow 'up'

      when 'top'
        @left = @targetOffset.left + (@targetWidth - @tooltipWidth)*0.5
        @top = @targetOffset.top - @tooltipHeight - @arrowHeight
        @setArrow 'down'

      when 'left'
        @left = @targetOffset.left - @tooltipWidth - @arrowHeight
        @top = @targetOffset.top + (@targetHeight - @tooltipHeight)*0.5
        @setArrow "right"

      when 'right'
        @left = @targetOffset.left + @targetWidth + @arrowHeight
        @top = @targetOffset.top + (@targetHeight - @tooltipHeight)*0.5
        @setArrow "left"

  setArrow:(orientation)->
    @arrow.removeClass 'up down left right'
      .addClass orientation

    switch orientation
      when 'up'
        @arrow.css
          left: @tooltipWidth/2  - @arrowBase/2
          top: -@arrowHeight
      when 'down'
        @arrow.css
          left: @tooltipWidth/2  - @arrowBase/2
          top: @tooltipHeight

      when 'left'
        @arrow.css
          left: -@arrowHeight
          top: @tooltipHeight/2 - @arrowBase/2
      when 'right'
        @arrow.css
          left: @tooltipWidth
          top: @tooltipHeight/2 - @arrowBase/2

  show:->
    @el.appendTo 'body'
    @setPosition()
    @el.css
      left: @left
      top: @top
      opacity:0
    @el.show()
    @el[0].offsetHeight  #force reflow

    top = @top
    left = @left
    switch @position
      when 'top'
        top -= @offset
      when 'bottom'
        top += @offset
      when 'left'
        left -= @offset
      when 'right'
        left += @offset

    @el.css
      top: top
      left: left
      opacity:1

  hide:->
    @el.css
      opacity: 0
      left: @left
      top: @top

    @el.one 'transitionend webkitTransitionEnd', =>
      @el.hide().remove()
      @position = null


  destroy:->
    @el.remove()
    @target.removeData 'tooltip'


window.simple ||= {}

simple.tooltip = (opts)->
  new Tooltip(opts)


