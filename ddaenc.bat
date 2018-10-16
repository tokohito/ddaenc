@echo off
setlocal

:start
rem #//--- バージョン情報 ---//
set release_version=3.4.8.181014

rem #//--- 各種出力先ディレクトリへのパス ---//

rem ### 作業用ディレクトリ(%work_dir%) ###
set work_dir=E:\avs temp\

rem ### テンポラリディレクトリ(%large_tmp_dir%) ###
rem # TsSplitter前の一時コピー先 / ts2aac&FAWのAAC出力 / 音声エンコーダーに渡す前のWAVなど
rem %large_tmp_dir%を環境変数で事前に設定

rem ### 最終出力ファイルを移動するフォルダへのパス ###
rem # ここのフォルダが何れも存在しない場合、ユーザーのホームフォルダに移動されます
set out_dir_1st=\\Servername\share\mp4 video\
set out_dir_2nd=D:\output video\

rem ### 連続実行用バッチファイルまでのパス ###
set encode_catalog_list=%USERPROFILE%\encode_catalog_list.txt

rem # エンコーダー選択
rem x264, x265, qsv_h264, qsv_hevc, nvenc_h264, nvenc_hevc
set video_encoder_type=x264


rem //--- x264 オプション ---//
rem --keyint及び二重引用符不要。

rem ### x264.exe へのpath ###
rem # 入手先
:   https://onedrive.live.com/?cid=6bdd4375ac8933c6&id=6BDD4375AC8933C6%214477&ithint=folder,&authkey=!ABzai4Ddn6_Xxd0
rem # vbv-maxrate/vbv-bufsize参考情報
:   http://www.up-cat.net/?page=x264(vbv-maxrate,vbv-bufsize,profile,level),%20H.264(Profile/Level)
rem # PSPはBフレームのピラミッド参照化に対応していないので、再選互換を確保する場合はオプションで無効化する事(--b-pyramid none)
rem # PSPはCABACしか対応していないので、無効化オプション(--no-cabac)は使用しないこと
:   http://nicowiki.com/%E6%8B%A1%E5%BC%B5%20x264%20%E5%87%BA%E5%8A%9B%EF%BC%88GUI%EF%BC%89%E3%81%AE%E8%A8%AD%E5%AE%9A%E9%A0%85%E7%9B%AE%E3%81%A8%E3%81%9D%E3%81%AE%E6%A9%9F%E8%83%BD%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6.html
rem # PSPはOpenGOPも非対応
:   http://pop.4-bit.jp/?p=4813
rem set x264_path=C:\bin\x264_r2851_8dpt_x86.exe
set x264_path=C:\bin\x264_r2901_8dpt_x64.exe

rem ### HighProfile@Level 4.2 オプション(VUI/fps optionsを除く) ###
set x264_HP@L42_option=--crf 22 --profile high --level 4.2 --ref 4 --bframes 3 --b-adapt 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --8x8dct --nal-hrd vbr --vbv-maxrate 62500 --vbv-bufsize 78125 --no-fast-pskip --qpstep 8

rem ### HighProfile@Level 4.0 オプション(VUI/fps optionsを除く) ###
rem set x264_HP@L40_option=--crf 21 --profile high --level 4 --sar 4:3 --ref 3 --bframes 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --8x8dct --nal-hrd vbr --vbv-maxrate 25000 --vbv-bufsize 31250 --no-fast-pskip --qpstep 8 --videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 --threads 4
set x264_HP@L40_option=--crf 22 --profile high --level 4 --ref 4 --bframes 3 --b-adapt 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --8x8dct --nal-hrd vbr --vbv-maxrate 25000 --vbv-bufsize 31250 --no-fast-pskip --qpstep 8

rem ### MainProfile@Level 3.2 オプション(VUI/fps optionsを除く) ###
set x264_MP@L32_option=--crf 22 --profile main --level 3.2 --ref 5 --bframes 3 --b-adapt 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --nal-hrd vbr --vbv-maxrate 20000 --vbv-bufsize 10000 --no-fast-pskip --qpstep 8

rem ### MainProfile@Level 3.1 オプション(VUI/fps optionsを除く) ###
set x264_MP@L31_option=--crf 22 --profile main --level 3.1 --ref 5 --bframes 3 --b-adapt 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --nal-hrd vbr --vbv-maxrate 14000 --vbv-bufsize 10000 --no-fast-pskip --qpstep 8

rem ### MainProfile@Level 3.0 オプション(VUI/fps optionsを除く) ###
set x264_MP@L30_option=--crf 22 --profile main --level 3 --ref 5 --bframes 3 --b-adapt 2 --b-pyramid none --cqm flat --subme 9 --me umh --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --nal-hrd vbr --vbv-maxrate 10000 --vbv-bufsize 10000 --no-fast-pskip --qpstep 8

rem ### MainProfile@Level 2.1 オプション(VUI/fps optionsを除く) ###
set x264_MP@L21_option=--crf 22 --profile main --level 21 --ref 3 --bframes 2 --b-pyramid none --cqm flat --subme 9 --me umh --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --nal-hrd vbr --vbv-maxrate 4000 --vbv-bufsize 4000 --no-fast-pskip --qpstep 8

rem ### インターレース保持エンコーディングをする場合のオプション ###
rem # Profile Level3
set x264_interlace_Lv3=--interlace --tff 
rem # Profile Level4
set x264_interlace_Lv4=--interlace --tff --weightp 0 


rem //--- x265 オプション ---//
rem ### x265.exe へのpath ###
rem # 入手先
:   https://onedrive.live.com/?authkey=%21AJWOVN55IpaFffo&id=6BDD4375AC8933C6%213306&cid=6BDD4375AC8933C6
set x265_path=C:\bin\x265_2.1+11_x64_pgo.exe

rem ### MainProfile@Level 4.1 (Main Tier)オプション(VUI/fps optionsを除く) ###
set x265_MP@L41_option=--crf 22 --profile main --level-idc 4.1 --preset slow --no-high-tier

rem ### MainProfile@Level 4.0 (Main Tier)オプション(VUI/fps optionsを除く) ###
set x265_MP@L40_option=--crf 22 --profile main --level-idc 4.0 --preset slow --no-high-tier

rem ### MainProfile@Level 3.1 (Main Tier)オプション(VUI/fps optionsを除く) ###
set x265_MP@L31_option=--crf 22 --profile main --level-idc 3.1 --preset slow --no-high-tier

rem ### MainProfile@Level 3.0 (Main Tier)オプション(VUI/fps optionsを除く) ###
set x265_MP@L30_option=--crf 22 --profile main --level-idc 3.0 --preset slow --no-high-tier


rem //--- QSVEncC オプション ---//
rem ### QSVEncC.exe へのpath ###
rem # 入手先
:   http://rigaya34589.blog135.fc2.com/blog-entry-337.html
set qsvencc_path=C:\app\QSVEnc\QSVEncC\x86\QSVEncC.exe

rem ### QSVEncC H.264/AVC HighProfile@Level 4.2 オプション(VUI/fps optionsを除く) ###
set qsv_h264_HP@L42_option=--y4m --profile Main --level 4.2 --cqp 24:26:27 

rem ### QSVEncC H.264/AVC HighProfile@Level 4.0 オプション(VUI/fps optionsを除く) ###
set qsv_h264_HP@L40_option=--y4m --profile Main --level 4.1 --cqp 24:26:27 

rem ### QSVEncC H.264/AVC MainProfile@Level 3.2 オプション(VUI/fps optionsを除く) ###
set qsv_h264_MP@L32_option=--y4m --profile Main --level 3.2 --cqp 24:26:27 

rem ### QSVEncC H.264/AVC MainProfile@Level 3.1 オプション(VUI/fps optionsを除く) ###
set qsv_h264_MP@L31_option=--y4m --profile Main --level 3.1 --cqp 24:26:27 

rem ### QSVEncC H.264/AVC MainProfile@Level 3.0 オプション(VUI/fps optionsを除く) ###
set qsv_h264_MP@L30_option=--y4m --profile Main --level 3 --cqp 24:26:27 

rem ### QSVEncC H.264/AVC MainProfile@Level 2.1 オプション(VUI/fps optionsを除く) ###
set qsv_h264_MP@L21_option=--y4m --profile Main --level 2.1 --cqp 24:26:27 


rem ### QSVEncC H.265/HEVC MainProfile@Level 4.1 (Main Tier)オプション(VUI/fps optionsを除く) ###
set qsv_hevc_MP@L41_option=--y4m --profile main --level 4.1 --cqp 24:26:27 

rem ### QSVEncC H.265/HEVC MainProfile@Level 4.0 (Main Tier)オプション(VUI/fps optionsを除く) ###
set qsv_hevc_MP@L40_option=--y4m --profile main --level 4.0 --cqp 24:26:27 

rem ### QSVEncC H.265/HEVC MainProfile@Level 3.1 (Main Tier)オプション(VUI/fps optionsを除く) ###
set qsv_hevc_MP@L31_option=--y4m --profile main --level 3.1 --cqp 24:26:27 

rem ### QSVEncC H.265/HEVC MainProfile@Level 3.0 (Main Tier)オプション(VUI/fps optionsを除く) ###
set qsv_hevc_MP@L30_option=--y4m --profile main --level 3 --cqp 24:26:27 


rem //--- NVEncC オプション ---//
rem ### NVEncC.exe へのpath ###
rem # 入手先
:   http://rigaya34589.blog135.fc2.com/blog-entry-739.html
set nvencc_path=C:\app\NVEnc\NVEncC\x86\NVEncC.exe

rem ### NVEncC H.264/AVC HighProfile@Level 4.2 オプション(VUI/fps optionsを除く) ###
set nvenc_h264_HP@L42_option=--y4m --profile Main --level 4.2 --cqp 20:23:25 

rem ### NVEncC H.264/AVC HighProfile@Level 4.0 オプション(VUI/fps optionsを除く) ###
set nvenc_h264_HP@L40_option=--y4m --profile Main --level 4.1 --cqp 20:23:25 

rem ### NVEncC H.264/AVC MainProfile@Level 3.2 オプション(VUI/fps optionsを除く) ###
set nvenc_h264_MP@L32_option=--y4m --profile Main --level 3.2 --cqp 20:23:25 

rem ### NVEncC H.264/AVC MainProfile@Level 3.1 オプション(VUI/fps optionsを除く) ###
set nvenc_h264_MP@L31_option=--y4m --profile Main --level 3.1 --cqp 20:23:25 

rem ### NVEncC H.264/AVC MainProfile@Level 3.0 オプション(VUI/fps optionsを除く) ###
set nvenc_h264_MP@L30_option=--y4m --profile Main --level 3 --cqp 20:23:25 

rem ### NVEncC H.264/AVC MainProfile@Level 2.1 オプション(VUI/fps optionsを除く) ###
set nvenc_h264_MP@L21_option=--y4m --profile Main --level 2.1 --cqp 20:23:25 


rem ### NVEncC H.265/HEVC MainProfile@Level 4.1 (Main Tier)オプション(VUI/fps optionsを除く) ###
set nvenc_hevc_MP@L41_option=--y4m --profile main --level 4.1 --cqp 20:23:25 

rem ### NVEncC H.265/HEVC MainProfile@Level 4.0 (Main Tier)オプション(VUI/fps optionsを除く) ###
set nvenc_hevc_MP@L40_option=--y4m --profile main --level 4.0 --cqp 20:23:25 

rem ### NVEncC H.265/HEVC MainProfile@Level 3.1 (Main Tier)オプション(VUI/fps optionsを除く) ###
set nvenc_hevc_MP@L31_option=--y4m --profile main --level 3.1 --cqp 20:23:25 

rem ### NVEncC H.265/HEVC MainProfile@Level 3.0 (Main Tier)オプション(VUI/fps optionsを除く) ###
set nvenc_hevc_MP@L30_option=--y4m --profile main --level 3 --cqp 20:23:25 


rem #//--- 各種スイッチ・パラメーター ---//

rem ### 作業開始前にソースファイルを一時ローカルフォルダにコピーする ###
rem # 0: ソースドライブのメディアタイプに依存。ローカルHDDの場合はコピーしない。
rem # 1: 一時コピー
set force_copy_src=0

rem ### 半透過ロゴ除去を抑止するかどうかのフラグ ###
rem # 0: 抑止しない(半透過ロゴ除去は実行されます)
rem # 1: 抑止する(半透過ロゴ除去は実行されません)
set disable_delogo=0

rem ### 自動CMカットを抑止するかどうかのフラグ(手動でTrimを反映した場合はそちらが優先されます) ###
rem # 0: 抑止しない(自動CMカットは実行されます)
rem # 1: 抑止する(自動CMカットは実行されません)
set disable_cmcutter=0

rem ### AVS スクリプトのプラグイン読み込み部分をインポートする ###
rem # 0: インポートせずに直接記述する
rem # 1: インポートする
set importloardpluguin_flag=1

rem ### AAC音声のオーディオゲインを指定したオフセット分アップする ###
rem # 0: ゲインアップしない
rem # 1～: ゲインアップする(整数値のみサポート)
set audio_gain=3

rem ### mp4ファイル出力後、ffmpegにてedtsを規格準拠に修正する ###
rem # 0: 修正しない
rem # 1: 修正する(Haali Media Splitter環境でズレ、及びQTのpar無視問題が発生する可能性があります)
set fix_edts_flag=0

rem ### ASS形式の字幕を出力するかどうかの選択 ###
rem # 0: 出力しない
rem # 1: 出力する
set output_ass_flag=1

rem ### MPEG2 デコーダーの選択 ###
rem ※DGIndex未実装
rem # 1: MPEG-2 VIDEO VFAPI Plug-In を使用。
rem # 2: DGMPGDEC を使用。
rem # 3: L-SMASH Works を使用。
set mpeg2dec_select_flag=3

rem # 大型ファイルのコピーに使用するアプリケーション選択
rem copy(Default), fac(FastCopy), ffc(FireFileCopy)
set copy_app_flag=fac

rem ### .NetFramework を有効にするかどうか ###
rem # 0: 使用しない
rem # 1: 使用する
set use_NetFramework_switch=1

rem ### エコー表示の長い&バッファクリアをするアプリケーションの為に、標準出力を許可するかどうか ###
rem # 0:出力する
rem # 1:出力しない
set kill_longecho_flag=1


rem //--- 実行ファイル系パス ---//

rem #//--- DGIndex 関係 ---//
rem ### DGIndex（DGMPGDEC）のあるフォルダのパス###
rem # mpeg2dec_select_flag=2 の場合に必要。
set dgindex_path="C:\app\DGMPGDec\DGIndex.exe"

rem ### DGIndex のオプション(ノーマル) ###
rem # 指定しない場合、デフォルトと DGIndex.ini の設定が使われる。二重引用符不要。
rem # オプションの書式は Unix-Style Command-Line Interface に則って記載すること
rem # 詳しくは DGIndexManual.html#AppendixC を参照。
set dgindex_options_normal=-ia 4 -of 2 -om 1 -yr 1 -hide -exit

rem ### DGIndex のオプション(TBS/フジテレビ/MXTV) ###
rem # 指定しない場合、デフォルトと DGIndex.ini の設定が使われる。二重引用符不要。
set fuji_dgindex_options=-ia 4 -of 2 -om 1 -yr 1 -ap 112 -vp 111 -hide -exit

rem ### DGIndex のオプション(NHK総合/教育) ###
rem # 指定しない場合、デフォルトと DGIndex.ini の設定が使われる。二重引用符不要。
set kyouiku_dgindex_options=-ia 4 -of 2 -om 1 -yr 1 -ap 110 -vp 100 -hide -exit

rem # FireFilecopy へのパス
set ffc_path=C:\app\FireFileCopy\FFC.exe

rem # FastCopy へのパス
set fac_path=C:\Program Files\FastCopy\fastcopy.exe

rem ### MPEG-2 VIDEO VFAPI Plug-In（m2v.vfp） のパス###
rem # mpeg2dec_select_flag=1 の場合に必要。
set m2v_vfp_path=C:\app\m2v_vfp\m2v.vfp

rem ### avs4x26x.exe へのpath ###
set avs4x26x_path=C:\bin\avs4x26x.exe

rem ### TsSplitter へのパス###
set TsSplitter_path=C:\app\TsSplitter\TsSplitter.exe

rem ### FakeAacWave へのパス ###
set FAW_path=C:\app\FakeAacWav\fawcl.exe

rem ### ts2aac へのパス ###
rem ※ts2aacは原則としてMPEG2 VFAPI Plug-Inかつビデオの先頭非closed GOPでなければ正常に機能しない, ts_parserの使用を推奨
set ts2aac_path=C:\app\ts2aac\ts2aac.exe

rem ### ts_parser へのパス ###
rem ※使用するMPEG-2デコーダーに応じて --delay-type オプションを変更する, ソースTSにDropがある場合のみts2aacの使用を推奨
set ts_parser_path=C:\bin\ts_parser.exe

rem ### faad へのパス ###
set faad_path=C:\bin\faad.exe

rem ### avs2wav へのパス ###
rem set avs2wav_path=C:\bin\avs2wav.exe
rem http://www.ku6.jp/keyword19/1.html
set avs2wav_path=C:\bin\avs2wav32.exe

rem ### avs2pipe(mod) へのパス ###
set avs2pipe_path=C:\bin\avs2pipemod.exe

rem ### logoframe へのパス ###
set logoframe_path=C:\app\logoframe\logoframe.exe

rem ### chapter_exe へのパス ###
set chapter_exe_path=C:\app\chapter_exe\chapter_exe.exe

rem ### chapter_exe のオプションパラメーター ###
set chapter_exe_option=-s 8 -e 4

rem ### join_logo_scp へのパス ###
set join_logo_scp_path=C:\app\join_logo_scp\join_logo_scp.exe

rem ### AutoVfr へのパス ###
set autovfr_path=C:\bin\AutoVfr.exe

rem ### AutoVfr.ini へのパス(存在しない場合、AutoVfr.exeと同じフォルダを探索) ###
set autovfrini_path=C:\bin\AutoVfr.ini

rem ### AutoVfrのオプションパラメーター(Auto_VfrとAuto_Vfr_Fast共通、Auto_Vfr固有のオプションはFastでは無視) ###
set autovfr_setting=cthresh=80, mi=60, blockx=16, blocky=32, chroma=false, IsCrop=true, crop_height=920

rem ### ext_bs へのパス ###
set ext_bs_path=C:\bin\ext_bs.exe

rem ### muxer.exe(L-SMASH) へのパス ###
set muxer_path=C:\bin\muxer.exe

rem ### remuxer.exe(L-SMASH) へのパス ###
set remuxer_path=C:\bin\remuxer.exe

rem ### timelineeditor.exe(L-SMASH) へのパス ###
set timelineeditor_path=C:\bin\timelineeditor.exe

rem ### mp4box へのパス ### ※削除予定
rem # 音声ストリームのdisableオプションのため、要version 0.4.5以降
set mp4box_path=C:\Program Files\GPAC\mp4box.exe

rem ### mp4chaps へのパス ### ※削除予定
set mp4chaps_path=C:\bin\mp4chaps.exe

rem ### DtsEdit へのパス ###
rem # QT再生互換の為に必要
set DtsEdit_path=C:\bin\DtsEdit.exe

rem ### sox へのパス ###
set sox_path=C:\app\sox-14.2.0\sox.exe

rem ### neroAacEnc へのパス ###
set neroAacEnc_path=C:\bin\neroAacEnc.exe

rem ### aacgain へのパス ###
set aacgain_path=C:\bin\aacgain.exe

rem ### ffmpeg へのパス ###
set ffmpeg_path=C:\bin\ffmpeg.exe

rem ### Comskip へのパス ###
set comskip_path=C:\app\Comskip\comskip.exe

rem ### comskip.ini へのパス ###
set comskipini_path=C:\app\Comskip\comskip.ini

rem ### caption2Ass(_mod) へのパス ###
set caption2Ass_path=C:\app\Caption2Ass_mod1\Caption2Ass_mod1.exe

rem ### SrtSync へのパス ###
rem # 要.NET Framework 3.5
set SrtSync_path=C:\bin\SrtSync.exe

rem ### nkf(文字コード変更ツール) へのパス ###
set nkf_path=C:\bin\nkf.exe

rem ### sed(onigsed) へパス ###
set sed_path=C:\bin\onigsed.exe

rem ### sedスクリプト へのパス ###
set sedscript_path=C:\app\Caption2Ass_mod1\Gaiji\ARIB2Unicode.txt

rem ### tsrenamec へのパス ###
set tsrenamec_path=C:\bin\tsrenamec.exe

rem ### AtomicParsley へのパス ###
set AtomicParsley_path=C:\bin\AtomicParsley.exe

rem ### KeyIn.VB.NET へのパス ###
rem http://www.vector.co.jp/soft/winnt/util/se461954.html
rem # .NET Framework 3.5 が必要。KeyInを使うかどうかは%use_NetFramework_switch%で指定
set KeyIn_path=C:\bin\KeyIn.exe

rem ### MediaInfo CLI へのパス ###
set MediaInfoC_path=C:\app\MediaInfo_CLI\MediaInfo.exe


rem //--- 各種テンプレートへのパス ---//

rem ### ロゴファイル(.lgd)のソースフォルダを指定 ###
set lgd_file_src_path=C:\app\AviSynth\lgd

rem ### カット処理方法スクリプト(JL)のソースフォルダを指定 ###
set JL_src_dir=C:\app\AviSynth\JL

rem ### デフォルトで使用するカット処理方法スクリプト(JL)のファイル名を指定 ###
set JL_file_name=JL_標準.txt

rem ### メイン処理用のAVSテンプレートファイル
set avs_main_template=C:\app\AviSynth\Script\MainAVStemplate_01-default.avs

rem ### プラグイン読み込みテンプレートのパス ###
set plugin_template=C:\app\AviSynth\Script\LoadPlugin.avs

rem ### AutoVfr テンプレートのパス ###
set autovfr_template=C:\app\AviSynth\Script\Auto_Vfr.avs

rem ### AutoVfr_Fast テンプレートのパス ###
set autovfr_fast_template=C:\app\AviSynth\Script\Auto_Vfr_Fast.avs

rem ### AutoVfr の逆テレシネを手動/自動どちらでやるか設定します ###
rem # 0: 手動 / 1: 自動
set autovfr_deint=1

rem ### def ファイルへパス ###
set def_itvfr_file=C:\app\AviSynth\Script\foo.def

rem #--- 初期設定終わり ---

rem ### ※ 注意 ###
rem 本来ifやfor文中でsetコマンドを使う場合に、入力されたファイルパスに()が含まれていると
rem 即時環境変数のため誤動作の原因になる。通常こういった場合遅延環境変数を用いるが
rem ファイルパスのに!が含まれる場合もあるのでこの方法は望ましくない。
rem 仕方ないのでcallコマンドを使い、サブルーチンとしてifやfor文に含まれないラベルまで
rem ジャンプする手法でこの問題を回避している。そのため非常にコードが肥大化かつ複雑化・・・
rem その際単純にラベルをcallしただけだとファイル名が継承されないので、call先でも
rem バッチファイルへD&Dしたファイル名を使用したい場合 call :ラベル名 "%~1" と記述すること。

rem # bat をダブルクリックならヘルプメッセージを表示
if "%~1"=="" (
    rem # ラベル:help_messageへ移動
    goto :help_message
)

rem # 環境変数クリーンナップ
set already_avs_detect_flag=
set bat_mode=
if not "%JL_src_dir:~-1%"=="\" set JL_src_dir=%JL_src_dir%\
if not "%lgd_file_src_path:~-1%"=="\" set lgd_file_src_path=%lgd_file_src_path%\

rem # ユーザー選択で指定するパラメーターをデフォルト値にセットする
rem #^(バッチ外でセットされた環境変数があると誤動作するので、あらかじめオーバーライド^)
if not exist "%work_dir%" (
    set work_dir=%HOMEDRIVE%%HOMEPATH%
)
if not exist "%out_dir_1st%" (
    set work_dir=%HOMEDRIVE%%HOMEPATH%
)
set audio_job_flag=faw
set bat_vresize_flag=none
set bat_lgd_file_path=
set JL_src_file_full-path=%JL_src_dir%%JL_file_name%
set JL_custom_flag=
set deinterlace_filter_flag=Its
set autovfr_mode=^0
set tssplitter_opt_param=
set crop_size_flag=none

echo ### 初期設定終了 ###
echo [%time%]

:bat_option_detect_phase
rem # 一番親の引数変数がshiftするように、shiftはcall先で実行しない事
if "%~1"=="-b" (
    set bat_mode=1
    shift /1
) else if "%~1"=="--bat-mode" (
    set bat_mode=1
    shift /1
) else if "%~1"=="-w" (
    set bat_mode=1
    call :bat_workdir_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="--work" (
    set bat_mode=1
    call :bat_workdir_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="-o" (
    set bat_mode=1
    call :bat_out_dir_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="--output" (
    set bat_mode=1
    call :bat_out_dir_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="-e" (
    set bat_mode=1
    call :bat_vencoder_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="--encoder" (
    set bat_mode=1
    call :bat_vencoder_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="-q" (
    set bat_mode=1
    call :bat_crf_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="--crf" (
    set bat_mode=1
    call :bat_crf_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="-m" (
    set bat_mode=1
    call :bat_mpeg2dec_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="--mpeg2-dec" (
    set bat_mode=1
    call :bat_mpeg2dec_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="-a" (
    set bat_mode=1
    call :bat_aencoder_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="--audio-job" (
    set bat_mode=1
    call :bat_aencoder_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="-r" (
    set bat_mode=1
    call :bat_vresize_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="--resize" (
    set bat_mode=1
    call :bat_vresize_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="-z" (
    set bat_mode=1
    call :bat_vresize_algo "%~2"
    shift /1
    shift /1
) else if "%~1"=="--resize-algo" (
    set bat_mode=1
    call :bat_vresize_algo "%~2"
    shift /1
    shift /1
) else if "%~1"=="-t" (
    set bat_mode=1
    call :bat_avstemplate_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="--template" (
    set bat_mode=1
    call :bat_avstemplate_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="-l" (
    set bat_mode=1
    echo バッチ処理モード分類
    call :bat_Logofile_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="--lgd-file" (
    set bat_mode=1
    call :bat_Logofile_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="-j" (
    set bat_mode=1
    call :bat_JLtemplate_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="--jl-file" (
    set bat_mode=1
    call :bat_JLtemplate_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="-f" (
    set bat_mode=1
    call :bat_JLflag_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="--jl-flag" (
    set bat_mode=1
    call :bat_JLflag_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="-d" (
    set bat_mode=1
    call :bat_deintfilter_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="--deint" (
    set bat_mode=1
    call :bat_deintfilter_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="-v" (
    set bat_mode=1
    call :bat_autovfr_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="--vfr" (
    set bat_mode=1
    call :bat_autovfr_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="-i" (
    set bat_mode=1
    call :bat_vfrini_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="--vfr-ini" (
    set bat_mode=1
    call :bat_vfrini_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="-s" (
    set bat_mode=1
    call :bat_tssplitter_options_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="--splitter" (
    set bat_mode=1
    call :bat_tssplitter_options_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="-c" (
    set bat_mode=1
    call :bat_cropsize_detect "%~2"
    shift /1
    shift /1
) else if "%~1"=="--crop" (
    set bat_mode=1
    call :bat_cropsize_detect "%~2"
    shift /1
    shift /1
)
rem # バッチモードパラメーターに不正な値が含まれていた場合、強制終了
if "%exit_stat%"=="1" (
    exit /b
)

rem # 第一引数の先頭文字が-の場合、オプションとみなして再帰実行する
set fast_param=%~1
if "%fast_param:~0,1%"=="-" (
    goto :bat_option_detect_phase
)

:error_check
rem # ソースファイルとコピー先のディレクトリが同一の場合エラー
if "%~dp1"=="%large_tmp_dir%" (
    rem # エラーメッセージの設定
    set error_message=ソースファイルのディレクトリとコピー先のディレクトリが同じです。
    rem # ラベルerrorへ移動
    goto :error
)
rem # AVS作業用ディレクトリとテンポラリ用ディレクトリが同一の場合エラー
if "%work_dir%"=="%large_tmp_dir%" (
    rem # エラーメッセージの設定
    set error_message=AVS作業用ディレクトリとTSテンポラリ用ディレクトリが同じです。
    rem # ラベルerrorへ移動
    goto :error
)
rem # work_dir が存在しない場合エラー
if not exist "%work_dir%" (
    rem # エラーメッセージの設定
    set error_message=AVS を出力するフォルダのパスが間違っています。
    rem # ラベルerrorへ移動
    goto :error
)
rem # avs_main_template が存在しない場合エラー
if not exist "%avs_main_template%" (
    rem # エラーメッセージの設定
    set error_message=AVSのメインテンプレートが存在しませんｎ。
    rem # ラベルerrorへ移動
    goto :error
)
if "%large_tmp_dir%"=="" (
    echo ※注意※
    echo 大きめの一時ファイルを作成する%%large_tmp_dir%%環境変数が未定義です。
    echo エンコードを実行する前にシステム設定を済ませてください。
)
echo.

if "%bat_mode%"=="1" (
    echo バッチモード変数確認
    echo プロジェクト作業フォルダ："%work_dir%"
    echo 出力フォルダ："%out_dir_1st%"
    echo エンコーダー："%video_encoder_type%"
    echo CRF："%crf_value%"
    echo MPEG2デコーダー："%mpeg2dec_select_flag%"
    echo オーディオ："%audio_job_flag%"
    echo リサイズ："%bat_vresize_flag%"
    echo AVSテンプレート："%avs_main_template%"
    echo ロゴファイル："%bat_lgd_file_path%"
    echo JLファイル："%JL_src_file_full-path%"
    echo JLフラグ："%JL_custom_flag%"
    echo デインターレース方式："%deinterlace_filter_flag%"
    echo AutoVfr方式："%autovfr_mode%"
    echo TsSplitter："%tssplitter_opt_param%"
    echo Crop指定："%crop_size_flag%"
)

:folder_end_checker
rem # ディレクトリ末尾に"\"を追加する調整
if not "%work_dir:~-1%"=="\" set work_dir=%work_dir%\


rem ### 関数設定開始

rem =============== メイン擬似関数開始 ===============
:main_function
rem ### 擬似main関数、ここから各擬似関数を呼び出す。初期設定で定められた条件の制御はなるべくここで行う

:check_filetype
if "%~x1"==".ts" (
    echo 入力ファイル："%~1"
) else if "%~x1"==".m2ts" (
    echo 入力ファイル："%~1"
) else if "%~x1"==".mpg" (
    echo 入力ファイル："%~1"
) else if "%~x1"==".mpeg" (
    echo 入力ファイル："%~1"
) else if "%~x1"==".m2p" (
    echo 入力ファイル："%~1"
) else if "%~x1"==".mpv" (
    echo 入力ファイル："%~1"
) else if "%~x1"==".m2v" (
    echo 入力ファイル："%~1"
) else if "%~x1"==".dv" (
    echo 入力ファイル："%~1"
) else if "%~x1"==".avs" (
    echo 入力ファイル："%~1"
) else if "%~x1"==".d2v" (
    echo 現状、拡張子が.d2vの読み込みに対応していません。本体を指定してください
    set mpeg2dec_select_flag=2
    goto :parameter_shift
) else (
    echo.
    echo 非対応拡張子
    goto :parameter_shift
)
echo.
echo ### 作業開始時刻 ###
echo [%time%]
echo.

rem ### ソースファイルへのフルパス^(src_file_path^)を環境変数に書き込む.。後でパラメーターファイルにも書き込む。
set src_file_path=%~1

rem ### ソースとするファイルへのパス、通常は入力されたファイル ###
set input_media_path=%~1

rem ### AVSファイルの名前、通常は入力されたファイルと同等 ###
set avs_project_name=%~n1

rem ### ディレクトリ名 main_project_name と、ファイル名 avs_project_name を決定する関数
rem # 入力がavsファイルの場合、コピー元とコピー先のディレクトリ名とファイル名を一致させる
rem ### avsファイルのあるディレクトリをコピーする擬似関数
rem # 入力がavsの場合、最初にavsファイルがあるディレクトリのさらに上位のディレクトリまでのパスを得る
if "%~x1"==".avs" (
    call :get_upperdir_path "%~dp1."
)
rem # フォルダの名前、初期値で設定した値(通常は入力ファイルと同名)
rem # if文中でsetコマンドを使う場合、与えられる文字列中に)があると誤作動するためcallでサブルーチン化
if "%~x1"==".avs" (
    call :avs_projectname_detect "%~1"
) else (
    call :other_projectname_detect "%~1"
)
rem # 作成するフォルダの末尾に半角スペースがあると不味いのでそのチェック
:space_blank_checker
if "%main_project_name:~-1%"==" " (
    call :space_blank_del
    goto :space_blank_checker
)
rem # 同名のAVSファイルが既に存在するかどうかのチェック
if exist "%work_dir%%main_project_name%\main.avs" (
    rem # 最初はここはcallを使っていたが、そうするとサブルーチンから帰ってきてその直後にラベル:space_blank_checkerへ
    rem # gotoすると変数%avs_project_name%がなぜか引き継がれないのでこうしてラベル:over_write_selectへもgotoする
    rem goto :over_write_select
    rem call :over_write_select "%~1"
    rem echo 第一関門
    goto :over_write_select
) else (
    echo メインネーム:"%main_project_name%"
    if "%main_project_name%"=="" (
        :name_blank_checker
        echo ※ 注意 ※
        echo ファイル名を空白にすることは出来ません
        if "%use_NetFramework_switch%"=="1" (
            call :Type_KeyIn
            goto :name_blank_checker
        ) else (
            call :noType_KeyIn
            goto :name_blank_checker
        )
    )
)
rem # 既存ファイル上書きの場合のジャンプのためのラベル
:esc_checkexist_avsfile
rem # 入力がavsの場合の処理。対象avsファイルがあるディレクトリを丸々コピー(除くソースファイル)
rem # ただし移動元と移動先のディレクトリが同一の場合コピーしない
if "%~x1"==".avs" (
    call :copy_avssrc_dir "%~1"
)
rem # 作業用サブディレクトリを作成する
call :make_project_dir "%~1"
rem # MediaInfo CLIで入力されたメディアの情報を出力する
call :MediaInfoC_phase "%~1"
if "%bat_mode%"=="1" (
    rem # バッチモードで未決定事項確定ルーチン
    call :bat_video_resolution_detect
) else (
    rem # 各ユーザー設定を決定する項目
    call :manual_job_settings "%~1"
    call :deinterlace_filter_selector
    call :video_job_selector
    call :vfr_rate_selecter
    call :audio_job_selector
)
call :sub_video_encodebatfile_detec
call :sub_audio_editbatfile_detec
call :sub_d2vgenbatfile_detec
call :sub_copybatfile_detec
rem 字幕ファイル操作用バッチファイルパスを設定
call :sub_srteditfile_detec
rem トラックmux用バッチファイルパスを設定
call :sub_muxtracksfile_detec
rem 一時ファイル削除用バッチファイルパスを設定
call :sub_deltmpfile_detec
rem # Trim情報の整形
call :sub_trimlinefile_detec

rem # メインバッチファイルを作成する
call :make_main_bat "%~1"
rem # ソースファイルコピー、その他事前準備用バッチファイルを作成する
call :copy_source_phase "%~1"
rem # .d2vファイル作成
rem call :make_d2vfile_phase "%input_media_path%"
rem Trim編集用バッチ内容作成
call :make_trimline_phase
rem ロゴ処理および自動CMカット関連バッチ内容作成
call :make_logoframe_phase
rem join_logo_scpの出力結果からチャプターファイルを自動生成するcscriptを生成, 「join_logo_scp試行環境」から拝借
call :make_chapter_jls_phase
rem AutoVfr用バッチおよび設定ファイル作成
call :make_autovfr_phase
rem # ロゴファイル(.lgd)のコピーフェーズ
call :copy_lgd_file_phase "%~1"
rem # カット処理方法スクリプト(JL)のコピーフェーズ
call :copy_JL_file_phase "%~1"
rem # AVSファイルを作成する、入力ファイルが.avsの場合はスキップ
if "%~x1"==".avs" (
    rem # 入力がavsの場合新規にavsファイルは作成しない
) else (
    rem # avsファイル作成
    rem エンコードメイン処理用のAVSファイルをテンプレートファイルから生成
    call :avs_template_main_phase
    rem # 出力解像度を表示
    echo 有効解像度: ^(Width:%resize_wpix%, Height:%resize_hpix%^)
    rem # Its用.defファイルのコピー
    echo Its defファイル："%def_itvfr_file%"
    copy "%def_itvfr_file%" "%work_dir%%main_project_name%\avs\main.def"> nul
    copy "%def_itvfr_file%" "%work_dir%%main_project_name%\main.def"> nul
    rem # 各種音源を読み込んでから、Trim編集後のオーディオストリームを出力するためのavsファイル作成
    rem # プレビュー(周期確認用)avsファイル作成
    call :make_previewfile_phase "%~1"
    rem # プラグイン読み込みフィルタ作成
    call :make_previewplugin_phase "%~1"
    rem # プレビュー用AVSファイル作成
    if "%~x1"==".dv" (
        rem 未実装
    ) else (
        call :load_mpeg2ts_preview "%~1"
    )
    rem # トップフィールド/ボトムフィールド指定
    call :avs_interlacebefore_privew "%~1"
    rem # Trim情報以下、プレビュー用フィルタ定義
    call :preview_setting_filter "%~1"
    rem # 編集＆解析用avsファイル出力^(音声付き^)
    call :edit_analyze_filter "%~1">> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
    rem # 半透過ロゴ除去関数avsファイル出力^(空ファイル^)
    call :eraselogo_filter> "%work_dir%%main_project_name%\avs\EraseLogo.avs"
)
rem # ビデオエンコード設定
call :Video_Encoding_phase "%~1"
rem # 音声処理(avs2wav～FakeAacWav/neroAacEnc～mp4creator60)
echo.
echo ### 音声処理 ###
call :audio_Encoding_select "%~1"
rem # デジタル放送の字幕抽出(Caption2Ass_mod1~SrtSync/"[外:"チェック)
if not "%~x1"==".dv" (
    call :srt_edit "%~1"
)
rem # 映像音声その他の合成(L-SMASH)、および出力先ディレクトリへの移動
call :mux_option_selector
rem # 作業用のソースファイルおよび不要な一時ファイルの削除
echo rem # 作業用のソースファイルおよび不要な一時ファイルの削除フェーズ>> "%main_bat_file%"
call :del_tmp_files
rem # パラメーターファイル作成
call :make_parameterfile_phase "%src_file_path%"
rem # 終了時間記述
call :last_order "%~1"
echo %main_bat_file%>> "%encode_catalog_list%"
goto :parameter_shift
rem =============== メイン擬似関数終了 ===============

rem # 各種変数設定
rem ---------- ここから ----------
rem めんどくさいのでd2vからはサブファイル名固定
:sub_d2vgenbatfile_detec
set d2vgen_batfile_path=%work_dir%%main_project_name%\bat\DGMPGDec_prjct.bat
exit /b
:sub_video_encodebatfile_detec
set video_encode_batfile_path=%work_dir%%main_project_name%\bat\video_encode.bat
exit /b
:sub_audio_editbatfile_detec
set audio_edit_batfile_path=%work_dir%%main_project_name%\bat\audio_edit.bat
exit /b
:sub_copybatfile_detec
set copysrc_batfile_path=%work_dir%%main_project_name%\bat\copy_src.bat
exit /b
:sub_trimlinefile_detec
set trimchars_batfile_path=%work_dir%%main_project_name%\bat\trim_chars.bat
exit /b
:sub_srteditfile_detec
set srtedit_batfile_path=%work_dir%%main_project_name%\bat\srt_edit.bat
exit /b
:sub_muxtracksfile_detec
set muxtracks_batfile_path=%work_dir%%main_project_name%\bat\mux_tracks.bat
exit /b
:sub_deltmpfile_detec
set deltmp_batfile_path=%work_dir%%main_project_name%\bat\del_tmp.bat
exit /b
rem ---------- ここまで ----------

:bat_workdir_detect
rem # バッチモードでのプロジェクト作業フォルダ指定
if exist "%~1" (
    set work_dir=%~1
) else (
    set error_message=Directory not exist! : %~1
    goto :error
)
exit /b

:bat_out_dir_detect
rem # 最終出力先ディレクトリの絶対パス指定
if exist "%~1" (
    set out_dir_1st=%~1
) else (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b

:bat_vencoder_detect
rem # バッチモードでのビデオエンコーダー指定
if "%~1"=="x264" (
    set video_encoder_type=x264
) else if "%~1"=="x265" (
    set video_encoder_type=x265
) else if "%~1"=="qsv_h264" (
    set video_encoder_type=qsv_h264
) else if "%~1"=="qsv_hevc" (
    set video_encoder_type=qsv_hevc
) else if "%~1"=="nvenc_h264" (
    set video_encoder_type=nvenc_h264
) else if "%~1"=="nvenc_hevc" (
    set video_encoder_type=nvenc_hevc
) else (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b

:bat_crf_detect
rem # バッチモードでのビデオエンコーダーCRF値の指定
if %~1 GEQ 0 (
    if %~1 LEQ 51 (
        set crf_value=%~1
    )
) else (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b

:bat_mpeg2dec_detect
rem # バッチモードでのMPEG2デコーダーの指定
if "%~1"=="1" (
    set mpeg2dec_select_flag=1
) else if "%~1"=="2" (
    set mpeg2dec_select_flag=2
) else if "%~1"=="3" (
    set mpeg2dec_select_flag=3
) else (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b

:bat_aencoder_detect
rem # バッチモードでのオーディオ処理の指定
if "%~1"=="faw" (
    set audio_job_flag=faw
) else if "%~1"=="sox" (
    set audio_job_flag=sox
) else if "%~1"=="nero" (
    set audio_job_flag=nero
) else (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b

:bat_vresize_detect
rem # バッチモードでの画面解像度リサイズの指定
if "%~1"=="none" (
    set bat_vresize_flag=none
) else if "%~1"=="1080" (
    set bat_vresize_flag=1080
) else if "%~1"=="900" (
    set bat_vresize_flag=900
) else if "%~1"=="810" (
    set bat_vresize_flag=810
) else if "%~1"=="720" (
    set bat_vresize_flag=720
) else if "%~1"=="540" (
    set bat_vresize_flag=540
) else if "%~1"=="480" (
    set bat_vresize_flag=480
) else if "%~1"=="272" (
    set bat_vresize_flag=270
) else if "%~1"=="270" (
    set bat_vresize_flag=270
) else (
    call :bat_vresize_calc "%~1"
)
exit /b

:bat_vresize_calc
set /a tmp_vresize_flag=%~1/1
if %tmp_vresize_flag% EQU %~1 (
    set bat_vresize_flag=custom
    set /a resize_wpix=%~1*16/9
    set /a resize_hpix=%~1
) else (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b

:bat_vresize_algo
rem # バッチモードでのリサイズアルゴリズムの指定
if "%~1"=="bilinear" (
    set resize_algo_flag=bilinear
) else if "%~1"=="bicubic" (
    set resize_algo_flag=bicubic
) else if "%~1"=="lanczos4" (
    set resize_algo_flag=lanczos4
) else if "%~1"=="spline16" (
    set resize_algo_flag=spline16
) else if "%~1"=="spline32" (
    set resize_algo_flag=spline32
) else if "%~1"=="spline64" (
    set resize_algo_flag=spline64
) else if "%~1"=="dither" (
    set resize_algo_flag=dither
) else (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b

:bat_avstemplate_detect
rem # バッチモードでのAVSテンプレートファイルの指定
if exist "%~1" (
    call :set_avstemplate_file_full-path "%~1"
) else (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b

:set_avstemplate_file_full-path
rem # バッチモードで指定したAVSテンプレートファイルへのフルパスを変数へ格納します
set avs_main_template=%~1
exit /b

:bat_Logofile_detect
rem # バッチモードでのロゴファイル(.lgd)の指定
if exist "%~1" (
    call :set_lgd_file_full-path "%~1"
) else (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b

:set_lgd_file_full-path
rem # バッチモードで指定したロゴファイルへのフルパスを変数へ格納します
set bat_lgd_file_path=%~1
exit /b

:bat_JLtemplate_detect
rem # JLファイルの指定
if exist "%~1" (
    call :set_JLtemplate_file_full-path "%~1"
) else (
    set error_message=Do not exist "%~1" !
    goto :error
)
exit /b

:set_JLtemplate_file_full-path
rem # バッチモードで指定したJLテンプレートファイルへのフルパスを変数へ格納します
set JL_src_file_full-path=%~1
exit /b

:bat_deintfilter_detect
rem # デインターレース方式の指定
if "%~1"=="its" (
    set deinterlace_filter_flag=Its
) else if "%~1"=="24fps" (
    set deinterlace_filter_flag=24fps
) else if "%~1"=="30fps" (
    set deinterlace_filter_flag=30fps
) else if "%~1"=="itvfr" (
    set deinterlace_filter_flag=itvfr
) else if "%~1"=="bob" (
    set deinterlace_filter_flag=bob
) else if "%~1"=="interlace" (
    set deinterlace_filter_flag=interlace
) else (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b

:bat_JLflag_detect
rem # JLフラグ指定
set JL_custom_flag=%~1
exit /b

rem # JLフラグ指定
set JL_custom_flag=%~1
exit /b

:bat_autovfr_detect
rem # AutoVfr方式の指定
if "%~1"=="normal" (
    set autovfr_mode=0
) else if "%~1"=="fast" (
    set autovfr_mode=1
) else (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b

:bat_vfrini_detect
rem # AutoVfr.ini へのフルパスを変数へ格納します
if exist "%~1" (
    call :set_autovfrini_file_full-path "%~1"
) else (
    set error_message=Do not exist "%~1" !
    goto :error
)
exit /b

:set_autovfrini_file_full-path
rem # バッチモードで指定したAutoVfr.iniファイルへのフルパスを変数へ格納します
set autovfrini_path=%~1
exit /b

:bat_tssplitter_options_detect
rem # TsSplitterのオプションを変数へ格納します
set tssplitter_opt_param=%~1
if "%tssplitter_opt_param%"=="" (
    set error_message=The value of the -s option can not be found !
    goto :error
) else if not "%tssplitter_opt_param:~0,1%"=="-" (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b


:bat_cropsize_detect
rem # 黒帯等の表示外領域のCrop指定
if "%~1"=="none" (
    set crop_size_flag=none
) else if "%~1"=="sidecut" (
    set crop_size_flag=sidecut
) else if "%~1"=="gakubuchi" (
    set crop_size_flag=gakubuchi
) else (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b


:make_parameterfile_phase
rem # 実行直前に参照するパラメーターファイルを作成
rem # オプションの並び次第では最後の1文字がリダイレクト表記と解釈されてしまうので対策
if not "%src_filesize%"=="" (
    set src_filesize=%src_filesize:~0,-1%^^%src_filesize:~-1%
)
if not "%video_encoder_type%"=="" (
    set video_encoder_type=%video_encoder_type:~0,-1%^^%video_encoder_type:~-1%
)
if not "%x264_enc_param%"=="" (
    set x264_enc_param=%x264_enc_param:~0,-1%^^%x264_enc_param:~-1%
)
if not "%x265_enc_param%"=="" (
    set x265_enc_param=%x265_enc_param:~0,-1%^^%x265_enc_param:~-1%
)
if not "%qsv_h264_enc_param%"=="" (
    set qsv_h264_enc_param=%qsv_h264_enc_param:~0,-1%^^%qsv_h264_enc_param:~-1%
)
if not "%qsv_hevc_enc_param%"=="" (
    set qsv_hevc_enc_param=%qsv_hevc_enc_param:~0,-1%^^%qsv_hevc_enc_param:~-1%
)
if not "%nvenc_h264_enc_param%"=="" (
    set nvenc_h264_enc_param=%nvenc_h264_enc_param:~0,-1%^^%nvenc_h264_enc_param:~-1%
)
if not "%nvenc_hevc_enc_param%"=="" (
    set nvenc_hevc_enc_param=%nvenc_hevc_enc_param:~0,-1%^^%nvenc_hevc_enc_param:~-1%
)
if not "%audio_gain%"=="" (
    set audio_gain=%audio_gain:~0,-1%^^%audio_gain:~-1%
)
if not "%tssplitter_opt_param%"=="" (
    set tssplitter_opt_param=%tssplitter_opt_param:~0,-1%^^%tssplitter_opt_param:~-1%
)
if not "%autovfr_thread_num%"=="" (
    set autovfr_thread_num=%autovfr_thread_num:~0,-1%^^%autovfr_thread_num:~-1%
)
if not "%autovfr_setting%"=="" (
    set autovfr_setting=%autovfr_setting:~0,-1%^^%autovfr_setting:~-1%
)
if not "%chapter_exe_option%"=="" (
    set chapter_exe_option=%chapter_exe_option:~0,-1%^^%chapter_exe_option:~-1%
)
echo # //--- parameter file ---//> "%work_dir%%main_project_name%\parameter.txt"
echo # release version>> "%work_dir%%main_project_name%\parameter.txt"
echo release_version=%release_version%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # Source file full-path>> "%work_dir%%main_project_name%\parameter.txt"
echo src_file_path=%~1>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # Prject name>> "%work_dir%%main_project_name%\parameter.txt"
echo project_name=%main_project_name%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # Source file size^(byte^)>> "%work_dir%%main_project_name%\parameter.txt"
echo src_filesize=%~z1>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # Video encoder type[x264^(Default^), x265, qsv_h264^(QSVEncC H.264/AVC^), qsv_hevc^(QSVEncC H.265/HEVC^), nvenc_h264^(NVEncC H.264/AVC^), nvenc_hevc^(NVEncC H.265/HEVC^)]>> "%work_dir%%main_project_name%\parameter.txt"
echo video_encoder_type=%video_encoder_type%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # x264 encode parameter>> "%work_dir%%main_project_name%\parameter.txt"
echo x264_enc_param=%x264_Encode_option% %video_sar_option%%x264_VUI_opt%%x264_keyint%%x264_interlace_option%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # x265 encode parameter>> "%work_dir%%main_project_name%\parameter.txt"
echo x265_enc_param=%x265_Encode_option% %video_sar_option%%x265_VUI_opt%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # QSVEncC H.264/AVC^(qsv_h264^) encode parameter>> "%work_dir%%main_project_name%\parameter.txt"
echo qsv_h264_enc_param=%qsv_h264_Encode_option% %video_sar_option%%qsv_VUI_opt%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # QSVEncC H.265/HEVC^(qsv_hevc^) encode parameter>> "%work_dir%%main_project_name%\parameter.txt"
echo qsv_hevc_enc_param=%qsv_hevc_Encode_option% %video_sar_option%%qsv_VUI_opt%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # NVEncC H.264/AVC^(nvenc_h264^) encode parameter>> "%work_dir%%main_project_name%\parameter.txt"
echo nvenc_h264_enc_param=%nvenc_h264_Encode_option% %video_sar_option%%nvenc_VUI_opt%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # NVEncC H.265/HEVC^(nvenc_hevc^) encode parameter>> "%work_dir%%main_project_name%\parameter.txt"
echo nvenc_hevc_enc_param=%nvenc_hevc_Encode_option% %video_sar_option%%nvenc_VUI_opt%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # MPEG-2 decoder parameter[1: MPEG-2 VIDEO VFAPI Plug-In^(Default^), 2: DGMPGDEC, 3: L-SMASH Works]>> "%work_dir%%main_project_name%\parameter.txt"
echo mpeg2dec_select_flag=^%mpeg2dec_select_flag%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # Audio edit mode[faw^(Default^), sox, nero]>> "%work_dir%%main_project_name%\parameter.txt"
echo audio_job_flag=%audio_job_flag%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # Audio Gain parameter[int]>> "%work_dir%%main_project_name%\parameter.txt"
echo audio_gain=%audio_gain%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # Audio Language parameter[str1,str2...^(ISO 639-2/T language code format^)]>> "%work_dir%%main_project_name%\parameter.txt"
echo audio_lang_param=jpn,eng>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # TsSplitter option parameter [-EIT] [-ECM] [-EMM] [-BUFF size] [-HD] [-SD] [-SDx] [-1SEG]>> "%work_dir%%main_project_name%\parameter.txt"
echo tssplitter_opt_param=%tssplitter_opt_param%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # AutoVFR mode select[0=Auto_Vfr] [1=Auto_Vfr_Fast]>> "%work_dir%%main_project_name%\parameter.txt"
echo autovfr_mode=^%autovfr_mode%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # AutoVFR deinterlace type select[0=manual_deint] [1=auto_deint^(Default^)]>> "%work_dir%%main_project_name%\parameter.txt"
echo autovfr_deint=^%autovfr_deint%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # AutoVFR thread number[If it is empty, substitute the number of logical CPUs]>> "%work_dir%%main_project_name%\parameter.txt"
echo autovfr_thread_num=%autovfr_thread_num%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # AutoVFR option paramater[null]>> "%work_dir%%main_project_name%\parameter.txt"
echo autovfr_setting=%autovfr_setting%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # Deinterlacing mode[24fps^(Default^), 30fps, Its, itvfr, bob, interlace]>> "%work_dir%%main_project_name%\parameter.txt"
echo deinterlace_filter_flag=%deinterlace_filter_flag%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # Copy application select[copy^(Default^), fac^(FastCopy^), ffc^(FireFileCopy^)]>> "%work_dir%%main_project_name%\parameter.txt"
echo copy_app_flag=%copy_app_flag%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # Disable delogo filter flag[0=not Disable^(Default^)] [1=Disable]>> "%work_dir%%main_project_name%\parameter.txt"
echo disable_delogo=^%disable_delogo%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # Force copy source file flag[0=Copy if the location is a network folder^(Default^)] [1=Force copy]>> "%work_dir%%main_project_name%\parameter.txt"
echo force_copy_src=^%force_copy_src%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # Auto CM cut application select[comskip]>> "%work_dir%%main_project_name%\parameter.txt"
echo cm_cutter_flag=%cm_cutter_flag%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # Disable auto CM cutter flag[0=not Disable^(Default^)] [1=Disable]>> "%work_dir%%main_project_name%\parameter.txt"
echo disable_cmcutter=^%disable_cmcutter%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # Output file directory>> "%work_dir%%main_project_name%\parameter.txt"
echo out_dir_1st=%out_dir_1st%>> "%work_dir%%main_project_name%\parameter.txt"
echo out_dir_2nd=%out_dir_2nd%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # Logo file ^(.lgd^) name>> "%work_dir%%main_project_name%\parameter.txt"
echo lgd_file_name=%lgd_file_name%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # auto CM cut config file ^(JL^) name>> "%work_dir%%main_project_name%\parameter.txt"
echo JL_file_name=%JL_file_name%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # JL file custom flag>> "%work_dir%%main_project_name%\parameter.txt"
echo JL_custom_flag=%JL_custom_flag%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # chapter_exe option parameter>> "%work_dir%%main_project_name%\parameter.txt"
echo chapter_exe_option=%chapter_exe_option%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
exit /b

:make_trimline_phase
rem # 整形した結果の文字列が空だった場合は何もしない
echo rem # Trim文字列の整形フェーズ>>"%main_bat_file%"
echo call ".\bat\trim_chars.bat">>"%main_bat_file%"
echo.>>"%main_bat_file%"
type nul > "%work_dir%%main_project_name%\trim_chars.txt"
type nul > "%trimchars_batfile_path%"
rem ------------------------------
(
echo @echo off
echo setlocal
echo echo start %%~nx0 bat job...
echo chdir /d %%~dp0..\
echo.
echo rem # エンコードツールをまとめたディレクトリを示す環境変数ENCTOOLSROOTPATHが定義されているか確認
echo call :toolsdircheck
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出
echo call :project_name_check
echo.
echo rem # 各種実行ファイルはWindows標準コマンド群のみ。
echo.
echo :main
echo rem //----- main開始 -----//
echo title %%project_name%%
echo echo Trim情報を整形しています. . .[%%date%% %%time%%]
echo if not exist "trim_line.txt" ^(
echo     echo ### 一行で表記するTrimコマンドはここに記入してください ###^> "trim_line.txt"
echo ^)
echo if not exist "trim_multi.txt" ^(
echo     echo ### 複数行で表記するTrimコマンドはここに記入してください ###^> "trim_multi.txt"
echo ^)
echo set trim_detect=
echo rem # "trim_line.txt"から単一行を抽出^(改行がある場合単一行にまとめる^)
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%Q in ^(`findstr /r Trim^^^(.*^^^) "trim_line.txt"`^) do ^(
echo     call :trim_line_join "%%%%Q"
echo ^)
echo rem # "trim_line.txt"から有効な文字列が抽出できた場合、\文字を削除したうえで内容を"trim_chars.txt"へコピーする
echo if not "%%trim_detect%%"=="" ^(
echo     call :trim_line_parser
echo     call :trimchar_export
echo ^)
echo rem # "trim_multi.txt"から複数行抽出
echo if not "%%trim_detect:~0,4%%"=="Trim" ^(
echo     call :conv_multi2char
echo ^)
echo rem # "main.avs"からTrim行^(単一／複数^)を抽出
echo if not "%%trim_detect:~0,4%%"=="Trim" ^(
echo     call :conv_mainline2char
echo ^)
echo rem # "preview1_straight.avs"からTrim行^(単一／複数^)を抽出
echo if not "%%trim_detect:~0,4%%"=="Trim" ^(
echo     call :conv_prev1line2char
echo ^)
echo rem # Trim行が検出されれば処理終了
echo if "%%trim_detect:~0,4%%"=="Trim" ^(
echo     call :show_trim_chars
echo ^) else ^(
echo     call echo Trimは検出されませんでした。
echo ^)
echo rem # 文字列抽出終了
echo title コマンド プロンプト
echo rem //----- main終了 -----//
echo echo end %%~nx0 bat job...
echo echo.
echo exit /b
echo.
rem ------------------------------
echo :trim_line_join
echo echo "trim_line.txt"で検出：%%~^1
echo set trim_detect=%%trim_detect%%%%~^1
echo exit /b
echo.
rem ------------------------------
echo :trim_line_parser
echo set trim_detect=%%trim_detect:\=%%
echo set trim_detect=%%trim_detect: =%%
echo exit /b
echo.
rem ------------------------------
echo :toolsdircheck
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 環境変数 ENCTOOLSROOTPATH が未定義です
echo     exit /b
echo ^)
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\
echo if exist "%%ENCTOOLSROOTPATH%%" ^(
echo     exit /b
echo ^) else ^(
echo     echo 環境変数ENCTOOLSROOTPATHが有効なパスではありません
echo     set ENCTOOLSROOTPATH=
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :conv_multi2char
echo set trim_detect=
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%S in ^(`findstr /r Trim^^^(.*^^^) "trim_multi.txt"`^) do ^(
echo     call :trimchar_searching "%%%%S"
echo ^)
echo set trim_detect=%%trim_detect:~0,-2%%
echo if "%%trim_detect:~0,4%%"=="Trim" ^(
echo     echo "trim_multi.txt"からTrim情報を抽出します
echo     call :trimchar_export
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :conv_mainline2char
echo set main_count=^0
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%R in ^(`findstr /b /r Trim^^^(.*^^^) "main.avs"`^) do ^(
echo     set trim_detect=%%%%R
echo     set /a main_count=main_count+^1
echo ^)
echo if "%%main_count%%"=="0" ^(
echo     echo "main.avs"でTrim行は検出されませんでした
echo ^) else if "%%main_count%%"=="1" ^(
echo     echo "main.avs"で最初に検出されたTrim行を使用します
echo     call :trimchar_export
echo ^) else ^(
echo     call :conv_mainmulti2char
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :conv_mainmulti2char
echo set trim_detect=
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%T in ^(`findstr /r Trim^^^(.*^^^) "main.avs"`^) do ^(
echo     call :trimchar_searching "%%%%T"
echo ^)
echo set trim_detect=%%trim_detect:~0,-2%%
echo if "%%trim_detect:~0,4%%"=="Trim" ^(
echo     echo "main.avs"に複数行のTrimが検出されました
echo     call :trimchar_export
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :conv_prev1line2char
echo set prev1_count=^0
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%U in ^(`findstr /b /r Trim^^^(.*^^^) "preview1_straight.avs"`^) do ^(
echo     set trim_detect=%%%%U
echo     set /a prev1_count=prev1_count+^1
echo ^)
echo if "%%prev1_count%%"=="0" ^(
echo     echo "preview1_straight.avs"でTrim行は検出されませんでした
echo ^) else if "%%prev1_count%%"=="1" ^(
echo     echo "preview1_straight.avs"で最初に検出されたTrim行を使用します
echo     call :trimchar_export
echo ^) else ^(
echo     call :conv_prev1multi2char
echo ^)
echo if not "%%prev1_count%%"=="0" ^(
echo     if "%%main_count%%"=="0" ^(
echo         echo "main.avs"にTrim行が検出されなかった為、代わりに"preview1_straight.avs"の内容を"trim_line.txt"へTrim行をコピーします
echo         call :trimchar_export2
echo     ^)
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :conv_prev1multi2char
echo set trim_detect=
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%V in ^(`findstr /r Trim^^^(.*^^^) "preview1_straight.avs"`^) do ^(
echo     call :trimchar_searching "%%%%V"
echo ^)
echo set trim_detect=%%trim_detect:~0,-2%%
echo if "%%trim_detect:~0,4%%"=="Trim" ^(
echo     echo "preview1_straight.avs"に複数行のTrimが検出されました
echo     call :trimchar_export
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :trimchar_searching
echo set fname=%%~1
echo set n=^0
echo set e=^0
echo :loop
echo call set c=%%%%fname:~%%n%%,1%%%%
echo call set trim_search=%%%%fname:~0,%%n%%%%%%
echo if "%%trim_search:~-5%%"=="Trim(" ^(
echo     set e=%%n%%
echo ^)
echo set /a n=n+^1
echo if "%%c%%"=="" exit /b
echo if "%%c%%"==")"  ^(
echo     if not "%%e%%"=="0"  ^(
echo         goto :break
echo     ^)
echo ^)
echo goto :loop
echo :break
echo set /a d=%%n%%-%%e%%
echo call set trim_detect=%%trim_detect%%Trim^(%%%%fname:~%%e%%,%%d%%%%%%++
echo exit /b
echo.
rem ------------------------------
echo :trimchar_export
echo echo # ソースに対してのTrim反映分抽出^> "trim_chars.txt"
echo echo %%trim_detect%%^> "trim_chars.txt"
echo exit /b
echo.
rem ------------------------------
echo :trimchar_export2
echo echo # copy from "preview1_straight.avs"^>^> "trim_line.txt"
echo echo %%trim_detect%%^>^> "trim_line.txt"
echo exit /b
echo.
rem ------------------------------
echo :show_trim_chars
echo echo Trim情報：%%trim_detect%%
echo exit /b
rem ------------------------------
echo :project_name_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(
echo     set %%%%P
echo ^)
echo exit /b
echo.
)>> "%trimchars_batfile_path%"
rem ------------------------------
exit /b


:make_logoframe_phase
rem # logoframe, chapter_exe, join_logo_scpを併用した半透過ロゴの消去や自動CMカットの処理を作成します
rem mainバッチへの登録作業
echo rem # 半透過ロゴ＆自動CMカット解析フェーズ>>"%main_bat_file%"
echo call ".\bat\logoframe_chapter_scan.bat">>"%main_bat_file%"
echo.>>"%main_bat_file%"
type nul > "%work_dir%%main_project_name%\avs\Auto_Vfr.avs"
rem サブルーチンバッチの登録作業
rem ------------------------------
(
echo @echo off
echo setlocal
echo echo start %%~nx0 bat job...
echo chdir /d %%~dp0..\
echo.
echo rem # エンコードツールをまとめたディレクトリを示す環境変数ENCTOOLSROOTPATHが定義されているか確認
echo call :toolsdircheck
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出
echo call :project_name_check
echo rem # parameterファイル中の透過性ロゴフィルタ無効化パラメーター^(disable_delogo^)を検出
echo call :disable_delogo_status_check
echo rem # parameterファイル中の自動CMカット無効化パラメーター^(disable_cmcutter^)を検出
echo call :disable_cmcutter_status_check
echo rem # parameterファイル中のlgdファイル名を検出
echo call :lgd_file_name_check
echo rem # parameterファイル中のJLファイル名を検出
echo call :JL_file_name_check
echo rem # parameterファイル中のJLフラグを検出
echo call :JL_custom_flag_check
echo rem # parameterファイル中のchapter_exeオプションパラメーターを検出
echo call :chapter_exe_option_check
echo rem # 各AVSファイルの中から有効なTrim行が含まれていないか検出
echo call :total_trim_line_check
echo rem # EraseLogo.avs のファイルサイズを検出
echo call :eraselogo_avs_filesize_check ".\avs\EraseLogo.avs"
echo.
echo rem # 各実行ファイルが存在するか確認。存在しない場合ENCTOOLSROOTPATH内部を探索する、もしくはシステムの探索パスに委ねる
echo if exist "%logoframe_path%" ^(set logoframe_path=%logoframe_path%^) else ^(call :find_logoframe "%logoframe_path%"^)
echo if exist "%chapter_exe_path%" ^(set chapter_exe_path=%chapter_exe_path%^) else ^(call :find_chapter_exe "%chapter_exe_path%"^)
echo if exist "%join_logo_scp_path%" ^(set join_logo_scp_path=%join_logo_scp_path%^) else ^(call :find_join_logo_scp "%join_logo_scp_path%"^)
echo.
echo rem # 各種実行ファイルへのパスが、最終的にどのような値になったか確認。
echo echo logoframe    : %%logoframe_path%%
echo echo chapter_exe  : %%chapter_exe_path%%
echo echo join_logo_scp: %%join_logo_scp_path%%
echo.
echo :main
echo rem //----- main開始 -----//
echo title %%project_name%%
echo echo ロゴとCMカットに関する処理工程を実行します. . .[%%date%% %%time%%]
echo rem # logoframe実行のサブルーチン呼び出し
echo call :logoframe_subroutine
echo if "%%trim_line_counter%%"=="0" ^(
echo     rem # chapter_exe実行のサブルーチン呼び出し
echo     call :chapter_exe_subroutine
echo     rem # join_logo_scp実行のサブルーチン呼び出し
echo     call :join_logo_scp_subroutine
echo ^) else ^(
echo     echo Trimが既に挿入されています、自動CMカットは必要ありません
echo ^)
echo rem # チャプターファイルを自動生成
echo call :make_chapfile_subroutine
echo title コマンド プロンプト
echo rem //----- main終了 -----//
echo echo end %%~nx0 bat job...
echo echo.
echo exit /b
echo.
rem ------------------------------
echo :logoframe_subroutine
echo pushd avs
echo if not exist "%%lgd_file_path%%" ^(
echo     echo .lgd ファイルが検出できません。処理を続けることが出来ない為、logoframeの処理を中断します。
echo     popd
echo     exit /b
echo ^)
echo popd
echo rem # logoframeを実行するためのサブルーチンです
echo if not exist ".\log\logoframe_log.txt" ^(
echo     echo logoframe_log.txtが存在しません
echo     if "%%eraselogo_avs_filesize%%"=="0" ^(
echo         echo EraseLogo.avsに有効な値が挿入されていません。
echo         if not "%%disable_delogo%%"=="1" ^(
echo             echo 半透過ロゴ処理は有効です
echo             echo logoframeを実行します^^^(avs+log^^^)...[%%date%% %%time%%]
echo             call :run_logoframe_all
echo         ^) else ^(
echo             echo 半透過ロゴ処理は無効です
echo             if not "%%trim_line_counter%%"=="0" ^(
echo                 echo Trimが既に挿入されています、logoframeは実行しません
echo             ^) else ^(
echo                 if not "%%disable_cmcutter%%"=="1" ^(
echo                     echo 自動CMカットは有効です、logoframeを実行します^^^(log^^^)...[%%date%% %%time%%]
echo                     call :run_logoframe_log
echo                 ^) else ^(
echo                     echo 自動CMカットは無効です、logoframeは実行しません
echo                 ^)
echo             ^)
echo         ^)
echo     ^) else ^(
echo         echo EraseLogo.avsは有効です、半透過ロゴが処理されます。
echo         if not "%%trim_line_counter%%"=="0" ^(
echo             echo Trimが既に挿入されています、logoframeは実行しません
echo         ^) else ^(
echo             if not "%%disable_cmcutter%%"=="1" ^(
echo                 echo 自動CMカットは有効です、logoframeを実行します^^^(log^^^)...[%%date%% %%time%%]
echo                 call :run_logoframe_log
echo             ^) else ^(
echo                 echo 自動CMカットは無効です、logoframeは実行しません
echo             ^)
echo         ^)
echo     ^)
echo ^) else ^(
echo     echo logoframe_log.txtが存在しています
echo     if "%%eraselogo_avs_filesize%%"=="0" ^(
echo         echo EraseLogo.avsに有効な値が挿入されていません。
echo         if not "%%disable_delogo%%"=="1" ^(
echo             echo 半透過ロゴ処理は有効です、logoframeを実行します^^^(avs+log※logoframe_log.txtは上書きされます^^^)...[%%date%% %%time%%]
echo             call :run_logoframe_all
echo         ^) else ^(
echo             echo 半透過ロゴ処理は無効です、logoframeは実行しません
echo         ^)
echo     ^) else ^(
echo         echo EraseLogo.avsは有効です、半透過ロゴが処理されます。logoframe 処理は不要の為、スキップします。
echo     ^)
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :run_logoframe_all
echo rem # EraseLogo.avs に上位の相対パスを記入するために、一時的に作業フォルダ移動^(logのみ作成の場合、本来は不要^)
echo pushd avs
echo "%%logoframe_path%%" -outform 1 ".\edit_analyze.avs" -logo "%%lgd_file_path%%" -oa "..\log\logoframe_log.txt" -o ".\EraseLogo.avs"
echo popd
echo exit /b
echo.
rem ------------------------------
echo :run_logoframe_log
echo rem # EraseLogo.avs に上位の相対パスを記入するために、一時的に作業フォルダ移動^(logのみ作成の場合、本来は不要^)
echo pushd avs
echo "%%logoframe_path%%" -outform 1 ".\edit_analyze.avs" -logo "%%lgd_file_path%%" -oa "..\log\logoframe_log.txt"
echo popd
echo exit /b
echo.
rem ------------------------------
echo :chapter_exe_subroutine
echo pushd avs
echo if not exist "%%lgd_file_path%%" ^(
echo     echo .lgd ファイルが検出できません。処理を続けることが出来ない為、chapter_exeの処理を中断します。
echo     popd
echo     exit /b
echo ^)
echo popd
echo if not "%%disable_cmcutter%%"=="1" ^(
echo     echo 自動CMカットは有効です、chapter_exeを実行します...[%%date%% %%time%%]
echo     call :run_chapter_exe_log
echo ^) else ^(
echo     echo 自動CMカットは無効です、chapter_exeは実行しません
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :run_chapter_exe_log
echo "%%chapter_exe_path%%" -v ".\avs\edit_analyze.avs" %%chapter_exe_option%%-o ".\log\chapter_exe_log.txt"
echo exit /b
echo.
rem ------------------------------
echo :join_logo_scp_subroutine
echo rem # comskipのルーチンを後で引き継ぐこと
echo if not exist "%%JL_file_path%%" ^(
echo     echo JL ファイルが検出できません。処理を続けることが出来ない為、join_logo_scpの処理を中断します。
echo     exit /b
echo ^)
echo if not exist ".\log\logoframe_log.txt" ^(
echo     echo logoframe_log.txt が見つかりません、join_logo_scp を中断します
echo ^) else if not exist ".\log\chapter_exe_log.txt" ^(
echo     echo chapter_exe_log.txt が見つかりません、join_logo_scp を中断します
echo ^) else ^(
echo     if not "%%disable_cmcutter%%"=="1" ^(
echo         echo 自動CMカットは有効です、join_logo_scpを実行します...[%%date%% %%time%%]
echo         call :run_join_logo_scp_log
echo     ^) else ^(
echo         echo 自動CMカットは無効です、join_logo_scpは実行しません
echo     ^)
echo ^)
echo rem # trim_chars.txt に有効なTrim行が含まれていないか最終チェック、含まれていなければjoin_logo_scpの出力結果をマージする
echo set trim_chars_txt_counter=^0
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%T in ^(`findstr /R Trim^^^(.*^^^) "trim_chars.txt"`^) do ^(
echo     set /a trim_chars_txt_counter=trim_chars_txt_counter+^1
echo ^)
echo if not "%%trim_chars_txt_counter%%"=="0" ^(
echo     echo trim_chars.txt には既に有効なTrimが含まれています、クリアしてから join_logo_scp の出力結果をマージします
echo     echo # ソースに対してのTrim反映分抽出^> "trim_chars.txt"
echo ^) else ^(
echo     echo join_logo_scp の出力結果を、trim_chars.txt にマージします
echo ^)
echo if not exist ".\tmp\join_logo_scp_out.txt" ^(
echo     echo join_logo_scp_out.txt が見つかりません、マージをスキップします
echo ^) else ^(
echo     echo # join_logo_scp generated.^>^> ".\trim_chars.txt"
echo     copy /b ".\trim_chars.txt" + ".\tmp\join_logo_scp_out.txt" ".\trim_chars.txt"
echo     rem # main.avs/trim_line.txt/trim_multi.txt に有効なTrim行が含まれていない場合も、join_logo_scpの出力結果をマージする
echo     if "%%trim_line_counter%%"=="0" ^(
echo         echo join_logo_scp の出力結果を、trim_line.txt にマージします
echo         echo # join_logo_scp generated.^>^> ".\trim_line.txt"
echo         copy /b ".\trim_line.txt" + ".\tmp\join_logo_scp_out.txt" ".\trim_line.txt"
echo     ^)
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :run_join_logo_scp_log
echo echo "%%join_logo_scp_path%%" -inlogo ".\log\logoframe_log.txt" -inscp ".\log\chapter_exe_log.txt" -incmd "%%JL_file_path%%" %%JL_custom_flag_param%%-o ".\tmp\join_logo_scp_out.txt" -oscp ".\log\obs_jlscp.txt"
echo "%%join_logo_scp_path%%" -inlogo ".\log\logoframe_log.txt" -inscp ".\log\chapter_exe_log.txt" -incmd "%%JL_file_path%%" %%JL_custom_flag_param%%-o ".\tmp\join_logo_scp_out.txt" -oscp ".\log\obs_jlscp.txt"
echo exit /b
echo.
rem ------------------------------
echo :make_chapfile_subroutine
echo if not exist "*.chapter.txt" ^(
echo     if not exist "*.chapters.txt" ^(
echo         if exist ".\tmp\join_logo_scp_out.txt" ^(
echo             if exist ".\log\obs_jlscp.txt" ^(
echo                 echo join_logo_scpの出力ログを用いてチャプターファイルを自動生成します
echo                 echo cscript //nologo ".\bat\func_chapter_jls.vbs" cut ".\tmp\join_logo_scp_out.txt" ".\log\obs_jlscp.txt"
echo                 cscript //nologo ".\bat\func_chapter_jls.vbs" cut ".\tmp\join_logo_scp_out.txt" ".\log\obs_jlscp.txt"^> ".\obs_jlscp.chapter.txt"
echo             ^)
echo         ^)
echo     ^) else ^(
echo         echo チャプターファイルが既に存在するため、自動生成は実施しません
echo     ^)
echo ^) else ^(
echo     echo チャプターファイルが既に存在するため、自動生成は実施しません
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :total_trim_line_check
echo rem # 有効なTrim行が含まれていないかチェック、含まれていた場合既に編集済みと判断し後続の処理をスキップする
echo set trim_line_counter=^0
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%T in ^(`findstr /r Trim^^^(.*^^^) "main.avs"`^) do ^(
echo     set /a trim_line_counter=trim_line_counter+^1
echo ^)
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%T in ^(`findstr /r Trim^^^(.*^^^) "trim_line.txt"`^) do ^(
echo     set /a trim_line_counter=trim_line_counter+^1
echo ^)
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%T in ^(`findstr /r Trim^^^(.*^^^) "trim_multi.txt"`^) do ^(
echo     set /a trim_line_counter=trim_line_counter+^1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :eraselogo_avs_filesize_check
echo if not exist ".\avs\EraseLogo.avs" ^(
echo     type nul^> ".\avs\EraseLogo.avs"
echo ^)
echo set eraselogo_avs_filesize=%%~z1
echo echo EraseLogo.avs ファイルサイズ：%%eraselogo_avs_filesize%%
echo exit /b
echo.
rem ------------------------------
echo :toolsdircheck
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 環境変数 ENCTOOLSROOTPATH が未定義です
echo     exit /b
echo ^)
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\
echo if exist "%%ENCTOOLSROOTPATH%%" ^(
echo     exit /b
echo ^) else ^(
echo     echo 環境変数ENCTOOLSROOTPATHが有効なパスではありません
echo     set ENCTOOLSROOTPATH=
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :project_name_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(
echo     set %%%%P
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :disable_delogo_status_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%L in ^(`findstr /b /r disable_delogo "parameter.txt"`^) do ^(
echo     set %%%%L
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :disable_cmcutter_status_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%C in ^(`findstr /b /r disable_cmcutter "parameter.txt"`^) do ^(
echo     set %%%%C
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :lgd_file_name_check
echo set lgd_file_path=
echo for /f "usebackq eol=# tokens=1 delims=" %%%%G in ^(`findstr /b /r lgd_file_name "parameter.txt"`^) do ^(
echo     set %%%%G
echo ^)
echo if "%%lgd_file_name%%"=="" ^(
echo     echo .lgd ファイル名が空です
echo ^) else ^(
echo     call :lgd_file_path_set
echo ^)
echo exit /b
echo :lgd_file_path_set
echo set lgd_file_path=..\lgd\%%lgd_file_name%%
echo exit /b
echo.
rem ------------------------------
echo :JL_file_name_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%J in ^(`findstr /b /r JL_file_name "parameter.txt"`^) do ^(
echo     set %%%%J
echo ^)
echo if "%%JL_file_name%%"=="" ^(
echo     echo JL ファイル名が空です
echo ^) else ^(
echo     call :JL_file_path_set
echo ^)
echo exit /b
echo :JL_file_path_set
echo set JL_file_path=.\JL\%%JL_file_name%%
echo exit /b
echo.
rem ------------------------------
echo :JL_custom_flag_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%F in ^(`findstr /b /r JL_custom_flag "parameter.txt"`^) do ^(
echo     set %%%%F
echo ^)
echo if "%%JL_custom_flag%%"=="" ^(
echo     echo JLフラグは未設定です
echo ^) else ^(
echo     call :JL_custom_flag_set
echo ^)
echo exit /b
echo :JL_custom_flag_set
echo set JL_custom_flag_param=-flags "%%JL_custom_flag%%" 
echo exit /b
echo.
rem ------------------------------
echo :chapter_exe_option_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%H in ^(`findstr /b /r chapter_exe_option "parameter.txt"`^) do ^(
echo     set %%%%H
echo ^)
echo if not "%%chapter_exe_option%%"=="" ^(
echo     call :chapter_exe_option_set
echo ^)
echo exit /b
echo :chapter_exe_option_set
echo if not "%%chapter_exe_option:~-1%%"==" " set chapter_exe_option=%%chapter_exe_option%% 
echo exit /b
echo.
rem ------------------------------
echo :find_logoframe
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set logoframe_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :logoframe_env_search "%%~nx1"
echo exit /b
echo :logoframe_env_search
echo set logoframe_path=%%~$PATH:1
echo if "%%logoframe_path%%"=="" ^(
echo     echo logoframeが見つかりません
echo     set logoframe_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_chapter_exe
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set chapter_exe_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :chapter_exe_env_search "%%~nx1"
echo exit /b
echo :chapter_exe_env_search
echo set chapter_exe_path=%%~$PATH:1
echo if "%%chapter_exe_path%%"=="" ^(
echo     echo chapter_exeが見つかりません
echo     set chapter_exe_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_join_logo_scp
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set join_logo_scp_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :join_logo_scp_env_search "%%~nx1"
echo exit /b
echo :join_logo_scp_env_search
echo set join_logo_scp_path=%%~$PATH:1
echo if "%%join_logo_scp_path%%"=="" ^(
echo     echo join_logo_scpが見つかりません
echo     set join_logo_scp_path=%%~1
echo ^)
echo exit /b
echo.
)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
rem ------------------------------
exit /b


:make_chapter_jls_phase
rem ------------------------------
(
echo ' Trimファイルとjoin_logo_scp構成解析ファイルからチャプターを標準出力に出力
echo ' 引数１：（入力）出力チャプター形式（org cut tvtplay tvtcut）
echo ' 引数２：（入力）Trimファイル名
echo ' 引数３：（入力）join_logo_scp構成解析ファイル名
echo.
echo Option Explicit
echo.
echo '--------------------------------------------------
echo ' 定数
echo '--------------------------------------------------
echo const PREFIX_TVTI = "ix"     ' カット開始時文字列（tvtplay用）
echo const PREFIX_TVTO = "ox"     ' カット終了時文字列（tvtplay用）
echo const PREFIX_ORGI = ""       ' カット開始時文字列（カットなしchapter）
echo const PREFIX_ORGO = ""       ' カット終了時文字列（カットなしchapter）
echo const PREFIX_CUTO = ""       ' カット終了時文字列（カット後）
echo const SUFFIX_CUTO = ""       ' カット終了時末尾追加文字列（カット後）
echo.
echo const MODE_ORG = 0
echo const MODE_CUT = 1
echo const MODE_TVT = 2
echo const MODE_TVC = 3
echo.
echo const MSEC_DIVMIN = 100      ' チャプター位置を同一としない時間間隔（msec単位）
echo.
echo '--------------------------------------------------
echo ' 引数読み込み
echo '--------------------------------------------------
echo Dim strFormat, strFile1, strFile2
echo Dim nOutFormat
echo.
echo If WScript.Arguments.Unnamed.Count ^< 3 Then
echo   WScript.StdErr.WriteLine "usage:func_chapter_jls.vbs org|cut|tvtplay <TrimFile> <jlsFile>"
echo   WScript.Quit
echo End If
echo.
echo strFormat = WScript.Arguments^(0^)
echo strFile1  = WScript.Arguments^(1^)
echo strFile2  = WScript.Arguments^(2^)
echo.
echo '--- 出力形式 ---
echo If StrComp^(strFormat, "cut"^) = 0 Then           'カット後のchapter
echo   nOutFormat = MODE_CUT
echo ElseIf StrComp^(strFormat, "tvtplay"^) = 0 Then   'カットしないTvtPlay
echo   nOutFormat = MODE_TVT
echo ElseIf StrComp^(strFormat, "tvtcut"^) = 0 Then    'カット後のTvtPlay
echo   nOutFormat = MODE_TVC
echo Else                                            'カットしないchapter
echo   nOutFormat = MODE_ORG
echo End If
echo.
echo '--------------------------------------------------
echo ' Trimによるカット情報読み込み
echo ' 読み込みデータ。開始位置を表すため終了位置では＋１する。
echo ' nTrimTotal  : Trim位置情報合計（Trim１個につき（開始,終了）で２個）
echo ' nItemTrim^(^) : Trim位置情報（単位はフレーム）
echo '--------------------------------------------------
echo '--- 共通変数 ---
echo Dim objFileSystem, objStream
echo Dim strBufRead
echo Dim i
echo Dim re, matches
echo Set re = New RegExp
echo re.Global = True
echo.
echo '--- ファイル読み込み ---
echo Set objFileSystem = WScript.CreateObject^("Scripting.FileSystemObject"^)
echo If Not objFileSystem.FileExists^(strFile1^) Then
echo   WScript.StdErr.WriteLine "ファイルが見つかりません:" ^& strFile1
echo   WScript.Quit
echo End If
echo Set objStream = objFileSystem.OpenTextFile^(strFile1^)
echo strBufRead = objStream.ReadLine
echo.
echo '--- trimパターン ---
echo Const strRegTrim = "Trim\((\d+)\,(\d+)\)"
echo '--- パターンマッチ ---
echo re.Pattern = strRegTrim
echo Set matches = re.Execute^(strBufRead^)
echo If matches.Count = 0 Then
echo   WScript.StdErr.WriteLine "Trimデータが読み込めません:" ^& strBufRead
echo   WScript.Quit
echo End If
echo.
echo '--- データ量決定 ---
echo Dim nTrimTotal
echo nTrimTotal = matches.Count * 2
echo.
echo '--- 変数に格納 ---
echo ReDim nItemTrim^(nTrimTotal^)
echo For i=0 To nTrimTotal/2 - 1
echo   nItemTrim^(i*2^)   = CLng^(matches^(i^).SubMatches^(0^)^)
echo   nItemTrim^(i*2+1^) = CLng^(matches^(i^).SubMatches^(1^)^) + 1
echo Next
echo Set matches = Nothing
echo.
echo '--- ファイルクローズ ---
echo objStream.Close
echo Set objStream = Nothing
echo Set objFileSystem  = Nothing
echo.
echo '--------------------------------------------------
echo ' 構成解析ファイルとカット情報からCHAPTERを作成
echo '--------------------------------------------------
echo '--- CHAPTER情報取得に必要な変数 ---
echo Dim clsChapter
echo Dim bCutOn, bShowOn, bShowPre, bPartExist
echo Dim nTrimNum, nType, nLastType, nPart
echo Dim nFrmTrim, nFrmSt, nFrmEd, nFrmMgn, nFrmBegin
echo Dim nSecRd, nSecCalc
echo Dim strCmt, strChapterName, strChapterLast
echo.
echo '--- CHAPTER情報格納用クラス ---
echo Set clsChapter = New ChapterData
echo.
echo '--- ファイルオープン ---
echo Set objFileSystem = WScript.CreateObject^("Scripting.FileSystemObject"^)
echo If Not objFileSystem.FileExists^(strFile2^) Then
echo   WScript.StdErr.WriteLine "ファイルが見つかりません:" ^& strFile2
echo   WScript.Quit
echo End If
echo Set objStream = objFileSystem.OpenTextFile^(strFile2^)
echo.
echo '--- trimパターン ---
echo Const strRegJls  = "^\s*(\d+)\s+(\d+)\s+(\d+)\s+([-\d]+)\s+(\d+).*:(\S+)"
echo '--- 初期設定 ---
echo re.Pattern = strRegJls
echo nFrmMgn    = 30          ' Trimと読み込み構成を同じ位置とみなすフレーム数
echo bShowOn    = 1           ' 最初は必ず表示
echo nTrimNum   = 0           ' 現在のTrim位置番号
echo nFrmTrim   = 0           ' 現在のTrimフレーム
echo nLastType  = 0           ' 直前状態クリア
echo nPart      = 0           ' 初期状態はAパート
echo bPartExist = 0           ' 現在のパートは存在なし
echo nFrmBegin  = 0           ' 次のchapter開始地点
echo.
echo '--- 開始地点設定 ---
echo ' nTrimNum が偶数：次のTrim開始位置を検索
echo ' nTrimNum が奇数：次のTrim終了位置を検索
echo If ^(nTrimTotal ^> 0^) Then
echo   If ^(nItemTrim^(0^) ^<= nFrmMgn^) Then  ' 最初の立ち上がりを0フレームと同一視
echo     nTrimNum   = 1
echo   End If
echo Else
echo   nTrimNum   = 1
echo End If
echo.
echo '--- 構成情報データを順番に読み出し ---
echo Do While objStream.AtEndOfLine = false
echo   strBufRead = objStream.ReadLine
echo   Set matches = re.Execute^(strBufRead^)
echo   If matches.Count ^> 0 Then
echo     '--- 読み出しデータ格納 ---
echo     nFrmSt = CLng^(matches^(0^).SubMatches^(0^)^)     ' 開始フレーム
echo     nFrmEd = CLng^(matches^(0^).SubMatches^(1^)^)     ' 終了フレーム
echo     nSecRd = matches^(0^).SubMatches^(2^)           ' 期間秒数
echo     strCmt = matches^(0^).SubMatches^(5^)           ' 構成コメント
echo     '--- 現在検索中のTrim位置データ取得 ---
echo     If nTrimNum ^< nTrimTotal Then
echo       nFrmTrim = nItemTrim^(nTrimNum^)
echo     End If
echo.
echo     '--- 現構成終了位置より手前にTrim地点がある場合の設定処理 ---
echo     Do While nFrmTrim ^< nFrmEd - nFrmMgn And nTrimNum ^< nTrimTotal
echo       bCutOn  = ^(nTrimNum+1^) Mod 2              ' Trimのカット状態（１でカット）
echo       '--- CHAPTER文字列取得処理 ---
echo       nType = ProcChapterTypeTerm^(nSecCalc, nFrmBegin, nFrmTrim^)
echo       strChapterName = ProcChapterName^(bCutOn, nType, nPart, bPartExist, nSecCalc^)
echo       '--- CHAPTER挿入処理 ---
echo       Call clsChapter.InsertFrame^(nFrmBegin, bCutOn, strChapterName^)
echo       nFrmBegin = nFrmTrim                      ' chapter開始位置変更
echo       nTrimNum = nTrimNum + 1                   ' Trim番号を次に移行
echo       If nTrimNum ^< nTrimTotal Then
echo         nFrmTrim = nItemTrim^(nTrimNum^)          ' 次のTrim位置検索に変更
echo       End If
echo     Loop
echo.
echo     '--- 現構成位置の判断開始 ---
echo     bShowPre = 0
echo     bShowOn = 0
echo     bCutOn  = ^(nTrimNum+1^) Mod 2                ' Trimのカット状態（１でカット）
echo     '--- 現終了位置にTrim地点があるか判断（あればCHAPTER表示確定） ---
echo     If ^(nFrmTrim ^<= nFrmEd + nFrmMgn^) And ^(nTrimNum ^< nTrimTotal^) Then
echo       nFrmEd  = nFrmTrim              ' Trim位置にフレームを変更
echo       bShowOn = 1                     ' 表示を行う
echo       nTrimNum = nTrimNum + 1         ' Trim位置を次に移行
echo     End If
echo.
echo     '--- コメントからCHAPTER表示種類を判断 ---
echo     ' nType 0:スルー 1:CM部分 10:独立構成 11:part扱いにしない独立構成
echo     nType = ProcChapterTypeCmt^(strCmt, nSecRd^)
echo     '--- CHAPTER区切りを確認（前回と今回の構成で区切るか判断） ---
echo     If bCutOn ^<^> 0 Then                  ' カットする部分
echo       If nType = 1 Then                  ' 明示的なCM時
echo         If nLastType ^<^> 1 Then           ' 前回CM以外だった場合表示
echo           bShowPre = 1                   ' 前回終了（今回開始）にchapter表示
echo         End If
echo       Else                               ' 明示的なCM以外
echo         If nLastType = 1 Then            ' 前回CMだった場合表示
echo           bShowPre = 1                   ' 前回終了（今回開始）にchapter表示
echo         End If
echo       End If
echo     End If
echo.
echo     '--- CHAPTER挿入（前回終了位置） ---
echo     If bShowPre ^> 0 Or nType ^>= 10 Then      ' 位置確定のフラグ確認
echo       If nFrmBegin ^< nFrmSt - nFrmMgn Then   ' chapter開始位置が今回開始より前
echo         If nLastType ^<^> 1 Then               ' 前回CM以外の時は種類再確認
echo           nLastType = ProcChapterTypeTerm^(nSecCalc, nFrmBegin, nFrmSt^)
echo         End If
echo         '--- CHAPTER名文字列を決定し挿入 ---
echo         strChapterLast = ProcChapterName^(bCutOn, nLastType, nPart, bPartExist, nSecCalc^)
echo         Call clsChapter.InsertFrame^(nFrmBegin, bCutOn, strChapterLast^)
echo         nFrmBegin = nFrmSt                   ' chapter開始位置を今回開始位置に
echo       End If
echo     End If
echo     '--- CHAPTER挿入（現終了位置） ---
echo     If bShowOn ^> 0 Or nType ^>= 10 Then
echo       If nFrmEd ^> nFrmBegin + nFrmMgn Then   ' chapter開始位置が今回終了より前
echo         '--- CHAPTER名文字列を決定し挿入 ---
echo         strChapterName = ProcChapterName^(bCutOn, nType, nPart, bPartExist, nSecRd^)
echo         Call clsChapter.InsertFrame^(nFrmBegin, bCutOn, strChapterName^)
echo         nFrmBegin = nFrmEd                   ' chapter開始位置を今回終了位置に
echo       End If
echo     End If
echo.
echo     '--- 次回確認用の処理 ---
echo     nLastType = nType
echo.
echo   End If
echo   Set matches = Nothing
echo Loop
echo.
echo '--- Trim位置の出力完了していない場合の処理 ---
echo Do While nTrimNum ^< nTrimTotal
echo   nFrmTrim = nItemTrim^(nTrimNum^)
echo.
echo   '--- Trim位置をchapterへ出力 ---
echo   bCutOn  = ^(nTrimNum+1^) Mod 2                   ' Trimのカット状態（１でカット）
echo   nType = ProcChapterTypeTerm^(nSecCalc, nFrmBegin, nFrmTrim^)
echo   strChapterName = ProcChapterName^(bCutOn, nType, nPart, bPartExist, nSecCalc^)
echo   '--- CHAPTER挿入処理 ---
echo   Call clsChapter.InsertFrame^(nFrmBegin, bCutOn, strChapterName^)
echo   nTrimNum = nTrimNum + 1                            ' Trim番号を次に移行
echo Loop
echo.
echo '--- 最終chapterの出力 ---
echo If nFrmBegin ^< nFrmEd - nFrmMgn Then
echo   bCutOn  = ^(nTrimNum+1^) Mod 2                   ' Trimのカット状態（１でカット）
echo   nType = ProcChapterTypeTerm^(nSecCalc, nFrmBegin, nFrmEd^)
echo   strChapterName = ProcChapterName^(bCutOn, nType, nPart, bPartExist, nSecCalc^)
echo   '--- CHAPTER挿入処理 ---
echo   Call clsChapter.InsertFrame^(nFrmBegin, bCutOn, strChapterName^)
echo End If
echo.
echo '--- 結果出力 ---
echo Call clsChapter.OutputChapter^(nOutFormat^)
echo.
echo '--- ファイルクローズ ---
echo objStream.Close
echo Set objStream = Nothing
echo Set objFileSystem  = Nothing
echo.
echo Set clsChapter = Nothing
echo.
echo '--- 完了 ---
echo.
echo.
echo '--------------------------------------------------
echo ' Chapter種類を取得（開始終了位置から秒数も取得する）
echo '   nSecRd : （出力）期間秒数
echo '   nFrmS  : 開始フレーム
echo '   nFrmE  : 終了フレーム
echo '  出力
echo '   nType  : 0:通常 1:明示的にCM 2:part扱いの判断迷う構成
echo '            10:単独構成 11:part扱いの判断迷う単独構成 12:空欄
echo '--------------------------------------------------
echo Function ProcChapterTypeTerm^(nSecRd, nFrmS, nFrmE^)
echo   Dim nType
echo.
echo   nSecRd = ProcGetSec^(nFrmE - nFrmS^)
echo   If nSecRd = 0 Then
echo     nType = 12
echo   ElseIf nSecRd = 90 Then
echo     nType = 11
echo   ElseIf CInt^(nSecRd^) ^< 15 Then
echo     nType = 2
echo   Else
echo     nType = 0
echo   End If
echo.
echo   ProcChapterTypeTerm = nType
echo End Function
echo.
echo.
echo '--------------------------------------------------
echo ' Chapter種類を取得（コメント情報を使用する）
echo '   strCmt : コメント文字列
echo '   nSecRd : コメントの秒数
echo '  出力
echo '   nType  : 0:通常 1:明示的にCM 2:part扱いの判断迷う構成
echo '            10:単独構成 11:part扱いの判断迷う単独構成 12:空欄
echo '--------------------------------------------------
echo Function ProcChapterTypeCmt^(strCmt, nSecRd^)
echo   Dim nType
echo.
echo   '--- CHAPTER表示内容か判断 ---
echo   ' nType  : 0:通常 1:明示的にCM 2:part扱いの判断迷う構成
echo   '          10:単独構成 11:part扱いの判断迷う単独構成 12:空欄
echo   If InStr^(strCmt, "Trailer(cut)"^) ^> 0 Then
echo     nType   = 0
echo   ElseIf InStr^(strCmt, "Trailer"^) ^> 0 Then
echo     nType   = 10
echo   ElseIf InStr^(strCmt, "Sponsor"^) ^> 0 Then
echo     nType   = 11
echo   ElseIf InStr^(strCmt, "Endcard"^) ^> 0 Then
echo     nType   = 11
echo   ElseIf InStr^(strCmt, "Edge"^) ^> 0 Then
echo     nType   = 11
echo   ElseIf InStr^(strCmt, "Border"^) ^> 0 Then
echo     nType   = 11
echo   ElseIf InStr^(strCmt, "CM"^) ^> 0 Then
echo     nType   = 1             ' 15秒単位CMとそれ以外を分ける必要なければ0にする
echo   ElseIf nSecRd = 90 Then
echo     nType   = 11
echo   ElseIf nSecRd = 60 Then
echo     nType   = 10
echo   ElseIf CInt^(nSecRd^) ^< 15 Then
echo     nType   = 2
echo   Else
echo     nType   = 0
echo   End If
echo.
echo   ProcChapterTypeCmt = nType
echo End Function
echo.
echo.
echo '--------------------------------------------------
echo ' CHAPTER名の文字列を決める
echo '   bCutOn : 0=カットしない部分 1=カット部分
echo '   nType  : 0:通常 1:明示的にCM 2:part扱いの判断迷う構成
echo '            10:単独構成 11:part扱いの判断迷う単独構成 12:空欄
echo '   nPart  : Aパートから順番に数字0～（function内で更新あり）
echo '   bPartExist : part構成の要素があれば2（function内で更新あり）
echo '   nSecRd     : 単独構成時の秒数
echo ' 戻り値はCHAPTER名
echo '--------------------------------------------------
echo Function ProcChapterName^(bCutOn, nType, nPart, bPartExist, nSecRd^)
echo   Dim strChapterName
echo.
echo   If bCutOn = 0 Then                           ' 残す部分
echo     strChapterName = Chr^(Asc^("A"^) + ^(nPart Mod 23^)^)
echo     If nType ^>= 10 Then
echo       strChapterName = strChapterName ^& nSecRd ^& "Sec"
echo     Else
echo       strChapterName = strChapterName
echo     End If
echo     If nType = 11 Or nType = 2 Then            ' part扱いの判断迷う構成
echo       If bPartExist = 0 Then
echo         bPartExist = 1
echo       End If
echo     ElseIf nType ^<^> 12 Then
echo       bPartExist = 2
echo     End If
echo   Else                                         ' カットする部分
echo     If nType ^>= 10 Then
echo       strChapterName = "X" ^& nSecRd ^& "Sec"
echo     ElseIf nType = 1 Then
echo       strChapterName = "XCM"
echo     Else
echo       strChapterName = "X"
echo     End If
echo     If bPartExist ^> 0 And nType ^<^> 12 Then
echo       nPart = nPart + 1
echo       bPartExist = 0
echo     End If
echo   End If
echo   ProcChapterName = strChapterName
echo End Function
echo.
echo.
echo '--------------------------------------------------
echo ' フレーム数に対応する秒数取得
echo '--------------------------------------------------
echo Function ProcGetSec^(nFrame^)
echo   '29.97fpsの設定で固定
echo   ProcGetSec = Int^(^(CLng^(nFrame^) * 1001 + 30000/2^) / 30000^)
echo End Function
echo.
echo.
echo '--------------------------------------------------
echo ' CHAPTER格納用クラス
echo '  InsertMSec     : CHAPTERに追加（ミリ秒で指定）
echo '  InsertFrame    : CHAPTERに追加（フレーム位置指定）
echo '  OutputChapter  : CHAPTER情報を標準出力に出力
echo '--------------------------------------------------
echo Class ChapterData
echo   Private m_nMaxList        ' 現在の格納最大
echo   Private m_nList           ' CHAPTER格納個数
echo   Private m_nMSec^(^)         ' CHAPTER位置（ミリ秒単位）
echo   Private m_bCutOn^(^)        ' 0:カットしない位置 1:カット位置
echo   Private m_strName^(^)       ' チャプター名
echo   Private m_strOutput       ' 出力格納
echo.
echo   Private Sub Class_Initialize^(^)
echo     m_nMaxList = 0
echo     m_nList    = 0
echo     m_strOutput = ""
echo   End Sub
echo.
echo   Private Sub Class_Terminate^(^)
echo   End Sub
echo.
echo   '------------------------------------------------------------
echo   ' CHAPTER表示用文字列を１個分作成（m_strOutputに格納）
echo   ' num     : 格納chapter通し番号
echo   ' nCount  : 出力用chapter番号
echo   ' nTime   : 位置ミリ秒単位
echo   ' strName : chapter名
echo   '------------------------------------------------------------
echo   Private Sub GetDispChapter^(num, nCount, nTime, strName^)
echo     Dim strBuf
echo     Dim strCount, strTime
echo     Dim strHour, strMin, strSec, strMsec
echo     Dim nHour, nMin, nSec, nMsec
echo.
echo     '--- チャプター番号 ---
echo     strCount = CStr^(nCount^)
echo     If ^(Len^(strCount^) = 1^) Then
echo       strCount = "0" ^& strCount
echo     End If
echo     '--- チャプター時間 ---
echo     nHour = Int^(nTime / ^(60*60*1000^)^)
echo     nMin  = Int^(^(nTime Mod ^(60*60*1000^)^) / ^(60*1000^)^)
echo     nSec  = Int^(^(nTime Mod ^(60*1000^)^)    / 1000^)
echo     nMsec = nTime Mod 1000
echo     strHour = Right^("0" ^& CStr^(nHour^), 2^)
echo     strMin  = Right^("0" ^& CStr^(nMin^),  2^)
echo     strSec  = Right^("0" ^& CStr^(nSec^),  2^)
echo     strMsec = Right^("00" ^& CStr^(nMsec^), 3^)
echo     StrTime = strHour ^& ":" ^& strMin ^& ":" ^& strSec ^& "." ^& strMsec
echo     '--- 出力文字列（１行目） ---
echo     strBuf = "CHAPTER" ^& strCount ^& "=" ^& strTime ^& vbCRLF
echo     '--- 出力文字列（２行目） ---
echo     strBuf = strBuf ^& "CHAPTER" ^& strCount ^& "NAME=" ^& strName ^& vbCRLF
echo     m_strOutput = m_strOutput ^& strBuf
echo   End Sub
echo.
echo.
echo   '---------------------------------------------
echo   ' CHAPTERに追加（ミリ秒で指定）
echo   ' nMSec   : 位置ミリ秒
echo   ' bCutOn  : 1の時カット
echo   ' strName : chapter表示用文字列
echo   '---------------------------------------------
echo   Public Sub InsertMSec^(nMSec, bCutOn, strName^)
echo     If m_nList ^>= m_nMaxList Then      ' 配列満杯時は再確保
echo       m_nMaxList = m_nMaxList + 100
echo       ReDim Preserve m_nMSec^(m_nMaxList^)
echo       ReDim Preserve m_bCutOn^(m_nMaxList^)
echo       ReDim Preserve m_strName^(m_nMaxList^)
echo     End If
echo     m_nMSec^(m_nList^)   = nMSec
echo     m_bCutOn^(m_nList^)  = bCutOn
echo     m_strName^(m_nList^) = strName
echo     m_nList = m_nList + 1
echo   End Sub
echo.
echo   '---------------------------------------------
echo   ' CHAPTERに追加（フレーム位置指定）
echo   ' nFrame  : フレーム位置
echo   ' bCutOn  : 1の時カット
echo   ' strName : chapter表示用文字列
echo   '---------------------------------------------
echo   Public Sub InsertFrame^(nFrame, bCutOn, strName^)
echo     Dim nTmp
echo     '29.97fpsの設定で固定
echo     nTmp = Int^(^(CLng^(nFrame^) * 1001 + 30/2^) / 30^)
echo     Call InsertMSec^(nTmp, bCutOn, strName^)
echo   End Sub
echo.
echo.
echo   '---------------------------------------------
echo   ' CHAPTER情報を標準出力に出力
echo   ' nCutType : MODE_ORG / MODE_CUT / MODE_TVT / MODE_TVC
echo   '---------------------------------------------
echo   Public Sub OutputChapter^(nCutType^)
echo     Dim i, inext, nCount
echo     Dim bCutState, bSkip
echo     Dim nSumTime
echo     Dim strName
echo.
echo     nSumTime  = CLng^(0^)      ' 現在の位置（ミリ秒単位）
echo     nCount    = 1            ' CHAPTER出力番号
echo     bCutState = 0            ' 前回の状態（0:非カット用 1:カット用）
echo     m_strOutput = ""         ' 出力
echo     '--- tvtplay用初期文字列 ---
echo     If nCutType = MODE_TVT Or nCutType = MODE_TVC Then
echo       m_strOutput = "c-"
echo     End If
echo.
echo     '--- CHAPTER設定数だけ繰り返し ---
echo     inext = 0
echo     For i=0 To m_nList - 1
echo       '--- 次のCHAPTERと重なっている場合は除く ---
echo       bSkip = 0
echo       If ^(inext ^> i^) Then
echo         bSkip = 1
echo       Else
echo         inext = i+1
echo         If ^(inext ^< m_nList-1^) Then
echo           If ^(m_nMSec^(inext+1^) - m_nMSec^(inext^) ^< MSEC_DIVMIN^) Then
echo             inext = inext + 1
echo           End If
echo         End If
echo       End If
echo       If ^(bSkip = 0^) Then
echo         '--- 全部表示モードorカットしない位置の時に出力 ---
echo         If nCutType = MODE_ORG Or nCutType = MODE_TVT Or m_bCutOn^(i^) = 0 Then
echo           '--- 最初が0でない時の補正 ---
echo           If nCutType = MODE_ORG Or nCutType = MODE_TVT Then
echo             If i = 0 And m_nMSec^(i^) ^> 0 Then
echo               nSumTime  = nSumTime + m_nMSec^(i^)
echo             End If
echo           End If
echo           '--- tvtplay用 ---
echo           If nCutType = MODE_TVT Or nCutType = MODE_TVC Then
echo             '--- CHAPTER名を設定 ---
echo             If nCutType = MODE_TVC Then                    ' カット済み
echo               If bCutState ^> 0 And m_bCutOn^(i^) = 0 Then    ' カット終了
echo                 strName = m_strName^(i^) ^& SUFFIX_CUTO
echo               Else
echo                 strName = m_strName^(i^)
echo               End If
echo             ElseIf bCutState = 0 And m_bCutOn^(i^) ^> 0 Then  ' カット開始
echo               strName = PREFIX_TVTI ^& m_strName^(i^)
echo             ElseIf bCutState ^> 0 And m_bCutOn^(i^) = 0 Then  ' カット終了
echo               strName = PREFIX_TVTO ^& m_strName^(i^)
echo             Else
echo               strName = m_strName^(i^)
echo             End If
echo             strName = Replace^(strName, "-", "－"^)
echo             '--- tvtplay用CHAPTER出力文字列設定 ---
echo             m_strOutput = m_strOutput ^& nSumTime ^& "c" ^& strName ^& "-"
echo           '--- 通常のchapter用 ---
echo           Else
echo             '--- CHAPTER名を設定 ---
echo             If bCutState = 0 And m_bCutOn^(i^) ^> 0 Then      ' カット開始
echo               strName = PREFIX_ORGI ^& m_strName^(i^)
echo             ElseIf bCutState ^> 0 And m_bCutOn^(i^) = 0 Then  ' カット終了
echo               If nCutType = MODE_CUT Then
echo                 strName = PREFIX_CUTO ^& m_strName^(i^) ^& SUFFIX_CUTO
echo               Else
echo                 strName = PREFIX_ORGO ^& m_strName^(i^)
echo               End If
echo             Else
echo               strName = m_strName^(i^)
echo             End If
echo             '--- CHAPTER出力文字列設定 ---
echo             Call GetDispChapter^(i, nCount, nSumTime, strName^)
echo           End If
echo           '--- 書き込み後共通設定 ---
echo           nSumTime  = nSumTime + ^(m_nMSec^(inext^) - m_nMSec^(i^)^)
echo           nCount    = nCount + 1
echo         End If
echo         '--- 現CHAPTERに状態更新 ---
echo         bCutState = m_bCutOn^(i^)
echo       End If
echo     Next
echo.
echo     '--- tvtplay用最終文字列 ---
echo     If nCutType = MODE_TVT Then
echo       If bCutState ^> 0 Then   ' CM終了処理
echo         m_strOutput = m_strOutput ^& "0e" ^& PREFIX_TVTO ^& "-"
echo       Else
echo         m_strOutput = m_strOutput ^& "0e-"
echo       End If
echo       m_strOutput = m_strOutput ^& "c"
echo     ElseIf nCutType = MODE_TVC Then
echo       m_strOutput = m_strOutput ^& "c"
echo     End If
echo     '--- 結果出力 ---
echo     WScript.StdOut.Write m_strOutput
echo   End Sub
echo End Class
)> "%work_dir%%main_project_name%\bat\func_chapter_jls.vbs"
rem ------------------------------
exit /b


:make_autovfr_phase
rem ### AutoVfrを自動事項するためのステップ
echo rem # AutoVfrの実行フェーズ>>"%main_bat_file%"
echo call ".\bat\autovfr_scan.bat">> "%main_bat_file%"
echo.>> "%main_bat_file%"
echo AutoVfr.avs："%autovfr_template%"
copy "%autovfr_template%" "%work_dir%%main_project_name%\\avs\"> nul
echo AutoVfr_Fast.avs："%autovfr_fast_template%"
copy "%autovfr_fast_template%" "%work_dir%%main_project_name%\\avs\"> nul
rem # "AutoVfr.ini"をコピーする。autovfrini_pathで指定されたパスが存在しない場合は、AutoVfr.exeと同じパスを使用する。
if exist "%autovfrini_path%" (
    echo AutoVfr.ini："%autovfrini_path%"
    copy "%autovfrini_path%" "%work_dir%%main_project_name%\"> nul
) else (
    call :find_autovfr_dir "%autovfr_path%"
)
(
echo @echo off
echo setlocal
echo echo start %%~nx0 bat job...
echo cd /d %%~dp0..\
echo.
echo rem ■AutoVfrのMode
echo call :autovfr_mode_detect
echo rem [0=Auto_Vfrを利用] [1=Auto_Vfr_Fastを利用]
echo rem set autovfr_mode=^0
echo.
echo rem ■AutoVfrの自動/手動設定判定
echo call :autovfr_deint_detect
echo rem [0=マニュアルでインタレースを利用] [1=自動デインターレースを利用]
echo rem set autovfr_deint=^1
echo.
echo rem ■スレッド数指定
echo call :autovfr_threadnum_detect
echo rem # AutoVfrログを出力する際のスレッド数を指定します。無指定の場合、システムの論理CPU数になります。
echo rem set autovfr_thread_num=
echo.
echo rem # デインターレース方式を確認
echo call :deinterlace_filter_flag_detect
echo.
echo if not "%%deinterlace_filter_flag%%"=="Its" ^(
echo     echo デインターレース方式にItsを用いない為、AutoVfrの実行を中止します。
echo     title コマンド プロンプト
echo     echo end %%~nx0 bat job...
echo     exit /b
echo ^)
echo.
echo rem # エンコードツールをまとめたディレクトリを示す環境変数ENCTOOLSROOTPATHが定義されているか確認
echo call :toolsdircheck
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出
echo call :project_name_check
echo rem # parameterファイル中のMPEG-2デコーダータイプ^(mpeg2dec_select_flag^)を検出
echo call :mpeg2dec_select_flag_check
echo rem # parameterファイル中のAutoVfrのパラメーターを検出
echo call :autovfr_param_check
echo.
echo rem # 各実行ファイルが存在するか確認。存在しない場合ENCTOOLSROOTPATH内部を探索する、もしくはシステムの探索パスに委ねる
)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist "%avs2pipe_path%" ^(set avs2pipe_path=%avs2pipe_path%^) else ^(call :find_avs2pipe "%avs2pipe_path%"^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist "%autovfr_path%" ^(set autovfr_path=%autovfr_path%^) else ^(call :find_autovfr "%autovfr_path%"^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
(
echo.
echo rem # 各種実行ファイルへのパスが、最終的にどのような値になったか確認。
echo echo avs2pipe: %%avs2pipe_path%%
echo echo AutoVfr : %%autovfr_path%%
echo.
echo rem *****************Auto_Vfrで使用**********************
echo rem ■Auto_Vfrの設定。^(^)無しで記載。ログファイルパス,cut,numberは指定不要。
echo rem [一覧] cthresh=^(コーミング強さ-1-255^), mi=^(コーミング量0-blockx*blocky^), chroma=false, blockx=16^(判定ブロック縦サイズ^), blocky=^(判定ブロック横サイズ^), IsCrop=false, crop_height=, IsTop=false, IsBottom=true, show_crop=false, IsDup=false, thr_m=10, thr_luma=0.01
echo rem 初期値cthresh=60, mi=55, blockx=16, blocky=32 
echo rem テロップだとcthresh=110,mi=100程度が上限^(70,60^)。下げすぎると誤判定多く、上げすぎると周期判定失敗してテロップが切れる。cthreshはそのままで、miを動かして調整するのが良い。^(60fps区間を広げる設定あれば良いのに^)
echo rem crop_heightの値はYV12の場合4の倍数でないとエラーになるので注意！
echo rem @set autovfr_setting_normal=cthresh=80, mi=60, blockx=16, blocky=32, chroma=false, IsCrop=true, crop_height=92^0
echo rem ■AutoVfr.exeの設定^(-i -o以外のオプション指定^)
echo rem # 判定不能な周期が見つかった場合、"-60F 0"でかつ"-30B 0^(default^)"であれば24fps関数が適用される
echo if "%%autovfr_deint%%"=="0" ^(
echo     @set EXESETTING=-INI "AutoVfr.ini" -30F 1 -60F 0 -30B 0 -skip 1 -ref 300 -24A 0 -30A 0 -FIX
echo ^) else ^(
echo     @set EXESETTING=-INI "AutoVfr.ini" -30F 1 -60F 0 -30B 0 -skip 1 -ref 300 -24A 1 -30A 1 -FIX
echo ^)
echo rem ■60iテロ範囲拡張フレーム数^(60fps・6to2範囲 拡張^)
echo rem 誤爆防止の閾値設定の為、60iテロ検出部分が短くなる場合があります。それを補正します。
echo rem この処理はAutoVFR.exeの後に行われます。"[24] txt60mc"または"[60] f60"を含む範囲指定行を処理対象にします。
echo rem EXBIGIsに先頭の、EXLASTsに末尾の拡張フレーム数を、指定してください。5の倍数推奨。
echo @set EXBIGIs=^5
echo @set EXLASTs=^5
echo rem *****************Auto_Vfr_Fastで利用*****************
echo rem ■Auto_Vfr_Fastの設定。^(^)無しで記載。ログファイルパス,cut,numberは指定不要。
echo rem [一覧] cthresh=^(コーミング強さ-1-255^), mi=^(コーミング量0-blockx*blocky^), chroma=false, blockx=^(判定ブロック縦サイズ^), blocky=^(判定ブロック横サイズ^)
echo rem 初期値cthresh=60, mi=55, blockx=16, blocky=32 
echo rem テロップだとcthresh=110,mi=100程度が上限^(70,60^)。下げすぎると誤判定多く、上げすぎると周期判定失敗してテロップが切れる。cthreshはそのままで、miを動かして調整するのが良い。^(60fps区間を広げる設定あれば良いのに^)
echo rem @set autovfr_setting_fast=cthresh=80, mi=60, blockx=16, blocky=32, chroma=false
echo rem ■AutoVfr.exeの設定^(-i -o以外のオプション指定^)
echo rem # 判定不能な周期が見つかった場合、"-60F 0"でかつ"-30B 0^(default^)"であれば24fps関数が適用される
echo if "%%autovfr_deint%%"=="0" ^(
echo     @set FASTEXESETTING=-INI "AutoVfr.ini" -30F 1 -60F 0 -30B 0 -skip 1 -ref 250 -24A 0 -30A 0 -FIX
echo ^) else ^(
echo     @set FASTEXESETTING=-INI "AutoVfr.ini" -30F 1 -60F 0 -30B 0 -skip 1 -ref 250 -24A 1 -30A 1 -FIX
echo ^)
echo rem ■60iテロ範囲拡張フレーム数^(60fps範囲拡張^)
echo rem 誤爆防止の閾値設定の為、60iテロ検出部分が短くなる場合があります。それを補正します。
echo rem この処理はAutoVFR.exeの後に行われます。"[60] f60"を含む範囲指定行を処理対象にします。
echo rem EXBIGIfに先頭の、EXLASTfに末尾の拡張フレーム数を、指定してください。5の倍数推奨。
echo @set EXBIGIf=^5
echo @set EXLASTf=^5
echo rem *****************************************************
echo.
echo :main
echo rem //----- main開始 -----//
echo title %%project_name%%
echo echo おーとおーとVFR（AutoVFR BAT版） インスパイア
echo echo Auto_VFRとAuto_VFR_Fastの処理を引き継ぎます
echo echo 閾値確認は
echo echo ShowCombedTIVTC^(debug=true,blockx=16,blocky=32,cthresh=60^)
echo echo 等で可能です。
echo echo txt60mcは、「IIフレーム前の最後のPフレームのフレーム番号のMod5値が、指定する値」を指定
echo echo.
echo rem # カレントの.defファイルをデフォルトのものと比較し、差分があればユーザー編集済みとしてAutoVfrはスキップ
echo if not exist ".\main.def" ^(
echo     echo main.defファイルが存在しません。AutoVfrを実行します。
echo     set exit_stat=^0
echo ^) else ^(
echo     call :def_diff_check
echo ^)
echo if "%%exit_stat%%"=="1" ^(
echo     exit /b
echo ^)
echo.
echo set STARTTIME=%%DATE%% %%TIME%%
echo.
echo if defined autovfr_setting_normal ^(set autovfr_setting_normal=, %%autovfr_setting_normal%%^)
echo if defined autovfr_setting_fast ^(set autovfr_setting_fast=, %%autovfr_setting_fast%%^)
echo.
echo call :SETPARAMETER
echo rem AutoVFRとAutoVFR_Fastを分岐
echo set SEPARATETEMP=%%autovfr_thread_num%%
echo if "%%autovfr_mode%%"=="0" ^(
echo     call :MAKESLOWAVS
echo ^) else ^(
echo     call :MAKEFASTAVS
echo ^)
echo echo AutoVfrを走査します. . .[%%date%% %%time%%]
echo call :AVS2PIPE_DECODE
echo call :MAKEDEF
echo call :EDITDEFm
echo rem # .defファイルを新しく作られたものに置き換え
echo call :ReLOCATION
echo echo.
echo echo ***************************************************************
echo echo ■全ての処理が終了しました。
echo echo 開始 : %%STARTTIME%%
echo echo 終了 : %%DATE%% %%TIME%%
echo echo ***************************************************************
echo echo.
echo title コマンド プロンプト
echo rem //----- main終了 -----//
echo echo end %%~nx0 bat job...
echo echo.
echo exit /b
echo.
rem ------------------------------
echo :def_diff_check
echo fc ".\main.def" ".\avs\main.def"^> NUL
echo if "%%errorlevel%%"=="1" ^(
echo     echo .defファイルが編集済みの為、AutoVfrの実行をスキップします
echo     set exit_stat=^1
echo ^) else ^(
echo     set exit_stat=^0
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :SETPARAMETER
echo rem # 環境変数のリセット
echo rem set SEPARATETEMP=%%SEPARATE%%
echo if not defined OUTPATH ^(set OUT=%%~dp1^) else ^(set OUT=%%OUTPATH%%^)
echo set PIPECOMMAND=
echo set COPYCOMMAND=
echo set DELCOMMANDa=
echo set DELCOMMANDl=
echo set /a NUMBER=%%NUMBER%%+^1
echo set TXTLINE=
echo set SPACEPOINT=^0
echo exit /b
echo.
rem ------------------------------
echo :MAKESLOWAVS
echo rem # スレッド分割AutoVfr用avsファイル作成
echo if "%%SEPARATETEMP%%"=="0" ^(exit /b^)
echo copy ".\avs\LoadPlugin.avs" ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"
echo echo.^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"
echo copy /b ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs" + ".\avs\Auto_Vfr.avs" ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"
echo echo.^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"
echo rem ※フィールドオーダーを明示しないとAutoVfrスキャン処理で盛大に誤爆する可能性があるので注意
echo if "%%mpeg2dec_select_flag%%"=="1" ^(
echo     echo Try { Import^^^("..\avs\LoadSrc_Video.avs"^^^) } catch^^^(err_msg^^^) { video1 = MPEG2VIDEO^^^("..\src\video1.ts"^^^) }^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"
echo ^) else if "%%mpeg2dec_select_flag%%"=="2" ^(
echo     echo Try { Import^^^("..\avs\LoadSrc_Video.avs"^^^) } catch^^^(err_msg^^^) { video1 = MPEG2Source^^^("..\src\video1.ts",upconv=0^^^).ConvertToYUY2^^^(^^^) }^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"
echo ^) else if "%%mpeg2dec_select_flag%%"=="3" ^(
echo     echo Try { Import^^^("..\avs\LoadSrc_Video.avs"^^^) } catch^^^(err_msg^^^) { video1 = LWLibavVideoSource^^^("..\src\video1.ts", dr=false, repeat=true, dominance=0^^^) }^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"
echo     echo video1 = video1.height^^^(^^^) == 1088 ? video1.Crop^^^(0, 0, 0, -8^^^) : video1^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"
echo ^)
echo echo video1.AssumeTFF^(^)^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"
echo echo.^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"
rem # Trim編集の1行抽出ファイル"trim_chars.txt"が存在する場合、それをAutoVfrにも反映する
echo if exist "trim_chars.txt" ^(
echo     copy /b ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs" + "trim_chars.txt" ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"
echo ^)
echo echo Auto_VFR^(".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.txt", cut=%%autovfr_thread_num%%, number=%%SEPARATETEMP%%%%autovfr_setting_normal%%^)^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"
echo if "%%SEPARATETEMP%%"=="1" ^(set PIPECOMMAND="%%avs2pipe_path%%" -benchmark ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"%%PIPECOMMAND%%^) else ^(set PIPECOMMAND= ^"^|^" "%%avs2pipe_path%%" -benchmark ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"%%PIPECOMMAND%%^)
echo if "%%SEPARATETEMP%%"=="1" ^(set COPYCOMMAND=copy ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.txt"%%COPYCOMMAND%% ".\log\AutoVFR.log"^) else ^(set COPYCOMMAND= + ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.txt"%%COPYCOMMAND%%^)
echo if "%%SEPARATETEMP%%"=="1" ^(set DELCOMMANDa=del ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"%%DELCOMMANDa%%^) else ^(set DELCOMMANDa= ^"^&^"del ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"%%DELCOMMANDa%%^)
echo if "%%SEPARATETEMP%%"=="1" ^(set DELCOMMANDl=del ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.txt"%%DELCOMMANDl%%^) else ^(set DELCOMMANDl= ^"^&^"del ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.txt"%%DELCOMMANDl%%^)
echo set /a SEPARATETEMP=%%SEPARATETEMP%%-^1
echo GOTO :MAKESLOWAVS
echo.
rem ------------------------------
echo :MAKEFASTAVS
echo rem # スレッド分割AutoVfr_Fast用avsファイル作成
echo if "%%SEPARATETEMP%%"=="0" ^(exit /b^)
echo copy ".\avs\LoadPlugin.avs" ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"
echo echo.^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"
echo copy /b ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs" + ".\avs\Auto_Vfr_Fast.avs" ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"
echo echo.^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"
echo rem ※フィールドオーダーを明示しないとAutoVfrスキャン処理で盛大に誤爆する可能性があるので注意
echo if "%%mpeg2dec_select_flag%%"=="1" ^(
echo     echo Try { Import^^^("..\avs\LoadSrc_Video.avs"^^^) } catch^^^(err_msg^^^) { video1 = MPEG2VIDEO^^^("..\src\video1.ts"^^^) }^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"
echo ^) else if "%%mpeg2dec_select_flag%%"=="2" ^(
echo     echo Try { Import^^^("..\avs\LoadSrc_Video.avs"^^^) } catch^^^(err_msg^^^) { video1 = MPEG2Source^^^("..\src\video1.ts",upconv=0^^^).ConvertToYUY2^^^(^^^) }^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"
echo ^) else if "%%mpeg2dec_select_flag%%"=="3" ^(
echo     echo Try { Import^^^("..\avs\LoadSrc_Video.avs"^^^) } catch^^^(err_msg^^^) { video1 = LWLibavVideoSource^^^("..\src\video1.ts", dr=false, repeat=true, dominance=0^^^) }^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"
echo     echo video1 = video1.height^^^(^^^) == 1088 ? video1.Crop^^^(0, 0, 0, -8^^^) : video1^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"
echo ^)
echo echo video1.AssumeTFF^(^)^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"
echo echo.^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"
rem # Trim編集の1行抽出ファイル"trim_chars.txt"が存在する場合、それをAutoVfrにも反映する
echo if exist "trim_chars.txt" ^(
echo     copy /b ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs" + "trim_chars.txt" ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"
echo ^)
echo echo Auto_VFR_Fast^("..\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.txt", cut=%%autovfr_thread_num%%, number=%%SEPARATETEMP%%%%autovfr_setting_fast%%^)^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"
echo if "%%SEPARATETEMP%%"=="1" ^(set PIPECOMMAND="%%avs2pipe_path%%" -benchmark ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"%%PIPECOMMAND%%^) else ^(set PIPECOMMAND= ^"^|^" "%%avs2pipe_path%%" -benchmark ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"%%PIPECOMMAND%%^)
echo if "%%SEPARATETEMP%%"=="1" ^(set COPYCOMMAND=copy ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.txt"%%COPYCOMMAND%% ".\log\AutoVFR_Fast.log"^) else ^(set COPYCOMMAND= + ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.txt"%%COPYCOMMAND%%^)
echo if "%%SEPARATETEMP%%"=="1" ^(set DELCOMMANDa=del ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"%%DELCOMMANDa%%^) else ^(set DELCOMMANDa= ^"^&^"del ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"%%DELCOMMANDa%%^)
echo if "%%SEPARATETEMP%%"=="1" ^(set DELCOMMANDl=del ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.txt"%%DELCOMMANDl%%^) else ^(set DELCOMMANDl= ^"^&^"del ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.txt"%%DELCOMMANDl%%^)
echo set /a SEPARATETEMP=%%SEPARATETEMP%%-^1
echo GOTO :MAKEFASTAVS
echo.
rem ------------------------------
echo :AVS2PIPE_DECODE
echo if "%%autovfr_mode%%"=="0" ^(call :DECODESETs^) else ^(call :DECODESETf^)
echo echo ===============================================================
echo echo モード            : %%MODE%%
echo echo 分割数            : %%autovfr_thread_num%%
echo echo スプリプトOptis   : %%VFROPTIONS%%
echo echo avs2pipe.exeパス  : %%avs2pipe_path%%
echo echo AutoVfr.exeパス   : %%autovfr_path%%
echo echo AutoVfr.exe設定   : %%AUTOEXESET%%
echo echo テロップ範囲拡張  : [先頭= %%EXBIGI%%] [終端= %%EXLAST%%]
echo echo.
echo echo Logファイル出力先 : %%OUTLOG%%
echo echo Defファイル出力先 : %%OUTDEF%%
echo if "%%DELLOG%%"=="1" ^(echo  [注] Logファイルは消去します^)
echo echo ===============================================================
echo echo デコード開始 : %%DATE%% %%TIME%%
echo echo.
echo echo デコードの一時停止 : プロンプトを 右クリック＞範囲選択
echo echo               再開 : プロンプトを 右クリック
echo echo ===============================================================
echo %%PIPECOMMAND:^"^|^"=^|%%
echo echo ===============================================================
echo echo デコード終了 : %%DATE%% %%TIME%%
echo.
echo %%COPYCOMMAND%% ^>NUL
echo %%DELCOMMANDa:^"^&^"=^&%%
echo if exist "%%OUTLOG%%" ^(echo Logファイルが作成されました。
echo %%DELCOMMANDl:^"^&^"=^&%%
echo ^)
echo echo.
echo echo ***************************************************************
echo exit /b
echo :::::::::::
echo :DECODESETs
echo set MODE=Auto_VFR^&set OUTLOG=.\log\AutoVFR.log^&set OUTDEF=.\tmp\AutoVFR.def^&set VFROPTIONS=[%%autovfr_setting_normal%%]^&set AUTOEXESET=[%%EXESETTING%%]^&set EXBIGI=%%EXBIGIs%%^&set EXLAST=%%EXLASTs%%
echo exit /b
echo :DECODESETf
echo set MODE=Auto_VFR_Fast^&set OUTLOG=.\log\AutoVFR_Fast.log^&set OUTDEF=.\tmp\AutoVFR_Fast.def^&set VFROPTIONS=[%%autovfr_setting_fast%%]^&set AUTOEXESET=[%%FASTEXESETTING%%]^&set EXBIGI=%%EXBIGIf%%^&set EXLAST=%%EXLASTf%%
echo exit /b
echo.
rem ------------------------------
echo :MAKEDEF
echo echo defファイルを出力します[%%date%% %%time%%]
echo if "%%autovfr_mode%%"=="0" ^(
echo     "%%autovfr_path%%" -i ".\log\AutoVFR.log" -o "%%OUTDEF%%" %%EXESETTING%%
echo ^) else if "%%autovfr_mode%%"=="1" ^(
echo     "%%autovfr_path%%" -i ".\log\AutoVFR_Fast.log" -o "%%OUTDEF%%" %%FASTEXESETTING%%
echo ^)
echo if exist "%%OUTDEF%%" ^(
echo     echo defファイルが作成されました。
echo     if "%%DELLOG%%"=="1" ^(
echo         del "%%OUTLOG%%"
echo     ^)
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :EDITDEFm
echo if "%%EXBIGI%%" == "0" ^(if "%%EXLAST%%" == "0" ^(exit /b^)^)
echo rem 空白行除去
echo if exist "%%OUTDEF%%.temp" ^(del "%%OUTDEF%%.temp"^)
echo for /f ^"usebackq delims=^" %%%%k in ^(^"%%OUTDEF%%^"^) do ^(echo %%%%k ^| find /v ^"mode fps_adjust = on^"^>^>^"%%OUTDEF%%.temp^"^)
echo if exist ^"%%OUTDEF%%.temp^" ^(del ^"%%OUTDEF%%^"^) else ^(echo ERROR1^)
echo rem 処理行数取得
echo for /f ^"usebackq delims=]^" %%%%k in ^(`find /n ^"-^" ^"%%OUTDEF%%.temp^" ^^^| find /i ^"[60] f60^"`^) do ^(call set TXTLINE=%%%%TXTLINE%%%%_%%%%k[^)
echo for /f ^"usebackq delims=]^" %%%%k in ^(`find /n ^"-^" ^"%%OUTDEF%%.temp^" ^^^| find /i ^"[24] txt60mc^"`^) do ^(call set TXTLINE=%%%%TXTLINE%%%%_%%%%k[^)
echo rem 範囲指定行取得
echo for /f ^"usebackq delims=[]^" %%%%k in ^(`find /n ^"-^" ^"%%OUTDEF%%.temp^" ^^^| find ^"[^" ^^^| find ^"] ^" ^^^| sort /r`^) do ^(set BIGILINE=%%%%k^)
echo for /f ^"usebackq delims=[]^" %%%%k in ^(`find /n ^"-^" ^"%%OUTDEF%%.temp^" ^^^| find ^"[^" ^^^| find ^"] ^" ^^^| sort`^) do ^(set LASTLINE=%%%%k^)
echo rem 置換
echo set COUNTTXTLINE=^0
echo for /f "usebackq delims=" %%%%k in ^("%%OUTDEF%%.temp"^) do ^(
echo  call :COUNTLINE
echo  call :EDITDEFs "%%%%~k"
echo ^)
echo if exist "%%OUTDEF%%" ^(del "%%OUTDEF%%.temp"^)
echo exit /b
echo.
rem ------------------------------
echo :COUNTLINE
echo set /a COUNTTXTLINE=%%COUNTTXTLINE%%+^1
echo set /a BLINE=%%COUNTTXTLINE%%-^1
echo set /a NLINE=%%COUNTTXTLINE%%+^1
echo rem 判定
echo set EDITA=0^&set EDITB=0^&set EDITC=^0
echo for /f "usebackq delims=" %%%%l in ^(`echo %%TXTLINE%% ^^^| find /c ^"[%%BLINE%%[^"`^) do ^(set EDITA=%%%%~l^)
echo for /f "usebackq delims=" %%%%l in ^(`echo %%TXTLINE%% ^^^| find /c ^"[%%COUNTTXTLINE%%[^"`^) do ^(set EDITB=%%%%~l^)
echo for /f "usebackq delims=" %%%%l in ^(`echo %%TXTLINE%% ^^^| find /c ^"[%%NLINE%%[^"`^) do ^(set EDITC=%%%%~l^)
echo exit /b
echo.
rem ------------------------------
echo :EDITDEFs
echo set CHKLINE=^0
echo for /f "usebackq delims=" %%%%l in ^(`echo %%1 ^^^| find ^"[^" ^^^| find ^"] ^" ^^^| find /v ^"set^" ^^^| find /v ^"=-^" ^^^| find /v ^" -^" ^^^| find /c ^"-^"`^) do ^(set CHKLINE=%%%%~l^)
echo if not "%%CHKLINE%%"=="1" ^(call :WRITEA "%%~1"^&exit /b^)
echo echo %%~1^> ".\tmp\EDITDEFt_tmp.txt"
echo rem `echo %%~1`表記が正常に動かないので中間ファイルを使用
echo rem for /f "usebackq tokens=1,2* delims=-[" %%%%l in ^(`echo %%~1`^) do ^(call :EDITDEFt "%%%%~l" "%%%%~m" "%%%%~n"^)
echo for /f "usebackq tokens=1,2* delims=-[" %%%%l in ^(.\tmp\EDITDEFt_tmp.txt^) do ^(call :EDITDEFt "%%%%~l" "%%%%~m" "%%%%~n"^)
echo if exist ".\tmp\EDITDEFt_tmp.txt" ^(del ".\tmp\EDITDEFt_tmp.txt"^)
echo exit /b
echo.
echo :WRITEA
echo echo %%~1^>^>"%%OUTDEF%%"
echo exit /b
echo.
rem ------------------------------
echo :EDITDEFt
echo if %%EDITA%% == 1 ^(set PARAMBa=%%EXLAST%%^) else ^(set PARAMBa=0^)
echo if %%EDITB%% == 1 ^(set PARAMA=%%EXBIGI%%^&set PARAMB=%%EXLAST%%^) else ^(set PARAMA=0^&set PARAMB=0^)
echo if %%COUNTTXTLINE%% == %%BIGILINE%% ^(set PARAMA=0^)
echo if %%COUNTTXTLINE%% == %%LASTLINE%% ^(set PARAMB=0^)
echo if %%EDITC%% == 1 ^(set PARAMAb=%%EXBIGI%%^) else ^(set PARAMAb=0^)
echo set /a EDITBIGI= 2*100%%~1 - %%PARAMA%% + %%PARAMBA%% - 200%%~1
echo set /a EDITLAST= 2*100%%~2 + %%PARAMB%% - %%PARAMAb%% - 200%%~2
echo set /a SPACEPOINT=%%SPACEPOINT%%+^1
echo if "%%SPACEPOINT%%"=="1" ^(echo.^>^>"%%OUTDEF%%"^)
echo echo %%EDITBIGI%%-%%EDITLAST%% [%%~3^>^>"%%OUTDEF%%"
echo exit /b
echo.
rem ------------------------------
echo :ReLOCATION
echo if "%%autovfr_mode%%"=="0" ^(
echo     move "main.def" ".\old\main_%%date:~0,4%%%%date:~5,2%%%%date:~8,2%%%%time:~0,2%%%%time:~3,2%%%%time:~6,2%%.def"
echo     move "%%OUTDEF%%" "main.def"
echo ^) else ^(
echo     move "main.def" ".\old\main_%%date:~0,4%%%%date:~5,2%%%%date:~8,2%%%%time:~0,2%%%%time:~3,2%%%%time:~6,2%%.def"
echo     move "%%OUTDEF%%" "main.def"
echo ^)
echo exit /b
rem ------------------------------
echo :autovfr_mode_detect
echo for /f "usebackq eol=# tokens=2 delims==" %%%%A in ^(`findstr /b /r autovfr_mode "parameter.txt"`^) do ^(
echo     if "%%%%A"=="0" ^(
echo         set autovfr_mode=^0
echo     ^) else if "%%%%A"=="1" ^(
echo         set autovfr_mode=^1
echo     ^) else ^(
echo         echo 不正なパラメータ指定です。デフォルトのAutoVfr^^^(Slow^^^)モードを使用します。
echo         set autovfr_mode=^0
echo     ^)
echo ^)
echo if "%%autovfr_mode%%"=="" ^(
echo     echo AutoVfrのモード指定が見つかりません。デフォルトのAutoVfr^^^(Slow^^^)モードを使用します。
echo     set autovfr_mode=^0
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :autovfr_deint_detect
echo for /f "usebackq eol=# tokens=2 delims==" %%%%A in ^(`findstr /b /r autovfr_deint "parameter.txt"`^) do ^(
echo     if "%%%%A"=="0" ^(
echo         set autovfr_deint=^0
echo     ^) else if "%%%%A"=="1" ^(
echo         set autovfr_deint=^1
echo     ^) else ^(
echo         echo 不正なパラメータ指定です。デフォルトの自動デインターレースモードを使用します。
echo         set autovfr_deint=^0
echo     ^)
echo ^)
echo if "%%autovfr_deint%%"=="" ^(
echo     echo AutoVfrのデインターレース指定が見つかりません。デフォルトの自動デインターレースモードを使用します。
echo     set autovfr_deint=^0
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :autovfr_threadnum_detect
echo rem # 正規表現判定の結果で得られるエラーレベルによってパラメーターの指定が正しいか否か判定します。
echo rem # バッチファイルで数値かどうか判定したいので…（続き） - アセトアミノフェンの気ままな日常
echo rem # http://d.hatena.ne.jp/acetaminophen/20150809/1439150912
echo for /f "usebackq eol=# tokens=2 delims==" %%%%T in ^(`findstr /b /r autovfr_thread_num "parameter.txt"`^) do ^(
echo     set thread_tmp_num=%%%%T
echo     echo %%%%T^| findstr /x /r "^[+-]*[0-9]*[\.]*[0-9]*$" 1^>nul
echo ^)
echo if "%%ERRORLEVEL%%"=="0" ^(
echo     if not "%%thread_tmp_num%%"=="" ^(
echo         echo AutoVfrの実行スレッド数 %%thread_tmp_num%% です。
echo         set autovfr_thread_num=%%thread_tmp_num%%
echo     ^) else ^(
echo         echo AutoVfrの実行スレッド数が未指定かパラメーター指定そのものが見つかりません。代わりにシステムの論理CPU数 %%Number_Of_Processors%% を使用します。
echo         set autovfr_thread_num=%%Number_Of_Processors%%
echo     ^)
echo ^) else if "%%ERRORLEVEL%%"=="1" ^(
echo     echo AutoVfrの実行スレッド数の指定かパラメーター正しい値ではありません。代わりにシステムの論理CPU数 %%Number_Of_Processors%% を使用します。
echo     set autovfr_thread_num=%%Number_Of_Processors%%
echo ^)
echo set thread_tmp_num=
echo exit /b
echo.
rem ------------------------------
echo :toolsdircheck
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 環境変数 ENCTOOLSROOTPATH が未定義です
echo     exit /b
echo ^)
)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%ENCTOOLSROOTPATH%\>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
(
echo if exist "%%ENCTOOLSROOTPATH%%" ^(
echo     exit /b
echo ^) else ^(
echo     echo 環境変数ENCTOOLSROOTPATHが有効なパスではありません
echo     set ENCTOOLSROOTPATH=
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :autovfr_param_check
echo rem # Autovfr.ini内部のtxt_area_Tを検出する
echo call :crop_height_search
echo rem # パラメーターファイル内探索
echo for /f "usebackq eol=# tokens=1 delims=" %%%%A in ^(`findstr /b autovfr_setting "parameter.txt"`^) do ^(
echo     set %%%%A
echo ^)
echo if "%%autovfr_setting%%"=="" ^(
echo     echo ※AutoVfrのパラメーターをが見つかりません、代替値をセットします
echo     set autovfr_setting=cthresh=80, mi=60, blockx=16, blocky=32, chroma=false, IsCrop=true, crop_height=92^0
echo ^)
echo set autovfr_setting=%%autovfr_setting:,=","%%
echo call :autovfr_setting_shape_phase "%%autovfr_setting%%"
echo rem # Auto_Vfr_Fast用オプションはAuto_Vfr用オプションから関係ないものを除く
echo set autovfr_setting_normal=%%autovfr_setting_gen%%%%autovfr_setting_opt%%
echo set autovfr_setting_normal=%%autovfr_setting_normal:~0,-2%%
echo set autovfr_setting_fast=%%autovfr_setting_gen:~0,-2%%
echo exit /b
echo.
rem ------------------------------
echo :autovfr_setting_shape_phase
echo set iscrop_true_flag=^0
echo set crop_height_detect_flag=^0
echo set autovfr_setting_gen=
echo set autovfr_setting_opt=
echo set autovfr_setting_uni=%%~^1
echo :autovfr_setting_param_shap_loop
echo set autovfr_setting_uni=%%autovfr_setting_uni: =%%
echo if "%%autovfr_setting_uni:~0,6%%"=="IsCrop" ^(
echo     set autovfr_setting_opt=%%autovfr_setting_opt%%%%~1, 
echo     if "%%autovfr_setting_uni%%"=="IsCrop=true" ^(
echo         set /a iscrop_true_flag=iscrop_true_flag+^1
echo     ^)
echo ^) else if "%%autovfr_setting_uni:~0,11%%"=="crop_height" ^(
echo     set autovfr_setting_opt=%%autovfr_setting_opt%%%%crop_height_param%%, 
echo     set /a crop_height_detect_flag=crop_height_detect_flag+^1
echo ^) else ^(
echo     set autovfr_setting_gen=%%autovfr_setting_gen%%%%autovfr_setting_uni%%, 
echo ^)
echo shift /^1
echo set autovfr_setting_uni=%%~^1
echo if not "%%autovfr_setting_uni%%"=="" ^(
echo     goto :autovfr_setting_param_shap_loop
echo ^)
echo if %%iscrop_true_flag%% GEQ 1 ^(
echo     if %%crop_height_detect_flag%% LSS 1 ^(
echo         set autovfr_setting_opt=%%autovfr_setting_opt%%%%crop_height_param%%, 
echo     ^)
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :crop_height_search
echo set crop_height_param=
echo for /f "usebackq eol=# tokens=1 delims=" %%%%C in ^(`findstr txt_area_T "AutoVfr.ini"`^) do ^(
echo     set func_6to2_LINE=%%%%C
echo ^)
echo call :crop_height_value_detec %%func_6to2_LINE%%
echo if "%%crop_height_value%%"=="" ^(
echo     echo "AutoVfr.ini"内に有効な"txt_area_T"が見つかりませんでした。代わりに暫定値920を設定します。
echo     set crop_height_param=crop_height=92^0
echo ^) else ^(
echo     set crop_height_param=crop_height=%%crop_height_value%%
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :crop_height_value_detec
echo if "%%~1"=="txt_area_T" ^(
echo     set crop_height_value=%%~^2
echo     exit /b
echo ^) else if "%%~1"=="" ^(
echo     exit /b
echo ^) else ^(
echo     shift /^1
echo     goto :crop_height_value_detec
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :project_name_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(
echo     set %%%%P
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :deinterlace_filter_flag_detect
echo for /f "usebackq eol=# tokens=1 delims=" %%%%D in ^(`findstr /b /r deinterlace_filter_flag "parameter.txt"`^) do ^(
echo     set %%%%D
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :mpeg2dec_select_flag_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%M in ^(`findstr /b /r mpeg2dec_select_flag "parameter.txt"`^) do ^(
echo     set %%%%M
echo ^)
echo if "%%mpeg2dec_select_flag%%"=="" ^(
echo     echo ※MPEG-2デコーダーの指定が見つかりません, MPEG2 VFAPI Plug-Inを使用します
echo     set mpeg2dec_select_flag=^1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_avs2pipe
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     set avs2pipe_path=%%~nx1
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set avs2pipe_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo     call :avspipe_env_search %%~nx1
echo ^)
echo exit /b
echo :avspipe_env_search
echo set avs2pipe_path=%%~$PATH:1
echo if "%%avs2pipe_path%%"=="" ^(
echo     echo avs2pipeが見つかりません
echo     set avs2pipe_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_autovfr
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     set autovfr_path=%%~nx1
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set autovfr_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。AutoVfr.exeは絶対パス指定をしないとiniファイルの読み込みに失敗しますので必須^(ver0.1.1.1^)。
echo     call :autovfr_env_search %%~nx1
echo ^)
echo exit /b
echo :autovfr_env_search
echo set autovfr_path=%%~$PATH:1
echo if "%%autovfr_path%%"=="" ^(
echo    echo AutoVfrが見つかりません
echo     set autovfr_path=%%~1
echo ^)
echo exit /b
echo.
)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
exit /b

:find_autovfr_dir
if exist "%~1" (
    if exist "%~dp1AutoVfr.ini" (
        copy "%~dp1AutoVfr.ini" "%work_dir%%main_project_name%\"
    )
)
if not exist "%work_dir%%main_project_name%\AutoVfr.ini" (
    echo AutoVfr.iniが存在しません。代わりのデフォルト設定のファイルを作成します。
    echo Func_24fps  =TIVTC24P_tv2^(^)>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo Func_30fps  =IT^(fps=30^)>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo Func_60fps  =TDeint^(mode=1,edeint=last.nnedi3^(field=-2^),emask=last.TMM^(mode=1^)^)>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo Func_6to2   =txt60mcHybrid^(int_ref,draft=true,txt_area_T=942,txt_area_B=1020,show=true^)>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo Mode_6to2   =24>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo Func_Append =>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo.>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo # Var for EasyVFR>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo Var_Trim    =c>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo Var_EasyVFR =result>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo Var_Loop    =fc>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo Var_Time    =tcpath>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo Var_Ref     =int_ref>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo.>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo # Var for Its>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo Var_Def24   =f24>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo Var_Def30   =f30>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo Var_Def60   =f60>> "%work_dir%%main_project_name%\AutoVfr.ini"
    echo Var_Def6to2 =txt60mc>> "%work_dir%%main_project_name%\AutoVfr.ini"
)
exit /b

:space_blank_del
rem # プロジェクト名の末尾の半角スペースを削除
set main_project_name=%main_project_name:~0,-1%
exit /b

:get_upperdir_path
rem # 入力されたファイルのパスと上位ディレクトリ名を取得する擬似関数
rem # 入力ファイルがAVSの場合に使用
set avs_upperdir_path=%~dp1
set avs_upperdir_name=%~n1
exit /b

:other_projectname_detect
rem # 入力ファイルがavs以外の場合のプロジェクト名決定擬似関数
set main_project_name=%~n1
exit /b

:avs_projectname_detect
rem # 入力ファイルがavsの場合のプロジェクト名決定擬似関数
set main_project_name=%avs_upperdir_name%
exit /b

:Type_KeyIn
rem # KeyInを使ったプロジェクト名設定、他の擬似関数より呼び出し
echo ※任意の名前に編集してください
"%KeyIn_path%" %main_project_name%
set /p new_project_name=type.
set main_project_name=%new_project_name%
exit /b

:noType_KeyIn
rem # KeyInを使わないプロジェクト名設定、他の擬似関数より呼び出し
echo ※ソースファイルの後ろに追加する文字を入力してください
set /p new_project_name=type.
set avs_project_name=%~n1%new_project_name%
exit /b

:over_write_select
rem # 既にファイルが存在していた場合にどう処理するかをユーザーに尋ねる擬似関数
rem # if文やfor文の()の中では環境変数が即時展開されるためこのように一度外部に逃げてから判定する
rem # ここはかなり特殊な擬似関数(ラベル)で、行きと帰りをgotoコマンドで行うことが必須となる
echo.
echo 既にAVSファイルが存在します、どうしますか？
echo 1. 上書き
echo 2. 別名で作成
echo 3. 既存のAVSスクリプトを流用
echo 0. 中止
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="1" (
    echo 上書きします
    goto :esc_checkexist_avsfile
) else if "%choice%"=="2" (
    :make_newproject
    echo.
    echo ### ソースファイルとは別の名前でAVSファイルを作成します ###
    if "%use_NetFramework_switch%"=="1" (
        call :Type_KeyIn
    ) else (
        call :noType_KeyIn
    )
    goto :space_blank_checker
) else if "%choice%"=="3" (
    set already_avs_detect_flag=1
    goto :esc_checkexist_avsfile
) else if "%choice%"=="0" (
    goto :parameter_shift
) else (
    rem 不正な入力
    echo 正しい値を選択してください！
    goto :over_write_select
)
goto :space_blank_checker
exit /b

:copy_avssrc_dir
rem ### ソースがavsの場合、そのavsがあるディレクトリをコピーするための擬似関数
rem # コピー元とコピー先のディレクトリが同じかどうかの比較
if "%avs_upperdir_path%"=="%work_dir%" (
    echo ※AVSファイルのコピー元とコピー先のディレクトリが同一です
) else (
    call :xcopy_phase "%~1"
)
exit /b

:xcopy_phase
echo xcopy先："%work_dir%%main_project_name%\"
set /p choice=%avs_upperdir_name% ディレクトリをコピーします、よろしいですか？^(y/n^)
if "%choice%"=="" set choice=n
if "%choice%"=="y" (
    call :run_xcopy_action "%~1"
)
if "%choice%"=="1" (
    call :run_xcopy_action "%~1"
)
exit /b

:run_xcopy_action
rem # ディレクトリの複製、一部の拡張子を除外設定
rem # xcopyコマンドで送り側に指定するディレクトリは末尾"\"不可。よって調整
set xcopydir_path=%~dp1
echo .bat> "ex.txt"
echo .ts>> "ex.txt"
echo .dv>> "ex.txt"
echo .wav>> "ex.txt"
echo .aac>> "ex.txt"
echo .mp4>> "ex.txt"
echo .m4a>> "ex.txt"
xcopy "%xcopydir_path:~0,-1%" "%work_dir%%main_project_name%\" /EXCLUDE:ex.txt
del "ex.txt"
rem exit /b


:copy_lgd_file_phase
rem # %lgd_file_src_path%ディレクトリの中から放送局名を含むロゴファイル(.lgd)を再帰的に見つけ出して、workディレクトリ内のlgdディレクトリにコピーします
rem # 万一ファイル名に半角カッコが含まれていると誤作動するので、call文を使用し外部関数を呼び出します。
rem # 対象となる.lgdファイルはtsrenamecで抽出した放送局名に合致したファイル名を持つものになりますので、命名則に気を付けてください
set lgd_file_counter=0
rem # バッチモード指定で明示的にロゴファイルが決められている場合、該当する放送局のロゴファイル抽出は行わない
if exist "%bat_lgd_file_path%" (
    call :broadcaster_lgd_copy_phase "%bat_lgd_file_path%"
    exit /b
)
for /f "usebackq delims=" %%B in (`%tsrenamec_path% "%~1" @CH`) do (
    call :set_broadcaster_name_phase "%%B"
)
if "%src_broadcaster_name%"=="" (
    echo 放送局名が判別できません
) else (
    echo 放送局："%src_broadcaster_name%"
    rem # ファイルを検出する際forfilesコマンドを使うと出力されたファイル名の両端にダブルクォーテーションが強制的に付加されて操作しづらいので不採用
    rem # [^\\]はディレクトリを含まない正規表現、$は末尾を表す正規表現
    for /f "usebackq delims=" %%L in (`dir /A-D /B /S "%lgd_file_src_path%" ^| findstr ".*%src_broadcaster_name%.*.lgd[^\\]*$"`) do (
        call :broadcaster_lgd_copy_phase "%%L"
    )
)
if "%lgd_file_counter%"=="0" (
    echo 適合するロゴファイルが見つかりませんでした
)
exit /b

:set_broadcaster_name_phase
set src_broadcaster_name=%~nx1
exit /b

:broadcaster_lgd_copy_phase
rem # 最初に渡されたファイルをメインのロゴファイルとして使用します。
if "%lgd_file_counter%"=="0" (
    call :set_main_lgd_file_name "%~1"
)
set /a lgd_file_counter=lgd_file_counter+1
echo ロゴファイル%lgd_file_counter%：%~nx1
copy "%~1" "%work_dir%%main_project_name%\lgd\"> nul
exit /b

:set_main_lgd_file_name
rem # メインのロゴファイルはparameterファイルに記録されます
set lgd_file_name=%~nx1
exit /b

:copy_JL_file_phase
rem # カット処理方法スクリプト(JL)をコピーする
rem # 通常は%JL_file_name%で指定したデフォルトファイルを使用するが、オプション指定された場合は別のスクリプトも使用可能
if "%JL_src_file_full-path%"=="" (
    set JL_src_file_full-path=%JL_src_dir%%JL_file_name%
)
echo カット処理方法スクリプト：%JL_src_file_full-path%
if not exist "%JL_src_file_full-path%" (
    echo カット処理方法スクリプト^(JL^)が存在しません、処理をスキップします
) else (
    copy "%JL_src_file_full-path%" "%work_dir%%main_project_name%\JL\"> nul
    call :fix_JL_file_name_phase "%JL_src_file_full-path%"
)
exit /b
:fix_JL_file_name_phase
set JL_file_name=%~nx1
exit /b


:bat_video_resolution_detect
rem # バッチモードの際の未決定パラメーター(リサイズ指定に伴う解像度、アス比の指定)を決定する
if "%src_video_wide_pixel%"=="" (
    echo MediaInfoCによる横解像度検出が見つかりませんでした、地上波放送で一般的な1440を設定します。
    set src_video_wide_pixel=1440
)
if "%src_video_hight_pixel%"=="" (
    echo MediaInfoCによる縦解像度検出が見つかりませんでした、地上波放送で一般的な1080を設定します。
    set src_video_hight_pixel=1080
)
if "%src_video_pixel_aspect_ratio%"=="" (
    echo MediaInfoCによるアスペクト比検出が見つかりませんでした。
    if "%src_video_wide_pixel%"=="1440" (
        echo 横解像度が 1440 の為、アスペクト比 1.333 を設定します。
        set src_video_pixel_aspect_ratio=1.333
    ) else if "%src_video_wide_pixel%"=="1920" (
        echo 横解像度が 1920 の為、アスペクト比 1.000 を設定します。
        set src_video_pixel_aspect_ratio=1.000
    ) else if "%src_video_wide_pixel%"=="720" (
        echo 横解像度が 720 の為、アスペクト比 1.212 を設定します。
        set src_video_pixel_aspect_ratio=1.212
    ) else (
        echo 横解像度が不明の為、アスペクト比 1.000 を設定します。
        set src_video_pixel_aspect_ratio=1.000
    )
)
rem # リサイズ処理未指定、もしくはソースビデオの縦解像度がバッチモードのリサイズ指定以下の場合はリサイズ処理を実施しない
if "%bat_vresize_flag%"=="none" (
    echo ※リサイズ処理未指定の為、リサイズ処理を実施しません
    call :bat_none-vresize_phase
) else if not "%bat_vresize_flag%"=="custom" (
    if %src_video_hight_pixel% LEQ %bat_vresize_flag% (
        echo ※ソースビデオの縦解像度がリサイズ指定以下の為、リサイズ処理を実施しません
        call :bat_none-vresize_phase
    ) else (
        if "%bat_vresize_flag%"=="1080" (
            set videoAspectratio_option=video_par1x1_option
            set resize_wpix=1920
            set resize_hpix=1080
        ) else if "%bat_vresize_flag%"=="900" (
            set videoAspectratio_option=video_par1x1_option
            set resize_wpix=1600
            set resize_hpix=900
        ) else if "%bat_vresize_flag%"=="810" (
            set videoAspectratio_option=video_par1x1_option
            set resize_wpix=1440
            set resize_hpix=810
        ) else if "%bat_vresize_flag%"=="720" (
            set videoAspectratio_option=video_par1x1_option
            set resize_wpix=1280
            set resize_hpix=720
        ) else if "%bat_vresize_flag%"=="540" (
            set videoAspectratio_option=video_par1x1_option
            set resize_wpix=960
            set resize_hpix=540
        ) else if "%bat_vresize_flag%"=="480" (
            set videoAspectratio_option=video_par40x33_option
            set resize_wpix=704
            set resize_hpix=480
        ) else if "%bat_vresize_flag%"=="270" (
            set videoAspectratio_option=video_par1x1_option
            set resize_wpix=480
            set resize_hpix=270
        )
    )
)
if %resize_hpix% LEQ 272 (
    set avs_filter_type=272p_template
) else if %resize_hpix% LEQ 480 (
    set avs_filter_type=480p_template
) else if %resize_hpix% LEQ 540 (
    set avs_filter_type=540p_template
) else if %resize_hpix% LEQ 720 (
    set avs_filter_type=720p_template
) else (
    set avs_filter_type=1080p_template
)
rem # bat_vresize_flag=custom の場合ピクセル比がブランクなので、1:1で埋める
if "%videoAspectratio_option%"=="" (
    set videoAspectratio_option=video_par1x1_option
)
exit /b
:bat_none-vresize_phase
if "%src_video_hight_pixel%"=="1080" (
    set avs_filter_type=1080p_template
    set resize_hpix=1080
    if "%src_video_pixel_aspect_ratio%"=="1.333" (
        set videoAspectratio_option=video_par4x3_option
        set resize_wpix=1440
    ) else if "%src_video_pixel_aspect_ratio%"=="1.000" (
        set videoAspectratio_option=video_par1x1_option
        set resize_wpix=1920
    )
) else if "%src_video_hight_pixel%"=="480" (
    set avs_filter_type=480p_template
    set resize_wpix=704
    set resize_hpix=480
    if "%src_video_pixel_aspect_ratio%"=="1.212" (
        set videoAspectratio_option=video_par40x33_option
    ) else if "%src_video_pixel_aspect_ratio%"=="0.909" (
        set videoAspectratio_option=video_par10x11_option
    )
)
exit /b


:manual_job_settings
rem ### 手動で各項目を設定する場合の擬似関数、通常template_job_selectから呼び出す
echo.
echo ### %main_project_name% を手動で設定します ###
echo 1. 1080i ソース
echo 2. 720×480i(16:9) ソース
echo 3. 720×480i(4:3)  ソース
echo 0. TsSplitter を通す
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="" (
    echo 選択してください！
    goto :manual_job_settings
) else if "%choice%"=="1" (
    rem 1. 1080i ソース
    set tssplitter_opt_param=
    call :1080input_edit_selector
    exit /b
) else if "%choice%"=="2" (
    rem 2. 720×480i(16:9) ソース
    set tssplitter_opt_param=
    set avs_filter_type=480p_template
    set src_video_wide_pixel=720
    set crop_size_flag=none
    set videoAspectratio_option=video_par40x33_option
    exit /b
) else if "%choice%"=="3" (
    rem 3. 720×480i(4:3)  ソース
    set tssplitter_opt_param=
    set avs_filter_type=480p_template
    set src_video_wide_pixel=720
    set crop_size_flag=none
    set videoAspectratio_option=video_par10x11_option
    exit /b
) else if "%choice%"=="0" (
    rem 0. TsSplitter を通す
    if "%~x1"==".ts" (
        call :TsSplitter_phase "%~1"
    ) else (
        echo ※MPEG-2 TSファイルではありません
        goto :manual_job_settings
    )
    exit /b
) else (
    rem 不正な入力
    echo 正しい値を選択してください！
    goto :manual_job_settings
)
exit /b

:TsSplitter_phase
rem ### 事前にTsSplitterを通す場合の擬似関数、通常:manual_job_settingsから呼び出す
echo ### TsSplitterで分離後のファイル名の末尾につく文字列を指定してください[HD] [SD] ###
set split_type=
set /p split_type=%~n1_
if "%split_type:~0,2%"=="HD" (
    set tssplitter_opt_param=-EIT -ECM -EMM -SEPAC -SD -1SEG 
    call :1080input_edit_selector
) else if "%split_type:~0,2%"=="SD" (
    set tssplitter_opt_param=-EIT -ECM -EMM -SEPAC -HD -1SEG 
    set avs_filter_type=480p_template
    set src_video_wide_pixel=720
    call :480input_edit_selector
) else (
    set tssplitter_opt_param=-EIT -ECM -EMM -SEPAC -SD -1SEG 
    call :1080input_edit_selector
)
exit /b

:1080input_edit_selector
rem # 1080i入力の場合に、どのように編集するか決定
rem # ここに--sarオプションのフラグをつける(1080pの場合はこの次で)
echo.
echo ### どのように編集しますか？ ###
echo 1.  フルワイド → 1080 出力
echo 2.  フルワイド → 900  出力
echo 3.  フルワイド → 810  出力
echo 4.  フルワイド → 720  出力
echo 5.  フルワイド → 540  出力
echo 6.  フルワイド → 16:9 480出力
echo 7. サイドカット→ 4:3  480出力
echo 8.    超額縁   → 16:9 480出力
echo 9.  フルワイド → PSP(270p)出力
echo 10.サイドカット→ PSP(270p)出力
echo 11.   超額縁   → PSP(270p)出力
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="" (
    echo 選択してください！
    goto :1080input_edit_selector
) else if "%choice%"=="1" (
    rem 1.  フルワイド → 1080 出力
    set avs_filter_type=1080p_template
    set crop_size_flag=none
    if "%src_video_wide_pixel%"=="1440" (
        set videoAspectratio_option=video_par4x3_option
        set resize_wpix=1440
    ) else if "%src_video_wide_pixel%"=="1920" (
        set videoAspectratio_option=video_par1x1_option
        set resize_wpix=1920
    ) else (
        call :HDvideo_wideselector
    )
    set resize_hpix=1080
    set bat_vresize_flag=none
    exit /b
) else if "%choice%"=="2" (
    rem 2.  フルワイド → 900  出力
    set avs_filter_type=1080p_template
    set crop_size_flag=none
    set videoAspectratio_option=video_par1x1_option
    set resize_wpix=1600
    set resize_hpix=900
    exit /b
) else if "%choice%"=="3" (
    rem 3.  フルワイド → 810  出力
    set avs_filter_type=1080p_template
    set crop_size_flag=none
    set videoAspectratio_option=video_par1x1_option
    set resize_wpix=1440
    set resize_hpix=810
    exit /b
) else if "%choice%"=="4" (
    rem 4.  フルワイド → 720  出力
    set avs_filter_type=720p_template
    set crop_size_flag=none
    set videoAspectratio_option=video_par1x1_option
    set resize_wpix=1280
    set resize_hpix=720
    exit /b
) else if "%choice%"=="5" (
    rem 5.  フルワイド → 540  出力
    set avs_filter_type=540p_template
    set crop_size_flag=none
    set videoAspectratio_option=video_par1x1_option
    set resize_wpix=960
    set resize_hpix=540
    exit /b
) else if "%choice%"=="6" (
    rem 6.  フルワイド → 16:9 480出力
    set avs_filter_type=480p_template
    set crop_size_flag=none
    set videoAspectratio_option=video_par40x33_option
    set resize_wpix=704
    set resize_hpix=480
    exit /b
) else if "%choice%"=="7" (
    rem 7. サイドカット→ 4:3  480出力
    set avs_filter_type=480p_template
    set crop_size_flag=sidecut
    set videoAspectratio_option=video_par10x11_option
    if "%src_video_wide_pixel%"=="" (
        call :HDvideo_wideselector
    )
    set resize_wpix=704
    set resize_hpix=480
    exit /b
) else if "%choice%"=="8" (
    rem 8.    超額縁   → 16:9 480出力
    set avs_filter_type=480p_template
    set crop_size_flag=gakubuchi
    set videoAspectratio_option=video_par40x33_option
    if "%src_video_wide_pixel%"=="" (
        call :HDvideo_wideselector
    )
    set resize_wpix=704
    set resize_hpix=480
    exit /b
) else if "%choice%"=="9" (
    rem 9.  フルワイド → PSP(270p)出力
    set avs_filter_type=272p_template
    set crop_size_flag=none
    set videoAspectratio_option=video_par1x1_option
    set resize_wpix=480
    set resize_hpix=270
    exit /b
) else if "%choice%"=="10" (
    rem 10.サイドカット→ PSP(270p)出力
    set avs_filter_type=PSP_square_template
    set crop_size_flag=sidecut
    set videoAspectratio_option=video_par1x1_option
    if "%src_video_wide_pixel%"=="" (
        call :HDvideo_wideselector
    )
    set resize_wpix=480
    set resize_hpix=270
    exit /b
) else if "%choice%"=="11" (
    rem 11.   超額縁   → PSP(270p)出力
    set avs_filter_type=272p_template
    set crop_size_flag=gakubuchi
    set videoAspectratio_option=video_par1x1_option
    if "%src_video_wide_pixel%"=="" (
        call :HDvideo_wideselector
    )
    set resize_wpix=480
    set resize_hpix=270
    exit /b
) else (
    rem 不正な入力
    echo 正しい値を選択してください！
    goto :1080input_edit_selector
)
exit /b

:480input_edit_selector
echo 未作成
exit /b


:HDvideo_wideselector
rem # 入力されるファイルの水平解像度を入力
rem # 出力がHD解像度の場合、入力解像度を維持したまま出力するビデオのアスペクト比情報を付与します
rem # 先に使用したMediaInfo CLIで検出された解像度が有効であれば手動で選択はしません
echo.
echo ### 入力されるHDファイルの水平解像度を選択してください ###
echo 1. 1440
echo 2. 1920
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="" (
    echo 選択してください！
    goto :HDvideo_wideselector
) else if "%choice%"=="1" (
    set src_video_wide_pixel=1440
    if "%avs_filter_type%"=="1080p_template" (
        set videoAspectratio_option=video_par4x3_option
        set resize_wpix=1440
    )
) else if "%choice%"=="2" (
    set src_video_wide_pixel=1920
    if "%avs_filter_type%"=="1080p_template" (
        set videoAspectratio_option=video_par1x1_option
        set resize_wpix=1920
    )
) else (
    rem 不正な入力
    echo 正しい値を選択してください！
    goto :HDvideo_wideselector
)
exit /b

:deinterlace_filter_selector
rem # どのようにインターレース解除するかの選択
echo.
echo ### インターレース解除モードを選択してください ###
echo 1. 自動24fps(IT)
echo 2. 自動30fps(IT)
echo 3. 手動インターレース解除(Its)
echo 4. 可変フレームレート出力(itvfr+Its)
echo 5. Bob化
echo 6. インターレース維持
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="" (
    echo 選択してください！
    goto :deinterlace_filter_selector
) else if "%choice%"=="1" (
    set deinterlace_filter_flag=24fps
) else if "%choice%"=="2" (
    set deinterlace_filter_flag=30fps
) else if "%choice%"=="3" (
    set deinterlace_filter_flag=Its
) else if "%choice%"=="4" (
    set deinterlace_filter_flag=itvfr
) else if "%choice%"=="5" (
    set deinterlace_filter_flag=bob
) else if "%choice%"=="6" (
    set deinterlace_filter_flag=interlace
) else (
    rem 不正な入力
    echo 正しい値を選択してください！
    goto :deinterlace_filter_selector
)
if "%deinterlace_filter_flag%"=="Its" (
    call :autovfr_mode_selector
) else (
    set autovfr_mode=0
)
exit /b


:autovfr_mode_selector
echo.
echo ### AutoVFRのモードを選択してください ###
echo 1. AutoVFR
echo 2. AutoVFR_Fast
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="1" (
    set autovfr_mode=0
) else if "%choice%"=="2" (
    set autovfr_mode=1
) else (
    rem 不正な入力
    echo 正しい値を選択してください！
    goto :autovfr_mode_selector
)
exit /b

:vfr_rate_selecter
rem # フレームレートの判定
echo.
if "%deinterlace_filter_flag%"=="Its" (
    echo インターレース解除にItsを使用します^(出力フレームレート不定^)
    call :peak_rate_selecter
) else if "%deinterlace_filter_flag%"=="=24fps" (
    echo 出力フレームレートは24fpsです
) else if "%deinterlace_filter_flag%"=="30fps" (
    echo 出力フレームレートは30fpsです
) else if "%deinterlace_filter_flag%"=="bob" (
    echo 出力フレームレートは60fpsです
)
exit /b

:peak_rate_selecter
rem # 映像のフレームレートが可変の場合、ピーク時のレートを指定する
echo ### エンコードする際のピークフレームレートを選択してください ###
echo 1. 30.0fps
echo 2. 60.0fps
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="1" (
    set vfr_peak_rate=30fps
) else if "%choice%"=="2" (
    set vfr_peak_rate=60fps
) else (
    echo 選択してください！
    goto :peak_rate_selecter
)
exit /b


:video_job_selector
rem # ビデオエンコーディングのフォーマットを選択
echo.
echo ### 映像のエンコード方式を選択してください ###
echo 1. H.264/AVC  (x264)
echo 2. H.265/HEVC (x265)
echo 3. H.264/AVC  (QSVEncC)
echo 4. H.265/HEVC (QSVEncC)
echo 5. H.264/AVC  (NVEncC)
echo 6. H.265/HEVC (NVEncC)
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="" (
    echo 選択してください！
    goto :video_job_selector
) else if "%choice%"=="1" (
    set video_encoder_type=x264
) else if "%choice%"=="2" (
    set video_encoder_type=x265
) else if "%choice%"=="3" (
    set video_encoder_type=qsv_h264
) else if "%choice%"=="4" (
    set video_encoder_type=qsv_hevc
) else if "%choice%"=="5" (
    set video_encoder_type=nvenc_h264
) else if "%choice%"=="6" (
    set video_encoder_type=nvenc_hevc
) else (
    rem 不正な入力
    echo 正しい値を選択してください！
    goto :video_job_selector
)
exit /b

:audio_job_selector
rem # 音声処理方式を選択
echo.
echo ### 音声の処理方式を選択してください ###
echo 1. FakeAacWav(faw)
echo 2. 二ヶ国語音声(sox)
echo 3. ステレオ再エンコード(nero)
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="" (
    echo 選択してください！
    goto :audio_job_selector
) else if "%choice%"=="1" (
    set audio_job_flag=faw
) else if "%choice%"=="2" (
    set audio_job_flag=sox
) else if "%choice%"=="3" (
    set audio_job_flag=nero
) else (
    rem 不正な入力
    echo 正しい値を選択してください！
    goto :audio_job_selector
)
exit /b


:make_previewfile_phase
rem ### ユーザーの入力した設定にしたがってavsファイルを作成する擬似関数
rem %work_dir%%main_project_name%にスクリプトを作成します
rem ----------
rem ### 素材のままプレビューする雛形スクリプトを作成(preview1_straight) ###
type nul > "%work_dir%%main_project_name%\preview1_straight.avs"
rem ----------
rem ### 素材にカット編集のみ適用した雛形スクリプトを作成(preview2_trimed) ###
type nul > "%work_dir%%main_project_name%\preview2_trimed.avs"
rem ----------
rem ### インターレス縞をプレビューし、周期設定を行う為の雛形スクリプトを作成(preview3_anticomb) ###
type nul > "%work_dir%%main_project_name%\preview3_anticomb.avs"
rem ----------
rem ### ビデオクリップに対する編集を適用済みの雛形スクリプトを作成(preview4_deinterlace) ###
type nul > "%work_dir%%main_project_name%\preview4_deinterlace.avs"
rem ----------
exit /b


:make_previewplugin_phase
rem # プラグイン読み込み部分
if "%importloardpluguin_flag%"=="1" (
    echo ##### プラグイン読み込み部分のインポート #####>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo Import^(".\avs\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo.>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo ##### プラグイン読み込み部分のインポート #####>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo Import^(".\avs\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo.>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo ##### プラグイン読み込み部分のインポート #####>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo Import^(".\avs\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo.>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo ##### プラグイン読み込み部分のインポート #####>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
    echo Import^(".\avs\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
    echo.>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
) else (
    copy /b "%work_dir%%main_project_name%\main.avs" + "%plugin_template%" "%work_dir%%main_project_name%\preview1_straight.avs"
    echo.>>"%work_dir%%main_project_name%\preview1_straight.avs"
    copy /b "%work_dir%%main_project_name%\main.avs" + "%plugin_template%" "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo.>>"%work_dir%%main_project_name%\preview2_trimed.avs"
    copy /b "%work_dir%%main_project_name%\main.avs" + "%plugin_template%" "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo.>>"%work_dir%%main_project_name%\preview3_anticomb.avs"
    copy /b "%work_dir%%main_project_name%\main.avs" + "%plugin_template%" "%work_dir%%main_project_name%\preview4_deinterlace.avs"
    echo.>>"%work_dir%%main_project_name%\preview4_deinterlace.avs"
)
exit /b


:load_mpeg2ts_preview
rem ### ソースのTSファイルをプレビューする為の読み込みフィルタを作成する擬似関数
echo ##### ソースファイル読み込み #####>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo ##### ソースファイル読み込み #####>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo ##### ソースファイル読み込み #####>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo ##### ソースファイル読み込み #####>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
if "%mpeg2dec_select_flag%"=="1" (
    echo Try { Try { Import^(".\avs\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = MPEG2VIDEO^(".\src\video1.ts"^).AssumeTFF^(^) } } catch^(err_msg^) { video1 = MPEG2VIDEO^("%~1"^).AssumeTFF^(^) }>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo #video2 = MPEG2VIDEO^("modclip.ts"^).AssumeTFF^(^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo video^1>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo Try { Try { Import^(".\avs\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = MPEG2VIDEO^(".\src\video1.ts"^).AssumeTFF^(^) } } catch^(err_msg^) { video1 = MPEG2VIDEO^("%~1"^).AssumeTFF^(^) }>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo #video2 = MPEG2VIDEO^("modclip.ts"^).AssumeTFF^(^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo video^1>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo Try { Try { Import^(".\avs\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = MPEG2VIDEO^(".\src\video1.ts"^).AssumeTFF^(^) } } catch^(err_msg^) { video1 = MPEG2VIDEO^("%~1"^).AssumeTFF^(^) }>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo #video2 = MPEG2VIDEO^("modclip.ts"^).AssumeTFF^(^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo video^1>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo Try { Try { Import^(".\avs\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = MPEG2VIDEO^(".\src\video1.ts"^).AssumeTFF^(^) } } catch^(err_msg^) { video1 = MPEG2VIDEO^("%~1"^).AssumeTFF^(^) }>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
    echo #video2 = MPEG2VIDEO^("modclip.ts"^).AssumeTFF^(^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
    echo video^1>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
) else if "%mpeg2dec_select_flag%"=="2" (
    echo Try { Try { Import^(".\avs\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = MPEG2Source^(".\src\video1..d2v",upconv=0^).ConvertToYUY2^(^) } } catch^(err_msg^) { video1 = MPEG2Source^("%~dpn1.d2v",upconv=0^).ConvertToYUY2^(^) }>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo #video2 = MPEG2Source^("modclip.ts"^).AssumeTFF^(^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo video^1>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo Try { Try { Import^(".\avs\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = MPEG2Source^(".\src\video1..d2v",upconv=0^).ConvertToYUY2^(^) } } catch^(err_msg^) { video1 = MPEG2Source^("%~dpn1.d2v",upconv=0^).ConvertToYUY2^(^) }>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo #video2 = MPEG2Source^("modclip.ts"^).AssumeTFF^(^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo video^1>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo Try { Try { Import^(".\avs\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = MPEG2Source^(".\src\video1..d2v",upconv=0^).ConvertToYUY2^(^) } } catch^(err_msg^) { video1 = MPEG2Source^("%~dpn1.d2v",upconv=0^).ConvertToYUY2^(^) }>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo #video2 = MPEG2Source^("modclip.ts"^).AssumeTFF^(^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo video^1>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo Try { Try { Import^(".\avs\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = MPEG2Source^(".\src\video1..d2v",upconv=0^).ConvertToYUY2^(^) } } catch^(err_msg^) { video1 = MPEG2Source^("%~dpn1.d2v",upconv=0^).ConvertToYUY2^(^) }>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
    echo #video2 = MPEG2Source^("modclip.ts"^).AssumeTFF^(^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
    echo video^1>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
) else if "%mpeg2dec_select_flag%"=="3" (
    echo Try { Try { Import^(".\avs\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = LWLibavVideoSource^(".\src\video1.ts", dr=false, repeat=true, dominance=0^) } } catch^(err_msg^) { video1 = LWLibavVideoSource^("%~1", dr=false, repeat=true, dominance=0^) }>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo video1 = video1.height^(^) == 1088 ? video1.Crop^(0, 0, 0, -8^) : video^1>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo #video2 = LWLibavVideoSource^("modclip.ts", dr=false, repeat=true, dominance=0^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo #video2 = video2.height^(^) == 1088 ? video2.Crop^(0, 0, 0, -8^) : video2>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo Try { Try { Import^(".\avs\LoadSrc_AudioPCM_1.avs"^) } catch^(err_msg^) { audio = LWLibavAudioSource^(".\src\video1.ts", stream_index=-1, av_sync=false, layout="stereo"^) } } catch^(err_msg^) { audio = LWLibavAudioSource^("%~1", stream_index=-1, av_sync=false, layout="stereo"^) }>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo AudioDub^(video1, audio^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo Try { Try { Import^(".\avs\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = LWLibavVideoSource^(".\src\video1.ts", dr=false, repeat=true, dominance=0^) } } catch^(err_msg^) { video1 = LWLibavVideoSource^("%~1", dr=false, repeat=true, dominance=0^) }>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo video1 = video1.height^(^) == 1088 ? video1.Crop^(0, 0, 0, -8^) : video^1>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo #video2 = LWLibavVideoSource^("modclip.ts", dr=false, repeat=true, dominance=0^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo #video2 = video2.height^(^) == 1088 ? video2.Crop^(0, 0, 0, -8^) : video2>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo Try { Try { Import^(".\avs\LoadSrc_AudioPCM_1.avs"^) } catch^(err_msg^) { audio = LWLibavAudioSource^(".\src\video1.ts", stream_index=-1, av_sync=false, layout="stereo"^) } } catch^(err_msg^) { audio = LWLibavAudioSource^("%~1", stream_index=-1, av_sync=false, layout="stereo"^) }>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo AudioDub^(video1, audio^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo Try { Try { Import^(".\avs\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = LWLibavVideoSource^(".\src\video1.ts", dr=false, repeat=true, dominance=0^) } } catch^(err_msg^) { video1 = LWLibavVideoSource^("%~1", dr=false, repeat=true, dominance=0^) }>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo video1 = video1.height^(^) == 1088 ? video1.Crop^(0, 0, 0, -8^) : video^1>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo #video2 = LWLibavVideoSource^("modclip.ts", dr=false, repeat=true, dominance=0^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo #video2 = video2.height^(^) == 1088 ? video2.Crop^(0, 0, 0, -8^) : video2>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo Try { Try { Import^(".\avs\LoadSrc_AudioPCM_1.avs"^) } catch^(err_msg^) { audio = LWLibavAudioSource^(".\src\video1.ts", stream_index=-1, av_sync=false, layout="stereo"^) } } catch^(err_msg^) { audio = LWLibavAudioSource^("%~1", stream_index=-1, av_sync=false, layout="stereo"^) }>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo AudioDub^(video1, audio^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo Try { Try { Import^(".\avs\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = LWLibavVideoSource^(".\src\video1.ts", dr=false, repeat=true, dominance=0^) } } catch^(err_msg^) { video1 = LWLibavVideoSource^("%~1", dr=false, repeat=true, dominance=0^) }>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
    echo video1 = video1.height^(^) == 1088 ? video1.Crop^(0, 0, 0, -8^) : video^1>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
    echo #video2 = LWLibavVideoSource^("modclip.ts", dr=false, repeat=true, dominance=0^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
    echo #video2 = video2.height^(^) == 1088 ? video2.Crop^(0, 0, 0, -8^) : video2>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
    echo Try { Try { Import^(".\avs\LoadSrc_AudioPCM_1.avs"^) } catch^(err_msg^) { audio = LWLibavAudioSource^(".\src\video1.ts", stream_index=-1, av_sync=false, layout="stereo"^) } } catch^(err_msg^) { audio = LWLibavAudioSource^("%~1", stream_index=-1, av_sync=false, layout="stereo"^) }>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
    echo AudioDub^(video1, audio^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
)
echo #KillAudio^(^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #video2=Adjust2clip^(video1,video2.BilinearResize^(1920, 1080^),0^)	#2つのクリップの開始位置を合わせる>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #stacksubtract^(video1,video2, 0, f1=4000, f2=15000, f3=33000^)	#開始フレームのズレを確認する関数>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #Delogo_BS11ANIMEP^(100^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #BS11overlay2^(last, video2, 100, 80, "logo"^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #BS11overlay2^(last, video2, 110, 90, "separate"^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #FreezeFrame^(100, 100, 101^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo.>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #KillAudio^(^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #video2=Adjust2clip^(video1,video2.BilinearResize^(1920, 1080^),0^)	#2つのクリップの開始位置を合わせる>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #stacksubtract^(video1,video2, 0, f1=4000, f2=15000, f3=33000^)	#開始フレームのズレを確認する関数>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #Delogo_BS11ANIMEP^(100^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #BS11overlay2^(last, video2, 100, 80, "logo"^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #BS11overlay2^(last, video2, 110, 90, "separate"^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #FreezeFrame^(100, 100, 101^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo.>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo KillAudio^(^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #video2=Adjust2clip^(video1,video2.BilinearResize^(1920, 1080^),0^)	#2つのクリップの開始位置を合わせる>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #stacksubtract^(video1,video2, 0, f1=4000, f2=15000, f3=33000^)	#開始フレームのズレを確認する関数>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #Delogo_BS11ANIMEP^(100^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #BS11overlay2^(last, video2, 100, 80, "logo"^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #BS11overlay2^(last, video2, 110, 90, "separate"^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #FreezeFrame^(100, 100, 101^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo.>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #KillAudio^(^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #video2=Adjust2clip^(video1,video2.BilinearResize^(1920, 1080^),0^)	#2つのクリップの開始位置を合わせる>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #stacksubtract^(video1,video2, 0, f1=4000, f2=15000, f3=33000^)	#開始フレームのズレを確認する関数>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #Delogo_BS11ANIMEP^(100^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #BS11overlay2^(last, video2, 100, 80, "logo"^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #BS11overlay2^(last, video2, 110, 90, "separate"^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #FreezeFrame^(100, 100, 101^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo.>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
exit /b


:avs_interlacebefore_privew
echo #//--- フィールドオーダー ---//>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo AssumeFrameBased^(^).ComplementParity^(^)	#トップフィールドが支配的>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #AssumeFrameBased^(^)			#ボトムフィールドが支配的>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #AssumeTFF^(^)				#トップファースト>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #AssumeBFF^(^)				#ボトムファースト>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #SeparateFields^(^)			#フィールドを分離>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo.>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #//--- クリップの操作 ---//>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #AlignedSplice^(clip clip1, clip clip2 [,...]^)	#演算子の++に相当するビデオクリップ結合フィルタ>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #UnalignedSplice^(clip clip1, clip clip2 [,...]^)	#演算子の+に相当するビデオクリップ結合フィルタ>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #FreezeFrame^(clip clip, int first-frame, int last-frame, int source-frame^)	#first-frameとlast-frameの間のすべてのフレームをsource-frameのコピーに置換。サウンドトラックは修正されません。>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #Try { Import^(".\avs\EraseLogo.avs"^) } catch(err_msg) { }	#半透過ロゴ除去>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo ExtErsLOGO^(logofile=".\lgd\%lgd_file_name%", start=0, end=-1, itype_s=0, itype_e=0, fadein=0, fadeout=0^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo.>> "%work_dir%%main_project_name%\preview1_straight.avs"
rem ----------
echo #//--- フィールドオーダー ---//>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo AssumeFrameBased^(^).ComplementParity^(^)	#トップフィールドが支配的>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #AssumeFrameBased^(^)			#ボトムフィールドが支配的>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #AssumeTFF^(^)				#トップファースト>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #AssumeBFF^(^)				#ボトムファースト>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #SeparateFields^(^)			#フィールドを分離>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo.>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #//--- クリップの操作 ---//>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #AlignedSplice^(clip clip1, clip clip2 [,...]^)	#演算子の++に相当するビデオクリップ結合フィルタ>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #UnalignedSplice^(clip clip1, clip clip2 [,...]^)	#演算子の+に相当するビデオクリップ結合フィルタ>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #FreezeFrame^(clip clip, int first-frame, int last-frame, int source-frame^)	#first-frameとlast-frameの間のすべてのフレームをsource-frameのコピーに置換。サウンドトラックは修正されません。>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #Try { Import^(".\avs\EraseLogo.avs"^) } catch(err_msg) { }	#半透過ロゴ除去>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo ExtErsLOGO^(logofile=".\lgd\%lgd_file_name%", start=0, end=-1, itype_s=0, itype_e=0, fadein=0, fadeout=0^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo.>> "%work_dir%%main_project_name%\preview2_trimed.avs"
rem ----------
echo #//--- フィールドオーダー ---//>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo AssumeFrameBased^(^).ComplementParity^(^)	#トップフィールドが支配的>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #AssumeFrameBased^(^)			#ボトムフィールドが支配的>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #AssumeTFF^(^)				#トップファースト>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #AssumeBFF^(^)				#ボトムファースト>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #SeparateFields^(^)			#フィールドを分離>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo.>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #//--- クリップの操作 ---//>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #AlignedSplice^(clip clip1, clip clip2 [,...]^)	#演算子の++に相当するビデオクリップ結合フィルタ>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #UnalignedSplice^(clip clip1, clip clip2 [,...]^)	#演算子の+に相当するビデオクリップ結合フィルタ>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #FreezeFrame^(clip clip, int first-frame, int last-frame, int source-frame^)	#first-frameとlast-frameの間のすべてのフレームをsource-frameのコピーに置換。サウンドトラックは修正されません。>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #Try { Import^(".\avs\EraseLogo.avs"^) } catch(err_msg) { }	#半透過ロゴ除去>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo ExtErsLOGO^(logofile=".\lgd\%lgd_file_name%", start=0, end=-1, itype_s=0, itype_e=0, fadein=0, fadeout=0^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo.>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
rem ----------
echo #//--- フィールドオーダー ---//>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo AssumeFrameBased^(^).ComplementParity^(^)	#トップフィールドが支配的>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #AssumeFrameBased^(^)			#ボトムフィールドが支配的>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #AssumeTFF^(^)				#トップファースト>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #AssumeBFF^(^)				#ボトムファースト>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #SeparateFields^(^)			#フィールドを分離>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo.>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #//--- クリップの操作 ---//>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #AlignedSplice^(clip clip1, clip clip2 [,...]^)	#演算子の++に相当するビデオクリップ結合フィルタ>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #UnalignedSplice^(clip clip1, clip clip2 [,...]^)	#演算子の+に相当するビデオクリップ結合フィルタ>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #FreezeFrame^(clip clip, int first-frame, int last-frame, int source-frame^)	#first-frameとlast-frameの間のすべてのフレームをsource-frameのコピーに置換。サウンドトラックは修正されません。>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #Try { Import^(".\avs\EraseLogo.avs"^) } catch(err_msg) { }	#半透過ロゴ除去>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo ExtErsLOGO^(logofile=".\lgd\%lgd_file_name%", start=0, end=-1, itype_s=0, itype_e=0, fadein=0, fadeout=0^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo.>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
exit /b


:preview_setting_filter
rem ----------
echo ##### カット編集 #####>> "%work_dir%%main_project_name%\preview1_straight.avs"
rem # 以下のインポート元ファイルにTrim情報を記入してください
echo #Try { Import^("trim_line.txt"^) } catch^(err_msg^) { }>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo.>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo ##### プレビュー用フィルタ #####>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #Its^(opt=1, def=".\main.def", fps=-1, debug=false, output="", chapter=""^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #AssumeFPS^("ntsc_film", sync_audio=false^)    #フレームレートを24fpsに修正>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #SelectField^(30, "top"^)    #解除漏れ対応、方フィールド選択>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #SelectField^(30, "bottom"^)    #解除漏れ対応、方フィールド選択>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #FreezeFrame^(100, 100, 101^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo.>> "%work_dir%%main_project_name%\preview1_straight.avs"
rem ----------
echo ##### カット編集 #####>> "%work_dir%%main_project_name%\preview2_trimed.avs"
rem # 以下のインポート元ファイルにTrim情報を記入してください
echo Try { Import^("trim_line.txt"^) } catch^(err_msg^) { }>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo.>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo ##### プレビュー用フィルタ #####>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #Its^(opt=1, def=".\main.def", fps=-1, debug=false, output="", chapter=""^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #AssumeFPS^("ntsc_film", sync_audio=false^)    #フレームレートを24fpsに修正>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #SelectField^(30, "top"^)    #解除漏れ対応、方フィールド選択>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #SelectField^(30, "bottom"^)    #解除漏れ対応、方フィールド選択>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #FreezeFrame^(100, 100, 101^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo.>> "%work_dir%%main_project_name%\preview2_trimed.avs"
rem ----------
echo ##### カット編集 #####>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
rem # 以下のインポート元ファイルにTrim情報を記入してください
echo Try { Import^("trim_line.txt"^) } catch^(err_msg^) { }>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo.>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo ##### プレビュー用フィルタ #####>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo DoubleWeave^(^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo a = Pulldown^(0, 2^).Subtitle^("Pulldown(0, 2)", size=90^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo b = Pulldown^(1, 3^).Subtitle^("Pulldown(1, 3)", size=90^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo c = Pulldown^(2, 4^).Subtitle^("Pulldown(2, 4)", size=90^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo d = Pulldown^(0 ,3^).Subtitle^("Pulldown(0, 3)", size=90^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo e = Pulldown^(1, 4^).Subtitle^("Pulldown(1, 4)", size=90^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo ShowFiveVersions^(a, b, c, d, e^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo.>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
rem ----------
echo ##### カット編集 #####>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
rem # 以下のインポート元ファイルにTrim情報を記入してください
echo Try { Import^("trim_line.txt"^) } catch^(err_msg^) { }>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
rem echo Import^("trim_multi.txt"^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo.>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo ##### プレビュー用フィルタ #####>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo Its^(opt=1, def=".\main.def", fps=-1, debug=false, output="", chapter=""^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #AssumeFPS^("ntsc_film", sync_audio=false^)    #フレームレートを24fpsに修正>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #SelectField^(30, "top"^)    #解除漏れ対応、方フィールド選択>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #SelectField^(30, "bottom"^)    #解除漏れ対応、方フィールド選択>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #FreezeFrame^(100, 100, 101^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
rem ----------
echo ##### 色空間変換 #####>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo ##### 色空間変換 #####>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo ##### 色空間変換 #####>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo ##### 色空間変換 #####>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
if "%mpeg2dec_select_flag%"=="1" (
    echo #ConvertToYUY2^(^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo #ConvertToYUY2^(^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo #ConvertToYUY2^(^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo #ConvertToYUY2^(^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
) else if "%mpeg2dec_select_flag%"=="2" (
    echo #ConvertToYUY2^(^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo #ConvertToYUY2^(^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo ConvertToYUY2^(^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo #ConvertToYUY2^(^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
) else if "%mpeg2dec_select_flag%"=="3" (
    echo #ConvertToYUY2^(^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo #ConvertToYUY2^(^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo ConvertToYUY2^(^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo #ConvertToYUY2^(^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
)
rem ----------
echo AntiComb^(checkmode=true^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
rem ----------
if "%mpeg2dec_select_flag%"=="1" (
    echo #ConvertToYV12^(^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo #ConvertToYV12^(^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo #ConvertToYV12^(^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo #ConvertToYV12^(^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
) else if "%mpeg2dec_select_flag%"=="2" (
    echo #ConvertToYV12^(^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo #ConvertToYV12^(^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo #ConvertToYV12^(^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo #ConvertToYV12^(^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
) else if "%mpeg2dec_select_flag%"=="3" (
    echo #ConvertToYV12^(^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo #ConvertToYV12^(^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo #ConvertToYV12^(^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo #ConvertToYV12^(^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
)
echo.>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #//--- 終了 ---//>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo return last>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo.>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #//--- 終了 ---//>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo return last>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo.>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #//--- 終了 ---//>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo return last>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo.>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #//--- 終了 ---//>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo return last>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
exit /b

:edit_analyze_filter
rem # ロゴ等編集＆解析のためのAVSファイル作成
echo ##### 編集＆解析のためのAVS #####
echo #//--- プラグイン読み込み部分のインポート ---//
echo Import^(".\LoadPlugin.avs"^)
echo.
echo #//--- ソースの読み込み ---//
if "%mpeg2dec_select_flag%"=="1" (
    echo Try { Try { Import^(".\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = MPEG2VIDEO^("..\src\video1.ts"^).AssumeTFF^(^) } } catch^(err_msg^) { video1 = MPEG2VIDEO^("%~1"^).AssumeTFF^(^) }
) else if "%mpeg2dec_select_flag%"=="2" (
    echo Try { Try { Import^(".\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = MPEG2Source^("..\src\video1..d2v",upconv=0^).ConvertToYUY2^(^) } } catch^(err_msg^) { video1 = MPEG2Source^("%~dpn1.d2v",upconv=0^).ConvertToYUY2^(^) }
) else if "%mpeg2dec_select_flag%"=="3" (
    echo Try { Try { Import^(".\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = LWLibavVideoSource^("..\src\video1.ts", dr=false, repeat=true, dominance=0^) } } catch^(err_msg^) { video1 = LWLibavVideoSource^("%~1", dr=false, repeat=true, dominance=0^) }
    echo video1 = video1.height^(^) == 1088 ? video1.Crop^(0, 0, 0, -8^) : video^1
)
echo #Try { Import^(".\LoadSrc_AudioPCM_1.avs"^) } catch^(err_msg^) { audio = WAVSource^("..\src\audio_pcm.wav"^) }
echo Try { Try { Import^(".\LoadSrc_AudioPCM_1.avs"^) } catch^(err_msg^) { audio = LWLibavAudioSource^("..\src\video1.ts", stream_index=-1, av_sync=false, layout="stereo"^) } } catch^(err_msg^) { audio = LWLibavAudioSource^("%~1", stream_index=-1, av_sync=false, layout="stereo"^) }
echo AudioDub^(video1, audio^)
echo.
echo #//--- フィールドオーダー ---//
echo #AssumeFrameBased^(^).ComplementParity^(^)    #トップフィールドが支配的
echo #AssumeFrameBased^(^)            #ボトムフィールドが支配的
echo #AssumeTFF^(^)                #トップファースト
echo #AssumeBFF^(^)                #ボトムファースト
echo.
echo #//--- Trim情報インポート ---//
echo #Import^("..\trim_chars.txt"^)
echo.
echo #//--- 色空間変更 ---//
echo # chapter_exe入力クリップの色空間はYUY2必須^(YV12だとシーンチェンジ縞を誤爆する^)
echo # ロゴ解析はYV12必須だが、logoframeが自動的にYV12に変換してくれるので問題なし
echo ConvertToYUY2^(^)
echo #ConvertToYV12^(^)
echo.
echo return last
exit /b

:eraselogo_filter
rem # 半透過ロゴ除去関数AVSファイル作成、中身はlogoframe実行時に上書き
type nul
exit /b

:avs_template_main_phase
rem ########## エンコードメイン処理用のAVSファイルをテンプレートファイルから生成
echo AVSテンプレートファイル：%avs_main_template%
echo プラグイン読み込みテンプレート："%plugin_template%"
copy "%plugin_template%" "%work_dir%%main_project_name%\avs\LoadPlugin.avs"> nul
echo [%time%] AVSテンプレートから生成開始
set last_phrase=
set eof_inuse_flag=
rem # forで検出した文字列を引数として外部ラベルに飛ばすと特殊文字"と>が混合している場合に正常に機能しない為、do構文内でsetすること
rem # 例：#ColorYUY2(levels="709->601")
for /f "usebackq delims=" %%L in (`findstr /n .* "%avs_main_template%"`) do (
    rem 文字列の中に特殊文字が含まれていると誤動作する場合があるので、ダブルクォートで囲む
    set str_temp="%%L"
    call :avs_template_line_edit
)
rem # テンプレートの最終行が return last 以外の文字列でかつまだ一度も return last を挿入していない場合、最後に挿入する
if not "%last_phrase:~0,11%"=="return last" (
    if not "%eof_inuse_flag%"=="1" (
        call :avs_template_eof_phase
    )
)
echo [%time%] AVSテンプレートから生成終了
exit /b

:avs_template_line_edit
rem # テンプレートの各行を分析、要置換対象の場合は所定のフィルタ等に変更
rem # 値が入っていない変数(=改行)に対してsetによる文字列置換をすると想定外の文字列になるため、行数が付与された状態で先に実施する
rem >記号は出力先ファイルにリダイレクトする際に誤動作するので、エスケープする
set str_temp=%str_temp:>=^^^>%
rem if文内で判定に使用する文字列はダブルクォートが含まれると誤動作するので、別に保持する
set str_checker="%str_temp:"=%"
rem 変数 str_temp は前後をダブルクォートで囲まれた状態の為、カウントする起点も3文字目からとなる
set avs_char_count=2
rem デリミタ:を探索するためのループ開始位置
:avs_template_charset_loop
call set str_delim=%%str_temp:~%avs_char_count%,1%%
set /a avs_char_count+=1
rem デリミタ:が出現するまでループ
if not "%str_delim%"==":" goto :avs_template_charset_loop
call set str_mod="%%str_temp:~%avs_char_count%, -1%%"
call set str_checker=%%str_checker:~%avs_char_count%, -1%%
rem 一度行頭と行末のダブルクォートを削除した状態の文字列を変数に格納しないと正しく機能しない
set str_mod=%str_mod:~1,-1%
rem 読み込みテンプレートの最終行を記録するため、空白でなければ上書き
rem #iFilterB("LanczosResize(704, 480)") で誤作動状態
if not "%str_checker%"=="" (
    call :avs_template_set_last_phrase
)
if "%str_checker%"=="" (
    echo.>> "%work_dir%%main_project_name%\main.avs"
) else if "%str_checker:~0,12%"=="___plugin___" (
    call :avs_template_plugin_phase
) else if "%str_checker:~0,13%"=="#___plugin___" (
    call :avs_template_plugin_phase
) else if "%str_checker:~0,9%"=="___src___" (
    call :avs_template_src_phase
) else if "%str_checker:~0,10%"=="#___src___" (
    call :avs_template_src_phase


) else if "%str_checker:~0,10%"=="___logo___" (
    call :avs_template_logo_phase
) else if "%str_checker:~0,11%"=="#___logo___" (
    call :avs_template_logo_phase



) else if "%str_checker:~0,10%"=="___trim___" (
    call :avs_template_trim_phase
) else if "%str_checker:~0,11%"=="#___trim___" (
    call :avs_template_trim_phase
) else if "%str_checker:~0,11%"=="___deint___" (
    call :avs_template_deint_phase
) else if "%str_checker:~0,12%"=="#___deint___" (
    call :avs_template_deint_phase
) else if "%str_checker:~0,12%"=="___resize___" (
    call :avs_template_resize_phase
) else if "%str_checker:~0,13%"=="#___resize___" (
    call :avs_template_resize_phase
) else if "%str_checker:~0,11%"=="return last" (
    call :avs_template_eof_phase
) else (
    call :avs_template_redirect_phase
)
exit /b

:avs_template_plugin_phase
rem # プラグイン読み込みテンプレートの挿入
echo Import^(".\avs\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\main.avs"
exit /b

:avs_template_src_phase
rem # 映像/音声読み込みテンプレートの挿入
if "%mpeg2dec_select_flag%"=="1" (
    echo Try { Import^(".\avs\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = MPEG2VIDEO^(".\src\video1.ts"^).AssumeTFF^(^) }>> "%work_dir%%main_project_name%\main.avs"
) else if "%mpeg2dec_select_flag%"=="2" (
    echo Try { Import^(".\avs\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = MPEG2Source^(".\src\video1.ts",upconv=0^).ConvertToYUY2^(^) }>> "%work_dir%%main_project_name%\main.avs"
) else if "%mpeg2dec_select_flag%"=="3" (
    echo Try { Import^(".\avs\LoadSrc_Video.avs"^) } catch^(err_msg^) { video1 = LWLibavVideoSource^(".\src\video1.ts", dr=false, repeat=true, dominance=0^) }>> "%work_dir%%main_project_name%\main.avs"
    echo video1 = video1.height^(^) == 1088 ? video1.Crop^(0, 0, 0, -8^) : video^1>> "%work_dir%%main_project_name%\main.avs"
)
echo Try { Import^(".\avs\LoadSrc_AudioPCM_1.avs"^) } catch^(err_msg^) { audio = WAVSource^(".\src\audio_pcm.wav"^) }>> "%work_dir%%main_project_name%\main.avs"
echo AudioDub^(video1, audio^)>> "%work_dir%%main_project_name%\main.avs"
echo.>> "%work_dir%%main_project_name%\main.avs"
exit /b

:avs_template_logo_phase
rem # ロゴ消去フィルタテンプレートの挿入
echo Try { Import^(".\avs\EraseLogo.avs"^) } catch(err_msg) { }	#半透過ロゴ除去>> "%work_dir%%main_project_name%\main.avs"
echo.>> "%work_dir%%main_project_name%\main.avs"
exit /b

:avs_template_trim_phase
rem # Trimカット編集テンプレートの挿入
echo # 単一行で表記するTrimコマンドはここ以下に記入してください>> "%work_dir%%main_project_name%\main.avs"
echo Try { Import^("trim_line.txt"^) } catch^(err_msg^) { }    # 一行Trim表記>> "%work_dir%%main_project_name%\main.avs"
echo #Trim^(0,99^) ++ Trim^(200,299^) ++ Trim^(300,399^)>> "%work_dir%%main_project_name%\main.avs"
echo.>> "%work_dir%%main_project_name%\main.avs"
echo # 複数行で表記するTrimコマンドはここ以下に記入してください>> "%work_dir%%main_project_name%\main.avs"
echo KillAudio^(^)    # 複雑な編集をする場合に備えて音声を一時無効化>> "%work_dir%%main_project_name%\main.avs"
echo Try { Import^("trim_multi.txt"^) } catch^(err_msg^) { }    # 複数行Trim表記^(EasyVFRなど^)>> "%work_dir%%main_project_name%\main.avs"
echo.>> "%work_dir%%main_project_name%\main.avs"
echo ### 一行で表記するTrimコマンドはここに記入してください ###>> "%work_dir%%main_project_name%\trim_line.txt"
echo ### 複数行で表記するTrimコマンドはここに記入してください ###>> "%work_dir%%main_project_name%\trim_multi.txt"
exit /b

:avs_template_deint_phase
rem # カラーマトリックスの調整
if "%avs_filter_type%"=="1080p_template" (
    echo #ColorMatrix^(mode="Rec.709->Rec.601", interlaced=true^)    #BT.709からBT.601へ変換>> "%work_dir%%main_project_name%\main.avs"
) else if "%avs_filter_type%"=="720p_template" (
    echo #ColorMatrix^(mode="Rec.709->Rec.601", interlaced=true^)    #BT.709からBT.601へ変換>> "%work_dir%%main_project_name%\main.avs"
) else if "%avs_filter_type%"=="540p_template" (
    echo #ColorMatrix^(mode="Rec.709->Rec.601", interlaced=true^)    #BT.709からBT.601へ変換>> "%work_dir%%main_project_name%\main.avs"
) else (
    echo ColorMatrix^(mode="Rec.709->Rec.601", interlaced=true^)    #BT.709からBT.601へ変換>> "%work_dir%%main_project_name%\main.avs"
    echo.>> "%work_dir%%main_project_name%\main.avs"
)
rem # デインターレースフィルタの挿入
if "%deinterlace_filter_flag%"=="24fps" (
    rem echo ### 24p でデインターレースします ###
    echo IT^(fps = 24, ref = "TOP", blend = false, diMode = 1^)>> "%work_dir%%main_project_name%\main.avs"
    echo #TDeint^(mode=2, full=false, cthresh=20, type=3, mthreshl=10, mtnmode=0, ap=10, aptype=2, expand=8^).TDecimate^(mode=1^)>> "%work_dir%%main_project_name%\main.avs"
) else if "%deinterlace_filter_flag%"=="Its" (
    rem echo ### Its でデインターレースします ###
    echo Its^(opt=1, def=".\main.def", fps=-1, debug=false, output=".\tmp\main.tmc", chapter=""^)>> "%work_dir%%main_project_name%\main.avs"
) else if "%deinterlace_filter_flag%"=="itvfr" (
    rem echo ### itvfrでデインターレースします ###
    echo Its^(opt=1, def=".\main.def", fps=-1, debug=false, output=".\tmp\main.tmc", chapter=""^)>> "%work_dir%%main_project_name%\main.avs"
) else if "%deinterlace_filter_flag%"=="30fps" (
    rem echo ### 30pでデインターレースします ###
    echo TomsMoComp^(1,5,0^)>> "%work_dir%%main_project_name%\main.avs"
    echo AntiComb^(^)>> "%work_dir%%main_project_name%\main.avs"
)
exit /b

:avs_template_resize_phase
rem # Crop, Resize, AddBorders
rem # Resize前、事前Crop
if "%crop_size_flag%"=="sidecut" (
    if "%src_video_wide_pixel%"=="1920" (
        echo Crop^(240, 0, -240, -0^)    #クリッピング^(左, 上, -右, -下^)>> "%work_dir%%main_project_name%\main.avs"
    ) else if "%src_video_wide_pixel%"=="720" (
        echo Crop^(96, 0, -96, -0^)    #クリッピング^(左, 上, -右, -下^)>> "%work_dir%%main_project_name%\main.avs"
    ) else (
        echo Crop^(180, 0, -180, -0^)    #クリッピング^(左, 上, -右, -下^)>> "%work_dir%%main_project_name%\main.avs"
    )
) else if "%crop_size_flag%"=="gakubuchi" (
    if "%src_video_wide_pixel%"=="1920" (
        echo Crop^(240, 134, -240, -136^)    #クリッピング^(左, 上, -右, -下^)>> "%work_dir%%main_project_name%\main.avs"
    ) else (
        echo Crop^(180, 134, -180, -136^)    #クリッピング^(左, 上, -右, -下^)>> "%work_dir%%main_project_name%\main.avs"
    )
) else (
    if "%src_video_wide_pixel%"=="720" (
        if "%avs_filter_type%"=="272p_template" (
            echo Crop^(8, 0, -8, -0^)    #クリッピング^(左, 上, -右, -下^)>> "%work_dir%%main_project_name%\main.avs"
        )
    )
)
rem # Resize処理・リサイズフィルタ設定
if "%bat_vresize_flag%"=="none" (
    echo #リサイズ無し>> "%work_dir%%main_project_name%\main.avs"
) else (
    if "%resize_algo_flag%"=="bilinear" (
        echo BilinearResize^(%resize_wpix%,%resize_hpix%^)>> "%work_dir%%main_project_name%\main.avs"
    ) else if "%resize_algo_flag%"=="bicubic" (
        echo BicubicResize^(%resize_wpix%,%resize_hpix%^)>> "%work_dir%%main_project_name%\main.avs"
    ) else if "%resize_algo_flag%"=="lanczos4" (
        echo Lanczos4Resize^(%resize_wpix%,%resize_hpix%^)>> "%work_dir%%main_project_name%\main.avs"
    ) else if "%resize_algo_flag%"=="spline16" (
        echo Spline16Resize^(%resize_wpix%,%resize_hpix%^)>> "%work_dir%%main_project_name%\main.avs"
    ) else if "%resize_algo_flag%"=="spline32" (
        echo Spline36Resize^(%resize_wpix%,%resize_hpix%^)>> "%work_dir%%main_project_name%\main.avs"
    ) else if "%resize_algo_flag%"=="spline64" (
        echo Spline64Resize^(%resize_wpix%,%resize_hpix%^)>> "%work_dir%%main_project_name%\main.avs"
    ) else if "%resize_algo_flag%"=="dither" (
        echo Dither_convert_8_to_16^(^)#色深度を8ビットから16ビットに展開>> "%work_dir%%main_project_name%\main.avs"
        echo Dither_resize16nr^(%resize_wpix%,%resize_hpix%,kernel="spline36",taps=6,noring=true^)#色深度16ビットリサイズ^&リンギング抑制>> "%work_dir%%main_project_name%\main.avs"
        echo f3kdb^(range=15,Y=56,Cb=40,Cr=40,grainY=0,grainC=0,keep_tv_range=true,input_mode=1,input_depth=16,output_mode=1,output_depth=16,random_algo_ref=2,random_algo_grain=2^)#色深度16ビット バンディング処理>> "%work_dir%%main_project_name%\main.avs"
        echo DitherPost^(mode=6^)#色深度を16ビットから8ビットに戻す^&バンディング処理2>> "%work_dir%%main_project_name%\main.avs"
    ) else (
        echo Spline64Resize^(%resize_wpix%,%resize_hpix%^)>> "%work_dir%%main_project_name%\main.avs"
    )
)
rem # リサイズ後、黒帯付加
if "%avs_filter_type%"=="480p_template" (
    if not "%src_video_wide_pixel%"=="720" (
        echo AddBorders^(8,0,8,0^)    #黒帯付加>> "%work_dir%%main_project_name%\main.avs"
    )
)
exit /b

:avs_template_eof_phase
rem # 最終処理段の挿入
set eof_inuse_flag=1
echo #//---  ConvertToYV12 ---//>>"%work_dir%%main_project_name%\main.avs"
if "%deinterlace_filter_flag%"=="interlace" (
    echo ConvertToYV12^(interlaced=true^)>>"%work_dir%%main_project_name%\main.avs"
) else (
    echo ConvertToYV12^(interlaced=false^)>>"%work_dir%%main_project_name%\main.avs"
)
echo #ConvertToYUY2^(interlaced=false^)>>"%work_dir%%main_project_name%\main.avs"
echo.>>"%work_dir%%main_project_name%\main.avs"
echo #//--- 終了 ---//>>"%work_dir%%main_project_name%\main.avs"
echo AudioDub^(last, audio^)>>"%work_dir%%main_project_name%\main.avs"
if "%deinterlace_filter_flag%"=="itvfr" (
    echo ItsCut^(^)>>"%work_dir%%main_project_name%\main.avs"
) else (
    echo #ItsCut^(^)>>"%work_dir%%main_project_name%\main.avs"
)
echo return last>>"%work_dir%%main_project_name%\main.avs"
exit /b

:avs_template_redirect_phase
rem # テンプレートの文字列をそのまま転記
echo %str_mod%>> "%work_dir%%main_project_name%\main.avs"
exit /b

:avs_template_set_last_phrase
set last_phrase=%str_mod%
exit /b

:make_project_dir
rem # プロジェクトディレクトリがなければ作成
if not exist "%work_dir%%main_project_name%\" mkdir "%work_dir%%main_project_name%\"
rem # AVSファイルを置くためのサブディレクトリがなければ作成
if not exist "%work_dir%%main_project_name%\avs\" mkdir "%work_dir%%main_project_name%\avs\"
rem # 映像および音声のソースを置くサブディレクトリがなければ作成
if not exist "%work_dir%%main_project_name%\src\" mkdir "%work_dir%%main_project_name%\src\"
rem # 各種バッチファイルを置くサブディレクトリがなければ作成
if not exist "%work_dir%%main_project_name%\bat\" mkdir "%work_dir%%main_project_name%\bat\"
rem # ログファイル置くサブディレクトリがなければ作成
if not exist "%work_dir%%main_project_name%\log\" mkdir "%work_dir%%main_project_name%\log\"
rem # ロゴファイル(.lgd)を置くためのサブディレクトリがなければ作成
if not exist "%work_dir%%main_project_name%\lgd\" mkdir "%work_dir%%main_project_name%\lgd\"
rem # カット処理方法スクリプト(JL)を置くためのサブディレクトリがなければ作成
if not exist "%work_dir%%main_project_name%\JL\" mkdir "%work_dir%%main_project_name%\JL\"
rem # バックアップファイル置くサブディレクトリがなければ作成
if not exist "%work_dir%%main_project_name%\old\" mkdir "%work_dir%%main_project_name%\old\"
rem # 軽量一時ファイル置くサブディレクトリがなければ作成
if not exist "%work_dir%%main_project_name%\tmp\" mkdir "%work_dir%%main_project_name%\tmp\"
exit /b

:make_main_bat
rem ### 実際に作業中核を担うメインとなるバッチファイルを作成する
rem # メインバッチファイルの作成、%encode_catalog_list%が定義されている場合、プロジェクトディレクトリ
rem # 以下にAVSと同名のメインバッチファイルを作成しそれを%encode_catalog_list%が呼び出す形式、setをサブルーチン化
set main_bat_file=%work_dir%%main_project_name%\main.bat
if not exist "%main_bat_file%" (
    echo メインバッチファイルがないので作成します...
    type nul > "%main_bat_file%"
    echo @echo off>> "%main_bat_file%"
    echo setlocal>> "%main_bat_file%"
    rem echo echo 開始時刻[%%date%% %%time%%]>> "%main_bat_file%"
) else (
    if "%encode_catalog_list%"=="" (
        rem %encode_catalog_list%を使用せず、かつ既にメインバッチファイルが存在している場合
        rem 保留中・・・
        exit /b
    ) else (
        echo 既にバッチファイルが存在しています。名前を変更し新規に作成します。
        rename "%main_bat_file%" "backup%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%_main.bat"
        type nul > "%main_bat_file%"
        echo @echo off>> "%main_bat_file%"
        echo setlocal>> "%main_bat_file%"
        rem echo echo 開始時刻[%%date%% %%time%%]>> "%main_bat_file%"
    )
)
echo.>> "%main_bat_file%"
rem %large_tmp_dir%が存在しない場合の対応
echo :START>> "%main_bat_file%"
echo rem #一時ファイル置き場確認>> "%main_bat_file%"
echo if not exist "%%large_tmp_dir%%" echo 大きめの一時ファイルを作成する%%%%large_tmp_dir%%%%が存在しません。^&echo ※ドライブレター直後のバックスラッシュ^^^(^^^\^^^)を忘れないこと^&echo フォルダへのフルパスを入力してください。^&set /p large_tmp_dir=type.^&goto :START>> "%main_bat_file%"
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\>> "%main_bat_file%"
echo chdir /d %%~dp0>> "%main_bat_file%"
rem # エンコードするファイルの見出し部分作成
echo.>> "%main_bat_file%"
echo echo Project: %main_project_name% >> "%main_bat_file%"
echo echo ### 開始時刻[%%date%% %%time%%] ###>> "%main_bat_file%"
echo.>> "%main_bat_file%"
exit /b

:MediaInfoC_phase
rem # MediaInfo CLIを使ってメディアの解像度を検出する(複数のストリームが含まれていることを想定し、最初にヒットしたものを対象とする)
echo MediaInfo でメディア情報のログを出力します
rem set /a Width_count=0
rem set /a Height_count=0
if not exist "%MediaInfoC_path%" (
    echo MediaInfo CLIが見つかりません。解像度の自動検出は行われません。
    exit /b
)
"%MediaInfoC_path%" -f "%~1"> "%work_dir%%main_project_name%\log\MediaInfo.log"
call :MediaInfo_Width_checker
call :MediaInfo_Height_checker
call :MediaInfo_Pixelaspect_checker
exit /b
:MediaInfo_Width_checker
for /f "usebackq tokens=3 delims= " %%W in (`findstr /C:"Width" "%work_dir%%main_project_name%\log\MediaInfo.log"`) do (
    set src_video_wide_pixel=%%~W
    echo Width : %%~W
    exit /b
)
echo Width が見つかりませんでした。
exit /b
:MediaInfo_Height_checker
for /f "usebackq tokens=3 delims= " %%H in (`findstr /C:"Height" "%work_dir%%main_project_name%\log\MediaInfo.log"`) do (
    set src_video_hight_pixel=%%~H
    echo Height: %%~H
    exit /b
)
echo Height が見つかりませんでした。
exit /b
:MediaInfo_Pixelaspect_checker
for /f "usebackq tokens=5 delims= " %%A in (`findstr /C:"Pixel aspect ratio" "%work_dir%%main_project_name%\log\MediaInfo.log"`) do (
    set src_video_pixel_aspect_ratio=%%~A
    echo Pixel aspect ratio: %%~A
    exit /b
)
echo Pixel aspect ratio が見つかりませんでした。
exit /b


:copy_source_phase
echo rem # ソースファイルのコピーおよび事前処理>> "%main_bat_file%"
echo call ".\bat\copy_src.bat">> "%main_bat_file%"
echo.>> "%main_bat_file%"
rem ### 指定したドライブのメディアタイプを判別するためのVBスクリプト、ソースファイルがローカルHDDドライブにあるか確認用
echo WScript.Echo CStr^(CreateObject^("Scripting.FileSystemObject"^).GetDrive^(WScript.Arguments^(0^)^).DriveType^)> "%work_dir%%main_project_name%\bat\media_check.vbs"
rem ### TSソースをコピーする擬似関数、TsSplitterによる処理も内包
type nul > "%copysrc_batfile_path%"
(
echo @echo off
echo setlocal
echo echo start %%~nx0 bat job...
echo chdir /d %%~dp0..\
echo.
echo rem # 使用するコピーアプリケーションを選択します
echo call :copy_app_detect
echo rem copy^(Default^), fac^(FastCopy^), ffc^(FireFileCopy^)
echo rem set copy_app_flag=%copy_app_flag%
echo.
echo echo ソースをローカルにコピーしています. . .[%%date%% %%time%%]
echo rem # %%large_tmp_dir%% の存在確認および末尾チェック
echo if not exist "%%large_tmp_dir%%" ^(
echo     echo 大きなファイルを出力する一時フォルダ %%%%large_tmp_dir%%%% が存在しません、代わりにシステムのテンポラリフォルダで代用します。
echo     set large_tmp_dir=%%tmp%%
echo ^)
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\
echo rem # エンコードツールをまとめたディレクトリを示す環境変数ENCTOOLSROOTPATHが定義されているか確認
echo call :toolsdircheck
echo rem # parameterファイル中のソースファイルへのフルパス^(src_file_path^)を検出
echo call :src_file_path_check
echo rem # 検出したソースファイルへのフルパスの中からファイル名^(src_file_name^)の部分のみを抽出
echo call :src_file_name_extraction "%%src_file_path%%"
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出
echo call :project_name_check
echo rem # parameterファイル中のMPEG-2デコーダータイプ^(mpeg2dec_select_flag^)を検出
echo call :mpeg2dec_select_flag_check
echo rem # parameterファイル中の強制コピーフラグ^(force_copy_src^)を検出
echo call :force_src_copy_check
echo rem # parameterファイル中のTsSplitterオプションパラメーター^(tssplitter_opt_param^)を検出
echo call :tssplitter_opt_param_check
echo rem # ソースメディア情報^(src_media_type^)を検出
echo call :src_media_type_check "%%src_file_path%%"
echo.
echo rem # 各実行ファイルが存在するか確認。存在しない場合ENCTOOLSROOTPATH内部を探索する、もしくはシステムの探索パスに委ねる
echo rem # それでも見つからない場合、コマンドプロンプト標準のcopyコマンドを使用する
)>> "%copysrc_batfile_path%"
echo if exist "%ffc_path%" ^(set ffc_path=%ffc_path%^) else ^(call :find_ffc "%ffc_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%fac_path%" ^(set fac_path=%fac_path%^) else ^(call :find_fac "%fac_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%ts2aac_path%" ^(set ts2aac_path=%ts2aac_path%^) else ^(call :find_ts2aac "%ts2aac_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%ts_parser_path%" ^(set ts_parser_path=%ts_parser_path%^) else ^(call :find_ts_parser "%ts_parser_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%faad_path%" ^(set faad_path=%faad_path%^) else ^(call :find_faad "%faad_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%FAW_path%" ^(set FAW_path=%FAW_path%^) else ^(call :find_FAW "%FAW_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%TsSplitter_path%" ^(set TsSplitter_path=%TsSplitter_path%^) else ^(call :find_TsSplitter "%TsSplitter_path%"^)>> "%copysrc_batfile_path%"
(
echo.
echo rem # 各種実行ファイルへのパスが、最終的にどのような値になったか確認。
echo echo FireFileCopy: %%ffc_path%%
echo echo FastCopy    : %%fac_path%%
echo echo ts2aac      : %%ts2aac_path%%
echo echo ts_parser   : %%ts_parser_path%%
echo echo faad        : %%faad_path%%
echo echo FakeAacWav  : %%FAW_path%%
echo echo TsSplitter  : %%TsSplitter_path%%
echo echo.
echo rem # 各種環境情報
echo echo ソースファイルへのフルパス: %%src_file_path%%
echo echo ソースファイル名  ： %%src_file_name%%
echo echo プロジェクト名    ： %%project_name%%
echo echo コピーソースフラグ : %%force_copy_src%%
echo echo 　0: ソースがネットワークフォルダの場合のみコピー
echo echo 　1: ソースのメディアタイプに関係なくコピー
echo echo ソースメディア情報 : %%src_media_type%%
echo echo 　1：リムーバブルドライブ^(USBメモリ/SDカード/FDなど^)
echo echo 　2：HDD
echo echo 　3：ネットワークドライブ
echo echo 　4：CD-ROM/CD-R/DVD-ROM/DVD-Rなど
echo echo 　5：RAMディスク
echo.
echo :main
echo rem //----- main開始 -----//
echo title %%project_name%%
echo set type-count=
echo set tssplitter_sepa_count=^0
echo set faad_audio_sep_flag=^0
echo if exist ".\avs\LoadSrc_Video.avs" ^(
echo     echo 映像用AVSファイルを再初期化
echo     del ".\avs\LoadSrc_Video.avs"
echo ^)
echo if exist ".\avs\LoadSrc_Audio*.avs" ^(
echo     echo 音声用AVSファイルを再初期化
echo     del ".\avs\LoadSrc_Audio*.avs"
echo ^)
echo if exist ".\log\ts_parser_log.txt" ^(
echo     del ".\log\ts_parser_log.txt"
echo ^)
echo if "%%tssplitter_opt_param%%"=="" ^(
echo     if not exist ".\src\video*%~x1" ^(
echo         if not exist "%%src_file_path%%" ^(
echo             echo ソースファイルが見つからない為処理を続行できません、中断します
echo             exit /b
echo         ^)
echo         if "%%force_copy_src%%"=="1" ^(
echo             echo 強制コピーフラグが有効な為、ソースをローカルフォルダに一時コピーします
echo             call :copy_src_phase
echo         ^) else ^(
echo             if not "%%src_media_type%%"=="2" ^(
echo                 echo ソースファイルが記録されているメディアがローカルHDD以外の為、一時コピーします
echo                 call :copy_src_phase
echo             ^) else ^(
echo                 echo ソースファイルが記録されているメディアがローカルHDDです、シンボリックリンクの作成を試みます
echo                 call :mklink_src_phase
echo             ^)
echo         ^)
echo     ^) else ^(
echo         echo サブディレクトリに既にソースファイルが存在するためコピーは実施しません
echo     ^)
echo     if exist ".\src\video1.ts" ^(
echo         set input_media_path=.\src\video1.ts
echo     ^) else ^(
echo         call :set_input_media_to_src
echo     ^)
echo     call :exec_audio_process
echo ^) else ^(
echo     echo TsSplitterオプションが指定されています。ソースをTsSplitterで分割します。
echo     call :set_input_media_to_src
echo     call :TsSplitter_exec_phase "%%src_file_path%%"
echo ^)
echo rem # faad音声が分割して出力された場合は音声チャンネルがストリームの途中で変更されている可能性があるので、TsSplitterでやり直す
echo rem # ただしTsSplitterの-SEPA系オプションを実行した実績がない場合に限る
echo if "%%faad_audio_sep_flag%%"=="1" ^(
echo     if not %%tssplitter_sepa_count%% GEQ 1 ^(
echo         call :TsSplitter_exec_phase "%%input_media_path%%"
echo     ^)
echo ^)
echo rem 作成されたオーディオ用AVSファイルをPIDから連番に振りなおします
echo set audio_faw_avs_num=
echo for /f "delims=" %%%%F in ^('dir /b ".\avs\LoadSrc_AudioFAW_*.avs"'^) do ^(
echo     call :audio_faw_renum "%%%%F"
echo ^)
echo set audio_pcm_avs_num=
echo for /f "delims=" %%%%P in ^('dir /b ".\avs\LoadSrc_AudioPCM_*.avs"'^) do ^(
echo     call :audio_pcm_renum "%%%%P"
echo ^)
echo.
echo title コマンド プロンプト
echo rem //----- main終了 -----//
echo echo end %%~nx0 bat job...
echo echo.
echo exit /b
echo.
rem ------------------------------
echo :copy_src_phase
echo if "%%copy_app_flag%%"=="fac" ^(
echo     if exist "%%fac_path%%" ^(
echo         echo FastCopy でコピーを実行します
echo         "%%fac_path%%" /cmd=diff /force_close /disk_mode=auto "%%src_file_path%%" /to="..\"
echo     ^) else ^(
echo         set copy_app_flag=copy
echo     ^)
echo ^) else if "%%copy_app_flag%%"=="ffc" ^(
echo     if exist "%%ffc_path%%" ^(
echo         echo FireFileCopy でコピーを実行します
echo         "%%ffc_path%%" "%%src_file_path%%" /copy /a /bg /md /nk /ys /to:"..\"
echo     ^) else ^(
echo         set copy_app_flag=copy
echo     ^)
echo ^)
echo if "%%copy_app_flag%%"=="copy" ^(
echo     echo コマンドプロンプト標準のcopyコマンドでコピーを実行します
echo     copy /z "%%src_file_path%%" "..\"
echo ^)
echo move "..\%%src_file_name%%" ".\src\video1.ts"^> nul
echo exit /b
echo.
rem ------------------------------
echo :mklink_src_phase
echo rem # verコマンドの出力結果を確認し、WindowsXP以前のOSの場合はシンボリックリンクが使えないので代わりにcopyを実行します。
echo for /f "tokens=2 usebackq delims=[]" %%%%W in ^(`ver`^) do ^(
echo     set os_version=%%%%W
echo ^)
echo echo OS %%os_version%%
echo for /f "tokens=2 usebackq delims=. " %%%%V in ^(`echo %%os_version%%`^) do ^(
echo     set major_version=%%%%V
echo ^)
echo if %%major_version%% LEQ 5 ^(
echo     echo 実行環境がWindowsXP以前のOSの為シンボリックリンクが使えません。代わりにcopy処理を実行します。
echo     call :copy_src_phase
echo ^) else ^(
echo     echo ソースファイルのシンボリックリンクを作成します。
echo     mklink ".\src\video1.ts" "%%src_file_path%%"
echo     if not exist ".\src\video1.ts" ^(
echo         echo シンボリックリンク作成に失敗しました、権限が不足している可能性があります。
echo         echo 代わりにcopy処理を実行します。
echo         call :copy_src_phase
echo     ^)
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :TsSplitter_exec_phase
echo rem TsSplitterのオプション指定が存在する場合それらを整形する、そうでない場合音声でのみ分割する
echo rem カンマはそのままだと引数の区切り文字として扱われてしまうので、一時的にダブルクォートで囲む
echo set tssplitter_opt_param_mod=%%tssplitter_opt_param:,=","%%
echo if not "%%tssplitter_opt_param%%"=="" ^(
echo     call :tssplitter_opt_shaping %%tssplitter_opt_param_mod%%
echo ^) else ^(
echo     set tssplitter_opt_fix=-EIT -ECM -EMM -SEPAC -1SEG 
echo     set /a tssplitter_sepa_count=tssplitter_sepa_count+^1
echo ^)
echo rem 最初からTsSplitterを使う場合は、カレントの親ディレクトリへ出力
echo rem コピー後にTsSplitterを使う場合は、.\src配下で直接実行
echo if exist ".\src\video1.ts" ^(
echo     echo %%TsSplitter_path%% %%tssplitter_opt_fix%%-OUT ".\src" ".\src\video1.ts"
echo     %%TsSplitter_path%% %%tssplitter_opt_fix%%-OUT ".\src" ".\src\video1.ts"
echo ^) else ^(
echo     echo %%TsSplitter_path%% %%tssplitter_opt_fix%%-OUT ".." "%%~1"
echo     %%TsSplitter_path%% %%tssplitter_opt_fix%%-OUT ".." "%%~1"
echo     for /f "delims=" %%%%F in ^('dir /b "..\%%~n1*%%~x1"'^) do ^(
echo         echo 検索対象：%%%%F
echo         call :move_tssplitter_outfiles "%%%%F" "%%~n1"
echo     ^)
echo ^)
echo rem 偶数奇数の連番にする為に、_HD/_SDはそれぞれ_HD-0/_SD-0にリネーム
echo if exist ".\src\video1_HD.ts" ^(
echo     move ".\src\video1_HD.ts" ".\src\video1_HD-0.ts"
echo ^)
echo if exist ".\src\video1_SD.ts" ^(
echo     move ".\src\video1_SD.ts" ".\src\video1_SD-0.ts"
echo ^)
echo echo HDサイズファイルの一覧
echo set tssplitter_HD_counter=^0
echo for /f "delims=" %%%%F in ^('dir /b ".\src\video1_HD*.ts"'^) do ^(
echo     echo %%%%F
echo     set /a tssplitter_HD_counter=tssplitter_HD_counter+^1
echo ^)
echo echo SDサイズファイルの一覧
echo set tssplitter_SD_counter=^0
echo for /f "delims=" %%%%F in ^('dir /b ".\src\video1_SD*.ts"'^) do ^(
echo     echo %%%%F
echo     set /a tssplitter_SD_counter=tssplitter_SD_counter+^1
echo ^)
echo rem # _HD ファイル総数カウント^(total^)
echo set HD_total_count=^0
echo :HD_total_count_loop
echo if exist ".\src\video1_HD-%%HD_total_count%%.ts" ^(
echo     set /a HD_total_count=HD_total_count+1
echo     goto :HD_total_count_loop
echo ^) else ^(
echo     set /a HD_total_count=HD_total_count-1
echo ^)
echo rem # 偶数連番と奇数連番のファイル総容量を比較し、大きい方のグループを後続の処理対象とする。
echo rem # Windowsのバッチファイルが 2147483647 までの値しか計算できないので、MBサイズに丸め込んで計算する。
echo rem # 偶数番ファイル数カウント^(even^)
echo set HD_even_count=^0
echo set HD_even_total_filesize=^0
echo :HD_even_count_loop
echo if exist ".\src\video1_HD-%%HD_even_count%%.ts" ^(
echo     call :filesize_calc_even ".\src\video1_HD-%%HD_even_count%%.ts"
echo     set /a HD_even_count=HD_even_count+2
echo     goto :HD_even_count_loop
echo ^) else ^(
echo     set /a HD_even_count=HD_even_count-2
echo ^)
echo echo 偶数番トータルファイルサイズ^(Mbyte^)：%%HD_even_total_filesize%%
echo rem # 奇数番ファイル数カウント^(odd^)
echo set HD_odd_count=^1
echo set HD_odd_total_filesize=^0
echo :HD_odd_count_loop
echo if exist ".\src\video1_HD-%%HD_odd_count%%.ts" ^(
echo     call :filesize_calc_odd ".\src\video1_HD-%%HD_odd_count%%.ts"
echo     set /a HD_odd_count=HD_odd_count+2
echo     goto :HD_odd_count_loop
echo ^) else ^(
echo     set /a HD_odd_count=HD_odd_count-^2
echo ^)
echo echo 奇数番トータルファイルサイズ^(Mbyte^)：%%HD_odd_total_filesize%%
echo rem # ファイル総容量を比較
echo if %%HD_even_total_filesize%% GEQ %%HD_odd_total_filesize%% ^(
echo     echo 偶数番のトータルファイルサイズが大きいです。以降の処理はこのグループに対して行います。
echo     set HD_tmp_count=^0
echo ^) else ^(
echo     echo 奇数番のトータルファイルサイズが大きいです。以降の処理はこのグループに対して行います。
echo     set HD_tmp_count=^1
echo ^)
echo call :HD_retry_phase
echo exit /b
echo.
rem ------------------------------
echo :tssplitter_opt_shaping
echo rem 半角スペースで区切られたTsSplitterオプションを整形する
echo set tssplitter_opt_fix=
echo set tssplitter_opt_uni=%%~^1
echo rem カンマが引数の区切り文字として扱われてしまわないよう一時的に付与したダブルクォートを外す
echo set tssplitter_opt_uni=%%tssplitter_opt_uni:"=%%
echo :tssplitter_opt_shap_loop
echo set tssplitter_opt_fix=%%tssplitter_opt_fix%%%%tssplitter_opt_uni%% 
echo rem # -SEPA系オプションの場合フラグをたてる
echo if "%%tssplitter_opt_uni:~0,5%%"=="-SEPA" ^(
echo     set /a tssplitter_sepa_count=tssplitter_sepa_count+^1
echo ^)
echo shift /^1
echo set tssplitter_opt_uni="%%~1"
echo set tssplitter_opt_uni=%%tssplitter_opt_uni:"=%%
echo if not "%%tssplitter_opt_uni%%"=="" ^(
echo     goto :tssplitter_opt_shap_loop
echo ^)
echo rem # faadによる音声チャンネル分割が発生しているにもかかわらず-SEPA系オプションが含まれていない場合追加する^(リトライ^)
echo if "%%faad_audio_sep_flag%%"=="1" ^(
echo     if "%%tssplitter_sepa_count%%"=="0" ^(
echo         set tssplitter_opt_fix=%%tssplitter_opt_fix%%-SEPAC 
echo         set /a tssplitter_sepa_count=tssplitter_sepa_count+^1
echo     ^)
echo ^)
echo rem # オプションの中に-OUTと-FLISTが含まれていた場合、それらを除外する
echo set tssplitter_opt_fix=%%tssplitter_opt_fix:-OUT =%%
echo set tssplitter_opt_fix=%%tssplitter_opt_fix:-FLIST =%%
echo exit /b
echo.
rem ------------------------------
echo :move_tssplitter_outfiles
echo rem カレントディレクトリの親ディレクトリにあるTsSplitter出力ファイルを.\src配下にリネームしながら移動する
echo set move_target_fname=%%~^1
echo rem 文字列を切り出す対象の中に変数を含む場合、callを使ってサブルーチン化する
echo call set move_target_alias=%%%%move_target_fname:%%~2=%%%%
echo echo move "..\%%move_target_fname%%" ".\src\video1%%move_target_alias%%"
echo move "..\%%move_target_fname%%" ".\src\video1%%move_target_alias%%"
echo exit /b
echo.
rem ------------------------------
echo :filesize_calc_even
echo rem # 偶数番ファイルサイズ計算
echo rem set /a HD_even_total_filesize=%%HD_even_total_filesize%%+%%~z1/1024/1024
echo set HD_even_each_filesize=%%~z1
echo set HD_even_each_filesize=%%HD_even_each_filesize:~0,-6%%
echo set /a HD_even_total_filesize=%%HD_even_total_filesize%%+%%HD_even_each_filesize%%
echo exit /b
echo.
rem ------------------------------
echo :filesize_calc_odd
echo rem # 奇数番ファイルサイズ計算
echo rem set /a HD_odd_total_filesize=%%HD_odd_total_filesize%%+%%~z1/1024/1024
echo set HD_odd_each_filesize=%%~z1
echo set HD_odd_each_filesize=%%HD_odd_each_filesize:~0,-6%%
echo set /a HD_odd_total_filesize=%%HD_odd_total_filesize%%+%%HD_odd_each_filesize%%
echo exit /b
echo.
rem ------------------------------
echo :HD_retry_phase
echo rem # 分割された _HD 各ファイルごとにオーディオ処理を繰り返します
echo :HD_retry_loop
echo set type-count=_HD-%%HD_tmp_count%%
echo call :ext_aac_audio_phase ".\src\video1_HD-%%HD_tmp_count%%.ts"
echo rem call :wav_decode_audio_phase "%%aac_audio_source%%"
echo if not %%HD_tmp_count%% GTR 1 ^(
echo     rem # TsSplitter分割ソースファイル読み込みAVS初期化
echo     echo video1 = \^> ".\avs\LoadSrc_Video.avs"
echo ^) else ^(
echo     echo     \ ++ \^>^> ".\avs\LoadSrc_Video.avs"
echo ^)
echo if "%%mpeg2dec_select_flag%%"=="1" ^(
echo     echo MPEG2VIDEO^^^("..\src\video1_HD-%%HD_tmp_count%%.ts"^^^).AssumeTFF^^^(^^^)^>^> ".\avs\LoadSrc_Video.avs"
echo ^) else if "%%mpeg2dec_select_flag%%"=="2" ^(
echo     echo MPEG2Source^^^("..\src\video1_HD-%%HD_tmp_count%%.d2v",upconv=0^^^).ConvertToYUY2^^^(^^^)^>^> ".\avs\LoadSrc_Video.avs"
echo ^) else if "%%mpeg2dec_select_flag%%"=="3" ^(
echo     echo LWLibavVideoSource^^^("..\src\video1_HD-%%HD_tmp_count%%.ts", dr=false, repeat=true, dominance=0^^^)^>^> ".\avs\LoadSrc_Video.avs"
echo ^)
echo set /a HD_tmp_count=HD_tmp_count+2
echo if %%HD_tmp_count%% LSS %%HD_total_count%% ^(
echo     goto :HD_retry_loop
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :ext_aac_audio_phase
echo echo AAC音声抽出 %%type-count%%...[%%date%% %%time%%]
echo set aac_audio_source=
echo set aac_audio_delay=
echo set aac_track_num=^1
echo if "%%mpeg2dec_select_flag%%"=="1" ^(
echo     echo # MPEG-2デコーダーに MPEG2 VFAPI Plug-In を使用します
echo     rem echo "%%ts2aac_path%%" -D -i "%%~1" -o "%%large_tmp_dir%%%%project_name%%"
echo     rem "%%ts2aac_path%%" -D -i "%%~1" -o "%%large_tmp_dir%%%%project_name%%"^>^> ".\log\ts2aac_log.txt"
echo     echo "%%ts_parser_path%%" --mode da --delay-type 1 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1"
echo     "%%ts_parser_path%%" --mode da --delay-type 1 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1"^>^> ".\log\ts_parser_log.txt" ^2^>^&^1
echo ^) else if "%%mpeg2dec_select_flag%%"=="2" ^(
echo     echo # MPEG-2デコーダーに DGIndex を使用します
echo     echo "%%ts_parser_path%%" --mode da --delay-type 2 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1"
echo     "%%ts_parser_path%%" --mode da --delay-type 2 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1"^>^> ".\log\ts_parser_log.txt" ^2^>^&^1
echo ^) else if "%%mpeg2dec_select_flag%%"=="3" ^(
echo     echo # MPEG-2デコーダーに L-SMASH Works を使用します
echo     echo "%%ts_parser_path%%" --mode da --delay-type 3 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1"
echo     "%%ts_parser_path%%" --mode da --delay-type 3 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1"^>^> ".\log\ts_parser_log.txt" ^2^>^&^1
echo ^)
echo for /f "delims=" %%^%%A in ^('dir /b "%%large_tmp_dir%%%%project_name%%*DELAY *ms.aac"'^) do ^(
echo     call :src_audio_loop "%%large_tmp_dir%%%%%%A"
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :src_audio_loop
echo set aac_audio_source=%%~1
echo echo オーディオトラック[%%aac_track_num%%]：%%aac_audio_source%%
echo set aac_audio_delay=%%aac_audio_source%%
echo set aac_audio_delay=%%aac_audio_delay:^"=%%
echo set aac_audio_delay=%%aac_audio_delay:*DELAY =%%
echo set aac_audio_delay=%%aac_audio_delay:ms.aac=%%
echo echo オーディオディレイ[%%aac_track_num%%]：%%aac_audio_delay%%
echo set audio_pid=%%aac_audio_source%%
echo set audio_pid=%%audio_pid:"=%%
echo set audio_pid=%%audio_pid:*PID =%%
echo rem setコマンドによる文字列置換では、後方のワイルドカードが機能しないのでfor文で代用
echo for /f "usebackq tokens=1 delims= " %%%%I in ^('%%audio_pid%%'^) do ^(
echo     set audio_pid=%%%%I
echo ^)
echo echo オーディオPID[%%aac_track_num%%]：%%audio_pid%%
echo rem # WAVデコード^(プレビューやCMカットに使用^)
echo call :wav_decode_audio_phase "%%aac_audio_source%%"
echo echo オーディオ用AVSファイルを作成します
echo if not exist ".\avs\LoadSrc_AudioPCM_PID%%audio_pid%%.avs" ^(
echo     echo audio = \^> ".\avs\LoadSrc_AudioPCM_PID%%audio_pid%%.avs"
echo ^) else ^(
echo     echo     \ ++ \^>^> ".\avs\LoadSrc_AudioPCM_PID%%audio_pid%%.avs"
echo ^)
echo echo WAVSource^^^("..\src\audio_pcm%%type-count%%_PID%%audio_pid%%.wav"^^^)^>^> ".\avs\LoadSrc_AudioPCM_PID%%audio_pid%%.avs"
echo if not exist ".\avs\LoadSrc_AudioFAW_PID%%audio_pid%%.avs" ^(
echo     echo audio = \^> ".\avs\LoadSrc_AudioFAW_PID%%audio_pid%%.avs"
echo ^) else ^(
echo     echo     \ ++ \^>^> ".\avs\LoadSrc_AudioFAW_PID%%audio_pid%%.avs"
echo ^)
echo echo WAVSource^^^("..\src\audio_faw%%type-count%%_PID%%audio_pid%%.wav"^^^)^>^> ".\avs\LoadSrc_AudioFAW_PID%%audio_pid%%.avs"
echo set /a aac_track_num=aac_track_num+^1
echo exit /b
echo.
rem ------------------------------
echo :audio_faw_renum
echo set /a audio_faw_avs_num=audio_faw_avs_num+^1
echo echo FAWオーディオAVS[%%audio_faw_avs_num%%]：".\avs\%%~1"
echo echo リネーム："LoadSrc_AudioFAW_%%audio_faw_avs_num%%.avs"
echo rename ".\avs\%%~1" "LoadSrc_AudioFAW_%%audio_faw_avs_num%%.avs"
echo exit /b
echo.
rem ------------------------------
echo :audio_pcm_renum
echo set /a audio_pcm_avs_num=audio_pcm_avs_num+^1
echo echo PCMオーディオAVS[%%audio_pcm_avs_num%%]：".\avs\%%~1"
echo echo リネーム："LoadSrc_AudioPCM_%%audio_pcm_avs_num%%.avs"
echo rename ".\avs\%%~1" "LoadSrc_AudioPCM_%%audio_pcm_avs_num%%.avs"
echo exit /b
echo.
rem ------------------------------
echo :wav_decode_audio_phase
echo rem # faadをは-Dでdelay調整が出来る改造版が前提。
echo rem # faadの -S オプションによって、音声チャンネルが切り替わった場合は複数のファイルが出力される。
echo rem # ^(2018/09/07 追記^)FAAD 改造版 0.7でないと不正な音声チャンネルヘッダ毎に出力ファイルが分割されてしまうので、古いバージョンを使わない事。
echo rem # 不正音声フレームのうち修正されなかったものがファイル出力されないよう、以下のデフォルトオプションパラメーターを除外して指定。^(-F 0x3D30D^)
echo rem # "0x2000: Output broken frames (default)."
echo rem # FAAD 改造版 0.4で、DELAYが含まれているとなぜか-oオプションが無視されしまう問題の回避^(改造版0.6で修正済み^)
echo echo WAVデコード %%type-count%%...[%%date%% %%time%%]
echo rem title %%project_name%%
echo echo "%%faad_path%%" -F 0x3D30D -S -d -D %%aac_audio_delay%% -o ".\src\audio_pcm%%type-count%%_PID%%audio_pid%%.wav" "%%~1"
echo "%%faad_path%%" -F 0x3D30D -S -d -D %%aac_audio_delay%% -o ".\src\audio_pcm%%type-count%%_PID%%audio_pid%%.wav" "%%~1"^>^> ".\log\faad_log.txt" ^2^>^&^1
echo set faad_outfile_counter=^0
echo echo 出力されたPCMファイルが、音声チャンネルで分割されていないかカウントします
echo echo 検査対象ファイル： ".\src\audio_pcm%%type-count%%_PID%%audio_pid%%[*].wav"
echo for /f "delims=" %%%%T in ^('dir /b ".\src\audio_pcm%%type-count%%_PID%%audio_pid%%[*].wav"'^) do ^(
echo     echo 検出ファイル：%%%%T
echo     set /a faad_outfile_counter=faad_outfile_counter+^1
echo ^)
echo if %%faad_outfile_counter%% GTR 1 ^(
echo     echo faadによって出力されたファイルが複数検出されました。
echo     if not %%tssplitter_sepa_count%% GEQ 1 ^(
echo         echo 音声チャンネルの切り替わりが発生しているため元のTSファイルをTsSplitterで分割しなおす必要があります。
echo         echo PCM音声ファイルを一旦削除
echo         del ".\src\audio_pcm*.wav"
echo         echo AAC音声ファイル一旦削除
echo         del "%%aac_audio_source%%"
echo         echo 音声AVSファイルを一旦削除
echo         del ".\avs\LoadSrc_Audio*.avs"
echo         set faad_audio_sep_flag=^1
echo     ^) else ^(
echo         echo 既にTsSplitterを-SEPAオプション付きで実行したにも関わらず再発しました。音声ストリームヘッダにエラーが含まれている可能性が高いです。
echo         echo 音声チャンネル変更による分割をせずにfaadを再度実行して後続の処理を継続します。
echo         echo PCM音声ファイルを一旦削除
echo         del ".\src\audio_pcm%%type-count%%*.wav"
echo         echo "%%faad_path%%" -F 0x3D30D -d -D %%aac_audio_delay%% -o ".\src\audio_pcm%%type-count%%.wav" "%%~1"
echo         "%%faad_path%%" -F 0x3D30D -d -D %%aac_audio_delay%% -o ".\src\audio_pcm%%type-count%%.wav" "%%~1"^>^> ".\log\faad_log.txt" ^2^>^&^1
echo         call :ext_faw_audio_phase "%%~1"
echo     ^)
echo ^) else ^(
echo     echo 音声チャンネルの切り替わりは検出されませんでした。このまま処理を続行します。
echo     rem # FAWファイル出力
echo     call :ext_faw_audio_phase "%%aac_audio_source%%"
echo     move "%%aac_audio_source%%" ".\src\audio%%type-count%%_%%aac_track_num%%_demux DELAY %%aac_audio_delay%%ms.aac"
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :ext_faw_audio_phase
echo echo FAW出力 %%type-count%%...[%%date%% %%time%%]
echo echo "%%FAW_path%%" "%%~1" ".\src\audio_faw%%type-count%%_PID%%audio_pid%%.wav"
echo "%%FAW_path%%" "%%~1" ".\src\audio_faw%%type-count%%_PID%%audio_pid%%.wav"
echo exit /b
echo.
rem ------------------------------
echo :src_media_type_check
echo if "%%~d1"=="\\" ^(
echo     echo ソースファイルへのパスがUNCの為、ネットワークドライブとして処理します
echo     set src_media_type=^3
echo ^) else ^(
echo     for /f "delims=" %%%%A in ^('cscript //nologo .\bat\media_check.vbs %%~d1'^) do ^(
echo         set src_media_type=%%%%A
echo     ^)
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :exec_audio_process
echo rem # AAC音声ファイルの分離
echo call :ext_aac_audio_phase "%%input_media_path%%"
echo rem # WAVデコード^(プレビューやCMカットに使用^)
echo rem call :wav_decode_audio_phase "%%aac_audio_source%%"
echo exit /b
echo.
rem ------------------------------
echo :set_input_media_to_src
echo set input_media_path=%%src_file_path%%
echo exit /b
echo.
rem ------------------------------
echo :copy_app_detect
echo for /f "usebackq eol=# tokens=2 delims==" %%%%C in ^(`findstr /b /r copy_app_flag "parameter.txt"`^) do ^(
echo     if "%%%%C"=="fac" ^(
echo         set copy_app_flag=fac
echo     ^) else if "%%%%C"=="ffc" ^(
echo         set copy_app_flag=ffc
echo     ^) else if "%%%%C"=="copy" ^(
echo         set copy_app_flag=copy
echo     ^)
echo ^)
echo if "%%copy_app_flag%%"=="" ^(
echo     echo コピー用アプリのパラメーターが見つかりません、デフォルトのcopyコマンドを使用します。
echo     set copy_app_flag=copy
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :toolsdircheck
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 環境変数 ENCTOOLSROOTPATH が未定義です
echo     exit /b
echo ^)
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\
echo if exist "%%ENCTOOLSROOTPATH%%" ^(
echo     exit /b
echo ^) else ^(
echo     echo 環境変数ENCTOOLSROOTPATHが有効なパスではありません
echo     set ENCTOOLSROOTPATH=
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :src_file_path_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%S in ^(`findstr /b /r src_file_path "parameter.txt"`^) do ^(
echo     set %%%%S
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :src_file_name_extraction
echo set src_file_name=%%~nx1
echo exit /b
echo.
rem ------------------------------
echo :project_name_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(
echo     set %%%%P
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :mpeg2dec_select_flag_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%M in ^(`findstr /b /r mpeg2dec_select_flag "parameter.txt"`^) do ^(
echo     set %%%%M
echo ^)
echo if "%%mpeg2dec_select_flag%%"=="" ^(
echo     echo ※MPEG-2デコーダーの指定が見つかりません, MPEG2 VFAPI Plug-Inを使用します
echo     set mpeg2dec_select_flag=^1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :force_src_copy_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%F in ^(`findstr /b /r force_copy_src "parameter.txt"`^) do ^(
echo     set %%%%F
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :tssplitter_opt_param_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%S in ^(`findstr /b /r tssplitter_opt_param "parameter.txt"`^) do ^(
echo     set %%%%S
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_ffc
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set ffc_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :ffc_env_search %%~nx1
echo exit /b
echo :ffc_env_search
echo set ffc_path=%%~$PATH:1
echo if "%%ffc_path%%"=="" echo FireFileCopyが見つかりません、代わりにコマンドプロンプト標準のcopyコマンドを使用します。
echo exit /b
echo.
rem ------------------------------
echo :find_fac
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set fac_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :fac_env_search %%~nx1
echo exit /b
echo :fac_env_search
echo set fac_path=%%~$PATH:1
echo if "%%fac_path%%"=="" echo FastCopyが見つかりません、代わりにコマンドプロンプト標準のcopyコマンドを使用します。
echo exit /b
echo.
rem ------------------------------
echo :find_ts2aac
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set ts2aac_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :ts2aac_env_search %%~nx1
echo exit /b
echo :ts2aac_env_search
echo set ts2aac_path=%%~$PATH:1
echo if "%%ts2aac_path%%"=="" ^(
echo     echo ts2aacが見つかりません。
echo     set ts2aac_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_ts_parser
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set ts_parser_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :ts_parser_env_search %%~nx1
echo exit /b
echo :ts_parser_env_search
echo set ts_parser_path=%%~$PATH:1
echo if "%%ts_parser_path%%"=="" ^(
echo     echo ts_parserが見つかりません。
echo     set ts_parser_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_faad
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set faad_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :faad_env_search %%~nx1
echo exit /b
echo :faad_env_search
echo set faad_path=%%~$PATH:1
echo if "%%faad_path%%"=="" ^(
echo    echo faadが見つかりません。
echo     set faad_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_FAW
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set FAW_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :FAW_env_search %%~nx1
echo exit /b
echo :FAW_env_search
echo set FAW_path=%%~$PATH:1
echo if "%%FAW_path%%"=="" ^(
echo     echo FAWが見つかりません。
echo     set FAW_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_TsSplitter
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set TsSplitter_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :TsSplitter_env_search %%~nx1
echo exit /b
echo :TsSplitter_env_search
echo set TsSplitter_path=%%~$PATH:1
echo if "%%TsSplitter_path%%"=="" ^(
echo     echo TsSplitterが見つかりません。
echo     set TsSplitter_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
)>> "%copysrc_batfile_path%"
exit /b


:make_d2vfile_phase
rem # DGIndexに読み込ませる為の.d2vファイルを作成する
rem # DGIndexを使用しない場合は当該関数スキップ
if not "%mpeg2dec_select_flag%"=="2" exit /b
type nul > "%d2vgen_batfile_path%"
echo @echo off>> "%d2vgen_batfile_path%"
echo setlocal>> "%d2vgen_batfile_path%"
echo cd /d %%~dp0..\>> "%d2vgen_batfile_path%"
echo.>> "%d2vgen_batfile_path%"
echo echo DGIndexのプロジェクトファイル(.d2v)を作成します[%%date%% %%time%%]>> "%d2vgen_batfile_path%"
call :d2v_exist_checker
echo echo DGIndexのプロジェクトファイル(.d2v)作成中...>> "%d2vgen_batfile_path%"
echo echo ===============================================================>> "%d2vgen_batfile_path%"
echo echo オプション：%dgindex_options_normal% >> "%d2vgen_batfile_path%"
echo echo ===============================================================>> "%d2vgen_batfile_path%"
echo call :dgindex_run "%~1">> "%d2vgen_batfile_path%"
echo exit /b>> "%d2vgen_batfile_path%"
echo.>> "%d2vgen_batfile_path%"
echo :dgindex_run>> "%d2vgen_batfile_path%"
echo rem # 入出力のパスを絶対パスに変換してからDGIndexに渡します>> "%d2vgen_batfile_path%"
echo %dgindex_path% -i "%%~f1" -o "%%~dpn1" %dgindex_options_normal% >> "%d2vgen_batfile_path%"
echo exit /b>> "%d2vgen_batfile_path%"
rem # メインバッチファイルに登録
echo rem # DGMPDecプロジェクトファイル(.d2v)が無い場合に作成>>"%main_bat_file%"
echo call ".\bat\DGMPGDec_prjct.bat">>"%main_bat_file%"
echo.>>"%main_bat_file%"
exit /b
:d2v_exist_checker
echo if exist "%~dpn1.d2v" ^(>> "%d2vgen_batfile_path%"
echo     echo ！既に同名の.d2vファイルが存在する為、処理をスキップします！>> "%d2vgen_batfile_path%"
echo     exit /b>> "%d2vgen_batfile_path%"
echo ^)>> "%d2vgen_batfile_path%"
rem ------------------------------
exit /b


:Video_Encoding_phase
rem ### x264/x265エンコードを決定するためのステップ
rem # H.265/HEVCプロファイルレベル参考資料
rem https://www.jstage.jst.go.jp/article/itej/67/7/67_553/_pdf
rem # sarの指定。末尾に要半角スペース
if "%videoAspectratio_option%"=="video_par1x1_option" (
    set video_sar_option=--sar 1:1 
) else if "%videoAspectratio_option%"=="video_par4x3_option" (
    set video_sar_option=--sar 4:3 
) else if "%videoAspectratio_option%"=="video_par40x33_option" (
    set video_sar_option=--sar 40:33 
) else if "%videoAspectratio_option%"=="video_par10x11_option" (
    set video_sar_option=--sar 10:11 
) else (
    echo ※ アスペクトの指定がありません！sar 1:1で代用します ※
    set video_sar_option=--sar 1:1 
)
rem # x264/x265/QSVEncC/NVEncCによるエンコード設定を書き込む擬似関数
if "%avs_filter_type%"=="1080p_template" (
    set x264_VUI_opt=--videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 
    set x265_VUI_opt=--videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 
    set qsv_VUI_opt=--videoformat ntsc --colormatrix bt709 --colorprim bt709 --transfer bt709 
    set nvenc_VUI_opt=--videoformat ntsc --colormatrix bt709 --colorprim bt709 --transfer bt709 
    if "%deinterlace_filter_flag%"=="Its" (
        if "%vfr_peak_rate%"=="60fps" (
            set x264_Encode_option=%x264_HP@L42_option%
            set x265_Encode_option=%x265_MP@L41_option%
            set qsv_h264_Encode_option=%qsv_h264_HP@L42_option%
            set qsv_hevc_Encode_option=%qsv_hevc_MP@L41_option%
            set nvenc_h264_Encode_option=%nvenc_h264_HP@L42_option%
            set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L41_option%
        ) else (
            set x264_Encode_option=%x264_HP@L40_option%
            set x265_Encode_option=%x265_MP@L40_option%
            set qsv_h264_Encode_option=%qsv_h264_HP@L40_option%
            set qsv_hevc_Encode_option=%qsv_hevc_MP@L40_option%
            set nvenc_h264_Encode_option=%nvenc_h264_HP@L40_option%
            set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L40_option%
        )
    ) else if "%deinterlace_filter_flag%"=="24fps" (
        set x264_Encode_option=%x264_HP@L40_option%
        set x265_Encode_option=%x265_MP@L40_option%
        set qsv_h264_Encode_option=%qsv_h264_HP@L40_option%
        set qsv_hevc_Encode_option=%qsv_hevc_MP@L40_option%
        set nvenc_h264_Encode_option=%nvenc_h264_HP@L40_option%
        set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L40_option%
    ) else if "%deinterlace_filter_flag%"=="30fps" (
        set x264_Encode_option=%x264_HP@L40_option%
        set x265_Encode_option=%x265_MP@L40_option%
        set qsv_h264_Encode_option=%qsv_h264_HP@L40_option%
        set qsv_hevc_Encode_option=%qsv_hevc_MP@L40_option%
        set nvenc_h264_Encode_option=%nvenc_h264_HP@L40_option%
        set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L40_option%
    ) else (
        set x264_Encode_option=%x264_HP@L42_option%
        set x265_Encode_option=%x265_MP@L41_option%
        set qsv_h264_Encode_option=%qsv_h264_HP@L42_option%
        set qsv_hevc_Encode_option=%qsv_hevc_MP@L41_option%
        set nvenc_h264_Encode_option=%nvenc_h264_HP@L42_option%
        set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L41_option%
    )
) else if "%avs_filter_type%"=="720p_template" (
    set x264_VUI_opt=--videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 
    set x265_VUI_opt=--videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 
    set qsv_VUI_opt=--videoformat ntsc --colormatrix bt709 --colorprim bt709 --transfer bt709 
    set nvenc_VUI_opt=--videoformat ntsc --colormatrix bt709 --colorprim bt709 --transfer bt709 
    if "%deinterlace_filter_flag%"=="Its" (
        if "%vfr_peak_rate%"=="60fps" (
            set x264_Encode_option=%x264_MP@L32_option%
            set x265_Encode_option=%x265_MP@L41_option%
            set qsv_h264_Encode_option=%qsv_h264_MP@L32_option%
            set qsv_hevc_Encode_option=%qsv_hevc_MP@L41_option%
            set nvenc_h264_Encode_option=%nvenc_h264_MP@L32_option%
            set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L41_option%
        ) else (
            set x264_Encode_option=%x264_MP@L31_option%
            set x265_Encode_option=%x265_MP@L40_option%
            set qsv_h264_Encode_option=%qsv_h264_MP@L31_option%
            set qsv_hevc_Encode_option=%qsv_hevc_MP@L40_option%
            set nvenc_h264_Encode_option=%nvenc_h264_MP@L31_option%
            set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L40_option%
        )
    ) else if "%deinterlace_filter_flag%"=="24fps" (
        set x264_Encode_option=%x264_MP@L31_option%
        set x265_Encode_option=%x265_MP@L40_option%
        set qsv_h264_Encode_option=%qsv_h264_MP@L31_option%
        set qsv_hevc_Encode_option=%qsv_hevc_MP@L40_option%
        set nvenc_h264_Encode_option=%nvenc_h264_MP@L31_option%
        set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L40_option%
    ) else if "%deinterlace_filter_flag%"=="30fps" (
        set x264_Encode_option=%x264_MP@L31_option%
        set x265_Encode_option=%x265_MP@L40_option%
        set qsv_h264_Encode_option=%qsv_h264_MP@L31_option%
        set qsv_hevc_Encode_option=%qsv_hevc_MP@L40_option%
        set nvenc_h264_Encode_option=%nvenc_h264_MP@L31_option%
        set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L40_option%
    ) else (
        set x264_Encode_option=%x264_MP@L32_option%
        set x265_Encode_option=%x265_MP@L41_option%
        set qsv_h264_Encode_option=%qsv_h264_MP@L32_option%
        set qsv_hevc_Encode_option=%qsv_hevc_MP@L41_option%
        set nvenc_h264_Encode_option=%nvenc_h264_MP@L32_option%
        set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L41_option%
    )
) else if "%avs_filter_type%"=="540p_template" (
    set x264_VUI_opt=--videoformat ntsc --colorprim smpte170m --transfer smpte170m --colormatrix smpte170m 
    set x265_VUI_opt=--videoformat ntsc --colorprim smpte170m --transfer smpte170m --colormatrix smpte170m 
    set qsv_VUI_opt=--videoformat ntsc --colormatrix smpte170m --colorprim smpte170m --transfer smpte170m 
    set nvenc_VUI_opt=--videoformat ntsc --colormatrix smpte170m --colorprim smpte170m --transfer smpte170m 
    if "%deinterlace_filter_flag%"=="Its" (
        if "%vfr_peak_rate%"=="60fps" (
            set x264_Encode_option=%x264_MP@L32_option%
            set x265_Encode_option=%x265_MP@L31_option%
            set qsv_h264_Encode_option=%qsv_h264_MP@L32_option%
            set qsv_hevc_Encode_option=%qsv_hevc_MP@L31_option%
            set nvenc_h264_Encode_option=%nvenc_h264_MP@L32_option%
            set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L31_option%
        ) else (
            set x264_Encode_option=%x264_MP@L31_option%
            set x265_Encode_option=%x265_MP@L30_option%
            set qsv_h264_Encode_option=%qsv_h264_MP@L31_option%
            set qsv_hevc_Encode_option=%qsv_hevc_MP@L30_option%
            set nvenc_h264_Encode_option=%nvenc_h264_MP@L31_option%
            set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L30_option%
        )
    ) else if "%deinterlace_filter_flag%"=="24fps" (
        set x264_Encode_option=%x264_MP@L31_option%
        set x265_Encode_option=%x265_MP@L30_option%
        set qsv_h264_Encode_option=%qsv_h264_MP@L31_option%
        set qsv_hevc_Encode_option=%qsv_hevc_MP@L30_option%
        set nvenc_h264_Encode_option=%nvenc_h264_MP@L31_option%
        set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L30_option%
    ) else if "%deinterlace_filter_flag%"=="30fps" (
        set x264_Encode_option=%x264_MP@L31_option%
        set x265_Encode_option=%x265_MP@L30_option%
        set qsv_h264_Encode_option=%qsv_h264_MP@L31_option%
        set qsv_hevc_Encode_option=%qsv_hevc_MP@L30_option%
        set nvenc_h264_Encode_option=%nvenc_h264_MP@L31_option%
        set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L30_option%
    ) else (
        set x264_Encode_option=%x264_MP@L32_option%
        set x265_Encode_option=%x265_MP@L31_option%
        set qsv_h264_Encode_option=%qsv_h264_MP@L32_option%
        set qsv_hevc_Encode_option=%qsv_hevc_MP@L31_option%
        set nvenc_h264_Encode_option=%nvenc_h264_MP@L32_option%
        set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L31_option%
    )
) else if "%avs_filter_type%"=="480p_template" (
    set x264_VUI_opt=--videoformat ntsc --colorprim smpte170m --transfer smpte170m --colormatrix smpte170m 
    set x265_VUI_opt=--videoformat ntsc --colorprim smpte170m --transfer smpte170m --colormatrix smpte170m 
    set qsv_VUI_opt=--videoformat ntsc --colormatrix smpte170m --colorprim smpte170m --transfer smpte170m 
    set nvenc_VUI_opt=--videoformat ntsc --colormatrix smpte170m --colorprim smpte170m --transfer smpte170m 
    if "%deinterlace_filter_flag%"=="Its" (
        if "%vfr_peak_rate%"=="60fps" (
            set x264_Encode_option=%x264_MP@L31_option%
            set x265_Encode_option=%x265_MP@L31_option%
            set qsv_h264_Encode_option=%qsv_h264_MP@L31_option%
            set qsv_hevc_Encode_option=%qsv_hevc_MP@L31_option%
            set nvenc_h264_Encode_option=%nvenc_h264_MP@L31_option%
            set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L31_option%
        ) else (
            set x264_Encode_option=%x264_MP@L30_option%
            set x265_Encode_option=%x265_MP@L30_option%
            set qsv_h264_Encode_option=%qsv_h264_MP@L30_option%
            set qsv_hevc_Encode_option=%qsv_hevc_MP@L30_option%
            set nvenc_h264_Encode_option=%nvenc_h264_MP@L30_option%
            set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L30_option%
        )
    ) else if "%deinterlace_filter_flag%"=="24fps" (
        set x264_Encode_option=%x264_MP@L30_option%
        set x265_Encode_option=%x265_MP@L30_option%
        set qsv_h264_Encode_option=%qsv_h264_MP@L30_option%
        set qsv_hevc_Encode_option=%qsv_hevc_MP@L30_option%
        set nvenc_h264_Encode_option=%nvenc_h264_MP@L30_option%
        set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L30_option%
    ) else if "%deinterlace_filter_flag%"=="30fps" (
        set x264_Encode_option=%x264_MP@L30_option%
        set x265_Encode_option=%x265_MP@L30_option%
        set qsv_h264_Encode_option=%qsv_h264_MP@L30_option%
        set qsv_hevc_Encode_option=%qsv_hevc_MP@L30_option%
        set nvenc_h264_Encode_option=%nvenc_h264_MP@L30_option%
        set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L30_option%
    ) else (
        set x264_Encode_option=%x264_MP@L31_option%
        set x265_Encode_option=%x265_MP@L31_option%
        set qsv_h264_Encode_option=%qsv_h264_MP@L31_option%
        set qsv_hevc_Encode_option=%qsv_hevc_MP@L31_option%
        set nvenc_h264_Encode_option=%nvenc_h264_MP@L31_option%
        set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L31_option%
    )
) else if "%avs_filter_type%"=="272p_template" (
    set x264_VUI_opt=--videoformat ntsc --colorprim smpte170m --transfer smpte170m --colormatrix smpte170m 
    set x265_VUI_opt=--videoformat ntsc --colorprim smpte170m --transfer smpte170m --colormatrix smpte170m 
    set qsv_VUI_opt=--videoformat ntsc --colormatrix smpte170m --colorprim smpte170m --transfer smpte170m 
    set nvenc_VUI_opt=--videoformat ntsc --colormatrix smpte170m --colorprim smpte170m --transfer smpte170m 
    set x264_Encode_option=%x264_MP@L21_option%
    set x265_Encode_option=%x265_MP@L30_option%
    set qsv_h264_Encode_option=%qsv_h264_MP@L21_option%
    set qsv_hevc_Encode_option=%qsv_hevc_MP@L30_option%
    set nvenc_h264_Encode_option=%nvenc_h264_MP@L21_option%
    set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L30_option%
) else (
    echo ※ プロファイルレベルの指定がありません！ ※
    set x264_VUI_opt=--videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 
    set x265_VUI_opt=--videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 
    set qsv_VUI_opt=--videoformat ntsc --colormatrix bt709 --colorprim bt709 --transfer bt709 
    set nvenc_VUI_opt=--videoformat ntsc --colormatrix bt709 --colorprim bt709 --transfer bt709 
    set x264_Encode_option=%x264_HP@L40_option%
    set x265_Encode_option=%x265_MP@L40_option%
    set qsv_h264_Encode_option=%qsv_h264_HP@L40_option%
    set qsv_hevc_Encode_option=%qsv_hevc_MP@L40_option%
    set nvenc_h264_Encode_option=%nvenc_h264_HP@L40_option%
    set nvenc_hevc_Encode_option=%nvenc_hevc_MP@L40_option%
)
rem # CRF値が設定されている場合の置換フェーズ
if not "%crf_value%"=="" (
    call :x264_Encode_option_shape %x264_Encode_option%
    call :x265_Encode_option_shape %x265_Encode_option%
)
rem # IDRフレームの最大間隔(シーク精度調整)の設定
set x265_keyint= --keyint 240 --min-keyint 1
rem # itvfrを使う場合の、ItsCut()用設定
if "%deinterlace_filter_flag%"=="itvfr" (
    set bat_start_wait=start "%~nx1 のエンコード..." /wait 
) else (
    set bat_start_wait=
)
echo rem # ビデオエンコードの実行フェーズ>>"%main_bat_file%"
echo call ".\bat\video_encode.bat">> "%main_bat_file%"
echo.>> "%main_bat_file%"
rem ------------------------------
(
echo @echo off
echo setlocal
echo echo start %%~nx0 bat job...
echo cd /d %%~dp0..\
echo.
echo rem # 使用するエンコーダーのタイプを指定します
echo call :video_codecparam_detect
echo rem x264, x265, qsv_h264, qsv_hevc, nvenc_h264, nvenc_hevc
echo rem set video_encoder_type=%video_encoder_type%
echo.
echo rem # x264, x265, QSVEncC, NVEncCのエンコードオプションを設定
echo call :x264_encparam_detect
echo rem set x264_enc_param=%x264_Encode_option% %video_sar_option%%x264_VUI_opt%%x264_keyint%%x264_interlace_option%
echo call :x265_encparam_detect
echo rem set x265_enc_param=%x265_Encode_option% %video_sar_option%%x265_VUI_opt%
echo call :qsv_h264_encparam_detect
echo rem set qsv_h264_enc_param=%qsv_h264_Encode_option% %video_sar_option%%qsv_VUI_opt%
echo call :qsv_hevc_encparam_detect
echo rem set qsv_hevc_enc_param=%qsv_hevc_Encode_option% %video_sar_option%%qsv_VUI_opt%
echo call :nvenc_h264_encparam_detect
echo rem set nvenc_h264_enc_param=%nvenc_h264_Encode_option% %video_sar_option%%nvenc_VUI_opt%
echo call :nvenc_hevc_encparam_detect
echo rem set nvenc_hevc_enc_param=%nvenc_hevc_Encode_option% %video_sar_option%%nvenc_VUI_opt%
echo.
echo rem # エンコードツールをまとめたディレクトリを示す環境変数ENCTOOLSROOTPATHが定義されているか確認
echo call :toolsdircheck
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出
echo call :project_name_check
echo rem # parameterファイル中のインターレース解除フラグ^(deinterlace_filter_flag^)を検出
echo call :deinterlace_filter_flag_check
echo.
echo rem # 各実行ファイルが存在するか確認。存在しない場合ENCTOOLSROOTPATH内部を探索する、もしくはシステムの探索パスに委ねる
)>> "%video_encode_batfile_path%"
echo if exist "%x264_path%" ^(set x264_path=%x264_path%^) else ^(call :find_x264 "%x264_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%x265_path%" ^(set x265_path=%x265_path%^) else ^(call :find_x265 "%x265_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%qsvencc_path%" ^(set qsvencc_path=%qsvencc_path%^) else ^(call :find_qsvencc "%qsvencc_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%nvencc_path%" ^(set nvencc_path=%nvencc_path%^) else ^(call :find_qsvencc "%nvencc_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%avs4x26x_path%" ^(set avs4x26x_path=%avs4x26x_path%^) else ^(call :find_avs4x26x "%avs4x26x_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%avs2pipe_path%" ^(set avs2pipe_path=%avs2pipe_path%^) else ^(call :find_avs2pipe "%avs2pipe_path%"^)>> "%video_encode_batfile_path%"
(
echo.
echo rem # 各種実行ファイルへのパスが、最終的にどのような値になったか確認。
echo echo x264    : %%x264_path%%
echo echo x265    : %%x265_path%%
echo echo QSVEncC : %%qsvencc_path%%
echo echo NVEncC  : %%nvencc_path%%
echo echo avs4x26x: %%avs4x26x_path%%
echo echo avs2pipe: %%avs2pipe_path%%
echo echo.
echo rem # 各種環境情報
echo echo プロジェクト名    ： %%project_name%%
echo echo インターレース解除： %%deinterlace_filter_flag%%
echo.
echo rem # エンコードオプション終端補正
echo if not "%%x264_enc_param:~-1%%"==" " set x264_enc_param=%%x264_enc_param%% 
echo if not "%%x265_enc_param:~-1%%"==" " set x265_enc_param=%%x265_enc_param%% 
echo if not "%%qsv_h264_enc_param:~-1%%"==" " set qsv_h264_enc_param=%%qsv_h264_enc_param%% 
echo if not "%%qsv_hevc_enc_param:~-1%%"==" " set qsv_hevc_enc_param=%%qsv_hevc_enc_param%% 
echo if not "%%nvenc_h264_enc_param:~-1%%"==" " set nvenc_h264_enc_param=%%nvenc_h264_enc_param%% 
echo if not "%%nvenc_hevc_enc_param:~-1%%"==" " set nvenc_hevc_enc_param=%%nvenc_hevc_enc_param%% 
echo echo.
echo :main
echo rem //----- main開始 -----//
echo title %%project_name%%
echo rem # .defファイル中のフレームレート指定の検査
echo if "%%deinterlace_filter_flag%%"=="Its" ^(
echo     echo デインターレースフラグがItsの為、.defファイル内のフレームレート指定をカウントします。
echo     call :def_file_composition_check
echo     echo.
echo ^)
echo.
echo rem # フレームレートオプションを決定
echo rem # デインターレースでItsフラグが指定されている場合.defの中身が全編30fps/60fpsの組み合わせの場合は
echo rem # 30000/1001、それ以外は24000/1001を指定する^(60000/1001や120000/1001ではcrfのレートコントロールが難しい為^)
echo if "%%deinterlace_filter_flag%%"=="24fps" ^(
echo     set encoder_fps_opt=--fps 24000/1001 
echo ^) else if "%%deinterlace_filter_flag%%"=="30fps" ^(
echo     set encoder_fps_opt=--fps 30000/1001 
echo ^) else if "%%deinterlace_filter_flag%%"=="bob" ^(
echo     set encoder_fps_opt=--fps 60000/1001 
echo ^) else if "%%deinterlace_filter_flag%%"=="Its" ^(
echo     if not "%%def_30fps_flag%%"=="0" ^(
echo         if not "%%def_24fps_flag%%"=="0" ^(
echo             set encoder_fps_opt=--fps 24000/1001 
echo         ^) else ^(
echo             set encoder_fps_opt=--fps 30000/1001 
echo         ^)
echo     ^) else if not "%%def_60fps_flag%%"=="0" ^(
echo         if not "%%def_24fps_flag%%"=="0" ^(
echo             set encoder_fps_opt=--fps 24000/1001 
echo         ^) else ^(
echo             set encoder_fps_opt=--fps 30000/1001 
echo         ^)
echo     ^) else ^(
echo         set encoder_fps_opt=--fps 24000/1001 
echo     ^)
echo ^) else ^(
echo     set encoder_fps_opt=
echo ^)
echo.
echo rem # 動画エンコード実行フェーズ
echo if "%%video_encoder_type%%"=="x264" ^(
echo     call :x264_exec_phase
echo ^) else if "%%video_encoder_type%%"=="x265" ^(
echo     call :x265_exec_phase
echo ^) else if "%%video_encoder_type%%"=="qsv_h264" ^(
echo     call :qsv_h264_func_check
echo ^) else if "%%video_encoder_type%%"=="qsv_hevc" ^(
echo     call :qsv_hevc_func_check
echo ^) else if "%%video_encoder_type%%"=="nvenc_h264" ^(
echo     call :nvenc_h264_func_check
echo ^) else if "%%video_encoder_type%%"=="nvenc_hevc" ^(
echo     call :nvenc_hevc_func_check
echo ^)
echo title コマンド プロンプト
echo rem //----- main終了 -----//
echo echo end %%~nx0 bat job...
echo echo.
echo exit /b
echo.
rem ------------------------------
echo :x264_exec_phase
echo echo x264エンコード. . .[%%date%% %%time%%]
echo echo "%%avs4x26x_path%%" -L "%%x264_path%%" %%x264_enc_param%%%%encoder_fps_opt%%--output ".\tmp\main_temp.264" "main.avs"
echo %bat_start_wait%"%%avs4x26x_path%%" -L "%%x264_path%%" %%x264_enc_param%%%%encoder_fps_opt%%--output ".\tmp\main_temp.264" "main.avs"
echo exit /b
echo.
rem ------------------------------
echo :x265_exec_phase
echo echo x265エンコード. . .[%%date%% %%time%%]
echo echo "%%avs4x26x_path%%" -L "%%x265_path%%" %%x265_enc_param%%%%encoder_fps_opt%%-o ".\tmp\main_temp.265" "main.avs"
echo %bat_start_wait%"%%avs4x26x_path%%" -L "%%x265_path%%" %%x265_enc_param%%%%encoder_fps_opt%%-o ".\tmp\main_temp.265" "main.avs"
echo exit /b
echo.
rem ------------------------------
echo :qsv_h264_exec_phase
echo echo QSVEncC^^^(H.264/AVC^^^)エンコード. . .[%%date%% %%time%%]
echo echo "%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%qsvencc_path%%" %%qsv_h264_enc_param%%%%encoder_fps_opt%%--codec h264 -i - -o ".\tmp\main_temp.264"
echo %bat_start_wait%"%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%qsvencc_path%%" %%qsv_h264_enc_param%%%%encoder_fps_opt%%--codec h264 -i - -o ".\tmp\main_temp.264"
echo exit /b
echo.
rem ------------------------------
echo :qsv_hevc_exec_phase
echo echo QSVEncC^^^(H.265/HEVC^^^)エンコード. . .[%%date%% %%time%%]
echo echo "%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%qsvencc_path%%" %%qsv_hevc_enc_param%%%%encoder_fps_opt%%--codec hevc -i - -o ".\tmp\main_temp.265"
echo %bat_start_wait%"%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%qsvencc_path%%" %%qsv_hevc_enc_param%%%%encoder_fps_opt%%--codec hevc -i - -o ".\tmp\main_temp.265"
echo exit /b
echo.
rem ------------------------------
echo :nvenc_h264_exec_phase
echo echo NVEncC^^^(H.264/AVC^^^)エンコード. . .[%%date%% %%time%%]
echo echo "%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%nvencc_path%%" %%nvenc_h264_enc_param%%%%encoder_fps_opt%%--codec h264 -i - -o ".\tmp\main_temp.264"
echo %bat_start_wait%"%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%nvencc_path%%" %%nvenc_h264_enc_param%%%%encoder_fps_opt%%--codec h264 -i - -o ".\tmp\main_temp.264"
echo exit /b
echo.
rem ------------------------------
echo :nvenc_hevc_exec_phase
echo echo NVEncC^^^(H.265/HEVC^^^)エンコード. . .[%%date%% %%time%%]
echo echo "%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%nvencc_path%%" %%nvenc_hevc_enc_param%%%%encoder_fps_opt%%--codec hevc -i - -o ".\tmp\main_temp.265"
echo %bat_start_wait%"%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%nvencc_path%%" %%nvenc_hevc_enc_param%%%%encoder_fps_opt%%--codec hevc -i - -o ".\tmp\main_temp.265"
echo exit /b
echo.
rem ------------------------------
echo :qsv_h264_func_check
echo "%%qsvencc_path%%" --check-features ^| findstr /b /X /C:"Codec: H.264/AVC"
echo if "%%ERRORLEVEL%%"=="0" ^(
echo     call :qsv_h264_exec_phase
echo ^) else ^(
echo     echo ※QSVEncで実行可能な環境が無い為、代わりにx264でエンコードします
echo     call :x264_exec_phase
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :qsv_hevc_func_check
echo "%%qsvencc_path%%" --check-features ^| findstr /b /X /C:"Codec: H.265/HEVC"
echo if "%%ERRORLEVEL%%"=="0" ^(
echo     call :qsv_hevc_exec_phase
echo ^) else ^(
echo     echo ※QSVEncで実行可能な環境が無い為、代わりにx265でエンコードします
echo     call :x265_exec_phase
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :nvenc_h264_func_check
echo "%%nvencc_path%%" --check-features ^| findstr /b /X /C:"Codec: H.264/AVC"
echo if "%%ERRORLEVEL%%"=="0" ^(
echo     call :nvenc_h264_exec_phase
echo ^) else ^(
echo     echo ※NVEncで実行可能な環境が無い為、代わりにx264でエンコードします
echo     call :x264_exec_phase
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :nvenc_hevc_func_check
echo "%%nvencc_path%%" --check-features ^| findstr /b /X /C:"Codec: H.265/HEVC"
echo if "%%ERRORLEVEL%%"=="0" ^(
echo     call :nvenc_hevc_exec_phase
echo ^) else ^(
echo     echo ※NVEncで実行可能な環境が無い為、代わりにx265でエンコードします
echo     call :x265_exec_phase
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :def_file_composition_check
echo set def_24fps_flag=^0
echo set def_30fps_flag=^0
echo set def_60fps_flag=^0
echo for /f "usebackq eol=# tokens=1 delims=[] " %%%%X in ^(`findstr /L "[24]" "main.def"`^) do ^(
echo     call :24fps_counter "%%%%X"
echo ^)
echo for /f "usebackq eol=# tokens=1 delims=[] " %%%%Y in ^(`findstr /L "[30]" "main.def"`^) do ^(
echo     call :30fps_counter "%%%%Y"
echo ^)
echo for /f "usebackq eol=# tokens=1 delims=[] " %%%%Z in ^(`findstr /L "[60]" "main.def"`^) do ^(
echo     call :60fps_counter "%%%%Z"
echo ^)
echo if not "%%def_24fps_flag%%"=="0" echo .def内に24fps定義があります
echo if not "%%def_30fps_flag%%"=="0" echo .def内に30fps定義があります
echo if not "%%def_60fps_flag%%"=="0" echo .def内に60fps定義があります
echo exit /b
echo :24fps_counter
echo if not "%%~1"=="set" ^(
echo     set def_24fps_flag=^1
echo ^)
echo exit /b
echo :30fps_counter
echo if not "%%~1"=="set" ^(
echo     set def_30fps_flag=^1
echo ^)
echo exit /b
echo :60fps_counter
echo if not "%%~1"=="set" ^(
echo     set def_60fps_flag=^1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :video_codecparam_detect
echo for /f "usebackq eol=# tokens=2 delims==" %%%%V in ^(`findstr /b /r video_encoder_type "parameter.txt"`^) do ^(
echo     if "%%%%V"=="x264" ^(
echo         set video_encoder_type=x264
echo     ^) else if "%%%%V"=="x265" ^(
echo         set video_encoder_type=x265
echo     ^) else if "%%%%V"=="qsv_h264" ^(
echo         set video_encoder_type=qsv_h264
echo     ^) else if "%%%%V"=="qsv_hevc" ^(
echo         set video_encoder_type=qsv_hevc
echo     ^) else if "%%%%V"=="nvenc_h264" ^(
echo         set video_encoder_type=nvenc_h264
echo     ^) else if "%%%%V"=="nvenc_hevc" ^(
echo         set video_encoder_type=nvenc_hevc
echo     ^)
echo ^)
echo if "%%video_encoder_type%%"=="" ^(
echo     echo ビデオエンコードのコーデック指定が見つかりません。代わりにデフォルトのx264を使用します。
echo     set video_encoder_type=x264
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :x264_encparam_detect
echo for /f "usebackq eol=# tokens=2 delims==" %%%%X in ^(`findstr /b /r x264_enc_param "parameter.txt"`^) do ^(
echo     set x264_enc_param=%%%%X
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :x265_encparam_detect
echo for /f "usebackq eol=# tokens=2 delims==" %%%%X in ^(`findstr /b /r x265_enc_param "parameter.txt"`^) do ^(
echo     set x265_enc_param=%%%%X
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :qsv_h264_encparam_detect
echo for /f "usebackq eol=# tokens=2 delims==" %%%%X in ^(`findstr /b /r qsv_h264_enc_param "parameter.txt"`^) do ^(
echo     set qsv_h264_enc_param=%%%%X
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :qsv_hevc_encparam_detect
echo for /f "usebackq eol=# tokens=2 delims==" %%%%X in ^(`findstr /b /r qsv_hevc_enc_param "parameter.txt"`^) do ^(
echo     set qsv_hevc_enc_param=%%%%X
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :nvenc_h264_encparam_detect
echo for /f "usebackq eol=# tokens=2 delims==" %%%%X in ^(`findstr /b /r nvenc_h264_enc_param "parameter.txt"`^) do ^(
echo     set nvenc_h264_enc_param=%%%%X
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :nvenc_hevc_encparam_detect
echo for /f "usebackq eol=# tokens=2 delims==" %%%%X in ^(`findstr /b /r nvenc_hevc_enc_param "parameter.txt"`^) do ^(
echo     set nvenc_hevc_enc_param=%%%%X
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :toolsdircheck
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 環境変数 ENCTOOLSROOTPATH が未定義です
echo     exit /b
echo ^)
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\
echo if exist "%%ENCTOOLSROOTPATH%%" ^(
echo     exit /b
echo ^) else ^(
echo     echo 環境変数ENCTOOLSROOTPATHが有効なパスではありません
echo     set ENCTOOLSROOTPATH=
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :project_name_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(
echo     set %%%%P
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :deinterlace_filter_flag_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%D in ^(`findstr /b /r deinterlace_filter_flag "parameter.txt"`^) do ^(
echo     set %%%%D
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_x264
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set x264_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :x264_env_search "%%~nx1"
echo exit /b
echo :x264_env_search
echo set x264_path=%%~$PATH:1
echo if "%%x264_path%%"=="" ^(
echo     echo x264が見つかりません
echo     set x264_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_x265
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set x265_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :x265_env_search "%%~nx1"
echo exit /b
echo :x265_env_search
echo set x265_path=%%~$PATH:1
echo if "%%x265_path%%"=="" ^(
echo    echo x265が見つかりません
echo     set x265_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_qsvencc
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set qsvencc_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :qsvencc_env_search "%%~nx1"
echo exit /b
echo :qsvencc_env_search
echo set qsvencc_path=%%~$PATH:1
echo if "%%qsvencc_path%%"=="" ^(
echo    echo QSVEncCが見つかりません
echo     set qsvencc_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_nvencc
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set nvencc_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :nvencc_env_search "%%~nx1"
echo exit /b
echo :nvencc_env_search
echo set nvencc_path=%%~$PATH:1
echo if "%%nvencc_path%%"=="" ^(
echo    echo NVEncCが見つかりません
echo     set nvencc_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_avs4x26x
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set avs4x26x_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :avs4x26x_env_search "%%~nx1"
echo exit /b
echo :avs4x26x_env_search
echo set avs4x26x_path=%%~$PATH:1
echo if "%%avs4x26x_path%%"=="" ^(
echo     echo avs4x26xが見つかりません
echo     set avs4x26x_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_avs2pipe
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     set avs2pipe_path=%%~nx1
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set avs2pipe_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo     call :avspipe_env_search %%~nx1
echo ^)
echo exit /b
echo :avspipe_env_search
echo set avs2pipe_path=%%~$PATH:1
echo if "%%avs2pipe_path%%"=="" ^(
echo     echo avs2pipeが見つかりません
echo     set avs2pipe_path=%%~1
echo ^)
echo exit /b
rem ------------------------------
)>> "%video_encode_batfile_path%"
echo.
echo ### 映像処理 ###
echo エンコーダー：%video_encoder_type%
if "%video_encoder_type%"=="x264" (
    echo 設定：%bat_start_wait%"%avs4x26x_path%" -L "%x264_path%" %x264_Encode_option% %video_sar_option%%x264_VUI_opt%%x264_keyint%%x264_interlace_option%--output ".\tmp\main_temp.264" "main.avs"
) else if "%video_encoder_type%"=="x265" (
    echo 設定：%bat_start_wait%"%avs4x26x_path%" -L "%x265_path%" %x265_Encode_option% %video_sar_option%%x265_VUI_opt%-o ".\tmp\main_temp.265" "main.avs"
) else if "%video_encoder_type%"=="qsv_h264" (
    echo 設定：%bat_start_wait%"%avs2pipe_path%" -y4mp "main.avs" ^| "%qsvencc_path%" %qsv_h264_Encode_option% %video_sar_option%%qsv_VUI_opt%--codec h264 -i - -o ".\tmp\main_temp.264"
) else if "%video_encoder_type%"=="qsv_hevc" (
    echo 設定：%bat_start_wait%"%avs2pipe_path%" -y4mp "main.avs" ^| "%qsvencc_path%" %qsv_hevc_Encode_option% %video_sar_option%%qsv_VUI_opt%--codec hevc -i - -o ".\tmp\main_temp.265"
) else if "%video_encoder_type%"=="nvenc_h264" (
    echo 設定：%bat_start_wait%"%avs2pipe_path%" -y4mp "main.avs" ^| "%nvencc_path%" %nvenc_h264_Encode_option% %video_sar_option%%nvenc_VUI_opt%--codec h264 -i - -o ".\tmp\main_temp.264"
) else if "%video_encoder_type%"=="nvenc_hevc" (
    echo 設定：%bat_start_wait%"%avs2pipe_path%" -y4mp "main.avs" ^| "%nvencc_path%" %nvenc_hevc_Encode_option% %video_sar_option%%nvenc_VUI_opt%--codec hevc -i - -o ".\tmp\main_temp.265"
)
exit /b


:x264_Encode_option_shape
set x264_Encode_option_mod=
:x264_option_shape_loop
set x264_Encode_option_mod=%x264_Encode_option_mod%%~1 
if "%~1"=="--crf" (
    set x264_Encode_option_mod=%x264_Encode_option_mod%%crf_value% 
    set crf_hit_count=1
    shift /1
    shift /1
) else (
    shift /1
)
if not "%~1"=="" (
    goto :x264_option_shape_loop
)
if not "%crf_hit_count%"=="1" (
    set x264_Encode_option_mod=--crf %crf_value% %x264_Encode_option_mod%
)
set x264_Encode_option=%x264_Encode_option_mod%
exit /b

:x265_Encode_option_shape
set x265_Encode_option_mod=
:x265_option_shape_loop
set x265_Encode_option_mod=%x265_Encode_option_mod%%~1 
if "%~1"=="--crf" (
    set x265_Encode_option_mod=%x265_Encode_option_mod%%crf_value% 
    set crf_hit_count=1
    shift /1
    shift /1
) else (
    shift /1
)
if not "%~1"=="" (
    goto :x265_option_shape_loop
)
if not "%crf_hit_count%"=="1" (
    set x265_Encode_option_mod=--crf %crf_value% %x265_Encode_option_mod%
)
set x265_Encode_option=%x265_Encode_option_mod%
exit /b


:audio_Encoding_select
rem # オーディオの一般的処理の擬似関数、FAW / neroAacEnc / Bilingual等の処理分岐もここで行う
if "%audio_job_flag%"=="sox" (
    echo sox を使用
) else if "%audio_job_flag%"=="nero" (
    echo neroAacEnc を使用
) else if "%audio_job_flag%"=="faw" (
    echo FakeAacWav を使用
) else (
    echo 音声処理の指定が不明です、代替としてFakeAacWav を使用
)
echo.
echo rem # オーディオファイルの編集実行フェーズ>>"%main_bat_file%"
echo call ".\bat\audio_edit.bat">> "%main_bat_file%"
echo.>> "%main_bat_file%"
rem # "%audio_edit_batfile_path%"へのリダイレクト開始
(
echo @echo off
echo setlocal
echo echo start %%~nx0 bat job...
echo cd /d %%~dp0..\
echo.
echo rem # オーディオの処理判定関数呼び出し
echo call :audio_job_detect
echo rem # Audio edit mode[faw^(Default^), sox, nero]
echo rem audio_job_flag=faw
echo.
echo rem # %%large_tmp_dir%% の存在確認および末尾チェック
echo if not exist "%%large_tmp_dir%%" ^(
echo     echo 大きなファイルを出力する一時フォルダ %%%%large_tmp_dir%%%% が存在しません、代わりにシステムのテンポラリフォルダで代用します。
echo     set large_tmp_dir=%%tmp%%
echo ^)
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\
echo rem # エンコードツールをまとめたディレクトリを示す環境変数ENCTOOLSROOTPATHが定義されているか確認
echo call :toolsdircheck
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出
echo call :project_name_check
echo rem # parameterファイル中のMPEG-2デコーダータイプ^(mpeg2dec_select_flag^)を検出
echo call :mpeg2dec_select_flag_check
echo rem # parameterファイル中のオーディオゲインアップ値^(audio_gain^)を検出
echo call :audio_gain_check
echo.
echo rem # 各実行ファイルが存在するか確認。存在しない場合ENCTOOLSROOTPATH内部を探索する、もしくはシステムの探索パスに委ねる
)>> "%audio_edit_batfile_path%"
echo if exist "%avs2wav_path%" ^(set avs2wav_path=%avs2wav_path%^) else ^(call :find_avs2wav "%avs2wav_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%sox_path%" ^(set sox_path=%sox_path%^) else ^(call :find_sox "%sox_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%neroAacEnc_path%" ^(set neroAacEnc_path=%neroAacEnc_path%^) else ^(call :find_neroAacEnc_path "%neroAacEnc_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%FAW_path%" ^(set FAW_path=%FAW_path%^) else ^(call :find_FAW "%FAW_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%muxer_path%" ^(set muxer_path=%muxer_path%^) else ^(call :find_muxer "%muxer_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%aacgain_path%" ^(set aacgain_path=%aacgain_path%^) else ^(call :find_aacgain "%aacgain_path%"^)>> "%audio_edit_batfile_path%"
(
echo.
echo rem # 各種実行ファイルへのパスが、最終的にどのような値になったか確認。
echo echo avs2wav       : %%avs2wav_path%%
echo echo sox           : %%sox_path%%
echo echo neroAacEnc    : %%neroAacEnc_path%%
echo echo FakeAacWav    : %%FAW_path%%
echo echo muxer^(L-SMASH^): %%muxer_path%%
echo echo AACGain       : %%aacgain_path%%
echo.
echo rem ※注意※
echo rem TSファイルの中には、番組切り替わりなどのタイミングでビデオとオーディオの開始位置が揃わないことがある^(PCR Wrap-around問題^)
echo rem TsSplitterのPMT^(ProgramMapTable^)毎に分割^(-SEP3オプション^)で回避するか、PCR Wrap-around対策済みのデコーダーを使用する事
echo rem muxer は入力に指定されたmp4コンテナのうち最初のトラックしか引き継がないので、マルチトラックの可能性のある音声はここでは扱わない
echo.
echo :main
echo rem //----- main開始 -----//
echo title %%project_name%%
echo if "%%audio_job_flag%%"=="sox" ^(
echo     call :Bilingual_audio_encoding
echo ^) else if "%%audio_job_flag%%"=="nero" ^(
echo     call :Stereo_audio_encoding
echo ^) else if "%%audio_job_flag%%"=="faw" ^(
echo     call :FAW_audio_encoding
echo ^)
echo title コマンド プロンプト
echo rem //----- main終了 -----//
echo echo end %%~nx0 bat job...
echo echo.
echo exit /b
echo.
rem ------------------------------
echo :Bilingual_audio_encoding
echo rem # 二ヶ国語音声の場合のエンコード処理、soxを使って左右のチャンネルを分割する
echo echo sox を使用
echo set audio_pcm_avs_num=^0
echo for /f "delims=" %%%%P in ^('dir /b ".\avs\LoadSrc_AudioPCM_*.avs"'^) do ^(
echo     call :make_pcmsrc_avs "%%%%P"
echo     call :Bilingual_audio_exec
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :Bilingual_audio_exec
echo echo avs2wavで編集中 %%audio_pcm_avs_num%%. . .[%%date%% %%time%%]
echo rem # avs2wavはバージョンによってはインプットファイルに相対パスを指定するとエラーで停止するので、一時的にディレクトリを変更します
echo pushd avs
echo "%%avs2wav_path%%" "audio_export_pcm_%%audio_pcm_avs_num%%.avs" "%%large_tmp_dir%%%%project_name%%_%%audio_pcm_avs_num%%.wav"^>nul
echo popd
echo echo 二ヶ国語音声の編集中. . .[%%date%% %%time%%]
echo "%%sox_path%%" "%%large_tmp_dir%%%%project_name%%_%%audio_pcm_avs_num%%.wav" -c 1 "%%large_tmp_dir%%%%project_name%%_%%audio_pcm_avs_num%%_left.wav" mixer -l
echo "%%sox_path%%" "%%large_tmp_dir%%%%project_name%%_%%audio_pcm_avs_num%%.wav" -c 1 "%%large_tmp_dir%%%%project_name%%_%%audio_pcm_avs_num%%_right.wav" mixer -r
echo "%%neroAacEnc_path%%" -q 0.40 -if "%%large_tmp_dir%%%%project_name%%_%%audio_pcm_avs_num%%_left.wav" -of ".\tmp\main_audio_%%audio_pcm_avs_num%%_left.m4a"
echo "%%neroAacEnc_path%%" -q 0.40 -if "%%large_tmp_dir%%%%project_name%%_%%audio_pcm_avs_num%%_right.wav" -of ".\tmp\main_audio_%%audio_pcm_avs_num%%_right.m4a"
echo call :AACGain_phase ".\tmp\main_audio_%%audio_pcm_avs_num%%_left.m4a"
echo call :AACGain_phase ".\tmp\main_audio_%%audio_pcm_avs_num%%_right.m4a"
echo del "%%large_tmp_dir%%%%project_name%%_%%audio_pcm_avs_num%%.wav"
echo del "%%large_tmp_dir%%%%project_name%%_%%audio_pcm_avs_num%%_left.wav"
echo del "%%large_tmp_dir%%%%project_name%%_%%audio_pcm_avs_num%%_right.wav"
echo exit /b
echo.
rem ------------------------------
echo :Stereo_audio_encoding
echo rem # ステレオ音声として再エンコードする場合の処理
echo echo neroAacEnc を使用
echo set audio_pcm_avs_num=^0
echo for /f "delims=" %%%%P in ^('dir /b ".\avs\LoadSrc_AudioPCM_*.avs"'^) do ^(
echo     call :make_pcmsrc_avs "%%%%P"
echo     call :Stereo_audio_exec
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :Stereo_audio_exec
echo echo avs2wavで編集中[%%audio_pcm_avs_num%%]. . .[%%date%% %%time%%]
echo rem # avs2wavはバージョンによってはインプットファイルに相対パスを指定するとエラーで停止するので、一時的にディレクトリを変更します
echo pushd avs
echo "%%avs2wav_path%%" "audio_export_pcm_%%audio_pcm_avs_num%%.avs" "%%large_tmp_dir%%%%project_name%%_%%audio_pcm_avs_num%%.wav"^>nul
echo popd
echo echo neroAacEncでエンコード中. . .[%%date%% %%time%%]
echo "%%neroAacEnc_path%%" -q 0.40 -if "%%large_tmp_dir%%%%project_name%%_%%audio_pcm_avs_num%%.wav" -of ".\tmp\main_audio_%%audio_pcm_avs_num%%.m4a"
echo call :AACGain_phase ".\tmp\main_audio_%%audio_pcm_avs_num%%.m4a"
echo del "%%large_tmp_dir%%%%project_name%%_%%audio_pcm_avs_num%%.wav"
echo exit /b
echo.
rem ------------------------------
echo :FAW_audio_encoding
echo rem # FAWを使用してカットのみの処理
echo echo FakeAacWav を使用
echo set audio_faw_avs_num=^0
echo for /f "delims=" %%%%F in ^('dir /b ".\avs\LoadSrc_AudioFAW_*.avs"'^) do ^(
echo     call :make_fawsrc_avs "%%%%F"
echo     call :FAW_audio_exec
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :FAW_audio_exec
echo echo avs2wavで編集中[%%audio_faw_avs_num%%]. . .[%%date%% %%time%%]
echo rem # avs2wavはバージョンによってはインプットファイルに相対パスを指定するとエラーで停止するので、一時的にディレクトリを変更します
echo pushd avs
echo echo avs2wavは出力先フォルダの指定方法次第で不正終了することがあるので注意
echo "%%avs2wav_path%%" "audio_export_faw_%%audio_faw_avs_num%%.avs" "%%large_tmp_dir%%%%project_name%%_%%audio_faw_avs_num%%_aac_edit.wav"
echo popd
echo "%%FAW_path%%" "%%large_tmp_dir%%%%project_name%%_%%audio_faw_avs_num%%_aac_edit.wav" ".\tmp\main_%%audio_faw_avs_num%%_edit.aac"
echo "%%muxer_path%%" -i ".\tmp\main_%%audio_faw_avs_num%%_edit.aac" -o ".\tmp\main_audio_%%audio_faw_avs_num%%.m4a"
echo call :AACGain_phase ".\tmp\main_audio_%%audio_faw_avs_num%%.m4a"
echo del "%%large_tmp_dir%%%%project_name%%_%%audio_faw_avs_num%%_aac_edit.wav"
echo exit /b
echo.
rem ------------------------------
echo :AACGain_phase
echo rem # AACGainを使用して音量をアップする処理
echo rem # AACGainは音声チャンネルを1つだけしか含まないファイルしか処理できないので、MUX前に実施する
echo echo AACGainで音量調整. . .[%%date%% %%time%%]
echo echo "%%~1" をオーディオゲインアップします
echo if "%%audio_gain%%"=="0" ^(
echo     echo オーディオゲインアップ値が0の為、処理をスキップします
echo ^) else ^(
echo     echo ゲインアップ値は %%audio_gain%% です
echo     "%%aacgain_path%%" /g %%audio_gain%% "%%~1"
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :make_fawsrc_avs
echo set /a audio_faw_avs_num=audio_faw_avs_num+^1
echo rem # 疑似WAV^(FAW^)を出力する際に整形済みTrim情報を渡すためのAVSファイル作成
echo ^(
echo echo ##### 疑似WAV^^^(FAW^^^)を出力する際に整形済みTrim情報を渡すためのAVS #####
echo echo #//--- プラグイン読み込み部分のインポート ---//
echo echo Import^^^(".\LoadPlugin.avs"^^^)
echo echo.
echo echo #//--- ソースの読み込み ---//^)^> ".\avs\audio_export_faw_%%audio_faw_avs_num%%.avs"
echo if "%%mpeg2dec_select_flag%%"=="1" ^(
echo     echo Try { Import^^^(".\LoadSrc_Video.avs"^^^) } catch^^^(err_msg^^^) { video1 = MPEG2VIDEO^^^("..\src\video1.ts"^^^).AssumeTFF^^^(^^^) }^>^> ".\avs\audio_export_faw_%%audio_faw_avs_num%%.avs"
echo ^) else if "%%mpeg2dec_select_flag%%"=="2" ^(
echo     echo Try { Import^^^(".\LoadSrc_Video.avs"^^^) } catch^^^(err_msg^^^) { video1 = MPEG2Source^^^("..\src\video1.d2v",upconv=0^^^).ConvertToYUY2^^^(^^^) }^>^> ".\avs\audio_export_faw_%%audio_faw_avs_num%%.avs"
echo ^) else if "%%mpeg2dec_select_flag%%"=="3" ^(
echo     echo Try { Import^^^(".\LoadSrc_Video.avs"^^^) } catch^^^(err_msg^^^) { video1 = LWLibavVideoSource^^^("..\src\video1.ts", dr=false, repeat=true, dominance=0^^^) }^>^> ".\avs\audio_export_faw_%%audio_faw_avs_num%%.avs"
echo     echo video1 = video1.height^^^(^^^) == 1088 ? video1.Crop^^^(0, 0, 0, -8^^^) : video1^>^> ".\avs\audio_export_faw_%%audio_faw_avs_num%%.avs"
echo ^)
echo ^(
echo echo Try { Import^^^(".\%%~1"^^^) } catch^^^(err_msg^^^) { audio = WAVSource^^^("..\src\audio_faw.wav"^^^) }
echo echo AudioDub^^^(video1, audio^^^)
echo echo.
echo echo #//--- フィールドオーダー ---//
echo echo #AssumeFrameBased^^^(^^^).ComplementParity^^^(^^^)    #トップフィールドが支配的
echo echo.
echo echo #//--- Trim情報インポート ---//
echo echo Import^^^("..\trim_chars.txt"^^^)
echo echo.
echo echo return last^)^>^> ".\avs\audio_export_faw_%%audio_faw_avs_num%%.avs"
echo exit /b
echo.
rem ------------------------------
echo :make_pcmsrc_avs
echo rem # PCM WAVを出力する際に整形済みTrim情報を渡すためのAVSファイル作成
echo set /a audio_pcm_avs_num=audio_pcm_avs_num+^1
echo ^(
echo echo ##### PCM WAVを出力する際に整形済みTrim情報を渡すためのAVS #####
echo echo #//--- プラグイン読み込み部分のインポート ---//
echo echo Import^^^(".\LoadPlugin.avs"^^^)
echo echo.
echo echo #//--- ソースの読み込み ---//^)^> ".\avs\audio_export_pcm_%%audio_pcm_avs_num%%.avs"
echo if "%%mpeg2dec_select_flag%%"=="1" ^(
echo     echo Try { Import^^^(".\LoadSrc_Video.avs"^^^) } catch^^^(err_msg^^^) { video1 = MPEG2VIDEO^^^("..\src\video1.ts"^^^).AssumeTFF^^^(^^^) }^>^> ".\avs\audio_export_pcm_.avs"
echo ^) else if "%%mpeg2dec_select_flag%%"=="2" ^(
echo     echo Try { Import^^^(".\LoadSrc_Video.avs"^^^) } catch^^^(err_msg^^^) { video1 = MPEG2Source^^^("..\src\video1.d2v",upconv=0^^^).ConvertToYUY2^^^(^^^) }^>^> ".\avs\audio_export_pcm_.avs"
echo ^) else if "%%mpeg2dec_select_flag%%"=="3" ^(
echo     echo Try { Import^^^(".\LoadSrc_Video.avs"^^^) } catch^^^(err_msg^^^) { video1 = LWLibavVideoSource^^^("..\src\video1.ts", dr=false, repeat=true, dominance=0^^^) }^>^> ".\avs\audio_export_pcm_.avs"
echo     echo video1 = video1.height^^^(^^^) == 1088 ? video1.Crop^^^(0, 0, 0, -8^^^) : video1^>^> ".\avs\audio_export_pcm_.avs"
echo ^)
echo ^(
echo echo Try { Import^^^(".\%%~1"^^^) } catch^^^(err_msg^^^) { audio = WAVSource^^^("..\src\audio_pcm.wav"^^^) }
echo echo AudioDub^^^(video1, audio^^^)
echo echo.
echo echo #//--- フィールドオーダー ---//
echo echo #AssumeFrameBased^^^(^^^).ComplementParity^^^(^^^)    #トップフィールドが支配的
echo echo.
echo echo #//--- Trim情報インポート ---//
echo echo Import^^^("..\trim_chars.txt"^^^)
echo echo.
echo echo return last^)^>^> ".\avs\audio_export_pcm_%%audio_pcm_avs_num%%.avs"
echo exit /b
echo.
rem ------------------------------
echo :audio_job_detect
echo for /f "usebackq eol=# tokens=2 delims==" %%%%A in ^(`findstr /b /r audio_job_flag "parameter.txt"`^) do ^(
echo     if "%%%%A"=="faw" ^(
echo         set audio_job_flag=faw
echo     ^) else if "%%%%A"=="sox" ^(
echo         set audio_job_flag=sox
echo     ^) else if "%%%%A"=="nero" ^(
echo         set audio_job_flag=nero
echo     ^)
echo ^)
echo if "%%audio_job_flag%%"=="" ^(
echo     echo パラメータファイルの中にオーディオの処理指定が見つかりません。デフォルトのFAWを使用します。
echo     set audio_job_flag=faw
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :toolsdircheck
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 環境変数 ENCTOOLSROOTPATH が未定義です
echo     exit /b
echo ^)
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\
echo if exist "%%ENCTOOLSROOTPATH%%" ^(
echo     exit /b
echo ^) else ^(
echo     echo 環境変数ENCTOOLSROOTPATHが有効なパスではありません
echo     set ENCTOOLSROOTPATH=
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :project_name_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(
echo     set %%%%P
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :mpeg2dec_select_flag_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%M in ^(`findstr /b /r mpeg2dec_select_flag "parameter.txt"`^) do ^(
echo     set %%%%M
echo ^)
echo if "%%mpeg2dec_select_flag%%"=="" ^(
echo     echo ※MPEG-2デコーダーの指定が見つかりません, MPEG2 VFAPI Plug-Inを使用します
echo     set mpeg2dec_select_flag=^1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :audio_gain_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%G in ^(`findstr /b /r audio_gain "parameter.txt"`^) do ^(
echo     set %%%%G
echo ^)
echo :gainint_blank_loop
echo if "%%audio_gain:~-1%%"==" " ^(
echo     set audio_gain=%%audio_gain:~0,-1%%
echo     goto :gainint_blank_loop
echo ^)
echo if "%%audio_gain%%"=="" ^(
echo     echo パラメーター audio_gain が未定義です。0 を代入します。
echo     set audio_gain=^0
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_avs2wav
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set avs2wav_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :avs2wav_env_search "%%~nx1"
echo exit /b
echo :avs2wav_env_search
echo set avs2wav_path=%%~$PATH:1
echo if "%%avs2wav_path%%"=="" ^(
echo     echo avs2wavが見つかりません
echo     set avs2wav_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_sox
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set sox_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :sox_env_search "%%~nx1"
echo exit /b
echo :sox_env_search
echo set sox_path=%%~$PATH:1
echo if "%%sox_path%%"=="" ^(
echo     echo soxが見つかりません
echo     set sox_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_neroAacEnc
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set neroAacEnc_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :neroAacEnc_env_search "%%~nx1"
echo exit /b
echo :neroAacEnc_env_search
echo set neroAacEnc_path=%%~$PATH:1
echo if "%%neroAacEnc_path%%"=="" ^(
echo     echo neroAacEncが見つかりません
echo     set neroAacEnc_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_FAW
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set FAW_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :FAW_env_search "%%~nx1"
echo exit /b
echo :FAW_env_search
echo set FAW_path=%%~$PATH:1
echo if "%%FAW_path%%"=="" ^(
echo     echo FakeAacWav^(FAW^)が見つかりません
echo     set FAW_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_muxer
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set muxer_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :muxer_env_search %%~nx1
echo exit /b
echo :muxer_env_search
echo set muxer_path=%%~$PATH:1
echo if "%%muxer_path%%"=="" ^(
echo     echo muxerが見つかりません
echo     set muxer_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_aacgain
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set aacgain_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :aacgain_env_search "%%~nx1"
echo exit /b
echo :aacgain_env_search
echo set aacgain_path=%%~$PATH:1
echo if "%%aacgain_path%%"=="" ^(
echo     echo AACGainが見つかりません
echo     set aacgain_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
)>> "%audio_edit_batfile_path%"
exit /b


:srt_edit
echo rem # デジタル放送の字幕抽出フェーズ>>"%main_bat_file%"
echo call ".\bat\srt_edit.bat">>"%main_bat_file%"
echo.>>"%main_bat_file%"
type nul > "%srtedit_batfile_path%"
rem ------------------------------
(
echo @echo off
echo setlocal
echo echo start %%~nx0 bat job...
echo chdir /d %%~dp0..\
echo.
echo rem # %%large_tmp_dir%% の存在確認および末尾チェック
echo if not exist "%%large_tmp_dir%%" ^(
echo     echo 大きなファイルを出力する一時フォルダ %%%%large_tmp_dir%%%% が存在しません、代わりにシステムのテンポラリフォルダで代用します。
echo     set large_tmp_dir=%%tmp%%
echo ^)
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\
echo rem # エンコードツールをまとめたディレクトリを示す環境変数ENCTOOLSROOTPATHが定義されているか確認
echo call :toolsdircheck
echo rem # parameterファイル中のソースファイルへのフルパス^(src_file_path^)を検出
echo call :src_file_path_check
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出
echo call :project_name_check
echo.
echo rem # 各実行ファイルが存在するか確認。存在しない場合ENCTOOLSROOTPATH内部を探索する、もしくはシステムの探索パスに委ねる
)>> "%srtedit_batfile_path%"
echo if exist "%caption2Ass_path%" ^(set caption2Ass_path=%caption2Ass_path%^) else ^(call :find_caption2Ass "%caption2Ass_path%"^)>> "%srtedit_batfile_path%"
echo if exist "%SrtSync_path%" ^(set SrtSync_path=%SrtSync_path%^) else ^(call :find_SrtSync "%SrtSync_path%"^)>> "%srtedit_batfile_path%"
echo if exist "%nkf_path%" ^(set nkf_path=%nkf_path%^) else ^(call :find_nkf "%nkf_path%"^)>> "%srtedit_batfile_path%"
echo if exist "%sed_path%" ^(set sed_path=%sed_path%^) else ^(call :find_sed "%sed_path%"^)>> "%srtedit_batfile_path%"
echo if exist "%sedscript_path%" ^(set sedscript_path=%sedscript_path%^) else ^(call :find_sedscript "%sedscript_path%"^)>> "%srtedit_batfile_path%"
(
echo.
echo rem # 各種実行ファイルへのパスが、最終的にどのような値になったか確認。
echo echo Caption2Ass: %%caption2Ass_path%%
echo echo SrtSync    : %%SrtSync_path%%
echo echo nkf        : %%nkf_path%%
echo echo Onigsed    : %%sed_path%%
echo echo sedscript  : %%sedscript_path%%
echo.
echo :main
echo rem //----- main開始 -----//
echo title %%project_name%%
echo echo デジタル放送の字幕抽出中. . .[%%date%% %%time%%]
echo.
echo rem # Caption2Assを使用してTSファイルから字幕を抽出します
echo set /a caption2Ass_retrycount=^0
echo rem # Caption2Ass_mod1で出力されたsrtファイルの文字コードはUTF-8
echo rem # -tsspオプションが無いとTsSplitterで音声分割されたファイルのタイムコードが正しくならない
echo rem # -forcepcrはforcePCRモード、オプション無しで実行した際に大きくタイムスタンプがズレる場合のみ使用する
echo rem # TsSplitterを使用した実績がある場合のみ-tsspオプションを使用します ※ソースの時点で実行されていた場合は判別不可
echo if exist ".\src\video1_HD-*.ts" ^(
echo     echo _HD-*.tsファイルが存在するため、-tsspオプションを使用します
echo     set caption2ass_tssp=-tssp 
echo ^) else if exist ".\src\video1_SD-*.ts" ^(
echo     echo _SD-*.tsファイルが存在するため、-tsspオプションを使用します
echo     set caption2ass_tssp=-tssp 
echo ^) else ^(
echo     set caption2ass_tssp=
echo ^)
)>> "%srtedit_batfile_path%"
if "%kill_longecho_flag%"=="1" (
    echo if exist "%%src_file_path%%" ^(>> "%srtedit_batfile_path%"
    echo     echo "%%src_file_path%%" から抽出します>> "%srtedit_batfile_path%"
    echo     "%%caption2Ass_path%%" -format srt %caption2ass_tssp%"%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.srt"^>nul>> "%srtedit_batfile_path%"
    echo ^) else if exist "%%src_file_path%%" ^(>> "%srtedit_batfile_path%"
    echo     echo "%%src_file_path%%" から抽出します>> "%srtedit_batfile_path%"
    echo     "%%caption2Ass_path%%" -format srt %caption2ass_tssp%"%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.srt"^>nul>> "%srtedit_batfile_path%"
    echo ^) else ^(>> "%srtedit_batfile_path%"
    echo     echo ※字幕を抽出するソースとなるTSファイルが見つかりません。処理を中断します。>> "%srtedit_batfile_path%"
    echo     exit /b>> "%srtedit_batfile_path%"
    echo ^)>> "%srtedit_batfile_path%"
) else (
    echo if exist "%%src_file_path%%" ^(>> "%srtedit_batfile_path%"
    echo     echo "%%src_file_path%%" から抽出します>> "%srtedit_batfile_path%"
    echo     "%%caption2Ass_path%%" -format srt %caption2ass_tssp%"%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.srt">> "%srtedit_batfile_path%"
    echo ^) else if exist "%%src_file_path%%" ^(>> "%srtedit_batfile_path%"
    echo     echo "%%src_file_path%%" から抽出します>> "%srtedit_batfile_path%"
    echo     "%%caption2Ass_path%%" -format srt %caption2ass_tssp%"%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.srt">> "%srtedit_batfile_path%"
    echo ^) else ^(>> "%srtedit_batfile_path%"
    echo     echo ※字幕を抽出するソースとなるTSファイルが見つかりません。処理を中断します。>> "%srtedit_batfile_path%"
    echo     exit /b>> "%srtedit_batfile_path%"
    echo ^)>> "%srtedit_batfile_path%"
)
(
echo call :Srt_filesize_check
echo title コマンド プロンプト
echo rem //----- main終了 -----//
echo echo end %%~nx0 bat job...
echo echo.
echo exit /b
echo.
rem ------------------------------
echo :Srt_filesize_check
echo rem # srtファイルのファイルサイズが3バイト以上であれば字幕が含まれていたと判断します
echo for %%%%F in ^("%%large_tmp_dir%%%%project_name%%.srt"^) do set srt_filesize=%%%%~zF
echo if %%srt_filesize%% GTR 3 ^(
rem # 上記の比較文字列を""でくくると数値ではなく文字列として処理され、下位桁から比較するので問題が出る ex^)"10" GTR "3"
echo     call :search_unknown_char
echo     call :SrtCutter
echo ^) else ^(
echo     echo ※字幕はみつかりませんでした※
echo     del "%%large_tmp_dir%%%%project_name%%.srt"
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :search_unknown_char
echo rem # 出力されたsrtファイルの中に外字代用字フォントを表す"[外"が含まれていないかチェックします
rem     # 出力された字幕ファイルの中に未知の外字代用字フォントが無いか探索
rem     # findstrコマンドは、対象がShift_JISでなければ機能しない。/Nで行番号オプション
echo findstr /N "[外" "%%large_tmp_dir%%%%project_name%%.srt"^>^> "%%large_tmp_dir%%%%project_name%%_sub.log"
echo for %%%%F in ^("%%large_tmp_dir%%%%project_name%%_sub.log"^) do set srtlog_filesize=%%%%~zF
rem     # findstrによって出力されたログが有効^(3バイト以上^)なら統合、空なら破棄する
echo if %%srtlog_filesize%% GTR 3 ^(
echo     echo "%%project_name%%"^>^> "%%USERPROFILE%%\unknown_letter.log"
echo     copy /b "%%USERPROFILE%%\unknown_letter.log" + "%%large_tmp_dir%%%%project_name%%_sub.log" "%%USERPROFILE%%\unknown_letter.log"
echo     echo.^>^> "%%USERPROFILE%%\unknown_letter.log"
echo     del "%%large_tmp_dir%%%%project_name%%_sub.log"
echo ^) else ^(
echo     del "%%large_tmp_dir%%%%project_name%%_sub.log"
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :SrtCutter
echo rem # Trim編集された形跡があるかチェック
rem # SrtSyncで出力されたsrtファイルの文字コードはShift_JIS
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%S in ^(`findstr /r Trim^^^(.*^^^) "trim_line.txt"`^) do ^(
echo     set search_trimline=%%%%S
echo ^)
echo if "%%search_trimline%%"=="" ^(
echo     echo ※Trim編集なし※
echo     copy "%%large_tmp_dir%%%%project_name%%.srt" ".\tmp\main_sjis.srt"
echo     move "%%large_tmp_dir%%%%project_name%%.srt" ".\log\exported.srt"
echo ^) else ^(
echo     call :SubEdit_phase
echo ^)
echo if exist ".\tmp\main_sjis.srt" ^(
echo     "%%nkf_path%%" -w ".\tmp\main_sjis.srt" ^| "%%sed_path%%" -f "%%sedscript_path%%"^> ".\tmp\main.srt"
echo     del ".\tmp\main_sjis.srt"
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :SubEdit_phase
echo rem # Trimコマンドを読み込んでsrtファイルの必要場所だけカットします
echo "%%SrtSync_path%%" -mode auto -nopause -trim "trim_line.txt" "%%large_tmp_dir%%%%project_name%%.srt"
echo for %%%%N in ^("%%large_tmp_dir%%%%project_name%%_new.srt"^) do set newsrt_filesize=%%%%~zN
echo if not %%newsrt_filesize%%==0 ^(
echo     echo ※指定範囲に字幕あり※
echo     move "%%large_tmp_dir%%%%project_name%%_new.srt" ".\tmp\main_sjis.srt"
echo     move "%%large_tmp_dir%%%%project_name%%.srt" ".\log\exported.srt"
rem     # ASS字幕を出力する設定が有効になっていた場合のみASSを出力する
rem     # srt字幕の出力が終わり、有効範囲に字幕が存在することが確認されてから出力する
rem     # ただし、現状Trimにあわせたカット編集の手段を持ち合わせていない
)>> "%srtedit_batfile_path%"
if "%output_ass_flag%"=="1" (
    echo     echo ASSファイルを抽出します>> "%srtedit_batfile_path%"
    if "%kill_longecho_flag%"=="1" (
        rem echo     start "字幕の抽出中..." /wait "%%caption2Ass_path%%" -format ass %caption2ass_tssp%"%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.ass">> "%srtedit_batfile_path%"
        echo     if %%caption2Ass_retrycount%%==0 ^(>> "%srtedit_batfile_path%"
        echo         "%%caption2Ass_path%%" -format ass %caption2ass_tssp%"%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.ass"^>nul>> "%srtedit_batfile_path%"
        echo     ^) else ^(>> "%srtedit_batfile_path%"
        echo         "%%caption2Ass_path%%" -format ass -forcepcr "%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.ass"^>nul>> "%srtedit_batfile_path%"
        echo     ^)>> "%srtedit_batfile_path%"
        echo     move "%%large_tmp_dir%%%%project_name%%.ass" ".\tmp\exported.ass">> "%srtedit_batfile_path%"
    ) else (
        echo     "%%caption2Ass_path%%" -format ass %caption2ass_tssp%-silent "%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.ass">> "%srtedit_batfile_path%"
        echo     move "%%large_tmp_dir%%%%project_name%%.ass" ".\tmp\main.ass">> "%srtedit_batfile_path%"
    )
)
(
echo ^) else ^(
echo     echo ※指定範囲に字幕なし、-forcepcrオプション付きで再度実行します※
echo     if %%caption2Ass_retrycount%%==0 ^(
echo         move "%%large_tmp_dir%%%%project_name%%.srt" ".\tmp\exported_noforcepcr.srt"
echo         del "%%large_tmp_dir%%%%project_name%%_new.srt"
echo         call :Re-caption2Ass
echo     ^) else ^(
echo         echo 既にCaption2Assでリトライ済みの為、処理を中断します
echo         move "%%large_tmp_dir%%%%project_name%%.srt" ".\tmp\exported_forcepcr.srt"
echo         del "%%large_tmp_dir%%%%project_name%%_new.srt"
echo     ^)
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :Re-caption2Ass
echo rem # 稀に出力されたsrtファイル内の時間が大きくズレる事があるので、-forcepcrオプション付きでリトライします
echo rem # -tsspオプションを-forcepcrオプションと併用するとSrtSyncの出力がNULLになるケースがあるので使用しないこと
echo "%%caption2Ass_path%%" -format srt -forcepcr "%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.srt"^>nul
echo set /a caption2Ass_retrycount=%caption2Ass_retrycount%+^1
echo call :SubEdit_phase
echo exit /b
echo.
rem ------------------------------
echo :toolsdircheck
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 環境変数 ENCTOOLSROOTPATH が未定義です
echo     exit /b
echo ^)
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\
echo if exist "%%ENCTOOLSROOTPATH%%" ^(
echo     exit /b
echo ^) else ^(
echo     echo 環境変数ENCTOOLSROOTPATHが有効なパスではありません
echo     set ENCTOOLSROOTPATH=
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :src_file_path_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%S in ^(`findstr /b /r src_file_path "parameter.txt"`^) do ^(
echo     set %%%%S
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :project_name_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(
echo     set %%%%P
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_caption2Ass
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set caption2Ass_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :caption2Ass_env_search "%%~nx1"
echo exit /b
echo :caption2Ass_env_search
echo set caption2Ass_path=%%~$PATH:1
echo if "%%caption2Ass_path%%"=="" ^(
echo     echo Caption2Assが見つかりません
echo     set caption2Ass_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_SrtSync
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set SrtSync_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :SrtSync_env_search "%%~nx1"
echo exit /b
echo :SrtSync_env_search
echo set SrtSync_path=%%~$PATH:1
echo if "%%SrtSync_path%%"=="" ^(
echo     echo SrtSyncが見つかりません
echo     set SrtSync_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_nkf
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set nkf_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :nkf_env_search "%%~nx1"
echo exit /b
echo :nkf_env_search
echo set nkf_path=%%~$PATH:1
echo if "%%nkf_path%%"=="" ^(
echo     echo nkfが見つかりません
echo     set nkf_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_sed
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set sed_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :sed_env_search "%%~nx1"
echo exit /b
echo :sed_env_search
echo set sed_path=%%~$PATH:1
echo if "%%sed_path%%"=="" ^(
echo     echo Onigsedが見つかりません
echo     set sed_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_sedscript
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set sedscript_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :sedscript_env_search "%%~nx1"
echo exit /b
echo :sedscript_env_search
echo set sedscript_path=%%~$PATH:1
echo if "%%sedscript_path%%"=="" ^(
echo     echo sedscriptが見つかりません
echo     set sedscript_path=%%~1
echo ^)
echo exit /b
)>> "%srtedit_batfile_path%"
rem ------------------------------
exit /b


:mux_option_selector
rem # MP4コンテナへのmuxと最終フォルダへの移動工程
echo rem # 各トラックのMUXと最終フォルダへの移動フェーズ>>"%main_bat_file%"
echo call ".\bat\mux_tracks.bat">>"%main_bat_file%"
echo.>>"%main_bat_file%"
type nul > "%muxtracks_batfile_path%"
rem ------------------------------
(
echo @echo off
echo setlocal
echo.
echo echo start %%~nx0 bat job...
echo echo 各種トラック情報等の統合. . .[%%date%% %%time%%]
echo chdir /d %%~dp0..\
echo.
echo rem # 使用するコピーアプリケーションを選択します
echo call :copy_app_detect
echo rem copy^(Default^), fac^(FastCopy^), ffc^(FireFileCopy^)
echo rem set copy_app_flag=%copy_app_flag%
echo.
echo rem # 最終出力先フォルダを検出
echo call :out_dir_detect
echo rem set final_out_dir=%%HOMEDRIVE%%\%%HOMEPATH%%
echo.
echo rem # 使用するビデオエンコードコーデックタイプに応じて拡張子を判定する関数を呼び出します
echo call :video_extparam_detect
echo rem # 使用するオーディオ処理を判定する関数を呼び出します
echo rem call :audio_job_detect
echo rem # エンコードツールをまとめたディレクトリを示す環境変数ENCTOOLSROOTPATHが定義されているか確認
echo call :toolsdircheck
echo rem # parameterファイル中のソースファイルへのフルパス^(src_file_path^)を検出
echo call :src_file_path_check
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出
echo call :project_name_check
echo rem # 移動先のサブフォルダ^(sub_folder_name^)をソースファイルの親ディレクトリ名に決定
echo call :sub_folder_name_detec "%%src_file_path%%"
echo rem # parameterファイル中のインターレース解除フラグ^(deinterlace_filter_flag^)を検出
echo call :deinterlace_filter_flag_check
echo.
echo rem # 各実行ファイルが存在するか確認。存在しない場合ENCTOOLSROOTPATH内部を探索する、もしくはシステムの探索パスに委ねる
echo rem # それでも見つからない場合、コマンドプロンプト標準のcopyコマンドを使用する
)>> "%muxtracks_batfile_path%"
echo if exist "%muxer_path%" ^(set muxer_path=%muxer_path%^) else ^(call :find_muxer "%muxer_path%"^)>> "%muxtracks_batfile_path%"
echo if exist "%timelineeditor_path%" ^(set timelineeditor_path=%timelineeditor_path%^) else ^(call :find_timelineeditor "%timelineeditor_path%"^)>> "%muxtracks_batfile_path%"
echo if exist "%DtsEdit_path%" ^(set DtsEdit_path=%DtsEdit_path%^) else ^(call :find_DtsEdit "%DtsEdit_path%"^)>> "%muxtracks_batfile_path%"
echo if exist "%mp4box_path%" ^(set mp4box_path=%mp4box_path%^) else ^(call :find_mp4box "%mp4box_path%"^)>> "%muxtracks_batfile_path%"
echo if exist "%mp4chaps_path%" ^(set mp4chaps_path=%mp4chaps_path%^) else ^(call :find_mp4chaps "%mp4chaps_path%"^)>> "%muxtracks_batfile_path%"
echo if exist "%nkf_path%" ^(set nkf_path=%nkf_path%^) else ^(call :find_nkf "%nkf_path%"^)>> "%muxtracks_batfile_path%"
echo if exist "%tsrenamec_path%" ^(set tsrenamec_path=%tsrenamec_path%^) else ^(call :find_tsrenamec "%tsrenamec_path%"^)>> "%muxtracks_batfile_path%"
echo if exist "%AtomicParsley_path%" ^(set AtomicParsley_path=%AtomicParsley_path%^) else ^(call :find_AtomicParsley "%AtomicParsley_path%"^)>> "%muxtracks_batfile_path%"
echo if exist "%ffc_path%" ^(set ffc_path=%ffc_path%^) else ^(call :find_ffc "%ffc_path%"^)>> "%muxtracks_batfile_path%"
echo if exist "%fac_path%" ^(set fac_path=%fac_path%^) else ^(call :find_fac "%fac_path%"^)>> "%muxtracks_batfile_path%"
(
echo.
echo rem # 各種実行ファイルへのパスが、最終的にどのような値になったか確認。
echo echo muxer^(L-SMASH^)         : %%muxer_path%%
echo echo timelineeditor^(L-SMASH^): %%timelineeditor_path%%
echo echo DtsEdit                : %%DtsEdit_path%%
echo echo mp4box                 : %%mp4box_path%%
echo echo mp4chaps               : %%mp4chaps_path%%
echo echo nkf                    : %%nkf_path%%
echo echo tsrenamec              : %%tsrenamec_path%%
echo echo AtomicParsley          : %%AtomicParsley_path%%
echo echo FireFileCopy           : %%ffc_path%%
echo echo FastCopy               : %%fac_path%%
echo echo.
echo echo プロジェクト名         ： %%project_name%%
echo echo サブフォルダ名         ： %%sub_folder_name%%
echo echo インターレース解除     ： %%deinterlace_filter_flag%%
echo rem ※注意点※
echo rem mp4boxは日本語文字列の取り扱いが下手かつ標準出力もUTF-8なので、事前に半角英数にリネームしてから処理する事。
echo.
echo :main
echo rem //----- main開始 -----//
echo title %%project_name%%
echo.
echo set lang_tokens_param=^1
echo set audio_mux_in_files=
echo rem # MUX対象のファイルが存在するか、正常かどうか確認
echo set tmp-file_error_flag=^0
echo if exist ".\tmp\main_temp%%video_ext_type%%" ^(
echo     call :zero-byte_error_check ".\tmp\main_temp%%video_ext_type%%"
echo ^) else ^(
echo     echo ※"main_temp%%video_ext_type%%" ファイルが存在しません
echo     set tmp-file_error_flag=^1
echo ^)
echo if exist ".\tmp\main_audio*.m4a" ^(
echo     for /f "delims=" %%%%A in ^('dir /b ".\tmp\main_audio*.m4a"'^) do ^(
echo         call :zero-byte_error_check ".\tmp\%%%%A"
echo         call :muxer_audio_in_param ".\tmp\%%%%A"
echo     ^)
echo ^) else ^(
echo     echo ※".\tmp\main_audio*.m4a" ファイルが存在しません
echo     set tmp-file_error_flag=^1
echo ^)
echo if "%%tmp-file_error_flag%%"=="1" ^(
echo     echo ※MUX対象ファイルに何らかの異常があるため、MUX処理を中断します。
echo     echo end %%~nx0 bat job...
echo     exit /b
echo ^)
echo.
echo rem # .defファイル中のフレームレート指定の検査
echo if "%%deinterlace_filter_flag%%"=="Its" ^(
echo     echo デインターレースフラグがItsの為、.defファイル内のフレームレート指定をカウントします。
echo     call :def_file_composition_check
echo     echo.
echo ^)
echo.
echo rem # フレームレートオプションを決定
echo if "%%deinterlace_filter_flag%%"=="24fps" ^(
echo     set video_track_fps_opt=?fps=24000/1001
echo ^) else if "%%deinterlace_filter_flag%%"=="30fps" ^(
echo     set video_track_fps_opt=?fps=30000/1001
echo ^) else if "%%deinterlace_filter_flag%%"=="bob" ^(
echo     set video_track_fps_opt=?fps=60000/1001
echo ^) else if "%%deinterlace_filter_flag%%"=="Its" ^(
echo     if not "%%def_24fps_flag%%"=="0" ^(
echo         if "%%def_30fps_flag%%"=="0" ^(
echo             if "%%def_60fps_flag%%"=="0" ^(
echo                 set video_track_fps_opt=?fps=24000/1001
echo             ^) else ^(
echo                 set video_track_fps_opt=?fps=120000/1001
echo             ^)
echo         ^) else ^(
echo             set video_track_fps_opt=?fps=120000/1001
echo         ^)
echo     ^) else ^(
echo         if not "%%def_60fps_flag%%"=="0" ^(
echo             set video_track_fps_opt=?fps=60000/1001
echo         ^) else ^(
echo             set video_track_fps_opt=?fps=30000/1001
echo         ^)
echo     ^)
echo     rem # timelineeditorの --media-timescale / --media-timebase オプションを決定
echo     call :timeline_PTS_opt_detect
echo ^) else ^(
echo     set video_track_fps_opt=
echo ^)
echo.
echo rem # 映像と音声をMUX
echo echo L-SMASHで映像と音声をMUXします[%%date%% %%time%%]
echo rem # L-SMASHの-chapterオプションはogg形式チャプターファイルを読み込めない為使用しません。代わりにmp4chapsを使用します。
echo rem # --file-format にmovを併用すると挙動が不安定になるため非推奨。
echo rem # alternate_group trackオプションはmp4コンテナでは無視されます。
echo echo "%%muxer_path%%" --optimize-pd --file-format mp4 --isom-version 6 -i ".\tmp\main_temp%%video_ext_type%%"%%video_track_fps_opt%% %%audio_mux_in_files%%-o "%%project_name%%.mp4"
echo "%%muxer_path%%" --optimize-pd --file-format mp4 --isom-version 6 -i ".\tmp\main_temp%%video_ext_type%%"%%video_track_fps_opt%% %%audio_mux_in_files%%-o "%%project_name%%.mp4"
echo.
echo rem # タイムコードファイルが存在する場合、timelineeditorを使ってタイムコード埋め込みします
echo if exist ".\tmp\main.tmc" ^(
echo     if "%%deinterlace_filter_flag%%"=="Its" ^(
echo         rename "%%project_name%%.mp4" "%%project_name%%_raw.mp4"
echo         rem # DtsEditはH.265/HEVC非対応
echo         rem # timelineeditorは--media-timescaleオプションを使用しないとQuickTimeで再生できないファイルが出力される^(QuickTime Player v7.7.9で確認^)
echo         rem # timelineeditor^(rev1450^)は、MPC-BE ver1.5.0^(build 2235^)内蔵のMP4/MOVスプリッターで不正終了、QTも再生不能の為非推奨^(rev1432迄なら問題なし^)
echo         rem # DtsEditでmuxしたファイルはPS4で再生ピッチがおかしくなるので一律timelineeditorに切り替え
echo         if "%%video_ext_type%%"==".265" ^(
echo             echo タイムコードファイルを発見したため、timelineeditorで統合します
echo             echo "%%timelineeditor_path%%" --timecode ".\tmp\main.tmc"%%timeline_PTS_opt%% "%%project_name%%_raw.mp4" "%%project_name%%.mp4"
echo             "%%timelineeditor_path%%" --timecode ".\tmp\main.tmc"%%timeline_PTS_opt%% "%%project_name%%_raw.mp4" "%%project_name%%.mp4"
echo         ^) else if "%%video_ext_type%%"==".264" ^(
echo             echo タイムコードファイルを発見したため、timelineeditorで統合します
echo             echo "%%timelineeditor_path%%" --timecode ".\tmp\main.tmc"%%timeline_PTS_opt%% "%%project_name%%_raw.mp4" "%%project_name%%.mp4"
echo             "%%timelineeditor_path%%" --timecode ".\tmp\main.tmc"%%timeline_PTS_opt%% "%%project_name%%_raw.mp4" "%%project_name%%.mp4"
echo             rem echo タイムコードファイルを発見したため、DtsEditで統合します
echo             rem "%%DtsEdit_path%%" -no-dc -s 120000 -tv 2 -tc ".\tmp\main.tmc" -o "%%project_name%%.mp4" "%%project_name%%_raw.mp4"
echo         ^)
echo         del "%%project_name%%_raw.mp4"
echo     ^)
echo ^)
echo.
echo rem # マニュアル24fpsプラグインで作成された.*.chapter.txtファイルが存在する場合リネームします
echo if exist "*.chapter.txt" ^(
echo     echo マニュアル24fpsプラグイン形式のチャプターファイルを発見したため、形式を変換します
echo     for /f "delims=" %%%%N in ^('dir /b "*.chapter.txt"'^) do ^(
echo         rename "%%%%N" "%%project_name%%_sjis.chapters.txt"
echo         "%%nkf_path%%" -w "%%project_name%%_sjis.chapters.txt"^> "%%project_name%%.chapters.txt"
echo         del "%%project_name%%_sjis.chapters.txt"
echo     ^)
echo ^)
echo.
echo rem # チャプターを結合するフェース。mp4chapsの仕様上、MP4ファイルと同じディレクトリに
echo rem # "インポート先MP4ファイル名.chapters.txt"の命名規則で、OGG形式のチャプターファイルを配置する必要があります。
echo rem # QT形式のチャプターは拡張子が.m4vでなければQuickTime Playerで認識できませんが、iTunesであれば.mp4でも使用できます。
echo rem # QuickTime Player^(version 7.7.9^)とiTunes^(12.4.1.6^)で確認
echo rem オプション： -A QTとNeroのハイブリッド / -Q QT形式 / -N Nero形式
echo if exist "%%project_name%%.chapters.txt" ^(
echo     echo チャプターファイルを発見したため、mp4chapsで統合します
echo     "%%mp4chaps_path%%" -i -Q "%%project_name%%.mp4"
echo ^)
echo.
echo rem # 字幕ファイルが存在するかチェック、あった場合それをmuxの工程に組み込みます
echo rem # L-SMASHは字幕のMUXが未実装の為、mp4box^(version 0.6.2以上推奨^)を使用します
echo if exist ".\tmp\main.srt" ^(
echo     echo 字幕あり、mp4boxで統合します
echo     rename "%%project_name%%.mp4" "main_raw.mp4"
echo     rem # Identifierが"sbtl:tx3g"の場合Appleフォーマット、"text:tx3g"の場合3GPP/MPEGアライアンスフォーマット
echo     rem https://gpac.wp.mines-telecom.fr/2014/09/04/subtitling-with-gpac/
echo     rem "%%mp4box_path%%" -add "main_raw.mp4"  -add ".\tmp\main.srt":lang=jpn:group=3:hdlr="sbtl:tx3g":layout=0x60x0x-1 -add "main.srt":disable:lang=jpn:group=3:hdlr="text:tx3g":layout=0x60x0x-1 "mp4box_out.mp4"
echo     "%%mp4box_path%%" -add "main_raw.mp4" -add ".\tmp\main.srt":lang=jpn:group=3:hdlr="sbtl:tx3g":layout=0x60x0x-1 "mp4box_out.mp4"
echo     if exist "mp4box_out.mp4" ^(
echo         echo 字幕の統合が成功しました。
echo         rename "mp4box_out.mp4" "%%project_name%%.mp4"
echo         del "main_raw.mp4"
echo     ^) else ^(
echo         echo 字幕の統合に失敗した模様です。統合前のファイルをオリジナルとして使います。
echo         rename "main_raw.mp4" "%%project_name%%.mp4"
echo     ^)
echo ^) else ^(
echo     echo 字幕なし
echo ^)
echo.
rem # 番組情報を抽出し、CSVファイルを経由してMP4ファイルに埋め込む作業。ソースがTSファイルの場合のみ有効
rem # 大文字かっこ（）を正規表現で話数として扱うと、番組によっては説明書きとして使われる場合もあるため問題
rem echo "%tsrenamec_path%" "%input_media_path%" "@NT1'\[二\]'@NT2'\[字\]'@C'\[新\]'@C'\[終\]'@C'＜新＞'@C'＜終＞'@C'\[二\]'@C'\[字\]'@C'\[デ\]'@NT3'^(#|＃.+^)'@NT4'（.+）'@C' |　*＃.+'@C' |　*#.+'@C'（.+）'@MST@TT,@sb,@PT3@PT4,@YY,@PT1@PT2@YY年@MM月@DD日,@CH,"^> "%%~dp0main.csv"
rem # @C'（.+）'を使用すると、「」内に（）が含まれているとおかしくなる模様。よって暫定的に排除。^(2010/12/28^)
rem echo "%tsrenamec_path%" "%input_media_path%" "@NT1'\[二\]'@NT2'\[字\]'@C'\[新\]'@C'\[終\]'@C'＜新＞'@C'＜終＞'@C'\[二\]'@C'\[字\]'@C'\[デ\]'@NT3'^(#|＃.+^)'@NT4'第.+話'@C' |　*＃.+'@C' |　*#.+'@C'（.+）'@MST@TT,@sb,@PT3@PT4,@YY,@PT1@PT2@YY年@MM月@DD日,@CH,"^> "main.csv"
echo rem # 番組情報の抽出とMP4ファイルへの統合フェーズ
echo if not exist "main.csv" ^(
echo     if exist ".\src\video1.ts" ^(
echo         echo tsrenamecでTSファイルから番組情報を抽出します
echo         echo ".\src\video1.ts"
echo         "%%tsrenamec_path%%" ".\src\video1.ts" "@NT1'\[二\]'@NT2'\[字\]'@C'\[新\]'@C'\[終\]'@C'＜新＞'@C'＜終＞'@C'\[二\]'@C'\[字\]'@C'\[デ\]'@NT3'^(#|＃.+^)'@NT4'第.+話'@C' |　*＃.+'@C' |　*#.+'@MST@TT,@sb,@PT3@PT4,@YY,@PT1@PT2@YY年@MM月@DD日,@CH,"^> "main.csv"
echo     ^) else if exist "%%src_file_path%%" ^(
echo         echo tsrenamecでTSファイルから番組情報を抽出します
echo         echo "%%src_file_path%%"
echo         "%%tsrenamec_path%%" "%%src_file_path%%" "@NT1'\[二\]'@NT2'\[字\]'@C'\[新\]'@C'\[終\]'@C'＜新＞'@C'＜終＞'@C'\[二\]'@C'\[字\]'@C'\[デ\]'@NT3'^(#|＃.+^)'@NT4'第.+話'@C' |　*＃.+'@C' |　*#.+'@MST@TT,@sb,@PT3@PT4,@YY,@PT1@PT2@YY年@MM月@DD日,@CH,"^> "main.csv"
echo     ^)
echo ^)
rem echo for /f "USEBACKQ tokens=1,2,3,4,5,6,7 delims=," %%%%a in ^("main.csv"^) do ^(
rem echo     "%%AtomicParsley_path%%" "%outputmp4_dir%%%project_name%%.mp4" --title "%%%%b" --album "%%%%a" --year "%%%%d" --grouping "%%%%f" --stik "TV Show" --description "%%%%e" --TVNetwork "%%%%f" --TVShowName "%%%%a" --TVEpisode "%%%%c%%%%b" --overWrite
rem echo ^)
rem # デリミター","で分割した際に、中身がブランクの要素があると後ろの要素が繰り上がって変数に代入されるためそれを回避するための小技
echo for /f "usebackq delims=" %%%%i in ^("main.csv"^) do ^(
echo     call :atomicparsley_phase %%%%i
echo ^)
echo.
echo rem # 出力先フォルダへのファイル移動
echo if exist "%%out_dir_1st%%" ^(
echo     call :moveto_final-dir_phase "%%out_dir_1st%%"
echo     if not exist "%%out_dir_1st%%%%sub_folder_name%%\%%project_name%%.mp4" ^(
echo         echo "%%out_dir_1st%%"への出力に失敗しました、移動先フォルダの空きが無い可能性があります。
echo         if exist "%%out_dir_2nd%%" ^(
echo             echo 予備フォルダへの出力を試行します。[%%date%% %%time%%]
echo             call :moveto_final-dir_phase "%%out_dir_2nd%%"
echo             if not exist "%%out_dir_2nd%%%%sub_folder_name%%\%%project_name%%.mp4" ^(
echo                 echo "%%out_dir_2nd%%"への出力に失敗しました、移動先フォルダの空きが無い可能性があります。
echo                 echo ユーザーのホームディレクトリへの出力を試行します。[%%date%% %%time%%]
echo                 call :moveto_final-dir_phase "%%HOMEDRIVE%%\%%HOMEPATH%%"
echo             ^)
echo         ^)
echo     ^)
echo ^) else if exist "%%out_dir_2nd%%" ^(
echo     call :moveto_final-dir_phase "%%out_dir_2nd%%"
echo     if not exist "%%out_dir_2nd%%%%sub_folder_name%%\%%project_name%%.mp4" ^(
echo         echo "%%out_dir_2nd%%"への出力に失敗しました、移動先フォルダの空きが無い可能性があります。
echo         echo ユーザーのホームディレクトリへの出力を試行します。[%%date%% %%time%%]
echo         call :moveto_final-dir_phase "%%HOMEDRIVE%%\%%HOMEPATH%%"
echo     ^)
echo ^) else ^(
echo     echo 設定されている最終ファイルの出力先ディレクトリが何れも存在しません。
echo     echo 代わりにユーザーのホームディレクトリに出力します。
echo     call :moveto_final-dir_phase "%%HOMEDRIVE%%\%%HOMEPATH%%"
echo ^)
echo rem # 出力先ファイルの存在確認
echo if exist "%%final_out_dir%%%%sub_folder_name%%\%%project_name%%.mp4" ^(
echo    echo "%%final_out_dir%%%%sub_folder_name%%\%%project_name%%.mp4" へ出力しました[%%date%% %%time%%]
echo ^) else ^(
echo    echo "%%final_out_dir%%%%sub_folder_name%%\%%project_name%%.mp4" の出力に失敗しました[%%date%% %%time%%]
echo    echo "%%final_out_dir%%%%sub_folder_name%%\%%project_name%%.mp4 の出力に失敗しました[%%date%% %%time%%]"^>^>"%%USERPROFILE%%\mp4output_error.log"
echo ^)
echo.
echo title コマンド プロンプト
echo rem //----- main終了 -----//
echo echo end %%~nx0 bat job...
echo echo.
echo exit /b
echo.
rem ------------------------------
echo :moveto_final-dir_phase
echo if not exist "%%~1%%sub_folder_name%%" ^(
echo     mkdir "%%~1%%sub_folder_name%%"
echo ^)
echo echo 最終出力先フォルダにファイルを転送します
echo echo フォルダパス：%%~1%%sub_folder_name%%
echo if "%%copy_app_flag%%"=="fac" ^(
echo     if exist "%%fac_path%%" ^(
echo         echo FastCopy で移動を実行します
echo         "%%fac_path%%" /cmd=move /force_close /disk_mode=auto "%%project_name%%.mp4" /to="%%~1%%sub_folder_name%%\"
echo     ^) else ^(
echo         set copy_app_flag=copy
echo     ^)
echo ^) else if "%%copy_app_flag%%"=="ffc" ^(
echo     if exist "%%ffc_path%%" ^(
echo         echo FireFileCopy で移動を実行します
echo         "%%ffc_path%%" "%%project_name%%.mp4" /move /a /bg /md /nk /ys /to:"%%~1%%sub_folder_name%%\"
echo     ^) else ^(
echo         set copy_app_flag=copy
echo     ^)
echo ^)
echo if "%%copy_app_flag%%"=="copy" ^(
echo     echo コマンドプロンプト標準のmoveコマンドで移動を実行します
echo     move /Y "%%project_name%%.mp4" "%%~1%%sub_folder_name%%\"
echo ^)
echo set final_out_dir=%%~1
echo exit /b
echo.
rem ------------------------------
echo :atomicparsley_phase
echo rem # AtomicParsley_path用の疑似関数
echo set t=%%*
echo set t="%%t:,=","%%"
echo for /f "usebackq tokens=1-6 delims=," %%%%a in ^(`call echo %%%%t%%%%`^) do ^(
echo     echo 番組情報をAtomicParsleyで統合します
echo     echo --title "%%%%~b" --album "%%%%~a" --year "%%%%~d" --grouping "%%%%~f" --stik "TV Show" --description "%%%%~e" --TVNetwork "%%%%~f" --TVShowName "%%%%~a" --TVEpisode "%%%%~c%%%%~b" --overWrite
echo     "%%AtomicParsley_path%%" "%%project_name%%.mp4" --title "%%%%~b" --album "%%%%~a" --year "%%%%~d" --grouping "%%%%~f" --stik "TV Show" --description "%%%%~e" --TVNetwork "%%%%~f" --TVShowName "%%%%~a" --TVEpisode "%%%%~c%%%%~b" --overWrite
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :zero-byte_error_check
echo for %%%%F in ^("%%~1"^) do set tmp_mux-src_filesize=%%%%~zF
echo echo %%~nx1 ファイルサイズ： %%tmp_mux-src_filesize%% byte
echo if %%tmp_mux-src_filesize%% EQU 0 (
echo     echo ※ゼロバイトファイル発生
echo     set tmp-file_error_flag=^1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :def_file_composition_check
echo set def_24fps_flag=^0
echo set def_30fps_flag=^0
echo set def_60fps_flag=^0
echo for /f "usebackq eol=# tokens=1 delims=[] " %%%%X in ^(`findstr /L "[24]" "main.def"`^) do ^(
echo     call :24fps_counter "%%%%X"
echo ^)
echo for /f "usebackq eol=# tokens=1 delims=[] " %%%%Y in ^(`findstr /L "[30]" "main.def"`^) do ^(
echo     call :30fps_counter "%%%%Y"
echo ^)
echo for /f "usebackq eol=# tokens=1 delims=[] " %%%%Z in ^(`findstr /L "[60]" "main.def"`^) do ^(
echo     call :60fps_counter "%%%%Z"
echo ^)
echo if not "%%def_24fps_flag%%"=="0" echo .def内に24fps定義があります
echo if not "%%def_30fps_flag%%"=="0" echo .def内に30fps定義があります
echo if not "%%def_60fps_flag%%"=="0" echo .def内に60fps定義があります
echo exit /b
echo :24fps_counter
echo if not "%%~1"=="set" ^(
echo     set def_24fps_flag=^1
echo ^)
echo exit /b
echo :30fps_counter
echo if not "%%~1"=="set" ^(
echo     set def_30fps_flag=^1
echo ^)
echo exit /b
echo :60fps_counter
echo if not "%%~1"=="set" ^(
echo     set def_60fps_flag=^1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :timeline_PTS_opt_detect
echo if "%%video_track_fps_opt%%"=="?fps=24000/1001" ^(
echo     set timeline_PTS_opt= --media-timescale 24000 --media-timebase 1001
echo ^) else if "%%video_track_fps_opt%%"=="?fps=30000/1001" ^(
echo     set timeline_PTS_opt= --media-timescale 30000 --media-timebase 1001
echo ^) else if "%%video_track_fps_opt%%"=="?fps=60000/1001" ^(
echo     set timeline_PTS_opt= --media-timescale 60000 --media-timebase 1001
echo ^) else if "%%video_track_fps_opt%%"=="?fps=120000/1001" ^(
echo     set timeline_PTS_opt= --media-timescale 120000 --media-timebase 1001
echo ^) else ^(
echo     set timeline_PTS_opt= 
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :toolsdircheck
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 環境変数 ENCTOOLSROOTPATH が未定義です
echo     exit /b
echo ^)
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\
echo if exist "%%ENCTOOLSROOTPATH%%" ^(
echo     exit /b
echo ^) else ^(
echo     echo 環境変数ENCTOOLSROOTPATHが有効なパスではありません
echo     set ENCTOOLSROOTPATH=
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :src_file_path_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%S in ^(`findstr /b /r src_file_path "parameter.txt"`^) do ^(
echo     set %%%%S
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :project_name_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(
echo     set %%%%P
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :sub_folder_name_detec
echo set upper_folder_path=%%~dp^1
echo set upper_folder_path=%%upper_folder_path:~0,-1%%
echo call :src_upper_foldername_detect "%%upper_folder_path%%.x"
echo exit /b
echo :src_upper_foldername_detect
echo set sub_folder_name=%%~n1
echo exit /b
echo.
rem ------------------------------
echo :video_extparam_detect
echo for /f "usebackq eol=# tokens=2 delims==" %%%%E in ^(`findstr /b /r video_encoder_type "parameter.txt"`^) do ^(
echo     if "%%%%E"=="x264" ^(
echo         set video_ext_type=.264
echo     ^) else if "%%%%E"=="x265" ^(
echo         set video_ext_type=.265
echo     ^) else if "%%%%E"=="qsv_h264" ^(
echo         set video_ext_type=.264
echo     ^) else if "%%%%E"=="qsv_hevc" ^(
echo         set video_ext_type=.265
echo     ^) else if "%%%%E"=="nvenc_h264" ^(
echo         set video_ext_type=.264
echo     ^) else if "%%%%E"=="nvenc_hevc" ^(
echo         set video_ext_type=.265
echo     ^)
echo ^)
echo if "%%video_ext_type%%"=="" ^(
echo     echo パラメータファイルの中にビデオエンコードのコーデック指定が見つかりません。暫定措置として、.264を使用します。
echo     set video_ext_type=.264
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :copy_app_detect
echo for /f "usebackq eol=# tokens=2 delims==" %%%%C in ^(`findstr /b /r copy_app_flag "parameter.txt"`^) do ^(
echo     if "%%%%C"=="fac" ^(
echo         set copy_app_flag=fac
echo     ^) else if "%%%%C"=="ffc" ^(
echo         set copy_app_flag=ffc
echo     ^) else if "%%%%C"=="copy" ^(
echo         set copy_app_flag=copy
echo     ^)
echo ^)
echo if "%%copy_app_flag%%"=="" ^(
echo     echo コピー用アプリのパラメーターが見つかりません、デフォルトのcopyコマンドを使用します。
echo     set copy_app_flag=copy
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :out_dir_detect
echo for /f "usebackq eol=# tokens=1 delims=" %%%%F in ^(`findstr /b /r out_dir_1st "parameter.txt"`^) do ^(
echo     set out_dir_1st=%%%%F
echo ^)
echo if not "%%out_dir_1st%%"=="" ^(
echo     set out_dir_1st=%%out_dir_1st:~12%%
echo ^)
echo if exist "%%out_dir_1st%%" ^(
echo     if not "%%out_dir_1st:~-1%%"=="\" ^(
echo         set out_dir_1st=%%out_dir_1st%%\
echo     ^)
echo     echo 最終ファイルの出力先1：%%out_dir_1st%%
echo ^)
echo for /f "usebackq eol=# tokens=1 delims=" %%%%F in ^(`findstr /b /r out_dir_2nd "parameter.txt"`^) do ^(
echo     set out_dir_2nd=%%%%F
echo ^)
echo if not "%%out_dir_2nd%%"=="" ^(
echo     set out_dir_2nd=%%out_dir_2nd:~12%%
echo ^)
echo if exist "%%out_dir_2nd%%" ^(
echo     if not "%%out_dir_2nd:~-1%%"=="\" ^(
echo         set out_dir_2nd=%%out_dir_2nd%%\
echo     ^)
echo     echo 最終ファイルの出力先2：%%out_dir_2nd%%
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :deinterlace_filter_flag_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%D in ^(`findstr /b /r deinterlace_filter_flag "parameter.txt"`^) do ^(
echo     set %%%%D
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :muxer_audio_in_param
echo set /a lang_tokens_param=lang_tokens_param+^1
echo for /f "usebackq eol=# tokens=%%lang_tokens_param%% delims==,;: " %%%%A in ^(`findstr /b /r audio_lang_param "parameter.txt"`^) do ^(
echo     set audio_track_opt=language=%%%%A,alternate-group=^2
echo ^)
echo if "%%audio_track_opt%%"=="" (
echo     echo 言語指定が見つかりませんでした。代わりに日本語^^^(jpn^^^)を指定します。
echo     set audio_track_opt=language=jpn,alternate-group=^2
echo ^)
echo rem # 音声として2つ目以降のトラックはdisableパラメーターを付与
echo if %%lang_tokens_param%% GTR 2 (
echo     set audio_track_opt=?disable,%%audio_track_opt%%
echo ^) else ^(
echo     set audio_track_opt=?%%audio_track_opt%%
echo ^)
echo rem set audio_mux_in_files=%%audio_mux_in_files%%-i "%%~1"?language=jpn,alternate-group=^2 -i ".\tmp\main_audio_%%audio_pcm_avs_num%%_right.m4a"?disable,language=eng,alternate-group=^2 
echo set audio_mux_in_files=%%audio_mux_in_files%%-i "%%~1"%%audio_track_opt%% 
echo exit /b
echo.
rem ------------------------------
echo :find_muxer
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set muxer_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :muxer_env_search %%~nx1
echo exit /b
echo :muxer_env_search
echo set muxer_path=%%~$PATH:1
echo if "%%muxer_path%%"=="" ^(
echo     echo muxerが見つかりません
echo     set muxer_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_timelineeditor
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set timelineeditor_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :timelineeditor_env_search %%~nx1
echo exit /b
echo :timelineeditor_env_search
echo set timelineeditor_path=%%~$PATH:1
echo if "%%timelineeditor_path%%"=="" ^(
echo     echo timelineeditorが見つかりません
echo     set timelineeditor_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_DtsEdit
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set DtsEdit_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :DtsEdit_env_search %%~nx1
echo exit /b
echo :DtsEdit_env_search
echo set DtsEdit_path=%%~$PATH:1
echo if "%%DtsEdit_path%%"=="" ^(
echo     echo DtsEditが見つかりません
echo     set DtsEdit_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_mp4box
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set mp4box_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :mp4box_env_search %%~nx1
echo exit /b
echo :mp4box_env_search
echo set mp4box_path=%%~$PATH:1
echo if "%%mp4box_path%%"=="" ^(
echo     echo mp4boxが見つかりません
echo     set mp4box_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_mp4chaps
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set mp4chaps_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :mp4chaps_env_search %%~nx1
echo exit /b
echo :mp4chaps_env_search
echo set mp4chaps_path=%%~$PATH:1
echo if "%%mp4chaps_path%%"=="" ^(
echo     echo mp4chapsが見つかりません
echo     set mp4chaps_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_nkf
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set nkf_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :nkf_env_search %%~nx1
echo exit /b
echo :nkf_env_search
echo set nkf_path=%%~$PATH:1
echo if "%%nkf_path%%"=="" ^(
echo     echo nkfが見つかりません
echo     set nkf_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_AtomicParsley
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set AtomicParsley_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :AtomicParsley_env_search %%~nx1
echo exit /b
echo :AtomicParsley_env_search
echo set AtomicParsley_path=%%~$PATH:1
echo if "%%AtomicParsley_path%%"=="" ^(
echo     echo AtomicParsleyが見つかりません
echo     set AtomicParsley_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_tsrenamec
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set tsrenamec_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :tsrenamec_env_search %%~nx1
echo exit /b
echo :tsrenamec_env_search
echo set tsrenamec_path=%%~$PATH:1
echo if "%%tsrenamec_path%%"=="" ^(
echo     echo tsrenamecが見つかりません
echo     set tsrenamec_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_ffc
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set ffc_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :ffc_env_search %%~nx1
echo exit /b
echo :ffc_env_search
echo set ffc_path=%%~$PATH:1
echo if "%%ffc_path%%"=="" echo FireFileCopyが見つかりません、代わりにコマンドプロンプト標準のcopyコマンドを使用します。
echo exit /b
echo.
rem ------------------------------
echo :find_fac
echo echo findexe引数："%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。
echo ^) else ^(
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%
echo     echo 探索しています...
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo 見つかりました
echo         set fac_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo 見つかりませんでした。システムのパス探索に委ねます。
echo ^)
echo call :fac_env_search %%~nx1
echo exit /b
echo :fac_env_search
echo set fac_path=%%~$PATH:1
echo if "%%fac_path%%"=="" echo FastCopyが見つかりません、代わりにコマンドプロンプト標準のcopyコマンドを使用します。
echo exit /b
)>> "%muxtracks_batfile_path%"
rem ------------------------------
exit /b


:del_tmp_files
rem # 作業用のソースファイルおよび不要な一時ファイルの削除フェーズ
echo call ".\bat\del_tmp.bat">>"%main_bat_file%"
echo.>> "%main_bat_file%"
type nul > "%deltmp_batfile_path%"
(
echo @echo off
echo setlocal
echo echo start %%~nx0 bat job...
echo cd /d %%~dp0..\
echo.
echo rem # %%large_tmp_dir%% の存在確認および末尾チェック
echo if not exist "%%large_tmp_dir%%" ^(
echo     echo 大きなファイルを出力する一時フォルダ %%%%large_tmp_dir%%%% が存在しません、代わりにシステムのテンポラリフォルダで代用します。
echo     set large_tmp_dir=%%tmp%%
echo ^)
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出
echo call :project_name_check
echo.
echo rem //----- main開始 -----//
echo title %%project_name%%
echo.
echo if exist ".\src\video1.ts" del ".\src\video1.ts"^&echo ".\src\video1.ts" deleted
echo if exist ".\src\video1.d2v" del ".\src\video1.d2v"^&echo ".\src\video1.d2v" deleted
echo if exist ".\src\video1.gl" del ".\src\video1.gl"^&echo ".\src\video1.gl" deleted
echo if exist ".\src\video1.ts.lwi" del ".\src\video1.ts.lwi"^&echo ".\src\video1.ts.lwi" deleted
echo if exist ".\src\audio_pcm*.wav" del ".\src\audio_pcm*.wav"^&echo ".\src\audio_pcm*.wav" deleted
echo if exist ".\src\audio_faw*.wav" del ".\src\audio_faw*.wav"^&echo ".\src\audio_faw*.wav" deleted
echo if exist ".\src\audio*_demux DELAY *ms.aac" del ".\src\audio*_demux DELAY *ms.aac"^&echo ".\src\audio*_demux DELAY *ms.aac" deleted
echo.
echo if exist ".\src\video1_HD-*.ts" del ".\src\video1_HD-*.ts"^&echo ".\src\video1_HD-*.ts" deleted
echo if exist ".\src\video1_HD-*.d2v" del ".\src\video1_HD-*.d2v"^&echo ".\src\video1_HD-*.d2v" deleted
echo if exist ".\src\video1_HD-*.gl" del ".\src\video1_HD-*.gl"^&echo ".\src\video1_HD-*.gl" deleted
echo if exist ".\src\video1_HD-*.ts.lwi" del ".\src\video1_HD-*.ts.lwi"^&echo ".\src\video1_HD-*.ts.lwi" deleted
echo.
echo if exist ".\src\video1_SD-*.ts" del ".\src\video1_SD-*.ts"^&echo ".\src\video1_SD-*.ts" deleted
echo if exist ".\src\video1_SD-*.d2v" del ".\src\video1_SD-*.d2v"^&echo ".\src\video1_SD-*.d2v" deleted
echo if exist ".\src\video1_SD-*.gl" del ".\src\video1_SD-*.gl"^&echo ".\src\video1_SD-*.gl" deleted
echo if exist ".\src\video1_SD-*.ts.lwi" del ".\src\video1_SD-*.ts.lwi"^&echo ".\src\video1_SD-*.ts.lwi" deleted
echo.
echo if exist "%%large_tmp_dir%%%%project_name%%*DELAY *ms.aac" del "%%large_tmp_dir%%%%project_name%%*DELAY *ms.aac"^&echo "%%large_tmp_dir%%%%project_name%%*DELAY *ms.aac" deleted
echo if exist "%%large_tmp_dir%%%%project_name%%*.wav" del "%%large_tmp_dir%%%%project_name%%*.wav"^&echo "%%large_tmp_dir%%%%project_name%%*.wav" deleted
echo if exist "%%large_tmp_dir%%%%project_name%%*_aac_edit.wav" del "%%large_tmp_dir%%%%project_name%%*_aac_edit.wav"^&echo "%%large_tmp_dir%%%%project_name%%*_aac_edit.wav" deleted
echo if exist "%%large_tmp_dir%%%%project_name%%.srt" del "%%large_tmp_dir%%%%project_name%%.srt"^&echo "%%large_tmp_dir%%%%project_name%%.srt" deleted
echo if exist "%%large_tmp_dir%%%%project_name%%_new.srt" del "%%large_tmp_dir%%%%project_name%%_new.srt"^&echo "%%large_tmp_dir%%%%project_name%%_new.srt" deleted	
echo.
echo title コマンド プロンプト
echo rem //----- main終了 -----//
echo echo end %%~nx0 bat job...
echo echo.
echo.
rem ------------------------------
echo :project_name_check
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(
echo     set %%%%P
echo ^)
echo exit /b
echo.
rem ------------------------------
)>> "%deltmp_batfile_path%"
exit /b


:last_order
rem # メインバッチに終了時刻表示コマンドを書き込み
echo echo ### 終了時刻[%%date%% %%time%%] ###>> "%main_bat_file%"
echo echo.>> "%main_bat_file%"
exit /b


:cleanup_phase
rem ----------------------------
rem # バッチモード関係
set src_video_wide_pixel=
set src_video_hight_pixel=
set src_video_pixel_aspect_ratio=
set videoAspectratio_option=
set avs_filter_type=

set x264_Encode_option=
set x265_Encode_option=
set x264_Encode_option_mod=
set x265_Encode_option_mod=
set crf_value=
set vfr_peak_rate=
set resize_algo_flag=
set resize_wpix=
set resize_hpix=
rem # 0:FAW / 1:faad→neroAacEnc / 2:sox / 3:5.1chMIX
set audio_job_flag=

rem # Videoエンコードオプション
set video_HP@L40_option=
set video_MP@L32_option=
set video_MP@L31_option=
set video_MP@L30_option=
set video_par1x1_option=
set video_par4x3_option=
set video_par40x33_option=
set video_par10x11_option=
rem PSP 4:3 / 360*270 / 368*272

set src_broadcaster_name=
set lgd_file_counter=
set lgd_file_name=
set bon_audio_flag=
set bon_audio_type=
set resizealgorithm=
set deinterlace_filter_flag=
set already_avs_detect_flag=
set ItsCut_switch=
set use_itvfr_flag=
set writing_cc_flag=
set bat_start_wait=
set x264_VUI_opt=
set x265_VUI_opt=

rem -----------------------------
exit /b


:parameter_shift
rem ### バッチパラメータをシフト ###
rem # %9 は %8 に、... %1 は %0 に
shift /1
rem # バッチパラメータが空なら終了
if "%~1"=="" goto end
echo ------------------------------
echo.
goto :main_function

:error
echo.
echo ### error! ###
echo.
echo %error_message%
rem # ダブルクリック、もしくはD&Dで呼び出された場合はpause
set cmd_env_chars=%CMDCMDLINE%
if not ""^%cmd_env_chars:~-1%""==""^ "" (
    echo ウィンドウを閉じるには、何かキーを押してください。
    pause>nul
)
echo.
set exit_stat=1
exit /b

:end
echo ### 作業終了時刻 ###
echo [%time%]
echo.
rem # ダブルクリック、もしくはD&Dで呼び出された場合はpause
set cmd_env_chars=%CMDCMDLINE%
if not ""^%cmd_env_chars:~-1%""==""^ "" (
    echo ウィンドウを閉じるには、何かキーを押してください。
    pause>nul
)
exit /b


:help_message
echo.
echo ddaenc - auto encode bat tools rev.%release_version%
echo.
echo Usage: ddaenc.bat [options] input1 input2 input3...
echo.
echo option:
echo     -b, --bat-mode
echo                    to specify bat mode switch
echo     -w, --work ^<string^>
echo                    project work directory path
echo     -o, --output ^<string^>
echo                    output directory path
echo     -e, --encoder ^<string^>
echo                    encoder type (Default:%video_encoder_type%)
echo                    [x264, x265, qsv_h264(QSVEncC H.264/AVC), 
echo                     qsv_hevc(QSVEncC H.265/HEVC), nvenc_h264(NVEncC H.264/AVC),
echo                     nvenc_hevc(NVEncC H.265/HEVC)]
echo     -q, --crf ^<int^>
echo                    CRF^(Constant Rate Factor^) Quality-based VBR [0-51]
echo     -m, --mpeg2-dec ^<int^>
echo                    mpeg2 decoder select (Default:%mpeg2dec_select_flag%)
echo                    [1:MPEG-2 VIDEO VFAPI Plug-In, 2:DGMPGDEC, 3:L-SMASH Works]
echo     -a, --audio-job ^<string^>
echo                    audio process type [faw(Default), sox, nero]
echo     -r, --resize ^<float^>
echo                    output video resize resolution
echo                    [none(Default), 1080, 900, 810, 720, 540, 480, 270]
echo     -z, --resize-algo ^<string^>
echo                    output video resize algorism
echo                    [bilinear, bicubic, lanczos4, spline64(Default), dither]
echo     -t, --template ^<string^>
echo                    template AVS file path
echo     -l, --lgd-file ^<string^>
echo                    .lgd Logo file path
echo     -j, --jl-file ^<string^>
echo                    JL template file path
echo     -f, --jl-flag ^<flag1,flag2,...^>
echo                    JL custom flag parameter
echo     -d, --deint ^<string^>
echo                    deinterlace filter flag
echo                    [its(Default), 24fps, 30fps, itvfr, bob, interlace]
echo     -v, --vfr ^<string^>
echo                    AutoVfr mode select [normal(Default), fast]
echo     -i, --vfr-ini ^<string^>
echo                    AutoVfr.ini file path
echo     -s, --splitter ^<"string1 string2..."^>
echo                    TsSplitter flag and options
echo                    [-EIT] [-ECM] [-EMM] [-HD] [-SD] [-SDx] [-1SEG] etc...
echo     -c, --crop ^<string^>
echo                    crop size select [none(Default), sidecut, gakubuchi]
echo.
rem # ダブルクリック、もしくはD&Dで呼び出された場合はpause
set cmd_env_chars=%CMDCMDLINE%
if not ""^%cmd_env_chars:~-1%""==""^ "" (
    echo ウィンドウを閉じるには、何かキーを押してください。
    pause>nul
)
exit /b


:exit
endlocal