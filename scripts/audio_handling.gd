extends Node
@onready var audio_player = $Microphone
var recording_effect: AudioEffectRecord
var bus_index: int

func _ready():
	bus_index = AudioServer.get_bus_index("voice_record")
	recording_effect = AudioServer.get_bus_effect(bus_index, 0)
	
	# Setting the format
	recording_effect.format = AudioStreamWAV.FORMAT_16_BITS
	
	# Start playing microphone
	audio_player.play()
	
	print("Microphone setup complete")

func start_recording(): 
	recording_effect.set_recording_active(true)
	print("Recording started...")

func stop_recording_and_transcribe():
	# Stop recording
	recording_effect.set_recording_active(false)
	
	# Get the recording immediately (no need to wait)
	var recording = recording_effect.get_recording()
	
	if recording != null:
		print("Got recording! Duration: ", recording.get_length(), " seconds")
		$WhisperAPI.transcribe_audio(recording)
	else:
		print("No recording found!")
