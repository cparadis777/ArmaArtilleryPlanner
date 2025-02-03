@tool
extends Polygon2D

@export var radius: float = 50.0 : set = set_radius
@export var n: int = 100 : set = set_n



func _ready() -> void:
	update_points()


func set_radius(value: float) -> void:
	radius = value
	update_points()

func set_n(value: int) -> void:
	n = value
	update_points()

func update_points() -> void:
	var points = PackedVector2Array()
	for i in range(self.n):
		var angle = i * 2 * PI / self.n
		var x = self.radius * cos(angle)
		var y = self.radius * sin(angle)
		points.append(Vector2(x, y))
	self.polygon = points