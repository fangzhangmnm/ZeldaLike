extends Node3D

@export_group("Target Follow")
@export var target: Node
@export var target_offset: Vector3=Vector3(0, 1.8, 0)
@export var follow_damping=4


@export_group("Zoom")
@export var zoom_minimum = 8
@export var zoom_maximum = 3
@export var zoom_speed = 10
@export var zoom_damping=8

@export_group("Rotation")
@export var joystick_sensitivity = 120
@export var mouse_sensitivity=0.1
@export var rotation_damping=20

var camera_rotation:Vector3
var zoom = 3

@onready var camera = $Camera3D

func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    camera_rotation = rotation_degrees 

func _physics_process(delta):
    if Input.is_action_just_pressed("mouse_capture"):
        if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        else:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    
    
    camera_rotation.x+=Input.get_axis("look_up", "look_down") * joystick_sensitivity * delta
    camera_rotation.y+=Input.get_axis("look_right", "look_left") * joystick_sensitivity * delta
    camera_rotation.x = clamp(camera_rotation.x, -80, -10)
    
    
    zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
    zoom = clamp(zoom, zoom_maximum, zoom_minimum)
    
    self.global_position = self.global_position.lerp(target.global_transform*target_offset, delta * follow_damping)
    self.rotation_degrees = self.rotation_degrees.lerp(camera_rotation, delta * rotation_damping)
    
    camera.position = camera.position.lerp(Vector3(0, 0, zoom), delta*zoom_damping)
    

func _input(event):
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        camera_rotation += Vector3(-event.relative.y, -event.relative.x, 0)*mouse_sensitivity
        camera_rotation.x = clamp(camera_rotation.x, -80, -10)
