// represents a 2D vector along with handful of functions to manipulate them

Vector2D = class
//// constructor
  // @x:number - x axis coord of the vector
  // @y:number - y axis coord of the vecotr
  constructor = function(x = 0, y = 0)
    this.X = x
    this.Y = y
  end
  
//// GetLength -  returns vector's magnitude
  // @returns:number - magnitude (length) of the vector
  GetLength = function()
    return sqrt(X*X + Y*Y)
  end
  
//// GetNormalized - returns normalized form of the vector with length of 1
  // @returns:number - normalized form of vector. If length is equal 0 then returns vector (0,0)
  GetNormalized = function()
    local length = GetLength()
    if length == 0 then
      return new Vector2D(X, Y)
    else
      return new Vector2D(X / length, Y / length)
    end
  end
  
//// Reverse - reverses vector, changing its direction to oposite
  Reverse = function()
    X = -X
    Y = -Y
  end
  
//// ToRadian - returns angle from the x axis in radians
  // @returns:number - angle in radians between x axis and vector
  ToRadian = function()
    return atan2(Y,X)
  end
  
//// ToAngle - returns angle from x axis in degrees
  // @returns:number - angle in degrees between x axis and vector
  ToAngle = function()
    return atan2(Y,X) * (180 / PI)
  end
  
//// RotateByAngle - rotates vector by an angle in degrees
  // @angle:number - angle in degrees
  RotateByAngle = function(angle)
    local x2 = X * cosd(angle) - Y * sind(angle)
    local y2 = X * sind(angle) + Y * cosd(angle)
    X = x2
    Y = y2
  end

//// RotateByRadian - rotates vector by an angle in radians
  // @radian:number - angle in radians
  RotateByRadian = function(radian)
    local x2 = X * cos(radian) - Y * sin(radian)
    local y2 = X * sin(radian) + Y * cos(radian)
    X = x2
    Y = y2
  end
  
//// Add - returns new vector which is a result of adding two vectors
  // @otherVector:Vector2D - vector that will be added
  // @returns:Vector2D - result of adding two vectors
  Add = function(otherVector)
    return new Vector2D(this.X + otherVector.X, this.Y + otherVector.Y)
  end

//// Subtract - subtract other vector
  // @otherVector:Vector2D - vector that will be sunbtracted
  // @returns:Vector2D - result of subtraction
  Subtract = function(otherVector)
    return new Vector2D(this.X - otherVector.X, this.Y - otherVector.Y)
  end
  
//// Multiply - multiplies a vector by a scalar
  // @scalar:number - scalar to multiply vector by
  // @results:Vector2D - result of multiplication
  Multiply = function(scalar)
    return new Vector2D(this.X * scalar, this.Y * scalar)
  end
end