extends HBoxContainer
class_name MissionRow

var mission: Mission

signal mission_selected(mission: Mission)
signal mission_deleted(mission: Mission)

func parse_mission(mission: Mission) -> void:
	self.mission = mission
	%Name.text = mission.name
	%Distance.text = "%d" % (mission.distance)
	%Elevation.text = "%d" % (mission.elevation)

func _on_select_button_pressed() -> void:
	self.mission_selected.emit(self.mission)


func _on_delete_button_pressed() -> void:
	self.mission_deleted.emit(self.mission)
