@echo off
setlocal

:start
rem #//--- バージョン情報 ---//
set release_version=3.2.12.180511

rem #//--- 各種出力先ディレクトリへのパス ---//

rem ### 作業用ディレクトリ(%work_dir%) ###
set work_dir=I:\avs temp\

rem ### テンポラリディレクトリ(%large_tmp_dir%) ###
rem # TsSplitter前の一時コピー先 / ts2aac&FAWのAAC出力 / 音声エンコーダーに渡す前のWAVなど
rem %large_tmp_dir%を環境変数で事前に設定

rem ### 最終出力ファイルを移動するフォルダへのパス ###
rem # ここのフォルダが何れも存在しない場合、ユーザーのホームフォルダに移動されます
set out_dir_1st=\\Servername\share\mp4 video\
set out_dir_2nd=D:\output video\

rem ### 連続実行用バッチファイルまでのパス ###
set calling_bat_file=%USERPROFILE%\Call_Encoding.bat

rem ### 出力失敗した際のエラーログ ###
set error_log_file=%USERPROFILE%\mp4output_error.log

rem ### 未知の外字代用字が見つかったときの警告ログ ###
set unknown_letter_log=%USERPROFILE%\unknown_letter.log

rem # エンコーダー選択
rem x265, x264, qsv_h264, qsv_hevc, nvenc_h264, nvenc_hevc
set video_encoder_type=x264

rem //--- x265 オプション ---//
rem ### x265.exe へのpath ###
rem # 入手先
:   https://onedrive.live.com/?authkey=%21AJWOVN55IpaFffo&id=6BDD4375AC8933C6%213306&cid=6BDD4375AC8933C6
set x265_path=%USERPROFILE%\AppData\Local\rootfs\bin\x265_2.1+11_x64_pgo.exe

rem ### MainProfile@Level 4.1 (Main Tier)オプション(VUI optionsを除く) ###
set x265_MP@L41_option=--crf 18 --profile main --level-idc 4.1 --preset slow --no-high-tier

rem ### MainProfile@Level 4.0 (Main Tier)オプション(VUI optionsを除く) ###
set x265_MP@L40_option=--crf 18 --profile main --level-idc 4.0 --preset slow --no-high-tier

rem ### MainProfile@Level 3.1 (Main Tier)オプション(VUI optionsを除く) ###
set x265_MP@L31_option=--crf 18 --profile main --level-idc 3.1 --preset slow --no-high-tier

rem ### MainProfile@Level 3.0 (Main Tier)オプション(VUI optionsを除く) ###
set x265_MP@L30_option=--crf 18 --profile main --level-idc 3.0 --preset slow --no-high-tier


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
rem set x264_path=%USERPROFILE%\AppData\Local\rootfs\bin\x264_r2851_8dpt_x86.exe
set x264_path=%USERPROFILE%\AppData\Local\rootfs\bin\x264_r2901_8dpt_x64.exe

rem ### HighProfile@Level 4.2 オプション(VUI optionsを除く) ###
set x264_HP@L42_option=--crf 18 --profile high --level 4.2 --ref 3 --bframes 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --8x8dct --nal-hrd vbr --vbv-maxrate 62500 --vbv-bufsize 78125 --no-fast-pskip --qpstep 8

rem ### HighProfile@Level 4.0 オプション(VUI optionsを除く) ###
rem set x264_HP@L40_option=--crf 21 --profile high --level 4 --sar 4:3 --ref 3 --bframes 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --8x8dct --nal-hrd vbr --vbv-maxrate 25000 --vbv-bufsize 31250 --no-fast-pskip --qpstep 8 --videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 --threads 4
set x264_HP@L40_option=--crf 18 --profile high --level 4 --ref 3 --bframes 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --8x8dct --nal-hrd vbr --vbv-maxrate 25000 --vbv-bufsize 31250 --no-fast-pskip --qpstep 8

rem ### MainProfile@Level 3.2 オプション(VUI optionsを除く) ###
set x264_MP@L32_option=--crf 18 --profile main --level 3.2 --ref 2 --bframes 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --nal-hrd vbr --vbv-maxrate 20000 --vbv-bufsize 10000 --no-fast-pskip --qpstep 8

rem ### MainProfile@Level 3.1 オプション(VUI optionsを除く) ###
set x264_MP@L31_option=--crf 18 --profile main --level 3.1 --ref 2 --bframes 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --nal-hrd vbr --vbv-maxrate 14000 --vbv-bufsize 10000 --no-fast-pskip --qpstep 8

rem ### MainProfile@Level 3.0 オプション(VUI optionsを除く) ###
set x264_MP@L30_option=--crf 18 --profile main --level 3 --ref 2 --bframes 2 --b-pyramid none --cqm flat --subme 9 --me umh --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --nal-hrd vbr --vbv-maxrate 10000 --vbv-bufsize 10000 --no-fast-pskip --qpstep 8

rem ### MainProfile@Level 2.1 オプション(VUI optionsを除く) ###
set x264_MP@L21_option=--crf 20 --profile main --level 21 --ref 2 --bframes 2 --b-pyramid none --cqm flat --subme 9 --me umh --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --nal-hrd vbr --vbv-maxrate 4000 --vbv-bufsize 4000 --no-fast-pskip --qpstep 8

rem ### インターレース保持エンコーディングをする場合のオプション ###
rem # Profile Level3
set x264_interlace_Lv3=--interlace --tff 
rem # Profile Level4
set x264_interlace_Lv4=--interlace --tff --weightp 0 


rem ### QSVEncC.exe へのpath ###
rem # 入手先
:   http://rigaya34589.blog135.fc2.com/blog-entry-337.html
set qsvencc_path=%USERPROFILE%\AppData\Local\rootfs\opt\QSVEnc\QSVEncC\x86\QSVEncC.exe

set qsv_Encode_option=--y4m 


rem ### NVEncC.exe へのpath ###
rem # 入手先
:   http://rigaya34589.blog135.fc2.com/blog-entry-739.html
set nvencc_path=%USERPROFILE%\AppData\Local\rootfs\opt\NVEnc\NVEncC\x86\NVEncC.exe

set nvenc_Encode_option=--y4m 


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
set dgindex_path="%USERPROFILE%\AppData\Local\rootfs\usr\DGMPGDec\DGIndex.exe"

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
set ffc_path=%USERPROFILE%\AppData\Local\rootfs\usr\FireFileCopy\FFC.exe

rem # FastCopy へのパス
set fac_path=C:\Program Files\FastCopy\fastcopy.exe

rem ### MPEG-2 VIDEO VFAPI Plug-In（m2v.vfp） のパス###
rem # mpeg2dec_select_flag=1 の場合に必要。
set m2v_vfp_path=%USERPROFILE%\AppData\Local\rootfs\opt\m2v_vfp\m2v.vfp

rem ### avs4x26x.exe へのpath ###
set avs4x26x_path=%USERPROFILE%\AppData\Local\rootfs\bin\avs4x26x.exe

rem ### TsSplitter へのパス###
set TsSplitter_path=%USERPROFILE%\AppData\Local\rootfs\usr\TsSplitter\TsSplitter.exe

rem ### FakeAacWave へのパス ###
set FAW_path=%USERPROFILE%\AppData\Local\rootfs\usr\FakeAacWav\fawcl.exe

rem ### ts2aac へのパス ###
rem ※ts2aacは原則としてMPEG2 VFAPI Plug-Inかつビデオの先頭非closed GOPでなければ正常に機能しない, ts_parserの使用を推奨
set ts2aac_path=%USERPROFILE%\AppData\Local\rootfs\usr\ts2aac\ts2aac.exe

rem ### ts_parser へのパス ###
rem ※使用するMPEG-2デコーダーに応じて --delay-type オプションを変更する, ソースTSにDropがある場合のみts2aacの使用を推奨
set ts_parser_path=%USERPROFILE%\AppData\Local\rootfs\bin\ts_parser.exe

rem ### faad へのパス ###
set faad_path=%USERPROFILE%\AppData\Local\rootfs\bin\faad.exe

rem ### avs2wav へのパス ###
rem set avs2wav_path=%USERPROFILE%\AppData\Local\rootfs\bin\avs2wav.exe
rem http://www.ku6.jp/keyword19/1.html
set avs2wav_path=%USERPROFILE%\AppData\Local\rootfs\bin\avs2wav32.exe

rem ### avs2pipe(mod) へのパス ###
set avs2pipe_path=%USERPROFILE%\AppData\Local\rootfs\bin\avs2pipemod.exe

rem ### logoframe へのパス ###
set logoframe_path=%USERPROFILE%\AppData\Local\rootfs\usr\logoframe\logoframe.exe

rem ### chapter_exe へのパス ###
set chapter_exe_path=%USERPROFILE%\AppData\Local\rootfs\usr\chapter_exe\chapter_exe.exe

rem ### join_logo_scp へのパス ###
set join_logo_scp_path=%USERPROFILE%\AppData\Local\rootfs\usr\join_logo_scp\join_logo_scp.exe

rem ### AutoVfr へのパス ###
set autovfr_path=%USERPROFILE%\AppData\Local\rootfs\bin\AutoVfr.exe

rem ### AutoVfr.ini へのパス(存在しない場合、AutoVfr.exeと同じフォルダを探索) ###
set autovfrini_path=%USERPROFILE%\AppData\Local\rootfs\bin\AutoVfr.ini

rem ### ext_bs へのパス ###
set ext_bs_path=%USERPROFILE%\AppData\Local\rootfs\bin\ext_bs.exe

rem ### muxer.exe(L-SMASH) へのパス ###
set muxer_path=%USERPROFILE%\AppData\Local\rootfs\bin\muxer.exe

rem ### remuxer.exe(L-SMASH) へのパス ###
set remuxer_path=%USERPROFILE%\AppData\Local\rootfs\bin\remuxer.exe

rem ### timelineeditor.exe(L-SMASH) へのパス ###
set timelineeditor_path=%USERPROFILE%\AppData\Local\rootfs\bin\timelineeditor.exe

rem ### mp4box へのパス ### ※削除予定
rem # 音声ストリームのdisableオプションのため、要version 0.4.5以降
set mp4box_path=C:\Program Files\GPAC\mp4box.exe

rem ### mp4chaps へのパス ### ※削除予定
set mp4chaps_path=%USERPROFILE%\AppData\Local\rootfs\bin\mp4chaps.exe

rem ### DtsEdit へのパス ###
rem # QT再生互換の為に必要
set DtsEdit_path=%USERPROFILE%\AppData\Local\rootfs\bin\DtsEdit.exe

rem ### sox へのパス ###
set sox_path=%USERPROFILE%\AppData\Local\rootfs\usr\sox-14.2.0\sox.exe

rem ### neroAacEnc へのパス ###
set neroAacEnc_path=%USERPROFILE%\AppData\Local\rootfs\bin\neroAacEnc.exe

rem ### mp4creator60 へのパス ### ※削除予定
set mp4creator60_path=%USERPROFILE%\AppData\Local\rootfs\bin\mp4creator60.exe

rem ### aacgain へのパス ###
set aacgain_path=%USERPROFILE%\AppData\Local\rootfs\bin\aacgain.exe

rem ### ffmpeg へのパス ###
set ffmpeg_path=%USERPROFILE%\AppData\Local\rootfs\bin\ffmpeg.exe

rem ### Comskip へのパス ###
set comskip_path=%USERPROFILE%\AppData\Local\rootfs\usr\Comskip\comskip.exe

rem ### comskip.ini へのパス ###
set comskipini_path=%USERPROFILE%\AppData\Local\rootfs\usr\Comskip\comskip.ini

rem ### caption2Ass(_mod) へのパス ###
set caption2Ass_path=%USERPROFILE%\AppData\Local\rootfs\usr\Caption2Ass_mod1\Caption2Ass_mod1.exe

rem ### SrtSync へのパス ###
rem # 要.NET Framework 3.5
set SrtSync_path=%USERPROFILE%\AppData\Local\rootfs\bin\SrtSync.exe

rem ### nkf(文字コード変更ツール) へのパス ###
set nkf_path=%USERPROFILE%\AppData\Local\rootfs\bin\nkf.exe

rem ### sed(onigsed) へパス ###
set sed_path=%USERPROFILE%\AppData\Local\rootfs\bin\onigsed.exe

rem ### sedスクリプト へのパス ###
set sedscript_path=%USERPROFILE%\AppData\Local\rootfs\usr\Caption2Ass_mod1\Gaiji\ARIB2Unicode.txt

rem ### tsrenamec へのパス ###
set tsrenamec_path=%USERPROFILE%\AppData\Local\rootfs\bin\tsrenamec.exe

rem ### AtomicParsley へのパス ###
set AtomicParsley_path=%USERPROFILE%\AppData\Local\rootfs\bin\AtomicParsley.exe

rem ### KeyIn.VB.NET へのパス ###
rem http://www.vector.co.jp/soft/winnt/util/se461954.html
rem # .NET Framework 3.5 が必要。KeyInを使うかどうかは%use_NetFramework_switch%で指定
set KeyIn_path=%USERPROFILE%\AppData\Local\rootfs\bin\KeyIn.exe

rem ### MediaInfo CLI へのパス ###
set MediaInfoC_path=%USERPROFILE%\AppData\Local\rootfs\usr\MediaInfo_CLI\MediaInfo.exe


rem //--- 各種テンプレートへのパス ---//

rem ### ロゴファイル(.lgd)のソースフォルダを指定 ###
set lgd_file_src_path=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\lgd

rem ### カット処理方法スクリプト(JL)のソースフォルダを指定 ###
set JL_src_dir=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\JL

rem ### デフォルトで使用するカット処理方法スクリプト(JL)のファイル名を指定 ###
set JL_file_name=JL_標準.txt

rem ### プラグイン読み込みテンプレートのパス ###
rem # use_auto_loading=0 の場合に必要。
set plugin_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\LoadPlugin.avs

rem ### AutoVfr テンプレートのパス ###
set autovfr_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\Auto_Vfr.avs

rem ### AutoVfr_Fast テンプレートのパス ###
set autovfr_fast_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\Auto_Vfr_Fast.avs

rem ### AutoVfr の逆テレシネを手動/自動どちらでやるか設定します ###
rem # 0: 手動 / 1: 自動
set autovfr_deint=1

rem ### ソース読み込みフィルタテンプレートのパス ###
set load_source=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\LoadSource.avs

rem ### フィールドファースト指定テンプレートのパス ###
set aff_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\assume_field_first.avs

rem ### インターレース状態で適用するフィルタのテンプレートパス ###
set interlaced_filter_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\interlaced_filter.avs

rem ### インターレース解除フィルタテンプレートのパス ###
set deinterlace_filter_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\deinterlace_filter.avs

rem ### インターレース解除状態で適用するフィルタテンプレートのパス ###
set uninterlaced_filter_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\uninterlaced_filter.avs

rem ### return_last フィルタテンプレートのパス ###
set return_last_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\return_last.avs

rem ### def ファイルへパス ###
set def_itvfr_file=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\foo.def

rem ### itvfr フィルタテンプレートのパス ###
set itvfr_filter_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\itvfr.avs

rem ### 24p フィルタテンプレートのパス ###
set 24p_filter_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\24p.avs

rem ### interlace フィルタテンプレートのパス ###
set interlace_filter_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\interlace.avs

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


