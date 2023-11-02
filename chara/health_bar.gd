@tool
extends Node

@export var chara:Node

@export var health_bar:TextureProgressBar
@export var poise_bar:TextureProgressBar

@export var sprite:Sprite3D
@export var subviewport:SubViewport

@export var lerp_speed:float=5

func _ready():
    if chara and health_bar:
        health_bar.max_value = chara.max_health
        health_bar.value = chara.current_health
    if chara and poise_bar:
        poise_bar.max_value = chara.max_poise
        poise_bar.value = chara.current_poise

func _physics_process(delta):
    if chara and health_bar:
        health_bar.max_value = chara.max_health
        health_bar.value = lerp(health_bar.value,chara.current_health,lerp_speed*delta)
    if chara and poise_bar:
        poise_bar.max_value = chara.max_poise
        poise_bar.value = lerp(poise_bar.value,chara.current_poise,lerp_speed*delta)
    if sprite and subviewport:
        sprite.visible=chara.current_health>0
        sprite.texture= subviewport.get_texture()
        
    

