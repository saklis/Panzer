// bunch of random utility functions

// Clamp - returns value. If value exceeds min or max limits, it returns the limit instead
// @value:number - number to be clamped
// @minVal:number - minimum limit for value
// @maxVal:number - maximum limit for value
// @returns:number - clamped value
Clamp = function(value, minVal, maxVal)
  return min(max(value, minVal), maxVal)
end