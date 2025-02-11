extends Control


@export var pieces:Array[ArtilleryPiece]


var active_piece:ArtilleryPiece : set = set_active_piece
var active_shell:ArtilleryShell

func _ready() -> void:
	%PieceSelect.clear()
	for piece in self.pieces:
		%PieceSelect.add_item(piece.name)
	%PieceSelect.select(0)
	self.active_piece = self.pieces[0]
	Arty.simulate_shot(
		self.active_shell.base_velocity * self.active_piece.charges[3], 
			PI/4, 
			int(%Elevation.text), 
			self.active_shell.air_friction
	)


func set_active_piece(piece:ArtilleryPiece) -> void:
	active_piece = piece
	%AmmoSelect.clear()
	for shell in piece.shells:
		%AmmoSelect.add_item(shell.name)
	%AmmoSelect.select(0)
	self.active_shell = piece.shells[0]


func _on_piece_select_item_selected(index:int) -> void:
	self.active_piece = self.pieces[index]

func _on_ammo_select_item_selected(index:int) -> void:
	self.active_shell = self.active_piece.shells[index]

func _on_calculate_pressed() -> void:
	if %Distance.text.is_valid_int() and %Elevation.text.is_valid_int():
		self.get_solutions()


func get_solutions() -> void:
	var solutions = []
	var distance = int(%Distance.text) + %Target.current_ot_adjustment #
	var elevation = int(%Elevation.text)

	var result = Arty.caculate_lr_shift(distance, %Target.current_lr_adjustment)
	distance = result[0]
	var azimuth = result[1]

	for charge in self.active_piece.charges:
		#var new_solutions = Arty.solve_firing_solutions(
		#	distance,
		#	self.active_shell.base_velocity * self.active_piece.charges[charge],
		#	elevation
		#)
		var new_solutions = Arty.solve_firing_solutions(
			distance,
			elevation,
			self.active_piece,
			self.active_shell,
			charge
		)

		for solution in new_solutions:
			solution.azimuth_correction = azimuth
			solutions.append(solution)

	solutions = solutions.filter(filter_solution)
	%SolutionsTable.load_solutions(solutions)

func filter_solution(solution:firing_solution) -> bool:

	var elevation = solution.elevation
	elevation = Arty.nMil_to_deg(elevation)

	if elevation > self.active_piece.maxAngle:
		return false
	if elevation < self.active_piece.minAngle:
		return false
	if solution.tof < 2:
		return false
	return true