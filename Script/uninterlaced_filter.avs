#//--- 非インターレースフィルタ ---//
#ConvertToYV12()
#Clean_SC()
#DecombUCF()
#fPMD(strength = 10, threshold = 10, sigma = 1.2, mode = 1, opt = -1)
#KNLMeansCL(device_type="gpu", device_id=1)
#kenkunNRT(64,2,4)
#kenkunNR(64,2,4)
#FFT3DFilter(plane=3,bt=4,bw=3,bh=2,ow=1,oh=1,svr=0,interlaced=true)
#FFT3dGPU(sigma=2 ,beta=1 ,plane=1 ,bw=16 ,bh=16 ,ow=8 ,oh=8 ,bt=4 ,mode=0 ,interlaced=false ,wintype=0 )

#//--- オーディオフィルタ ---//
#KillAudio()	#音声消去
#DelayAudio (clip, float seconds)		#seconds 秒単位で遅らせる

#//--- その他のフィルタ ---//
#ColorBars (int "width", int "height", string "pixel_type")	#カラーバー
#Info(clip clip)	#クリップ情報
#ShowFrameNumber(true ,x=650, y=470)	#フレーム番号を表示
#ShowSMPTE()	#時間を表示
