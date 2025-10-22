extends Node

@onready var audio_player = $Microphone
var is_recording: bool = false
var recording_effect: AudioEffectRecord
var bus_index: int
var recording: AudioStreamWAV

func _ready():
	bus_index = AudioServer.get_bus_index("voice_record")
	recording_effect = AudioServer.get_bus_effect(bus_index, 3)
	
	# Setting the format
	recording_effect.format = AudioStreamWAV.FORMAT_16_BITS
	
	print("Microphone setup complete")


func start_recording():
	if not is_recording:
		print("Recording started...")
		is_recording = true
		recording_effect.set_recording_active(true)
	else:
		print("Stopping recording...")
		is_recording = false
		recording_effect.set_recording_active(false)
		recording = recording_effect.get_recording()
		if recording != null:
			print("Got recording! Duration: ", recording.get_length(), " seconds")
			$WhisperAPI.transcribe_audio(recording)
		else:
			print("No recording found!")
