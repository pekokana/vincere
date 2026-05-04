extends CharacterBody3D


@onready var camera_arm = $SpringArm3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	# 重力処理（変更なし）
	if not is_on_floor():
		velocity += get_gravity() * delta

	# ジャンプ処理（変更なし）
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 入力方向の取得（変更なし）
	var input_dir := Input.get_vector("player_move_left", "player_move_right", "player_move_forward", "player_move_back")

	# --- ここから修正 ---
	
	# カメラの向きを基準に移動方向を計算する
	# camera_arm（SpringArm3D）の向きを取得
	var view_basis = camera_arm.global_transform.basis
	
	# カメラの向きに基づいて、地面の前後左右ベクトルを作成
	var forward = view_basis.z
	var right = view_basis.x
	
	# Y軸（上下）の成分を消して、地面と平行にする
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()

	# 入力ベクトルとカメラの向きを掛け合わせる
	# input_dir.y は「前/後」なので forward を掛ける
	var direction = (forward * input_dir.y + right * input_dir.x).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		# 移動方向を向く（ここに移動したことで、移動中だけ回転する）
		var target_rotation = atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, delta * 10.0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# マウスの左右の動きを、自撮り棒（SpringArm）の回転に反映
		camera_arm.rotate_y(-event.relative.x * 0.005)
		# 上下の動き（首振り）も制限付きで追加
		camera_arm.rotate_x(-event.relative.y * 0.005)
		camera_arm.rotation.x = clamp(camera_arm.rotation.x, -deg_to_rad(60), deg_to_rad(30))
