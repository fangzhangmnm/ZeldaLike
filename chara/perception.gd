@tool
class_name Perception
extends Node3D

const VISUAL_OCCLUSION_LAYERS=0b1


@export_category("Update Behavior")
enum Tick_Behavior{PHYSICS_PROCESS,EXTERNAL}
@export var tick_behavior:Tick_Behavior=Tick_Behavior.PHYSICS_PROCESS
@export var skip_ticks:int=0

@export_category("Perception Ability")
@export var look_distance:float=10
@export var look_angle_deg:float=45
@export var look_vertical_angle_min_deg=-45
@export var look_vertical_angle_max_deg=45
@export var hear_distance:float=5
@export var sense_distance:float=0


var perceived:Array[Perceptible]=[]
var perceived_data:Dictionary={}
var target:Perceptible=null
var skip_tick_counter:int=0



func check_raycast(_target:Perceptible)->bool:
    # can be only called inside _physics_process
    var space_state=get_world_3d().direct_space_state
    var query=PhysicsRayQueryParameters3D.create(global_position,_target.global_position)
    query.collide_with_areas=true
    query.collision_mask=VISUAL_OCCLUSION_LAYERS
    var result=space_state.intersect_ray(query)
    if result.is_empty():
        return true
    else:
        return result.collider!=_target

func can_sense(_target:Perceptible)->bool:
    return distance_to(_target)<=sense_distance

func can_hear(_target:Perceptible)->bool:
    var distance_threshold=hear_distance*_target.hear_distance_multiplier*_target.noise_strength
    return distance_to(_target)<=distance_threshold

func can_see(_target:Perceptible,raycast:bool=true)->bool:
    # can be only called inside _physics_process
    if _target.invisible:return false
    var distance=distance_to(_target)
    var distance_threshold=look_distance*_target.look_distance_multiplier
    if distance>distance_threshold:return false
    if not in_look_angle(_target):return false
    if raycast:
        if not check_raycast(_target):return false
    return true

func can_perceive(_target:Perceptible)->bool:
    return can_sense(_target) or can_hear(_target) or can_see(_target)

func distance_to(_target:Variant,_transform:=global_transform)->float:
    if _target is Node3D:_target=(_target as Node3D).global_position
    return _transform.origin.distance_to(_target)
    
func angle_to(_target:Variant,_transform:=global_transform)->Vector3:
    if _target is Node3D:_target=(_target as Node3D).global_position
    var t=Transform3D(_transform);t.basis.x=t.basis.x.normalized();t.basis.y=t.basis.y.normalized();t.basis.z=t.basis.z.normalized()
    var v=global_transform.inverse()*_target
    var angle:Vector3=Vector3(
        atan2(v.y,sqrt(v.x*v.x+v.z*v.z)),
        atan2(v.x,-v.z),
        0)
    return angle

func angle_to_deg(_target:Variant,_transform:=global_transform)->Vector3:
    return angle_to(_target,_transform)*rad_to_deg(1)

func in_look_angle(_target:Variant)->bool:
    var angle=angle_to(_target)
    var angle_deg=angle*rad_to_deg(1)
    if abs(angle_deg.y)>look_angle_deg:return false
    if angle_deg.x<look_vertical_angle_min_deg or angle_deg.x>look_vertical_angle_max_deg:return false
    return true

func find_nearest_perceived(criteria:Callable,custom_distance:Callable=distance_to)->Perceptible:
    var distance=INF
    var nearest:Perceptible=null
    for perceptible in perceived:
        if is_instance_valid(perceptible) and perceptible.enabled:
            if criteria.call(perceptible):
                var d=custom_distance.call(perceptible)
                if d<distance:
                    distance=d
                    nearest=perceptible
    return nearest

func _ready():
    skip_tick_counter=randi()%skip_ticks if skip_ticks>0 else 0

func _physics_process(_delta):
    if tick_behavior==Tick_Behavior.PHYSICS_PROCESS:
        tick(_delta)

func tick(_delta):
    if Engine.is_editor_hint(): return
    if not Engine.is_in_physics_frame(): assert(false,"Perception.tick() must be called inside _physics_process")
    if skip_tick_counter>0:skip_tick_counter-=1;return
    skip_tick_counter=skip_ticks

    # can be only called inside _physics_process
    perceived.clear()
    perceived_data.clear()
    var all_perceptibles=get_tree().get_nodes_in_group(Perceptible.GROUP_NAME)
    # print(all_perceptibles)
    for perceptible in all_perceptibles:
        if perceptible is Perceptible:
            perceptible=perceptible as Perceptible
            if perceptible.enabled:
                if can_perceive(perceptible):
                    perceived.append(perceptible)
    # printt(owner.name,perceived)


