class window.PlayScreen extends GameScreen

  ROSHKI_IMAGES = ["images/roshki1.png", "images/roshki2.png", "images/roshki3.png", "images/roshki4.png"]
  MOVEMENT_KEYS = [KeyEvent.A, KeyEvent.S, KeyEvent.D, KeyEvent.F]

  roshki = null
  spriteIndex = 0
  velocity = 0

  constructor: () ->
    super()

    # sky
    skyImg = game.preload.getResult "skyImage"
    sky = new createjs.Shape new createjs.Graphics().beginBitmapFill(skyImg).drawRect(0, 0, 960, 400)
    @container.addChild sky

    # buildings
    cityImg1 = game.preload.getResult "cityImage1"
    @background1 = new createjs.Shape new createjs.Graphics().beginBitmapFill(cityImg1).drawRect(0, 0, 8000, 400)
    cityImg2 = game.preload.getResult "cityImage2"
    @background2 = new createjs.Shape new createjs.Graphics().beginBitmapFill(cityImg2).drawRect(0, 0, 8000, 400)
    @container.addChild @background2
    @container.addChild @background1

    # roshki
    roshki = new createjs.Bitmap ROSHKI_IMAGES[0]
    roshki.x = 20
    roshki.y = 330
    @container.addChild roshki

    # speedometer
    @speedometer = new createjs.Text "0 mph", "20px silom"
    @speedometer.x = game.CANVAS_WIDTH - 100
    @speedometer.y = 20
    @container.addChild @speedometer

  handlePressed: (key) ->
    if key == MOVEMENT_KEYS[spriteIndex]
      spriteIndex = (spriteIndex + 1) % ROSHKI_IMAGES.length
      velocity += 1
    else
      velocity -= 0.5

  tick: () ->
    # slowly decelerate
    velocity -= 0.005 * velocity
    velocity = 0 if velocity < 0 

    # move background to give impression of running
    @background1.x -= velocity
    @background2.x -= velocity

    # spriteIndex = (spriteIndex + 1) % ROSHKI_IMAGES.length
    roshki.image.src = ROSHKI_IMAGES[spriteIndex]

    # update speedometer
    @speedometer.text = "#{Math.round(velocity)} mph"
