extends HBoxContainer

class_name MissionBank


var missions: Dictionary


signal mission_selected(mission: Mission)

func _ready() -> void:
	%MissionsTable.mission_selected.connect(self._on_mission_selected)
	%MissionsTable.mission_deleted.connect(self._on_mission_deleted)

func add_mission(mission: Mission) -> void:
	if mission.name in missions:
		missions[mission.name].queue_free()
		missions.erase(mission.name)

	missions[mission.name] = %MissionsTable.add_mission(mission)

func _on_mission_selected(mission: Mission) -> void:
	self.mission_selected.emit(mission)
	%SolutionsTable.load_solutions(mission.solutions)

func _on_mission_deleted(mission: Mission) -> void:
	self.missions[mission.name].queue_free()
	self.missions.erase(mission.name)
