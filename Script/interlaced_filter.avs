#//--- EasyVFR ---//
#all = src.EasyVFR_Create(a, path="", name="EasyVFR", start=, end=, avg=, chap="", chap_frame=)
#all = all.EasyVFR_Append(b, start=, end=, avg=, chap="", chap_frame=)
#all
#WriteTimeCode_v2()

##### フィルタ #####
#//--- ビデオフィルタ ---//
#KillVideo()									#ビデオ消去
#FilterRange(clip "clip", int "start", int "end", string "filter")	#フィルタの引数に二重引用符が含まれる場合、外側の二重引用符を 3 つ重ねる
#EraseLOGO(logofile=".lgd", start=0, fadein=0, fadeout=0, end=-1, interlaced=true)
#ColorYUY2(levels="709->601")	#BT.709からBT.601へ変換
