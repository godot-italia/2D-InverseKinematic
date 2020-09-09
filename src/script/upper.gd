extends Node2D

var l1 = 96
var l2 = 112

var tetat : float
var teta1 : float
var teta2 : float
var teta3 : float

onready var upper = $upper
onready var lower = $upper/lower
onready var foot = $upper/lower/foot
onready var FootRay = $RayCast2D

onready var TargetP = $target

onready var target_position = TargetP.position

var target : Vector2

var t = 0
var speed : float = 0.0

var Ax = 0
var Ay = 0
export var treshold = 0

export var delay = 0.0

export var leg = 0

var colliding = false

signal colliding(leg)
signal not_colliding(leg)

# Called when the node enters the scene tree for the first time.
func _ready():
	print(sqrt(pow(l1,2)+pow(l2,2)))
	teta3 = 0
	foot.rotation = teta3
	t+=delay

func _process(delta : float) -> void:
	t+=delta*speed;
	
	TargetP.position = Vector2(Ax*cos(t) + target_position.x, Ay*sin(t) + target_position.y);
	FootRay.cast_to.x = clamp(TargetP.position.x,-l1-l2,l1+l2+10);
	FootRay.cast_to.y = clamp(TargetP.position.y,-l1-l2,l1+l2+10);
	target = (FootRay.get_collision_point() - position - upper.position - get_parent().position) if FootRay.is_colliding() else TargetP.position - upper.position;
	
	# ----------------------- IK EQUATIONS on ANGLES
	var x : float = target.x;
	var y : float = target.y;
	var x_sq : float = pow(x,2);
	var y_sq : float = pow(y,2);
	var l1_sq : float = pow(l1,2);
	var l2_sq : float = pow(l2,2);
	
	upper.position.y = position.y + 10*sin(t);
	
	teta2 = acos( (x_sq + y_sq - l1_sq - l2_sq) / (2*l1*l2) );
	teta1 = atan2( (y*(l1 + l2*cos(teta2)) - x*l2*sin(teta2)), (x*(l1 + l2*cos(teta2)) + y*l2*sin(teta2)) );
	teta3 = -teta1-teta2 + ((PI/2) + (FootRay.get_collision_normal().rotated((PI/2)).angle()));
	# -----------------------------------------------
	
#	print("teta1: %f , teta2: %f" %[teta1,teta2])
	upper.rotation = teta1;
	lower.rotation = teta2;
	foot.rotation = teta3;
	
	
	
	if FootRay.is_colliding() and not colliding:
			colliding = true
			emit_signal("colliding",leg)
	else:
			colliding = false
			emit_signal("not_colliding",leg)
