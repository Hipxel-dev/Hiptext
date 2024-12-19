extends Resource

export var saved_text = [""]
export var text_names = [""]
export var booleans = []

# s = slider
# t = toggle
# p = seperator with title
# e = selection with arrays as texts
# b = button with scene that spawn upon clickati
# b = button with scene that spawn upon clickati

# Note: Selections define their selected selection by the last string in the array!

var settings = {
	
	"pAudio Settings": "",
	
	"sAudio volume": [100],
	"tEnable audio": true,
	
	"eTyping sound effect": [["Click", "Click 2", "Tap", "Tap 2", "No sound"], 0],
	"eUI click sound effect": [["Click", "Click 2", "Tap", "Tap 2", "No sound"], 0],
	
	"pAppearance": "",
	
	"eSelection of the alphabet": [["a","b","d","e","f","g","h","i","j","k","l","m","n","o","o","p","q","w","r","s","t","u","v","w","x","y","z"], 0],
	
	"sTransparency": [255],
	"tDraw tabs": false,
	"tDraw spaces": false,
	"tShow line numbers": false,
	"tHighlight current line": false,
	
	"eColor theme 1": [["White", "Red", "Yellow", "Green", "Cyan", "Blue", "Magenta", "Purple"], 0],
	"eColor theme 2": [["White", "Red", "Yellow", "Green", "Cyan", "Blue", "Magenta", "Purple"], 0],
	"eFont selection": [["8bitoperator", "picotron"], 0],
	
	"pSystem": false,
	"sRight click to remove time": [1],
	"sRight click to remove time in seconds": [1],
	"tWrap text": true,
	"tAutomatically hide tabs": false,
	"tLow processor mode": false,
	"tKeep screen on": false,
	"tAlways on top": false,
	
	"eAutosave behaviour": [["Always save when inputting text", "Save after changing tabs", "Save after every 5 seconds", "Save after every 15 seconds","Save after every 30 seconds","Save after every 45 seconds"], 0]
	}

export var settings_variable = [
	
]

export var settings_value = [
	
]
	
#	"sSlider_test": 100,
#	"tToggle_test": false,
#	"tToggle_test_1": false,
#	"sSlider_test_1": 200,
#	"pAudio settings": "",
#	"sSlider_test14": 300,
#	"sSlider_test145": 300,
#	"tToggle_test_2": false,

