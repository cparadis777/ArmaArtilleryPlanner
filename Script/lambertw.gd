class_name lambertW

func lambertW(x: float) -> float:
	if not check_validity(x):
		push_error("Invalid input for Lambert W function")
		return 0.0
	
	var w = 0.0
	if x >= 0.0:
		w = x
	else:
		w = -1.0

	for i in range(100):
		var e = exp(w)
		var we = w * e
		var we_plus_x = we + x
		var w_next = w - (we_plus_x / (e * (w + 1.0) - ((w + 2.0) * we_plus_x / (2.0 * w + 2.0))))
		if abs(w_next - w) < 1e-10:
			break
		w = w_next

	return w



func check_validity(x:float) -> bool:
	if x < -1 / exp(1):
		return false
	return true