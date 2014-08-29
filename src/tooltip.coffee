class Tooltip extends Widget

  opts:
    el:""
    content:""
    position:"auto"


  tpl: """
    <div class="simple-tooltip">
      <div class="arrow"></div>
      <div class="content"></div>
    <div>
  """

  #arrow三角形的底与高,与scss文件中保持一致
  arrowHeight:10
  arrowBase: 20

  #鼠标mouseenter进入target元素时,tooltip transition的距离
  transitionSize:15

  #position代表tooltip相对于element的方向,top,bottom,left,right
  _init: () ->
    @target = $(@opts.el).first()
    if @target.length == 0
      throw "Must provide a valid selector"

    if @opts.content == ""
      throw "Tooltip's content can't  be empty"

    if @target.data('tooltip')
      @target.data('tooltip').destroy()


    @position = @opts.position
    @top = 0
    @left = 0

    @_render()
    @_bind()



  _render: () ->
    @el = $(@tpl)
    $(".content",@el).text(@opts.content)
    @arrow = $('.arrow',@el)
    @el.appendTo 'body'
    @target.data "tooltip",@

    viewportWidth = $(window).width()
    scrollTop = $(window).scrollTop()
    viewportHeigth = $(window).height()
    scrollLeft = $(window).scrollLeft()

    @targetOffset = @target.offset()
    @targetWidth = @target.outerWidth()
    @targetHeight = @target.outerHeight()

    @tooltipWidth = @el.outerWidth()
    @tooltipHeight = @el.outerHeight()


    if @position == "auto"

      if @targetOffset.top + @targetHeight + @tooltipHeight + @arrowHeight + @transitionSize < viewportHeigth + scrollTop
        return @setPosition "bottom"

      if @targetOffset.top - @tooltipHeight - @arrowHeight - @transitionSize > 0
        return @setPosition "top"

      if @targetOffset.left - @tooltipWidth - @arrowHeight - @transitionSize > 0
        return @setPosition "left"

      if @targetOffset.left + @targetWidth + @tooltipWidth + @arrowHeight + @transitionSize < viewportWidth + scrollLeft
        return @setPosition "right"

    else
      @setPosition @opts.position

  setPosition:(pos)->
    switch pos
      when 'bottom'
        @position = "bottom"
        @left = @targetOffset.left + (@targetWidth - @tooltipWidth)*0.5
        @top = @targetOffset.top + @targetHeight + @arrowHeight
        @setArrow 'up'

      when 'top'
        @position = "top"
        @left = @targetOffset.left + (@targetWidth - @tooltipWidth)*0.5
        @top = @targetOffset.top - @tooltipHeight - @arrowHeight
        @setArrow 'down'

      when 'left'
        @position = "left"
        @left = @targetOffset.left - @tooltipWidth - @arrowHeight
        @top = @targetOffset.top + (@targetHeight - @tooltipHeight)*0.5
        @setArrow "right"

      when 'right'
        @position = "right"
        @left = @targetOffset.left + @targetWidth + @arrowHeight
        @top = @targetOffset.top + (@targetHeight - @tooltipHeight)*0.5
        @setArrow "left"

    @el.css
      left:@left
      top:@top

  setArrow:(orientation)->
    @arrow.addClass orientation
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

  _bind: ->
    @target.on 'mouseenter.tooltip',=>
      @el.css
        opacity:1
        "z-index":9999

      switch @position
        when 'top'
          @el.css
            top: @top - @transitionSize
        when 'bottom'
          @el.css
            top: @top + @transitionSize
        when 'left'
          @el.css
            left: @left - @transitionSize
        when 'right'
          @el.css
            left: @left + @transitionSize

    @target.on 'mouseleave.tooltip',=>
      @el.css
        opacity:0
        "z-index":-9999
      @el.css
        left:@left
        top:@top

  destroy: () ->
    @el.remove()
    @target.off('.tooltip')



window.simple ||= {}

simple.tooltip=(opts)->
  new Tooltip(opts)


