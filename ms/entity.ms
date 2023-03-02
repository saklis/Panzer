// represents entity in game world

Entity = class
  // Next number for Entity unique identifiers
  NextEntityId = 0
  
//// constructor
  // @entityName:string - Name of this Entity.
  constructor = function(entityName = "entity")
    // increase the class static property to count number of entities
    Entity.NextEntityId += 1 // increase instance count
    
    // Entity's unique identifier
    this.Id = Entity.NextEntityId
    
    // game reference to access other entities in game world
    Game = 0
  
    // components of this entities
    Components = []
    
    Name = entityName + "_" + Id
    
    // A flag marking state of the Entity in the  game world. Set to 'true' during spawning
    Initialized = false
    
    // reference to TransformComponent. It's set in Init(). Must be set manually for Entities that don't have Transform Component while Init() is called.
    Transform = 0
    
    // A flag informing that this entity was marked for deletion. Will be removed from game world by next global update
    Delete = false
  end
  
//// AddComponent - add new component to entity
  // @component:Component - instance of a class that extends from Component
  AddComponent = function(component)
    Components.push(component)
    component.Owner = this
    
    // initialize component if entity is initialized
    // used in case of adding components to Entity that is already spwaned into the game world
    if Initialized then component.Init() end
  end
  
//// GetComponent - get component of particular class
  // @componentClass:Class - class to look for
  // @returns:Component - Instance of Component class that is attached to this Entity. Returns 0 if no component of given class was found
  GetComponent = function(componentClass)
    for component in Components
      if component.class == componentClass then
        return component
      end
    end
    return 0
  end

//// Init - initializes Entity. Called by Spawn() method in Game class
  Init = function()
    // find Transform Component reference
    Transform = GetComponent(TransformComponent)
    
    // initialize all components that are already added
    for component in Components
      component.Init()
    end
    
    Initialized = true
  end
  
//// Update - update all attached component
  // @deltaTime:number - amount of time that passed since last update
  Update = function(deltaTime)
    for component in Components
      component.Update(deltaTime)
    end
  end
  
//// Draw - draw all component
  // @layer:int - currently drawn layer
  Draw = function(layer)
    for component in Components
      component.Draw(layer)
    end
  end
  
//// Destroy - destroy all components
  Destroy = function()
    for component in Components
      component.Destroy()
    end
  end
end