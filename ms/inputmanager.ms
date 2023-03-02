// Abstraction layer for all input options
// supports keyboard, gamepad and touchscreen

// Input Manager deals in devices. It reacts to raw device input and set actions in an object assigned to device.
// The rest of the game deals in actors - Player1 and Player2 variables. Those are used to read actions.
// The game cares that Player 1 wants to go up, not whether they used keyboard, gamepad or touch controls to announce that
// To make it work exactl same object is assigned to the device and to a player that selected specific device.
// For example, if player 1 selected keyboard, then:
//            this.Player1 = this.Keyboard = new InputAction()
// Because both variables "point" at the same object, InputManager can set action though one variable and everything else can read actions through second variable.

InputManager = class
//// constructor
  constructor = function()
    // flag marking, that controls are locked for specific player
    this.ControlsLocked = false
    
    // tells which player selected keyboard device 
    this.KeyboardPlayer = ""
    // tells which player selected gamepad device
    this.GamepadPlayer = ""
    // tells which player selected touch device
    this.TouchPlayer = ""
    
    // input actors
    this.Player1 = 0
    this.Player2 = 0
    
    // input devices
    this.Keyboard = 0
    this.Gamepad = 0
    this.Touch = 0
    
    // touch on-screen button bounds. Updated in DrawTouchControls in case of screen size change during gameplay
    // index 0 - button's center X
    // index 1 - button's center Y
    // index 2 - half of size
    this.TouchDpadUp = [0, 0, 0]
    this.TouchDpadLeft = [0, 0, 0]
    this.TouchDpadDown = [0, 0, 0]
    this.TouchDpadRight = [0, 0, 0]
    this.TouchDpadUpLeft = [0, 0, 0]
    this.TouchDpadUpRight = [0, 0, 0]
    this.TouchDpadDownLeft = [0, 0, 0]
    this.TouchDpadDownRight = [0, 0, 0]
    this.TouchFire = [0, 0, 0]
    this.TouchMenu = [0, 0, 0]
    
    // load required fonts
    screen.loadFont("EnterCommand")
  end
  
//// Init - Initialize Input Manager
  Init = function()
  end
  
//// Update - Update Input manager. Read input data from all devices
  // @deltaTime:number - amount of time that passed since last update
  Update = function(deltaTime)
    if ControlsLocked == false then InputSelectionControls()
    else
      if Keyboard != 0 then  UpdateKeyboard() end
      if Gamepad != 0 then UpdateGamepad() end
      if Touch != 0 then UpdateTouch() end
    end
  end
  
//// Draw - Draw input selection menu. Used for input selection screen at the beginning of game
  Draw = function()
    if screen.isFontReady("EnterCommand") then
      screen.setFont("EnterCommand")
      screen.drawText("WELCOME!", 0, 93, 20, "rgb(255,255,255)")
      screen.drawText("Before playing the game you need to select input device.", 0, 80, 10, "rgb(255,255,255)")
      
      screen.drawText("PLAYER 1 / MENU", -100, 57, 10)
      screen.drawText("PLAYER 2", 100, 57, 10)
      
      // keyboard
      local keyboardPosX = 0
      if KeyboardPlayer == "PLAYER1" then keyboardPosX = -100
      elsif KeyboardPlayer == "PLAYER2" then keyboardPosX = 100 end
      
      screen.drawSprite("keyboard_icon", keyboardPosX, 25, 75, 30) // keyboard icon
      screen.setAlpha(0.5)
      screen.fillRect(keyboardPosX, 26, 110, 15,"rgb(0,0,0)")
      screen.setAlpha(1)
      screen.drawText("Keyboard: W, A, S, D or arrow keys to move", keyboardPosX, 30, 6,"rgb(255,255,255)")
      screen.drawText("SPACE to shoot and ESC for pause menu", keyboardPosX, 23, 6,"rgb(255,255,255)")
      
      // gamepad
      local gamepadPosX = 0
      if GamepadPlayer == "PLAYER1" then gamepadPosX = -100
      elsif GamepadPlayer == "PLAYER2" then gamepadPosX = 100 end
      
      screen.drawSprite("gamepad_icon", gamepadPosX, -15, 55, 30) // gamepad icon
      screen.setAlpha(0.5)
      screen.fillRect(gamepadPosX, -14, 110, 15,"rgb(0,0,0)")
      screen.setAlpha(1)
      screen.drawText("Gamepad: D-pad to move", gamepadPosX, -10, 6, "rgb(255,255,255)")
      screen.drawText("X to shoot and MENU for pause menu", gamepadPosX, -17, 6, "rgb(255,255,255)")
      
      // touchscreen
      local touchPosX = 0
      if TouchPlayer == "PLAYER1" then touchPosX = -100
      elsif TouchPlayer == "PLAYER2" then touchPosX = 100 end
        
      screen.drawSprite("touchscreen_icon", touchPosX, -55, 55, 50) // touchscreen icon
      screen.setAlpha(0.5)
      screen.fillRect(touchPosX, -54, 110, 16,"rgb(0,0,0)")
      screen.setAlpha(1)
      screen.drawText("Touch: On-screen d-pad to move", touchPosX, -50, 6, "rgb(255,255,255)")
      screen.drawText("Touch     to shoot and     for pause menu", touchPosX, -57, 6, "rgb(255,255,255)")
      screen.drawSprite("fire_icon2", touchPosX-35, -57, 8, 8)
      screen.drawSprite("menu_icon", touchPosX+10, -57, 8, 8)
      
      // P1 SHOOT to continue / can't continue without P1 input selected
      if KeyboardPlayer == "PLAYER1" or GamepadPlayer == "PLAYER1" or TouchPlayer == "PLAYER1" then
        screen.drawText("Press SHOOT on PLAYER 1 device to continue!", 0, -95, 10, "rgb(255,255,255)")
      else
        screen.drawText("Can't continue before selecting input for PLAYER 1", 0, -95, 10, "rgb(255,255,255)")
      end
    else
      screen.drawText("Loading...", 0, -95, 10, "rgb(255,255,255)")
    end
  end
  
