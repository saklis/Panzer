// Sound manager. Handles playing sounds and background music. Single instance is created in main.ms

SoundManager = class
//// constructor
  constructor = function()
    // reference to currently playing music. If 0 then no music is playing
    this.CurrentMusic = 0
  end
  
//// PlayMainMenuMusic - plays main menu music. Stops any other music if there is any
  PlayMainMenuMusic = function()
    StopMusic()
    
    CurrentMusic = audio.playMusic("titlescreen", 0.3, true)
    CurrentMusic.play()
  end
  
//// PlayGameBackgroundMusic - play background music for current level
  // @levelnumber:uint - number of current level
  PlayGameBackgroundMusic = function(levelNumber)
    StopMusic()
    
    local musicNumber = levelNumber%3 + 1
    
    CurrentMusic = audio.playMusic("level" + musicNumber, 0.17, true)
    CurrentMusic.play()
  end
  
//// PlayCampaignWonMusic - play background music for 'campaign won intermission screen'
  PlayCampaignWonMusic = function()
    StopMusic()
    
    CurrentMusic = audio.playMusic("titlescreen", 0.3, true)
    CurrentMusic.play()
  end
  
//// PlayCampaignLostMusic - play background music for 'campaign lost intermission screen'
  PlayCampaignLostMusic = function()
    StopMusic()
    
    CurrentMusic = audio.playMusic("ending", 0.3, true)
    CurrentMusic.play()
  end
  
//// PlayNewGameEffect - plays sound effect for selecting new game in main menu
  PlayNewGameEffect = function()
    audio.playSound("quaddamage_shoot", 0.6, 1, 0, false)
  end
  
//// EnemySpawned - play sound effect of spawned enemy
  EnemySpawned = function()
    audio.playSound("jumppad", 0.5, 1, 0, false)
  end
  
//// EnemyDied - play sound effect of enemy dying
  EnemyDied = function()
    audio.playSound("explosion", 0.8, 1, 0, false)
  end
  
//// MapDestroyed - play sound effect of map destroyed
  MapDestroyed = function()
    audio.playSound("grenade2", 0.7, 1, 0, false)
  end
  
//// ProjectileFired - play sound effect of projectile fired
  // soundName:string - name of the sound to play
  ProjectileFired = function(soundName)
    audio.playSound(soundName, 0.4, 1, 0, false)
  end
  
//// ProjectileExploded - play sound effect of projectile exploding
  ProjectileExploded = function()
    audio.playSound("grenade3", 0.5, 1, 0, false)
  end
  
//// Upgrade - play sound effect of player upgrading their tank
  Upgrade = function()
    audio.playSound("pickup_01", 0.45, 1, 0, false)
  end
  
//// WinJingle - play sound jingle to celebrate player's victory
  WinJingle = function()
    audio.playSound("jingle_win_00", 0.45, 1, 0, false)
  end
  
//// LoseJingle - play sound jingle to mourn player's defeat
  LoseJingle = function()
    audio.playSound("jingle_lose_00", 0.45, 1, 0, false)
  end
  
//// StopMusic - stops currently playing music
  StopMusic = function()
    if CurrentMusic != 0 then
      CurrentMusic.stop()
      CurrentMusic = 0
    end
  end
end