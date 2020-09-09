extends Node2D


onready var x = $UI/x/x
onready var y = $UI/y/y
onready var t = $UI/t/t

onready var h = $UI/h/h
onready var alpha = $UI/alpha/alpha

onready var leg2 = $Node2D/Node2D
onready var leg1 = $Node2D/Node2D2

onready var Floor = $StaticBody2D
onready var Speed = $UI/path845

onready var Ax = $UI/Ax
onready var Ay = $UI/Ay


onready var speed_pos = Speed.position
onready var Ax_pos = Ax.position
onready var Ay_pos = Ay.position


var time = 0

onready var pelv = $Node2D
onready var Heigth = $Node2D/Heigth

func _ready():
		pass

func _process(delta):
		time+=delta
		
#	$Node2D.position.x+=0.1
		
		pelv.position = pelv.position.linear_interpolate(Vector2(pelv.position.x, Heigth.get_collision_point().y - (leg1.l1+leg1.l2-20)),0.5)
		
		
		$UI/x/value.set_text(str(x.value))
		$UI/y/value.set_text(str(y.value))
		$UI/t/value.set_text(str(t.value))
		
		$UI/h/value.set_text(str(h.value))
		$UI/alpha/value.set_text(str(alpha.value))
		
		
		leg2.Ax = x.value
		leg1.Ax = x.value
		
		leg2.Ay = y.value
		leg1.Ay = y.value
		
		leg1.speed = t.value
		leg2.speed = t.value
		
		Floor.position.y = h.value
		Floor.rotation_degrees = alpha.value
		
		var c = Color(0,0,0,1)
		if alpha.value <= 0:
				c.r = range_lerp(alpha.value,-75,0,1,0)
				c.g = range_lerp(alpha.value,-75,0,0,1)
		else:
				c.r = range_lerp(alpha.value,0,75,0,1)
				c.g = range_lerp(alpha.value,0,75,1,0)
		Floor.modulate = c
		
		Speed.scale.x = t.value/10
		var c1 = Color(0,0,0,1)
		c1.b = range_lerp(t.value*sign(t.value),0,10,0,1)
		Speed.modulate = c1
		
		Ax.position.x = Ax_pos.x + (x.value*cos(time*t.value))
		Ay.position.y = Ay_pos.y + (y.value*sin(time*t.value))
		
		#-----------
		var direction = Vector2(
				int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
				int(Input.is_action_pressed("ui_up")) - int(Input.is_action_pressed("ui_down"))
		)
		
		pelv.position.x += t.value*cos(time*t.value)*sign(cos(time*t.value))
#	pelv.get_node("body").position.y = 2*sin(2*time) - 45
#	update()
#
#func _draw():
#	draw_circle(pelv.position,10,Color("#ffffff"))
