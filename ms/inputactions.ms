// structure that holds a state of actions based on raw input from a device on last update

InputActions = class
  constructor = function()
    // actions
    this.Up = false
    this.Left = false
    this.Down = false
    this.Right = false
    this.Fire = false
    this.Menu = false
    this.UpBegin = false
    this.LeftBegin = false
    this.DownBegin = false
    this.RightBegin = false
    this.FireBegin = false
    this.MenuBegin = false
  end
  
//// Reset - reset all actions to false
  Reset = function()
    this.Up = false
    this.Left = false
    this.Down = false
    this.Right = false
    this.Fire = false
    this.Menu = false
    this.UpBegin = false
    this.LeftBegin = false
    this.DownBegin = false
    this.RightBegin = false
    this.FireBegin = false
    this.MenuBegin = false
  end
end