//// DrawTouchControls - draws on-screen controller. Called by draw() in main.ms if touch capability is detected
  DrawTouchControls = function()
    // calcualte X position of icon to anchor them to edge of the screen
    local dpadX = round(screen.width / 2) - 42 // 42 = 40+2. 40 is half of d-pad size when drawn on screen. 2 is offset from the edge
    local fireiconX = round(screen.width / 2) - 26 // 26 = 24+2. 24 is half of fire icon size when drawn on screen. 2 is offset from the edge
    screen.drawSprite("dpad", -dpadX, -58, 80, 80)
    
    screen.drawSprite("fire_icon2", fireiconX, -75, 48, 48)
    
    screen.drawSprite("menu_icon", fireiconX, 75, 48, 48)
    
    // store coords for "active" areas for each button. Those coords are later used to check if player touched screen within button areas
    // up
    TouchDpadUp[0] = -dpadX
    TouchDpadUp[1] = -30
    TouchDpadUp[2] = 15
    // left
    TouchDpadLeft[0] = -dpadX-28
    TouchDpadLeft[1] = -58
    TouchDpadLeft[2] = 15
    // down
    TouchDpadDown[0] = -dpadX
    TouchDpadDown[1] = -86
    TouchDpadDown[2] = 15
    // right
    TouchDpadRight[0] = -dpadX+28
    TouchDpadRight[1] = -58
    TouchDpadRight[2] = 15
    // up left
    TouchDpadUpLeft[0] = -dpadX-28
    TouchDpadUpLeft[1] = -30
    TouchDpadUpLeft[2] = 15
    // up right
    TouchDpadUpRight[0] = -dpadX+28
    TouchDpadUpRight[1] = -30
    TouchDpadUpRight[2] = 15
    // down left
    TouchDpadDownLeft[0] = -dpadX-28
    TouchDpadDownLeft[1] = -86
    TouchDpadDownLeft[2] = 15
    // down right
    TouchDpadDownRight[0] = -dpadX+28
    TouchDpadDownRight[1] = -86
    TouchDpadDownRight[2] = 15
    
    // fire
    TouchFire[0] = fireiconX
    TouchFire[1] = -75
    TouchFire[2] = 24
    // menu
    TouchMenu[0] = fireiconX
    TouchMenu[1] = 75
    TouchMenu[2] = 24
  end
  
//// IsInsideBounds - checks if supplied coords are inside touch button's bounds
  // @x:number - touch input on X axis
  // @y:number - touch input on Y axis
  // @bounds:int[] - one of the touch on-screen button's bounds
  IsInsideBounds = function(x, y, bounds)
    // x must be between center-size/2 and center+size/2. Center for x axis is bounds[0]. bounds[2] is size/2
    // y must be between center-size/2 and center+size/2. Center for y axis is bounds[1]. bounds[2] is size/2
    
    // if x or y are outside of bounds, return false
    if x < (bounds[0] - bounds[2]) then return false end
    if x > (bounds[0] + bounds[2]) then return false end
    if y < (bounds[1] - bounds[2]) then return false end
    if y > (bounds[1] + bounds[2]) then return false end
    return true
  end
  
