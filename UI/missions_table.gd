extends VBoxContainer
class_name MissionsTable

const MissionRowScene: PackedScene = preload("res://UI/MissionRow.tscn")

func clear() -> void:
	for child in self.get_children():
		child.queue_free()

func add_mission(mission: Mission) -> void:
	var new_row = MissionRowScene.instantiate()
	new_row.parse_mission(mission)
	self.add_child(new_row)
