extends Node

# AssemblyAI API key (environment variable)
var API_KEY: String = ""

const BASE_URL = "https://api.assemblyai.com"

var http_request: HTTPRequest
var transcript_id: String = ""

func _ready():
	# Loading API key from config
	var config = ConfigFile.new()
	var err = config.load("res://secrets.cfg")
	if err == OK:
		API_KEY = config.get_value("api", "assemblyai_key", "")
	else:
		print("Error in config file: " + str(err) +"\n")
		return
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_complete)

# calling this with the recorded audio
func transcribe_audio(audio_stream: AudioStreamWAV):
	# Uploading local file
	upload_local_file(audio_stream)

func upload_local_file(audio_stream: AudioStreamWAV):
	print("Uploading audio file..."+ "\n")
	
	# Creating WAV file bytes
	var audio_data = create_wav_file(audio_stream.data, audio_stream.mix_rate)
	
	var headers = [
		"authorization: " + API_KEY
	]
	
	# Upload
	http_request.request_raw(
		BASE_URL + "/v2/upload",
		headers,
		HTTPClient.METHOD_POST,
		audio_data
	)

func create_transcript_request(audio_url: String):
	print("Creating transcript request..."+ "\n")
	
	# Create request data
	var data = {
		"audio_url": audio_url,
		"speech_model": "universal"
	}
	
	var json_string = JSON.stringify(data)
	var body = json_string.to_utf8_buffer()
	
	var headers = [
		"authorization: " + API_KEY,
		"Content-Type: application/json"
	]
	
	http_request.request_raw(
		BASE_URL + "/v2/transcript",
		headers,
		HTTPClient.METHOD_POST,
		body
	)

func poll_transcript():
	print("Polling transcript status...\n")
	
	var headers = [
		"authorization: " + API_KEY
	]
	
	var polling_endpoint = BASE_URL + "/v2/transcript/" + transcript_id
	
	http_request.request(
		polling_endpoint,
		headers,
		HTTPClient.METHOD_GET
	)

func _on_request_complete(_result, response_code, _headers, body):
	var response_text = body.get_string_from_utf8()
	
	print("=== Response Code: ", response_code, " ===\n")
	#--debugging
	#print("Response: ", response_text)
	
	if response_code != 200:
		print("API Error: ", response_code)
		return
	
	var json = JSON.new()
	var parse_result = json.parse(response_text)
	
	if parse_result != OK:
		print("JSON parse error")
		return
	
	var response = json.data
	#--debugging
	#print("Response keys: ", response.keys())
	
	# Check which endpoint responded
	if response.has("upload_url"):
		# Upload complete - got audio URL
		var audio_url = response["upload_url"]
		print("✓ Upload successful! URL: ", audio_url)
		create_transcript_request(audio_url)
		
	elif response.has("id") and response.has("status") and transcript_id == "":
		# Transcript request created - got transcript ID (first time)
		transcript_id = response["id"]
		print("✓ Transcript created! ID: ", transcript_id)
		print("Status: ", response["status"])
		# Wait 1 second before first poll
		await get_tree().create_timer(1.0).timeout
		poll_transcript()
		
	elif response.has("status") and transcript_id != "":
		# Polling response
		var status = response["status"]
		print("Status: ", status)
		
		if status == "completed":
			# Done!
			var transcript_text = response.get("text", "")
			print("✓ Transcript Text: ", transcript_text)
			transcription_received(transcript_text)
			
		elif status == "error":
			var error_msg = response.get("error", "Unknown error")
			push_error("Transcription failed: " + error_msg)
			print("✗ Transcription failed: ", error_msg)
			
		else:
			# Still processing (queued or processing)
			print("⏳ Waiting 1 seconds...")
			await get_tree().create_timer(1.0).timeout
			poll_transcript()

func create_wav_file(audio_data: PackedByteArray, sample_rate: int) -> PackedByteArray:
	var wav = PackedByteArray()
	
	# WAV header
	wav.append_array("RIFF".to_utf8_buffer())
	var file_size = 36 + audio_data.size()
	wav.append_array(_int_to_bytes(file_size, 4))
	wav.append_array("WAVE".to_utf8_buffer())
	
	# fmt chunk
	wav.append_array("fmt ".to_utf8_buffer())
	wav.append_array(_int_to_bytes(16, 4))
	wav.append_array(_int_to_bytes(1, 2))
	wav.append_array(_int_to_bytes(1, 2))
	wav.append_array(_int_to_bytes(sample_rate, 4))
	wav.append_array(_int_to_bytes(sample_rate * 2, 4))
	wav.append_array(_int_to_bytes(2, 2))
	wav.append_array(_int_to_bytes(16, 2))
	
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

# Override this or connect to it
func transcription_received(text: String):
	print("=== TRANSCRIPTION COMPLETE ===")
	$"../../TranscribedText".set_text(text)
	print("==============================")
	# Do something with your transcribed text here!
