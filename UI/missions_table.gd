extends VBoxContainer
class_name MissionsTable

const MissionRowScene: PackedScene = preload("res://UI/MissionRow.tscn")


signal mission_selected(mission: Mission)
signal mission_deleted(mission: Mission)

func clear() -> void:
	for child in self.get_children():
		child.queue_free()

func add_mission(mission: Mission) -> MissionRow:
	var new_row = MissionRowScene.instantiate()

	new_row.parse_mission(mission)
	self.add_child(new_row)
	new_row.mission_selected.connect(self._on_mission_selected)
	new_row.mission_deleted.connect(self._on_mission_deleted)
	return new_row


func _on_mission_selected(mission: Mission) -> void:
	self.mission_selected.emit(mission)

func _on_mission_deleted(mission: Mission) -> void:
	self.mission_deleted.emit(mission)
