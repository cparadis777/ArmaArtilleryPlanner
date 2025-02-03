extends VBoxContainer

const SolutionRowScene:PackedScene = preload("res://UI/SolutionRow.tscn")

func clear() -> void:
	for child in self.get_children():
		child.queue_free()

func load_solutions(solutions:Array) -> void:
	self.clear()
	for solution in solutions:
		var new_row = SolutionRowScene.instantiate()
		new_row.parse_solution(solution)
		self.add_child(new_row)