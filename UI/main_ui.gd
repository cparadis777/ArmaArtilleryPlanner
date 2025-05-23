extends Control


@export var SavePopUp: PackedScene

@export var pieces: Array[ArtilleryPiece]


var active_piece: ArtilleryPiece: set = set_active_piece
var active_shell: ArtilleryShell


func _ready() -> void:
	%PieceSelect.clear()
	for piece in self.pieces:
		%PieceSelect.add_item(piece.name)
		
	%PieceSelect.select(0)
	self.active_piece = self.pieces[0]

	Arty.simulate_shot(
		self.active_shell.base_velocity * self.active_piece.charges[3],
			PI / 4,
			int(%Elevation.text),
			self.active_shell.air_friction
	)


func set_active_piece(piece: ArtilleryPiece) -> void:
	active_piece = piece
	%AmmoSelect.clear()
	for shell in piece.shells:
		%AmmoSelect.add_item(shell.name)
	%AmmoSelect.select(0)
	self.active_shell = piece.shells[0]


func _on_piece_select_item_selected(index: int) -> void:
	self.active_piece = self.pieces[index]

func _on_ammo_select_item_selected(index: int) -> void:
	self.active_shell = self.active_piece.shells[index]

func _on_calculate_pressed() -> void:
	if %Distance.text.is_valid_int() and %Elevation.text.is_valid_int():
		self.get_solutions()


func get_solutions() -> void:
	var solutions = []
	var distance = int(%Distance.text) + %Target.current_ot_adjustment #
	var elevation = int(%Elevation.text) - int(%BATTELEV.text)

	var result = Arty.caculate_lr_shift(distance, %Target.current_lr_adjustment)
	distance = result[0]
	var azimuth = result[1]


	var new_solutions = Arty.solve_firing_solutions(
		distance,
		elevation,
		self.active_piece,
		self.active_shell
	)

	for solution in new_solutions:
		solution.azimuth_correction = azimuth
		solutions.append(solution)

	%SolutionsTable.load_solutions(solutions)


func save_mission() -> void:
	var popup = self.SavePopUp.instantiate()
	self._on_calculate_pressed()
	self.add_child(popup)
	popup.create_mission.connect(self.create_mission)
	popup.popup()


func create_mission(name: String) -> void:
	var mission = Mission.new()
	mission.name = name
	mission.distance = int(%Distance.text)
	mission.elevation = int(%Elevation.text)
	mission.solutions = %SolutionsTable.current_solutions
	mission.ot_adjustment = %Target.current_ot_adjustment
	mission.lr_adjustment = %Target.current_lr_adjustment

	%MissionBank.add_mission(mission)

func load_mission(mission: Mission) -> void:
	%Distance.text = "%d" % (mission.distance)
	%Elevation.text = "%d" % (mission.elevation)
	%SolutionsTable.load_solutions(mission.solutions)
	%Target.current_ot_adjustment = mission.ot_adjustment
	%Target.current_lr_adjustment = mission.lr_adjustment


func _on_mission_bank_mission_selected(mission: Mission) -> void:
	self.load_mission(mission)
