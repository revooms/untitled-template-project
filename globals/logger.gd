extends Node

func _ready() -> void:
	self.out(self, "Logger ready")

func log(identifier, type: Enums.LogType, message: String) -> void:
	print(create_message(identifier, type, message))

func out(identifier, message: String) -> void:
	print(create_message(identifier, Enums.LogType.LINE, message))

func info(identifier, message: String) -> void:
	print(create_message(identifier, Enums.LogType.INFO, message))

func warning(identifier, message: String) -> void:
	print(create_message(identifier, Enums.LogType.WARNING, message))

func danger(identifier, message: String) -> void:
	print(create_message(identifier, Enums.LogType.DANGER, message))
	
func create_message(identifer, type, message) -> String:
	var logtype_text = ""
	if type > 0:
		logtype_text = "%s:" % Enums.LogType.keys()[type]
		
	return "%s: %s:%s %s" % [
		Time.get_date_string_from_system(), 
		identifer.name, 
		logtype_text, 
		message
	]
