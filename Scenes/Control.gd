extends Control

# Variables to hold arrays
var texts := ["I only know 25 letters of the alphabet", 
"Why did the math book look sad?", 
"I named my dog Five Miles so I tell people", 
"What's a tree's favorite drink?",
"Why don't scientists trust stairs?"]
var correctAnswers := ["I don't know u", 
"Too many problems", 
"I walk Five Miles 
every day!", 
"Root beer.",
"Gravity"]
var wrongAnswers := ["I forgot the last one", 
"Lost its cover", 
"life is truly about the friends", 
"Leaf juice",
"Unstable",]
var equalAnswers := ["I have dementia", 
"Old pages", 
"I ran over 
Five Miles",
"Sap",
"Something",]

# Variables for UI elements
var label : Label
var buttons : Array
var progressBar : ProgressBar
var animatedSprite1 : AnimatedSprite2D
var animatedSprite2 : AnimatedSprite2D
var animatedSprite3 : AnimatedSprite2D
var audioStreamPlayer : AudioStreamPlayer2D
var audioStreamPlayer2 : AudioStreamPlayer2D
var audioStreamPlayer3 : AudioStreamPlayer2D
# Variable to track current question index
var currentQuestionIndex : int = -1

# Variable to track progress
var progress : float = 50

var state = [null, null,null]
func _ready():
	
	# Access UI elements
	label = $PanelContainer/Label
	buttons = [$HBoxContainer/ButtonOne, $HBoxContainer/ButtonTwo, $HBoxContainer/ButtonThree]
	progressBar = $ProgressBar
	animatedSprite1 = $"../Node2D/AnimatedSprite2D"
	animatedSprite2 = $"../Node2D/AnimatedSprite2D2"
	animatedSprite3 = $"../Node2D/AnimatedSprite2D3"
	audioStreamPlayer = $"../AudioStreamPlayer2D"
	audioStreamPlayer2 = $"../AudioStreamPlayer2D2"
	audioStreamPlayer3 = $"../AudioStreamPlayer2D3"
	audioStreamPlayer3.stream = preload("res://Audio/idle_song.wav")
	#audioStreamPlayer3.loop  
	audioStreamPlayer3.play()
	
	for i in range(3):
			buttons[i].pressed.connect(_on_button_cick.bind(i))
	# Initialize UI
	next_question()
	
	
func _on_button_cick(i):
	if state[i] == "wrong":
		_on_wrong_button_pressed()
	elif state[i] == "equal":
		_on_equal_button_pressed()
	elif state[i] == "correct":
		_on_correct_button_pressed()
	pass
	
func next_question():
	print("NEXT")
	# Move to the next question
	currentQuestionIndex += 1
	print(currentQuestionIndex)

	# Check if all questions are answered
	if currentQuestionIndex >= texts.size():
		# Check if progress reaches 100%
		if progress >= 100:
			get_tree().change_scene_to_file("res://Scenes/win.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
		return
	# Update label with question text
	label.text = texts[currentQuestionIndex]
	# Randomly assign answers to buttons
	var answers = [correctAnswers[currentQuestionIndex], wrongAnswers[currentQuestionIndex], equalAnswers[currentQuestionIndex]]
	answers.shuffle()
	for i in range(3):
		print(i)
		buttons[i].text = answers[i]
		print(buttons[i])
		print(buttons[i].pressed)
		if answers[i] == correctAnswers[currentQuestionIndex]:
			state[i] = "correct"
			#buttons[i].connect("pressed", self, "_on_correct_button_pressed")
		elif answers[i] == wrongAnswers[currentQuestionIndex]:
			state[i] = "wrong"
			#buttons[i].pressed.connect(func():call("_on_wrong_button_pressed"))
		else:
			state[i] = "equal"
			#buttons[i].connect("pressed", self, "_on_equal_button_pressed")
			#buttons[i].pressed.connect(func():call("_on_equal_button_pressed"))
func _on_correct_button_pressed():
	print("CORRECT")
	progress += 10
	progressBar.value = progress
	$PanelContainer.visible = false
	label.visible = false
	for button in buttons:
		button.visible = false
	animatedSprite1.stop()
	animatedSprite3.play("crowd")
	animatedSprite1.play("winning_animation")
	animatedSprite2.play("win_clown")
	audioStreamPlayer3.stop()
	audioStreamPlayer.stream = preload("res://Audio/win110.wav")
	audioStreamPlayer.play()
	await get_tree().create_timer(2.0).timeout  # Delay for 2 seconds
	update_animations()
	animatedSprite1.play("idle_animation")
	animatedSprite3.stop()
	audioStreamPlayer3.play()
	$PanelContainer.visible = true  # Show the container
	label.visible = true
	#animatedSprite1.play("idle_anim")
	for button in buttons:
		button.visible = true
	next_question()
	

func _on_wrong_button_pressed():
	print("WRONG")
	# Decrease progress by 10% and update animations
	progress -= 10
	progressBar.value = progress
	$PanelContainer.visible = false  # Hide the container
	label.visible = false
	for button in buttons:
		button.visible = false
	animatedSprite1.stop()
	animatedSprite3.play("crowd")
	animatedSprite1.play("losing_anim")
	animatedSprite2.play("lose_clown")
	audioStreamPlayer3.stop()
	audioStreamPlayer2.stream = preload("res://Audio/dark1.wav")
	audioStreamPlayer2.play()
	update_animations()
	#animatedSprite1.play("idle_animation")
	animatedSprite3.stop()
	audioStreamPlayer3.play()
	await get_tree().create_timer(2.0).timeout  # Delay for 2 seconds
	$PanelContainer.visible = true  # Show the container
	label.visible = true
	for button in buttons:
		button.visible = true
	next_question()
	
func _on_equal_button_pressed():
	print("EQUAL")
	# Do nothing for equal answers
	$PanelContainer.visible = false  # Hide the container
	label.visible = false
	audioStreamPlayer3.stop()
	for button in buttons:
		button.visible = false
	#animatedSprite1.play("idle_anim")
	animatedSprite3.play("crowd")
	animatedSprite2.play("idle_clown")
	await get_tree().create_timer(2.0).timeout  # Delay for 2 seconds
	$PanelContainer.visible = true  # Show the container
	label.visible = true
	audioStreamPlayer3.play()
	for button in buttons:
		button.visible = true
	next_question()
	animatedSprite3.play("crowd")
	next_question()
	pass
	
func update_animations():
	# Update animated sprites based on progress Clown
	if progress >= 50:
		animatedSprite2.play("win_clown")
	elif progress >= 30:
		animatedSprite2.play("lose_clown")
	else:
		animatedSprite2.play("win_clown")
	# Play animations for winning or losing
	#if int(progress) % 100 == 0:
		##animatedSprite1.play("winning_animation")
		#animatedSprite2.play("win_clown")
		##audioStreamPlayer.stream = preload("res://Audio/win110.wav")
	#elif int(progress) % 10 == 0:
		##animatedSprite1.play("losing_animation")
		#animatedSprite2.play("lose_clown")
		##audioStreamPlayer.stream = preload("res://Audio/dark1.wav")
		#audioStreamPlayer.play()
	#else:
		#animatedSprite1.play("idle_animation")
		#animatedSprite2.play("idle_clown")
