@tool
extends Node2D

@export var chara:Node

@export var health_bar:TextureProgressBar
@export var poise_bar:TextureProgressBar

@export var lerp_speed:float=5

func _ready():
    if chara:
        self.visible=chara.current_health>0
        if health_bar:
            health_bar.max_value = chara.max_health
            health_bar.value = chara.current_health
        if poise_bar:
            poise_bar.max_value = chara.max_poise
            poise_bar.value = chara.current_poise

func _physics_process(delta):
    if chara:
        self.visible=chara.current_health>0
        if health_bar:
            health_bar.max_value = chara.max_health
            health_bar.value = lerp(health_bar.value,chara.current_health,lerp_speed*delta)
        if poise_bar:
            poise_bar.max_value = chara.max_poise
            poise_bar.value = lerp(poise_bar.value,chara.current_poise,lerp_speed*delta)
        
    

