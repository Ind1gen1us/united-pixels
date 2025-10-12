extends Node

# setting this to the openai API key
var API_KEY: String
var http_request: HTTPRequest
var audio_recording: AudioStreamWAV

func _ready():
	var config = ConfigFile.new()
	var err = config.load("res://secrets.cfg")
	
	if err != OK:
		push_error("Could not load secrets.cfg!")
		return
	
	# getting the "openai_key" in the [api] section of the config. It is defaulted to ""
	API_KEY = config.get_value("api", "openai_key", "")
	
	if API_KEY.is_empty():
		push_error("API key not found in secrets.cfg!")
		return
	$HTTPRequest.request_completed.connect(_on_transcription_complete)


# Calling this function with the recorded audio
func transcribe_audio(audio_stream: AudioStreamWAV):
	# Converting audio to WAV bytes
	var audio_data = audio_stream.data
	
	# Creating multipart form data
	var boundary = "----GodotWhisperBoundary"
	var body = PackedByteArray()
	
	# Add file part
	body.append_array(("--" + boundary + "\r\n").to_utf8_buffer())
	body.append_array('Content-Disposition: form-data; name="file"; filename="audio.wav"\r\n'.to_utf8_buffer())
	body.append_array("Content-Type: audio/wav\r\n\r\n".to_utf8_buffer())
	body.append_array(create_wav_file(audio_data, audio_stream.mix_rate))
	body.append_array("\r\n".to_utf8_buffer())
	
	# Add model part
	body.append_array(("--" + boundary + "\r\n").to_utf8_buffer())
	body.append_array('Content-Disposition: form-data; name="model"\r\n\r\n'.to_utf8_buffer())
	body.append_array("whisper-1\r\n".to_utf8_buffer())
	
	# End boundary
	body.append_array(("--" + boundary + "--\r\n").to_utf8_buffer())
	
	# Send request
	var headers = [
		"Authorization: Bearer " + API_KEY,
		"Content-Type: multipart/form-data; boundary=" + boundary
	]
	
	http_request.request(
		"https://api.openai.com/v1/audio/transcriptions",
		headers,
		HTTPClient.METHOD_POST,
		body
	)
	
	print("Sending audio to Whisper API...")

func create_wav_file(audio_data: PackedByteArray, sample_rate: int) -> PackedByteArray:
	var wav = PackedByteArray()
	
	# WAV header
	wav.append_array("RIFF".to_utf8_buffer())
	var file_size = 36 + audio_data.size()
	wav.append_array(_int_to_bytes(file_size, 4))
	wav.append_array("WAVE".to_utf8_buffer())
	
	# fmt chunk
	wav.append_array("fmt ".to_utf8_buffer())
	wav.append_array(_int_to_bytes(16, 4))  # fmt chunk size
	wav.append_array(_int_to_bytes(1, 2))   # audio format (PCM)
	wav.append_array(_int_to_bytes(1, 2))   # channels (mono)
	wav.append_array(_int_to_bytes(sample_rate, 4))
	wav.append_array(_int_to_bytes(sample_rate * 2, 4))  # byte rate
	wav.append_array(_int_to_bytes(2, 2))   # block align
	wav.append_array(_int_to_bytes(16, 2))  # bits per sample
	
	# data chunk
	wav.append_array("data".to_utf8_buffer())
	wav.append_array(_int_to_bytes(audio_data.size(), 4))
	wav.append_array(audio_data)
	
	return wav

func _int_to_bytes(value: int, num_bytes: int) -> PackedByteArray:
	var bytes = PackedByteArray()
	for i in range(num_bytes):
		bytes.append(value & 0xFF)
		value >>= 8
	return bytes

func _on_transcription_complete(_result, response_code, _headers, body):
	if response_code == 200:
		var json = JSON.new()
		var parse_result = json.parse(body.get_string_from_utf8())
		
		if parse_result == OK:
			var response = json.data
			var transcribed_text = response.get("text", "")
			print("Transcription: ", transcribed_text)
			
			# Emitting signal or calling function with the text
			#transcription_received(transcribed_text)
		else:
			print("JSON parse error")
	else:
		print("API Error: ", response_code)
		print("Response: ", body.get_string_from_utf8())

# Override this or connect to it
func transcription_received(text: String):
	print("Got text: ", text)
	# Do something with your transcribed text here!
