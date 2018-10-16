#//--- プラグイン読み込みー ---//
#___plugin___

#//--- ソースファイル読み込み ---//
#___src___

#//--- フィールドオーダー ---//
AssumeFrameBased().ComplementParity()	#トップフィールドが支配的
#AssumeFrameBased()			#ボトムフィールドが支配的

#//--- ロゴ消去フィルタ ---//
#___logo___

#//--- Trimカット編集 ---//
#___trim___

#//--- EasyVFR ---//
#all = src.EasyVFR_Create(a, path="", name="EasyVFR", start=, end=, avg=, chap="", chap_frame=)
#all = all.EasyVFR_Append(b, start=, end=, avg=, chap="", chap_frame=)
#all
#WriteTimeCode_v2()

##### フィルタ #####
#//--- ビデオフィルタ ---//
#KillVideo()									#ビデオ消去

#//--- デインターレース・逆テレシネ ---//
#___deint___

#//--- オーディオフィルタ ---//
#KillAudio()	#音声消去

#//--- その他のフィルタ ---//
#ColorBars (int "width", int "height", string "pixel_type")	#カラーバー

#//--- リサイズ ---//
#___resize___

return last
