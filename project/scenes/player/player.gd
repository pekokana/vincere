extends CharacterBody3D

@onready var camera_arm = $SpringArm3D

const SPEED = 5.0
const HIGHT_SPEED = 10.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	# マウスカーソルを画面内に閉じ込め消去する
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	# マウスが動いたときだけ処理
	if event is InputEventMouseMotion:
		# 左右の回転（Y軸まわり）
		camera_arm.rotate_y(-event.relative.x * 0.005)
		# 上下の回転（X軸まわり）
		camera_arm.rotate_x(-event.relative.y * 0.005)

		# 首が180度回転しないように制限（-70度から30度の範囲など）
		camera_arm.rotation.x = clamp(camera_arm.rotation.x, deg_to_rad(-70), deg_to_rad(30))
		
	# ESCキーでマウスを解放する処理（デバッグ時に便利）
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
	var CURRENT_SPEED = SPEED

	# Shiftキー（または設定したアクション）が押されていたら速度アップ
	if Input.is_action_pressed("player_move_dash") and is_on_floor():
		CURRENT_SPEED = HIGHT_SPEED
		$SpringArm3D/Camera3D.fov = lerp($SpringArm3D/Camera3D.fov, 85.0, delta * 5.0)
	else:
		CURRENT_SPEED = SPEED
		$SpringArm3D/Camera3D.fov = lerp($SpringArm3D/Camera3D.fov, 75.0, delta * 5.0)

   

	# 1. 重力処理
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. ジャンプ処理
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. 入力方向の取得
	var input_dir := Input.get_vector("player_move_left", "player_move_right", "player_move_forward", "player_move_back")
	
	# 4. カメラの向きを基準にした移動ベクトル計算
	var view_basis = camera_arm.global_transform.basis
	
	# カメラの「前方(Z)」と「右(X)」を取得し、高さ(Y)を0にして地面に水平にする
	var forward = view_basis.z
	var right = view_basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()

	# 入力（xが左右、yが前後）に合わせて移動方向を決定
	# input_dir.y がプラス（後退）のとき forward(Z+)方向に動く
	var direction = (forward * input_dir.y + right * input_dir.x).normalized()

	if direction:
		velocity.x = direction.x * CURRENT_SPEED
		velocity.z = direction.z * CURRENT_SPEED
	else:
		# 入力がないときは減速
		velocity.x = move_toward(velocity.x, 0, CURRENT_SPEED)
		velocity.z = move_toward(velocity.z, 0, CURRENT_SPEED)

	# 5. 移動の実行
	move_and_slide()
	
	# ログ出力
	PsLog.dlog(global_position, PsLog.dlog_Level.INFO)
