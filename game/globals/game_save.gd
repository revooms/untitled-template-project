extends Node

# This script shows how to save data using Godot's custom ConfigFile format.
# ConfigFile can store any Variant type except Signal or Callable.
# It can even store Objects, but be extra careful where you deserialize them
# from, because they can include (potentially malicious) scripts.

const save_file_path = "user://game_save_data.ini"

var player_data

var max_backups := 5  # Anzahl der maximalen Sicherungen, kann angepasst werden

func _ready():
	player_data = Game.get_player()
	# Beim Start: Daten laden oder Standarddaten verwenden
	if load_game():
		Logger.out(self, "Daten geladen: %s"% player_data)
	else:
		Logger.out(self, "Keine gespeicherten Daten gefunden, Standarddaten werden genutzt.")

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
		get_tree().quit()
	elif what == NOTIFICATION_WM_GO_BACK_REQUEST:
		save_game()

func save_game() -> ConfigFile:
	Logger.out(self, "Saving game data")
	var config := ConfigFile.new()

	var game_variables = Game.get_persistant_object()
	for game_var in game_variables:
		config.set_value("game", game_var, game_variables[game_var])

	var player_variables = Game.get_player().get_persistant_object()
	for player_var in player_variables:
		config.set_value("player", player_var, player_variables[player_var])

	config.save(save_file_path)
	
	return config

func load_game() -> bool:
	var config
	if not FileAccess.file_exists(save_file_path):
		Logger.out(self, "Save file not found, creating ...")
		config = save_game()
	else:
		Logger.out(self, "Loading save data")
		config = ConfigFile.new()
		config.load(save_file_path)
	
	var game_variables = Game.get_persistant_object()
	Logger.out(self, "Loading game variables")
	for game_var in game_variables:
		#Logger.out(self, "Setting game's %s to %s (was %s)" % [game_var, config.get_value("game", game_var), Game[game_var]])
		Game[game_var] = config.get_value("game", game_var)
		

	var player = Game.get_player()
	var player_variables = player.get_persistant_object()
	Logger.out(self, "Loading player variables")
	for player_var in player_variables:
		#Logger.out(self, "Setting player's %s to %s (was %s)" % [player_var, config.get_value("player", player_var), player[player_var]])
		player[player_var] = config.get_value("player", player_var)

	return true

func backup_save_file():
	if not FileAccess.file_exists(save_file_path):
		return  # Keine Datei, nichts zu sichern

	# Backup-Dateiname mit Datum/Uhrzeit
	var date_str = Time.get_datetime_string_from_system(true).replace(":", "-").replace(" ", "_")
	var backup_name = "user://player_data_%s.bak" % date_str

	# Ursprüngliche Datei als Backup mit Zeitstempel speichern
	DirAccess.rename_absolute(save_file_path, backup_name)

	# Alte Backups aufräumen
	var dir = DirAccess.open("user://")
	if dir:
		var backups = []
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.begins_with("player_data_") and file_name.ends_with(".bak"):
				backups.append(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()

		# Nach Namen sortieren (älteste zuerst, weil Datumsnamen aufsteigend sortiert werden)
		backups.sort()

		# Wenn zu viele Backups vorhanden sind: älteste löschen
		while backups.size() > max_backups:
			var oldest = backups.pop_front()
			DirAccess.remove_absolute("user://" + oldest)
