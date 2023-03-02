// used by AI to store information for pathfinding. Each Node have it's own location and location of next node on the way to the target

VectorFieldNode = class
//// constructor
  // @positionX - position of this node on x axis
  // @positionY - position of this node on y axis
  // @comeFromX - position of next node on the path on x axis
  // @comeFromY - position of next node on the path on y axis
  constructor = function(positionX, positionY, comeFromX, comeFromY)
    this.PositionX = positionX
    this.PositionY = positionY
    this.ComeFromX = comeFromX
    this.ComeFromY = comeFromY
  end
end