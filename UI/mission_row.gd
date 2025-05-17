extends HBoxContainer
class_name MissionRow

func parse_mission(mission: Mission) -> void:
    %Name.text = mission.name
    %Distance.text = "%d" % (mission.distance)
    %Elevation.text = "%d" % (mission.elevation)