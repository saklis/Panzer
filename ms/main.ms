// MAIN - Game entry point

// Current game state. Possible options are:
// INPUTSELECT - one time input method selection screen that shows up after game start
// MAINMENU - game's main menu. Start new game. Perhaps some settings. Quit game
// INTERMISSION - screen shown before each mission, at game over and when player finishes the game
// GAME - gameplay
// PAUSE - game pause menu. Continue or quit current level
GameState = "INPUTSELECT"

// Global InputManager - input abstraction layer 
Input = 0

// Global MenuManager - display and handles main menu logic
Menu = 0

// Global GameManager - handles gameplay logic and draw
Game = 0

// Global SoundManager - handles sound effects and background music.
Noise = 0 // variable renamed to Noise after switching to microScript v2, in which Sound is a reserved global variable name. So I'll make some Noise instead :D

// Global variable to keep track of current level's DB index
GameLevelIndex = -1
// Global variable to keep track of player(s) score between levels. Reset on BeginNewCampaign()
GameScore = 0
GamePlayer1Kills = 0
GamePlayer2Kills = 0

// InputInitialized - informs main game that InputManager finished setting up input. Called by Inputmanager.LockControls()
InputInitialized = function()
  GameState = "MAINMENU"
  Noise.PlayMainMenuMusic()
end

// GameInit - called in InputManager, switches game state to GAME to begin next level
GameInit = function()
  Game.CurrentLevelIndex = GameLevelIndex
  Game.Init()
  GameState = "GAME"
  
  Noise.PlayGameBackgroundMusic(GameLevelIndex)
end

// BeginNewCampaign - begin new campaing. Show intermission screen for new campaing
BeginNewCampaign = function()
  GameScore = 0
  GamePlayer1Kills = 0
  GamePlayer2Kills = 0

  GameLevelIndex = -1
  GameState = "INTERMISSION"
  Menu.CurrentMenu = "INTERMISSION"
  Menu.PreviousLevelResult = 0
  
  Noise.StopMusic()
  Noise.PlayNewGameEffect()
end

// GameFinished - game ended with player winning or loosing. Load next level or go back to main menu
// playerWon:bool - if 'true', then player won the game
GameFinished = function(playerWon)
  if Game.Score > 0 then GameScore += round(Game.Score) end // VERY long or very bad games can have score lower than zero. Don't take that into account, because having negative score sucks ;-)
  GamePlayer1Kills += Game.Player1Kills
  GamePlayer2Kills += Game.Player2Kills
  
  GameState = "INTERMISSION"
  Menu.CurrentMenu = "INTERMISSION"
  if playerWon then
    Menu.PreviousLevelResult = "PLAYERWON"
    
    // if there is no more levels, it means that player just won lvl 20. Congrats!
    local nextLevelExists = (GameLevelIndex + 1) < Database.Levels.length
    if nextLevelExists == false then Noise.PlayCampaignWonMusic() end
  else
    Menu.PreviousLevelResult = "PLAYERLOST"
    Noise.PlayCampaignLostMusic()
  end
end

// NextLevel - begins game on next level. Called from MenuManager in INTERMISSION mode
NextLevel = function()
  GameLevelIndex += 1
  GameInit()
end

// GoToMainMenu - returns to main menu when the game is over. Called from MenuManager in INTERMISSION mode
GoToMainMenu = function()
  GameState = "MAINMENU"
  Menu.CurrentMenu = "MAINMENU"
  Noise.PlayMainMenuMusic()
end

// PauseGame - pauses and resumes game, displaying pause menu
PauseGame = function()
  if GameState == "GAME" then 
    GameState = "PAUSE"
    Menu.CurrentMenu = "PAUSEMENU"
  elsif GameState == "PAUSE" then 
    GameState = "GAME" 
  end
end

// MicroStudio.init function
init = function()
  // initialize game objects
  Input = new InputManager()
  Noise = new SoundManager()
  Menu = new MenuManager()
  Game = new GameManager()
end

// MicroStudio.updatye function
update = function()
  Input.Update(1/60) // update input no matter which state
  if GameState == "MAINMENU" then Menu.Update(1/60) end
  if GameState == "GAME" then Game.Update(1/60) end
  if GameState == "INTERMISSION" then Menu.Update(1/60) end
  if GameState == "PAUSE" then Menu.Update(1/60) end
end

// MicroStudio.draw function
draw = function()
  screen.clear()
  
  if GameState == "INPUTSELECT" then Input.Draw() end
  if GameState == "MAINMENU" then Menu.Draw() end
  if GameState == "GAME" then Game.Draw() end
  if GameState == "INTERMISSION" then Menu.Draw() end
  if GameState == "PAUSE" then
    // on pose menu, draw game and overlay pause menu over it
    Game.Draw()
    Menu.Draw()
  end
  
  if system.inputs.touch then 
    Input.DrawTouchControls() 
  end
end