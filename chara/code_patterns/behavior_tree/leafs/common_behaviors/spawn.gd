class_name BehaviorSpawn
extends BehaviorAction

@export var prefab:PackedScene
@export var position_key:StringName="spawn_position"
@export var group:StringName=""

func tick()->Result:
    var spawn_transform=Transform3D()
    var position=blackboard.get_value(position_key)
    print(position)
    if position is Node3D:
        spawn_transform=position.global_transform
    elif position is Vector3:
        spawn_transform.origin=position
    else:
        return FAILURE
    var instance=prefab.instantiate()
    instance.global_transform=spawn_transform
    if group!="":instance.add_to_group(group)
    get_tree().get_root().add_child(instance)
    # TODO check collision
    # TODO random range, random choices
    return SUCCESS