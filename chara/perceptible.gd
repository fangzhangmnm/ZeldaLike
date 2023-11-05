class_name Perceptible
extends Node3D

const GROUP_NAME="Perceptibles"

@export var invisible: bool = false
@export var look_distance_multiplier: float = 1.0
@export var hear_distance_multiplier: float = 1.0
@export var sense_distance_multiplier: float = 1.0

var noise_strength: float = 0.0
@export var enabled: bool = true

func _init():
    add_to_group(GROUP_NAME)