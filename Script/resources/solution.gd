extends Resource
class_name firing_solution

var charge:int
var elevation:float
var tof:float
var type:String
var azimuth_correction:float
var error:float

func display() -> void:
    print("Charge: %s, Elevation: %.2f, ToF: %.2f, Type: %s, Azimuth Correction: %.2f, Error: %.2f" % [charge, elevation, tof, type, azimuth_correction, error])