//// UpdateTouch - update touch raw input
  UpdateTouch = function()
    if system.inputs.touch then
      if touch.touching then
        for t in touch.touches
          if IsInsideBounds(t.x, t.y, TouchDpadUp) or IsInsideBounds(t.x, t.y, TouchDpadUpLeft) or IsInsideBounds(t.x, t.y, TouchDpadUpRight) then 
            // if action is not yet set, that means this is the first update where it would be, so Begin needs to be set
            if this.Touch.Up == false then this.Touch.UpBegin = true else this.Touch.UpBegin = false end
            this.Touch.Up = true 
          else this.Touch.Up = false end
          
          if IsInsideBounds(t.x, t.y, TouchDpadLeft) or IsInsideBounds(t.x, t.y, TouchDpadUpLeft) or IsInsideBounds(t.x, t.y, TouchDpadDownLeft) then 
            if this.Touch.Left == false then this.Touch.LeftBegin = true else this.Touch.LeftBegin = false end
            this.Touch.Left = true 
          else this.Touch.Left = false end
          
          if IsInsideBounds(t.x, t.y, TouchDpadDown) or IsInsideBounds(t.x, t.y, TouchDpadDownLeft) or IsInsideBounds(t.x, t.y, TouchDpadDownRight) then 
            if this.Touch.Down == false then this.Touch.DownBegin = true else this.Touch.DownBegin = false end
            this.Touch.Down = true 
          else this.Touch.Down = false end
          
          if IsInsideBounds(t.x, t.y, TouchDpadRight) or IsInsideBounds(t.x, t.y, TouchDpadUpRight) or IsInsideBounds(t.x, t.y, TouchDpadDownRight) then 
            if this.Touch.Right == false then this.Touch.RightBegin = true else this.Touch.RightBegin = false end
            this.Touch.Right = true 
          else this.Touch.Right = false end
          
          if IsInsideBounds(t.x, t.y, TouchFire) then 
            if this.Touch.Fire == false then this.Touch.FireBegin = true else this.Touch.FireBegin = false end
            this.Touch.Fire = true 
          else this.Touch.Fire = false end
          
          if IsInsideBounds(t.x, t.y, TouchMenu) then 
            if this.Touch.Menu == false then this.Touch.MenuBegin = true else this.Touch.MenuBegin = false end
            this.Touch.Menu = true 
          else this.Touch.Menu = false end
        end
      else
        this.Touch.Reset()
      end
    end
  end
  
//// UpdateKeyboard - update keyboard raw input
  UpdateKeyboard = function()
    if keyboard.W or keyboard.ARROW_UP then this.Keyboard.Up = true else this.Keyboard.Up = false end
    if keyboard.A or keyboard.ARROW_LEFT then this.Keyboard.Left = true else this.Keyboard.Left = false end
    if keyboard.S or keyboard.ARROW_DOWN then this.Keyboard.Down = true else this.Keyboard.Down = false end
    if keyboard.D or keyboard.ARROW_RIGHT then this.Keyboard.Right = true else this.Keyboard.Right = false end
    if keyboard.SPACE then this.Keyboard.Fire = true else this.Keyboard.Fire = false end
    if keyboard.ESCAPE then this.Keyboard.Menu = true else this.Keyboard.Menu = false end
    if keyboard.press.W or keyboard.press.ARROW_UP then this.Keyboard.UpBegin = true else this.Keyboard.UpBegin = false end
    if keyboard.press.A or keyboard.press.ARROW_LEFT then this.Keyboard.LeftBegin = true else this.Keyboard.LeftBegin = false end
    if keyboard.press.S or keyboard.press.ARROW_DOWN then this.Keyboard.DownBegin = true else this.Keyboard.DownBegin = false end
    if keyboard.press.D or keyboard.press.ARROW_RIGHT then this.Keyboard.RightBegin = true else this.Keyboard.RightBegin = false end
    if keyboard.press.SPACE then this.Keyboard.FireBegin = true else this.Keyboard.FireBegin = false end
    if keyboard.press.ESCAPE then this.Keyboard.MenuBegin = true else this.Keyboard.MenuBegin = false end
  end
  
//// UpdateGamepad - update gamepad raw input
  UpdateGamepad = function()
    if gamepad.DPAD_UP then this.Gamepad.Up = true else this.Gamepad.Up = false end
    if gamepad.DPAD_LEFT then this.Gamepad.Left = true else this.Gamepad.Left = false end
    if gamepad.DPAD_DOWN then this.Gamepad.Down = true else this.Gamepad.Down = false end
    if gamepad.DPAD_RIGHT then this.Gamepad.Right = true else this.Gamepad.Right = false end
    if gamepad.X then this.Gamepad.Fire = true else this.Gamepad.Fire = false end
    if gamepad.MENU then this.Gamepad.Menu = true else this.Gamepad.Menu = false end
    if gamepad.press.DPAD_UP then this.Gamepad.UpBegin = true else this.Gamepad.UpBegin = false end
    if gamepad.press.DPAD_LEFT then this.Gamepad.LeftBegin = true else this.Gamepad.LeftBegin = false end
    if gamepad.press.DPAD_DOWN then this.Gamepad.DownBegin = true else this.Gamepad.DownBegin = false end
    if gamepad.press.DPAD_RIGHT then this.Gamepad.RightBegin = true else this.Gamepad.RightBegin = false end
    if gamepad.press.X then this.Gamepad.FireBegin = true else this.Gamepad.FireBegin = false end
    if gamepad.press.MENU then this.Gamepad.MenuBegin = true else this.Gamepad.MenuBegin = false end
  end
  