:bat_option_detect_phase
rem # 一番親の引数変数がshiftするように、callは使用しない事
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
    set out_dir_1st=%~2
    shift /1
    shift /1
) else if "%~1"=="--output" (
    set bat_mode=1
    set out_dir_1st=%~2
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
) else if "%~1"=="-s" (
    set bat_mode=1
    set TsSplitter_flag=1
    shift /1
) else if "%~1"=="--splitter" (
    set bat_mode=1
    set TsSplitter_flag=1
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
) else if "%~1"=="-n" (
    set bat_mode=1
    set NR_filter_flag=1
    shift /1
) else if "%~1"=="--nr-filter" (
    set bat_mode=1
    set NR_filter_flag=1
    shift /1
) else if "%~1"=="-p" (
    set bat_mode=1
    set Sharp_filter_flag=1
    shift /1
) else if "%~1"=="--sharp-filter" (
    set bat_mode=1
    set Sharp_filter_flag=1
    shift /1
) else if "%~1"=="-x" (
    set bat_mode=1
    set DeDot_cc_filter_flag=1
    shift /1
) else if "%~1"=="--dedot-filter" (
    set bat_mode=1
    set DeDot_cc_filter_flag=1
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
rem # バッチモードの未指定パラメーターをデフォルト値にセットする
if "%bat_mode%"=="1" (
    if not exist "%work_dir%" (
        set work_dir=%HOMEDRIVE%%HOMEPATH%
    )
    if "%video_encoder_type%"=="" (
        set video_encoder_type=x264
    )
    if "%audio_job_flag%"=="" (
        set audio_job_flag=faw
    )
    if "%bat_vresize_flag%"=="" (
        set bat_vresize_flag=none
    )
    if "%JL_src_file_full-path%"=="" (
        set JL_src_file_full-path=%JL_src_dir%%JL_file_name%
    )
    if "%deinterlace_filter_flag%"=="" (
        set deinterlace_filter_flag=Its
    )
    if "%autovfr_mode%"=="" (
        set autovfr_mode=0
    )
    if "%TsSplitter_flag%"=="" (
        set TsSplitter_flag=0
    )
    if "%Crop_size_flag%"=="" (
        set Crop_size_flag=none
    )
    if "%NR_filter_flag%"=="" (
        set NR_filter_flag=0
    )
    if "%Sharp_filter_flag%"=="" (
        set Sharp_filter_flag=0
    )
    if "%DeDot_cc_filter_flag%"=="" (
        set DeDot_cc_filter_flag=0
    )
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
rem # work_dir が存在するかチェック
if not exist "%work_dir%" (
    rem # エラーメッセージの設定
    set error_message=AVS を出力するフォルダのパスが間違っています。
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
    echo プロジェクト作業フォルダ：%work_dir%
    echo 出力フォルダ：%out_dir_1st%
    echo エンコーダー：%video_encoder_type%
    echo オーディオ：%audio_job_flag%
    echo リサイズ：%bat_vresize_flag%
    echo JLファイル：%JL_src_file_full-path%
    echo デインターレース方式：%deinterlace_filter_flag%
    echo AutoVfr方式：%autovfr_mode%
    echo TsSplitter：%TsSplitter_flag%
    echo Crop指定：%Crop_size_flag%
    echo NRフィルタ：%NR_filter_flag%
    echo シャープフィルタ：%Sharp_filter_flag%
    echo DeDotフィルタ：%DeDot_cc_filter_flag%
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
    echo --- 入力ファイル： %~1
) else if "%~x1"==".m2ts" (
    echo --- 入力ファイル： %~1
) else if "%~x1"==".mpg" (
    echo --- 入力ファイル： %~1
) else if "%~x1"==".mpeg" (
    echo --- 入力ファイル： %~1
) else if "%~x1"==".m2p" (
    echo --- 入力ファイル： %~1
) else if "%~x1"==".mpv" (
    echo --- 入力ファイル： %~1
) else if "%~x1"==".m2v" (
    echo --- 入力ファイル： %~1
) else if "%~x1"==".dv" (
    echo --- 入力ファイル： %~1
) else if "%~x1"==".avs" (
    echo --- 入力ファイル： %~1
) else if "%~x1"==".d2v" (
    echo 現状、拡張子が.d2vの読み込みに対応していません。本体を指定してください
    set mpeg2dec_select_flag=2
    goto :parameter_shift
) else (
    echo.
    echo 非対応拡張子
    goto :parameter_shift
)


echo ### 作業開始時刻 ###
echo %time%
echo.

rem ### ソースファイルへのフルパス^(src_file_path^)を環境変数に書き込む.。後でパラメーターファイルにも書き込む。
set src_file_path=%~1

rem ### ソースとするファイルへのパス、通常は入力されたファイル ###
set input_media_path=%~1

rem ### AVSファイルの名前、通常は入力されたファイルと同等 ###
set avs_project_name=%~n1

rem ### ディレクトリ名(%main_project_name%)と、ファイル名(%avs_project_name%)を決定する関数
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
    rem バッチモードで未決定事項確定ルーチンを書く
    call :bat_video_resolution_detect
) else (
    rem # 各ユーザー設定を決定する項目
    call :manual_job_settings "%~1"
    call :deinterlace_filter_selector
    call :NR_filter_selector
    call :video_job_selector
    call :vfr_rate_selecter
    call :audio_job_selector
)

rem # メインバッチファイルを作成する
call :make_main_bat "%~1"
rem # 各ソースをの下準備の制御(.ts|.dv|.avs)
rem # 入力ファイルがTSの場合の処理、必要な場合の音声ソースの作成を含む
call :sub_video_encodebatfile_detec
call :sub_audio_editbatfile_detec
call :sub_d2vgenbatfile_detec
call :sub_copybatfile_detec
call :copy_source_phase "%~1"
echo rem # ソースファイルのコピーおよび事前処理>> "%main_bat_file%"
echo call ".\bat\copy_src.bat">> "%main_bat_file%"
echo.>> "%main_bat_file%"
rem # .d2vファイル作成
call :make_d2vfile_phase "%input_media_path%"
rem 字幕ファイル操作用バッチファイルパスを設定
call :sub_srteditfile_detec
rem トラックmux用バッチファイルパスを設定
call :sub_muxtracksfile_detec
rem 一時ファイル削除用バッチファイルパスを設定
call :sub_deltmpfile_detec
rem ロゴ処理および自動CMカット関連バッチ内容作成
call :make_logoframe_phase
rem # Trim情報の整形
call :sub_trimlinefile_detec
rem Trim編集用バッチ内容作成
call :make_trimline_phase
rem AutoVfr用バッチおよび設定ファイル作成
call :make_autovfr_phase
rem # AVSファイルを作成する、入力ファイルが.avsの場合はスキップ
if "%~x1"==".avs" (
    rem # 入力がavsの場合新規にavsファイルは作成しない
) else (
    rem # avsファイル作成
    call :make_avsfile_phase "%~1"
    rem # プラグイン読み込み～ソース読み込みフィルタ作成
    call :make_avsplugin_phase "%~1"
    rem # 入力ファイル読み込み方法を直接読み込みか、テンポラリに一時コピーかで分類する
    call :load_mpeg2ts_source "%~1"
    rem # フィールドオーダー～インタレ解除前のフィルタの統合
    call :avs_interlacebefore_phase
    rem # Trim情報のインポート
    call :trim_edit_phase
    rem # インターレース状態で適用するフィルタの結合
    call :interlaced_filter_phase
    rem # 色空間変換フィルタの記述、EarthsoftDVはBT.601で録画するため変換なし。TSでかつSD以下に変換の場合に記述
    call :make_ColorMatrix_filter
    rem # インターレース解除フィルタの統合
    call :avs_interlacemain_phase
    rem # ドット妨害、クロスカラー除去フィルタ
    call :DeDotCC_filter_phase
    rem # デインターレースフィルタ
    call :deinterlace_filter_phase
    rem # クロップフィルタ
    call :crop_filter_phase
    rem # NRフィルタ～その他のフィルタ統合
    call :avs_interlaceafter_phase
    rem # NR フィルタ
    call :nr_filter_phase
    rem # リサイズフィルタ
    call :resize_filter_phase
    rem # Sharp フィルタ
    call :sharp_filter_phase
    rem # 黒帯追加
    call :add_border_phase
    rem # ConvertToYV12フィルタ
    call :ConvertToYV12_filter_phase
    rem # ItsCutフィルタ
    call :ItsCut_filter_phase
    rem # Its用.defファイルのコピー
    copy "%def_itvfr_file%" "%work_dir%%main_project_name%\avs\main.def"
    copy "%def_itvfr_file%" "%work_dir%%main_project_name%\main.def"
    rem # 各種音源を読み込んでから、Trim編集後のオーディオストリームを出力するためのavsファイル作成
    call :make_fawsrc_avs
    call :make_pcmsrc_avs
    rem # カット編集用avsファイル作成
    call :make_cuteditfile_phase "%~1"
    rem # プレビュー(周期確認用)avsファイル作成
    call :make_previewfile_phase "%~1"
    rem # プラグイン読み込みフィルタ作成
    call :make_previewplugin_phase "%~1"
    rem # ソースファイル入力
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
    call :edit_analyze_filter
    rem # 半透過ロゴ除去関数avsファイル出力^(空ファイル^)
    call :eraselogo_filter
)
rem # ロゴファイル(.lgd)のコピーフェーズ
call :copy_lgd_file_phase "%~1"
rem # カット処理方法スクリプト(JL)のコピーフェーズ
call :copy_JL_file_phase "%~1"
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
rem # ffmpegによるedts修正、QTなど一部ソフトでアスペクト比情報が機能しなくなる恐れあり
if "%fix_edts_flag%"=="1" (
    call :fix_edts_select "%~1"
)
rem # 作業用のソースファイルおよび不要な一時ファイルの削除
echo rem # 作業用のソースファイルおよび不要な一時ファイルの削除フェーズ>> "%main_bat_file%"
call :del_tmp_files
rem # パラメーターファイル作成
call :make_parameterfile_phase "%src_file_path%"
rem # 終了時間記述
call :last_order "%~1"
rem # バッチファイル呼び出し
if not "%calling_bat_file%"=="" (
    call :call_bat_phase
)
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
) else if "%~1"=="720" (
    set bat_vresize_flag=720
) else if "%~1"=="540" (
    set bat_vresize_flag=540
) else if "%~1"=="480" (
    set bat_vresize_flag=480
) else if "%~1"=="270" (
    set bat_vresize_flag=270
) else (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b

:bat_avstemplate_detect
exit /b

:bat_JLtemplate_detect
rem # JLファイルの指定
if exist "%~1" (
    set JL_src_file_full-path=%~1
) else (
    set error_message=Do not exist "%~1" !
    goto :error
)
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

:bat_cropsize_detect
rem # 黒帯等の表示外領域のCrop指定
if "%~1"=="none" (
    set Crop_size_flag=none
) else if "%~1"=="sidecut" (
    set Crop_size_flag=sidecut
) else if "%~1"=="gakubuchi" (
    set Crop_size_flag=gakubuchi
) else (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b


:make_parameterfile_phase
rem # 実行直前に参照するパラメーターファイルを作成
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
echo x264_enc_param=%x264_Encode_option% %video_sar_option%%x264_VUI_opt%%x264_keyint% %x264_interlace_option%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # x265 encode parameter>> "%work_dir%%main_project_name%\parameter.txt"
echo x265_enc_param=%x265_Encode_option% %video_sar_option%%x265_VUI_opt%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # QSVEncC encode parameter>> "%work_dir%%main_project_name%\parameter.txt"
echo qsv_enc_param=%qsv_Encode_option% %video_sar_option%%qsv_VUI_opt%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # NVEncC encode parameter>> "%work_dir%%main_project_name%\parameter.txt"
echo nvenc_enc_param=%nvenc_Encode_option% %video_sar_option%%nvenc_VUI_opt%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # MPEG-2 decoder parameter[1: MPEG-2 VIDEO VFAPI Plug-In^(Default^), 2: DGMPGDEC, 3: L-SMASH Works]>> "%work_dir%%main_project_name%\parameter.txt"
echo mpeg2dec_select_flag=^%mpeg2dec_select_flag%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # Audio edit mode[faw^(Default^), sox, nero]>> "%work_dir%%main_project_name%\parameter.txt"
echo audio_job_flag=%audio_job_flag%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
echo # Audio Gain parameter[int]>> "%work_dir%%main_project_name%\parameter.txt"
echo audio_gain=%audio_gain% >> "%work_dir%%main_project_name%\parameter.txt"
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
echo # auto CM cut script file ^(JL^) name>> "%work_dir%%main_project_name%\parameter.txt"
echo JL_file_name=^%JL_file_name%>> "%work_dir%%main_project_name%\parameter.txt"
echo.>> "%work_dir%%main_project_name%\parameter.txt"
exit /b

:make_cuteditfile_phase
rem # 事前にカット編集するためのAVSファイル作成
echo ##### 事前にカット編集するためのAVS #####> "%work_dir%%main_project_name%\cutedit.avs"
echo #//--- プラグイン読み込み部分のインポート ---//>> "%work_dir%%main_project_name%\cutedit.avs"
echo Import^(".\avs\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\cutedit.avs"
echo.>> "%work_dir%%main_project_name%\cutedit.avs"
echo #//--- ソースの読み込み ---//>> "%work_dir%%main_project_name%\cutedit.avs"
if "%mpeg2dec_select_flag%"=="1" (
    echo MPEG2VIDEO^("%~1"^).AssumeTFF^(^)>>"%work_dir%%main_project_name%\cutedit.avs"
) else if "%mpeg2dec_select_flag%"=="2" (
    echo MPEG2Source^("%~dpn1.d2v",upconv=0^).ConvertToYUY2^(^)>>"%work_dir%%main_project_name%\cutedit.avs"
) else if "%mpeg2dec_select_flag%"=="3" (
    echo video = LWLibavVideoSource^("%~1", dr=false, repeat=true, dominance=0^)>>"%work_dir%%main_project_name%\cutedit.avs"
    echo video = video.height^(^) == 1088 ? video.Crop^(0, 0, 0, -8^) : video>>"%work_dir%%main_project_name%\cutedit.avs"
    echo audio = LWLibavAudioSource^("%~1", stream_index=-1, av_sync=false, layout="stereo"^)>>"%work_dir%%main_project_name%\cutedit.avs"
    echo AudioDub^(video, audio^)>>"%work_dir%%main_project_name%\cutedit.avs"
)
echo #KillAudio^(^)>>"%work_dir%%main_project_name%\cutedit.avs"
echo.>> "%work_dir%%main_project_name%\cutedit.avs"
echo #//--- フィールドオーダー ---//>> "%work_dir%%main_project_name%\cutedit.avs"
echo #AssumeFrameBased^(^).ComplementParity^(^)    #トップフィールドが支配的>> "%work_dir%%main_project_name%\cutedit.avs"
echo.>> "%work_dir%%main_project_name%\cutedit.avs"
echo #//--- Trim情報インポート ---//>> "%work_dir%%main_project_name%\cutedit.avs"
echo #Import^("trim_line.txt"^)>> "%work_dir%%main_project_name%\cutedit.avs"
echo.>> "%work_dir%%main_project_name%\cutedit.avs"
echo #//--- 終了 ---//>> "%work_dir%%main_project_name%\cutedit.avs"
echo return last>> "%work_dir%%main_project_name%\cutedit.avs"
exit /b

:make_fawsrc_avs
rem # 疑似WAV(FAW)を出力する際に整形済みTrim情報を渡すためのAVSファイル作成
echo ##### 疑似WAV^(FAW^)を出力する際に整形済みTrim情報を渡すためのAVS #####> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo #//--- プラグイン読み込み部分のインポート ---//>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo Import^(".\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo.>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo #//--- ソースの読み込み ---//>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
if "%mpeg2dec_select_flag%"=="1" (
    echo video = MPEG2VIDEO^("..\src\video.ts"^).AssumeTFF^(^)>>"%work_dir%%main_project_name%\avs\audio_export_faw.avs"
) else if "%mpeg2dec_select_flag%"=="2" (
    echo video = MPEG2Source^("..\src\video.d2v",upconv=0^).ConvertToYUY2^(^)>>"%work_dir%%main_project_name%\avs\audio_export_faw.avs"
) else if "%mpeg2dec_select_flag%"=="3" (
    echo video = LWLibavVideoSource^("..\src\video.ts", dr=false, repeat=true, dominance=0^)>>"%work_dir%%main_project_name%\avs\audio_export_faw.avs"
    echo video = video.height^(^) == 1088 ? video.Crop^(0, 0, 0, -8^) : video>>"%work_dir%%main_project_name%\avs\audio_export_faw.avs"
)
echo audio = WAVSource^("..\src\audio_faw.wav"^)>>"%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo AudioDub^(video, audio^)>>"%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo.>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo #//--- フィールドオーダー ---//>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo #AssumeFrameBased^(^).ComplementParity^(^)    #トップフィールドが支配的>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo.>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo #//--- Trim情報インポート ---//>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo Import^("..\trim_chars.txt"^)>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo.>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo return last>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
exit /b

:make_pcmsrc_avs
rem # PCM WAVを出力する際に整形済みTrim情報を渡すためのAVSファイル作成
echo ##### PCM WAVを出力する際に整形済みTrim情報を渡すためのAVS #####> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo #//--- プラグイン読み込み部分のインポート ---//>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo Import^(".\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo.>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo #//--- ソースの読み込み ---//>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
if "%mpeg2dec_select_flag%"=="1" (
    echo video = MPEG2VIDEO^("..\src\video.ts"^).AssumeTFF^(^)>>"%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
) else if "%mpeg2dec_select_flag%"=="2" (
    echo video = MPEG2Source^("..\src\video.d2v",upconv=0^).ConvertToYUY2^(^)>>"%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
) else if "%mpeg2dec_select_flag%"=="3" (
    echo video = LWLibavVideoSource^("..\src\video.ts", dr=false, repeat=true, dominance=0^)>>"%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
    echo video = video.height^(^) == 1088 ? video.Crop^(0, 0, 0, -8^) : video>>"%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
)
echo audio = WAVSource^("..\src\audio_pcm.wav"^)>>"%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo AudioDub^(video, audio^)>>"%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo.>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo #//--- フィールドオーダー ---//>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo #AssumeFrameBased^(^).ComplementParity^(^)    #トップフィールドが支配的>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo.>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo #//--- Trim情報インポート ---//>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo Import^("..\trim_chars.txt"^)>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo.>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo return last>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
exit /b

:make_trimline_phase
rem # 整形した結果の文字列が空だった場合は何もしない
echo rem # Trim文字列の整形フェーズ>>"%main_bat_file%"
echo call ".\bat\trim_chars.bat">>"%main_bat_file%"
echo.>>"%main_bat_file%"
type nul > "%work_dir%%main_project_name%\trim_chars.txt"
type nul > "%trimchars_batfile_path%"
echo @echo off>> "%trimchars_batfile_path%"
echo setlocal>> "%trimchars_batfile_path%"
echo echo start %%~nx0 bat job...>> "%trimchars_batfile_path%"
echo chdir /d %%~dp0..\>> "%trimchars_batfile_path%"
echo.>> "%trimchars_batfile_path%"
echo rem # エンコードツールをまとめたディレクトリを示す環境変数ENCTOOLSROOTPATHが定義されているか確認>> "%trimchars_batfile_path%"
echo call :toolsdircheck>> "%trimchars_batfile_path%"
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出>> "%trimchars_batfile_path%"
echo call :project_name_check>> "%trimchars_batfile_path%"
echo.>> "%trimchars_batfile_path%"
echo rem # 各種実行ファイルはWindows標準コマンド群のみ。>> "%trimchars_batfile_path%"
echo.>> "%trimchars_batfile_path%"
echo :main>> "%trimchars_batfile_path%"
echo rem //----- main開始 -----//>> "%trimchars_batfile_path%"
echo title %%project_name%%>> "%trimchars_batfile_path%"
echo echo Trim情報を整形しています. . .[%%time%%]>> "%trimchars_batfile_path%"
echo echo # ソースに対してのTrim反映分抽出^> "trim_chars.txt">> "%trimchars_batfile_path%"
echo rem # "trim_line.txt"から単一行を抽出>> "%trimchars_batfile_path%"
echo set count=^0>> "%trimchars_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%Q in ^(`findstr /b /r Trim^^(.*^^) "trim_line.txt"`^) do ^(>> "%trimchars_batfile_path%"
echo     set trim_detect=%%%%Q>> "%trimchars_batfile_path%"
echo     call :linecount_checker>> "%trimchars_batfile_path%"
echo     set /a count=count+1>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo rem # "main.avs"から単一行を抽出>> "%trimchars_batfile_path%"
echo if not "%%trim_detect:~0,4%%"=="Trim" ^(>> "%trimchars_batfile_path%"
echo     call :conv_mainline2char>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo rem # "trim_multi.txt"から複数行抽出>> "%trimchars_batfile_path%"
echo if not "%%trim_detect:~0,4%%"=="Trim" ^(>> "%trimchars_batfile_path%"
echo     call :conv_multi2char>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo rem # "main.avs"から複数行抽出>> "%trimchars_batfile_path%"
echo if not "%%trim_detect:~0,4%%"=="Trim" ^(>> "%trimchars_batfile_path%"
echo     call :conv_mainmulti2char>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo rem # Trim行が検出されれば処理終了>> "%trimchars_batfile_path%"
echo if "%%trim_detect:~0,4%%"=="Trim" ^(>> "%trimchars_batfile_path%"
echo     call :show_trim_chars>> "%trimchars_batfile_path%"
echo ^) else ^(>> "%trimchars_batfile_path%"
echo     call echo Trimは検出されませんでした。>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo rem # 文字列抽出終了>> "%trimchars_batfile_path%"
echo title コマンド プロンプト>> "%trimchars_batfile_path%"
echo rem //----- main終了 -----//>> "%trimchars_batfile_path%"
echo echo end %%~nx0 bat job...>> "%trimchars_batfile_path%"
echo exit /b>> "%trimchars_batfile_path%"
echo.>> "%trimchars_batfile_path%"
rem ------------------------------
echo :toolsdircheck>> "%trimchars_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%trimchars_batfile_path%"
echo     echo 環境変数 ENCTOOLSROOTPATH が未定義です>> "%trimchars_batfile_path%"
echo     exit /b>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\>> "%trimchars_batfile_path%"
echo if exist "%%ENCTOOLSROOTPATH%%" ^(>> "%trimchars_batfile_path%"
echo     exit /b>> "%trimchars_batfile_path%"
echo ^) else ^(>> "%trimchars_batfile_path%"
echo     echo 環境変数ENCTOOLSROOTPATHが有効なパスではありません>> "%trimchars_batfile_path%"
echo     set ENCTOOLSROOTPATH=>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo exit /b>> "%trimchars_batfile_path%"
echo.>> "%trimchars_batfile_path%"
rem ------------------------------
echo :project_name_check>> "%trimchars_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(>> "%trimchars_batfile_path%"
echo     set %%%%P>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo exit /b>> "%trimchars_batfile_path%"
echo.>> "%trimchars_batfile_path%"
rem ------------------------------
echo :linecount_checker>> "%trimchars_batfile_path%"
echo if "%%count%%"=="0" ^(>> "%trimchars_batfile_path%"
echo     echo "trim_line.txt"に単一行のTrimが検出されました>> "%trimchars_batfile_path%"
echo     call :trimchar_export>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo exit /b>> "%trimchars_batfile_path%"
echo.>> "%trimchars_batfile_path%"
rem ------------------------------
echo :conv_mainline2char>> "%trimchars_batfile_path%"
echo set count=^0>> "%trimchars_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%R in ^(`findstr /b /r Trim^^(.*^^) "main.avs"`^) do ^(>> "%trimchars_batfile_path%"
echo     set trim_detect=%%%%R>> "%trimchars_batfile_path%"
echo     call :maincount_checker>> "%trimchars_batfile_path%"
echo     set /a count=count+1>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo exit /b>> "%trimchars_batfile_path%"
echo.>> "%trimchars_batfile_path%"
rem ------------------------------
echo :maincount_checker>> "%trimchars_batfile_path%"
echo if "%%count%%"=="0" ^(>> "%trimchars_batfile_path%"
echo     echo "main.avs"に単一行のTrimが検出されました>> "%trimchars_batfile_path%"
echo     call :trimchar_export>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo exit /b>> "%trimchars_batfile_path%"
echo.>> "%trimchars_batfile_path%"
rem ------------------------------
echo :conv_multi2char>> "%trimchars_batfile_path%"
echo set trim_detect=>> "%trimchars_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%S in ^(`findstr /r Trim^^(.*^^) "trim_multi.txt"`^) do ^(>> "%trimchars_batfile_path%"
echo     call :trimchar_searching "%%%%S">> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo set trim_detect=%%trim_detect:~0,-2%%>> "%trimchars_batfile_path%"
echo if "%%trim_detect:~0,4%%"=="Trim" ^(>> "%trimchars_batfile_path%"
echo     echo "trim_multi.txt"からTrim情報を抽出します>> "%trimchars_batfile_path%"
echo     call :trimchar_export>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo exit /b>> "%trimchars_batfile_path%"
echo.>> "%trimchars_batfile_path%"
rem ------------------------------
echo :conv_mainmulti2char>> "%trimchars_batfile_path%"
echo set trim_detect=>> "%trimchars_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%T in ^(`findstr /r Trim^^(.*^^) "main.avs"`^) do ^(>> "%trimchars_batfile_path%"
echo     call :trimchar_searching "%%%%T">> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo set trim_detect=%%trim_detect:~0,-2%%>> "%trimchars_batfile_path%"
echo if "%%trim_detect:~0,4%%"=="Trim" ^(>> "%trimchars_batfile_path%"
echo     echo "main.avs"に複数行のTrimが検出されました>> "%trimchars_batfile_path%"
echo     call :trimchar_export>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo exit /b>> "%trimchars_batfile_path%"
echo.>> "%trimchars_batfile_path%"
rem ------------------------------
echo :trimchar_export>> "%trimchars_batfile_path%"
echo echo %%trim_detect%%^>^> "trim_chars.txt">> "%trimchars_batfile_path%"
echo exit /b>> "%trimchars_batfile_path%"
echo.>> "%trimchars_batfile_path%"
rem ------------------------------
echo :trimchar_searching>> "%trimchars_batfile_path%"
echo set fname=%%~1>> "%trimchars_batfile_path%"
echo set n=^0>> "%trimchars_batfile_path%"
echo set e=^0>> "%trimchars_batfile_path%"
rem ------------------------------
echo :loop>> "%trimchars_batfile_path%"
echo call set c=%%%%fname:~%%n%%,1%%%%>> "%trimchars_batfile_path%"
echo call set trim_search=%%%%fname:~0,%%n%%%%%%>> "%trimchars_batfile_path%"
echo if "%%trim_search:~-5%%"=="Trim(" ^(>> "%trimchars_batfile_path%"
echo     set e=%%n%%>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo set /a n=n+1>> "%trimchars_batfile_path%"
echo if "%%c%%"=="" exit /b>> "%trimchars_batfile_path%"
echo if "%%c%%"==")"  ^(>> "%trimchars_batfile_path%"
echo     if not "%%e%%"=="0"  ^(>> "%trimchars_batfile_path%"
echo         goto :break>> "%trimchars_batfile_path%"
echo     ^)>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo goto :loop>> "%trimchars_batfile_path%"
echo :break>> "%trimchars_batfile_path%"
echo set /a d=%%n%%-%%e%%>> "%trimchars_batfile_path%"
echo call set trim_detect=%%trim_detect%%Trim^(%%%%fname:~%%e%%,%%d%%%%%%++>> "%trimchars_batfile_path%"
echo exit /b>> "%trimchars_batfile_path%"
echo.>> "%trimchars_batfile_path%"
rem ------------------------------
echo :show_trim_chars>> "%trimchars_batfile_path%"
echo echo Trim情報：%%trim_detect%%>> "%trimchars_batfile_path%"
echo exit /b>> "%trimchars_batfile_path%"
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
echo @echo off>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo setlocal>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo start %%~nx0 bat job...>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo chdir /d %%~dp0..\>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # エンコードツールをまとめたディレクトリを示す環境変数ENCTOOLSROOTPATHが定義されているか確認>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :toolsdircheck>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :project_name_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # parameterファイル中の透過性ロゴフィルタ無効化パラメーター^(disable_delogo^)を検出>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :disable_delogo_status_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # parameterファイル中の自動CMカット無効化パラメーター^(disable_cmcutter^)を検出>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :disable_cmcutter_status_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # parameterファイル中のlgdファイル名を検出>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :lgd_file_name_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # parameterファイル中のJLファイル名を検出>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :JL_file_name_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # 各AVSファイルの中から有効なTrim行が含まれていないか検出>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :total_trim_line_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # EraseLogo.avs のファイルサイズを検出>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :eraselogo_avs_filesize_check ".\avs\EraseLogo.avs">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # 各実行ファイルが存在するか確認。存在しない場合ENCTOOLSROOTPATH内部を探索する、もしくはシステムの探索パスに委ねる>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if exist "%logoframe_path%" ^(set logoframe_path=%logoframe_path%^) else ^(call :find_logoframe "%logoframe_path%"^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if exist "%chapter_exe_path%" ^(set chapter_exe_path=%chapter_exe_path%^) else ^(call :find_chapter_exe "%chapter_exe_path%"^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if exist "%join_logo_scp_path%" ^(set join_logo_scp_path=%join_logo_scp_path%^) else ^(call :find_join_logo_scp "%join_logo_scp_path%"^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # 各種実行ファイルへのパスが、最終的にどのような値になったか確認。>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo logoframe    : %%logoframe_path%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo chapter_exe  : %%chapter_exe_path%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo join_logo_scp: %%join_logo_scp_path%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :main>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem //----- main開始 -----//>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo title %%project_name%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo ロゴとCMカットに関する処理工程を実行します. . .[%%time%%]>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # logoframe実行のサブルーチン呼び出し>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :logoframe_subroutine>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if "%%trim_line_counter%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     rem # chapter_exe実行のサブルーチン呼び出し>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     call :chapter_exe_subroutine>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     rem # join_logo_scp実行のサブルーチン呼び出し>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     call :join_logo_scp_subroutine>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo Trimが既に挿入されています、自動CMカットは必要ありません>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo title コマンド プロンプト>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem //----- main終了 -----//>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo end %%~nx0 bat job...>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :toolsdircheck>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not defined ENCTOOLSROOTPATH ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo 環境変数 ENCTOOLSROOTPATH が未定義です>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if exist "%%ENCTOOLSROOTPATH%%" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo 環境変数ENCTOOLSROOTPATHが有効なパスではありません>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     set ENCTOOLSROOTPATH=>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :project_name_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     set %%%%P>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :disable_delogo_status_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%L in ^(`findstr /b /r disable_delogo "parameter.txt"`^) do ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     set %%%%L>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :disable_cmcutter_status_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%C in ^(`findstr /b /r disable_cmcutter "parameter.txt"`^) do ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     set %%%%C>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :lgd_file_name_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo set lgd_file_path=>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%G in ^(`findstr /b /r lgd_file_name "parameter.txt"`^) do ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     set %%%%G>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if "%%lgd_file_name%%"=="" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo .lgd ファイル名が空です>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     call :lgd_file_path_set>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :lgd_file_path_set>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo set lgd_file_path=..\lgd\%%lgd_file_name%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :JL_file_name_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%J in ^(`findstr /b /r JL_file_name "parameter.txt"`^) do ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     set %%%%J>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if "%%JL_file_name%%"=="" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo JL ファイル名が空です>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     call :JL_file_path_set>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :JL_file_path_set>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo set JL_file_path=.\JL\%%JL_file_name%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :total_trim_line_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # 有効なTrim行が含まれていないかチェック、含まれていた場合既に編集済みと判断し後続の処理をスキップする>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo set trim_line_counter=^0>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%T in ^(`findstr /r Trim^^^(.*^^^) "trim_chars.txt"`^) do ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     set /a trim_line_counter=trim_line_counter+1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%T in ^(`findstr /r Trim^^^(.*^^^) "main.avs"`^) do ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     set /a trim_line_counter=trim_line_counter+1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :eraselogo_avs_filesize_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not exist ".\avs\EraseLogo.avs" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     type nul^> ".\avs\EraseLogo.avs">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo set eraselogo_avs_filesize=%%~z1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo EraseLogo.avs ファイルサイズ：%%eraselogo_avs_filesize%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :find_logoframe>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo findexe引数："%%~1">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not defined ENCTOOLSROOTPATH ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo 探索しています...>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo 見つかりました>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         set logoframe_path=%%%%~E>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :logoframe_env_search "%%~nx1">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :logoframe_env_search>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo set logoframe_path=%%~$PATH:1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if "%%logoframe_path%%"=="" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo logoframeが見つかりません>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     set logoframe_path=%%~1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :find_chapter_exe>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo findexe引数："%%~1">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not defined ENCTOOLSROOTPATH ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo 探索しています...>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo 見つかりました>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         set chapter_exe_path=%%%%~E>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :chapter_exe_env_search "%%~nx1">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :chapter_exe_env_search>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo set chapter_exe_path=%%~$PATH:1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if "%%chapter_exe_path%%"=="" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo chapter_exeが見つかりません>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     set chapter_exe_path=%%~1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :find_join_logo_scp>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo findexe引数："%%~1">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not defined ENCTOOLSROOTPATH ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo 探索しています...>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo 見つかりました>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         set join_logo_scp_path=%%%%~E>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :join_logo_scp_env_search "%%~nx1">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :join_logo_scp_env_search>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo set join_logo_scp_path=%%~$PATH:1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if "%%join_logo_scp_path%%"=="" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo join_logo_scpが見つかりません>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     set join_logo_scp_path=%%~1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :logoframe_subroutine>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo pushd avs>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not exist "%%lgd_file_path%%" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo .lgd ファイルが検出できません。処理を続けることが出来ない為、logoframeの処理を中断します。>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     popd>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo popd>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # logoframeを実行するためのサブルーチンです>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not exist ".\log\logoframe_log.txt" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo logoframe_log.txtが存在しません>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     if "%%eraselogo_avs_filesize%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo EraseLogo.avsに有効な値が挿入されていません。>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         if not "%%disable_delogo%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             echo 半透過ロゴ処理は有効です>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             if not "%%disable_cmcutter%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 echo logoframeを実行します^^^(avs+log^^^)...[%%time%%]>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 call :run_logoframe_all>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 echo logoframeは実行しません>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             echo 半透過ロゴ処理は無効です>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             if not "%%trim_line_counter%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 echo Trimが既に挿入されています、logoframeは実行しません>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 if not "%%disable_cmcutter%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                     echo 自動CMカットは有効です、logoframeを実行します^^^(log^^^)...[%%time%%]>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                     call :run_logoframe_log>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                     echo 自動CMカットは無効です、logoframeは実行しません>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo EraseLogo.avsは有効です、半透過ロゴが処理されます。>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         if not "%%trim_line_counter%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             echo Trimが既に挿入されています、logoframeは実行しません>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             if not "%%disable_cmcutter%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 echo 自動CMカットは有効です、logoframeを実行します^^^(log^^^)...[%%time%%]>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 call :run_logoframe_log>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 echo 自動CMカットは無効です、logoframeは実行しません>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo logoframe_log.txtが存在しています>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     if "%%eraselogo_avs_filesize%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo EraseLogo.avsに有効な値が挿入されていません。>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         if not "%%disable_delogo%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             echo 半透過ロゴ処理は有効です、logoframeを実行します^^^(avs+log※logoframe_log.txtは上書きされます^^^)...[%%time%%]>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             call :run_logoframe_all>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             echo 半透過ロゴ処理は無効です、logoframeは実行しません>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo EraseLogo.avsは有効です、半透過ロゴが処理されます。logoframe 処理は不要の為、スキップします。>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :run_logoframe_all>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # EraseLogo.avs に上位の相対パスを記入するために、一時的に作業フォルダ移動^(logのみ作成の場合、本来は不要^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo pushd avs>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo "%%logoframe_path%%" -outform 1 ".\edit_analyze.avs" -logo "%%lgd_file_path%%" -oa "..\log\logoframe_log.txt" -o ".\EraseLogo.avs">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo popd>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :run_logoframe_log>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # EraseLogo.avs に上位の相対パスを記入するために、一時的に作業フォルダ移動^(logのみ作成の場合、本来は不要^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo pushd avs>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo "%%logoframe_path%%" -outform 1 ".\edit_analyze.avs" -logo "%%lgd_file_path%%" -oa "..\log\logoframe_log.txt">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo popd>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :chapter_exe_subroutine>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo pushd avs>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not exist "%%lgd_file_path%%" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo .lgd ファイルが検出できません。処理を続けることが出来ない為、chapter_exeの処理を中断します。>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     popd>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo popd>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not "%%disable_cmcutter%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo 自動CMカットは有効です、chapter_exeを実行します...[%%time%%]>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     call :run_chapter_exe_log>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo 自動CMカットは無効です、chapter_exeは実行しません>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :run_chapter_exe_log>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo "%%chapter_exe_path%%" -v ".\avs\edit_analyze.avs" -o ".\log\chapter_exe_log.txt">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :join_logo_scp_subroutine>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # comskipのルーチンを後で引き継ぐこと>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not exist "%%JL_file_path%%" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo JL ファイルが検出できません。処理を続けることが出来ない為、join_logo_scpの処理を中断します。>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not exist ".\log\logoframe_log.txt" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo logoframe_log.txt が見つかりません、join_logo_scp を中断します>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else if not exist ".\log\chapter_exe_log.txt" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo chapter_exe_log.txt が見つかりません、join_logo_scp を中断します>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     if not "%%disable_cmcutter%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo 自動CMカットは有効です、join_logo_scpを実行します...[%%time%%]>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         call :run_join_logo_scp_log>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo 自動CMカットは無効です、join_logo_scpは実行しません>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # trim_chars.txt に有効なTrim行が含まれていないか最終チェック、含まれていなければjoin_logo_scpの出力結果をマージする>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo set trim_chars_txt_counter=^0>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%T in ^(`findstr /R Trim^^^(.*^^^) "trim_chars.txt"`^) do ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     set /a trim_chars_txt_counter=trim_chars_txt_counter+1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%T in ^(`findstr /R Trim^^^(.*^^^) "trim_line.txt"`^) do ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     set /a trim_chars_txt_counter=trim_chars_txt_counter+1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%T in ^(`findstr /R Trim^^^(.*^^^) "trim_multi.txt"`^) do ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     set /a trim_chars_txt_counter=trim_chars_txt_counter+1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not "%%trim_chars_txt_counter%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo trim_chars.txt には既に有効なTrimが含まれています、join_logo_scp の出力結果はマージしません>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     if not exist ".\tmp\join_logo_scp_out.txt" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo join_logo_scp_out.txt が見つかりません、マージをスキップします>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo # join_logo_scp generated.^>^> ".\trim_line.txt">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         copy /b ".\trim_line.txt" + ".\tmp\join_logo_scp_out.txt" ".\trim_line.txt">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :run_join_logo_scp_log>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo "%%join_logo_scp_path%%" -inlogo ".\log\logoframe_log.txt" -inscp ".\log\chapter_exe_log.txt" -incmd "%%JL_file_path%%" -o ".\tmp\join_logo_scp_out.txt">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
rem ------------------------------
exit /b


:make_autovfr_phase
rem ### AutoVfrを自動事項するためのステップ
echo rem # AutoVfrの実行フェーズ>>"%main_bat_file%"
echo call ".\bat\autovfr_scan.bat">> "%main_bat_file%"
echo.>> "%main_bat_file%"
copy "%autovfr_template%" "%work_dir%%main_project_name%\\avs\"
copy "%autovfr_fast_template%" "%work_dir%%main_project_name%\\avs\"
rem # "AutoVfr.ini"をコピーする。autovfrini_pathで指定されたパスが存在しない場合は、AutoVfr.exeと同じパスを使用する。
if exist "%autovfrini_path%" (
    copy "%autovfrini_path%" "%work_dir%%main_project_name%\"
) else (
    call :find_autovfr_dir "%autovfr_path%"
)
echo @echo off>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo setlocal>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo start %%~nx0 bat job...>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo cd /d %%~dp0..\>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ■AutoVfrのMode>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :autovfr_mode_detect>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem [0=Auto_Vfrを利用] [1=Auto_Vfr_Fastを利用]>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem set autovfr_mode=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ■AutoVfrの自動/手動設定判定>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :autovfr_deint_detect>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem [0=マニュアルでインタレースを利用] [1=自動デインターレースを利用]>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem set autovfr_deint=^1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ■スレッド数指定>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :autovfr_threadnum_detect>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # AutoVfrログを出力する際のスレッド数を指定します。無指定の場合、システムの論理CPU数になります。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem set autovfr_thread_num=>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem *****************Auto_Vfrで使用**********************>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ■Auto_Vfrの設定。^(^)無しで記載。ログファイルパス,cut,numberは指定不要。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem [一覧] cthresh=^(コーミング強さ-1-255^), mi=^(コーミング量0-blockx*blocky^), chroma=false, blockx=16^(判定ブロック縦サイズ^), blocky=^(判定ブロック横サイズ^), IsCrop=false, crop_height=, IsTop=false, IsBottom=true, show_crop=false, IsDup=false, thr_m=10, thr_luma=0.01>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem 初期値cthresh=60, mi=55, blockx=16, blocky=32 >> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem テロップだとcthresh=110,mi=100程度が上限^(70,60^)。下げすぎると誤判定多く、上げすぎると周期判定失敗してテロップが切れる。cthreshはそのままで、miを動かして調整するのが良い。^(60fps区間を広げる設定あれば良いのに^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem crop_heightの値はYV12の場合4の倍数でないとエラーになるので注意！>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo @set AUTOVFRSETTING=cthresh=80, mi=60, blockx=16, blocky=32, chroma=false, IsCrop=true, crop_height=92^4>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ■AutoVfr.exeの設定^(-i -o以外のオプション指定^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%autovfr_deint%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     @set EXESETTING=-INI "AutoVfr.ini" -30F 1 -60F 1 -skip 1 -ref 300 -24A 0 -30A 0 -FIX>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     @set EXESETTING=-INI "AutoVfr.ini" -30F 1 -60F 1 -skip 1 -ref 300 -24A 1 -30A 1 -FIX>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ■60iテロ範囲拡張フレーム数^(60fps・6to2範囲 拡張^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem 誤爆防止の閾値設定の為、60iテロ検出部分が短くなる場合があります。それを補正します。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem この処理はAutoVFR.exeの後に行われます。"[24] txt60mc"または"[60] f60"を含む範囲指定行を処理対象にします。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem EXBIGIsに先頭の、EXLASTsに末尾の拡張フレーム数を、指定してください。5の倍数推奨。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo @set EXBIGIs=^5>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo @set EXLASTs=^5>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem *****************Auto_Vfr_Fastで利用*****************>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ■Auto_Vfr_Fastの設定。^(^)無しで記載。ログファイルパス,cut,numberは指定不要。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem [一覧] cthresh=^(コーミング強さ-1-255^), mi=^(コーミング量0-blockx*blocky^), chroma=false, blockx=^(判定ブロック縦サイズ^), blocky=^(判定ブロック横サイズ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem 初期値cthresh=60, mi=55, blockx=16, blocky=32 >> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem テロップだとcthresh=110,mi=100程度が上限^(70,60^)。下げすぎると誤判定多く、上げすぎると周期判定失敗してテロップが切れる。cthreshはそのままで、miを動かして調整するのが良い。^(60fps区間を広げる設定あれば良いのに^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo @set AUTOVFRFASTSETTING=cthresh=80, mi=60, blockx=16, blocky=32, chroma=false>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ■AutoVfr.exeの設定^(-i -o以外のオプション指定^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%autovfr_deint%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     @set FASTEXESETTING=-INI "AutoVfr.ini" -30F 1 -60F 1 -skip 1 -ref 250 -24A 0 -30A 0 -FIX>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     @set FASTEXESETTING=-INI "AutoVfr.ini" -30F 1 -60F 1 -skip 1 -ref 250 -24A 1 -30A 1 -FIX>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ■60iテロ範囲拡張フレーム数^(60fps範囲拡張^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem 誤爆防止の閾値設定の為、60iテロ検出部分が短くなる場合があります。それを補正します。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem この処理はAutoVFR.exeの後に行われます。"[60] f60"を含む範囲指定行を処理対象にします。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem EXBIGIfに先頭の、EXLASTfに末尾の拡張フレーム数を、指定してください。5の倍数推奨。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo @set EXBIGIf=^5>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo @set EXLASTf=^5>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem *****************************************************>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # エンコードツールをまとめたディレクトリを示す環境変数ENCTOOLSROOTPATHが定義されているか確認>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :toolsdircheck>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :project_name_check>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # 各実行ファイルが存在するか確認。存在しない場合ENCTOOLSROOTPATH内部を探索する、もしくはシステムの探索パスに委ねる>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist "%avs2pipe_path%" ^(set avs2pipe_path=%avs2pipe_path%^) else ^(call :find_avs2pipe "%avs2pipe_path%"^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist "%autovfr_path%" ^(set autovfr_path=%autovfr_path%^) else ^(call :find_autovfr "%autovfr_path%"^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # 各種実行ファイルへのパスが、最終的にどのような値になったか確認。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo avs2pipe: %%avs2pipe_path%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo AutoVfr : %%autovfr_path%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo :main>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem //----- main開始 -----//>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo title %%project_name%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo おーとおーとVFR（AutoVFR BAT版） インスパイア>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo Auto_VFRとAuto_VFR_Fastの処理を引き継ぎます>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo 閾値確認は>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ShowCombedTIVTC^(debug=true,blockx=16,blocky=32,cthresh=60^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo 等で可能です。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo txt60mcは、「IIフレーム前の最後のPフレームのフレーム番号のMod5値が、指定する値」を指定>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # カレントの.defファイルをデフォルトのものと比較し、差分があればユーザー編集済みとしてAutoVfrはスキップ>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if not exist ".\main.def" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo main.defファイルが存在しません。AutoVfrを実行します。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set exit_stat=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     call :def_diff_check>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%exit_stat%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set STARTTIME=%%DATE%% %%TIME%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if defined AUTOVFRSETTING ^(set AUTOVFRSETTING=, %%AUTOVFRSETTING%%^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if defined AUTOVFRFASTSETTING ^(set AUTOVFRFASTSETTING=, %%AUTOVFRFASTSETTING%%^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :SETPARAMETER>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem AutoVFRとAutoVFR_Fastを分岐>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set SEPARATETEMP=%%autovfr_thread_num%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%autovfr_mode%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     call :MAKESLOWAVS>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     call :MAKEFASTAVS>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo AutoVfrを走査します. . .[%%time%%]>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :AVS2PIPE_DECODE>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :MAKEDEF>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :EDITDEFm>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # .defファイルを新しく作られたものに置き換え>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :ReLOCATION>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ***************************************************************>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ■全ての処理が終了しました。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo 開始 : %%STARTTIME%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo 終了 : %%DATE%% %%TIME%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ***************************************************************>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo title コマンド プロンプト>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem //----- main終了 -----//>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo end %%~nx0 bat job...>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :autovfr_mode_detect>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f "usebackq eol=# tokens=2 delims==" %%%%A in ^(`findstr /b /r autovfr_mode "parameter.txt"`^) do ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     if "%%%%A"=="0" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         set autovfr_mode=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^) else if "%%%%A"=="1" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         set autovfr_mode=^1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         echo 不正なパラメータ指定です。デフォルトのAutoVfr^^^(Slow^^^)モードを使用します。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         set autovfr_mode=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%autovfr_mode%%"=="" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo AutoVfrのモード指定が見つかりません。デフォルトのAutoVfr^^^(Slow^^^)モードを使用します。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set autovfr_mode=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :autovfr_deint_detect>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f "usebackq eol=# tokens=2 delims==" %%%%A in ^(`findstr /b /r autovfr_deint "parameter.txt"`^) do ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     if "%%%%A"=="0" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         set autovfr_deint=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^) else if "%%%%A"=="1" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         set autovfr_deint=^1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         echo 不正なパラメータ指定です。デフォルトの自動デインターレースモードを使用します。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         set autovfr_deint=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%autovfr_deint%%"=="" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo AutoVfrのデインターレース指定が見つかりません。デフォルトの自動デインターレースモードを使用します。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set autovfr_deint=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :autovfr_threadnum_detect>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # 正規表現判定の結果で得られるエラーレベルによってパラメーターの指定が正しいか否か判定します。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # バッチファイルで数値かどうか判定したいので…（続き） - アセトアミノフェンの気ままな日常>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # http://d.hatena.ne.jp/acetaminophen/20150809/1439150912>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f "usebackq eol=# tokens=2 delims==" %%%%T in ^(`findstr /b /r autovfr_thread_num "parameter.txt"`^) do ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set thread_tmp_num=%%%%T>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo %%%%T^| findstr /x /r "^[+-]*[0-9]*[\.]*[0-9]*$" 1^>nul>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%ERRORLEVEL%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     if not "%%thread_tmp_num%%"=="" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         echo AutoVfrの実行スレッド数 %%thread_tmp_num%% です。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         set autovfr_thread_num=%%thread_tmp_num%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         echo AutoVfrの実行スレッド数が未指定かパラメーター指定そのものが見つかりません。代わりにシステムの論理CPU数 %%Number_Of_Processors%% を使用します。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         set autovfr_thread_num=%%Number_Of_Processors%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else if "%%ERRORLEVEL%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo AutoVfrの実行スレッド数の指定かパラメーター正しい値ではありません。代わりにシステムの論理CPU数 %%Number_Of_Processors%% を使用します。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set autovfr_thread_num=%%Number_Of_Processors%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set thread_tmp_num=>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :toolsdircheck>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if not defined ENCTOOLSROOTPATH ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo 環境変数 ENCTOOLSROOTPATH が未定義です>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%ENCTOOLSROOTPATH%\>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist "%%ENCTOOLSROOTPATH%%" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo 環境変数ENCTOOLSROOTPATHが有効なパスではありません>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set ENCTOOLSROOTPATH=>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :project_name_check>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set %%%%P>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :find_avs2pipe>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo findexe引数："%%~1">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if not defined ENCTOOLSROOTPATH ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set avs2pipe_path=%%~nx1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo 探索しています...>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         echo 見つかりました>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         set avs2pipe_path=%%%%~E>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     call :avspipe_env_search %%~nx1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo :avspipe_env_search>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set avs2pipe_path=%%~$PATH:1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%avs2pipe_path%%"=="" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo avs2pipeが見つかりません>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set avs2pipe_path=%%~1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :find_autovfr>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo findexe引数："%%~1">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if not defined ENCTOOLSROOTPATH ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set autovfr_path=%%~nx1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo 探索しています...>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         echo 見つかりました>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         set autovfr_path=%%%%~E>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。AutoVfr.exeは絶対パス指定をしないとiniファイルの読み込みに失敗しますので必須^(ver0.1.1.1^)。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     call :autovfr_env_search %%~nx1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo :autovfr_env_search>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set autovfr_path=%%~$PATH:1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%autovfr_path%%"=="" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo    echo AutoVfrが見つかりません>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set autovfr_path=%%~1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :def_diff_check>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo fc ".\main.def" ".\avs\main.def"^> NUL>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%errorlevel%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo .defファイルが編集済みの為、AutoVfrの実行をスキップします>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set exit_stat=^1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set exit_stat=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :SETPARAMETER>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # 環境変数のリセット>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem set SEPARATETEMP=%%SEPARATE%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if not defined OUTPATH ^(set OUT=%%~dp1^) else ^(set OUT=%%OUTPATH%%^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set PIPECOMMAND=>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set COPYCOMMAND=>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set DELCOMMANDa=>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set DELCOMMANDl=>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set /a NUMBER=%%NUMBER%%+1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set TXTLINE=>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set SPACEPOINT=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :MAKESLOWAVS>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # スレッド分割AutoVfr用avsファイル作成>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%SEPARATETEMP%%"=="0" ^(exit /b^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo copy /b ".\avs\LoadPlugin.avs" + ".\avs\Auto_Vfr.avs" ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo.^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ※フィールドオーダーを明示しないとAutoVfrスキャン処理で盛大に誤爆する可能性があるので注意>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
if "%mpeg2dec_select_flag%"=="1" (
    echo echo MPEG2VIDEO^("..\src\video.ts"^).AssumeTFF^(^)^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
) else if "%mpeg2dec_select_flag%"=="2" (
    echo echo MPEG2Source^("..\src\video.d2v",upconv=0^).AssumeTFF^(^)^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
) else if "%mpeg2dec_select_flag%"=="3" (
    echo echo video = LWLibavVideoSource^("..\src\video.ts", dr=false, repeat=true, dominance=0^).AssumeTFF^(^)^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
    echo echo video = video.height^(^) == 1088 ? video.Crop^(0, 0, 0, -8^) : video^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
    echo echo video^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
)
rem # Trim編集の1行抽出ファイル"trim_chars.txt"が存在する場合、それをAutoVfrにも反映する
echo if exist "trim_chars.txt" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem echo     echo str_trim="Trim^(1874,4559^)"^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem echo     echo Eval^(str_trim^)^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     copy /b ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs" + "trim_chars.txt" ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo Auto_VFR^(".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.txt", cut=%%autovfr_thread_num%%, number=%%SEPARATETEMP%%%%AUTOVFRSETTING%%^)^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%SEPARATETEMP%%"=="1" ^(set PIPECOMMAND="%%avs2pipe_path%%" -benchmark ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"%%PIPECOMMAND%%^) else ^(set PIPECOMMAND= ^"^|^" "%%avs2pipe_path%%" -benchmark ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"%%PIPECOMMAND%%^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%SEPARATETEMP%%"=="1" ^(set COPYCOMMAND=copy ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.txt"%%COPYCOMMAND%% ".\log\AutoVFR.log"^) else ^(set COPYCOMMAND= + ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.txt"%%COPYCOMMAND%%^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%SEPARATETEMP%%"=="1" ^(set DELCOMMANDa=del ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"%%DELCOMMANDa%%^) else ^(set DELCOMMANDa= ^"^&^"del ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"%%DELCOMMANDa%%^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%SEPARATETEMP%%"=="1" ^(set DELCOMMANDl=del ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.txt"%%DELCOMMANDl%%^) else ^(set DELCOMMANDl= ^"^&^"del ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.txt"%%DELCOMMANDl%%^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set /a SEPARATETEMP=%%SEPARATETEMP%%-1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo GOTO :MAKESLOWAVS>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :MAKEFASTAVS>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # スレッド分割AutoVfr_Fast用avsファイル作成>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%SEPARATETEMP%%"=="0" ^(exit /b^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo copy /b ".\avs\LoadPlugin.avs" + ".\avs\Auto_Vfr_Fast.avs" ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo.^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ※フィールドオーダーを明示しないとAutoVfrスキャン処理で盛大に誤爆する可能性があるので注意>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
if "%mpeg2dec_select_flag%"=="1" (
    echo echo MPEG2VIDEO^("..\src\video.ts"^).AssumeTFF^(^)^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
) else if "%mpeg2dec_select_flag%"=="2" (
    echo echo MPEG2Source^("..\src\video.d2v",upconv=0^).AssumeTFF^(^)^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
) else if "%mpeg2dec_select_flag%"=="3" (
    echo echo video = LWLibavVideoSource^("..\src\video.ts", dr=false, repeat=true, dominance=0^).AssumeTFF^(^)^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
    echo echo video = video.height^(^) == 1088 ? video.Crop^(0, 0, 0, -8^) : video^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
    echo echo video^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
)
rem # Trim編集の1行抽出ファイル"trim_chars.txt"が存在する場合、それをAutoVfrにも反映する
echo if exist "trim_chars.txt" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem echo     echo str_trim="Trim^(1874,4559^)"^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem echo     echo Eval^(str_trim^)^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     copy /b ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs" + "trim_chars.txt" ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo Auto_VFR_Fast^("..\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.txt", cut=%%autovfr_thread_num%%, number=%%SEPARATETEMP%%%%AUTOVFRFASTSETTING%%^)^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%SEPARATETEMP%%"=="1" ^(set PIPECOMMAND="%%avs2pipe_path%%" -benchmark ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"%%PIPECOMMAND%%^) else ^(set PIPECOMMAND= ^"^|^" "%%avs2pipe_path%%" -benchmark ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"%%PIPECOMMAND%%^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%SEPARATETEMP%%"=="1" ^(set COPYCOMMAND=copy ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.txt"%%COPYCOMMAND%% ".\log\AutoVFR_Fast.log"^) else ^(set COPYCOMMAND= + ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.txt"%%COPYCOMMAND%%^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%SEPARATETEMP%%"=="1" ^(set DELCOMMANDa=del ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"%%DELCOMMANDa%%^) else ^(set DELCOMMANDa= ^"^&^"del ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"%%DELCOMMANDa%%^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%SEPARATETEMP%%"=="1" ^(set DELCOMMANDl=del ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.txt"%%DELCOMMANDl%%^) else ^(set DELCOMMANDl= ^"^&^"del ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.txt"%%DELCOMMANDl%%^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set /a SEPARATETEMP=%%SEPARATETEMP%%-1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo GOTO :MAKEFASTAVS>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :AVS2PIPE_DECODE>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%autovfr_mode%%"=="0" ^(call :DECODESETs^) else ^(call :DECODESETf^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ===============================================================>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo モード            : %%MODE%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo 分割数            : %%autovfr_thread_num%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo スプリプトOptis   : %%VFROPTIONS%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo avs2pipe.exeパス  : %%avs2pipe_path%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo AutoVfr.exeパス   : %%autovfr_path%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo AutoVfr.exe設定   : %%AUTOEXESET%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo テロップ範囲拡張  : [先頭= %%EXBIGI%%] [終端= %%EXLAST%%]>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo Logファイル出力先 : %%OUTLOG%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo Defファイル出力先 : %%OUTDEF%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%DELLOG%%"=="1" ^(echo  [注] Logファイルは消去します^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ===============================================================>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo デコード開始 : %%DATE%% %%TIME%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo デコードの一時停止 : プロンプトを 右クリック＞範囲選択>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo               再開 : プロンプトを 右クリック>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ===============================================================>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo %%PIPECOMMAND:^"^|^"=^|%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ===============================================================>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo デコード終了 : %%DATE%% %%TIME%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo %%COPYCOMMAND%% ^>NUL>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo %%DELCOMMANDa:^"^&^"=^&%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist "%%OUTLOG%%" ^(echo Logファイルが作成されました。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo %%DELCOMMANDl:^"^&^"=^&%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ***************************************************************>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo :::::::::::>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo :DECODESETs>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set MODE=Auto_VFR^&set OUTLOG=.\log\AutoVFR.log^&set OUTDEF=.\tmp\AutoVFR.def^&set VFROPTIONS=[%%AUTOVFRSETTING%%]^&set AUTOEXESET=[%%EXESETTING%%]^&set EXBIGI=%%EXBIGIs%%^&set EXLAST=%%EXLASTs%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo :DECODESETf>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set MODE=Auto_VFR_Fast^&set OUTLOG=.\log\AutoVFR_Fast.log^&set OUTDEF=.\tmp\AutoVFR_Fast.def^&set VFROPTIONS=[%%AUTOVFRFASTSETTING%%]^&set AUTOEXESET=[%%FASTEXESETTING%%]^&set EXBIGI=%%EXBIGIf%%^&set EXLAST=%%EXLASTf%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :MAKEDEF>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo defファイルを出力します[%%time%%]>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%autovfr_mode%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     "%%autovfr_path%%" -i ".\log\AutoVFR.log" -o "%%OUTDEF%%" %%EXESETTING%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else if "%%autovfr_mode%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     "%%autovfr_path%%" -i ".\log\AutoVFR_Fast.log" -o "%%OUTDEF%%" %%FASTEXESETTING%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist "%%OUTDEF%%" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo defファイルが作成されました。>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     if "%%DELLOG%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         del "%%OUTLOG%%">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :EDITDEFm>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%EXBIGI%%" == "0" ^(if "%%EXLAST%%" == "0" ^(exit /b^)^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem 空白行除去>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist "%%OUTDEF%%.temp" ^(del "%%OUTDEF%%.temp"^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f ^"usebackq delims=^" %%%%k in ^(^"%%OUTDEF%%^"^) do ^(echo %%%%k ^| find /v ^"mode fps_adjust = on^"^>^>^"%%OUTDEF%%.temp^"^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist ^"%%OUTDEF%%.temp^" ^(del ^"%%OUTDEF%%^"^) else ^(echo ERROR1^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem 処理行数取得>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f ^"usebackq delims=]^" %%%%k in ^(`find /n ^"-^" ^"%%OUTDEF%%.temp^" ^^^| find /i ^"[60] f60^"`^) do ^(call set TXTLINE=%%%%TXTLINE%%%%_%%%%k[^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f ^"usebackq delims=]^" %%%%k in ^(`find /n ^"-^" ^"%%OUTDEF%%.temp^" ^^^| find /i ^"[24] txt60mc^"`^) do ^(call set TXTLINE=%%%%TXTLINE%%%%_%%%%k[^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem 範囲指定行取得>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f ^"usebackq delims=[]^" %%%%k in ^(`find /n ^"-^" ^"%%OUTDEF%%.temp^" ^^^| find ^"[^" ^^^| find ^"] ^" ^^^| sort /r`^) do ^(set BIGILINE=%%%%k^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f ^"usebackq delims=[]^" %%%%k in ^(`find /n ^"-^" ^"%%OUTDEF%%.temp^" ^^^| find ^"[^" ^^^| find ^"] ^" ^^^| sort`^) do ^(set LASTLINE=%%%%k^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem 置換>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set COUNTTXTLINE=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f "usebackq delims=" %%%%k in ^("%%OUTDEF%%.temp"^) do ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo  call :COUNTLINE>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo  call :EDITDEFs "%%%%~k">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist "%%OUTDEF%%" ^(del "%%OUTDEF%%.temp"^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :COUNTLINE>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set /a COUNTTXTLINE=%%COUNTTXTLINE%%+1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set /a BLINE=%%COUNTTXTLINE%%-1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set /a NLINE=%%COUNTTXTLINE%%+1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem 判定>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set EDITA=0^&set EDITB=0^&set EDITC=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f "usebackq delims=" %%%%l in ^(`echo %%TXTLINE%% ^^^| find /c ^"[%%BLINE%%[^"`^) do ^(set EDITA=%%%%~l^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f "usebackq delims=" %%%%l in ^(`echo %%TXTLINE%% ^^^| find /c ^"[%%COUNTTXTLINE%%[^"`^) do ^(set EDITB=%%%%~l^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f "usebackq delims=" %%%%l in ^(`echo %%TXTLINE%% ^^^| find /c ^"[%%NLINE%%[^"`^) do ^(set EDITC=%%%%~l^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :EDITDEFs>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set CHKLINE=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f "usebackq delims=" %%%%l in ^(`echo %%1 ^^^| find ^"[^" ^^^| find ^"] ^" ^^^| find /v ^"set^" ^^^| find /v ^"=-^" ^^^| find /v ^" -^" ^^^| find /c ^"-^"`^) do ^(set CHKLINE=%%%%~l^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if not "%%CHKLINE%%"=="1" ^(call :WRITEA "%%~1"^&exit /b^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo %%~1^> ".\tmp\EDITDEFt_tmp.txt">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem `echo %%~1`表記が正常に動かないので中間ファイルを使用>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem for /f "usebackq tokens=1,2* delims=-[" %%%%l in ^(`echo %%~1`^) do ^(call :EDITDEFt "%%%%~l" "%%%%~m" "%%%%~n"^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f "usebackq tokens=1,2* delims=-[" %%%%l in ^(.\tmp\EDITDEFt_tmp.txt^) do ^(call :EDITDEFt "%%%%~l" "%%%%~m" "%%%%~n"^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist ".\tmp\EDITDEFt_tmp.txt" ^(del ".\tmp\EDITDEFt_tmp.txt"^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo :WRITEA>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo %%~1^>^>"%%OUTDEF%%">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :EDITDEFt>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if %%EDITA%% == 1 ^(set PARAMBa=%%EXLAST%%^) else ^(set PARAMBa=0^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if %%EDITB%% == 1 ^(set PARAMA=%%EXBIGI%%^&set PARAMB=%%EXLAST%%^) else ^(set PARAMA=0^&set PARAMB=0^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if %%COUNTTXTLINE%% == %%BIGILINE%% ^(set PARAMA=0^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if %%COUNTTXTLINE%% == %%LASTLINE%% ^(set PARAMB=0^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if %%EDITC%% == 1 ^(set PARAMAb=%%EXBIGI%%^) else ^(set PARAMAb=0^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set /a EDITBIGI= 2*100%%~1 - %%PARAMA%% + %%PARAMBA%% - 200%%~1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set /a EDITLAST= 2*100%%~2 + %%PARAMB%% - %%PARAMAb%% - 200%%~2>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set /a SPACEPOINT=%%SPACEPOINT%%+1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%SPACEPOINT%%"=="1" ^(echo.^>^>"%%OUTDEF%%"^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo %%EDITBIGI%%-%%EDITLAST%% [%%~3^>^>"%%OUTDEF%%">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :ReLOCATION>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%autovfr_mode%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     move "main.def" ".\old\main_%%date:~0,4%%%%date:~5,2%%%%date:~8,2%%%%time:~0,2%%%%time:~3,2%%%%time:~6,2%%.def">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     move "%%OUTDEF%%" "main.def">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     move "main.def" ".\old\main_%%date:~0,4%%%%date:~5,2%%%%date:~8,2%%%%time:~0,2%%%%time:~3,2%%%%time:~6,2%%.def">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     move "%%OUTDEF%%" "main.def">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
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


:call_bat_phase
if not exist "%calling_bat_file%" (
    type nul > "%calling_bat_file%"
    echo @echo off>> "%calling_bat_file%"
    echo setlocal>> "%calling_bat_file%"
    echo echo 開始時刻[%%time%%]>> "%calling_bat_file%"
    echo.>> "%calling_bat_file%"
)
echo call "%main_bat_file%">> "%calling_bat_file%"
exit /b


:del_tmp_files
rem # 作業用のソースファイルおよび不要な一時ファイルの削除フェーズ
echo call ".\bat\del_tmp.bat">>"%main_bat_file%"
echo.>> "%main_bat_file%"
type nul > "%deltmp_batfile_path%"
echo @echo off>> "%deltmp_batfile_path%"
echo setlocal>> "%deltmp_batfile_path%"
echo echo start %%~nx0 bat job...>> "%deltmp_batfile_path%"
echo cd /d %%~dp0..\>> "%deltmp_batfile_path%"
echo.>> "%deltmp_batfile_path%"
echo rem # %%large_tmp_dir%% の存在確認および末尾チェック>> "%deltmp_batfile_path%"
echo if not exist "%%large_tmp_dir%%" ^(>> "%deltmp_batfile_path%"
echo     echo 大きなファイルを出力する一時フォルダ %%%%large_tmp_dir%%%% が存在しません、代わりにシステムのテンポラリフォルダで代用します。>> "%deltmp_batfile_path%"
echo     set large_tmp_dir=%%tmp%%>> "%deltmp_batfile_path%"
echo ^)>> "%deltmp_batfile_path%"
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\>> "%deltmp_batfile_path%"
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出>> "%deltmp_batfile_path%"
echo call :project_name_check>> "%deltmp_batfile_path%"
echo.>> "%deltmp_batfile_path%"
echo rem //----- main開始 -----//>> "%deltmp_batfile_path%"
echo title %%project_name%%>> "%deltmp_batfile_path%"
echo.>> "%deltmp_batfile_path%"
echo if exist ".\src\video.ts" del ".\src\video.ts"^&echo ".\src\video.ts" deleted>> "%deltmp_batfile_path%"
echo if exist ".\src\video.gl" del ".\src\video.gl"^&echo ".\src\video.gl" deleted>> "%deltmp_batfile_path%"
echo if exist ".\src\video.ts.lwi" del ".\src\video.ts.lwi"^&echo ".\src\video.ts.lwi" deleted>> "%deltmp_batfile_path%"
echo if exist ".\src\video_*.ts" del ".\src\video_*.ts"^&echo ".\src\video_*.ts" deleted>> "%deltmp_batfile_path%"
echo if exist ".\src\video_*.gl" del ".\src\video_*.gl"^&echo ".\src\video_*.gl" deleted>> "%deltmp_batfile_path%"
echo if exist ".\src\video_*.ts.lwi" del ".\src\video_*.ts.lwi"^&echo ".\src\video_*.ts.lwi" deleted>> "%deltmp_batfile_path%"
echo if exist ".\src\audio_pcm.wav" del ".\src\audio_pcm.wav"^&echo ".\src\audio_pcm.wav" deleted>> "%deltmp_batfile_path%"
echo if exist ".\src\audio_faw.wav" del ".\src\audio_faw.wav"^&echo ".\src\audio_faw.wav" deleted>> "%deltmp_batfile_path%"
echo for /f "delims=" %%^%%A in ^('dir /b "%%large_tmp_dir%%%%project_name%%*DELAY *ms.aac"'^) do ^( del "%%large_tmp_dir%%%%%%A"^&echo "%%large_tmp_dir%%%%%%A" deleted ^)>> "%copysrc_batfile_path%"
echo if exist "%%large_tmp_dir%%%%project_name%%.wav" del "%%large_tmp_dir%%%%project_name%%.wav"^&echo "%%large_tmp_dir%%%%project_name%%.wav" deleted>> "%deltmp_batfile_path%"
echo if exist "%%large_tmp_dir%%%%project_name%%_aac_edit.wav" del "%%large_tmp_dir%%%%project_name%%_aac_edit.wav"^&echo "%%large_tmp_dir%%%%project_name%%_aac_edit.wav" deleted>> "%deltmp_batfile_path%"
echo if exist "%%large_tmp_dir%%%%project_name%%_left.wav" del "%%large_tmp_dir%%%%project_name%%_left.wav"^&echo "%%large_tmp_dir%%%%project_name%%_left.wav" deleted>> "%deltmp_batfile_path%"
echo if exist "%%large_tmp_dir%%%%project_name%%_right.wav" del "%%large_tmp_dir%%%%project_name%%_right.wav"^&echo "%%large_tmp_dir%%%%project_name%%_right.wav" deleted>> "%deltmp_batfile_path%"
echo if exist "%%large_tmp_dir%%%%project_name%%.srt" del "%%large_tmp_dir%%%%project_name%%.srt"^&echo "%%large_tmp_dir%%%%project_name%%.srt" deleted>> "%deltmp_batfile_path%"
echo if exist "%%large_tmp_dir%%%%project_name%%_new.srt" del "%%large_tmp_dir%%%%project_name%%_new.srt"^&echo "%%large_tmp_dir%%%%project_name%%_new.srt" deleted>> "%deltmp_batfile_path%"	
echo.>> "%deltmp_batfile_path%"
echo title コマンド プロンプト>> "%deltmp_batfile_path%"
echo rem //----- main終了 -----//>> "%deltmp_batfile_path%"
echo echo end %%~nx0 bat job...>> "%deltmp_batfile_path%"
echo.>> "%deltmp_batfile_path%"
rem ------------------------------
echo :project_name_check>> "%deltmp_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(>> "%deltmp_batfile_path%"
echo     set %%%%P>> "%deltmp_batfile_path%"
echo ^)>> "%deltmp_batfile_path%"
echo exit /b>> "%deltmp_batfile_path%"
echo.>> "%deltmp_batfile_path%"
rem ------------------------------
exit /b


:copy_lgd_file_phase
rem # %lgd_file_src_path%ディレクトリの中から放送局名を含むロゴファイル(.lgd)を再帰的に見つけ出して、workディレクトリ内のlgdディレクトリにコピーします
rem # 万一ファイル名に半角カッコが含まれていると誤作動するので、call文を使用し外部関数を呼び出します。
rem # 対象となる.lgdファイルはtsrenamecで抽出した放送局名に合致したファイル名を持つものになりますので、命名則に気を付けてください
set lgd_file_counter=0
for /f "usebackq delims=" %%B in (`%tsrenamec_path% "%~1" @CH`) do (
    call :set_broadcaster_name_phase %%B
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
rem # 便宜的に最初に見つかったファイルをメインのロゴファイルとして使用します。
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
)
exit /b

:nr_filter_phase
if "%NR_filter_flag%"=="1" (
    echo #AntiComb^(^)>> "%work_dir%%main_project_name%\main.avs"
    echo fPMD^(strength = 10, threshold = 10, sigma = 1.2, mode = 1, opt = -1^)>> "%work_dir%%main_project_name%\main.avs"
)
exit /b

:DeDotCC_filter_phase
if "%DeDot_cc_filter_flag%"=="1" (
    echo cc^(y1=8,y2=8,c1=12,c2=112,interlaced=true,yc=2.,ylimit=true,climit=true^)>> "%work_dir%%main_project_name%\main.avs"
    echo DeCross^(20, 128, 4, false^)>> "%work_dir%%main_project_name%\main.avs"
)
exit /b

:sharp_filter_phase
if "%Sharp_filter_flag%"=="1" (
    echo #UnsharpMask^(32, 2, 6^)>> "%work_dir%%main_project_name%\main.avs"
    echo #WarpSharp^(36, 3, 128, -0.6^)>> "%work_dir%%main_project_name%\main.avs"
    echo edgelevel^(^)>> "%work_dir%%main_project_name%\main.avs"
) else (
    echo #UnsharpMask^(64, 2, 6^)>> "%work_dir%%main_project_name%\main.avs"
    echo #WarpSharp^(36, 3, 128, -0.6^)>> "%work_dir%%main_project_name%\main.avs"
    echo #edgelevel^(^)>> "%work_dir%%main_project_name%\main.avs"
)
exit /b

rem echo デインターレースフィルタ設定の擬似関数
:deinterlace_filter_phase
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
) else if %src_video_hight_pixel% leq %bat_vresize_flag% (
    echo ※ソースビデオの縦解像度がリサイズ指定以下の為、リサイズ処理を実施しません
    call :bat_none-vresize_phase
) else (
    if "%bat_vresize_flag%"=="1080" (
        set avs_filter_type=1080p_template
        set videoAspectratio_option=video_par1x1_option
    ) else if "%bat_vresize_flag%"=="720" (
        set avs_filter_type=720p_template
        set videoAspectratio_option=video_par1x1_option
    ) else if "%bat_vresize_flag%"=="540" (
        set avs_filter_type=540p_template
        set videoAspectratio_option=video_par1x1_option
    ) else if "%bat_vresize_flag%"=="480" (
        set avs_filter_type=480p_template
        set videoAspectratio_option=video_par40x33_option
    ) else if "%bat_vresize_flag%"=="270" (
        set avs_filter_type=272p_template
        set videoAspectratio_option=video_par1x1_option
    )
)
exit /b
:bat_none-vresize_phase
if "%src_video_hight_pixel%"=="1080" (
    set avs_filter_type=1080p_template
    if "%src_video_pixel_aspect_ratio%"=="1.333" (
        set videoAspectratio_option=video_par4x3_option
    ) else if "%src_video_pixel_aspect_ratio%"=="1.000" (
        set videoAspectratio_option=video_par1x1_option
    )
) else if "%src_video_hight_pixel%"=="480" (
    set avs_filter_type=480p_template
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
    set TsSplitter_flag=0
    set video_format_type=HD
    call :1080input_edit_selector
    exit /b
) else if "%choice%"=="2" (
    rem 2. 720×480i(16:9) ソース
    set TsSplitter_flag=0
    set video_format_type=SD
    set avs_filter_type=480p_template
    set src_video_wide_pixel=720
    set Crop_size_flag=none
    set videoAspectratio_option=video_par40x33_option
    exit /b
) else if "%choice%"=="3" (
    rem 3. 720×480i(4:3)  ソース
    set TsSplitter_flag=0
    set video_format_type=SD
    set avs_filter_type=480p_template
    set src_video_wide_pixel=720
    set Crop_size_flag=none
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
echo ### TsSplitterで分離後のファイル名の末尾につく文字列を指定してください ###
set split_type=
set /p split_type=%~n1_
if "%split_type:~0,2%"=="HD" (
    set video_format_type=HD
) else if "%split_type:~0,2%"=="SD" (
    set video_format_type=SD
) else (
    set video_format_type=HD
)
call :copy_source_phase
echo "%TsSplitter_path%" -EIT -ECM -EMM -1SEG -OUT "%work_dir%src" "%input_media_path%">> "%main_bat_file%"
set input_media_path=%work_dir%src\%~n1_%split_type%%~x1
exit /b

:1080input_edit_selector
rem # 1080i入力の場合に、どのように編集するかの擬似関数
rem # ここに--sarオプションのフラグをつける(1080pの場合はこの次で)
echo.
echo ### どのように編集しますか？ ###
echo 1.  フルワイド → 1080 出力
echo 2.  フルワイド → 720  出力
echo 3.  フルワイド → 540  出力
echo 4.  フルワイド → 16:9 480出力
echo 5. サイドカット→ 4:3  480出力
echo 6.    超額縁   → 16:9 480出力
echo 7.  フルワイド → PSP(270p)出力
echo 8. サイドカット→ PSP(270p)出力
echo 9.    超額縁   → PSP(270p)出力
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="" (
    echo 選択してください！
    goto :1080input_edit_selector
) else if "%choice%"=="1" (
    rem 1.  フルワイド → 1080 出力
    set avs_filter_type=1080p_template
    set Crop_size_flag=none
    if "%src_video_wide_pixel%"=="1440" (
        set videoAspectratio_option=video_par4x3_option
    ) else if "%src_video_wide_pixel%"=="1920" (
        set videoAspectratio_option=video_par1x1_option
    ) else (
        call :HDvideo_wideselector
    )
    exit /b
) else if "%choice%"=="2" (
    rem 2.  フルワイド → 720  出力
    set avs_filter_type=720p_template
    set Crop_size_flag=none
    set videoAspectratio_option=video_par1x1_option
    exit /b
) else if "%choice%"=="3" (
    rem 3.  フルワイド → 540  出力
    set avs_filter_type=540p_template
    set Crop_size_flag=none
    set videoAspectratio_option=video_par1x1_option
    exit /b
) else if "%choice%"=="4" (
    rem 4.  フルワイド → 16:9 480出力
    set avs_filter_type=480p_template
    set Crop_size_flag=none
    set videoAspectratio_option=video_par40x33_option
    exit /b
) else if "%choice%"=="5" (
    rem 5. サイドカット→ 4:3  480出力
    set avs_filter_type=480p_template
    set Crop_size_flag=sidecut
    set videoAspectratio_option=video_par10x11_option
    if "%src_video_wide_pixel%"=="" (
        call :HDvideo_wideselector
    )
    exit /b
) else if "%choice%"=="6" (
    rem 6.    超額縁   → 16:9 480出力
    set avs_filter_type=480p_template
    set Crop_size_flag=gakubuchi
    set videoAspectratio_option=video_par40x33_option
    if "%src_video_wide_pixel%"=="" (
        call :HDvideo_wideselector
    )
    exit /b
) else if "%choice%"=="7" (
    rem 7.  フルワイド → PSP(270p)出力
    set avs_filter_type=272p_template
    set Crop_size_flag=none
    set videoAspectratio_option=video_par1x1_option
    exit /b
) else if "%choice%"=="8" (
    rem 8. サイドカット→ PSP(270p)出力
    set avs_filter_type=PSP_square_template
    set Crop_size_flag=sidecut
    set videoAspectratio_option=video_par1x1_option
    if "%src_video_wide_pixel%"=="" (
        call :HDvideo_wideselector
    )
    exit /b
) else if "%choice%"=="9" (
    rem 9.    超額縁   → PSP(270p)出力
    set avs_filter_type=272p_template
    set Crop_size_flag=gakubuchi
    set videoAspectratio_option=video_par1x1_option
    if "%src_video_wide_pixel%"=="" (
        call :HDvideo_wideselector
    )
    exit /b
) else (
    rem 不正な入力
    echo 正しい値を選択してください！
    goto :1080input_edit_selector
)
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
    )
) else if "%choice%"=="2" (
    set src_video_wide_pixel=1920
    if "%avs_filter_type%"=="1080p_template" (
        set videoAspectratio_option=video_par1x1_option
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

:NR_filter_selector
rem # ノイズリダクションフィルタの選択
echo.
echo ### 使用するノイズ除去フィルタを選択してください ###
echo 1. ドット妨害/クロスカラー除去
echo 2. リンギング除去
echo 3. ドット妨害クロスカラー除去＋リンギング除去
echo 0. なし
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="" (
    echo 選択してください！
    goto :NR_filter_selector
)
if "%choice%"=="1" (
    set DeDot_cc_filter_flag=1
    set NR_filter_flag=0
    set Sharp_filter_flag=1
) else if "%choice%"=="2" (
    set DeDot_cc_filter_flag=0
    set NR_filter_flag=1
    set Sharp_filter_flag=1
) else if "%choice%"=="3" (
    set DeDot_cc_filter_flag=1
    set NR_filter_flag=1
    set Sharp_filter_flag=1
) else (
    set DeDot_cc_filter_flag=0
    set NR_filter_flag=0
    set Sharp_filter_flag=0
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


:make_avsplugin_phase
rem # プラグイン読み込み部分
if "%importloardpluguin_flag%"=="1" (
    copy "%plugin_template%" "%work_dir%%main_project_name%\avs\LoadPlugin.avs"
    echo ##### プラグイン読み込み部分のインポート #####>> "%work_dir%%main_project_name%\main.avs"
    echo Import^(".\avs\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\main.avs"
    echo.>> "%work_dir%%main_project_name%\main.avs"
) else (
    copy /b "%work_dir%%main_project_name%\main.avs" + "%plugin_template%" "%work_dir%%main_project_name%\main.avs"
    echo.>>"%work_dir%%main_project_name%\main.avs"
)
rem # ソース入力前のフィルタ群
copy /b "%work_dir%%main_project_name%\main.avs" + "%load_source%" "%work_dir%%main_project_name%\main.avs"
echo.>>"%work_dir%%main_project_name%\main.avs"
exit /b


:make_previewfile_phase
rem ### ユーザーの入力した設定にしたがってavsファイルを作成する擬似関数
rem %work_dir%%main_project_name%にスクリプトを作成します
echo.
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
    echo MPEG2VIDEO^("%~1"^).AssumeTFF^(^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo MPEG2VIDEO^("%~1"^).AssumeTFF^(^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo MPEG2VIDEO^("%~1"^).AssumeTFF^(^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo MPEG2VIDEO^("%~1"^).AssumeTFF^(^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
) else if "%mpeg2dec_select_flag%"=="2" (
    echo MPEG2Source^("%~dpn1.d2v",upconv=0^).ConvertToYUY2^(^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo MPEG2Source^("%~dpn1.d2v",upconv=0^).ConvertToYUY2^(^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo MPEG2Source^("%~dpn1.d2v",upconv=0^).ConvertToYUY2^(^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo MPEG2Source^("%~dpn1.d2v",upconv=0^).ConvertToYUY2^(^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
) else if "%mpeg2dec_select_flag%"=="3" (
    echo video = LWLibavVideoSource^("%~1", dr=false, repeat=true, dominance=0^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo video = video.height^(^) == 1088 ? video.Crop^(0, 0, 0, -8^) : video>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo audio = LWLibavAudioSource^("%~1", stream_index=-1, av_sync=false, layout="stereo"^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo AudioDub^(video, audio^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo video = LWLibavVideoSource^("%~1", dr=false, repeat=true, dominance=0^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo video = video.height^(^) == 1088 ? video.Crop^(0, 0, 0, -8^) : video>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo audio = LWLibavAudioSource^("%~1", stream_index=-1, av_sync=false, layout="stereo"^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo AudioDub^(video, audio^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo video = LWLibavVideoSource^("%~1", dr=false, repeat=true, dominance=0^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo video = video.height^(^) == 1088 ? video.Crop^(0, 0, 0, -8^) : video>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo audio = LWLibavAudioSource^("%~1", stream_index=-1, av_sync=false, layout="stereo"^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo AudioDub^(video, audio^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo video = LWLibavVideoSource^("%~1", dr=false, repeat=true, dominance=0^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
    echo video = video.height^(^) == 1088 ? video.Crop^(0, 0, 0, -8^) : video>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
    echo audio = LWLibavAudioSource^("%~1", stream_index=-1, av_sync=false, layout="stereo"^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
    echo AudioDub^(video, audio^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"

)
echo #KillAudio^(^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo.>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #KillAudio^(^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo.>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo KillAudio^(^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo.>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #KillAudio^(^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo.>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
exit /b


:avs_interlacebefore_privew
copy /b "%work_dir%%main_project_name%\preview1_straight.avs" + "%aff_template%" "%work_dir%%main_project_name%\preview1_straight.avs"
echo.>>"%work_dir%%main_project_name%\preview1_straight.avs"
copy /b "%work_dir%%main_project_name%\preview2_trimed.avs" + "%aff_template%" "%work_dir%%main_project_name%\preview2_trimed.avs"
echo.>>"%work_dir%%main_project_name%\preview2_trimed.avs"
copy /b "%work_dir%%main_project_name%\preview3_anticomb.avs" + "%aff_template%" "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo.>>"%work_dir%%main_project_name%\preview3_anticomb.avs"
copy /b "%work_dir%%main_project_name%\preview4_deinterlace.avs" + "%aff_template%" "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo.>>"%work_dir%%main_project_name%\preview4_deinterlace.avs"
exit /b


:preview_setting_filter
rem ----------
echo ##### カット編集 #####>> "%work_dir%%main_project_name%\preview1_straight.avs"
rem # 以下のインポート元ファイルにTrim情報を記入してください
echo #Import^("trim_line.txt"^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo.>> "%work_dir%%main_project_name%\preview1_straight.avs"
rem ----------
echo ##### カット編集 #####>> "%work_dir%%main_project_name%\preview2_trimed.avs"
rem # 以下のインポート元ファイルにTrim情報を記入してください
echo Import^("trim_line.txt"^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo.>> "%work_dir%%main_project_name%\preview2_trimed.avs"
rem ----------
echo ##### カット編集 #####>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
rem # 以下のインポート元ファイルにTrim情報を記入してください
echo Import^("trim_line.txt"^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
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
echo Import^("trim_line.txt"^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
rem echo Import^("trim_multi.txt"^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo.>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo ##### プレビュー用フィルタ #####>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo Its^(opt=1, def=".\main.def", fps=-1, debug=false, output="", chapter=""^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo.>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
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
echo ##### 編集＆解析のためのAVS #####> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #//--- プラグイン読み込み部分のインポート ---//>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo Import^(".\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo.>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #//--- ソースの読み込み ---//>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
if "%mpeg2dec_select_flag%"=="1" (
    echo video = MPEG2VIDEO^("..\src\video.ts"^).AssumeTFF^(^)>>"%work_dir%%main_project_name%\avs\edit_analyze.avs"
) else if "%mpeg2dec_select_flag%"=="2" (
    echo video = MPEG2Source^("..\src\video.d2v",upconv=0^).ConvertToYUY2^(^)>>"%work_dir%%main_project_name%\avs\edit_analyze.avs"
) else if "%mpeg2dec_select_flag%"=="3" (
    echo video = LWLibavVideoSource^("..\src\video.ts", dr=false, repeat=true, dominance=0^)>>"%work_dir%%main_project_name%\avs\edit_analyze.avs"
    echo video = video.height^(^) == 1088 ? video.Crop^(0, 0, 0, -8^).ConvertToYUY2^(^) : video.ConvertToYUY2^(^)>>"%work_dir%%main_project_name%\avs\edit_analyze.avs"
)
echo audio = WAVSource^("..\src\audio_pcm.wav"^)>>"%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo AudioDub^(video, audio^)>>"%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo.>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #//--- フィールドオーダー ---//>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #AssumeFrameBased^(^).ComplementParity^(^)    #トップフィールドが支配的>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #AssumeFrameBased^(^)            #ボトムフィールドが支配的>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #AssumeTFF^(^)                #トップファースト>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #AssumeBFF^(^)                #ボトムファースト>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo.>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #//--- Trim情報インポート ---//>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo Import^("..\trim_chars.txt"^)>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo.>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #//--- 色空間変更^(ロゴ解析の為にYV12必須^) ---//>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #ConvertToYUY2^(^)>>"%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo ConvertToYV12^(^)>>"%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo.>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo return last>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
exit /b

:avs_interlacebefore_phase
copy /b "%work_dir%%main_project_name%\main.avs" + "%aff_template%" "%work_dir%%main_project_name%\main.avs"
echo.>>"%work_dir%%main_project_name%\main.avs"
exit /b

:interlaced_filter_phase
copy /b "%work_dir%%main_project_name%\main.avs" + "%interlaced_filter_template%" "%work_dir%%main_project_name%\main.avs"
echo.>>"%work_dir%%main_project_name%\main.avs"
exit /b

:eraselogo_filter
rem # 半透過ロゴ除去関数AVSファイル作成、中身はlogoframe実行時に上書き
type nul> "%work_dir%%main_project_name%\avs\EraseLogo.avs"
exit /b

:make_ColorMatrix_filter
if "%avs_filter_type%"=="1080p_template" (
    exit /b
) else if "%avs_filter_type%"=="720p_template" (
    exit /b
) else if "%avs_filter_type%"=="540p_template" (
    exit /b
) else (
    echo ColorMatrix^(mode="Rec.709->Rec.601", interlaced=true^)    #BT.709からBT.601へ変換>> "%work_dir%%main_project_name%\main.avs"
    echo.>> "%work_dir%%main_project_name%\main.avs"
)
exit /b

:avs_interlacemain_phase
copy /b "%work_dir%%main_project_name%\main.avs" + "%deinterlace_filter_template%" "%work_dir%%main_project_name%\main.avs"
exit /b

:crop_filter_phase
if "%Crop_size_flag%"=="sidecut" (
    if "%src_video_wide_pixel%"=="1920" (
        echo Crop^(240, 0, -240, -0^)    #クリッピング^(左, 上, -右, -下^)>> "%work_dir%%main_project_name%\main.avs"
    ) else if "%src_video_wide_pixel%"=="720" (
        echo Crop^(96, 0, -96, -0^)    #クリッピング^(左, 上, -右, -下^)>> "%work_dir%%main_project_name%\main.avs"
    ) else (
        echo Crop^(180, 0, -180, -0^)    #クリッピング^(左, 上, -右, -下^)>> "%work_dir%%main_project_name%\main.avs"
    )
) else if "%Crop_size_flag%"=="gakubuchi" (
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
exit /b

:resize_filter_phase
if "%src_video_wide_pixel%"=="720" (
    if "%avs_filter_type%"=="272p_template" (
        echo Lanczos4Resize^(480,270^)>> "%work_dir%%main_project_name%\main.avs"
    )
) else (
    if "%avs_filter_type%"=="720p_template" (
        echo Lanczos4Resize^(1280,720^)>> "%work_dir%%main_project_name%\main.avs"
    ) else if "%avs_filter_type%"=="540p_template" (
        echo Lanczos4Resize^(960,540^)>> "%work_dir%%main_project_name%\main.avs"
    ) else if "%avs_filter_type%"=="480p_template" (
        echo Lanczos4Resize^(704,480^)>> "%work_dir%%main_project_name%\main.avs"
    ) else if "%avs_filter_type%"=="272p_template" (
        echo Lanczos4Resize^(480,270^)>> "%work_dir%%main_project_name%\main.avs"
    )
)
exit /b

:add_border_phase
if "%avs_filter_type%"=="480p_template" (
    if not "%src_video_wide_pixel%"=="720" (
        echo AddBorders^(8,0,8,0^)    #黒帯付加>> "%work_dir%%main_project_name%\main.avs"
    )
)
exit /b

:avs_interlaceafter_phase
echo.>>"%work_dir%%main_project_name%\main.avs"
copy /b "%work_dir%%main_project_name%\main.avs" + "%uninterlaced_filter_template%" "%work_dir%%main_project_name%\main.avs"
exit /b

:ConvertToYV12_filter_phase
echo.>>"%work_dir%%main_project_name%\main.avs"
echo #//---  ConvertToYV12 ---//>>"%work_dir%%main_project_name%\main.avs"
if "%deinterlace_filter_flag%"=="interlace" (
    echo ConvertToYV12^(interlaced=true^)>>"%work_dir%%main_project_name%\main.avs"
) else (
    echo ConvertToYV12^(interlaced=false^)>>"%work_dir%%main_project_name%\main.avs"
)
echo #ConvertToYUY2^(interlaced=false^)>>"%work_dir%%main_project_name%\main.avs"
echo #gradfun2db^(^)    #バンディング除去フィルタ・プラグイン>>"%work_dir%%main_project_name%\main.avs"
exit /b

:ItsCut_filter_phase
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
rem # メインバッチファイルの作成、%calling_bat_file%が定義されている場合、プロジェクトディレクトリ
rem # 以下にAVSと同名のメインバッチファイルを作成しそれを%calling_bat_file%が呼び出す形式、setをサブルーチン化
set main_bat_file=%work_dir%%main_project_name%\main.bat
if not exist "%main_bat_file%" (
    echo メインバッチファイルがないので作成します...
    type nul > "%main_bat_file%"
    echo @echo off>> "%main_bat_file%"
    echo setlocal>> "%main_bat_file%"
    rem echo echo 開始時刻[%%time%%]>> "%main_bat_file%"
) else (
    if "%calling_bat_file%"=="" (
        rem %calling_bat_file%を使用せず、かつ既にメインバッチファイルが存在している場合
        rem 保留中・・・
        exit /b
    ) else (
        echo 既にバッチファイルが存在しています。名前を変更し新規に作成します。
        rename "%main_bat_file%" "backup%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%_main.bat"
        type nul > "%main_bat_file%"
        echo @echo off>> "%main_bat_file%"
        echo setlocal>> "%main_bat_file%"
        rem echo echo 開始時刻[%%time%%]>> "%main_bat_file%"
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
echo echo ### %main_project_name% のエンコード[%%time%%] ###>> "%main_bat_file%"
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
rem ### 指定したドライブのメディアタイプを判別するためのVBスクリプト、ソースファイルがローカルHDDドライブにあるか確認用
echo WScript.Echo CStr^(CreateObject^("Scripting.FileSystemObject"^).GetDrive^(WScript.Arguments^(0^)^).DriveType^)> "%work_dir%%main_project_name%\bat\media_check.vbs"
rem ### TSソースをコピーする擬似関数、TsSplitterによる処理も内包
type nul > "%copysrc_batfile_path%"
echo @echo off>> "%copysrc_batfile_path%"
echo setlocal>> "%copysrc_batfile_path%"
echo echo start %%~nx0 bat job...>> "%copysrc_batfile_path%"
echo chdir /d %%~dp0..\>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
echo rem # 使用するコピーアプリケーションを選択します>> "%copysrc_batfile_path%"
echo call :copy_app_detect>> "%copysrc_batfile_path%"
echo rem copy^(Default^), fac^(FastCopy^), ffc^(FireFileCopy^)>> "%copysrc_batfile_path%"
echo rem set copy_app_flag=%copy_app_flag%>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
echo echo ソースをローカルにコピーしています. . .[%%time%%]>> "%copysrc_batfile_path%"
echo rem # %%large_tmp_dir%% の存在確認および末尾チェック>> "%copysrc_batfile_path%"
echo if not exist "%%large_tmp_dir%%" ^(>> "%copysrc_batfile_path%"
echo     echo 大きなファイルを出力する一時フォルダ %%%%large_tmp_dir%%%% が存在しません、代わりにシステムのテンポラリフォルダで代用します。>> "%copysrc_batfile_path%"
echo     set large_tmp_dir=%%tmp%%>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\>> "%copysrc_batfile_path%"
echo rem # エンコードツールをまとめたディレクトリを示す環境変数ENCTOOLSROOTPATHが定義されているか確認>> "%copysrc_batfile_path%"
echo call :toolsdircheck>> "%copysrc_batfile_path%"
echo rem # parameterファイル中のソースファイルへのフルパス^(src_file_path^)を検出>> "%copysrc_batfile_path%"
echo call :src_file_path_check>> "%copysrc_batfile_path%"
echo rem # 検出したソースファイルへのフルパスの中からファイル名^(src_file_name^)の部分のみを抽出>> "%copysrc_batfile_path%"
echo call :src_file_name_extraction "%%src_file_path%%">> "%copysrc_batfile_path%"
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出>> "%copysrc_batfile_path%"
echo call :project_name_check>> "%copysrc_batfile_path%"
echo rem # parameterファイル中のMPEG-2デコーダータイプ^(mpeg2dec_select_flag^)を検出>> "%copysrc_batfile_path%"
echo call :mpeg2dec_select_flag_check>> "%copysrc_batfile_path%"
echo rem # parameterファイル中の強制コピーフラグ^(force_copy_src^)を検出>> "%copysrc_batfile_path%"
echo call :force_src_copy_check>> "%copysrc_batfile_path%"
echo rem # ソースメディア情報^(src_media_type^)を検出>> "%copysrc_batfile_path%"
echo call :src_media_type_check "%%src_file_path%%">> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
echo rem # 各実行ファイルが存在するか確認。存在しない場合ENCTOOLSROOTPATH内部を探索する、もしくはシステムの探索パスに委ねる>> "%copysrc_batfile_path%"
echo rem # それでも見つからない場合、コマンドプロンプト標準のcopyコマンドを使用する>> "%copysrc_batfile_path%"
echo if exist "%ffc_path%" ^(set ffc_path=%ffc_path%^) else ^(call :find_ffc "%ffc_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%fac_path%" ^(set fac_path=%fac_path%^) else ^(call :find_fac "%fac_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%ts2aac_path%" ^(set ts2aac_path=%ts2aac_path%^) else ^(call :find_ts2aac "%ts2aac_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%ts_parser_path%" ^(set ts_parser_path=%ts_parser_path%^) else ^(call :find_ts_parser "%ts_parser_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%faad_path%" ^(set faad_path=%faad_path%^) else ^(call :find_faad "%faad_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%FAW_path%" ^(set FAW_path=%FAW_path%^) else ^(call :find_FAW "%FAW_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%TsSplitter_path%" ^(set TsSplitter_path=%TsSplitter_path%^) else ^(call :find_TsSplitter "%TsSplitter_path%"^)>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
echo rem # 各種実行ファイルへのパスが、最終的にどのような値になったか確認。>> "%copysrc_batfile_path%"
echo echo FireFileCopy: %%ffc_path%%>> "%copysrc_batfile_path%"
echo echo FastCopy    : %%fac_path%%>> "%copysrc_batfile_path%"
echo echo ts2aac      : %%ts2aac_path%%>> "%copysrc_batfile_path%"
echo echo ts_parser   : %%ts_parser_path%%>> "%copysrc_batfile_path%"
echo echo faad        : %%faad_path%%>> "%copysrc_batfile_path%"
echo echo FakeAacWav  : %%FAW_path%%>> "%copysrc_batfile_path%"
echo echo TsSplitter  : %%TsSplitter_path%%>> "%copysrc_batfile_path%"
echo echo.>> "%copysrc_batfile_path%"
echo rem # 各種環境情報>> "%copysrc_batfile_path%"
echo echo ソースファイルへのフルパス: %%src_file_path%%>> "%copysrc_batfile_path%"
echo echo ソースファイル名  ： %%src_file_name%%>> "%copysrc_batfile_path%"
echo echo プロジェクト名    ： %%project_name%%>> "%copysrc_batfile_path%"
echo echo コピーソースフラグ : %%force_copy_src%%>> "%copysrc_batfile_path%"
echo echo 　0: ソースがネットワークフォルダの場合のみコピー>> "%copysrc_batfile_path%"
echo echo 　1: ソースのメディアタイプに関係なくコピー>> "%copysrc_batfile_path%"
echo echo ソースメディア情報 : %%src_media_type%%>> "%copysrc_batfile_path%"
echo echo 　1：リムーバブルドライブ^(USBメモリ/SDカード/FDなど^)>> "%copysrc_batfile_path%"
echo echo 　2：HDD>> "%copysrc_batfile_path%"
echo echo 　3：ネットワークドライブ>> "%copysrc_batfile_path%"
echo echo 　4：CD-ROM/CD-R/DVD-ROM/DVD-Rなど>> "%copysrc_batfile_path%"
echo echo 　5：RAMディスク>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
echo :main>> "%copysrc_batfile_path%"
echo rem //----- main開始 -----//>> "%copysrc_batfile_path%"
echo title %%project_name%%>> "%copysrc_batfile_path%"
echo if not exist ".\src\video*%~x1" ^(>> "%copysrc_batfile_path%"
echo     if not exist "%%src_file_path%%" ^(>> "%copysrc_batfile_path%"
echo         echo ソースファイルが見つからない為処理を続行できません、中断します>> "%copysrc_batfile_path%"
echo         exit /b>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo     if "%%force_copy_src%%"=="1" ^(>> "%copysrc_batfile_path%"
echo         echo 強制コピーフラグが有効な為、ソースをローカルフォルダに一時コピーします>> "%copysrc_batfile_path%"
echo         call :copy_src_phase>> "%copysrc_batfile_path%"
echo     ^) else ^(>> "%copysrc_batfile_path%"
echo         if not "%%src_media_type%%"=="2" ^(>> "%copysrc_batfile_path%"
echo             echo ソースファイルが記録されているメディアがローカルHDD以外の為、一時コピーします>> "%copysrc_batfile_path%"
echo             call :copy_src_phase>> "%copysrc_batfile_path%"
echo         ^) else ^(>> "%copysrc_batfile_path%"
echo             echo ソースファイルが記録されているメディアがローカルHDDです、シンボリックリンクの作成を試みます>> "%copysrc_batfile_path%"
echo             call :mklink_src_phase>> "%copysrc_batfile_path%"
echo         ^)>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo サブディレクトリに既にソースファイルが存在するためコピーは実施しません>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo if exist ".\src\video.ts" ^(>> "%copysrc_batfile_path%"
echo     set input_media_path=.\src\video.ts>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     call :set_input_media_to_src>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
echo set src_tsfile_counter=^0>> "%copysrc_batfile_path%"
echo set type-count=>> "%copysrc_batfile_path%"
echo rem # AAC音声ファイルの分離>> "%copysrc_batfile_path%"
echo call :ext_aac_audio_phase "%%input_media_path%%">> "%copysrc_batfile_path%"
echo rem # WAVデコード^(プレビューやCMカットに使用^)>> "%copysrc_batfile_path%"
echo call :wav_decode_audio_phase %%aac_audio_source%%>> "%copysrc_batfile_path%"
echo rem # FAWファイル出力>> "%copysrc_batfile_path%"
echo call :ext_faw_audio_phase %%aac_audio_source%%>> "%copysrc_batfile_path%"
echo del %%aac_audio_source%%>> "%copysrc_batfile_path%"
echo title コマンド プロンプト>> "%copysrc_batfile_path%"
echo rem //----- main終了 -----//>> "%copysrc_batfile_path%"
echo echo end %%~nx0 bat job...>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :copy_src_phase>> "%copysrc_batfile_path%"
if "%TsSplitter_flag%"=="1" (
    call :splitted_inputmedia_detect "%~1"
    set copy_to_path=%%large_tmp_dir%%
    set tssp_comment_flag=
    set rename_src_flag=rem 
) else (
    call :nosplit_inputmedia_detect "%~1"
    set copy_to_path=..\
    set tssp_comment_flag=rem 
    set rename_src_flag=
)
echo if "%%copy_app_flag%%"=="fac" ^(>> "%copysrc_batfile_path%"
echo     if exist "%%fac_path%%" ^(>> "%copysrc_batfile_path%"
echo         echo FastCopy でコピーを実行します>> "%copysrc_batfile_path%"
echo         "%%fac_path%%" /cmd=diff /force_close /disk_mode=auto "%%src_file_path%%" /to="%copy_to_path%">> "%copysrc_batfile_path%"
echo     ^) else ^(>> "%copysrc_batfile_path%"
echo         set copy_app_flag=copy>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo ^) else if "%%copy_app_flag%%"=="ffc" ^(>> "%copysrc_batfile_path%"
echo     if exist "%%ffc_path%%" ^(>> "%copysrc_batfile_path%"
echo         echo FireFileCopy でコピーを実行します>> "%copysrc_batfile_path%"
echo         "%%ffc_path%%" "%%src_file_path%%" /copy /a /bg /md /nk /ys /to:"%copy_to_path%">> "%copysrc_batfile_path%"
echo     ^) else ^(>> "%copysrc_batfile_path%"
echo         set copy_app_flag=copy>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo if "%%copy_app_flag%%"=="copy" ^(>> "%copysrc_batfile_path%"
echo     echo コマンドプロンプト標準のcopyコマンドでコピーを実行します>> "%copysrc_batfile_path%"
echo     copy /z "%%src_file_path%%" "%copy_to_path%">> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo %tssp_comment_flag%"%%TsSplitter_path%%" -EIT -ECM -EMM -1SEG -OUT ".\src" "%copy_to_path%%%src_file_name%%">> "%copysrc_batfile_path%"
echo %rename_src_flag%move "%copy_to_path%%%src_file_name%%" ".\src\video%~x1"^> nul>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :mklink_src_phase>> "%copysrc_batfile_path%"
echo rem # verコマンドの出力結果を確認し、WindowsXP以前のOSの場合はシンボリックリンクが使えないので代わりにcopyを実行します。>> "%copysrc_batfile_path%"
echo for /f "tokens=2 usebackq delims=[]" %%%%W in ^(`ver`^) do ^(>> "%copysrc_batfile_path%"
echo     set os_version=%%%%W>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo echo OS %%os_version%%>> "%copysrc_batfile_path%"
echo for /f "tokens=2 usebackq delims=. " %%%%V in ^(`echo %%os_version%%`^) do ^(>> "%copysrc_batfile_path%"
echo     set major_version=%%%%V>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo if %%major_version%% leq 5 ^(>> "%copysrc_batfile_path%"
echo     echo 実行環境がWindowsXP以前のOSの為シンボリックリンクが使えません。代わりにcopy処理を実行します。>> "%copysrc_batfile_path%"
echo     call :copy_src_phase>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo ソースファイルのシンボリックリンクを作成します。>> "%copysrc_batfile_path%"
echo     mklink ".\src\video%~x1" "%%src_file_path%%">> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :TsSplitter_src_retry_phase>> "%copysrc_batfile_path%"
echo echo %%TsSplitter_path%% -OUT ".\src" -SEPAC -1SEG "%%input_media_path%%">> "%copysrc_batfile_path%"
echo %%TsSplitter_path%% -OUT ".\src" -SEPAC -1SEG "%%input_media_path%%">> "%copysrc_batfile_path%"
echo if exist ".\src\video_HD.ts" ^(>> "%copysrc_batfile_path%"
echo     move ".\src\video_HD.ts" ".\src\video_HD-0.ts">> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo if exist ".\src\video_SD.ts" ^(>> "%copysrc_batfile_path%"
echo     move ".\src\video_SD.ts" ".\src\video_SD-0.ts">> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo echo HDサイズファイルの一覧>> "%copysrc_batfile_path%"
echo set tssplitter_HD_counter=^0>> "%copysrc_batfile_path%"
echo for /f "delims=" %%%%F in ^('dir /b ".\src\video_HD*.ts"'^) do ^(>> "%copysrc_batfile_path%"
echo     echo %%%%F>> "%copysrc_batfile_path%"
echo     set /a tssplitter_HD_counter=tssplitter_HD_counter+1>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo echo SDサイズファイルの一覧>> "%copysrc_batfile_path%"
echo set tssplitter_SD_counter=^0>> "%copysrc_batfile_path%"
echo for /f "delims=" %%%%F in ^('dir /b ".\src\video_SD*.ts"'^) do ^(>> "%copysrc_batfile_path%"
echo     echo %%%%F>> "%copysrc_batfile_path%"
echo     set /a tssplitter_SD_counter=tssplitter_SD_counter+1>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo rem # 偶数連番と奇数連番のファイル総容量を比較し、大きい方のグループを後続の処理対象とする。>> "%copysrc_batfile_path%"
echo rem # Windowsのバッチファイルが 2147483647 までの値しか計算できないので、MBサイズに丸め込んで計算する。>> "%copysrc_batfile_path%"
echo rem # 偶数番ファイル数カウント^(even^)>> "%copysrc_batfile_path%"
echo set HD_even_count=^0>> "%copysrc_batfile_path%"
echo set HD_even_total_filesize=^0>> "%copysrc_batfile_path%"
echo :HD_even_count_loop>> "%copysrc_batfile_path%"
echo if exist ".\src\video_HD-%%HD_even_count%%.ts" ^(>> "%copysrc_batfile_path%"
echo     call :filesize_calc_even ".\src\video_HD-%%HD_even_count%%.ts">> "%copysrc_batfile_path%"
echo     set /a HD_even_count=HD_even_count+2>> "%copysrc_batfile_path%"
echo     goto :HD_even_count_loop>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     set /a HD_even_count=HD_even_count-2>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo echo 偶数番トータルファイルサイズ^(MB^)：%%HD_even_total_filesize%%>> "%copysrc_batfile_path%"
echo rem # 奇数番ファイル数カウント^(odd^)>> "%copysrc_batfile_path%"
echo set HD_odd_count=^1>> "%copysrc_batfile_path%"
echo set HD_odd_total_filesize=^0>> "%copysrc_batfile_path%"
echo :HD_odd_count_loop>> "%copysrc_batfile_path%"
echo if exist ".\src\video_HD-%%HD_odd_count%%.ts" ^(>> "%copysrc_batfile_path%"
echo     call :filesize_calc_odd ".\src\video_HD-%%HD_odd_count%%.ts">> "%copysrc_batfile_path%"
echo     set /a HD_odd_count=HD_odd_count+2>> "%copysrc_batfile_path%"
echo     goto :HD_odd_count_loop>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     set /a HD_odd_count=HD_odd_count-2>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo echo 奇数番トータルファイルサイズ^(MB^)：%%HD_odd_total_filesize%%>> "%copysrc_batfile_path%"
echo rem # ファイル総容量を比較>> "%copysrc_batfile_path%"
echo if %%HD_odd_total_filesize%% geq %%HD_even_total_filesize%% ^(>> "%copysrc_batfile_path%"
echo     echo 奇数番のトータルファイルサイズが大きいです。以降の処理はこのグループに対して行います。>> "%copysrc_batfile_path%"
echo     call :HD_odd_retry_phase>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo 偶数番のトータルファイルサイズが大きいです。以降の処理はこのグループに対して行います。>> "%copysrc_batfile_path%"
echo     call :HD_even_retry_phase>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :filesize_calc_even>> "%copysrc_batfile_path%"
echo rem # 偶数番ファイルサイズ計算>> "%copysrc_batfile_path%"
echo set /a HD_even_total_filesize=HD_even_total_filesize+%%~z1/1024/1024>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :filesize_calc_odd>> "%copysrc_batfile_path%"
echo rem # 奇数番ファイルサイズ計算>> "%copysrc_batfile_path%"
echo set /a HD_odd_total_filesize=HD_odd_total_filesize+%%~z1/1024/1024>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :HD_even_retry_phase>> "%copysrc_batfile_path%"
echo rem # 偶数番の各ファイルごとにオーディオ処理を繰り返します>> "%copysrc_batfile_path%"
echo set HD_even_tmp_count=^0>> "%copysrc_batfile_path%"
echo :HD_even_retry_loop>> "%copysrc_batfile_path%"
echo set type-count=_HD-%%HD_even_tmp_count%%>> "%copysrc_batfile_path%"
echo call :ext_aac_audio_phase ".\src\video_HD-%%HD_even_tmp_count%%.ts">> "%copysrc_batfile_path%"
echo call :wav_decode_audio_phase  %%aac_audio_source%%>> "%copysrc_batfile_path%"
echo call :ext_faw_audio_phase  %%aac_audio_source%%>> "%copysrc_batfile_path%"
echo del %%aac_audio_source%%>> "%copysrc_batfile_path%"
echo if not "%%HD_even_tmp_count%%"=="%%HD_even_count%%" ^(>> "%copysrc_batfile_path%"
echo     set /a HD_even_tmp_count=HD_even_tmp_count+2>> "%copysrc_batfile_path%"
echo     goto :HD_even_retry_loop>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :HD_odd_retry_phase>> "%copysrc_batfile_path%"
echo rem # 奇数番の各ファイルごとにオーディオ処理を繰り返します>> "%copysrc_batfile_path%"
echo set HD_odd_tmp_count=^1>> "%copysrc_batfile_path%"
echo :HD_odd_retry_loop>> "%copysrc_batfile_path%"
echo set type-count=_HD-%%HD_odd_tmp_count%%>> "%copysrc_batfile_path%"
echo call :ext_aac_audio_phase ".\src\video_HD-%%HD_odd_tmp_count%%.ts">> "%copysrc_batfile_path%"
echo call :wav_decode_audio_phase  %%aac_audio_source%%>> "%copysrc_batfile_path%"
echo call :ext_faw_audio_phase  %%aac_audio_source%%>> "%copysrc_batfile_path%"
echo del %%aac_audio_source%%>> "%copysrc_batfile_path%"
echo if not "%%HD_odd_tmp_count%%"=="%%HD_odd_count%%" ^(>> "%copysrc_batfile_path%"
echo     set /a HD_odd_tmp_count=HD_odd_tmp_count+2>> "%copysrc_batfile_path%"
echo     goto :HD_odd_retry_loop>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :ext_aac_audio_phase>> "%copysrc_batfile_path%"
echo echo AAC音声抽出 %%type-count%%...[%%time%%]>> "%copysrc_batfile_path%"
echo set aac_audio_source=>> "%copysrc_batfile_path%"
echo set aac_audio_delay=>> "%copysrc_batfile_path%"
echo if "%%mpeg2dec_select_flag%%"=="1" ^(>> "%copysrc_batfile_path%"
echo     echo # MPEG-2デコーダーに MPEG2 VFAPI Plug-In を使用します>> "%copysrc_batfile_path%"
echo     rem echo "%%ts2aac_path%%" -D -i "%%~1" -o "%%large_tmp_dir%%%%project_name%%">> "%copysrc_batfile_path%"
echo     rem "%%ts2aac_path%%" -D -i "%%~1" -o "%%large_tmp_dir%%%%project_name%%"^>^> ".\log\demuxed-aac_log.log">> "%copysrc_batfile_path%"
echo     echo "%%ts_parser_path%%" --mode da --delay-type 1 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1">> "%copysrc_batfile_path%"
echo     "%%ts_parser_path%%" --mode da --delay-type 1 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1"^>^> ".\log\demuxed-aac_log.log">> "%copysrc_batfile_path%"
echo ^) else if "%%mpeg2dec_select_flag%%"=="2" ^(>> "%copysrc_batfile_path%"
echo     echo # MPEG-2デコーダーに DGIndex を使用します>> "%copysrc_batfile_path%"
echo     echo "%%ts_parser_path%%" --mode da --delay-type 2 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1">> "%copysrc_batfile_path%"
echo     "%%ts_parser_path%%" --mode da --delay-type 2 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1"^>^> ".\log\demuxed-aac_log.log">> "%copysrc_batfile_path%"
echo ^) else if "%%mpeg2dec_select_flag%%"=="3" ^(>> "%copysrc_batfile_path%"
echo     echo # MPEG-2デコーダーに L-SMASH Works を使用します>> "%copysrc_batfile_path%"
echo     echo "%%ts_parser_path%%" --mode da --delay-type 3 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1">> "%copysrc_batfile_path%"
echo     "%%ts_parser_path%%" --mode da --delay-type 3 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1"^>^> ".\log\demuxed-aac_log.log">> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo type ".\log\demuxed-aac_log.log">> "%copysrc_batfile_path%"
echo for /f "delims=" %%^%%A in ^('dir /b "%%large_tmp_dir%%%%project_name%%*DELAY *ms.aac"'^) do ^(>> "%copysrc_batfile_path%"
echo     set aac_audio_source="%%large_tmp_dir%%%%%%A">> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo echo オーディオソース：%%aac_audio_source%%>> "%copysrc_batfile_path%"
echo set aac_audio_delay=%%aac_audio_source%%>> "%copysrc_batfile_path%"
echo set aac_audio_delay=%%aac_audio_delay:^"=%%>> "%copysrc_batfile_path%"
echo set aac_audio_delay=%%aac_audio_delay:*DELAY =%%>> "%copysrc_batfile_path%"
echo set aac_audio_delay=%%aac_audio_delay:ms.aac=%%>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :wav_decode_audio_phase>> "%copysrc_batfile_path%"
echo rem # faadをは-Dでdelay調整が出来る改造版が前提>> "%copysrc_batfile_path%"
echo rem # faadのオプションによって、音声チャンネルが切り替わった場合は複数のファイルが出力されます>> "%copysrc_batfile_path%"
echo echo WAVデコード %%type-count%%...[%%time%%]>> "%copysrc_batfile_path%"
rem # FAAD 改造版 0.4で、DELAYが含まれているとなぜか-oオプションが無視されしまう問題の回避
rem # setコマンド内でアスタリスクが使えるのは、文字列1の先頭のみのようです。
rem # ※参考 http://questionbox.jp.msn.com/qa2638625.html
rem # 2010/11/28 追記
rem # 少なくとも改造版0.6では上記の症状は治っている模様。念のためコメントアウトとして残しておく
rem echo for /f "delims=" %%%%W in ('dir /b "%%large_tmp_dir%%%main_project_name%*DELAY 0ms.wav"') do (>> "%copysrc_batfile_path%"
rem echo     set outputwav_path="%%large_tmp_dir%%%%%%W">> "%copysrc_batfile_path%"
rem echo )>> "%copysrc_batfile_path%"
rem echo if not exist "%%~dp0src\audio_pcm.wav" (>> "%copysrc_batfile_path%"
rem echo     if exist "%%outputwav_path%%" (>> "%copysrc_batfile_path%"
rem echo         move /Y "%%outputwav_path%%" "%%~dp0src\audio_pcm.wav">> "%copysrc_batfile_path%"
rem echo     )>> "%copysrc_batfile_path%"
rem echo )>> "%copysrc_batfile_path%"
if "%kill_longecho_flag%"=="1" (
    rem echo start "FAADデコード中..." /wait "%faad_path%" -d -o ".\src\audio_pcm.wav" "%%~1">> "%copysrc_batfile_path%"
    echo echo FAAD Decoding...>> "%copysrc_batfile_path%"
    echo echo Delay %%aac_audio_delay%%ms>> "%copysrc_batfile_path%"
    echo echo "%%faad_path%%" -S -d -q -D %%aac_audio_delay%% -o ".\src\audio_pcm%%type-count%%.wav" "%%~1">> "%copysrc_batfile_path%"
    echo "%%faad_path%%" -S -d -q -D %%aac_audio_delay%% -o ".\src\audio_pcm%%type-count%%.wav" "%%~1">> "%copysrc_batfile_path%"
) else (
    echo echo "%%faad_path%%" -S -d -D %%aac_audio_delay%% -o ".\src\audio_pcm%%type-count%%.wav" "%%~1">> "%copysrc_batfile_path%"
    echo "%%faad_path%%" -S -d -D %%aac_audio_delay%% -o ".\src\audio_pcm%%type-count%%.wav" "%%~1">> "%copysrc_batfile_path%"
)
echo rem title %%project_name%%>> "%copysrc_batfile_path%"
echo set faad_outfile_counter=^0>> "%copysrc_batfile_path%"
echo echo 出力されたPCMファイルが、音声チャンネルで分割されていないかカウントします>> "%copysrc_batfile_path%"
echo echo 検査対象ファイル： ".\src\audio_pcm[*].wav">> "%copysrc_batfile_path%"
echo for /f "delims=" %%%%T in ^('dir /b ".\src\audio_pcm[*].wav"'^) do ^(>> "%copysrc_batfile_path%"
echo     echo 検出ファイル：%%%%T>> "%copysrc_batfile_path%"
echo     set /a faad_outfile_counter=faad_outfile_counter+1>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo if not "%%faad_outfile_counter%%"=="0" ^(>> "%copysrc_batfile_path%"
echo     echo faadによって出力されたファイルが複数検出されました。>> "%copysrc_batfile_path%"
echo     echo 音声チャンネルの切り替わりが発生しているため元のTSファイルをTsSplitterで分割しなおす必要があります。>> "%copysrc_batfile_path%"
echo     echo PCM音声ファイルを一旦削除>> "%copysrc_batfile_path%"
echo     del ".\src\audio_pcm*.wav">> "%copysrc_batfile_path%"
echo     call :TsSplitter_src_retry_phase>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo 音声チャンネルの切り替わりは検出されませんでした。このまま処理を続行します。>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :ext_faw_audio_phase>> "%copysrc_batfile_path%"
echo echo FAW抽出 %%type-count%%...[%%time%%]>> "%copysrc_batfile_path%"
echo echo "%%FAW_path%%" "%%~1" ".\src\audio_faw%%type-count%%.wav">> "%copysrc_batfile_path%"
echo "%%FAW_path%%" "%%~1" ".\src\audio_faw%%type-count%%.wav">> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :copy_app_detect>> "%copysrc_batfile_path%"
echo for /f "usebackq eol=# tokens=2 delims==" %%%%C in ^(`findstr /b /r copy_app_flag "parameter.txt"`^) do ^(>> "%copysrc_batfile_path%"
echo     if "%%%%C"=="fac" ^(>> "%copysrc_batfile_path%"
echo         set copy_app_flag=fac>> "%copysrc_batfile_path%"
echo     ^) else if "%%%%C"=="ffc" ^(>> "%copysrc_batfile_path%"
echo         set copy_app_flag=ffc>> "%copysrc_batfile_path%"
echo     ^) else if "%%%%C"=="copy" ^(>> "%copysrc_batfile_path%"
echo         set copy_app_flag=copy>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo if "%%copy_app_flag%%"=="" ^(>> "%copysrc_batfile_path%"
echo     echo コピー用アプリのパラメーターが見つかりません、デフォルトのcopyコマンドを使用します。>> "%copysrc_batfile_path%"
echo     set copy_app_flag=copy>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :toolsdircheck>> "%copysrc_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%copysrc_batfile_path%"
echo     echo 環境変数 ENCTOOLSROOTPATH が未定義です>> "%copysrc_batfile_path%"
echo     exit /b>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\>> "%copysrc_batfile_path%"
echo if exist "%%ENCTOOLSROOTPATH%%" ^(>> "%copysrc_batfile_path%"
echo     exit /b>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo 環境変数ENCTOOLSROOTPATHが有効なパスではありません>> "%copysrc_batfile_path%"
echo     set ENCTOOLSROOTPATH=>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :src_file_path_check>> "%copysrc_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%S in ^(`findstr /b /r src_file_path "parameter.txt"`^) do ^(>> "%copysrc_batfile_path%"
echo     set %%%%S>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :src_file_name_extraction>> "%copysrc_batfile_path%"
echo set src_file_name=%%~nx1>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :project_name_check>> "%copysrc_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(>> "%copysrc_batfile_path%"
echo     set %%%%P>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :mpeg2dec_select_flag_check>> "%copysrc_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%M in ^(`findstr /b /r mpeg2dec_select_flag "parameter.txt"`^) do ^(>> "%copysrc_batfile_path%"
echo     set %%%%M>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo if "%%mpeg2dec_select_flag%%"=="" ^(>> "%copysrc_batfile_path%"
echo     echo ※MPEG-2デコーダーの指定が見つかりません, MPEG2 VFAPI Plug-Inを使用します>> "%copysrc_batfile_path%"
echo     set mpeg2dec_select_flag=^1>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :force_src_copy_check>> "%copysrc_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r force_copy_src "parameter.txt"`^) do ^(>> "%copysrc_batfile_path%"
echo     set %%%%P>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :src_media_type_check>> "%copysrc_batfile_path%"
echo if "%%~d1"=="\\" ^(>> "%copysrc_batfile_path%"
echo     echo ソースファイルへのパスがUNCの為、ネットワークドライブとして処理します>> "%copysrc_batfile_path%"
echo     set src_media_type=^3>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     for /f "delims=" %%%%A in ^('cscript //nologo .\bat\media_check.vbs %%~d1'^) do ^(>> "%copysrc_batfile_path%"
echo         set src_media_type=%%%%A>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :set_input_media_to_src>> "%copysrc_batfile_path%"
echo set input_media_path=%%src_file_path%%>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :find_ffc>> "%copysrc_batfile_path%"
echo echo findexe引数："%%~1">> "%copysrc_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%copysrc_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%copysrc_batfile_path%"
echo     echo 探索しています...>> "%copysrc_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%copysrc_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%copysrc_batfile_path%"
echo         echo 見つかりました>> "%copysrc_batfile_path%"
echo         set ffc_path=%%%%~E>> "%copysrc_batfile_path%"
echo         exit /b>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo call :ffc_env_search %%~nx1>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo :ffc_env_search>> "%copysrc_batfile_path%"
echo set ffc_path=%%~$PATH:1>> "%copysrc_batfile_path%"
echo if "%%ffc_path%%"=="" echo FireFileCopyが見つかりません、代わりにコマンドプロンプト標準のcopyコマンドを使用します。>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :find_fac>> "%copysrc_batfile_path%"
echo echo findexe引数："%%~1">> "%copysrc_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%copysrc_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%copysrc_batfile_path%"
echo     echo 探索しています...>> "%copysrc_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%copysrc_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%copysrc_batfile_path%"
echo         echo 見つかりました>> "%copysrc_batfile_path%"
echo         set fac_path=%%%%~E>> "%copysrc_batfile_path%"
echo         exit /b>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo call :fac_env_search %%~nx1>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo :fac_env_search>> "%copysrc_batfile_path%"
echo set fac_path=%%~$PATH:1>> "%copysrc_batfile_path%"
echo if "%%fac_path%%"=="" echo FastCopyが見つかりません、代わりにコマンドプロンプト標準のcopyコマンドを使用します。>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :find_ts2aac>> "%copysrc_batfile_path%"
echo echo findexe引数："%%~1">> "%copysrc_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%copysrc_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%copysrc_batfile_path%"
echo     echo 探索しています...>> "%copysrc_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%copysrc_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%copysrc_batfile_path%"
echo         echo 見つかりました>> "%copysrc_batfile_path%"
echo         set ts2aac_path=%%%%~E>> "%copysrc_batfile_path%"
echo         exit /b>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo call :ts2aac_env_search %%~nx1>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo :ts2aac_env_search>> "%copysrc_batfile_path%"
echo set ts2aac_path=%%~$PATH:1>> "%copysrc_batfile_path%"
echo if "%%ts2aac_path%%"=="" ^(>> "%copysrc_batfile_path%"
echo     echo ts2aacが見つかりません。>> "%copysrc_batfile_path%"
echo     set ts2aac_path=%%~1>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :find_ts_parser>> "%copysrc_batfile_path%"
echo echo findexe引数："%%~1">> "%copysrc_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%copysrc_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%copysrc_batfile_path%"
echo     echo 探索しています...>> "%copysrc_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%copysrc_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%copysrc_batfile_path%"
echo         echo 見つかりました>> "%copysrc_batfile_path%"
echo         set ts_parser_path=%%%%~E>> "%copysrc_batfile_path%"
echo         exit /b>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo call :ts_parser_env_search %%~nx1>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo :ts_parser_env_search>> "%copysrc_batfile_path%"
echo set ts_parser_path=%%~$PATH:1>> "%copysrc_batfile_path%"
echo if "%%ts_parser_path%%"=="" ^(>> "%copysrc_batfile_path%"
echo     echo ts_parserが見つかりません。>> "%copysrc_batfile_path%"
echo     set ts_parser_path=%%~1>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :find_faad>> "%copysrc_batfile_path%"
echo echo findexe引数："%%~1">> "%copysrc_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%copysrc_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%copysrc_batfile_path%"
echo     echo 探索しています...>> "%copysrc_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%copysrc_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%copysrc_batfile_path%"
echo         echo 見つかりました>> "%copysrc_batfile_path%"
echo         set faad_path=%%%%~E>> "%copysrc_batfile_path%"
echo         exit /b>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo call :faad_env_search %%~nx1>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo :faad_env_search>> "%copysrc_batfile_path%"
echo set faad_path=%%~$PATH:1>> "%copysrc_batfile_path%"
echo if "%%faad_path%%"=="" ^(>> "%copysrc_batfile_path%"
echo    echo faadが見つかりません。>> "%copysrc_batfile_path%"
echo     set faad_path=%%~1>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :find_FAW>> "%copysrc_batfile_path%"
echo echo findexe引数："%%~1">> "%copysrc_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%copysrc_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%copysrc_batfile_path%"
echo     echo 探索しています...>> "%copysrc_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%copysrc_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%copysrc_batfile_path%"
echo         echo 見つかりました>> "%copysrc_batfile_path%"
echo         set FAW_path=%%%%~E>> "%copysrc_batfile_path%"
echo         exit /b>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo call :FAW_env_search %%~nx1>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo :FAW_env_search>> "%copysrc_batfile_path%"
echo set FAW_path=%%~$PATH:1>> "%copysrc_batfile_path%"
echo if "%%FAW_path%%"=="" ^(>> "%copysrc_batfile_path%"
echo     echo FAWが見つかりません。>> "%copysrc_batfile_path%"
echo     set FAW_path=%%~1>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :find_TsSplitter>> "%copysrc_batfile_path%"
echo echo findexe引数："%%~1">> "%copysrc_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%copysrc_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%copysrc_batfile_path%"
echo     echo 探索しています...>> "%copysrc_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%copysrc_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%copysrc_batfile_path%"
echo         echo 見つかりました>> "%copysrc_batfile_path%"
echo         set TsSplitter_path=%%%%~E>> "%copysrc_batfile_path%"
echo         exit /b>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo call :TsSplitter_env_search %%~nx1>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo :TsSplitter_env_search>> "%copysrc_batfile_path%"
echo set TsSplitter_path=%%~$PATH:1>> "%copysrc_batfile_path%"
echo if "%%TsSplitter_path%%"=="" ^(>> "%copysrc_batfile_path%"
echo     echo TsSplitterが見つかりません。>> "%copysrc_batfile_path%"
echo     set TsSplitter_path=%%~1>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
exit /b
rem ------------------------------
:splitted_inputmedia_detect
set input_media_path=.\src\video_%split_type%%~x1
if "%mpeg2dec_select_flag%"=="1" (
    set sourceTSfile_name=video_%split_type%%~x1>> "%copysrc_batfile_path%"
) else if "%mpeg2dec_select_flag%"=="2" (
    set sourceTSfile_name=video_%split_type%.d2v>> "%copysrc_batfile_path%"
) else if "%mpeg2dec_select_flag%"=="3" (
    set sourceTSfile_name=video_%split_type%%~x1>> "%copysrc_batfile_path%"
)
exit /b
rem ------------------------------
:nosplit_inputmedia_detect
set input_media_path=.\src\video%~x1
if "%mpeg2dec_select_flag%"=="1" (
    set sourceTSfile_name=video%~x1>> "%copysrc_batfile_path%"
) else if "%mpeg2dec_select_flag%"=="2" (
    set sourceTSfile_name=video.d2v>> "%copysrc_batfile_path%"
) else if "%mpeg2dec_select_flag%"=="3" (
    set sourceTSfile_name=video%~x1>> "%copysrc_batfile_path%"
)
exit /b
rem ------------------------------


:make_d2vfile_phase
rem # DGIndexに読み込ませる為の.d2vファイルを作成する
rem # DGIndexを使用しない場合は当該関数スキップ
if not "%mpeg2dec_select_flag%"=="2" exit /b
type nul > "%d2vgen_batfile_path%"
echo @echo off>> "%d2vgen_batfile_path%"
echo setlocal>> "%d2vgen_batfile_path%"
echo cd /d %%~dp0..\>> "%d2vgen_batfile_path%"
echo.>> "%d2vgen_batfile_path%"
echo echo DGIndexのプロジェクトファイル(.d2v)を作成します[%%time%%]>> "%d2vgen_batfile_path%"
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
exit /b
:d2v_exist_checker
echo if exist "%~dpn1.d2v" ^(>> "%d2vgen_batfile_path%"
echo     echo ！既に同名の.d2vファイルが存在する為、処理をスキップします！>> "%d2vgen_batfile_path%"
echo     exit /b>> "%d2vgen_batfile_path%"
echo ^)>> "%d2vgen_batfile_path%"
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
echo rem # オーディオファイルの編集実行フェーズ>>"%main_bat_file%"
echo call ".\bat\audio_edit.bat">> "%main_bat_file%"
echo.>> "%main_bat_file%"
echo @echo off>> "%audio_edit_batfile_path%"
echo setlocal>> "%audio_edit_batfile_path%"
echo echo start %%~nx0 bat job...>> "%audio_edit_batfile_path%"
echo cd /d %%~dp0..\>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
echo rem # オーディオの処理判定関数呼び出し>> "%audio_edit_batfile_path%"
echo call :audio_job_detect>> "%audio_edit_batfile_path%"
echo rem # Audio edit mode[faw^(Default^), sox, nero]>> "%audio_edit_batfile_path%"
echo rem audio_job_flag=faw>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
echo rem # %%large_tmp_dir%% の存在確認および末尾チェック>> "%audio_edit_batfile_path%"
echo if not exist "%%large_tmp_dir%%" ^(>> "%audio_edit_batfile_path%"
echo     echo 大きなファイルを出力する一時フォルダ %%%%large_tmp_dir%%%% が存在しません、代わりにシステムのテンポラリフォルダで代用します。>> "%audio_edit_batfile_path%"
echo     set large_tmp_dir=%%tmp%%>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\>> "%audio_edit_batfile_path%"
echo rem # エンコードツールをまとめたディレクトリを示す環境変数ENCTOOLSROOTPATHが定義されているか確認>> "%audio_edit_batfile_path%"
echo call :toolsdircheck>> "%audio_edit_batfile_path%"
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出>> "%audio_edit_batfile_path%"
echo call :project_name_check>> "%audio_edit_batfile_path%"
echo rem # parameterファイル中のオーディオゲインアップ値^(audio_gain^)を検出>> "%audio_edit_batfile_path%"
echo call :audio_gain_check>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
echo rem # 各実行ファイルが存在するか確認。存在しない場合ENCTOOLSROOTPATH内部を探索する、もしくはシステムの探索パスに委ねる>> "%audio_edit_batfile_path%"
echo if exist "%avs2wav_path%" ^(set avs2wav_path=%avs2wav_path%^) else ^(call :find_avs2wav "%avs2wav_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%sox_path%" ^(set sox_path=%sox_path%^) else ^(call :find_sox "%sox_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%neroAacEnc_path%" ^(set neroAacEnc_path=%neroAacEnc_path%^) else ^(call :find_neroAacEnc_path "%neroAacEnc_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%FAW_path%" ^(set FAW_path=%FAW_path%^) else ^(call :find_FAW "%FAW_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%muxer_path%" ^(set muxer_path=%muxer_path%^) else ^(call :find_muxer "%muxer_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%aacgain_path%" ^(set aacgain_path=%aacgain_path%^) else ^(call :find_aacgain "%aacgain_path%"^)>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
echo rem # 各種実行ファイルへのパスが、最終的にどのような値になったか確認。>> "%audio_edit_batfile_path%"
echo echo avs2wav       : %%avs2wav_path%%>> "%audio_edit_batfile_path%"
echo echo sox           : %%sox_path%%>> "%audio_edit_batfile_path%"
echo echo neroAacEnc    : %%neroAacEnc_path%%>> "%audio_edit_batfile_path%"
echo echo FakeAacWav    : %%FAW_path%%>> "%audio_edit_batfile_path%"
echo echo muxer^(L-SMASH^): %%muxer_path%%>> "%audio_edit_batfile_path%"
echo echo AACGain       : %%aacgain_path%%>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
echo rem ※注意※>> "%audio_edit_batfile_path%"
echo rem TSファイルの中には、番組切り替わりなどのタイミングでビデオとオーディオの開始位置が揃わないことがある^(ＴＢＳ局などで発生^)>> "%audio_edit_batfile_path%"
echo rem この場合、TsSplitterのPMT^(ProgramMapTable^)毎に分割することで回避できる場合がある^(-SEP3オプション^)>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
echo :main>> "%audio_edit_batfile_path%"
echo rem //----- main開始 -----//>> "%audio_edit_batfile_path%"
echo title %%project_name%%>> "%audio_edit_batfile_path%"
echo if "%%audio_job_flag%%"=="sox" ^(>> "%audio_edit_batfile_path%"
echo     call :Bilingual_audio_encoding>> "%audio_edit_batfile_path%"
echo ^) else if "%%audio_job_flag%%"=="nero" ^(>> "%audio_edit_batfile_path%"
echo     call :Stereo_audio_encoding>> "%audio_edit_batfile_path%"
echo ^) else if "%%audio_job_flag%%"=="faw" ^(>> "%audio_edit_batfile_path%"
echo     call :FAW_audio_encoding>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo title コマンド プロンプト>> "%audio_edit_batfile_path%"
echo rem //----- main終了 -----//>> "%audio_edit_batfile_path%"
echo echo end %%~nx0 bat job...>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :Bilingual_audio_encoding>> "%audio_edit_batfile_path%"
echo rem # 二ヶ国語音声の場合のエンコード処理、soxを使って左右のチャンネルを分割する>> "%audio_edit_batfile_path%"
echo echo sox を使用>> "%audio_edit_batfile_path%"
echo echo avs2wavで編集中. . .[%%time%%]>> "%audio_edit_batfile_path%"
echo rem # avs2wavはバージョンによってはインプットファイルに相対パスを指定するとエラーで停止するので、一時的にディレクトリを変更します>> "%audio_edit_batfile_path%"
echo pushd avs>> "%audio_edit_batfile_path%"
echo "%%avs2wav_path%%" "audio_export_pcm.avs" "%%large_tmp_dir%%%%project_name%%.wav"^>nul>> "%audio_edit_batfile_path%"
echo popd>> "%audio_edit_batfile_path%"
echo echo 二ヶ国語音声の編集中. . .[%%time%%]>> "%audio_edit_batfile_path%"
echo "%%sox_path%%" "%%large_tmp_dir%%%%project_name%%.wav" -c 1 "%%large_tmp_dir%%%%project_name%%_left.wav" mixer -l>> "%audio_edit_batfile_path%"
echo "%%sox_path%%" "%%large_tmp_dir%%%%project_name%%.wav" -c 1 "%%large_tmp_dir%%%%project_name%%_right.wav" mixer -r>> "%audio_edit_batfile_path%"
echo "%%neroAacEnc_path%%" -q 0.40 -if "%%large_tmp_dir%%%%project_name%%_left.wav" -of ".\tmp\main_left.m4a">> "%audio_edit_batfile_path%"
echo "%%neroAacEnc_path%%" -q 0.40 -if "%%large_tmp_dir%%%%project_name%%_right.wav" -of ".\tmp\main_right.m4a">> "%audio_edit_batfile_path%"
echo call :AACGain_phase ".\tmp\main_left.m4a">> "%audio_edit_batfile_path%"
echo call :AACGain_phase ".\tmp\main_right.m4a">> "%audio_edit_batfile_path%"
echo del "%%large_tmp_dir%%%%project_name%%.wav">> "%audio_edit_batfile_path%"
echo del "%%large_tmp_dir%%%%project_name%%_left.wav">> "%audio_edit_batfile_path%"
echo del "%%large_tmp_dir%%%%project_name%%_right.wav">> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :Stereo_audio_encoding>> "%audio_edit_batfile_path%"
echo rem # ステレオ音声として再エンコードする場合の処理>> "%audio_edit_batfile_path%"
echo echo neroAacEnc を使用>> "%audio_edit_batfile_path%"
echo echo avs2wavで編集中. . .[%%time%%]>> "%audio_edit_batfile_path%"
echo rem # avs2wavはバージョンによってはインプットファイルに相対パスを指定するとエラーで停止するので、一時的にディレクトリを変更します>> "%audio_edit_batfile_path%"
echo pushd avs>> "%audio_edit_batfile_path%"
echo "%%avs2wav_path%%" "audio_export_pcm.avs" "%%large_tmp_dir%%%%project_name%%.wav"^>nul>> "%audio_edit_batfile_path%"
echo popd>> "%audio_edit_batfile_path%"
echo echo neroAacEncでエンコード中. . .[%%time%%]>> "%audio_edit_batfile_path%"
echo "%%neroAacEnc_path%%" -q 0.40 -if "%%large_tmp_dir%%%%project_name%%.wav" -of ".\tmp\main_audio.m4a">> "%audio_edit_batfile_path%"
echo call :AACGain_phase ".\tmp\main_audio.m4a">> "%audio_edit_batfile_path%"
echo del "%%large_tmp_dir%%%%project_name%%.wav">> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :FAW_audio_encoding>> "%audio_edit_batfile_path%"
echo rem # FAWを使用してカットのみの処理>> "%audio_edit_batfile_path%"
echo echo FakeAacWav を使用>> "%audio_edit_batfile_path%"
echo echo avs2wavで編集中. . .[%%time%%]>> "%audio_edit_batfile_path%"
echo rem # avs2wavはバージョンによってはインプットファイルに相対パスを指定するとエラーで停止するので、一時的にディレクトリを変更します>> "%audio_edit_batfile_path%"
echo pushd avs>> "%audio_edit_batfile_path%"
echo echo avs2wavは出力先フォルダの指定方法次第で不正終了することがあるので注意>> "%audio_edit_batfile_path%"
echo "%%avs2wav_path%%" "audio_export_faw.avs" "%%large_tmp_dir%%%%project_name%%_aac_edit.wav"^>nul>> "%audio_edit_batfile_path%"
echo popd>> "%audio_edit_batfile_path%"
echo "%%FAW_path%%" "%%large_tmp_dir%%%%project_name%%_aac_edit.wav" ".\tmp\main_edit.aac">> "%audio_edit_batfile_path%"
echo echo muxer を使ってm4aコンテナへ統合します>> "%audio_edit_batfile_path%"
echo "%%muxer_path%%" -i ".\tmp\main_edit.aac" -o ".\tmp\main_audio.m4a">> "%audio_edit_batfile_path%"
echo call :AACGain_phase ".\tmp\main_audio.m4a">> "%audio_edit_batfile_path%"
echo del "%%large_tmp_dir%%%%project_name%%_aac_edit.wav">> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :AACGain_phase>> "%audio_edit_batfile_path%"
echo rem # AACGainを使用して音量をアップする処理>> "%audio_edit_batfile_path%"
echo echo AACGainで音量調整. . .[%%time%%]>> "%audio_edit_batfile_path%"
echo echo "%%~1" をオーディオゲインアップします>> "%audio_edit_batfile_path%"
echo if "%%audio_gain%%"=="0" ^(>> "%audio_edit_batfile_path%"
echo     echo オーディオゲインアップ値が0の為、処理をスキップします>> "%audio_edit_batfile_path%"
echo ^) else ^(>> "%audio_edit_batfile_path%"
echo     echo ゲインアップ値は %%audio_gain%% です>> "%audio_edit_batfile_path%"
echo     "%%aacgain_path%%" /g %%audio_gain%% "%%~1">> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :audio_job_detect>> "%audio_edit_batfile_path%"
echo for /f "usebackq eol=# tokens=2 delims==" %%%%A in ^(`findstr /b /r audio_job_flag "parameter.txt"`^) do ^(>> "%audio_edit_batfile_path%"
echo     if "%%%%A"=="faw" ^(>> "%audio_edit_batfile_path%"
echo         set audio_job_flag=faw>> "%audio_edit_batfile_path%"
echo     ^) else if "%%%%A"=="sox" ^(>> "%audio_edit_batfile_path%"
echo         set audio_job_flag=sox>> "%audio_edit_batfile_path%"
echo     ^) else if "%%%%A"=="nero" ^(>> "%audio_edit_batfile_path%"
echo         set audio_job_flag=nero>> "%audio_edit_batfile_path%"
echo     ^)>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo if "%%audio_job_flag%%"=="" ^(>> "%audio_edit_batfile_path%"
echo     echo パラメータファイルの中にオーディオの処理指定が見つかりません。デフォルトのFAWを使用します。>> "%audio_edit_batfile_path%"
echo     set audio_job_flag=faw>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :toolsdircheck>> "%audio_edit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%audio_edit_batfile_path%"
echo     echo 環境変数 ENCTOOLSROOTPATH が未定義です>> "%audio_edit_batfile_path%"
echo     exit /b>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\>> "%audio_edit_batfile_path%"
echo if exist "%%ENCTOOLSROOTPATH%%" ^(>> "%audio_edit_batfile_path%"
echo     exit /b>> "%audio_edit_batfile_path%"
echo ^) else ^(>> "%audio_edit_batfile_path%"
echo     echo 環境変数ENCTOOLSROOTPATHが有効なパスではありません>> "%audio_edit_batfile_path%"
echo     set ENCTOOLSROOTPATH=>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :project_name_check>> "%audio_edit_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(>> "%audio_edit_batfile_path%"
echo     set %%%%P>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :audio_gain_check>> "%audio_edit_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%G in ^(`findstr /b /r audio_gain "parameter.txt"`^) do ^(>> "%audio_edit_batfile_path%"
echo     set %%%%G>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo :gainint_blank_loop>> "%audio_edit_batfile_path%"
echo if "%%audio_gain:~-1%%"==" " ^(>> "%audio_edit_batfile_path%"
echo     set audio_gain=%%audio_gain:~0,-1%%>> "%audio_edit_batfile_path%"
echo     goto :gainint_blank_loop>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo if "%%audio_gain%%"=="" ^(>> "%audio_edit_batfile_path%"
echo     echo パラメーター audio_gain が未定義です。0 を代入します。>> "%audio_edit_batfile_path%"
echo     set audio_gain=^0>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :find_avs2wav>> "%audio_edit_batfile_path%"
echo echo findexe引数："%%~1">> "%audio_edit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%audio_edit_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%audio_edit_batfile_path%"
echo ^) else ^(>> "%audio_edit_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%audio_edit_batfile_path%"
echo     echo 探索しています...>> "%audio_edit_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%audio_edit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%audio_edit_batfile_path%"
echo         echo 見つかりました>> "%audio_edit_batfile_path%"
echo         set avs2wav_path=%%%%~E>> "%audio_edit_batfile_path%"
echo         exit /b>> "%audio_edit_batfile_path%"
echo     ^)>> "%audio_edit_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo call :avs2wav_env_search "%%~nx1">> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo :avs2wav_env_search>> "%audio_edit_batfile_path%"
echo set avs2wav_path=%%~$PATH:1>> "%audio_edit_batfile_path%"
echo if "%%avs2wav_path%%"=="" ^(>> "%audio_edit_batfile_path%"
echo     echo avs2wavが見つかりません>> "%audio_edit_batfile_path%"
echo     set avs2wav_path=%%~1>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :find_sox>> "%audio_edit_batfile_path%"
echo echo findexe引数："%%~1">> "%audio_edit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%audio_edit_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%audio_edit_batfile_path%"
echo ^) else ^(>> "%audio_edit_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%audio_edit_batfile_path%"
echo     echo 探索しています...>> "%audio_edit_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%audio_edit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%audio_edit_batfile_path%"
echo         echo 見つかりました>> "%audio_edit_batfile_path%"
echo         set sox_path=%%%%~E>> "%audio_edit_batfile_path%"
echo         exit /b>> "%audio_edit_batfile_path%"
echo     ^)>> "%audio_edit_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo call :sox_env_search "%%~nx1">> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo :sox_env_search>> "%audio_edit_batfile_path%"
echo set sox_path=%%~$PATH:1>> "%audio_edit_batfile_path%"
echo if "%%sox_path%%"=="" ^(>> "%audio_edit_batfile_path%"
echo     echo soxが見つかりません>> "%audio_edit_batfile_path%"
echo     set sox_path=%%~1>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :find_neroAacEnc>> "%audio_edit_batfile_path%"
echo echo findexe引数："%%~1">> "%audio_edit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%audio_edit_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%audio_edit_batfile_path%"
echo ^) else ^(>> "%audio_edit_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%audio_edit_batfile_path%"
echo     echo 探索しています...>> "%audio_edit_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%audio_edit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%audio_edit_batfile_path%"
echo         echo 見つかりました>> "%audio_edit_batfile_path%"
echo         set neroAacEnc_path=%%%%~E>> "%audio_edit_batfile_path%"
echo         exit /b>> "%audio_edit_batfile_path%"
echo     ^)>> "%audio_edit_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo call :neroAacEnc_env_search "%%~nx1">> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo :neroAacEnc_env_search>> "%audio_edit_batfile_path%"
echo set neroAacEnc_path=%%~$PATH:1>> "%audio_edit_batfile_path%"
echo if "%%neroAacEnc_path%%"=="" ^(>> "%audio_edit_batfile_path%"
echo     echo neroAacEncが見つかりません>> "%audio_edit_batfile_path%"
echo     set neroAacEnc_path=%%~1>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :find_FAW>> "%audio_edit_batfile_path%"
echo echo findexe引数："%%~1">> "%audio_edit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%audio_edit_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%audio_edit_batfile_path%"
echo ^) else ^(>> "%audio_edit_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%audio_edit_batfile_path%"
echo     echo 探索しています...>> "%audio_edit_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%audio_edit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%audio_edit_batfile_path%"
echo         echo 見つかりました>> "%audio_edit_batfile_path%"
echo         set FAW_path=%%%%~E>> "%audio_edit_batfile_path%"
echo         exit /b>> "%audio_edit_batfile_path%"
echo     ^)>> "%audio_edit_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo call :FAW_env_search "%%~nx1">> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo :FAW_env_search>> "%audio_edit_batfile_path%"
echo set FAW_path=%%~$PATH:1>> "%audio_edit_batfile_path%"
echo if "%%FAW_path%%"=="" ^(>> "%audio_edit_batfile_path%"
echo     echo FakeAacWav^(FAW^)が見つかりません>> "%audio_edit_batfile_path%"
echo     set FAW_path=%%~1>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :find_muxer>> "%audio_edit_batfile_path%"
echo echo findexe引数："%%~1">> "%audio_edit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%audio_edit_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%audio_edit_batfile_path%"
echo ^) else ^(>> "%audio_edit_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%audio_edit_batfile_path%"
echo     echo 探索しています...>> "%audio_edit_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%audio_edit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%audio_edit_batfile_path%"
echo         echo 見つかりました>> "%audio_edit_batfile_path%"
echo         set muxer_path=%%%%~E>> "%audio_edit_batfile_path%"
echo         exit /b>> "%audio_edit_batfile_path%"
echo     ^)>> "%audio_edit_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo call :muxer_env_search %%~nx1>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo :muxer_env_search>> "%audio_edit_batfile_path%"
echo set muxer_path=%%~$PATH:1>> "%audio_edit_batfile_path%"
echo if "%%muxer_path%%"=="" ^(>> "%audio_edit_batfile_path%"
echo     echo muxerが見つかりません>> "%audio_edit_batfile_path%"
echo     set muxer_path=%%~1>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :find_aacgain>> "%audio_edit_batfile_path%"
echo echo findexe引数："%%~1">> "%audio_edit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%audio_edit_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%audio_edit_batfile_path%"
echo ^) else ^(>> "%audio_edit_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%audio_edit_batfile_path%"
echo     echo 探索しています...>> "%audio_edit_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%audio_edit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%audio_edit_batfile_path%"
echo         echo 見つかりました>> "%audio_edit_batfile_path%"
echo         set aacgain_path=%%%%~E>> "%audio_edit_batfile_path%"
echo         exit /b>> "%audio_edit_batfile_path%"
echo     ^)>> "%audio_edit_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo call :aacgain_env_search "%%~nx1">> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo :aacgain_env_search>> "%audio_edit_batfile_path%"
echo set aacgain_path=%%~$PATH:1>> "%audio_edit_batfile_path%"
echo if "%%aacgain_path%%"=="" ^(>> "%audio_edit_batfile_path%"
echo     echo AACGainが見つかりません>> "%audio_edit_batfile_path%"
echo     set aacgain_path=%%~1>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
exit /b


:last_order
echo echo ### 終了時刻[%%time%%] ###>> "%main_bat_file%"
echo echo.>> "%main_bat_file%"
exit /b

:fix_edts_select
echo rename "%outputmp4_dir%%%project_name%%.mp4" "%%project_name%%_bak.mp4">> "%audio_edit_batfile_path%"
echo "%ffmpeg_path%" -i "%outputmp4_dir%%%project_name%%_bak.mp4" -vcodec copy -acodec copy -f mp4 "%outputmp4_dir%%%project_name%%.mp4" ^&^& del "%outputmp4_dir%%%project_name%%_bak.mp4">> "%audio_edit_batfile_path%"
exit /b


:mux_option_selector
rem # MP4コンテナへのmuxと最終フォルダへの移動工程
rem # フレームレートオプションを決定
if "%deinterlace_filter_flag%"=="24fps" (
    set video_track_fps_opt=?fps=24000/1001
) else if "%deinterlace_filter_flag%"=="30fps" (
    set video_track_fps_opt=?fps=30000/1001
) else (
    set video_track_fps_opt=
)
echo rem # 各トラックのMUXと最終フォルダへの移動フェーズ>>"%main_bat_file%"
echo call ".\bat\mux_tracks.bat">>"%main_bat_file%"
echo.>>"%main_bat_file%"
type nul > "%muxtracks_batfile_path%"
echo @echo off>> "%muxtracks_batfile_path%"
echo setlocal>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo echo start %%~nx0 bat job...>>"%muxtracks_batfile_path%"
echo echo 各種トラック情報等の統合. . .[%%time%%]>>"%muxtracks_batfile_path%"
echo chdir /d %%~dp0..\>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
echo rem # 使用するコピーアプリケーションを選択します>> "%muxtracks_batfile_path%"
echo call :copy_app_detect>> "%muxtracks_batfile_path%"
echo rem copy^(Default^), fac^(FastCopy^), ffc^(FireFileCopy^)>> "%muxtracks_batfile_path%"
echo rem set copy_app_flag=%copy_app_flag%>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # 最終出力先フォルダを検出>> "%muxtracks_batfile_path%"
echo call :out_dir_detect>> "%muxtracks_batfile_path%"
echo rem set final_out_dir=%%HOMEDRIVE%%\%%HOMEPATH%%>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # 使用するビデオエンコードコーデックタイプに応じて拡張子を判定する関数を呼び出します>> "%muxtracks_batfile_path%"
echo call :video_extparam_detect>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # 使用するオーディオ処理を判定する関数を呼び出します>> "%muxtracks_batfile_path%"
echo call :audio_job_detect>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # エンコードツールをまとめたディレクトリを示す環境変数ENCTOOLSROOTPATHが定義されているか確認>> "%muxtracks_batfile_path%"
echo call :toolsdircheck>> "%muxtracks_batfile_path%"
echo rem # parameterファイル中のソースファイルへのフルパス^(src_file_path^)を検出>> "%muxtracks_batfile_path%"
echo call :src_file_path_check>> "%muxtracks_batfile_path%"
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出>> "%muxtracks_batfile_path%"
echo call :project_name_check>> "%muxtracks_batfile_path%"
echo rem # 移動先のサブフォルダ^(sub_folder_name^)をソースファイルの親ディレクトリ名を元に決定>> "%muxtracks_batfile_path%"
echo call :sub_folder_name_detec "%%src_file_path%%">> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # 各実行ファイルが存在するか確認。存在しない場合ENCTOOLSROOTPATH内部を探索する、もしくはシステムの探索パスに委ねる>> "%muxtracks_batfile_path%"
echo rem # それでも見つからない場合、コマンドプロンプト標準のcopyコマンドを使用する>> "%muxtracks_batfile_path%"
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
echo.>> "%muxtracks_batfile_path%"
echo rem # 各種実行ファイルへのパスが、最終的にどのような値になったか確認。>> "%muxtracks_batfile_path%"
echo echo muxer^(L-SMASH^)         : %%muxer_path%%>> "%muxtracks_batfile_path%"
echo echo timelineeditor^(L-SMASH^): %%timelineeditor_path%%>> "%muxtracks_batfile_path%"
echo echo DtsEdit                : %%DtsEdit_path%%>> "%muxtracks_batfile_path%"
echo echo mp4box                 : %%mp4box_path%%>> "%muxtracks_batfile_path%"
echo echo mp4chaps               : %%mp4chaps_path%%>> "%muxtracks_batfile_path%"
echo echo nkf                    : %%nkf_path%%>> "%muxtracks_batfile_path%"
echo echo tsrenamec              : %%tsrenamec_path%%>> "%muxtracks_batfile_path%"
echo echo AtomicParsley          : %%AtomicParsley_path%%>> "%muxtracks_batfile_path%"
echo echo FireFileCopy           : %%ffc_path%%>> "%muxtracks_batfile_path%"
echo echo FastCopy               : %%fac_path%%>> "%muxtracks_batfile_path%"
echo echo.>> "%muxtracks_batfile_path%"
echo echo プロジェクト名         ： %%project_name%%>> "%muxtracks_batfile_path%"
echo echo サブフォルダ名         ： %%sub_folder_name%%>> "%muxtracks_batfile_path%"
echo rem ※注意点※>> "%muxtracks_batfile_path%"
echo rem mp4boxは日本語文字列の取り扱いが下手かつ標準出力もUTF-8なので、事前に半角英数にリネームしてから処理する事。>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo :main>> "%muxtracks_batfile_path%"
echo rem //----- main開始 -----//>> "%muxtracks_batfile_path%"
echo title %%project_name%%>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # MUX対象のファイルが存在するか、正常かどうか確認>> "%muxtracks_batfile_path%"
echo set tmp-file_error_flag=^0>> "%muxtracks_batfile_path%"
echo if exist ".\tmp\main_temp%%video_ext_type%%" ^(>> "%muxtracks_batfile_path%"
echo     call :zero-byte_error_check ".\tmp\main_temp%%video_ext_type%%">> "%muxtracks_batfile_path%"
echo ^) else ^(>> "%muxtracks_batfile_path%"
echo     echo ※"main_temp%%video_ext_type%%" ファイルが存在しません>> "%muxtracks_batfile_path%"
echo     set tmp-file_error_flag=^1>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo if "%%audio_job_flag%%"=="sox" ^(>> "%muxtracks_batfile_path%"
echo     if exist ".\tmp\main_left.m4a" ^(>> "%muxtracks_batfile_path%"
echo         call :zero-byte_error_check ".\tmp\main_left.m4a">> "%muxtracks_batfile_path%"
echo     ^) else ^(>> "%muxtracks_batfile_path%"
echo         echo ※"main_left.m4a" ファイルが存在しません>> "%muxtracks_batfile_path%"
echo         set tmp-file_error_flag=^1>> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo     if exist ".\tmp\main_right.m4a" ^(>> "%muxtracks_batfile_path%"
echo         call :zero-byte_error_check ".\tmp\main_right.m4a">> "%muxtracks_batfile_path%"
echo     ^) else ^(>> "%muxtracks_batfile_path%"
echo         echo ※"main_right.m4a" ファイルが存在しません>> "%muxtracks_batfile_path%"
echo         set tmp-file_error_flag=^1>> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^) else if "%%audio_job_flag%%"=="nero" ^(>> "%muxtracks_batfile_path%"
echo     if exist ".\tmp\main_audio.m4a" ^(>> "%muxtracks_batfile_path%"
echo         call :zero-byte_error_check ".\tmp\main_audio.m4a">> "%muxtracks_batfile_path%"
echo     ^) else ^(>> "%muxtracks_batfile_path%"
echo         echo ※"main_audio.m4a" ファイルが存在しません>> "%muxtracks_batfile_path%"
echo         set tmp-file_error_flag=^1>> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^) else ^(>> "%muxtracks_batfile_path%"
echo     if exist ".\tmp\main_audio.m4a" ^(>> "%muxtracks_batfile_path%"
echo         call :zero-byte_error_check ".\tmp\main_audio.m4a">> "%muxtracks_batfile_path%"
echo     ^) else ^(>> "%muxtracks_batfile_path%"
echo         echo ※".\tmp\main_audio.m4a" ファイルが存在しません>> "%muxtracks_batfile_path%"
echo         set tmp-file_error_flag=^1>> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo if "%%tmp-file_error_flag%%"=="1" ^(>> "%muxtracks_batfile_path%"
echo     echo ※MUX対象ファイルに何らかの異常があるため、MUX処理を中断します。>> "%muxtracks_batfile_path%"
echo     echo end %%~nx0 bat job...>> "%muxtracks_batfile_path%"
echo     exit /b>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # 映像と音声をMUX>> "%muxtracks_batfile_path%"
echo echo L-SMASHで映像と音声を統合します>> "%muxtracks_batfile_path%"
echo rem # L-SMASHの-chapterオプションはogg形式チャプターファイルを読み込めない為使用しません。代わりにmp4chapsを使用します。>> "%muxtracks_batfile_path%"
echo rem # --file-format にmovを併用すると挙動が不安定になるため非推奨>> "%muxtracks_batfile_path%"
echo if "%%audio_job_flag%%"=="sox" ^(>> "%muxtracks_batfile_path%"
echo     echo 二か国語音声を個別のモノラル音声としてMUXします[%%time%%]>> "%muxtracks_batfile_path%"
echo     "%%muxer_path%%" -i ".\tmp\main_temp%%video_ext_type%%"%video_track_fps_opt% -i ".\tmp\main_left.m4a"?language=jpn,group=2 -i ".\tmp\main_right.m4a"?disable,language=eng,group=2 --optimize-pd --file-format mp4 --isom-version 6 -o "%%project_name%%.mp4">> "%muxtracks_batfile_path%"
echo ^) else if "%%audio_job_flag%%"=="nero" ^(>> "%muxtracks_batfile_path%"
echo     echo 再エンコードしたステレオAAC音声をMUXします[%%time%%]>> "%muxtracks_batfile_path%"
echo     "%%muxer_path%%" -i ".\tmp\main_temp%%video_ext_type%%"%video_track_fps_opt% -i ".\tmp\main_audio.m4a"?language=jpn --optimize-pd --file-format mp4 --isom-version 6 -o "%%project_name%%.mp4">> "%muxtracks_batfile_path%"
echo ^) else ^(>> "%muxtracks_batfile_path%"
echo     echo ソースを無劣化編集したFAW音声をMUXします[%%time%%]>> "%muxtracks_batfile_path%"
echo     "%%muxer_path%%" -i ".\tmp\main_temp%%video_ext_type%%"%video_track_fps_opt% -i ".\tmp\main_audio.m4a"?language=jpn --optimize-pd --file-format mp4 --isom-version 6 -o "%%project_name%%.mp4">> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # タイムコードファイルが存在する場合、timelineeditorを使ってタイムコード埋め込みします>> "%muxtracks_batfile_path%"
echo if exist ".\tmp\main.tmc" ^(>> "%muxtracks_batfile_path%"
echo     rename "%%project_name%%.mp4" "%%project_name%%_raw.mp4">> "%muxtracks_batfile_path%"
echo     rem # DtsEditはH.265/HEVC非対応>> "%muxtracks_batfile_path%"
echo     rem # timelineeditorは--media-timescaleオプションを使用しないとQuickTimeで再生できないファイルが出力される^(QuickTime Player v7.7.9で確認^)>> "%muxtracks_batfile_path%"
echo     rem # timelineeditor^(rev1450^)は、MPC-BE ver1.5.0^(build 2235^)内蔵のMP4/MOVスプリッターで不正終了、QTも再生不能の為非推奨^(rev1432迄なら問題なし^)>> "%muxtracks_batfile_path%"
echo     rem # DtsEditでmuxしたファイルはPS4で再生ピッチがおかしくなるので一律timelineeditorに切り替え>> "%muxtracks_batfile_path%"
echo     if "%%video_ext_type%%"==".265" ^(>> "%muxtracks_batfile_path%"
echo         echo タイムコードファイルを発見したため、timelineeditorで統合します>> "%muxtracks_batfile_path%"
echo         "%%timelineeditor_path%%" --timecode ".\tmp\main.tmc" --media-timescale 24000 "%%project_name%%_raw.mp4" "%%project_name%%.mp4">> "%muxtracks_batfile_path%"
echo         rem "%%DtsEdit_path%%" -no-dc -s 24000 -tv 2 -tc ".\tmp\main.tmc" -o "%%project_name%%.mp4" "%%project_name%%_raw.mp4">> "%muxtracks_batfile_path%"
echo     ^) else if "%%video_ext_type%%"==".264" ^(>> "%muxtracks_batfile_path%"
echo         echo タイムコードファイルを発見したため、timelineeditorで統合します>> "%muxtracks_batfile_path%"
echo         "%%timelineeditor_path%%" --timecode ".\tmp\main.tmc" --media-timescale 24000 "%%project_name%%_raw.mp4" "%%project_name%%.mp4">> "%muxtracks_batfile_path%"
echo         rem echo タイムコードファイルを発見したため、DtsEditで統合します>> "%muxtracks_batfile_path%"
echo         rem "%%DtsEdit_path%%" -no-dc -s 24000 -tv 2 -tc ".\tmp\main.tmc" -o "%%project_name%%.mp4" "%%project_name%%_raw.mp4">> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo     del "%%project_name%%_raw.mp4">>"%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # マニュアル24fpsプラグインで作成された.*.chapter.txtファイルが存在する場合リネームします>> "%muxtracks_batfile_path%"
echo if exist "*.chapter.txt" ^(>> "%muxtracks_batfile_path%"
echo     echo マニュアル24fpsプラグイン形式のチャプターファイルを発見したため、形式を変換します>> "%muxtracks_batfile_path%"
echo     for /f "delims=" %%%%N in ^('dir /b "*.chapter.txt"'^) do ^(>> "%muxtracks_batfile_path%"
echo         rename "%%%%N" "%%project_name%%_sjis.chapters.txt">> "%muxtracks_batfile_path%"
echo         "%%nkf_path%%" -w "%%project_name%%_sjis.chapters.txt"^> "%%project_name%%.chapters.txt">> "%muxtracks_batfile_path%"
echo         del "%%project_name%%_sjis.chapters.txt">> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # チャプターを結合するフェース。mp4chapsの仕様上、MP4ファイルと同じディレクトリに>> "%muxtracks_batfile_path%"
echo rem # "インポート先MP4ファイル名.chapters.txt"の命名規則で、OGG形式のチャプターファイルを配置する必要があります。>> "%muxtracks_batfile_path%"
echo rem # QT形式のチャプターは拡張子が.m4vでなければQuickTime Playerで認識できませんが、iTunesであれば.mp4でも使用できます。>>"%muxtracks_batfile_path%"
echo rem # QuickTime Player^(version 7.7.9^)とiTunes^(12.4.1.6^)で確認>>"%muxtracks_batfile_path%"
echo rem オプション： -A QTとNeroのハイブリッド / -Q QT形式 / -N Nero形式>>"%muxtracks_batfile_path%"
echo if exist "%%project_name%%.chapters.txt" ^(>> "%muxtracks_batfile_path%"
echo     echo チャプターファイルを発見したため、mp4chapsで統合します>> "%muxtracks_batfile_path%"
echo     "%%mp4chaps_path%%" -i -Q "%%project_name%%.mp4">> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # 字幕ファイルが存在するかチェック、あった場合それをmuxの工程に組み込みます>>"%muxtracks_batfile_path%"
echo rem # L-SMASHは字幕のMUXが未実装の為、mp4box(version 0.6.2以上推奨)を使用します>>"%muxtracks_batfile_path%"
echo if exist ".\tmp\main.srt" ^(>>"%muxtracks_batfile_path%"
echo     echo 字幕あり、mp4boxで統合します>>"%muxtracks_batfile_path%"
echo     rename "%%project_name%%.mp4" "main_raw.mp4">> "%muxtracks_batfile_path%"
echo     rem # Identifierが"sbtl:tx3g"の場合Appleフォーマット、"text:tx3g"の場合3GPP/MPEGアライアンスフォーマット>> "%muxtracks_batfile_path%"
echo     rem https://gpac.wp.mines-telecom.fr/2014/09/04/subtitling-with-gpac/>> "%muxtracks_batfile_path%"
echo     rem "%%mp4box_path%%" -add "main_raw.mp4"  -add ".\tmp\main.srt":lang=jpn:group=3:hdlr="sbtl:tx3g":layout=0x60x0x-1 -add "main.srt":disable:lang=jpn:group=3:hdlr="text:tx3g":layout=0x60x0x-1 "mp4box_out.mp4">> "%muxtracks_batfile_path%"
echo     "%%mp4box_path%%" -add "main_raw.mp4" -add ".\tmp\main.srt":lang=jpn:group=3:hdlr="sbtl:tx3g":layout=0x60x0x-1 "mp4box_out.mp4">> "%muxtracks_batfile_path%"
echo     if exist "mp4box_out.mp4" ^(>> "%muxtracks_batfile_path%"
echo         echo 字幕の統合が成功しました。>> "%muxtracks_batfile_path%"
echo         rename "mp4box_out.mp4" "%%project_name%%.mp4">> "%muxtracks_batfile_path%"
echo         del "main_raw.mp4">> "%muxtracks_batfile_path%"
echo     ^) else ^(>> "%muxtracks_batfile_path%"
echo         echo 字幕の統合に失敗した模様です。統合前のファイルをオリジナルとして使います。>> "%muxtracks_batfile_path%"
echo         rename "main_raw.mp4" "%%project_name%%.mp4">> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo 字幕なし>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem # 番組情報を抽出し、CSVファイルを経由してMP4ファイルに埋め込む作業。ソースがTSファイルの場合のみ有効
rem # 大文字かっこ（）を正規表現で話数として扱うと、番組によっては説明書きとして使われる場合もあるため問題
rem echo "%tsrenamec_path%" "%input_media_path%" "@NT1'\[二\]'@NT2'\[字\]'@C'\[新\]'@C'\[終\]'@C'＜新＞'@C'＜終＞'@C'\[二\]'@C'\[字\]'@C'\[デ\]'@NT3'(#|＃.+)'@NT4'（.+）'@C' |　*＃.+'@C' |　*#.+'@C'（.+）'@MST@TT,@sb,@PT3@PT4,@YY,@PT1@PT2@YY年@MM月@DD日,@CH,"^> "%%~dp0main.csv">> "%muxtracks_batfile_path%"
rem # @C'（.+）'を使用すると、「」内に（）が含まれているとおかしくなる模様。よって暫定的に排除。(2010/12/28)
rem echo "%tsrenamec_path%" "%input_media_path%" "@NT1'\[二\]'@NT2'\[字\]'@C'\[新\]'@C'\[終\]'@C'＜新＞'@C'＜終＞'@C'\[二\]'@C'\[字\]'@C'\[デ\]'@NT3'(#|＃.+)'@NT4'第.+話'@C' |　*＃.+'@C' |　*#.+'@C'（.+）'@MST@TT,@sb,@PT3@PT4,@YY,@PT1@PT2@YY年@MM月@DD日,@CH,"^> "main.csv">> "%muxtracks_batfile_path%"
echo rem # 番組情報の抽出とMP4ファイルへの統合フェーズ>> "%muxtracks_batfile_path%"
echo if not exist "main.csv" ^(>> "%muxtracks_batfile_path%"
echo     if exist "%input_media_path%" ^(>> "%muxtracks_batfile_path%"
echo         echo tsrenamecでTSファイルから番組情報を抽出します>> "%muxtracks_batfile_path%"
echo         "%%tsrenamec_path%%" "%input_media_path%" "@NT1'\[二\]'@NT2'\[字\]'@C'\[新\]'@C'\[終\]'@C'＜新＞'@C'＜終＞'@C'\[二\]'@C'\[字\]'@C'\[デ\]'@NT3'(#|＃.+)'@NT4'第.+話'@C' |　*＃.+'@C' |　*#.+'@MST@TT,@sb,@PT3@PT4,@YY,@PT1@PT2@YY年@MM月@DD日,@CH,"^> "main.csv">> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
rem echo for /f "USEBACKQ tokens=1,2,3,4,5,6,7 delims=," %%%%a in ("main.csv") do (>> "%muxtracks_batfile_path%"
rem echo     "%%AtomicParsley_path%%" "%outputmp4_dir%%%project_name%%.mp4" --title "%%%%b" --album "%%%%a" --year "%%%%d" --grouping "%%%%f" --stik "TV Show" --description "%%%%e" --TVNetwork "%%%%f" --TVShowName "%%%%a" --TVEpisode "%%%%c%%%%b" --overWrite>> "%muxtracks_batfile_path%"
rem echo )>> "%muxtracks_batfile_path%"
rem # デリミター","で分割した際に、中身がブランクの要素があると後ろの要素が繰り上がって変数に代入されるためそれを回避するための小技
echo for /f "usebackq delims=" %%%%i in ("main.csv") do (>> "%muxtracks_batfile_path%"
echo     call :atomicparsley_phase %%%%i>> "%muxtracks_batfile_path%"
echo )>> "%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
echo rem # 出力されたファイルを最終出力先フォルダに移動します>> "%muxtracks_batfile_path%"
echo if not "%%final_out_dir:~-1%%"=="\" ^(>> "%muxtracks_batfile_path%"
echo     set final_out_dir=%%final_out_dir%%\>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo if not exist "%%final_out_dir%%%%sub_folder_name%%" ^(>> "%muxtracks_batfile_path%"
echo     mkdir "%%final_out_dir%%%%sub_folder_name%%">> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo echo 最終出力先フォルダにファイルを転送します>> "%muxtracks_batfile_path%"
echo if "%%copy_app_flag%%"=="fac" ^(>> "%muxtracks_batfile_path%"
echo     if exist "%%fac_path%%" ^(>> "%muxtracks_batfile_path%"
echo         echo FastCopy で移動を実行します>> "%muxtracks_batfile_path%"
echo         "%%fac_path%%" /cmd=move /force_close /disk_mode=auto "%%project_name%%.mp4" /to="%%final_out_dir%%%%sub_folder_name%%\">> "%muxtracks_batfile_path%"
echo     ^) else ^(>> "%muxtracks_batfile_path%"
echo         set copy_app_flag=copy>> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^) else if "%%copy_app_flag%%"=="ffc" ^(>> "%muxtracks_batfile_path%"
echo     if exist "%%ffc_path%%" ^(>> "%muxtracks_batfile_path%"
echo         echo FireFileCopy で移動を実行します>> "%muxtracks_batfile_path%"
echo         "%%ffc_path%%" "%%project_name%%.mp4" /move /a /bg /md /nk /ys /to:"%%final_out_dir%%%%sub_folder_name%%\">> "%muxtracks_batfile_path%"
echo     ^) else ^(>> "%muxtracks_batfile_path%"
echo         set copy_app_flag=copy>> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo if "%%copy_app_flag%%"=="copy" ^(>> "%muxtracks_batfile_path%"
echo     echo コマンドプロンプト標準のmoveコマンドで移動を実行します>> "%muxtracks_batfile_path%"
echo     move /Y "%%project_name%%.mp4" "%%final_out_dir%%">> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo rem # 出力先ファイルの存在確認>> "%muxtracks_batfile_path%"
echo if not exist "%%final_out_dir%%%%sub_folder_name%%\%%project_name%%.mp4" ^(>> "%muxtracks_batfile_path%"
echo    echo "%%project_name%%.mp4の出力に失敗しました[%%time%%]"^>^>"%error_log_file%">> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo title コマンド プロンプト>> "%muxtracks_batfile_path%"
echo rem //----- main終了 -----//>> "%muxtracks_batfile_path%"
echo echo end %%~nx0 bat job...>> "%muxtracks_batfile_path%"
echo exit /b>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
rem ------------------------------
echo :video_extparam_detect>> "%muxtracks_batfile_path%"
echo for /f "usebackq eol=# tokens=2 delims==" %%%%E in ^(`findstr /b /r video_encoder_type "parameter.txt"`^) do ^(>> "%muxtracks_batfile_path%"
echo     if "%%%%E"=="x264" ^(>> "%muxtracks_batfile_path%"
echo         set video_ext_type=.264>> "%muxtracks_batfile_path%"
echo     ^) else if "%%%%E"=="x265" ^(>> "%muxtracks_batfile_path%"
echo         set video_ext_type=.265>> "%muxtracks_batfile_path%"
echo     ^) else if "%%%%E"=="qsv_h264" ^(>> "%muxtracks_batfile_path%"
echo         set video_ext_type=.264>> "%muxtracks_batfile_path%"
echo     ^) else if "%%%%E"=="qsv_hevc" ^(>> "%muxtracks_batfile_path%"
echo         set video_ext_type=.265>> "%muxtracks_batfile_path%"
echo     ^) else if "%%%%E"=="nvenc_h264" ^(>> "%muxtracks_batfile_path%"
echo         set video_ext_type=.264>> "%muxtracks_batfile_path%"
echo     ^) else if "%%%%E"=="nvenc_hevc" ^(>> "%muxtracks_batfile_path%"
echo         set video_ext_type=.265>> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo if "%%video_ext_type%%"=="" ^(>> "%muxtracks_batfile_path%"^(>> "%muxtracks_batfile_path%"
echo     echo パラメータファイルの中にビデオエンコードのコーデック指定が見つかりません。暫定措置として、.264を使用します。>> "%muxtracks_batfile_path%"
echo     set video_ext_type=.264>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo exit /b>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
rem ------------------------------
echo :audio_job_detect>> "%muxtracks_batfile_path%"
echo for /f "usebackq eol=# tokens=2 delims==" %%%%A in ^(`findstr /b /r audio_job_flag "parameter.txt"`^) do ^(>> "%muxtracks_batfile_path%"
echo     if "%%%%A"=="faw" ^(>> "%muxtracks_batfile_path%"
echo         set audio_job_flag=faw>> "%muxtracks_batfile_path%"
echo     ^) else if "%%%%A"=="sox" ^(>> "%muxtracks_batfile_path%"
echo         set audio_job_flag=sox>> "%muxtracks_batfile_path%"
echo     ^) else if "%%%%A"=="nero" ^(>> "%muxtracks_batfile_path%"
echo         set audio_job_flag=nero>> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo if "%%audio_job_flag%%"=="" ^(>> "%muxtracks_batfile_path%"
echo     echo パラメータファイルの中にオーディオの処理指定が見つかりません。デフォルトのFAWを使用します。>> "%muxtracks_batfile_path%"
echo     set audio_job_flag=faw>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo exit /b>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
rem ------------------------------
echo :copy_app_detect>> "%muxtracks_batfile_path%"
echo for /f "usebackq eol=# tokens=2 delims==" %%%%C in ^(`findstr /b /r copy_app_flag "parameter.txt"`^) do ^(>> "%muxtracks_batfile_path%"
echo     if "%%%%C"=="fac" ^(>> "%muxtracks_batfile_path%"
echo         set copy_app_flag=fac>> "%muxtracks_batfile_path%"
echo     ^) else if "%%%%C"=="ffc" ^(>> "%muxtracks_batfile_path%"
echo         set copy_app_flag=ffc>> "%muxtracks_batfile_path%"
echo     ^) else if "%%%%C"=="copy" ^(>> "%muxtracks_batfile_path%"
echo         set copy_app_flag=copy>> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo if "%%copy_app_flag%%"=="" ^(>> "%muxtracks_batfile_path%"
echo     echo コピー用アプリのパラメーターが見つかりません、デフォルトのcopyコマンドを使用します。>> "%muxtracks_batfile_path%"
echo     set copy_app_flag=copy>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo exit /b>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
rem ------------------------------
echo :out_dir_detect>> "%muxtracks_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%F in ^(`findstr /b /r out_dir_1st "parameter.txt"`^) do ^(>> "%muxtracks_batfile_path%"
echo     set out_dir_1st=%%%%F>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo if not "%%out_dir_1st%%"=="" ^(>> "%muxtracks_batfile_path%"
echo     set out_dir_1st=%%out_dir_1st:~12%%>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%F in ^(`findstr /b /r out_dir_2nd "parameter.txt"`^) do ^(>> "%muxtracks_batfile_path%"
echo     set out_dir_2nd=%%%%F>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo if not "%%out_dir_2nd%%"=="" ^(>> "%muxtracks_batfile_path%"
echo     set out_dir_2nd=%%out_dir_2nd:~12%%>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo if exist "%%out_dir_1st%%" ^(>> "%muxtracks_batfile_path%"
echo     echo 最終ファイルの出力先：%%out_dir_1st%%>> "%muxtracks_batfile_path%"
echo     set final_out_dir=%%out_dir_1st%%>> "%muxtracks_batfile_path%"
echo ^) else if exist "%%out_dir_2nd%%" ^(>> "%muxtracks_batfile_path%"
echo     echo 最終ファイルの出力先：%%out_dir_2nd%%>> "%muxtracks_batfile_path%"
echo     set final_out_dir=%%out_dir_2nd%%>> "%muxtracks_batfile_path%"
echo ^) else ^(>> "%muxtracks_batfile_path%"
echo     echo 設定されている最終ファイルの出力先ディレクトリが何れも存在しません。>> "%muxtracks_batfile_path%"
echo     echo 代わりにユーザーのホームディレクトリに出力します。>> "%muxtracks_batfile_path%"
echo     set final_out_dir=%%HOMEDRIVE%%\%%HOMEPATH%%>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo exit /b>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
rem ------------------------------
echo :zero-byte_error_check>> "%muxtracks_batfile_path%"
echo for %%%%F in ^("%%~1"^) do set tmp_mux-src_filesize=%%%%~zF>> "%muxtracks_batfile_path%"
echo echo %%~nx1 ファイルサイズ： %%tmp_mux-src_filesize%% byte>> "%muxtracks_batfile_path%"
echo if %%tmp_mux-src_filesize%% EQU 0 (>> "%muxtracks_batfile_path%"
echo     echo ※ゼロバイトファイル発生>> "%muxtracks_batfile_path%"
echo     set tmp-file_error_flag=^1>> "%muxtracks_batfile_path%
echo ^)>> "%muxtracks_batfile_path%"
echo exit /b>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
rem ------------------------------
echo :toolsdircheck>>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo 環境変数 ENCTOOLSROOTPATH が未定義です>>"%muxtracks_batfile_path%"
echo     exit /b>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\>>"%muxtracks_batfile_path%"
echo if exist "%%ENCTOOLSROOTPATH%%" ^(>>"%muxtracks_batfile_path%"
echo     exit /b>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo 環境変数ENCTOOLSROOTPATHが有効なパスではありません>>"%muxtracks_batfile_path%"
echo     set ENCTOOLSROOTPATH=>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :src_file_path_check>>"%muxtracks_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%S in ^(`findstr /b /r src_file_path "parameter.txt"`^) do ^(>>"%muxtracks_batfile_path%"
echo     set %%%%S>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :project_name_check>>"%muxtracks_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(>>"%muxtracks_batfile_path%"
echo     set %%%%P>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :sub_folder_name_detec>>"%muxtracks_batfile_path%"
echo call :src_upper_foldername_detect "%%~dp1.">>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo :src_upper_foldername_detect>>"%muxtracks_batfile_path%"
echo set sub_folder_name=%%~n1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_muxer>>"%muxtracks_batfile_path%"
echo echo findexe引数："%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo 探索しています...>>"%muxtracks_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo 見つかりました>>"%muxtracks_batfile_path%"
echo         set muxer_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :muxer_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo :muxer_env_search>>"%muxtracks_batfile_path%"
echo set muxer_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%muxer_path%%"=="" ^(>>"%muxtracks_batfile_path%"
echo     echo muxerが見つかりません>>"%muxtracks_batfile_path%"
echo     set muxer_path=%%~1>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_timelineeditor>>"%muxtracks_batfile_path%"
echo echo findexe引数："%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo 探索しています...>>"%muxtracks_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo 見つかりました>>"%muxtracks_batfile_path%"
echo         set timelineeditor_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :timelineeditor_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo :timelineeditor_env_search>>"%muxtracks_batfile_path%"
echo set timelineeditor_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%timelineeditor_path%%"=="" ^(>>"%muxtracks_batfile_path%"
echo     echo timelineeditorが見つかりません>>"%muxtracks_batfile_path%"
echo     set timelineeditor_path=%%~1>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_DtsEdit>>"%muxtracks_batfile_path%"
echo echo findexe引数："%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo 探索しています...>>"%muxtracks_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo 見つかりました>>"%muxtracks_batfile_path%"
echo         set DtsEdit_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :DtsEdit_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo :DtsEdit_env_search>>"%muxtracks_batfile_path%"
echo set DtsEdit_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%DtsEdit_path%%"=="" ^(>>"%muxtracks_batfile_path%"
echo     echo DtsEditが見つかりません>>"%muxtracks_batfile_path%"
echo     set DtsEdit_path=%%~1>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_mp4box>>"%muxtracks_batfile_path%"
echo echo findexe引数："%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo 探索しています...>>"%muxtracks_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo 見つかりました>>"%muxtracks_batfile_path%"
echo         set mp4box_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :mp4box_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo :mp4box_env_search>>"%muxtracks_batfile_path%"
echo set mp4box_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%mp4box_path%%"=="" ^(>>"%muxtracks_batfile_path%"
echo     echo mp4boxが見つかりません>>"%muxtracks_batfile_path%"
echo     set mp4box_path=%%~1>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_mp4chaps>>"%muxtracks_batfile_path%"
echo echo findexe引数："%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo 探索しています...>>"%muxtracks_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo 見つかりました>>"%muxtracks_batfile_path%"
echo         set mp4chaps_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :mp4chaps_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo :mp4chaps_env_search>>"%muxtracks_batfile_path%"
echo set mp4chaps_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%mp4chaps_path%%"=="" ^(>>"%muxtracks_batfile_path%"
echo     echo mp4chapsが見つかりません>>"%muxtracks_batfile_path%"
echo     set mp4chaps_path=%%~1>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_nkf>>"%muxtracks_batfile_path%"
echo echo findexe引数："%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo 探索しています...>>"%muxtracks_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo 見つかりました>>"%muxtracks_batfile_path%"
echo         set nkf_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :nkf_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo :nkf_env_search>>"%muxtracks_batfile_path%"
echo set nkf_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%nkf_path%%"=="" ^(>>"%muxtracks_batfile_path%"
echo     echo nkfが見つかりません>>"%muxtracks_batfile_path%"
echo     set nkf_path=%%~1>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_AtomicParsley>>"%muxtracks_batfile_path%"
echo echo findexe引数："%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo 探索しています...>>"%muxtracks_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo 見つかりました>>"%muxtracks_batfile_path%"
echo         set AtomicParsley_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :AtomicParsley_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
echo :AtomicParsley_env_search>>"%muxtracks_batfile_path%"
echo set AtomicParsley_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%AtomicParsley_path%%"=="" ^(>>"%muxtracks_batfile_path%"
echo     echo AtomicParsleyが見つかりません>>"%muxtracks_batfile_path%"
echo     set AtomicParsley_path=%%~1>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_tsrenamec>>"%muxtracks_batfile_path%"
echo echo findexe引数："%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo 探索しています...>>"%muxtracks_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo 見つかりました>>"%muxtracks_batfile_path%"
echo         set tsrenamec_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :tsrenamec_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
echo :tsrenamec_env_search>>"%muxtracks_batfile_path%"
echo set tsrenamec_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%tsrenamec_path%%"=="" ^(>>"%muxtracks_batfile_path%"
echo     echo tsrenamecが見つかりません>>"%muxtracks_batfile_path%"
echo     set tsrenamec_path=%%~1>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_ffc>>"%muxtracks_batfile_path%"
echo echo findexe引数："%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo 探索しています...>>"%muxtracks_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo 見つかりました>>"%muxtracks_batfile_path%"
echo         set ffc_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :ffc_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo :ffc_env_search>>"%muxtracks_batfile_path%"
echo set ffc_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%ffc_path%%"=="" echo FireFileCopyが見つかりません、代わりにコマンドプロンプト標準のcopyコマンドを使用します。>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_fac>>"%muxtracks_batfile_path%"
echo echo findexe引数："%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo 探索しています...>>"%muxtracks_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in ^(%%~nx1^) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo 見つかりました>>"%muxtracks_batfile_path%"
echo         set fac_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :fac_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo :fac_env_search>>"%muxtracks_batfile_path%"
echo set fac_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%fac_path%%"=="" echo FastCopyが見つかりません、代わりにコマンドプロンプト標準のcopyコマンドを使用します。>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :atomicparsley_phase>> "%muxtracks_batfile_path%"
echo rem # AtomicParsley_path用の疑似関数>> "%muxtracks_batfile_path%"
echo set t=%%*>> "%muxtracks_batfile_path%"
echo set t="%%t:,=","%%">> "%muxtracks_batfile_path%"
echo for /f "usebackq tokens=1-6 delims=," %%%%a in (`call echo %%%%t%%%%`) do (>> "%muxtracks_batfile_path%"
echo     echo 番組情報をAtomicParsleyで統合します>> "%muxtracks_batfile_path%"
echo     echo --title "%%%%~b" --album "%%%%~a" --year "%%%%~d" --grouping "%%%%~f" --stik "TV Show" --description "%%%%~e" --TVNetwork "%%%%~f" --TVShowName "%%%%~a" --TVEpisode "%%%%~c%%%%~b" --overWrite>> "%muxtracks_batfile_path%"
echo     "%%AtomicParsley_path%%" "%%project_name%%.mp4" --title "%%%%~b" --album "%%%%~a" --year "%%%%~d" --grouping "%%%%~f" --stik "TV Show" --description "%%%%~e" --TVNetwork "%%%%~f" --TVShowName "%%%%~a" --TVEpisode "%%%%~c%%%%~b" --overWrite>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo exit /b>> "%muxtracks_batfile_path%"
rem ------------------------------
exit /b


:srt_edit
rem # Caption2Ass_mod1で出力されたsrtファイルの文字コードはUTF-8
rem # -tsspオプションが無いとTsSplitterで音声分割されたファイルのタイムコードが正しくならない
rem # -forcepcrはforcePCRモード、オプション無しで実行した際に大きくタイムスタンプがズレる場合のみ使用する
rem # TsSplitterを使用するときのみ-tsspオプションを使用します。
if "%TsSplitter_flag%"=="1" (
    set caption2ass_tssp= -tssp
)
echo rem # デジタル放送の字幕抽出フェーズ>>"%main_bat_file%"
echo call ".\bat\srt_edit.bat">>"%main_bat_file%"
echo.>>"%main_bat_file%"
type nul > "%srtedit_batfile_path%"
echo @echo off>> "%srtedit_batfile_path%"
echo setlocal>> "%srtedit_batfile_path%"
echo echo start %%~nx0 bat job...>> "%srtedit_batfile_path%"
echo chdir /d %%~dp0..\>> "%srtedit_batfile_path%"
echo.>> "%srtedit_batfile_path%"
echo rem # %%large_tmp_dir%% の存在確認および末尾チェック>> "%srtedit_batfile_path%"
echo if not exist "%%large_tmp_dir%%" ^(>> "%srtedit_batfile_path%"
echo     echo 大きなファイルを出力する一時フォルダ %%%%large_tmp_dir%%%% が存在しません、代わりにシステムのテンポラリフォルダで代用します。>> "%srtedit_batfile_path%"
echo     set large_tmp_dir=%%tmp%%>> "%srtedit_batfile_path%"
echo ^)>> "%srtedit_batfile_path%"
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\>> "%srtedit_batfile_path%"
echo rem # エンコードツールをまとめたディレクトリを示す環境変数ENCTOOLSROOTPATHが定義されているか確認>>"%srtedit_batfile_path%"
echo call :toolsdircheck>>"%srtedit_batfile_path%"
echo rem # parameterファイル中のソースファイルへのフルパス^(src_file_path^)を検出>>"%srtedit_batfile_path%"
echo call :src_file_path_check>>"%srtedit_batfile_path%"
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出>>"%srtedit_batfile_path%"
echo call :project_name_check>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
echo rem # 各実行ファイルが存在するか確認。存在しない場合ENCTOOLSROOTPATH内部を探索する、もしくはシステムの探索パスに委ねる>>"%srtedit_batfile_path%"
echo if exist "%caption2Ass_path%" ^(set caption2Ass_path=%caption2Ass_path%^) else ^(call :find_caption2Ass "%caption2Ass_path%"^)>>"%srtedit_batfile_path%"
echo if exist "%SrtSync_path%" ^(set SrtSync_path=%SrtSync_path%^) else ^(call :find_SrtSync "%SrtSync_path%"^)>>"%srtedit_batfile_path%"
echo if exist "%nkf_path%" ^(set nkf_path=%nkf_path%^) else ^(call :find_nkf "%nkf_path%"^)>>"%srtedit_batfile_path%"
echo if exist "%sed_path%" ^(set sed_path=%sed_path%^) else ^(call :find_sed "%sed_path%"^)>>"%srtedit_batfile_path%"
echo if exist "%sedscript_path%" ^(set sedscript_path=%sedscript_path%^) else ^(call :find_sedscript "%sedscript_path%"^)>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
echo rem # 各種実行ファイルへのパスが、最終的にどのような値になったか確認。>>"%srtedit_batfile_path%"
echo echo Caption2Ass: %%caption2Ass_path%%>>"%srtedit_batfile_path%"
echo echo SrtSync    : %%SrtSync_path%%>>"%srtedit_batfile_path%"
echo echo nkf        : %%nkf_path%%>>"%srtedit_batfile_path%"
echo echo Onigsed    : %%sed_path%%>>"%srtedit_batfile_path%"
echo echo sedscript  : %%sedscript_path%%>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
echo :main>>"%srtedit_batfile_path%"
echo rem //----- main開始 -----//>>"%srtedit_batfile_path%"
echo title %%project_name%%>>"%srtedit_batfile_path%"
echo echo デジタル放送の字幕抽出中. . .[%%time%%]>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
echo rem # Caption2Assを使用してTSファイルから字幕を抽出します>>"%srtedit_batfile_path%"
echo set /a caption2Ass_retrycount=^0>>"%srtedit_batfile_path%"
if "%kill_longecho_flag%"=="1" (
    echo if exist "%input_media_path%" ^(>>"%srtedit_batfile_path%"
    echo     echo "%input_media_path%" から抽出します>>"%srtedit_batfile_path%"
    echo     "%%caption2Ass_path%%" -format srt%caption2ass_tssp% "%input_media_path%" "%%large_tmp_dir%%%%project_name%%.srt"^>nul>>"%srtedit_batfile_path%"
    echo ^) else if exist "%%src_file_path%%" ^(>>"%srtedit_batfile_path%"
    echo     echo "%%src_file_path%%" から抽出します>>"%srtedit_batfile_path%"
    echo     "%%caption2Ass_path%%" -format srt%caption2ass_tssp% "%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.srt"^>nul>>"%srtedit_batfile_path%"
    echo ^) else ^(>>"%srtedit_batfile_path%"
    echo     echo ※字幕を抽出するソースとなるTSファイルが見つかりません。処理を中断します。>>"%srtedit_batfile_path%"
    echo     exit /b>>"%srtedit_batfile_path%"
    echo ^)>>"%srtedit_batfile_path%"
) else (
    echo if exist "%input_media_path%" ^(>>"%srtedit_batfile_path%"
    echo     echo "%input_media_path%" から抽出します>>"%srtedit_batfile_path%"
    echo     "%%caption2Ass_path%%" -format srt%caption2ass_tssp% "%input_media_path%" "%%large_tmp_dir%%%%project_name%%.srt">>"%srtedit_batfile_path%"
    echo ^) else if exist "%%src_file_path%%" ^(>>"%srtedit_batfile_path%"
    echo     echo "%%src_file_path%%" から抽出します>>"%srtedit_batfile_path%"
    echo     "%%caption2Ass_path%%" -format srt%caption2ass_tssp% "%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.srt">>"%srtedit_batfile_path%"
    echo ^) else ^(>>"%srtedit_batfile_path%"
    echo     echo ※字幕を抽出するソースとなるTSファイルが見つかりません。処理を中断します。>>"%srtedit_batfile_path%"
    echo     exit /b>>"%srtedit_batfile_path%"
    echo ^)>>"%srtedit_batfile_path%"
)
echo call :Srt_filesize_check>>"%srtedit_batfile_path%"
echo title コマンド プロンプト>>"%srtedit_batfile_path%"
echo rem //----- main終了 -----//>>"%srtedit_batfile_path%"
echo echo end %%~nx0 bat job...>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :toolsdircheck>>"%srtedit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%srtedit_batfile_path%"
echo     echo 環境変数 ENCTOOLSROOTPATH が未定義です>>"%srtedit_batfile_path%"
echo     exit /b>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\>>"%srtedit_batfile_path%"
echo if exist "%%ENCTOOLSROOTPATH%%" ^(>>"%srtedit_batfile_path%"
echo     exit /b>>"%srtedit_batfile_path%"
echo ^) else ^(>>"%srtedit_batfile_path%"
echo     echo 環境変数ENCTOOLSROOTPATHが有効なパスではありません>>"%srtedit_batfile_path%"
echo     set ENCTOOLSROOTPATH=>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :src_file_path_check>>"%srtedit_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%S in ^(`findstr /b /r src_file_path "parameter.txt"`^) do ^(>>"%srtedit_batfile_path%"
echo     set %%%%S>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :project_name_check>>"%srtedit_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(>>"%srtedit_batfile_path%"
echo     set %%%%P>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :find_caption2Ass>>"%srtedit_batfile_path%"
echo echo findexe引数："%%~1">>"%srtedit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%srtedit_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>>"%srtedit_batfile_path%"
echo ^) else ^(>>"%srtedit_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>>"%srtedit_batfile_path%"
echo     echo 探索しています...>>"%srtedit_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>>"%srtedit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%srtedit_batfile_path%"
echo         echo 見つかりました>>"%srtedit_batfile_path%"
echo         set caption2Ass_path=%%%%~E>>"%srtedit_batfile_path%"
echo         exit /b>>"%srtedit_batfile_path%"
echo     ^)>>"%srtedit_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo call :caption2Ass_env_search "%%~nx1">>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo :caption2Ass_env_search>>"%srtedit_batfile_path%"
echo set caption2Ass_path=%%~$PATH:1>>"%srtedit_batfile_path%"
echo if "%%caption2Ass_path%%"=="" ^(>>"%srtedit_batfile_path%"
echo     echo Caption2Assが見つかりません>>"%srtedit_batfile_path%"
echo     set caption2Ass_path=%%~1>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :find_SrtSync>>"%srtedit_batfile_path%"
echo echo findexe引数："%%~1">>"%srtedit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%srtedit_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>>"%srtedit_batfile_path%"
echo ^) else ^(>>"%srtedit_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>>"%srtedit_batfile_path%"
echo     echo 探索しています...>>"%srtedit_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>>"%srtedit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%srtedit_batfile_path%"
echo         echo 見つかりました>>"%srtedit_batfile_path%"
echo         set SrtSync_path=%%%%~E>>"%srtedit_batfile_path%"
echo         exit /b>>"%srtedit_batfile_path%"
echo     ^)>>"%srtedit_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo call :SrtSync_env_search "%%~nx1">>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo :SrtSync_env_search>>"%srtedit_batfile_path%"
echo set SrtSync_path=%%~$PATH:1>>"%srtedit_batfile_path%"
echo if "%%SrtSync_path%%"=="" ^(>>"%srtedit_batfile_path%"
echo     echo SrtSyncが見つかりません>>"%srtedit_batfile_path%"
echo     set SrtSync_path=%%~1>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :find_nkf>>"%srtedit_batfile_path%"
echo echo findexe引数："%%~1">>"%srtedit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%srtedit_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>>"%srtedit_batfile_path%"
echo ^) else ^(>>"%srtedit_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>>"%srtedit_batfile_path%"
echo     echo 探索しています...>>"%srtedit_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>>"%srtedit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%srtedit_batfile_path%"
echo         echo 見つかりました>>"%srtedit_batfile_path%"
echo         set nkf_path=%%%%~E>>"%srtedit_batfile_path%"
echo         exit /b>>"%srtedit_batfile_path%"
echo     ^)>>"%srtedit_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo call :nkf_env_search "%%~nx1">>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo :nkf_env_search>>"%srtedit_batfile_path%"
echo set nkf_path=%%~$PATH:1>>"%srtedit_batfile_path%"
echo if "%%nkf_path%%"=="" ^(>>"%srtedit_batfile_path%"
echo     echo nkfが見つかりません>>"%srtedit_batfile_path%"
echo     set nkf_path=%%~1>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :find_sed>>"%srtedit_batfile_path%"
echo echo findexe引数："%%~1">>"%srtedit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%srtedit_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>>"%srtedit_batfile_path%"
echo ^) else ^(>>"%srtedit_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>>"%srtedit_batfile_path%"
echo     echo 探索しています...>>"%srtedit_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>>"%srtedit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%srtedit_batfile_path%"
echo         echo 見つかりました>>"%srtedit_batfile_path%"
echo         set sed_path=%%%%~E>>"%srtedit_batfile_path%"
echo         exit /b>>"%srtedit_batfile_path%"
echo     ^)>>"%srtedit_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo call :sed_env_search "%%~nx1">>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo :sed_env_search>>"%srtedit_batfile_path%"
echo set sed_path=%%~$PATH:1>>"%srtedit_batfile_path%"
echo if "%%sed_path%%"=="" ^(>>"%srtedit_batfile_path%"
echo     echo Onigsedが見つかりません>>"%srtedit_batfile_path%"
echo     set sed_path=%%~1>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :find_sedscript>>"%srtedit_batfile_path%"
echo echo findexe引数："%%~1">>"%srtedit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%srtedit_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>>"%srtedit_batfile_path%"
echo ^) else ^(>>"%srtedit_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>>"%srtedit_batfile_path%"
echo     echo 探索しています...>>"%srtedit_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>>"%srtedit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%srtedit_batfile_path%"
echo         echo 見つかりました>>"%srtedit_batfile_path%"
echo         set sedscript_path=%%%%~E>>"%srtedit_batfile_path%"
echo         exit /b>>"%srtedit_batfile_path%"
echo     ^)>>"%srtedit_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo call :sedscript_env_search "%%~nx1">>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo :sedscript_env_search>>"%srtedit_batfile_path%"
echo set sedscript_path=%%~$PATH:1>>"%srtedit_batfile_path%"
echo if "%%sedscript_path%%"=="" ^(>>"%srtedit_batfile_path%"
echo     echo sedscriptが見つかりません>>"%srtedit_batfile_path%"
echo     set sedscript_path=%%~1>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :Srt_filesize_check>>"%srtedit_batfile_path%"
echo rem # srtファイルのファイルサイズが3バイト以上であれば字幕が含まれていたと判断します>>"%srtedit_batfile_path%"
echo for %%%%F in ^("%%large_tmp_dir%%%%project_name%%.srt"^) do set srt_filesize=%%%%~zF>>"%srtedit_batfile_path%"
echo if %%srt_filesize%% GTR 3 ^(>>"%srtedit_batfile_path%"
rem # 上記の比較文字列を""でくくると数値ではなく文字列として処理され、下位桁から比較するので問題が出る ex)"10" GTR "3"
echo     call :search_unknown_char>>"%srtedit_batfile_path%"
echo     call :SrtCutter>>"%srtedit_batfile_path%"
echo ^) else ^(>>"%srtedit_batfile_path%"
echo     echo ※字幕はみつかりませんでした※>>"%srtedit_batfile_path%"
echo     del "%%large_tmp_dir%%%%project_name%%.srt">>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :search_unknown_char>> "%srtedit_batfile_path%"
echo rem # 出力されたsrtファイルの中に外字代用字フォントを表す"[外"が含まれていないかチェックします>>"%srtedit_batfile_path%"
rem     # 出力された字幕ファイルの中に未知の外字代用字フォントが無いか探索
rem     # findstrコマンドは、対象がShift_JISでなければ機能しない。/Nで行番号オプション
echo findstr /N "[外" "%%large_tmp_dir%%%%project_name%%.srt"^>^> "%%large_tmp_dir%%%%project_name%%_sub.log">> "%srtedit_batfile_path%"
echo for %%%%F in ^("%%large_tmp_dir%%%%project_name%%_sub.log"^) do set srtlog_filesize=%%%%~zF>> "%srtedit_batfile_path%"
rem     # findstrによって出力されたログが有効(3バイト以上)なら統合、空なら破棄する
echo if %%srtlog_filesize%% GTR 3 ^(>> "%srtedit_batfile_path%"
echo     echo "%%project_name%%"^>^> "%unknown_letter_log%">> "%srtedit_batfile_path%"
echo     copy /b "%unknown_letter_log%" + "%%large_tmp_dir%%%%project_name%%_sub.log" "%unknown_letter_log%">> "%srtedit_batfile_path%"
echo     echo.^>^> "%unknown_letter_log%">> "%srtedit_batfile_path%"
echo     del "%%large_tmp_dir%%%%project_name%%_sub.log">> "%srtedit_batfile_path%"
echo ^) else ^(>> "%srtedit_batfile_path%"
echo     del "%%large_tmp_dir%%%%project_name%%_sub.log">> "%srtedit_batfile_path%"
echo ^)>> "%srtedit_batfile_path%"
echo exit /b>> "%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :SrtCutter>>"%srtedit_batfile_path%"
echo rem # Trim編集された形跡があるかチェック>>"%srtedit_batfile_path%"
rem # SrtSyncで出力されたsrtファイルの文字コードはShift_JIS
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%S in ^(`findstr /r Trim^^^(.*^^^) "trim_line.txt"`^) do ^(>> "%srtedit_batfile_path%"
echo     set search_trimline=%%%%S>> "%srtedit_batfile_path%"
echo ^)>> "%srtedit_batfile_path%"
echo if "%%search_trimline%%"=="" ^(>> "%srtedit_batfile_path%"
echo     echo ※Trim編集なし※>> "%srtedit_batfile_path%"
echo     copy "%%large_tmp_dir%%%%project_name%%.srt" ".\tmp\main_sjis.srt">>"%srtedit_batfile_path%"
echo     move "%%large_tmp_dir%%%%project_name%%.srt" ".\log\exported.srt">>"%srtedit_batfile_path%"
echo ^) else ^(>> "%srtedit_batfile_path%"
echo     call :SubEdit_phase>> "%srtedit_batfile_path%"
echo ^)>> "%srtedit_batfile_path%"
echo if exist ".\tmp\main_sjis.srt" ^(>> "%srtedit_batfile_path%"
echo     "%%nkf_path%%" -w ".\tmp\main_sjis.srt" ^| "%%sed_path%%" -f "%%sedscript_path%%"^> ".\tmp\main.srt">> "%srtedit_batfile_path%"
echo     del ".\tmp\main_sjis.srt">> "%srtedit_batfile_path%"
echo ^)>> "%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :SubEdit_phase>> "%srtedit_batfile_path%"
echo rem # Trimコマンドを読み込んでsrtファイルの必要場所だけカットします>>"%srtedit_batfile_path%"
echo "%%SrtSync_path%%" -mode auto -nopause -trim "trim_line.txt" "%%large_tmp_dir%%%%project_name%%.srt">>"%srtedit_batfile_path%"
echo for %%%%N in ^("%%large_tmp_dir%%%%project_name%%_new.srt"^) do set newsrt_filesize=%%%%~zN>>"%srtedit_batfile_path%"
echo if not %%newsrt_filesize%%==0 ^(>> "%srtedit_batfile_path%"
echo     echo ※指定範囲に字幕あり※>>"%srtedit_batfile_path%"
echo     move "%%large_tmp_dir%%%%project_name%%_new.srt" ".\tmp\main_sjis.srt">>"%srtedit_batfile_path%"
echo     move "%%large_tmp_dir%%%%project_name%%.srt" ".\log\exported.srt">>"%srtedit_batfile_path%"
rem     # ASS字幕を出力する設定が有効になっていた場合のみASSを出力する
rem     # srt字幕の出力が終わり、有効範囲に字幕が存在することが確認されてから出力する
rem     # ただし、現状Trimにあわせたカット編集の手段を持ち合わせていない
if "%output_ass_flag%"=="1" (
    echo     echo ASSファイルを抽出します>>"%srtedit_batfile_path%"
    if "%kill_longecho_flag%"=="1" (
        rem echo     start "字幕の抽出中..." /wait "%%caption2Ass_path%%" -format ass%caption2ass_tssp% "%input_media_path%" "%%large_tmp_dir%%%%project_name%%.ass">>"%srtedit_batfile_path%"
        echo     if %%caption2Ass_retrycount%%==0 ^(>>"%srtedit_batfile_path%"
        echo         "%%caption2Ass_path%%" -format ass%caption2ass_tssp% "%input_media_path%" "%%large_tmp_dir%%%%project_name%%.ass"^>nul>>"%srtedit_batfile_path%"
        echo     ^) else ^(>>"%srtedit_batfile_path%"
        echo         "%%caption2Ass_path%%" -format ass -forcepcr "%input_media_path%" "%%large_tmp_dir%%%%project_name%%.ass"^>nul>>"%srtedit_batfile_path%"
        echo     ^)>>"%srtedit_batfile_path%"
        echo     move "%%large_tmp_dir%%%%project_name%%.ass" ".\tmp\exported.ass">>"%srtedit_batfile_path%"
    ) else (
        echo     "%%caption2Ass_path%%" -format ass%caption2ass_tssp% -silent "%input_media_path%" "%%large_tmp_dir%%%%project_name%%.ass">>"%srtedit_batfile_path%"
        echo     move "%%large_tmp_dir%%%%project_name%%.ass" ".\tmp\main.ass">>"%srtedit_batfile_path%"
    )
)
echo ^) else ^(>> "%srtedit_batfile_path%"
echo     echo ※指定範囲に字幕なし、-forcepcrオプション付きで再度実行します※>> "%srtedit_batfile_path%"
echo     if %%caption2Ass_retrycount%%==0 ^(>>"%srtedit_batfile_path%"
echo         move "%%large_tmp_dir%%%%project_name%%.srt" ".\tmp\exported_noforcepcr.srt">> "%srtedit_batfile_path%"
echo         del "%%large_tmp_dir%%%%project_name%%_new.srt">> "%srtedit_batfile_path%"
echo         call :Re-caption2Ass>> "%srtedit_batfile_path%"
echo     ^) else ^(>>"%srtedit_batfile_path%"
echo         echo 既にCaption2Assでリトライ済みの為、処理を中断します>>"%srtedit_batfile_path%"
echo         move "%%large_tmp_dir%%%%project_name%%.srt" ".\tmp\exported_forcepcr.srt">> "%srtedit_batfile_path%"
echo         del "%%large_tmp_dir%%%%project_name%%_new.srt">> "%srtedit_batfile_path%"
echo     ^)>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :Re-caption2Ass>> "%srtedit_batfile_path%"
echo rem # 稀に出力されたsrtファイル内の時間が大きくズレる事があるので、-forcepcrオプション付きでリトライします>>"%srtedit_batfile_path%"
echo rem # -tsspオプションを-forcepcrオプションと併用するとSrtSyncの出力がNULLになるケースがあるので使用しないこと>>"%srtedit_batfile_path%"
echo "%%caption2Ass_path%%" -format srt -forcepcr "%input_media_path%" "%%large_tmp_dir%%%%project_name%%.srt"^>nul>>"%srtedit_batfile_path%"
echo set /a caption2Ass_retrycount=%caption2Ass_retrycount%+^1>>"%srtedit_batfile_path%"
echo call :SubEdit_phase>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
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
rem # x264/x265によるエンコード設定を書き込む擬似関数
if "%avs_filter_type%"=="1080p_template" (
    set x264_VUI_opt=--videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 
    set x265_VUI_opt=--videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 
    set qsv_VUI_opt=--videoformat ntsc --colormatrix bt709 --colorprim bt709 --transfer bt709 
    set nvenc_VUI_opt=--videoformat ntsc --colormatrix bt709 --colorprim bt709 --transfer bt709 
    if "%deinterlace_filter_flag%"=="Its" (
        if "%vfr_peak_rate%"=="30fps" (
            set x264_Encode_option=%x264_HP@L40_option%
            set x265_Encode_option=%x265_MP@L40_option%
        ) else (
            set x264_Encode_option=%x264_HP@L42_option%
            set x265_Encode_option=%x265_MP@L41_option%
        )
    ) else if "%deinterlace_filter_flag%"=="24fps" (
        set x264_Encode_option=%x264_HP@L40_option%
        set x265_Encode_option=%x265_MP@L40_option%
    ) else if "%deinterlace_filter_flag%"=="30fps" (
        set x264_Encode_option=%x264_HP@L40_option%
        set x265_Encode_option=%x265_MP@L40_option%
    ) else (
        set x264_Encode_option=%x264_HP@L42_option%
        set x265_Encode_option=%x265_MP@L41_option%
    )
) else if "%avs_filter_type%"=="720p_template" (
    set x264_VUI_opt=--videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 
    set x265_VUI_opt=--videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 
    set qsv_VUI_opt=--videoformat ntsc --colormatrix bt709 --colorprim bt709 --transfer bt709 
    set nvenc_VUI_opt=--videoformat ntsc --colormatrix bt709 --colorprim bt709 --transfer bt709 
    if "%deinterlace_filter_flag%"=="Its" (
        if "%vfr_peak_rate%"=="30fps" (
            set x264_Encode_option=%x264_MP@L31_option%
            set x265_Encode_option=%x265_MP@L40_option%
        ) else (
            set x264_Encode_option=%x264_MP@L32_option%
            set x265_Encode_option=%x265_MP@L41_option%
        )
    ) else if "%deinterlace_filter_flag%"=="24fps" (
        set x264_Encode_option=%x264_MP@L31_option%
        set x265_Encode_option=%x265_MP@L40_option%
    ) else if "%deinterlace_filter_flag%"=="30fps" (
        set x264_Encode_option=%x264_MP@L31_option%
        set x265_Encode_option=%x265_MP@L40_option%
    ) else (
        set x264_Encode_option=%x264_MP@L32_option%
        set x265_Encode_option=%x265_MP@L41_option%
    )
) else if "%avs_filter_type%"=="540p_template" (
    set x264_VUI_opt=--videoformat ntsc --colorprim smpte170m --transfer smpte170m --colormatrix smpte170m 
    set x265_VUI_opt=--videoformat ntsc --colorprim smpte170m --transfer smpte170m --colormatrix smpte170m 
    set qsv_VUI_opt=--videoformat ntsc --colormatrix smpte170m --colorprim smpte170m --transfer smpte170m 
    set nvenc_VUI_opt=--videoformat ntsc --colormatrix smpte170m --colorprim smpte170m --transfer smpte170m 
    if "%deinterlace_filter_flag%"=="Its" (
        if "%vfr_peak_rate%"=="30fps" (
            set x264_Encode_option=%x264_MP@L31_option%
            set x265_Encode_option=%x265_MP@L30_option%
        ) else (
            set x264_Encode_option=%x264_MP@L32_option%
            set x265_Encode_option=%x265_MP@L31_option%
        )
    ) else if "%deinterlace_filter_flag%"=="24fps" (
        set x264_Encode_option=%x264_MP@L31_option%
        set x265_Encode_option=%x265_MP@L30_option%
    ) else if "%deinterlace_filter_flag%"=="30fps" (
        set x264_Encode_option=%x264_MP@L31_option%
        set x265_Encode_option=%x265_MP@L30_option%
    ) else (
        set x264_Encode_option=%x264_MP@L32_option%
        set x265_Encode_option=%x265_MP@L31_option%
    )
) else if "%avs_filter_type%"=="480p_template" (
    set x264_VUI_opt=--videoformat ntsc --colorprim smpte170m --transfer smpte170m --colormatrix smpte170m 
    set x265_VUI_opt=--videoformat ntsc --colorprim smpte170m --transfer smpte170m --colormatrix smpte170m 
    set qsv_VUI_opt=--videoformat ntsc --colormatrix smpte170m --colorprim smpte170m --transfer smpte170m 
    set nvenc_VUI_opt=--videoformat ntsc --colormatrix smpte170m --colorprim smpte170m --transfer smpte170m 
    if "%deinterlace_filter_flag%"=="Its" (
        if "%vfr_peak_rate%"=="30fps" (
            set x264_Encode_option=%x264_MP@L30_option%
            set x265_Encode_option=%x265_MP@L30_option%
        ) else (
            set x264_Encode_option=%x264_MP@L31_option%
            set x265_Encode_option=%x265_MP@L31_option%
        )
    ) else if "%deinterlace_filter_flag%"=="24fps" (
        set x264_Encode_option=%x264_MP@L30_option%
        set x265_Encode_option=%x265_MP@L30_option%
    ) else if "%deinterlace_filter_flag%"=="30fps" (
        set x264_Encode_option=%x264_MP@L30_option%
        set x265_Encode_option=%x265_MP@L30_option%
    ) else (
        set x264_Encode_option=%x264_MP@L31_option%
        set x265_Encode_option=%x265_MP@L31_option%
    )
) else if "%avs_filter_type%"=="272p_template" (
    set x264_VUI_opt=--videoformat ntsc --colorprim smpte170m --transfer smpte170m --colormatrix smpte170m 
    set x265_VUI_opt=--videoformat ntsc --colorprim smpte170m --transfer smpte170m --colormatrix smpte170m 
    set qsv_VUI_opt=--videoformat ntsc --colormatrix smpte170m --colorprim smpte170m --transfer smpte170m 
    set nvenc_VUI_opt=--videoformat ntsc --colormatrix smpte170m --colorprim smpte170m --transfer smpte170m 
    set x264_Encode_option=%x264_MP@L21_option%
    set x265_Encode_option=%x265_MP@L30_option%
) else (
    echo ※ プロファイルレベルの指定がありません！ ※
    set x264_VUI_opt=--videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 
    set x265_VUI_opt=--videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 
    set qsv_VUI_opt=--videoformat ntsc --colormatrix bt709 --colorprim bt709 --transfer bt709 
    set nvenc_VUI_opt=--videoformat ntsc --colormatrix bt709 --colorprim bt709 --transfer bt709 
    set x264_Encode_option=%x264_HP@L40_option%
    set x265_Encode_option=%x265_MP@L40_option%
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
echo @echo off>> "%video_encode_batfile_path%"
echo setlocal>> "%video_encode_batfile_path%"
echo echo start %%~nx0 bat job...>> "%video_encode_batfile_path%"
echo cd /d %%~dp0..\>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
echo rem # 使用するエンコーダーのタイプを指定します>> "%video_encode_batfile_path%"
echo call :video_codecparam_detect>> "%video_encode_batfile_path%"
echo rem x264, x265, qsv_h264, qsv_hevc, nvenc_h264, nvenc_hevc>> "%video_encode_batfile_path%"
echo rem set video_encoder_type=%video_encoder_type%>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
echo rem # x264, x265, QSVEncC, NVEncCのエンコードオプションを設定>> "%video_encode_batfile_path%"
echo call :x264_encparam_detect>> "%video_encode_batfile_path%"
echo rem set x264_enc_param=%x264_Encode_option% %video_sar_option%%x264_VUI_opt%%x264_keyint% %x264_interlace_option%>> "%video_encode_batfile_path%"
echo call :x265_encparam_detect>> "%video_encode_batfile_path%"
echo rem set x265_enc_param=%x265_Encode_option% %video_sar_option%%x265_VUI_opt%>> "%video_encode_batfile_path%"
echo call :qsv_encparam_detect>> "%video_encode_batfile_path%"
echo rem set qsv_enc_param=%qsv_Encode_option% %video_sar_option%%qsv_VUI_opt%>> "%video_encode_batfile_path%"
echo call :nvenc_encparam_detect>> "%video_encode_batfile_path%"
echo rem set nvenc_enc_param=%nvenc_Encode_option% %video_sar_option%%nvenc_VUI_opt%>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
echo rem # エンコードツールをまとめたディレクトリを示す環境変数ENCTOOLSROOTPATHが定義されているか確認>> "%video_encode_batfile_path%"
echo call :toolsdircheck>> "%video_encode_batfile_path%"
echo rem # parameterファイル中のプロジェクト名^(project_name^)を検出>> "%video_encode_batfile_path%"
echo call :project_name_check>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
echo rem # 各実行ファイルが存在するか確認。存在しない場合ENCTOOLSROOTPATH内部を探索する、もしくはシステムの探索パスに委ねる>> "%video_encode_batfile_path%"
echo if exist "%x264_path%" ^(set x264_path=%x264_path%^) else ^(call :find_x264 "%x264_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%x265_path%" ^(set x265_path=%x265_path%^) else ^(call :find_x265 "%x265_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%qsvencc_path%" ^(set qsvencc_path=%qsvencc_path%^) else ^(call :find_qsvencc "%qsvencc_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%nvencc_path%" ^(set nvencc_path=%nvencc_path%^) else ^(call :find_qsvencc "%nvencc_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%avs4x26x_path%" ^(set avs4x26x_path=%avs4x26x_path%^) else ^(call :find_avs4x26x "%avs4x26x_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%avs2pipe_path%" ^(set avs2pipe_path=%avs2pipe_path%^) else ^(call :find_avs2pipe "%avs2pipe_path%"^)>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
echo rem # 各種実行ファイルへのパスが、最終的にどのような値になったか確認。>> "%video_encode_batfile_path%"
echo echo x264    : %%x264_path%%>> "%video_encode_batfile_path%"
echo echo x265    : %%x265_path%%>> "%video_encode_batfile_path%"
echo echo QSVEncC : %%qsvencc_path%%>> "%video_encode_batfile_path%"
echo echo NVEncC  : %%nvencc_path%%>> "%video_encode_batfile_path%"
echo echo avs4x26x: %%avs4x26x_path%%>> "%video_encode_batfile_path%"
echo echo avs2pipe: %%avs2pipe_path%%>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
echo rem # エンコードオプション終端補正>> "%video_encode_batfile_path%"
echo if not "%%x264_enc_param:~-1%%"==" " set x264_enc_param=%%x264_enc_param%% >> "%video_encode_batfile_path%"
echo if not "%%x265_enc_param:~-1%%"==" " set x265_enc_param=%%x265_enc_param%% >> "%video_encode_batfile_path%"
echo if not "%%qsv_enc_param:~-1%%"==" " set qsv_enc_param=%%qsv_enc_param%% >> "%video_encode_batfile_path%"
echo if not "%%nvenc_enc_param:~-1%%"==" " set nvenc_enc_param=%%nvenc_enc_param%% >> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
echo :main>> "%video_encode_batfile_path%"
echo rem //----- main開始 -----//>> "%video_encode_batfile_path%"
echo title %%project_name%%>> "%video_encode_batfile_path%"
echo rem # 動画エンコード実行フェーズ>> "%video_encode_batfile_path%"
echo if "%%video_encoder_type%%"=="x264" ^(>> "%video_encode_batfile_path%"
echo     rem %bat_start_wait%"%%avs4x26x_path%%" -L "%%x264_path%%" %x264_Encode_option% %video_sar_option%%x264_VUI_opt%%x264_keyint% %x264_interlace_option%--output ".\tmp\main_temp.264" "main.avs">> "%video_encode_batfile_path%"
echo     call :x264_exec_phase>> "%video_encode_batfile_path%"
echo ^) else if "%%video_encoder_type%%"=="x265" ^(>> "%video_encode_batfile_path%"
echo     rem %bat_start_wait%"%%avs4x26x_path%%" -L "%%x265_path%%" %x265_Encode_option% %video_sar_option%%x265_VUI_opt%-o ".\tmp\main_temp.265" "main.avs">> "%video_encode_batfile_path%"
echo     call :x265_exec_phase>> "%video_encode_batfile_path%"
echo ^) else if "%%video_encoder_type%%"=="qsv_h264" ^(>> "%video_encode_batfile_path%"
echo     call :qsv_h264_func_check>> "%video_encode_batfile_path%"
echo ^) else if "%%video_encoder_type%%"=="qsv_hevc" ^(>> "%video_encode_batfile_path%"
echo     call :qsv_hevc_func_check>> "%video_encode_batfile_path%"
echo ^) else if "%%video_encoder_type%%"=="nvenc_h264" ^(>> "%video_encode_batfile_path%"
echo     call :nvenc_h264_func_check>> "%video_encode_batfile_path%"
echo ^) else if "%%video_encoder_type%%"=="nvenc_hevc" ^(>> "%video_encode_batfile_path%"
echo     call :nvenc_hevc_func_check>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo title コマンド プロンプト>> "%video_encode_batfile_path%"
echo rem //----- main終了 -----//>> "%video_encode_batfile_path%"
echo echo end %%~nx0 bat job...>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :video_codecparam_detect>> "%video_encode_batfile_path%"
echo for /f "usebackq eol=# tokens=2 delims==" %%%%V in ^(`findstr /b /r video_encoder_type "parameter.txt"`^) do ^(>> "%video_encode_batfile_path%"
echo     if "%%%%V"=="x264" ^(>> "%video_encode_batfile_path%"
echo         set video_encoder_type=x264>> "%video_encode_batfile_path%"
echo     ^) else if "%%%%V"=="x265" ^(>> "%video_encode_batfile_path%"
echo         set video_encoder_type=x265>> "%video_encode_batfile_path%"
echo     ^) else if "%%%%V"=="qsv_h264" ^(>> "%video_encode_batfile_path%"
echo         set video_encoder_type=qsv_h264>> "%video_encode_batfile_path%"
echo     ^) else if "%%%%V"=="qsv_hevc" ^(>> "%video_encode_batfile_path%"
echo         set video_encoder_type=qsv_hevc>> "%video_encode_batfile_path%"
echo     ^) else if "%%%%V"=="nvenc_h264" ^(>> "%video_encode_batfile_path%"
echo         set video_encoder_type=nvenc_h264>> "%video_encode_batfile_path%"
echo     ^) else if "%%%%V"=="nvenc_hevc" ^(>> "%video_encode_batfile_path%"
echo         set video_encoder_type=nvenc_hevc>> "%video_encode_batfile_path%"
echo     ^)>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo if "%%video_encoder_type%%"=="" ^(>> "%video_encode_batfile_path%"
echo     echo ビデオエンコードのコーデック指定が見つかりません。代わりにデフォルトのx264を使用します。>> "%video_encode_batfile_path%"
echo     set video_encoder_type=x264>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :x264_encparam_detect>> "%video_encode_batfile_path%"
echo for /f "usebackq eol=# tokens=2 delims==" %%%%X in ^(`findstr /b /r x264_enc_param "parameter.txt"`^) do ^(>> "%video_encode_batfile_path%"
echo     set x264_enc_param=%%%%X>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :x265_encparam_detect>> "%video_encode_batfile_path%"
echo for /f "usebackq eol=# tokens=2 delims==" %%%%X in ^(`findstr /b /r x265_enc_param "parameter.txt"`^) do ^(>> "%video_encode_batfile_path%"
echo     set x265_enc_param=%%%%X>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :qsv_encparam_detect>> "%video_encode_batfile_path%"
echo for /f "usebackq eol=# tokens=2 delims==" %%%%X in ^(`findstr /b /r qsv_enc_param "parameter.txt"`^) do ^(>> "%video_encode_batfile_path%"
echo     set qsv_enc_param=%%%%X>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :nvenc_encparam_detect>> "%video_encode_batfile_path%"
echo for /f "usebackq eol=# tokens=2 delims==" %%%%X in ^(`findstr /b /r nvenc_enc_param "parameter.txt"`^) do ^(>> "%video_encode_batfile_path%"
echo     set nvenc_enc_param=%%%%X>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :qsv_h264_func_check>> "%video_encode_batfile_path%"
echo "%%qsvencc_path%%" --check-features ^| findstr /b /X /C:"Codec: H.264/AVC">> "%video_encode_batfile_path%"
echo if "%%ERRORLEVEL%%"=="0" ^(>> "%video_encode_batfile_path%"
echo     call :qsv_h264_exec_phase>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo ※QSVEncで実行可能な環境が無い為、代わりにx264でエンコードします>> "%video_encode_batfile_path%"
echo     call :x264_exec_phase>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :qsv_hevc_func_check>> "%video_encode_batfile_path%"
echo "%%qsvencc_path%%" --check-features ^| findstr /b /X /C:"Codec: H.265/HEVC">> "%video_encode_batfile_path%"
echo if "%%ERRORLEVEL%%"=="0" ^(>> "%video_encode_batfile_path%"
echo     call :qsv_hevc_exec_phase>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo ※QSVEncで実行可能な環境が無い為、代わりにx265でエンコードします>> "%video_encode_batfile_path%"
echo     call :x265_exec_phase>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :nvenc_h264_func_check>> "%video_encode_batfile_path%"
echo "%%nvencc_path%%" --check-features ^| findstr /b /X /C:"Codec: H.264/AVC">> "%video_encode_batfile_path%"
echo if "%%ERRORLEVEL%%"=="0" ^(>> "%video_encode_batfile_path%"
echo     call :nvenc_h264_exec_phase>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo ※NVEncで実行可能な環境が無い為、代わりにx264でエンコードします>> "%video_encode_batfile_path%"
echo     call :x264_exec_phase>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :nvenc_hevc_func_check>> "%video_encode_batfile_path%"
echo "%%nvencc_path%%" --check-features ^| findstr /b /X /C:"Codec: H.265/HEVC">> "%video_encode_batfile_path%"
echo if "%%ERRORLEVEL%%"=="0" ^(>> "%video_encode_batfile_path%"
echo     call :nvenc_hevc_exec_phase>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo ※NVEncで実行可能な環境が無い為、代わりにx265でエンコードします>> "%video_encode_batfile_path%"
echo     call :x265_exec_phase>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :x264_exec_phase>> "%video_encode_batfile_path%"
echo echo x264エンコード. . .[%%time%%]>> "%video_encode_batfile_path%"
echo %bat_start_wait%"%%avs4x26x_path%%" -L "%%x264_path%%" %%x264_enc_param%%--output ".\tmp\main_temp.264" "main.avs">> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :x265_exec_phase>> "%video_encode_batfile_path%"
echo echo x265エンコード. . .[%%time%%]>> "%video_encode_batfile_path%"
echo %bat_start_wait%"%%avs4x26x_path%%" -L "%%x265_path%%" %%x265_enc_param%%-o ".\tmp\main_temp.265" "main.avs">> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :qsv_h264_exec_phase>> "%video_encode_batfile_path%"
echo echo QSVEncC^^^(H.264/AVC^^^)エンコード. . .[%%time%%]>> "%video_encode_batfile_path%"
echo %bat_start_wait%"%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%qsvencc_path%%" %%qsv_enc_param%%--codec h264 -i - -o ".\tmp\main_temp.264" >> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :qsv_hevc_exec_phase>> "%video_encode_batfile_path%"
echo echo QSVEncC^^^(H.265/HEVC^^^)エンコード. . .[%%time%%]>> "%video_encode_batfile_path%"
echo %bat_start_wait%"%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%qsvencc_path%%" %%qsv_enc_param%%--codec hevc -i - -o ".\tmp\main_temp.265" >> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :nvenc_h264_exec_phase>> "%video_encode_batfile_path%"
echo echo NVEncC^^^(H.264/AVC^^^)エンコード. . .[%%time%%]>> "%video_encode_batfile_path%"
echo %bat_start_wait%"%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%nvencc_path%%" %%nvenc_enc_param%%--codec h264 -i - -o ".\tmp\main_temp.264" >> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :nvenc_hevc_exec_phase>> "%video_encode_batfile_path%"
echo echo NVEncC^^^(H.265/HEVC^^^)エンコード. . .[%%time%%]>> "%video_encode_batfile_path%"
echo %bat_start_wait%"%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%nvencc_path%%" %%nvenc_enc_param%%--codec hevc -i - -o ".\tmp\main_temp.265" >> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :toolsdircheck>> "%video_encode_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%video_encode_batfile_path%"
echo     echo 環境変数 ENCTOOLSROOTPATH が未定義です>> "%video_encode_batfile_path%"
echo     exit /b>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\>> "%video_encode_batfile_path%"
echo if exist "%%ENCTOOLSROOTPATH%%" ^(>> "%video_encode_batfile_path%"
echo     exit /b>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo 環境変数ENCTOOLSROOTPATHが有効なパスではありません>> "%video_encode_batfile_path%"
echo     set ENCTOOLSROOTPATH=>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :project_name_check>> "%video_encode_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=" %%%%P in ^(`findstr /b /r project_name "parameter.txt"`^) do ^(>> "%video_encode_batfile_path%"
echo     set %%%%P>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :find_x264>> "%video_encode_batfile_path%"
echo echo findexe引数："%%~1">> "%video_encode_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%video_encode_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%video_encode_batfile_path%"
echo     echo 探索しています...>> "%video_encode_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%video_encode_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%video_encode_batfile_path%"
echo         echo 見つかりました>> "%video_encode_batfile_path%"
echo         set x264_path=%%%%~E>> "%video_encode_batfile_path%"
echo         exit /b>> "%video_encode_batfile_path%"
echo     ^)>> "%video_encode_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo call :x264_env_search "%%~nx1">> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo :x264_env_search>> "%video_encode_batfile_path%"
echo set x264_path=%%~$PATH:1>> "%video_encode_batfile_path%"
echo if "%%x264_path%%"=="" ^(>> "%video_encode_batfile_path%"
echo     echo x264が見つかりません>> "%video_encode_batfile_path%"
echo     set x264_path=%%~1>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :find_x265>> "%video_encode_batfile_path%"
echo echo findexe引数："%%~1">> "%video_encode_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%video_encode_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%video_encode_batfile_path%"
echo     echo 探索しています...>> "%video_encode_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%video_encode_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%video_encode_batfile_path%"
echo         echo 見つかりました>> "%video_encode_batfile_path%"
echo         set x265_path=%%%%~E>> "%video_encode_batfile_path%"
echo         exit /b>> "%video_encode_batfile_path%"
echo     ^)>> "%video_encode_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo call :x265_env_search "%%~nx1">> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo :x265_env_search>> "%video_encode_batfile_path%"
echo set x265_path=%%~$PATH:1>> "%video_encode_batfile_path%"
echo if "%%x265_path%%"=="" ^(>> "%video_encode_batfile_path%"
echo    echo x265が見つかりません>> "%video_encode_batfile_path%"
echo     set x265_path=%%~1>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :find_qsvencc>> "%video_encode_batfile_path%"
echo echo findexe引数："%%~1">> "%video_encode_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%video_encode_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%video_encode_batfile_path%"
echo     echo 探索しています...>> "%video_encode_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%video_encode_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%video_encode_batfile_path%"
echo         echo 見つかりました>> "%video_encode_batfile_path%"
echo         set qsvencc_path=%%%%~E>> "%video_encode_batfile_path%"
echo         exit /b>> "%video_encode_batfile_path%"
echo     ^)>> "%video_encode_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo call :qsvencc_env_search "%%~nx1">> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo :qsvencc_env_search>> "%video_encode_batfile_path%"
echo set qsvencc_path=%%~$PATH:1>> "%video_encode_batfile_path%"
echo if "%%qsvencc_path%%"=="" ^(>> "%video_encode_batfile_path%"
echo    echo QSVEncCが見つかりません>> "%video_encode_batfile_path%"
echo     set qsvencc_path=%%~1>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :find_nvencc>> "%video_encode_batfile_path%"
echo echo findexe引数："%%~1">> "%video_encode_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%video_encode_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%video_encode_batfile_path%"
echo     echo 探索しています...>> "%video_encode_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%video_encode_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%video_encode_batfile_path%"
echo         echo 見つかりました>> "%video_encode_batfile_path%"
echo         set nvencc_path=%%%%~E>> "%video_encode_batfile_path%"
echo         exit /b>> "%video_encode_batfile_path%"
echo     ^)>> "%video_encode_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo call :nvencc_env_search "%%~nx1">> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo :nvencc_env_search>> "%video_encode_batfile_path%"
echo set nvencc_path=%%~$PATH:1>> "%video_encode_batfile_path%"
echo if "%%nvencc_path%%"=="" ^(>> "%video_encode_batfile_path%"
echo    echo NVEncCが見つかりません>> "%video_encode_batfile_path%"
echo     set nvencc_path=%%~1>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :find_avs4x26x>> "%video_encode_batfile_path%"
echo echo findexe引数："%%~1">> "%video_encode_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%video_encode_batfile_path%"
echo     echo 探索ディレクトリが未定義です、システムのパス探索に委ねます。>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%video_encode_batfile_path%"
echo     echo 探索しています...>> "%video_encode_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%video_encode_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%video_encode_batfile_path%"
echo         echo 見つかりました>> "%video_encode_batfile_path%"
echo         set avs4x26x_path=%%%%~E>> "%video_encode_batfile_path%"
echo         exit /b>> "%video_encode_batfile_path%"
echo     ^)>> "%video_encode_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo call :avs4x26x_env_search "%%~nx1">> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo :avs4x26x_env_search>> "%video_encode_batfile_path%"
echo set avs4x26x_path=%%~$PATH:1>> "%video_encode_batfile_path%"
echo if "%%avs4x26x_path%%"=="" ^(>> "%video_encode_batfile_path%"
echo     echo avs4x26xが見つかりません>> "%video_encode_batfile_path%"
echo     set avs4x26x_path=%%~1>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :find_avs2pipe>> "%video_encode_batfile_path%"
echo echo findexe引数："%%~1">> "%video_encode_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%video_encode_batfile_path%"
echo     set avs2pipe_path=%%~nx1>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo 探索ディレクトリ：%%ENCTOOLSROOTPATH%%>> "%video_encode_batfile_path%"
echo     echo 探索しています...>> "%video_encode_batfile_path%"
echo     rem # for /r "ディレクトリ" %%%%E in (%%~nx1) のコマンドではなぜか存在しないファイルも見つけたことになってしまったので、dirコマンドと併用>> "%video_encode_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%video_encode_batfile_path%"
echo         echo 見つかりました>> "%video_encode_batfile_path%"
echo         set avs2pipe_path=%%%%~E>> "%video_encode_batfile_path%"
echo         exit /b>> "%video_encode_batfile_path%"
echo     ^)>> "%video_encode_batfile_path%"
echo     echo 見つかりませんでした。システムのパス探索に委ねます。>> "%video_encode_batfile_path%"
echo     call :avspipe_env_search %%~nx1>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo :avspipe_env_search>> "%video_encode_batfile_path%"
echo set avs2pipe_path=%%~$PATH:1>> "%video_encode_batfile_path%"
echo if "%%avs2pipe_path%%"=="" ^(>> "%video_encode_batfile_path%"
echo     echo avs2pipeが見つかりません>> "%video_encode_batfile_path%"
echo     set avs2pipe_path=%%~1>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo.
if "%video_encoder_type%"=="x264" (
    echo ### x264 の書き出し ###
    echo 設定：%bat_start_wait%"%avs4x26x_path%" -L "%x264_path%" %x264_Encode_option% %video_sar_option%%x264_VUI_opt%%x264_keyint% %x264_interlace_option%--output ".\tmp\main_temp.264" "main.avs"
) else if "%video_encoder_type%"=="x265" (
    echo ### x265 の書き出し ###
    echo 設定：%bat_start_wait%"%avs4x26x_path%" -L "%x265_path%" %x265_Encode_option% %video_sar_option%%x265_VUI_opt%-o ".\tmp\main_temp.265" "main.avs"
) else if "%video_encoder_type%"=="qsv_h264" (
    echo ### QSVEncC^(H.264/AVC^) の書き出し ###
    echo 設定：%bat_start_wait%"%avs2pipe_path%" -y4mp "main.avs" ^| "%qsvencc_path%" %qsv_Encode_option% %video_sar_option%%qsv_VUI_opt%--codec h264 -i - -o ".\tmp\main_temp.264"
) else if "%video_encoder_type%"=="qsv_hevc" (
    echo ### QSVEncC^(H.265/HEVC^) の書き出し ###
    echo 設定：%bat_start_wait%"%avs2pipe_path%" -y4mp "main.avs" ^| "%qsvencc_path%" %qsv_Encode_option% %video_sar_option%%qsv_VUI_opt%--codec hevc -i - -o ".\tmp\main_temp.265"
) else if "%video_encoder_type%"=="nvenc_h264" (
    echo ### NVEncC^(H.264/AVC^) の書き出し ###
    echo 設定：%bat_start_wait%"%avs2pipe_path%" -y4mp "main.avs" ^| "%nvencc_path%" %nvenc_Encode_option% %video_sar_option%%nvenc_VUI_opt%--codec h264 -i - -o ".\tmp\main_temp.264"
) else if "%video_encoder_type%"=="nvenc_hevc" (
    echo ### NVEncC^(H.265/HEVC^) の書き出し ###
    echo 設定：%bat_start_wait%"%avs2pipe_path%" -y4mp "main.avs" ^| "%nvencc_path%" %nvenc_Encode_option% %video_sar_option%%nvenc_VUI_opt%--codec hevc -i - -o ".\tmp\main_temp.265"
)
exit /b


:load_mpeg2ts_source
rem ### ソースがTSファイルの場合の読み込みフィルタを作成する擬似関数
call :copy_mpeg2source_phase
rem call :direct_mpeg2source_phase
if "%mpeg2dec_select_flag%"=="1" (
    echo video = MPEG2VIDEO^("%mpeg2video_source%"^).AssumeTFF^(^)>> "%work_dir%%main_project_name%\main.avs"
) else if "%mpeg2dec_select_flag%"=="2" (
    echo video = MPEG2Source^("%mpeg2video_source%",upconv=0^).ConvertToYUY2^(^)>> "%work_dir%%main_project_name%\main.avs"
) else if "%mpeg2dec_select_flag%"=="3" (
    echo video = LWLibavVideoSource^("%mpeg2video_source%", dr=false, repeat=true, dominance=0^)>> "%work_dir%%main_project_name%\main.avs"
    echo video = video.height^(^) == 1088 ? video.Crop^(0, 0, 0, -8^) : video>> "%work_dir%%main_project_name%\main.avs"
)
echo audio = WAVSource^(".\src\audio_pcm.wav"^)>> "%work_dir%%main_project_name%\main.avs"
echo AudioDub^(video, audio^)>> "%work_dir%%main_project_name%\main.avs"
echo.>> "%work_dir%%main_project_name%\main.avs"
exit /b

:copy_mpeg2source_phase
set mpeg2video_source=.\src\%sourceTSfile_name%
exit /b
:direct_mpeg2source_phase
set mpeg2video_source=%input_media_path%
exit /b


:trim_edit_phase
echo ##### カット編集 #####>> "%work_dir%%main_project_name%\main.avs"
echo # 単一行で表記するTrimコマンドはここ以下に記入してください>> "%work_dir%%main_project_name%\main.avs"
echo Import^("trim_line.txt"^)    # 一行Trim表記>> "%work_dir%%main_project_name%\main.avs"
echo #Trim^(0,99^) ++ Trim^(200,299^) ++ Trim^(300,399^)>> "%work_dir%%main_project_name%\main.avs"
echo ### 一行で表記するTrimコマンドはここに記入してください ###>> "%work_dir%%main_project_name%\trim_line.txt"
echo.>> "%work_dir%%main_project_name%\main.avs"
echo # 複数行で表記するTrimコマンドはここ以下に記入してください>> "%work_dir%%main_project_name%\main.avs"
echo KillAudio^(^)    # 複雑な編集をする場合に備えて音声を一時無効化>> "%work_dir%%main_project_name%\main.avs"
echo Import^("trim_multi.txt"^)    # 複数行Trim表記^(EasyVFRなど^)>> "%work_dir%%main_project_name%\main.avs"
echo.>> "%work_dir%%main_project_name%\main.avs"
echo ### 複数行で表記するTrimコマンドはここに記入してください ###>> "%work_dir%%main_project_name%\trim_multi.txt"
exit /b


:make_avsfile_phase
rem ### ユーザーの入力した設定にしたがってavsファイルを作成する擬似関数
echo.
echo ### Avisynthスクリプトの雛形を作成 ###
echo %work_dir%%main_project_name%にスクリプトを作成します
type nul > "%work_dir%%main_project_name%\main.avs"
exit /b


----------------------------
set video_format_type=
rem 720p_template / 
set avs_filter_type=
set x264_Encode_option=
set x265_Encode_option=
set vfr_peak_rate=
set TsSplitter_flag=
set DeDot_cc_filter_flag=
rem # 0:Lanczos4Resize / 1:AU_resize
set resize_algo_flag=
rem # 0:FAW / 1:faad→neroAacEnc / 2:sox / 3:5.1chMIX
audio_job_flag=

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
-----------------------------

:cleanup_phase
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

rem # バッチモード関係
set src_video_wide_pixel=
set src_video_hight_pixel=
set src_video_pixel_aspect_ratio=
set videoAspectratio_option=
set avs_filter_type=


goto :parameter_shift

:parameter_shift
rem ### バッチパラメータをシフト ###
rem # %9 は %8 に、... %1 は %0 に
shift /1
rem # バッチパラメータが空なら終了
if "%~1"=="" goto end
echo ------------------------------
echo.
goto :main_function

:help_message
echo.
echo ddaenc - auto encode bat tools rev.%release_version%
echo.
echo Usage: ddaenc.bat [options] input1 input2 input3...
echo.
echo option:
echo     -b, --bat-mode
echo                    To specify bat mode switch
echo     -w, --work ^<string^>
echo                    project work directory path
echo     -o, --output ^<string^>
echo                    output directory path
echo     -e, --encoder ^<string^>
echo                    encoder type [x264(Default), x265, qsv_h264(QSVEncC H.264/AVC), 
echo                    qsv_hevc(QSVEncC H.265/HEVC), nvenc_h264(NVEncC H.264/AVC), 
echo                    nvenc_hevc(NVEncC H.265/HEVC)]
echo     -a, --audio-job ^<string^>
echo                    audio process type [faw(Default), sox, nero]
echo     -r, --resize ^<string^>
echo                    output video resize resolution [none, 1080, 720, 540, 480, 270]
echo     -t, --template ^<string^>
echo                    Not define...
echo     -j, --jl-file ^<string^>
echo                    JL template file path
echo     -d, --deint ^<string^>
echo                    deinterlace filter flag [its(Default), 24fps, 30fps, itvfr, bob, interlace]
echo     -v, --vfr ^<string^>
echo                    AutoVfr mode select [normal, fast]
echo     -s, --splitter
echo                    TsSplitter flag
echo     -c, --crop ^<string^>
echo                    Crop size select [none, sidecut, gakubuchi]
echo     -n, --nr-filter
echo                    Noise Reduction filter flag
echo     -p, --sharp-filter
echo                    Sharp filter flag
echo     -x, --dedot-filter
echo                    DeDot filter flag
echo.
rem # ダブルクリック、もしくはD&Dで呼び出された場合はpause
set cmd_env_chars=%CMDCMDLINE%
if not ""^%cmd_env_chars:~-1%""==""^ "" (
    echo ウィンドウを閉じるには、何かキーを押してください。
    pause>nul
)
exit /b

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
echo.
echo ### 作業終了時刻 ###
echo %time%
echo.
rem # ダブルクリック、もしくはD&Dで呼び出された場合はpause
set cmd_env_chars=%CMDCMDLINE%
if not ""^%cmd_env_chars:~-1%""==""^ "" (
    echo ウィンドウを閉じるには、何かキーを押してください。
    pause>nul
)
echo.
exit /b

:exit
endlocal