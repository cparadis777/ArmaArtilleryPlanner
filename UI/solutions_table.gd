extends VBoxContainer

const SolutionRowScene: PackedScene = preload("res://UI/SolutionRow.tscn")


var current_solutions: Array

func clear() -> void:
	for child in self.get_children():
		child.queue_free()

func load_solutions(solutions: Array) -> void:
	self.clear()
	self.current_solutions = solutions
	for solution in self.current_solutions:
		var new_row = SolutionRowScene.instantiate()
		new_row.parse_solution(solution)
		self.add_child(new_row)
