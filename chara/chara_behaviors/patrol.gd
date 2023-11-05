extends CharaBehaviorAction

enum StartBehavior{START_AT_BEGINNING,START_AT_NEAREST,START_AT_LAST_INTERRUPT}

@export var patrol_path_key := "patrol_path"
@export var start_behavior:=StartBehavior.START_AT_LAST_INTERRUPT
@export var min_distance:=0.5
@export var speed_multiplier:=0.5
@export var speed_coeff:=1.

var next_waypoint_id:int=0

func start():
    var patrol_path=blackboard.get_value(patrol_path_key)
    if not patrol_path is Path3D:
        push_warning("PatrolPathAction: patrol_path is not a Path3D, behavior will fail")
        return
    patrol_path=patrol_path as Path3D
    match StartBehavior:
        StartBehavior.START_AT_BEGINNING:
            next_waypoint_id=0
        StartBehavior.START_AT_NEAREST:
            var dist=INF
            for i in range(patrol_path.curve.get_point_count()):
                var d=chara.distance_to(patrol_path.transform*patrol_path.curve.get_point_position(i))
                if d<dist:
                    dist=d
                    next_waypoint_id=i
        StartBehavior.START_AT_LAST_INTERRUPT:
            pass

func tick():
    var patrol_path=blackboard.get_value(patrol_path_key) as Path3D
    if not patrol_path is Path3D: return FAILURE
    patrol_path=patrol_path as Path3D
    if next_waypoint_id>=patrol_path.curve.get_point_count():
        next_waypoint_id=0
        return SUCCESS
    var next_waypoint=patrol_path.transform*patrol_path.curve.get_point_position(next_waypoint_id)
    if chara.distance_to(next_waypoint)<min_distance:
        next_waypoint_id+=1
    else:
        var input_move=speed_multiplier*(next_waypoint-chara.global_position)*speed_coeff
        input_move=input_move.limit_length(speed_multiplier)
        chara.input_move=input_move
    return RUNNING

func cleanup():
    chara.input_move=Vector3.ZERO
