// base class for components
// represents component that can be added to entity

Component = class
  
//// constructor
  constructor = function()
    // reference to entity that "owns" this component
    Owner = 0
  end
  
//// Init - Initialize component's members
  Init = function()
  end
  
//// Update - Update component
  // @deltaTime:number - amount of time that passed since last update
  Update = function(deltaTime)
  end
  
//// Draw - Draw component on particular layer
  // @layer:int - currently drawn layer
  Draw = function(layer)
  end
  
//// Destroy - Destroy component and cleanup
  Destroy = function()
  end
end