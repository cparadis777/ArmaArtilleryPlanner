extends Popup


signal create_mission(name: String)

func close() -> void:
	self.queue_free()

func save() -> void:
	self.create_mission.emit(%Name.text)
	self.hide()
	self.queue_free()
