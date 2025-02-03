extends Node

var gravity:float = 9.81


func calculate_projectile_motion(initial_velocity: float, initial_angle: float) -> Dictionary:
	var angle_radians = deg_to_rad(initial_angle)
	var time_of_flight = (2 * initial_velocity * sin(angle_radians)) / gravity
	var horizontal_distance = (initial_velocity * cos(angle_radians)) * time_of_flight
	return {
		"horizontal_distance": horizontal_distance,
		"time_of_flight": time_of_flight
	}


func get_distance(pos1:Vector3, pos2:Vector3) -> float:
	return pos1.distance_to(pos2)

func get_angle(pos1:Vector3, pos2:Vector3) -> float:
	return pos1.angle_to(pos2)

func deg2mil(deg:float) -> float:
	return 0.06*deg

func mil2deg(mil:float) -> float:
	return mil/0.06

func solve_firing_solutions(distance: float, muzzle_velocity: float, elevation_difference: float) -> Array:
	var solutions = []
	var g = gravity
	var v = muzzle_velocity
	var d = distance
	var h = elevation_difference

	var discriminant = pow(v, 4) - g * (g * pow(d, 2) + 2 * h * pow(v, 2))
	if discriminant < 0:
		return [firing_solution.new()]  # No solution

	var angle1 = atan((pow(v, 2) + sqrt(discriminant)) / (g * d))
	var angle2 = atan((pow(v, 2) - sqrt(discriminant)) / (g * d))

	for angle in [angle1, angle2]:
		var result = calculate_projectile_motion(v, rad_to_deg(angle))
		var new_solution = firing_solution.new()
		new_solution.elevation = rad_to_deg(angle)
		new_solution.tof = result.time_of_flight
		new_solution.type = "High" if rad_to_deg(angle) >= 45 else "Low"
		solutions.append(new_solution)


	return solutions


#167.7
#195.2
#226.6
#262.0
#307.9
#353.7
#415.3
