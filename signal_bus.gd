extends Node

var listeners := {}


func listen(signal_name: String, callable: Callable) -> void:
	var functions: Array = listeners.get(signal_name, [])
	functions.append(callable)
	listeners[signal_name] = functions



func disconnect_listener(signal_name: String, function_to_remove: Callable) -> void:
	var callables: Array = listeners.get(signal_name, [])
	var starting_length := callables.size()
	callables.erase(function_to_remove)
	var ending_length := callables.size()

	if starting_length == ending_length:
		push_error("Tried to remove `" + str(function_to_remove) + \
				"` from signal `" + signal_name + "` but didn't find it.")
		return


func send_signal(signal_name: StringName, args := []):
	for listener: Callable in listeners.get(signal_name, []):
		listener.callv(args)
