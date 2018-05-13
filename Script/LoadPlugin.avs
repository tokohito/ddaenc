##### プラグイン読み込み #####
#//--- プラグインディレクトリ ---//
#PluginDir="%USERPROFILE%\opt\AviSynth\Filter"	#プラグインディレクトリ
#LoadPlugin(PluginDir + "warpsharp_2003_1103\warpsharp.dll")	#プラグインディレクトリ+プラグイン

#//--- warpsharpパッケージ ---//
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\warpsharp_20080325\VC09\warpsharp.dll")	#warpsharpパッケージseraphy氏修正版
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\aviutlyc_001\AviUtlYC.dll")	#warpsharp.dllのAviUtl内部形式変換関数の変換式修正版

#//--- 入力プラグイン ---//
LoadPlugin("%USERPROFILE%\usr\DGMPGDec\DGDecode.dll")	#MPEG2Source
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\L-SMASH_Works\LSMASHSource.dll")	#L-SMASH Works POP@4bit版
LoadAviUtlInputPlugin("%USERPROFILE%\opt\m2v_vfp\m2v.vfp", "MPEG2VIDEO")	#MPEG-2 VIDEO VFAPI Plug-In(AviUtl入力プラグイン)

#//--- デインターレース/逆テレシネ ---//
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\IT_YV12\IT_ICC.dll")	#IT_YV12 [2.5] [YUY2/YV12] [IT]
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\Its086\Its.dll")	#Its [2.5] [RGB24/RGB32/YUY2/YV12] [Its]
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\TIVTC\TIVTC.dll")	#TIVTC [2.5] [YUY2/YV12] [TDecimate他]
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\TDeint\TDeint.dll")	#TDeint [2.5] [YUY2/YV12] [TDeint(mode=1のときBob)]

#//--- フィルタ ---//
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\delogo_avisynth_004\delogo.dll")	#透過性ロゴ フィルタ for AviSynth 2.5
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\ColorYUY2_v0_17-3\ColorYUY2_for_25.dll")	#ColorYUY2 [2.5] [YUY2/YV12]
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\ColorMatrix\ColorMatrix.dll")	#ColorMatrix [2.5] [YUY2/YV12]
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\mt_masktools\mt_masktools.dll")	#mt_masktools（MaskTools v2） [2.5] [YV12]
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\VerticalCleaner\VerticalCleaner.dll")	#VerticalClearer [2.5] [YV12/Planar YUY2]
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\SmoothAdjust-v2.62\x86\SmoothAdjust.dll")	#SmoothAdjust [2.5] [YV12] [2.6] [YV12/Y8/YV411/YV16/YV24]
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\variableblur\variableblur.dll")	#VariableBlur [2.5] [YV12]
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\dup_20071120\Dup.dll")	#Dup [1.0/2.0] [YUY2] / [2.5] [YUY2/YV12]
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\edgelevel_avisynth\x86\edgelevel.dll")	#エッジレベル調整
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\KNLMeansCL\KNLMeansCL.dll")	#KNLMeansCL NL-means実装(GPU/CPU)

#//--- Avisynth 1.0/2.0フィルタの読み込み ---//
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\warpsharp_20080325\VC09\LoadPluginEx.dll")	#warpsharp 1.0/2.0用プラグイン読み込み
LoadPlugin("%USERPROFILE%\opt\AviSynth\Filter\acomb05\AntiComb.dll")	#AntiComb [1.0/2.0] [YUY2] [AntiComb]

#//--- 外部関数のインポート ---//
Import("%USERPROFILE%\opt\AviSynth\Script\EasyVFR3.avs")
Import("%USERPROFILE%\opt\AviSynth\Script\NL-Means filter.avs")
Import("%USERPROFILE%\opt\AviSynth\Script\deint_txt60mc_ho_vt.avsi")	# txt60mc
Import("%USERPROFILE%\opt\AviSynth\Script\Clean_SC.avsi")	#シーンチェンジのフレームを自動置換する関数です。 http://tyottoenc.blog.fc2.com/blog-entry-7.html ※YV12 Only
Import("%USERPROFILE%\opt\AviSynth\Script\deint_v3.13.avsi")	#BS/地デジ映像のシーンチェンジや激しく動く場面等、片フィールドに発生するノイズを除去する関数です。（逆テレシネ後に利用） http://tyottoenc.blog.fc2.com/blog-entry-9.html ※YV12 Only
Import("%USERPROFILE%\opt\AviSynth\Script\logo_ExtErsLOGO.avsi")	#半透過ロゴ除去の片フィールド対応関数(要YV12色空間)
