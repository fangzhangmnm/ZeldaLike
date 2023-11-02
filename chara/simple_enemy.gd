extends Node


@onready var chara:Chara = owner
@onready var state_machine:CharaStateMachine=%CharaStateMachine
var player:Chara
@onready var timer:Timer = $Timer

func _ready():
    player=owner.get_tree().get_nodes_in_group("player")[0]
    await chara.ready
    mainloop()

func wait_time(sec):
    timer.wait_time=sec
    timer.start()
    await timer.timeout

func player_dist():
    return (player.global_position-chara.global_position).length()

func player_angle_deg():
    return rad_to_deg((player.global_position-chara.global_position).angle_to(-chara.global_transform.basis.z))

func player_in_face():
    return player_angle_deg()<30 and player_dist()<1.5



func mainloop():
    while true:
        while player_dist()>100:
            await wait_time(0.5)
        while player_dist()>3:
            chara.input_move=(player.global_position-chara.global_position).normalized()
            await wait_time(0.1)
        chara.input_target=player
        while not player_in_face():
            chara.input_move=(player.global_position-chara.global_position).normalized()*.5
            await wait_time(0.1)
        chara.input_move=Vector3.ZERO
        await wait_time(0.5)
        while player_in_face():
            chara.input_action_buffed=chara.InputAction.ATTACK
            await wait_time(0.5)
            if player_in_face():
                chara.input_action_buffed=chara.InputAction.ATTACK
                await wait_time(1.5)
        chara.input_target=null


