extends Node3D

@onready var omni_light_3d: OmniLight3D = $OmniLight3D

# Exported properties for user modification
@export var flicker_intensity: float = 0.2
@export var flicker_speed: float = 5.0
@export var base_intensity: float = 1.0

# Internal variables
var time_passed: float = 0.0
var noise: FastNoiseLite = FastNoiseLite.new()

func _ready():
	# Configure the noise parameters
	noise.seed = randi()
	noise.frequency = 1.0

func _process(delta: float):
	time_passed += delta * flicker_speed
	var flicker_value = noise.get_noise_1d(time_passed) * flicker_intensity
	omni_light_3d.light_energy = base_intensity + flicker_value
