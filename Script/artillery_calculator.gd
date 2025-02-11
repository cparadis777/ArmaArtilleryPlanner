extends Node

var GRAVITY:float = 9.8066
var TIMESTEP:float = 0.05
var EPSILON:int = 10
var MAX_ITERATIONS:int = 1500
var ANGLE_STEP:float = 0.001

func calculate_projectile_motion(initial_velocity: float, initial_angle: float) -> Dictionary:
	var angle_radians = deg_to_rad(initial_angle)
	var time_of_flight = (2 * initial_velocity * sin(angle_radians)) / GRAVITY
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

func nMil_to_rad(nMil:float) -> float:
	return nMil * 0.000982

func rad_to_nMil(rad:float) -> float:
	return rad * 1018.591636

func deg_to_nMil(deg:float) -> float:
	return rad_to_nMil(deg_to_rad(deg))

func nMil_to_deg(nMil:float) -> float:
	return rad_to_deg(nMil_to_rad(nMil))

# func solve_firing_solutions(distance: float, muzzle_velocity: float, elevation_difference: float) -> Array:
# 	var solutions = []
# 	var g = GRAVITY
# 	var v = muzzle_velocity
# 	var d = distance
# 	var h = elevation_difference

# 	var discriminant = pow(v, 4) - g * (g * pow(d, 2) + 2 * h * pow(v, 2))
# 	if discriminant < 0:
# 		return [firing_solution.new()]  # No solution

# 	var angle1 = atan((pow(v, 2) + sqrt(discriminant)) / (g * d))
# 	var angle2 = atan((pow(v, 2) - sqrt(discriminant)) / (g * d))

# 	for angle in [angle1, angle2]:
# 		var result = calculate_projectile_motion(v, rad_to_deg(angle))
# 		var new_solution = firing_solution.new()
# 		new_solution.elevation = rad_to_deg(angle)
# 		new_solution.tof = result.time_of_flight
# 		new_solution.type = "High" if rad_to_deg(angle) >= 45 else "Low"
# 		solutions.append(new_solution)


# 	return solutions

func solve_firing_solutions(distance:int, elevation_difference:int, piece:ArtilleryPiece, ammo:ArtilleryShell, charge:int) -> Array:
	var current_angle:float = deg_to_rad(piece.minAngle)
	var n_iter = 0
	var solutions = []
	var max_angle = deg_to_rad(piece.maxAngle)

	while n_iter < MAX_ITERATIONS and current_angle < max_angle:
		var result = simulate_shot(ammo.base_velocity * piece.charges[charge], 
			current_angle, 
			elevation_difference, 
			ammo.air_friction)
		
		var error = abs(result[0] - distance)
		#if n_iter % 10 == 0:
		#	print("Iteration: %s, Charge: %s, Angle: %.2f, Distance: %.2f,  ToF: %.2f,  Error: %.2f" % [n_iter, charge, rad_to_nMil(current_angle), result[0], result[1], error])
		
		if  abs(result[0] - distance) < EPSILON:
			var new_solution = firing_solution.new()
			new_solution.elevation = rad_to_nMil(current_angle)
			new_solution.tof = result[1]
			new_solution.type = "High" if rad_to_deg(current_angle) >= 45 else "Low"
			new_solution.error = error
			new_solution.charge = charge
			solutions.append(new_solution)
		current_angle += ANGLE_STEP
		n_iter += 1
	
	var solution_families = { "High":[], "Low":[] }
	for solution in solutions:
		solution_families[solution.type].append(solution)

	var selected_solutions = []
	if solution_families['High'].size() != 0:
		selected_solutions.append(select_solution(solution_families['High']))
	if solution_families['Low'].size() != 0:
		selected_solutions.append(select_solution(solution_families['Low']))
	return selected_solutions


func select_solution(solutions:Array) -> firing_solution:
	var best_solution = solutions[0]
	for solution in solutions:
		if solution.error < best_solution.error:
			best_solution = solution
	return best_solution

func caculate_lr_shift(distance:int, adjustment:int) -> Array:

	#  r = radius
	#  dtetha = azimuth change
	#  dT = change along the tangent
	#  dr = change in range 
	#  
	#
	#  dtetha = arctan ( dt / r)
	#  dr = dt/sin(dtetha)
	#
	#  with dtetha and (r+dr), we can calculate the new solution

	if adjustment == 0:
		return [distance, 0]

	distance = float(distance)
	adjustment = float(adjustment)


	var azimuth_change = atan2(adjustment, distance)
	
	var distance_adjustment = (adjustment / sin(azimuth_change))
	var new_distance = distance_adjustment + distance
	return [int(new_distance), deg2mil(rad_to_deg(azimuth_change))]


func simulate_shot(initial_velocity:float, initial_angle:float, target_elevation:float, air_friction:float) -> Array:
	
	var velocity = Vector2(initial_velocity * cos(initial_angle), initial_velocity * sin(initial_angle))
	var position = Vector2(0,0)
	var time = 0 

	var apex = 0

	while position.y >= target_elevation or velocity.y > 0:
		position += velocity * TIMESTEP
		var deltaV:Vector2 = Vector2(0,0)
		deltaV.y = -GRAVITY
		deltaV += (velocity.length() * air_friction) * velocity
		velocity += deltaV * TIMESTEP
		time += TIMESTEP

		if position.y > apex:
			apex = position.y
		
	if apex < target_elevation:
		return [0, 0]
	
	return [position.x, time]
