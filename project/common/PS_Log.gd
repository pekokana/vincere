## [PS_Log] コアロギング・診断クラス
##
## 開発時のみコンソールに色付き（絵文字）でログを出力します。
## Autoload時の名称は[PsLog]
extends Node

## ログレベルの定義
enum dlog_Level { INFO, WARN, ERROR, DEBUG }

## デバッグログを出力します[br]
## [b]Example: [/b][br]
## [code]PsLog.dlog("メッセージ", PS_LOG.dlog_Level.DEBUG)[/code]
## [param msg] 出力したいメッセージ（Variant方なのでなんでもOK）
## [param level] ログレベル（デフォルトはDEBUG)
func dlog(msg: Variant, level: dlog_Level = dlog_Level.DEBUG):
	if not OS.is_debug_build():
		return

	var prefix = ""
	match level:
		dlog_Level.INFO:  prefix = "📘[Ps-INFO]"
		dlog_Level.WARN:  prefix = "⚠[Ps-WARN]"
		dlog_Level.ERROR: prefix = "🚫[Ps-ERROR]"
		dlog_Level.DEBUG: prefix = "🛠️[Ps-DEBUG]"
	
	# 時刻付きで出力（10年前のPCでも、この程度の文字列操作は問題ありません）
	var time = Time.get_time_string_from_system()
	print("%s %s: %s" % [prefix, time, str(msg)])

## デバック用のショートカット関数
func d(msg): dlog(msg, dlog_Level.DEBUG)
func e(msg): dlog(msg, dlog_Level.ERROR)


## 実行時のノードツリー構造とアタッチされたスクリプト、メソッド一覧をコンソールに出力します。[br]
## [b]Example:[/b][br]
## [code]PsLog.print_node_tree(get_tree().root)[/code]
## [param node] 解析を開始するルートノード
## [param indent] 内部処理用のインデント階層（通常は指定不要）
func print_node_tree(node: Node, indent: int = 0) -> void:
	if not OS.is_debug_build():
		return

	var prefix = "  ".repeat(indent)
	var type_name = node.get_class()
	var line = "%s|-- %s (%s)" % [prefix, node.name, type_name]
	
	var script = node.get_script()
	if script != null:
		line += " [Script]"
		
	# 自作のdebug_log経由で出力（フォーマットを統一）
	print(line)

	# メソッド一覧の出力
	if script != null and script is Script:
		var method_list = script.get_script_method_list()
		if not method_list.is_empty():
			var methods_str = []
			for method in method_list:
				methods_str.append(method.name)
			print("%s  |-> Methods: [%s]" % [prefix, ", ".join(methods_str)])

	# 子ノードを再帰的に処理
	for child in node.get_children():
		print_node_tree(child, indent + 1)

## 現在の全シーンツリーをダンプします。
func dump_all():
	print("=== P's factory: Scene Tree Dump ===")
	print_node_tree(get_tree().root)
	print("====================================")
