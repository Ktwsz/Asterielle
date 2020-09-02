extends Node2D

const WEBSITE_ADDRESS = "http://elf-vs-dwarves.pl"
const WORLD_SCENE = preload("res://Scenes/World/World.tscn")

onready var home = get_node("Canvas/Home")
onready var options = get_node("Canvas/Options")
onready var about = get_node("Canvas/About")



func _ready():
	setup_continue_btn_visible()
	setup_exit_btn_visible()

func setup_continue_btn_visible():
	if !Directory.new().file_exists(GameSaver.SAVE_PATH):
		home.find_node("ContinueBtn").visible = false
		
func setup_exit_btn_visible():
	if OS.get_name() == "HTML5":
		home.find_node("ExitBtn").visible = false

func switch_panel(menu_panel):
	hide_all_panel()
	match menu_panel:
		MENU_PANEL.HOME:
			home.visible = true
		MENU_PANEL.OPTIONS:
			options.visible = true
		MENU_PANEL.ABOUT:
			about.visible = true

func hide_all_panel():
	home.visible = false
	options.visible = false
	about.visible = false

enum MENU_PANEL{
	HOME,
	OPTIONS,
	ABOUT
}

func start_new_game():
	Directory.new().remove(GameSaver.SAVE_PATH)
	ElfStats.restore_to_default()
	GameData.reset()
	get_tree().change_scene_to(WORLD_SCENE)

func _on_NewGameBtn_pressed():
	var slides = $Canvas/StorySlides
	slides.visible = true
	
func _on_ContinueBtn_pressed():
	get_tree().change_scene_to(WORLD_SCENE)

func _on_OptionsBtn_pressed():
	switch_panel(MENU_PANEL.OPTIONS)

func _on_AboutBtn_pressed():
	switch_panel(MENU_PANEL.ABOUT)

func _on_ExitBtn_pressed():
	get_tree().quit()

func _on_BackBtn_pressed():
	switch_panel(MENU_PANEL.HOME)

func _on_LinkBtn_pressed():
	OS.shell_open(WEBSITE_ADDRESS) 
