class window.Game


  ############## PRIVATE METHODS #############
  _tick = () ->
    @stage.update()
    @currentScreen.tick() if @currentScreen != undefined

  _toggleSound = () ->
    @mute = not @mute
    createjs.Sound.setMute @mute
    if @mute
        $("#mute").html "Unmute Sound"
    else
        $("#mute").html "Mute Sound"


  _keyHandler = (e, isPressed, keyPressedTxt) ->
    # prevent scrolling 
    e.preventDefault()
    switch e.keyCode
      when KeyEvent.A then @playScreen.handlePressed KeyEvent.A
      when KeyEvent.S then @playScreen.handlePressed KeyEvent.S
      when KeyEvent.D then @playScreen.handlePressed KeyEvent.D
      when KeyEvent.F then @playScreen.handlePressed KeyEvent.F

  _onDoneLoadingResources = (loadingProgressTxt) ->
    # start the music
    @stage.removeChild loadingProgressTxt
    createjs.Sound.play "music", createjs.Sound.INTERRUPT_NONE, 0, 0, -1, 0.25

    # add start menu
    @startMenuScreen = new StartMenu()

    # add instructions menu
    @instructionsScreen = new InstructionsMenu()

    # create play screen
    @playScreen = new PlayScreen()

    # start off at start menu
    @switchToStartMenuScreen()

    # handle keyboard key presses
    kh = _keyHandler.bind @
    window.onkeydown = (e) ->
      kh e, false
    window.onkeyup = (e) ->
      kh e, true

  _updateLoadingResources = (loadingProgressTxt, preload) ->
    loadingProgressTxt.text = "Loading " + (preload.progress*100|0) + "%"
    @stage.update()

  _switchScreenTo = (targetScreen) ->
    screens = [@playScreen, @startMenuScreen, @instructionsScreen]
    for screen in screens
      if screen == targetScreen 
        screen.activateScreen @stage
        @currentScreen = targetScreen
      else
        screen.removeScreen @stage


  ################## PUBLIC METHODS ##################
  switchToPlayScreen: () ->
    _switchScreenTo.call @, @playScreen

  switchToStartMenuScreen: () ->
    _switchScreenTo.call @, @startMenuScreen

  switchToInstructionsScreen: () ->
    _switchScreenTo.call @, @instructionsScreen

  init: () ->

    # get a reference to the canvas we'll be working with:
    canvas = document.getElementById "gameCanvas"

    # create a stage object to work with the canvas. This is the top level node in the display list:
    @stage = new createjs.Stage canvas

    @CANVAS_WIDTH = canvas.width
    @CANVAS_HEIGHT = canvas.height

    # start game timer   
    if not createjs.Ticker.hasEventListener "tick"
      createjs.Ticker.addEventListener "tick", _tick.bind @

    createjs.Ticker.setFPS 60

    # sounds to load
    manifest = [
      id: "music",
      src: "assets/music.mp3"
    ,  
      id: "skyImage",
      src: "images/sky-orange.png"
    ,  
      id: "cityImage1",
      src: "images/simpleCity1.png"
    ,  
      id: "cityImage2",
      src: "images/simpleCity2.png"
    ]
    
    # show loading 
    loadingProgressTxt = new createjs.Text "Loading", "bold 24px Arial", "#000"
    loadingProgressTxt.maxWidth = 1000
    loadingProgressTxt.textAlign = "center"
    loadingProgressTxt.x = canvas.width / 2
    loadingProgressTxt.y = canvas.height / 2
    @stage.addChild loadingProgressTxt

    # begin loading content
    @preload = new createjs.LoadQueue()
    @preload.installPlugin createjs.Sound
    @preload.addEventListener "progress", _updateLoadingResources.bind @, loadingProgressTxt, @preload
    @preload.addEventListener "complete", _onDoneLoadingResources.bind @, loadingProgressTxt
    @preload.loadManifest manifest

    # mute button event 
    $("#mute").click _toggleSound
    @mute = false

window.game = new Game()
game.init()