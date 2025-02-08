extends HBoxContainer
class_name SolutionRow


func parse_solution(solution:firing_solution) -> void:
	%Type.text = solution.type
	%Charge.text = "%d" % (solution.charge)
	%Elevation.text = "%.2f" % (solution.elevation)
	%ToF.text = "%.2f" % (solution.tof)
	%dAz.text = "%.2f" % (solution.azimuth_correction)