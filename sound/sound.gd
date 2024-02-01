extends Node

const SOUND_EFFECTS_PATH = "res://sound/"

# This will map filenames to the actual loaded sound resource.
var sounds = {}

# We have an array of players, so we can play multiple sounds at once.
var players:Array[AudioStreamPlayer] = []
# I think this is a good number, but it's backed up by no actual understanding
# of how expensive it is to play a sound.
var num_players := 50
# The players are chosed in a round-robin fashion; this keeps track of which
# one should be used next.
var index := 0

# We have a separate player for music.
var music_player = AudioStreamPlayer.new()
# And for the background ambient noise.
var ambient_player = AudioStreamPlayer.new()


func _ready():
	# Music is played in its own player on its own bus.
	add_child(music_player)
	music_player.bus = &"Music"
	# Same with the abmient sound.
	add_child(ambient_player)
	ambient_player.bus = &"Ambient"
	ambient_player.stream = load("res://sound/music/room_tone_ambient_16K.wav")

	# Everything else is played on a player from the `players` list, chosen
	# in a round-robin fashion.
	for i in range(num_players):
		var player = AudioStreamPlayer.new()
		add_child(player)
		players.append(player)


	load_sounds()



func play(sound_name: String):
	players[index].stream = sounds.get(sound_name)
	if players[index].stream == null:
		print("Error: can't find sound `", sound_name, "`")
	players[index].play()
	index = (index + 1) % num_players


func play_effect(sound_name: String) -> void:
	play("effects/" + sound_name)


func play_music(song_name: String):
	music_player.stream = sounds.get("music/" + song_name)
	music_player.play()


func cycle_music():
	# TODO: make less lame.
	music_player.stop()
	if music_player.stream == sounds.get("music/chill_music"):
		play_music("intense_music")
	else:
		play_music("chill_music")


func stop_music():
	music_player.stop()


func play_ambient():
	ambient_player.play()

func load_sounds():
	var files = get_files(SOUND_EFFECTS_PATH)
	for full_path in files:
		# We're assuming there won't be any files that share the same name
		# but have different prefixes.
		var simple_name = full_path.trim_suffix("." + full_path.get_extension())
		# Now we strip off the initial resource directory.
		simple_name = simple_name.trim_prefix(SOUND_EFFECTS_PATH)
		# Also handle an extra slash that might be present depending on how I
		# hardcoded the sound effects path.
		simple_name = simple_name.trim_prefix("/")

		# Check if there's a name conflict.
		if sounds.has(simple_name):
			push_error("Duplicate sound name. `" + simple_name + "` already assigned to: " + str(sounds[simple_name]))
			assert(false)

		sounds[simple_name] = load(full_path)



func get_files(dir_path:String) -> Array[String]:
	# Open the directory.
	var dir = DirAccess.open(dir_path)
	# Display errors and crash if that didn't work.
	if not dir:
		push_error("Error opening ", dir_path)
		push_error("    " + str(DirAccess.get_open_error()))
		assert(false) # So it crashes.
		return []
	# Opens the stream to read the files.
	dir.list_dir_begin()
	# We'll be storing all filenames in this flat array.
	var files:Array[String] = []
	# get_next() returns the name of the file or directory, or an empty string
	# if there's nothing left to read.
	var file_name = dir.get_next()
	while file_name != "":
		# If it's a directory, we recurse into that directory.
		if dir.current_is_dir():
			files.append_array(get_files(dir_path + "/" + file_name))
		else:
			# The filename is *just* the name, so we add on the directory
			# path, which we'll need to actually load the file later.
			var sound_file = dir_path + "/" + file_name
			# When exported, only the .import versions are available. However,
			# when we go to load them later, we need to provide the path without
			# the .import extension.
			if sound_file.ends_with(".import"):
				files.append(sound_file.trim_suffix(".import"))
		file_name = dir.get_next()
	return files



