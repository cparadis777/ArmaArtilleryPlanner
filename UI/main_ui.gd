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
		var new_solutions = Arty.solve_firing_solutions(
			distance,
			self.active_shell.base_velocity * self.active_piece.charges[charge],
			elevation
		)
		for solution in new_solutions:
			solution.charge = charge
			solution.azimuth_correction = azimuth
			solutions.append(solution)

	solutions = solutions.filter(filter_solution)
	%SolutionsTable.load_solutions(solutions)

func filter_solution(solution:firing_solution) -> bool:

	if solution.elevation > self.active_piece.maxAngle:
		return false
	if solution.elevation < self.active_piece.minAngle:
		return false
	if solution.tof < 10:
		return false
	return true