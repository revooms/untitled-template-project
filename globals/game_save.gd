extends Node


var thePlayer
var player_data

var save_file_path = "user://player_data.save"
var save_keys = ["distance_travelled", "distance_travelled_on_floor", "distance_travelled_in_air", "times_jumped"]

func _ready():
	thePlayer = get_tree().get_nodes_in_group("Players")[0]
	player_data = thePlayer
	# Beim Start: Daten laden oder Standarddaten verwenden
	if load_player_data():
		print("Daten geladen:", player_data)
	else:
		print("Keine gespeicherten Daten gefunden, Standarddaten werden genutzt.")

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_player_data()
		get_tree().quit()
	elif what == NOTIFICATION_WM_GO_BACK_REQUEST:
		save_player_data()


func _load_value(file: FileAccess, expected_type):
	if file.get_position() >= file.get_length():
		push_error("Laden: Unerwartetes Dateiende.")
		return null

	var type_id = file.get_8()
	if type_id != expected_type and expected_type != 0:
		push_error("Laden: Erwarteter Typ %d, aber gefunden %d" % [expected_type, type_id])
		return null

	match type_id:
		TYPE_STRING:
			if file.get_position() >= file.get_length():
				push_error("Laden: Unerwartetes Dateiende bei String.")
				return null
			return file.get_line()
		TYPE_INT:
			if file.get_position() + 4 > file.get_length():
				push_error("Laden: Unerwartetes Dateiende bei Int.")
				return null
			return file.get_32()
		TYPE_FLOAT:
			if file.get_position() + 4 > file.get_length():
				push_error("Laden: Unerwartetes Dateiende bei Float.")
				return null
			return file.get_float()
		TYPE_BOOL:
			if file.get_position() + 1 > file.get_length():
				push_error("Laden: Unerwartetes Dateiende bei Bool.")
				return null
			return file.get_8() != 0
		TYPE_ARRAY:
			if file.get_position() + 4 > file.get_length():
				push_error("Laden: Unerwartetes Dateiende bei Array-Größe.")
				return null
			var size = file.get_32()
			var arr = []
			for i in range(size):
				var val = _load_value(file, 0)
				if val == null:
					return null
				arr.append(val)
			return arr
		TYPE_DICTIONARY:
			if file.get_position() + 4 > file.get_length():
				push_error("Laden: Unerwartetes Dateiende bei Dictionary-Größe.")
				return null
			var size = file.get_32()
			var dict = {}
			for i in range(size):
				var k = _load_value(file, 0)
				var v = _load_value(file, 0)
				if k == null or v == null:
					return null
				dict[k] = v
			return dict
		_:
			push_error("Laden: Typ nicht unterstützt: %d" % type_id)
			return null

func _save_value(file: FileAccess, value) -> int:
	# Rückgabewert: OK oder Fehlercode
	match typeof(value):
		TYPE_STRING:
			file.store_8(TYPE_STRING)
			file.store_line(value)
			return OK
		TYPE_INT:
			file.store_8(TYPE_INT)
			file.store_32(value)
			return OK
		TYPE_FLOAT:
			file.store_8(TYPE_FLOAT)
			file.store_float(value)
			return OK
		TYPE_BOOL:
			file.store_8(TYPE_BOOL)
			file.store_8(value)
			return OK
		TYPE_ARRAY:
			file.store_8(TYPE_ARRAY)
			file.store_32(value.size())
			for item in value:
				var err = _save_value(file, item)
				if err != OK:
					return err
			return OK
		TYPE_DICTIONARY:
			file.store_8(TYPE_DICTIONARY)
			file.store_32(value.size())
			for key in value.keys():
				var err = _save_value(file, key)
				if err != OK:
					return err
				err = _save_value(file, value[key])
				if err != OK:
					return err
			return OK
		_:
			push_error("Speichern: Typ nicht unterstützt: %s" % typeof(value))
			return ERR_INVALID_PARAMETER

func load_player_data() -> bool:
	if not FileAccess.file_exists(save_file_path):
		print("Laden: Keine Datei gefunden.")
		return false

	var file = FileAccess.open(save_file_path, FileAccess.READ)
	if not file:
		push_error("Laden: Datei konnte nicht geöffnet werden.")
		return false

	for key in save_keys:
		var current_value = get(key)
		var loaded_value = _load_value(file, typeof(current_value))
		if loaded_value == null:
			push_error("Laden: Fehler beim Laden von '%s'" % key)
			file.close()
			return false
		set(key, loaded_value)
		thePlayer[key] = loaded_value

	file.close()
	print("Spielerdaten geladen.")
	return true

func save_player_data():
	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	if not file:
		push_error("Speichern: Datei konnte nicht geöffnet werden.")
		return
	for key in save_keys:
		#var value = get(key)
		var value = thePlayer[key]
		var err = _save_value(file, value)
		if err != OK:
			push_error("Speichern: Fehler beim Speichern von '%s'" % key)
	file.close()
	print("Spielerdaten gespeichert.")


func debug_print_saved_data():
	if not FileAccess.file_exists(save_file_path):
		print("Keine Speicherdatei gefunden.")
		return

	var file = FileAccess.open(save_file_path, FileAccess.READ)
	if not file:
		print("Speicherdatei konnte nicht geöffnet werden.")
		return

	print("Inhalt der Speicherdatei:")
	for key in save_keys:
		# Dummy-Wert als erwarteter Typ (kann beliebig sein, nur zum Typabgleich)
		var dummy_value = get(key) if has_method("get") else null
		#var expected_type = dummy_value != null ? typeof(dummy_value) : 0
		var expected_type = typeof(dummy_value) if dummy_value != null else 0

		var loaded_value = _load_value(file, expected_type)
		if loaded_value == null:
			print("Fehler beim Laden von ", key)
			break
		print(key, ":", loaded_value)

	file.close()