//// InputSelectionControls - updates input selection state. Only available at the beginning, while controls are not locked
  InputSelectionControls = function()
    if keyboard.press.A or keyboard.press.ARROW_LEFT then
      // move keyboard control left
      if KeyboardPlayer == "PLAYER2" then KeyboardPlayer = ""
      elsif KeyboardPlayer == "" and GamepadPlayer != "PLAYER1" and TouchPlayer != "PLAYER1" then KeyboardPlayer = "PLAYER1" end
    end
    if keyboard.press.D or keyboard.press.ARROW_RIGHT then
      // move keyboard control right
      if KeyboardPlayer == "PLAYER1" then KeyboardPlayer = ""
      elsif KeyboardPlayer == "" and GamepadPlayer != "PLAYER2" and TouchPlayer != "PLAYER2" then KeyboardPlayer = "PLAYER2" end
    end
    if keyboard.press.SPACE then
      if KeyboardPlayer == "PLAYER1" then
        LockControls()
      end
    end
    
    if gamepad.press.DPAD_LEFT then
      if GamepadPlayer == "PLAYER2" then GamepadPlayer = ""
      elsif GamepadPlayer == "" and KeyboardPlayer != "PLAYER1" and TouchPlayer != "PLAYER1" then GamepadPlayer = "PLAYER1" end
    end
    if gamepad.press.DPAD_RIGHT then
      if GamepadPlayer == "PLAYER1" then GamepadPlayer = ""
      elsif GamepadPlayer == "" and KeyboardPlayer != "PLAYER2" and TouchPlayer != "PLAYER2" then GamepadPlayer = "PLAYER2" end
    end
    if gamepad.press.X then
      if GamepadPlayer == "PLAYER1" then
        LockControls()
      end
    end
    
    if touch.touching and touch.press then
      if IsInsideBounds(touch.x, touch.y, TouchDpadLeft) then
        if TouchPlayer == "PLAYER2" then TouchPlayer = ""
        elsif TouchPlayer == "" and KeyboardPlayer != "PLAYER1" and GamepadPlayer != "PLAYER1" then TouchPlayer = "PLAYER1" end
      end
      if IsInsideBounds(touch.x, touch.y, TouchDpadRight) then
        if TouchPlayer == "PLAYER1" then TouchPlayer = ""
        elsif TouchPlayer == "" and KeyboardPlayer != "PLAYER2" and GamepadPlayer != "PLAYER2" then TouchPlayer = "PLAYER2" end
      end
      if IsInsideBounds(touch.x, touch.y, TouchFire) then
        if TouchPlayer == "PLAYER1" then
          LockControls()
        end
      end
    end
  end
  
//// LockControls - called when player confirmed input device selection
  LockControls = function()
    // lock control selection
    ControlsLocked = true
    
    // assign input devices
    // assign same object to two variables so it can be accessed from device and player side
    // this makes exchanging info between Input Manager and Player Controller easier
    if KeyboardPlayer == "PLAYER1" then Player1 = new InputActions() Keyboard = Player1 end
    if KeyboardPlayer == "PLAYER2" then Player2 = new InputActions() Keyboard = Player2 end
    
    if GamepadPlayer == "PLAYER1" then Player1 = new InputActions() Gamepad = Player1 end
    if GamepadPlayer == "PLAYER2" then Player2 = new InputActions() Gamepad = Player2 end
    
    if TouchPlayer == "PLAYER1" then Player1 = new InputActions() Touch = Player1 Touch.Fire = true end
    if TouchPlayer == "PLAYER2" then Player2 = new InputActions() Touch = Player2 Touch.Fire = true end
    // 'Touch.Fire = true' artificaly sets state of InputActions what is most probable at this time.
    // To call LockControls() player had to touch TouchFire button and it's almost impossible that they will release the button fast enough to not holding when Main Menu is displayed
    // Since new InputAction is created player still holding button would be registered as new press, causing to click through the main menu.
    
    InputInitialized() // defined in main.ms
  end
end