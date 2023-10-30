class_name CameraController
extends Camera3D

@export var pivot: Node3D
@onready var camera = self


@export_group("Target Follow")
@export var target: Node3D
@export var target_offset: Vector3=Vector3(0, 1.8, 0)
@export var follow_damping=4
@export var secondary_target: Node3D
@export var secondary_target_offset: Vector3=Vector3(0, 1.8, 0)


@export_group("Zoom")
@export var zoom_minimum = 8
@export var zoom_maximum = 3
@export var zoom_speed = 10
@export var zoom_damping=8

@export_group("Rotation")
@export var joystick_sensitivity = 120
@export var mouse_sensitivity=0.1
@export var rotation_damping=20
@export var rotation_lower_limit=-80
@export var rotation_upper_limit=30

var camera_rotation:Vector3
var zoom = 3

func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    camera_rotation = pivot.global_rotation 

func _physics_process(delta):
    if Input.is_action_just_pressed("mouse_capture"):
        if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        else:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    
    
    camera_rotation.x-=Input.get_axis("look_up", "look_down") * deg_to_rad(joystick_sensitivity) * delta
    camera_rotation.y+=Input.get_axis("look_right", "look_left") * deg_to_rad(joystick_sensitivity) * delta
    camera_rotation.x = clamp(camera_rotation.x, deg_to_rad(rotation_lower_limit), deg_to_rad(rotation_upper_limit))

    # if have secondary target, use it to calculate the rotation
    if secondary_target:
        var secondary_target_point=secondary_target.global_transform*secondary_target_offset
        if (secondary_target_point-target.global_transform.origin).length()>1:
            var look_at_transform=pivot.global_transform.looking_at(secondary_target.global_transform*secondary_target_offset, Vector3(0, 1, 0))
            camera_rotation=look_at_transform.basis.get_euler()
            camera_rotation.x = clamp(camera_rotation.x, deg_to_rad(rotation_lower_limit), deg_to_rad(rotation_upper_limit))
    
    
    zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
    zoom = clamp(zoom, zoom_maximum, zoom_minimum)
    
    pivot.global_position = pivot.global_position.lerp(target.global_transform*target_offset, delta * follow_damping)
    pivot.global_rotation = lerp_euler_angle(pivot.global_rotation, camera_rotation, delta * rotation_damping)
    
    camera.position = camera.position.lerp(Vector3(0, 0, zoom), delta*zoom_damping)

func lerp_euler_angle(a,b,t):
    var result = Vector3()
    for i in range(3):
        result[i] = lerp_angle(a[i], b[i], t)
    return result

func _input(event):
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        camera_rotation += Vector3(-event.relative.y, -event.relative.x, 0)*deg_to_rad(mouse_sensitivity)
        camera_rotation.x = clamp(camera_rotation.x, deg_to_rad(rotation_lower_limit), deg_to_rad(rotation_upper_limit))
