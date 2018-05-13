#//--- インターレース解除 ---//
#Its(opt=1, def="C:\local\def\test.def", fps=-1, debug=false, output=".\sample.tmc", chapter="bar.xml")	#逆テレシネとインターレース解除の切り換え器
#Auto24FPS(drop=true, threshold=24, border=16, mode="", debug=false)	#(true:逆テレシネ/false:プログレ化のみ,,, "":ノーマル, "blend":縞二重化, "dot":ドットで解除)
#IT(fps = 24, ref = "TOP", blend = false, diMode = 1)	#(24:24fps化/30:プログレ化のみ,,true:24の時のみ有効スムージング,0:解除しない/1:IT/2:簡易二重化/3:フィールド補間)
#TDeint(mode=2, full=false, cthresh=20, type=3, mthreshl=10, mtnmode=0, ap=10, aptype=2, expand=8).TDecimate(mode=1)	#アプコン縞向け
#IVTC24(TFM=6, TDecimate=2)	#高精度
