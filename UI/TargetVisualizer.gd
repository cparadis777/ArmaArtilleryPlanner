extends MarginContainer

var current_viz_radius:float = 50.0
var current_scaling_factor:float = 1.0
var possible_radii = [50, 100, 150, 200]

var real_radius:int

var current_ot_adjustment:int = 0
var current_lr_adjustment:int = 0


func _ready() -> void:
	self.real_radius = %screen.radius


func calculate_scaling_factor(pos:Vector2) -> void:
	self.select_radius(pos)
	self.current_scaling_factor = self.real_radius / self.current_viz_radius 
	
func update_marker(pos:Vector2) -> void:
	self.calculate_scaling_factor(pos)
	%Reticle.position=real_to_viz(pos)

func real_to_viz(pos:Vector2) -> Vector2:
	return Vector2(pos.x * self.current_scaling_factor, pos.y * self.current_scaling_factor)

func select_radius(pos:Vector2) -> void:
	# We want the smallest radius that will fit the point
	var current_smallest_radius = 0
	var length = pos.length()
	for radius in self.possible_radii:
		if length <= radius:
			current_smallest_radius = radius
			break
	self.current_viz_radius = current_smallest_radius


func _on_adj_text_changed(_text:String) -> void:
	if %LRAdj.text.is_valid_int() and %OTAdj.text.is_valid_int():
		self.current_lr_adjustment = int(%LRAdj.text)
		self.current_ot_adjustment = int(%OTAdj.text)
		self.update_marker(Vector2(self.current_lr_adjustment, -self.current_ot_adjustment))
