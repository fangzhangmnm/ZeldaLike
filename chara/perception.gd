class_name Perception
extends Node3D

const VISUAL_OCCLUSION_LAYERS=0b1

@export var look_distance:float=10
@export var look_angle_deg:float=45
@export var look_vertical_angle_min_deg=-45
@export var look_vertical_angle_max_deg=45
@export var hear_distance:float=2
@export var sense_distance:float=0

@export var exclude_perceptibles:Array[Perceptible]=[]


func check_raycast(target:Perceptible)->bool:
    # can be only called inside _physics_process
    var space_state=get_world_3d().direct_space_state
    var query=PhysicsRayQueryParameters3D.create(global_position,target.global_position)
    query.collide_with_areas=true
    query.collision_mask=VISUAL_OCCLUSION_LAYERS
    query.exclude=exclude_perceptibles
    var result=space_state.intersect_ray(query)
    if result.is_empty():
        return true
    else:
        return result!=target

func can_sense(target:Perceptible)->bool:
    return global_position.distance_to(target.global_position)<=sense_distance

func can_hear(target:Perceptible)->bool:
    var distance_threshold=hear_distance*target.hear_distance_multiplier*target.noise_strength
    return global_position.distance_to(target.global_position)<=distance_threshold

func can_see(target:Perceptible)->bool:
    # can be only called inside _physics_process
    var distance=global_position.distance_to(target.global_position)
    var distance_threshold=look_distance*target.look_distance_multiplier
    if distance>distance_threshold:return false
    var angle_deg=get_angle(target)*rad_to_deg(1)
    if abs(angle_deg.x)>look_angle_deg:return false
    if angle_deg.y<look_vertical_angle_min_deg or angle_deg.y>look_vertical_angle_max_deg:return false
    return check_raycast(target)
    
func get_angle(target:Node3D,_transform:=global_transform)->Vector3:
    var t=Transform3D(_transform);t.basis.x=t.basis.x.normalized();t.basis.y=t.basis.y.normalized();t.basis.z=t.basis.z.normalized()
    var v=global_transform.inverse()*target.global_position
    var angle:Vector3=Vector3(
        atan2(v.x,-v.z),
        atan2(v.y,sqrt(v.x*v.x+v.z*v.z)),
        0)
    return angle








