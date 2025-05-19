extends Popup


signal create_mission(name: String)

func close() -> void:
	self.queue_free()

func _process(_delta: float) -> void:
	if not %Name.text.is_empty() and Input.is_action_just_pressed("ui_accept"):
		self.save()


func save() -> void:
	self.create_mission.emit(%Name.text)
	self.hide()
	self.queue_free()
