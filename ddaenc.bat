@echo off
setlocal

:start
rem #//--- �o�[�W������� ---//
set release_version=3.4.8.181014

rem #//--- �e��o�͐�f�B���N�g���ւ̃p�X ---//

rem ### ��Ɨp�f�B���N�g��(%work_dir%) ###
set work_dir=E:\avs temp\

rem ### �e���|�����f�B���N�g��(%large_tmp_dir%) ###
rem # TsSplitter�O�̈ꎞ�R�s�[�� / ts2aac&FAW��AAC�o�� / �����G���R�[�_�[�ɓn���O��WAV�Ȃ�
rem %large_tmp_dir%�����ϐ��Ŏ��O�ɐݒ�

rem ### �ŏI�o�̓t�@�C�����ړ�����t�H���_�ւ̃p�X ###
rem # �����̃t�H���_����������݂��Ȃ��ꍇ�A���[�U�[�̃z�[���t�H���_�Ɉړ�����܂�
set out_dir_1st=\\Servername\share\mp4 video\
set out_dir_2nd=D:\output video\

rem ### �A�����s�p�o�b�`�t�@�C���܂ł̃p�X ###
set encode_catalog_list=%USERPROFILE%\encode_catalog_list.txt

rem # �G���R�[�_�[�I��
rem x264, x265, qsv_h264, qsv_hevc, nvenc_h264, nvenc_hevc
set video_encoder_type=x264


rem //--- x264 �I�v�V���� ---//
rem --keyint�y�ѓ�d���p���s�v�B

rem ### x264.exe �ւ�path ###
rem # �����
:   https://onedrive.live.com/?cid=6bdd4375ac8933c6&id=6BDD4375AC8933C6%214477&ithint=folder,&authkey=!ABzai4Ddn6_Xxd0
rem # vbv-maxrate/vbv-bufsize�Q�l���
:   http://www.up-cat.net/?page=x264(vbv-maxrate,vbv-bufsize,profile,level),%20H.264(Profile/Level)
rem # PSP��B�t���[���̃s���~�b�h�Q�Ɖ��ɑΉ����Ă��Ȃ��̂ŁA�đI�݊����m�ۂ���ꍇ�̓I�v�V�����Ŗ��������鎖(--b-pyramid none)
rem # PSP��CABAC�����Ή����Ă��Ȃ��̂ŁA�������I�v�V����(--no-cabac)�͎g�p���Ȃ�����
:   http://nicowiki.com/%E6%8B%A1%E5%BC%B5%20x264%20%E5%87%BA%E5%8A%9B%EF%BC%88GUI%EF%BC%89%E3%81%AE%E8%A8%AD%E5%AE%9A%E9%A0%85%E7%9B%AE%E3%81%A8%E3%81%9D%E3%81%AE%E6%A9%9F%E8%83%BD%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6.html
rem # PSP��OpenGOP����Ή�
:   http://pop.4-bit.jp/?p=4813
rem set x264_path=C:\bin\x264_r2851_8dpt_x86.exe
set x264_path=C:\bin\x264_r2901_8dpt_x64.exe

rem ### HighProfile@Level 4.2 �I�v�V����(VUI/fps options������) ###
set x264_HP@L42_option=--crf 22 --profile high --level 4.2 --ref 4 --bframes 3 --b-adapt 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --8x8dct --nal-hrd vbr --vbv-maxrate 62500 --vbv-bufsize 78125 --no-fast-pskip --qpstep 8

rem ### HighProfile@Level 4.0 �I�v�V����(VUI/fps options������) ###
rem set x264_HP@L40_option=--crf 21 --profile high --level 4 --sar 4:3 --ref 3 --bframes 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --8x8dct --nal-hrd vbr --vbv-maxrate 25000 --vbv-bufsize 31250 --no-fast-pskip --qpstep 8 --videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 --threads 4
set x264_HP@L40_option=--crf 22 --profile high --level 4 --ref 4 --bframes 3 --b-adapt 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --8x8dct --nal-hrd vbr --vbv-maxrate 25000 --vbv-bufsize 31250 --no-fast-pskip --qpstep 8

rem ### MainProfile@Level 3.2 �I�v�V����(VUI/fps options������) ###
set x264_MP@L32_option=--crf 22 --profile main --level 3.2 --ref 5 --bframes 3 --b-adapt 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --nal-hrd vbr --vbv-maxrate 20000 --vbv-bufsize 10000 --no-fast-pskip --qpstep 8

rem ### MainProfile@Level 3.1 �I�v�V����(VUI/fps options������) ###
set x264_MP@L31_option=--crf 22 --profile main --level 3.1 --ref 5 --bframes 3 --b-adapt 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --nal-hrd vbr --vbv-maxrate 14000 --vbv-bufsize 10000 --no-fast-pskip --qpstep 8

rem ### MainProfile@Level 3.0 �I�v�V����(VUI/fps options������) ###
set x264_MP@L30_option=--crf 22 --profile main --level 3 --ref 5 --bframes 3 --b-adapt 2 --b-pyramid none --cqm flat --subme 9 --me umh --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --nal-hrd vbr --vbv-maxrate 10000 --vbv-bufsize 10000 --no-fast-pskip --qpstep 8

rem ### MainProfile@Level 2.1 �I�v�V����(VUI/fps options������) ###
set x264_MP@L21_option=--crf 22 --profile main --level 21 --ref 3 --bframes 2 --b-pyramid none --cqm flat --subme 9 --me umh --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --nal-hrd vbr --vbv-maxrate 4000 --vbv-bufsize 4000 --no-fast-pskip --qpstep 8

rem ### �C���^�[���[�X�ێ��G���R�[�f�B���O������ꍇ�̃I�v�V���� ###
rem # Profile Level3
set x264_interlace_Lv3=--interlace --tff 
rem # Profile Level4
set x264_interlace_Lv4=--interlace --tff --weightp 0 


rem //--- x265 �I�v�V���� ---//
rem ### x265.exe �ւ�path ###
rem # �����
:   https://onedrive.live.com/?authkey=%21AJWOVN55IpaFffo&id=6BDD4375AC8933C6%213306&cid=6BDD4375AC8933C6
set x265_path=C:\bin\x265_2.1+11_x64_pgo.exe

rem ### MainProfile@Level 4.1 (Main Tier)�I�v�V����(VUI/fps options������) ###
set x265_MP@L41_option=--crf 22 --profile main --level-idc 4.1 --preset slow --no-high-tier

rem ### MainProfile@Level 4.0 (Main Tier)�I�v�V����(VUI/fps options������) ###
set x265_MP@L40_option=--crf 22 --profile main --level-idc 4.0 --preset slow --no-high-tier

rem ### MainProfile@Level 3.1 (Main Tier)�I�v�V����(VUI/fps options������) ###
set x265_MP@L31_option=--crf 22 --profile main --level-idc 3.1 --preset slow --no-high-tier

rem ### MainProfile@Level 3.0 (Main Tier)�I�v�V����(VUI/fps options������) ###
set x265_MP@L30_option=--crf 22 --profile main --level-idc 3.0 --preset slow --no-high-tier


rem //--- QSVEncC �I�v�V���� ---//
rem ### QSVEncC.exe �ւ�path ###
rem # �����
:   http://rigaya34589.blog135.fc2.com/blog-entry-337.html
set qsvencc_path=C:\app\QSVEnc\QSVEncC\x86\QSVEncC.exe

rem ### QSVEncC H.264/AVC HighProfile@Level 4.2 �I�v�V����(VUI/fps options������) ###
set qsv_h264_HP@L42_option=--y4m --profile Main --level 4.2 --cqp 24:26:27 

rem ### QSVEncC H.264/AVC HighProfile@Level 4.0 �I�v�V����(VUI/fps options������) ###
set qsv_h264_HP@L40_option=--y4m --profile Main --level 4.1 --cqp 24:26:27 

rem ### QSVEncC H.264/AVC MainProfile@Level 3.2 �I�v�V����(VUI/fps options������) ###
set qsv_h264_MP@L32_option=--y4m --profile Main --level 3.2 --cqp 24:26:27 

rem ### QSVEncC H.264/AVC MainProfile@Level 3.1 �I�v�V����(VUI/fps options������) ###
set qsv_h264_MP@L31_option=--y4m --profile Main --level 3.1 --cqp 24:26:27 

rem ### QSVEncC H.264/AVC MainProfile@Level 3.0 �I�v�V����(VUI/fps options������) ###
set qsv_h264_MP@L30_option=--y4m --profile Main --level 3 --cqp 24:26:27 

rem ### QSVEncC H.264/AVC MainProfile@Level 2.1 �I�v�V����(VUI/fps options������) ###
set qsv_h264_MP@L21_option=--y4m --profile Main --level 2.1 --cqp 24:26:27 


rem ### QSVEncC H.265/HEVC MainProfile@Level 4.1 (Main Tier)�I�v�V����(VUI/fps options������) ###
set qsv_hevc_MP@L41_option=--y4m --profile main --level 4.1 --cqp 24:26:27 

rem ### QSVEncC H.265/HEVC MainProfile@Level 4.0 (Main Tier)�I�v�V����(VUI/fps options������) ###
set qsv_hevc_MP@L40_option=--y4m --profile main --level 4.0 --cqp 24:26:27 

rem ### QSVEncC H.265/HEVC MainProfile@Level 3.1 (Main Tier)�I�v�V����(VUI/fps options������) ###
set qsv_hevc_MP@L31_option=--y4m --profile main --level 3.1 --cqp 24:26:27 

rem ### QSVEncC H.265/HEVC MainProfile@Level 3.0 (Main Tier)�I�v�V����(VUI/fps options������) ###
set qsv_hevc_MP@L30_option=--y4m --profile main --level 3 --cqp 24:26:27 


rem //--- NVEncC �I�v�V���� ---//
rem ### NVEncC.exe �ւ�path ###
rem # �����
:   http://rigaya34589.blog135.fc2.com/blog-entry-739.html
set nvencc_path=C:\app\NVEnc\NVEncC\x86\NVEncC.exe

rem ### NVEncC H.264/AVC HighProfile@Level 4.2 �I�v�V����(VUI/fps options������) ###
set nvenc_h264_HP@L42_option=--y4m --profile Main --level 4.2 --cqp 20:23:25 

rem ### NVEncC H.264/AVC HighProfile@Level 4.0 �I�v�V����(VUI/fps options������) ###
set nvenc_h264_HP@L40_option=--y4m --profile Main --level 4.1 --cqp 20:23:25 

rem ### NVEncC H.264/AVC MainProfile@Level 3.2 �I�v�V����(VUI/fps options������) ###
set nvenc_h264_MP@L32_option=--y4m --profile Main --level 3.2 --cqp 20:23:25 

rem ### NVEncC H.264/AVC MainProfile@Level 3.1 �I�v�V����(VUI/fps options������) ###
set nvenc_h264_MP@L31_option=--y4m --profile Main --level 3.1 --cqp 20:23:25 

rem ### NVEncC H.264/AVC MainProfile@Level 3.0 �I�v�V����(VUI/fps options������) ###
set nvenc_h264_MP@L30_option=--y4m --profile Main --level 3 --cqp 20:23:25 

rem ### NVEncC H.264/AVC MainProfile@Level 2.1 �I�v�V����(VUI/fps options������) ###
set nvenc_h264_MP@L21_option=--y4m --profile Main --level 2.1 --cqp 20:23:25 


rem ### NVEncC H.265/HEVC MainProfile@Level 4.1 (Main Tier)�I�v�V����(VUI/fps options������) ###
set nvenc_hevc_MP@L41_option=--y4m --profile main --level 4.1 --cqp 20:23:25 

rem ### NVEncC H.265/HEVC MainProfile@Level 4.0 (Main Tier)�I�v�V����(VUI/fps options������) ###
set nvenc_hevc_MP@L40_option=--y4m --profile main --level 4.0 --cqp 20:23:25 

rem ### NVEncC H.265/HEVC MainProfile@Level 3.1 (Main Tier)�I�v�V����(VUI/fps options������) ###
set nvenc_hevc_MP@L31_option=--y4m --profile main --level 3.1 --cqp 20:23:25 

rem ### NVEncC H.265/HEVC MainProfile@Level 3.0 (Main Tier)�I�v�V����(VUI/fps options������) ###
set nvenc_hevc_MP@L30_option=--y4m --profile main --level 3 --cqp 20:23:25 


rem #//--- �e��X�C�b�`�E�p�����[�^�[ ---//

rem ### ��ƊJ�n�O�Ƀ\�[�X�t�@�C�����ꎞ���[�J���t�H���_�ɃR�s�[���� ###
rem # 0: �\�[�X�h���C�u�̃��f�B�A�^�C�v�Ɉˑ��B���[�J��HDD�̏ꍇ�̓R�s�[���Ȃ��B
rem # 1: �ꎞ�R�s�[
set force_copy_src=0

rem ### �����߃��S������}�~���邩�ǂ����̃t���O ###
rem # 0: �}�~���Ȃ�(�����߃��S�����͎��s����܂�)
rem # 1: �}�~����(�����߃��S�����͎��s����܂���)
set disable_delogo=0

rem ### ����CM�J�b�g��}�~���邩�ǂ����̃t���O(�蓮��Trim�𔽉f�����ꍇ�͂����炪�D�悳��܂�) ###
rem # 0: �}�~���Ȃ�(����CM�J�b�g�͎��s����܂�)
rem # 1: �}�~����(����CM�J�b�g�͎��s����܂���)
set disable_cmcutter=0

rem ### AVS �X�N���v�g�̃v���O�C���ǂݍ��ݕ������C���|�[�g���� ###
rem # 0: �C���|�[�g�����ɒ��ڋL�q����
rem # 1: �C���|�[�g����
set importloardpluguin_flag=1

rem ### AAC�����̃I�[�f�B�I�Q�C�����w�肵���I�t�Z�b�g���A�b�v���� ###
rem # 0: �Q�C���A�b�v���Ȃ�
rem # 1�`: �Q�C���A�b�v����(�����l�̂݃T�|�[�g)
set audio_gain=3

rem ### mp4�t�@�C���o�͌�Affmpeg�ɂ�edts���K�i�����ɏC������ ###
rem # 0: �C�����Ȃ�
rem # 1: �C������(Haali Media Splitter���ŃY���A�y��QT��par������肪��������\��������܂�)
set fix_edts_flag=0

rem ### ASS�`���̎������o�͂��邩�ǂ����̑I�� ###
rem # 0: �o�͂��Ȃ�
rem # 1: �o�͂���
set output_ass_flag=1

rem ### MPEG2 �f�R�[�_�[�̑I�� ###
rem ��DGIndex������
rem # 1: MPEG-2 VIDEO VFAPI Plug-In ���g�p�B
rem # 2: DGMPGDEC ���g�p�B
rem # 3: L-SMASH Works ���g�p�B
set mpeg2dec_select_flag=3

rem # ��^�t�@�C���̃R�s�[�Ɏg�p����A�v���P�[�V�����I��
rem copy(Default), fac(FastCopy), ffc(FireFileCopy)
set copy_app_flag=fac

rem ### .NetFramework ��L���ɂ��邩�ǂ��� ###
rem # 0: �g�p���Ȃ�
rem # 1: �g�p����
set use_NetFramework_switch=1

rem ### �G�R�[�\���̒���&�o�b�t�@�N���A������A�v���P�[�V�����ׂ̈ɁA�W���o�͂������邩�ǂ��� ###
rem # 0:�o�͂���
rem # 1:�o�͂��Ȃ�
set kill_longecho_flag=1


rem //--- ���s�t�@�C���n�p�X ---//

rem #//--- DGIndex �֌W ---//
rem ### DGIndex�iDGMPGDEC�j�̂���t�H���_�̃p�X###
rem # mpeg2dec_select_flag=2 �̏ꍇ�ɕK�v�B
set dgindex_path="C:\app\DGMPGDec\DGIndex.exe"

rem ### DGIndex �̃I�v�V����(�m�[�}��) ###
rem # �w�肵�Ȃ��ꍇ�A�f�t�H���g�� DGIndex.ini �̐ݒ肪�g����B��d���p���s�v�B
rem # �I�v�V�����̏����� Unix-Style Command-Line Interface �ɑ����ċL�ڂ��邱��
rem # �ڂ����� DGIndexManual.html#AppendixC ���Q�ƁB
set dgindex_options_normal=-ia 4 -of 2 -om 1 -yr 1 -hide -exit

rem ### DGIndex �̃I�v�V����(TBS/�t�W�e���r/MXTV) ###
rem # �w�肵�Ȃ��ꍇ�A�f�t�H���g�� DGIndex.ini �̐ݒ肪�g����B��d���p���s�v�B
set fuji_dgindex_options=-ia 4 -of 2 -om 1 -yr 1 -ap 112 -vp 111 -hide -exit

rem ### DGIndex �̃I�v�V����(NHK����/����) ###
rem # �w�肵�Ȃ��ꍇ�A�f�t�H���g�� DGIndex.ini �̐ݒ肪�g����B��d���p���s�v�B
set kyouiku_dgindex_options=-ia 4 -of 2 -om 1 -yr 1 -ap 110 -vp 100 -hide -exit

rem # FireFilecopy �ւ̃p�X
set ffc_path=C:\app\FireFileCopy\FFC.exe

rem # FastCopy �ւ̃p�X
set fac_path=C:\Program Files\FastCopy\fastcopy.exe

rem ### MPEG-2 VIDEO VFAPI Plug-In�im2v.vfp�j �̃p�X###
rem # mpeg2dec_select_flag=1 �̏ꍇ�ɕK�v�B
set m2v_vfp_path=C:\app\m2v_vfp\m2v.vfp

rem ### avs4x26x.exe �ւ�path ###
set avs4x26x_path=C:\bin\avs4x26x.exe

rem ### TsSplitter �ւ̃p�X###
set TsSplitter_path=C:\app\TsSplitter\TsSplitter.exe

rem ### FakeAacWave �ւ̃p�X ###
set FAW_path=C:\app\FakeAacWav\fawcl.exe

rem ### ts2aac �ւ̃p�X ###
rem ��ts2aac�͌����Ƃ���MPEG2 VFAPI Plug-In���r�f�I�̐擪��closed GOP�łȂ���ΐ���ɋ@�\���Ȃ�, ts_parser�̎g�p�𐄏�
set ts2aac_path=C:\app\ts2aac\ts2aac.exe

rem ### ts_parser �ւ̃p�X ###
rem ���g�p����MPEG-2�f�R�[�_�[�ɉ����� --delay-type �I�v�V������ύX����, �\�[�XTS��Drop������ꍇ�̂�ts2aac�̎g�p�𐄏�
set ts_parser_path=C:\bin\ts_parser.exe

rem ### faad �ւ̃p�X ###
set faad_path=C:\bin\faad.exe

rem ### avs2wav �ւ̃p�X ###
rem set avs2wav_path=C:\bin\avs2wav.exe
rem http://www.ku6.jp/keyword19/1.html
set avs2wav_path=C:\bin\avs2wav32.exe

rem ### avs2pipe(mod) �ւ̃p�X ###
set avs2pipe_path=C:\bin\avs2pipemod.exe

rem ### logoframe �ւ̃p�X ###
set logoframe_path=C:\app\logoframe\logoframe.exe

rem ### chapter_exe �ւ̃p�X ###
set chapter_exe_path=C:\app\chapter_exe\chapter_exe.exe

rem ### chapter_exe �̃I�v�V�����p�����[�^�[ ###
set chapter_exe_option=-s 8 -e 4

rem ### join_logo_scp �ւ̃p�X ###
set join_logo_scp_path=C:\app\join_logo_scp\join_logo_scp.exe

rem ### AutoVfr �ւ̃p�X ###
set autovfr_path=C:\bin\AutoVfr.exe

rem ### AutoVfr.ini �ւ̃p�X(���݂��Ȃ��ꍇ�AAutoVfr.exe�Ɠ����t�H���_��T��) ###
set autovfrini_path=C:\bin\AutoVfr.ini

rem ### AutoVfr�̃I�v�V�����p�����[�^�[(Auto_Vfr��Auto_Vfr_Fast���ʁAAuto_Vfr�ŗL�̃I�v�V������Fast�ł͖���) ###
set autovfr_setting=cthresh=80, mi=60, blockx=16, blocky=32, chroma=false, IsCrop=true, crop_height=920

rem ### ext_bs �ւ̃p�X ###
set ext_bs_path=C:\bin\ext_bs.exe

rem ### muxer.exe(L-SMASH) �ւ̃p�X ###
set muxer_path=C:\bin\muxer.exe

rem ### remuxer.exe(L-SMASH) �ւ̃p�X ###
set remuxer_path=C:\bin\remuxer.exe

rem ### timelineeditor.exe(L-SMASH) �ւ̃p�X ###
set timelineeditor_path=C:\bin\timelineeditor.exe

rem ### mp4box �ւ̃p�X ### ���폜�\��
rem # �����X�g���[����disable�I�v�V�����̂��߁A�vversion 0.4.5�ȍ~
set mp4box_path=C:\Program Files\GPAC\mp4box.exe

rem ### mp4chaps �ւ̃p�X ### ���폜�\��
set mp4chaps_path=C:\bin\mp4chaps.exe

rem ### DtsEdit �ւ̃p�X ###
rem # QT�Đ��݊��ׂ̈ɕK�v
set DtsEdit_path=C:\bin\DtsEdit.exe

rem ### sox �ւ̃p�X ###
set sox_path=C:\app\sox-14.2.0\sox.exe

rem ### neroAacEnc �ւ̃p�X ###
set neroAacEnc_path=C:\bin\neroAacEnc.exe

rem ### aacgain �ւ̃p�X ###
set aacgain_path=C:\bin\aacgain.exe

rem ### ffmpeg �ւ̃p�X ###
set ffmpeg_path=C:\bin\ffmpeg.exe

rem ### Comskip �ւ̃p�X ###
set comskip_path=C:\app\Comskip\comskip.exe

rem ### comskip.ini �ւ̃p�X ###
set comskipini_path=C:\app\Comskip\comskip.ini

rem ### caption2Ass(_mod) �ւ̃p�X ###
set caption2Ass_path=C:\app\Caption2Ass_mod1\Caption2Ass_mod1.exe

rem ### SrtSync �ւ̃p�X ###
rem # �v.NET Framework 3.5
set SrtSync_path=C:\bin\SrtSync.exe

rem ### nkf(�����R�[�h�ύX�c�[��) �ւ̃p�X ###
set nkf_path=C:\bin\nkf.exe

rem ### sed(onigsed) �փp�X ###
set sed_path=C:\bin\onigsed.exe

rem ### sed�X�N���v�g �ւ̃p�X ###
set sedscript_path=C:\app\Caption2Ass_mod1\Gaiji\ARIB2Unicode.txt

rem ### tsrenamec �ւ̃p�X ###
set tsrenamec_path=C:\bin\tsrenamec.exe

rem ### AtomicParsley �ւ̃p�X ###
set AtomicParsley_path=C:\bin\AtomicParsley.exe

rem ### KeyIn.VB.NET �ւ̃p�X ###
rem http://www.vector.co.jp/soft/winnt/util/se461954.html
rem # .NET Framework 3.5 ���K�v�BKeyIn���g�����ǂ�����%use_NetFramework_switch%�Ŏw��
set KeyIn_path=C:\bin\KeyIn.exe

rem ### MediaInfo CLI �ւ̃p�X ###
set MediaInfoC_path=C:\app\MediaInfo_CLI\MediaInfo.exe


rem //--- �e��e���v���[�g�ւ̃p�X ---//

rem ### ���S�t�@�C��(.lgd)�̃\�[�X�t�H���_���w�� ###
set lgd_file_src_path=C:\app\AviSynth\lgd

rem ### �J�b�g�������@�X�N���v�g(JL)�̃\�[�X�t�H���_���w�� ###
set JL_src_dir=C:\app\AviSynth\JL

rem ### �f�t�H���g�Ŏg�p����J�b�g�������@�X�N���v�g(JL)�̃t�@�C�������w�� ###
set JL_file_name=JL_�W��.txt

rem ### ���C�������p��AVS�e���v���[�g�t�@�C��
set avs_main_template=C:\app\AviSynth\Script\MainAVStemplate_01-default.avs

rem ### �v���O�C���ǂݍ��݃e���v���[�g�̃p�X ###
set plugin_template=C:\app\AviSynth\Script\LoadPlugin.avs

rem ### AutoVfr �e���v���[�g�̃p�X ###
set autovfr_template=C:\app\AviSynth\Script\Auto_Vfr.avs

rem ### AutoVfr_Fast �e���v���[�g�̃p�X ###
set autovfr_fast_template=C:\app\AviSynth\Script\Auto_Vfr_Fast.avs

rem ### AutoVfr �̋t�e���V�l���蓮/�����ǂ���ł�邩�ݒ肵�܂� ###
rem # 0: �蓮 / 1: ����
set autovfr_deint=1

rem ### def �t�@�C���փp�X ###
set def_itvfr_file=C:\app\AviSynth\Script\foo.def

rem #--- �����ݒ�I��� ---

rem ### �� ���� ###
rem �{��if��for������set�R�}���h���g���ꍇ�ɁA���͂��ꂽ�t�@�C���p�X��()���܂܂�Ă����
rem �������ϐ��̂��ߌ듮��̌����ɂȂ�B�ʏ킱���������ꍇ�x�����ϐ���p���邪
rem �t�@�C���p�X�̂�!���܂܂��ꍇ������̂ł��̕��@�͖]�܂����Ȃ��B
rem �d���Ȃ��̂�call�R�}���h���g���A�T�u���[�`���Ƃ���if��for���Ɋ܂܂�Ȃ����x���܂�
rem �W�����v�����@�ł��̖���������Ă���B���̂��ߔ��ɃR�[�h����剻�����G���E�E�E
rem ���̍ےP���Ƀ��x����call�����������ƃt�@�C�������p������Ȃ��̂ŁAcall��ł�
rem �o�b�`�t�@�C����D&D�����t�@�C�������g�p�������ꍇ call :���x���� "%~1" �ƋL�q���邱�ƁB

rem # bat ���_�u���N���b�N�Ȃ�w���v���b�Z�[�W��\��
if "%~1"=="" (
    rem # ���x��:help_message�ֈړ�
    goto :help_message
)

rem # ���ϐ��N���[���i�b�v
set already_avs_detect_flag=
set bat_mode=
if not "%JL_src_dir:~-1%"=="\" set JL_src_dir=%JL_src_dir%\
if not "%lgd_file_src_path:~-1%"=="\" set lgd_file_src_path=%lgd_file_src_path%\

rem # ���[�U�[�I���Ŏw�肷��p�����[�^�[���f�t�H���g�l�ɃZ�b�g����
rem #^(�o�b�`�O�ŃZ�b�g���ꂽ���ϐ�������ƌ듮�삷��̂ŁA���炩���߃I�[�o�[���C�h^)
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

echo ### �����ݒ�I�� ###
echo [%time%]

:bat_option_detect_phase
rem # ��Ԑe�̈����ϐ���shift����悤�ɁAshift��call��Ŏ��s���Ȃ���
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
    echo �o�b�`�������[�h����
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
rem # �o�b�`���[�h�p�����[�^�[�ɕs���Ȓl���܂܂�Ă����ꍇ�A�����I��
if "%exit_stat%"=="1" (
    exit /b
)

rem # �������̐擪������-�̏ꍇ�A�I�v�V�����Ƃ݂Ȃ��čċA���s����
set fast_param=%~1
if "%fast_param:~0,1%"=="-" (
    goto :bat_option_detect_phase
)

:error_check
rem # �\�[�X�t�@�C���ƃR�s�[��̃f�B���N�g��������̏ꍇ�G���[
if "%~dp1"=="%large_tmp_dir%" (
    rem # �G���[���b�Z�[�W�̐ݒ�
    set error_message=�\�[�X�t�@�C���̃f�B���N�g���ƃR�s�[��̃f�B���N�g���������ł��B
    rem # ���x��error�ֈړ�
    goto :error
)
rem # AVS��Ɨp�f�B���N�g���ƃe���|�����p�f�B���N�g��������̏ꍇ�G���[
if "%work_dir%"=="%large_tmp_dir%" (
    rem # �G���[���b�Z�[�W�̐ݒ�
    set error_message=AVS��Ɨp�f�B���N�g����TS�e���|�����p�f�B���N�g���������ł��B
    rem # ���x��error�ֈړ�
    goto :error
)
rem # work_dir �����݂��Ȃ��ꍇ�G���[
if not exist "%work_dir%" (
    rem # �G���[���b�Z�[�W�̐ݒ�
    set error_message=AVS ���o�͂���t�H���_�̃p�X���Ԉ���Ă��܂��B
    rem # ���x��error�ֈړ�
    goto :error
)
rem # avs_main_template �����݂��Ȃ��ꍇ�G���[
if not exist "%avs_main_template%" (
    rem # �G���[���b�Z�[�W�̐ݒ�
    set error_message=AVS�̃��C���e���v���[�g�����݂��܂��񂎁B
    rem # ���x��error�ֈړ�
    goto :error
)
if "%large_tmp_dir%"=="" (
    echo �����Ӂ�
    echo �傫�߂̈ꎞ�t�@�C�����쐬����%%large_tmp_dir%%���ϐ�������`�ł��B
    echo �G���R�[�h�����s����O�ɃV�X�e���ݒ���ς܂��Ă��������B
)
echo.

if "%bat_mode%"=="1" (
    echo �o�b�`���[�h�ϐ��m�F
    echo �v���W�F�N�g��ƃt�H���_�F"%work_dir%"
    echo �o�̓t�H���_�F"%out_dir_1st%"
    echo �G���R�[�_�[�F"%video_encoder_type%"
    echo CRF�F"%crf_value%"
    echo MPEG2�f�R�[�_�[�F"%mpeg2dec_select_flag%"
    echo �I�[�f�B�I�F"%audio_job_flag%"
    echo ���T�C�Y�F"%bat_vresize_flag%"
    echo AVS�e���v���[�g�F"%avs_main_template%"
    echo ���S�t�@�C���F"%bat_lgd_file_path%"
    echo JL�t�@�C���F"%JL_src_file_full-path%"
    echo JL�t���O�F"%JL_custom_flag%"
    echo �f�C���^�[���[�X�����F"%deinterlace_filter_flag%"
    echo AutoVfr�����F"%autovfr_mode%"
    echo TsSplitter�F"%tssplitter_opt_param%"
    echo Crop�w��F"%crop_size_flag%"
)

:folder_end_checker
rem # �f�B���N�g��������"\"��ǉ����钲��
if not "%work_dir:~-1%"=="\" set work_dir=%work_dir%\


rem ### �֐��ݒ�J�n

rem =============== ���C���[���֐��J�n ===============
:main_function
rem ### �[��main�֐��A��������e�[���֐����Ăяo���B�����ݒ�Œ�߂�ꂽ�����̐���͂Ȃ�ׂ������ōs��

:check_filetype
if "%~x1"==".ts" (
    echo ���̓t�@�C���F"%~1"
) else if "%~x1"==".m2ts" (
    echo ���̓t�@�C���F"%~1"
) else if "%~x1"==".mpg" (
    echo ���̓t�@�C���F"%~1"
) else if "%~x1"==".mpeg" (
    echo ���̓t�@�C���F"%~1"
) else if "%~x1"==".m2p" (
    echo ���̓t�@�C���F"%~1"
) else if "%~x1"==".mpv" (
    echo ���̓t�@�C���F"%~1"
) else if "%~x1"==".m2v" (
    echo ���̓t�@�C���F"%~1"
) else if "%~x1"==".dv" (
    echo ���̓t�@�C���F"%~1"
) else if "%~x1"==".avs" (
    echo ���̓t�@�C���F"%~1"
) else if "%~x1"==".d2v" (
    echo ����A�g���q��.d2v�̓ǂݍ��݂ɑΉ����Ă��܂���B�{�̂��w�肵�Ă�������
    set mpeg2dec_select_flag=2
    goto :parameter_shift
) else (
    echo.
    echo ��Ή��g���q
    goto :parameter_shift
)
echo.
echo ### ��ƊJ�n���� ###
echo [%time%]
echo.

rem ### �\�[�X�t�@�C���ւ̃t���p�X^(src_file_path^)�����ϐ��ɏ�������.�B��Ńp�����[�^�[�t�@�C���ɂ��������ށB
set src_file_path=%~1

rem ### �\�[�X�Ƃ���t�@�C���ւ̃p�X�A�ʏ�͓��͂��ꂽ�t�@�C�� ###
set input_media_path=%~1

rem ### AVS�t�@�C���̖��O�A�ʏ�͓��͂��ꂽ�t�@�C���Ɠ��� ###
set avs_project_name=%~n1

rem ### �f�B���N�g���� main_project_name �ƁA�t�@�C���� avs_project_name �����肷��֐�
rem # ���͂�avs�t�@�C���̏ꍇ�A�R�s�[���ƃR�s�[��̃f�B���N�g�����ƃt�@�C��������v������
rem ### avs�t�@�C���̂���f�B���N�g�����R�s�[����[���֐�
rem # ���͂�avs�̏ꍇ�A�ŏ���avs�t�@�C��������f�B���N�g���̂���ɏ�ʂ̃f�B���N�g���܂ł̃p�X�𓾂�
if "%~x1"==".avs" (
    call :get_upperdir_path "%~dp1."
)
rem # �t�H���_�̖��O�A�����l�Őݒ肵���l(�ʏ�͓��̓t�@�C���Ɠ���)
rem # if������set�R�}���h���g���ꍇ�A�^�����镶���񒆂�)������ƌ�쓮���邽��call�ŃT�u���[�`����
if "%~x1"==".avs" (
    call :avs_projectname_detect "%~1"
) else (
    call :other_projectname_detect "%~1"
)
rem # �쐬����t�H���_�̖����ɔ��p�X�y�[�X������ƕs�����̂ł��̃`�F�b�N
:space_blank_checker
if "%main_project_name:~-1%"==" " (
    call :space_blank_del
    goto :space_blank_checker
)
rem # ������AVS�t�@�C�������ɑ��݂��邩�ǂ����̃`�F�b�N
if exist "%work_dir%%main_project_name%\main.avs" (
    rem # �ŏ��͂�����call���g���Ă������A��������ƃT�u���[�`������A���Ă��Ă��̒���Ƀ��x��:space_blank_checker��
    rem # goto����ƕϐ�%avs_project_name%���Ȃ��������p����Ȃ��̂ł������ă��x��:over_write_select�ւ�goto����
    rem goto :over_write_select
    rem call :over_write_select "%~1"
    rem echo ���֖�
    goto :over_write_select
) else (
    echo ���C���l�[��:"%main_project_name%"
    if "%main_project_name%"=="" (
        :name_blank_checker
        echo �� ���� ��
        echo �t�@�C�������󔒂ɂ��邱�Ƃ͏o���܂���
        if "%use_NetFramework_switch%"=="1" (
            call :Type_KeyIn
            goto :name_blank_checker
        ) else (
            call :noType_KeyIn
            goto :name_blank_checker
        )
    )
)
rem # �����t�@�C���㏑���̏ꍇ�̃W�����v�̂��߂̃��x��
:esc_checkexist_avsfile
rem # ���͂�avs�̏ꍇ�̏����B�Ώ�avs�t�@�C��������f�B���N�g�����ہX�R�s�[(�����\�[�X�t�@�C��)
rem # �������ړ����ƈړ���̃f�B���N�g��������̏ꍇ�R�s�[���Ȃ�
if "%~x1"==".avs" (
    call :copy_avssrc_dir "%~1"
)
rem # ��Ɨp�T�u�f�B���N�g�����쐬����
call :make_project_dir "%~1"
rem # MediaInfo CLI�œ��͂��ꂽ���f�B�A�̏����o�͂���
call :MediaInfoC_phase "%~1"
if "%bat_mode%"=="1" (
    rem # �o�b�`���[�h�Ŗ����莖���m�胋�[�`��
    call :bat_video_resolution_detect
) else (
    rem # �e���[�U�[�ݒ�����肷�鍀��
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
rem �����t�@�C������p�o�b�`�t�@�C���p�X��ݒ�
call :sub_srteditfile_detec
rem �g���b�Nmux�p�o�b�`�t�@�C���p�X��ݒ�
call :sub_muxtracksfile_detec
rem �ꎞ�t�@�C���폜�p�o�b�`�t�@�C���p�X��ݒ�
call :sub_deltmpfile_detec
rem # Trim���̐��`
call :sub_trimlinefile_detec

rem # ���C���o�b�`�t�@�C�����쐬����
call :make_main_bat "%~1"
rem # �\�[�X�t�@�C���R�s�[�A���̑����O�����p�o�b�`�t�@�C�����쐬����
call :copy_source_phase "%~1"
rem # .d2v�t�@�C���쐬
rem call :make_d2vfile_phase "%input_media_path%"
rem Trim�ҏW�p�o�b�`���e�쐬
call :make_trimline_phase
rem ���S��������ю���CM�J�b�g�֘A�o�b�`���e�쐬
call :make_logoframe_phase
rem join_logo_scp�̏o�͌��ʂ���`���v�^�[�t�@�C����������������cscript�𐶐�, �ujoin_logo_scp���s���v����q��
call :make_chapter_jls_phase
rem AutoVfr�p�o�b�`����ѐݒ�t�@�C���쐬
call :make_autovfr_phase
rem # ���S�t�@�C��(.lgd)�̃R�s�[�t�F�[�Y
call :copy_lgd_file_phase "%~1"
rem # �J�b�g�������@�X�N���v�g(JL)�̃R�s�[�t�F�[�Y
call :copy_JL_file_phase "%~1"
rem # AVS�t�@�C�����쐬����A���̓t�@�C����.avs�̏ꍇ�̓X�L�b�v
if "%~x1"==".avs" (
    rem # ���͂�avs�̏ꍇ�V�K��avs�t�@�C���͍쐬���Ȃ�
) else (
    rem # avs�t�@�C���쐬
    rem �G���R�[�h���C�������p��AVS�t�@�C�����e���v���[�g�t�@�C�����琶��
    call :avs_template_main_phase
    rem # �o�͉𑜓x��\��
    echo �L���𑜓x: ^(Width:%resize_wpix%, Height:%resize_hpix%^)
    rem # Its�p.def�t�@�C���̃R�s�[
    echo Its def�t�@�C���F"%def_itvfr_file%"
    copy "%def_itvfr_file%" "%work_dir%%main_project_name%\avs\main.def"> nul
    copy "%def_itvfr_file%" "%work_dir%%main_project_name%\main.def"> nul
    rem # �e�퉹����ǂݍ���ł���ATrim�ҏW��̃I�[�f�B�I�X�g���[�����o�͂��邽�߂�avs�t�@�C���쐬
    rem # �v���r���[(�����m�F�p)avs�t�@�C���쐬
    call :make_previewfile_phase "%~1"
    rem # �v���O�C���ǂݍ��݃t�B���^�쐬
    call :make_previewplugin_phase "%~1"
    rem # �v���r���[�pAVS�t�@�C���쐬
    if "%~x1"==".dv" (
        rem ������
    ) else (
        call :load_mpeg2ts_preview "%~1"
    )
    rem # �g�b�v�t�B�[���h/�{�g���t�B�[���h�w��
    call :avs_interlacebefore_privew "%~1"
    rem # Trim���ȉ��A�v���r���[�p�t�B���^��`
    call :preview_setting_filter "%~1"
    rem # �ҏW����͗pavs�t�@�C���o��^(�����t��^)
    call :edit_analyze_filter "%~1">> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
    rem # �����߃��S�����֐�avs�t�@�C���o��^(��t�@�C��^)
    call :eraselogo_filter> "%work_dir%%main_project_name%\avs\EraseLogo.avs"
)
rem # �r�f�I�G���R�[�h�ݒ�
call :Video_Encoding_phase "%~1"
rem # ��������(avs2wav�`FakeAacWav/neroAacEnc�`mp4creator60)
echo.
echo ### �������� ###
call :audio_Encoding_select "%~1"
rem # �f�W�^�������̎������o(Caption2Ass_mod1~SrtSync/"[�O:"�`�F�b�N)
if not "%~x1"==".dv" (
    call :srt_edit "%~1"
)
rem # �f���������̑��̍���(L-SMASH)�A����яo�͐�f�B���N�g���ւ̈ړ�
call :mux_option_selector
rem # ��Ɨp�̃\�[�X�t�@�C������ѕs�v�Ȉꎞ�t�@�C���̍폜
echo rem # ��Ɨp�̃\�[�X�t�@�C������ѕs�v�Ȉꎞ�t�@�C���̍폜�t�F�[�Y>> "%main_bat_file%"
call :del_tmp_files
rem # �p�����[�^�[�t�@�C���쐬
call :make_parameterfile_phase "%src_file_path%"
rem # �I�����ԋL�q
call :last_order "%~1"
echo %main_bat_file%>> "%encode_catalog_list%"
goto :parameter_shift
rem =============== ���C���[���֐��I�� ===============

rem # �e��ϐ��ݒ�
rem ---------- �������� ----------
rem �߂�ǂ������̂�d2v����̓T�u�t�@�C�����Œ�
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
rem ---------- �����܂� ----------

:bat_workdir_detect
rem # �o�b�`���[�h�ł̃v���W�F�N�g��ƃt�H���_�w��
if exist "%~1" (
    set work_dir=%~1
) else (
    set error_message=Directory not exist! : %~1
    goto :error
)
exit /b

:bat_out_dir_detect
rem # �ŏI�o�͐�f�B���N�g���̐�΃p�X�w��
if exist "%~1" (
    set out_dir_1st=%~1
) else (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b

:bat_vencoder_detect
rem # �o�b�`���[�h�ł̃r�f�I�G���R�[�_�[�w��
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
rem # �o�b�`���[�h�ł̃r�f�I�G���R�[�_�[CRF�l�̎w��
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
rem # �o�b�`���[�h�ł�MPEG2�f�R�[�_�[�̎w��
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
rem # �o�b�`���[�h�ł̃I�[�f�B�I�����̎w��
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
rem # �o�b�`���[�h�ł̉�ʉ𑜓x���T�C�Y�̎w��
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
rem # �o�b�`���[�h�ł̃��T�C�Y�A���S���Y���̎w��
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
rem # �o�b�`���[�h�ł�AVS�e���v���[�g�t�@�C���̎w��
if exist "%~1" (
    call :set_avstemplate_file_full-path "%~1"
) else (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b

:set_avstemplate_file_full-path
rem # �o�b�`���[�h�Ŏw�肵��AVS�e���v���[�g�t�@�C���ւ̃t���p�X��ϐ��֊i�[���܂�
set avs_main_template=%~1
exit /b

:bat_Logofile_detect
rem # �o�b�`���[�h�ł̃��S�t�@�C��(.lgd)�̎w��
if exist "%~1" (
    call :set_lgd_file_full-path "%~1"
) else (
    set error_message=Invalid value "%~1" !
    goto :error
)
exit /b

:set_lgd_file_full-path
rem # �o�b�`���[�h�Ŏw�肵�����S�t�@�C���ւ̃t���p�X��ϐ��֊i�[���܂�
set bat_lgd_file_path=%~1
exit /b

:bat_JLtemplate_detect
rem # JL�t�@�C���̎w��
if exist "%~1" (
    call :set_JLtemplate_file_full-path "%~1"
) else (
    set error_message=Do not exist "%~1" !
    goto :error
)
exit /b

:set_JLtemplate_file_full-path
rem # �o�b�`���[�h�Ŏw�肵��JL�e���v���[�g�t�@�C���ւ̃t���p�X��ϐ��֊i�[���܂�
set JL_src_file_full-path=%~1
exit /b

:bat_deintfilter_detect
rem # �f�C���^�[���[�X�����̎w��
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
rem # JL�t���O�w��
set JL_custom_flag=%~1
exit /b

rem # JL�t���O�w��
set JL_custom_flag=%~1
exit /b

:bat_autovfr_detect
rem # AutoVfr�����̎w��
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
rem # AutoVfr.ini �ւ̃t���p�X��ϐ��֊i�[���܂�
if exist "%~1" (
    call :set_autovfrini_file_full-path "%~1"
) else (
    set error_message=Do not exist "%~1" !
    goto :error
)
exit /b

:set_autovfrini_file_full-path
rem # �o�b�`���[�h�Ŏw�肵��AutoVfr.ini�t�@�C���ւ̃t���p�X��ϐ��֊i�[���܂�
set autovfrini_path=%~1
exit /b

:bat_tssplitter_options_detect
rem # TsSplitter�̃I�v�V������ϐ��֊i�[���܂�
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
rem # ���ѓ��̕\���O�̈��Crop�w��
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
rem # ���s���O�ɎQ�Ƃ���p�����[�^�[�t�@�C�����쐬
rem # �I�v�V�����̕��ю���ł͍Ō��1���������_�C���N�g�\�L�Ɖ��߂���Ă��܂��̂ő΍�
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
rem # ���`�������ʂ̕����񂪋󂾂����ꍇ�͉������Ȃ�
echo rem # Trim������̐��`�t�F�[�Y>>"%main_bat_file%"
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
echo rem # �G���R�[�h�c�[�����܂Ƃ߂��f�B���N�g�����������ϐ�ENCTOOLSROOTPATH����`����Ă��邩�m�F
echo call :toolsdircheck
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o
echo call :project_name_check
echo.
echo rem # �e����s�t�@�C����Windows�W���R�}���h�Q�̂݁B
echo.
echo :main
echo rem //----- main�J�n -----//
echo title %%project_name%%
echo echo Trim���𐮌`���Ă��܂�. . .[%%date%% %%time%%]
echo if not exist "trim_line.txt" ^(
echo     echo ### ��s�ŕ\�L����Trim�R�}���h�͂����ɋL�����Ă������� ###^> "trim_line.txt"
echo ^)
echo if not exist "trim_multi.txt" ^(
echo     echo ### �����s�ŕ\�L����Trim�R�}���h�͂����ɋL�����Ă������� ###^> "trim_multi.txt"
echo ^)
echo set trim_detect=
echo rem # "trim_line.txt"����P��s�𒊏o^(���s������ꍇ�P��s�ɂ܂Ƃ߂�^)
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%Q in ^(`findstr /r Trim^^^(.*^^^) "trim_line.txt"`^) do ^(
echo     call :trim_line_join "%%%%Q"
echo ^)
echo rem # "trim_line.txt"����L���ȕ����񂪒��o�ł����ꍇ�A\�������폜���������œ��e��"trim_chars.txt"�փR�s�[����
echo if not "%%trim_detect%%"=="" ^(
echo     call :trim_line_parser
echo     call :trimchar_export
echo ^)
echo rem # "trim_multi.txt"���畡���s���o
echo if not "%%trim_detect:~0,4%%"=="Trim" ^(
echo     call :conv_multi2char
echo ^)
echo rem # "main.avs"����Trim�s^(�P��^����^)�𒊏o
echo if not "%%trim_detect:~0,4%%"=="Trim" ^(
echo     call :conv_mainline2char
echo ^)
echo rem # "preview1_straight.avs"����Trim�s^(�P��^����^)�𒊏o
echo if not "%%trim_detect:~0,4%%"=="Trim" ^(
echo     call :conv_prev1line2char
echo ^)
echo rem # Trim�s�����o�����Ώ����I��
echo if "%%trim_detect:~0,4%%"=="Trim" ^(
echo     call :show_trim_chars
echo ^) else ^(
echo     call echo Trim�͌��o����܂���ł����B
echo ^)
echo rem # �����񒊏o�I��
echo title �R�}���h �v�����v�g
echo rem //----- main�I�� -----//
echo echo end %%~nx0 bat job...
echo echo.
echo exit /b
echo.
rem ------------------------------
echo :trim_line_join
echo echo "trim_line.txt"�Ō��o�F%%~^1
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
echo     echo ���ϐ� ENCTOOLSROOTPATH ������`�ł�
echo     exit /b
echo ^)
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\
echo if exist "%%ENCTOOLSROOTPATH%%" ^(
echo     exit /b
echo ^) else ^(
echo     echo ���ϐ�ENCTOOLSROOTPATH���L���ȃp�X�ł͂���܂���
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
echo     echo "trim_multi.txt"����Trim���𒊏o���܂�
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
echo     echo "main.avs"��Trim�s�͌��o����܂���ł���
echo ^) else if "%%main_count%%"=="1" ^(
echo     echo "main.avs"�ōŏ��Ɍ��o���ꂽTrim�s���g�p���܂�
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
echo     echo "main.avs"�ɕ����s��Trim�����o����܂���
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
echo     echo "preview1_straight.avs"��Trim�s�͌��o����܂���ł���
echo ^) else if "%%prev1_count%%"=="1" ^(
echo     echo "preview1_straight.avs"�ōŏ��Ɍ��o���ꂽTrim�s���g�p���܂�
echo     call :trimchar_export
echo ^) else ^(
echo     call :conv_prev1multi2char
echo ^)
echo if not "%%prev1_count%%"=="0" ^(
echo     if "%%main_count%%"=="0" ^(
echo         echo "main.avs"��Trim�s�����o����Ȃ������ׁA�����"preview1_straight.avs"�̓��e��"trim_line.txt"��Trim�s���R�s�[���܂�
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
echo     echo "preview1_straight.avs"�ɕ����s��Trim�����o����܂���
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
echo echo # �\�[�X�ɑ΂��Ă�Trim���f�����o^> "trim_chars.txt"
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
echo echo Trim���F%%trim_detect%%
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
rem # logoframe, chapter_exe, join_logo_scp�𕹗p���������߃��S�̏����⎩��CM�J�b�g�̏������쐬���܂�
rem main�o�b�`�ւ̓o�^���
echo rem # �����߃��S������CM�J�b�g��̓t�F�[�Y>>"%main_bat_file%"
echo call ".\bat\logoframe_chapter_scan.bat">>"%main_bat_file%"
echo.>>"%main_bat_file%"
type nul > "%work_dir%%main_project_name%\avs\Auto_Vfr.avs"
rem �T�u���[�`���o�b�`�̓o�^���
rem ------------------------------
(
echo @echo off
echo setlocal
echo echo start %%~nx0 bat job...
echo chdir /d %%~dp0..\
echo.
echo rem # �G���R�[�h�c�[�����܂Ƃ߂��f�B���N�g�����������ϐ�ENCTOOLSROOTPATH����`����Ă��邩�m�F
echo call :toolsdircheck
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o
echo call :project_name_check
echo rem # parameter�t�@�C�����̓��ߐ����S�t�B���^�������p�����[�^�[^(disable_delogo^)�����o
echo call :disable_delogo_status_check
echo rem # parameter�t�@�C�����̎���CM�J�b�g�������p�����[�^�[^(disable_cmcutter^)�����o
echo call :disable_cmcutter_status_check
echo rem # parameter�t�@�C������lgd�t�@�C���������o
echo call :lgd_file_name_check
echo rem # parameter�t�@�C������JL�t�@�C���������o
echo call :JL_file_name_check
echo rem # parameter�t�@�C������JL�t���O�����o
echo call :JL_custom_flag_check
echo rem # parameter�t�@�C������chapter_exe�I�v�V�����p�����[�^�[�����o
echo call :chapter_exe_option_check
echo rem # �eAVS�t�@�C���̒�����L����Trim�s���܂܂�Ă��Ȃ������o
echo call :total_trim_line_check
echo rem # EraseLogo.avs �̃t�@�C���T�C�Y�����o
echo call :eraselogo_avs_filesize_check ".\avs\EraseLogo.avs"
echo.
echo rem # �e���s�t�@�C�������݂��邩�m�F�B���݂��Ȃ��ꍇENCTOOLSROOTPATH������T������A�������̓V�X�e���̒T���p�X�Ɉς˂�
echo if exist "%logoframe_path%" ^(set logoframe_path=%logoframe_path%^) else ^(call :find_logoframe "%logoframe_path%"^)
echo if exist "%chapter_exe_path%" ^(set chapter_exe_path=%chapter_exe_path%^) else ^(call :find_chapter_exe "%chapter_exe_path%"^)
echo if exist "%join_logo_scp_path%" ^(set join_logo_scp_path=%join_logo_scp_path%^) else ^(call :find_join_logo_scp "%join_logo_scp_path%"^)
echo.
echo rem # �e����s�t�@�C���ւ̃p�X���A�ŏI�I�ɂǂ̂悤�Ȓl�ɂȂ������m�F�B
echo echo logoframe    : %%logoframe_path%%
echo echo chapter_exe  : %%chapter_exe_path%%
echo echo join_logo_scp: %%join_logo_scp_path%%
echo.
echo :main
echo rem //----- main�J�n -----//
echo title %%project_name%%
echo echo ���S��CM�J�b�g�Ɋւ��鏈���H�������s���܂�. . .[%%date%% %%time%%]
echo rem # logoframe���s�̃T�u���[�`���Ăяo��
echo call :logoframe_subroutine
echo if "%%trim_line_counter%%"=="0" ^(
echo     rem # chapter_exe���s�̃T�u���[�`���Ăяo��
echo     call :chapter_exe_subroutine
echo     rem # join_logo_scp���s�̃T�u���[�`���Ăяo��
echo     call :join_logo_scp_subroutine
echo ^) else ^(
echo     echo Trim�����ɑ}������Ă��܂��A����CM�J�b�g�͕K�v����܂���
echo ^)
echo rem # �`���v�^�[�t�@�C������������
echo call :make_chapfile_subroutine
echo title �R�}���h �v�����v�g
echo rem //----- main�I�� -----//
echo echo end %%~nx0 bat job...
echo echo.
echo exit /b
echo.
rem ------------------------------
echo :logoframe_subroutine
echo pushd avs
echo if not exist "%%lgd_file_path%%" ^(
echo     echo .lgd �t�@�C�������o�ł��܂���B�����𑱂��邱�Ƃ��o���Ȃ��ׁAlogoframe�̏����𒆒f���܂��B
echo     popd
echo     exit /b
echo ^)
echo popd
echo rem # logoframe�����s���邽�߂̃T�u���[�`���ł�
echo if not exist ".\log\logoframe_log.txt" ^(
echo     echo logoframe_log.txt�����݂��܂���
echo     if "%%eraselogo_avs_filesize%%"=="0" ^(
echo         echo EraseLogo.avs�ɗL���Ȓl���}������Ă��܂���B
echo         if not "%%disable_delogo%%"=="1" ^(
echo             echo �����߃��S�����͗L���ł�
echo             echo logoframe�����s���܂�^^^(avs+log^^^)...[%%date%% %%time%%]
echo             call :run_logoframe_all
echo         ^) else ^(
echo             echo �����߃��S�����͖����ł�
echo             if not "%%trim_line_counter%%"=="0" ^(
echo                 echo Trim�����ɑ}������Ă��܂��Alogoframe�͎��s���܂���
echo             ^) else ^(
echo                 if not "%%disable_cmcutter%%"=="1" ^(
echo                     echo ����CM�J�b�g�͗L���ł��Alogoframe�����s���܂�^^^(log^^^)...[%%date%% %%time%%]
echo                     call :run_logoframe_log
echo                 ^) else ^(
echo                     echo ����CM�J�b�g�͖����ł��Alogoframe�͎��s���܂���
echo                 ^)
echo             ^)
echo         ^)
echo     ^) else ^(
echo         echo EraseLogo.avs�͗L���ł��A�����߃��S����������܂��B
echo         if not "%%trim_line_counter%%"=="0" ^(
echo             echo Trim�����ɑ}������Ă��܂��Alogoframe�͎��s���܂���
echo         ^) else ^(
echo             if not "%%disable_cmcutter%%"=="1" ^(
echo                 echo ����CM�J�b�g�͗L���ł��Alogoframe�����s���܂�^^^(log^^^)...[%%date%% %%time%%]
echo                 call :run_logoframe_log
echo             ^) else ^(
echo                 echo ����CM�J�b�g�͖����ł��Alogoframe�͎��s���܂���
echo             ^)
echo         ^)
echo     ^)
echo ^) else ^(
echo     echo logoframe_log.txt�����݂��Ă��܂�
echo     if "%%eraselogo_avs_filesize%%"=="0" ^(
echo         echo EraseLogo.avs�ɗL���Ȓl���}������Ă��܂���B
echo         if not "%%disable_delogo%%"=="1" ^(
echo             echo �����߃��S�����͗L���ł��Alogoframe�����s���܂�^^^(avs+log��logoframe_log.txt�͏㏑������܂�^^^)...[%%date%% %%time%%]
echo             call :run_logoframe_all
echo         ^) else ^(
echo             echo �����߃��S�����͖����ł��Alogoframe�͎��s���܂���
echo         ^)
echo     ^) else ^(
echo         echo EraseLogo.avs�͗L���ł��A�����߃��S����������܂��Blogoframe �����͕s�v�ׁ̈A�X�L�b�v���܂��B
echo     ^)
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :run_logoframe_all
echo rem # EraseLogo.avs �ɏ�ʂ̑��΃p�X���L�����邽�߂ɁA�ꎞ�I�ɍ�ƃt�H���_�ړ�^(log�̂ݍ쐬�̏ꍇ�A�{���͕s�v^)
echo pushd avs
echo "%%logoframe_path%%" -outform 1 ".\edit_analyze.avs" -logo "%%lgd_file_path%%" -oa "..\log\logoframe_log.txt" -o ".\EraseLogo.avs"
echo popd
echo exit /b
echo.
rem ------------------------------
echo :run_logoframe_log
echo rem # EraseLogo.avs �ɏ�ʂ̑��΃p�X���L�����邽�߂ɁA�ꎞ�I�ɍ�ƃt�H���_�ړ�^(log�̂ݍ쐬�̏ꍇ�A�{���͕s�v^)
echo pushd avs
echo "%%logoframe_path%%" -outform 1 ".\edit_analyze.avs" -logo "%%lgd_file_path%%" -oa "..\log\logoframe_log.txt"
echo popd
echo exit /b
echo.
rem ------------------------------
echo :chapter_exe_subroutine
echo pushd avs
echo if not exist "%%lgd_file_path%%" ^(
echo     echo .lgd �t�@�C�������o�ł��܂���B�����𑱂��邱�Ƃ��o���Ȃ��ׁAchapter_exe�̏����𒆒f���܂��B
echo     popd
echo     exit /b
echo ^)
echo popd
echo if not "%%disable_cmcutter%%"=="1" ^(
echo     echo ����CM�J�b�g�͗L���ł��Achapter_exe�����s���܂�...[%%date%% %%time%%]
echo     call :run_chapter_exe_log
echo ^) else ^(
echo     echo ����CM�J�b�g�͖����ł��Achapter_exe�͎��s���܂���
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
echo rem # comskip�̃��[�`������ň����p������
echo if not exist "%%JL_file_path%%" ^(
echo     echo JL �t�@�C�������o�ł��܂���B�����𑱂��邱�Ƃ��o���Ȃ��ׁAjoin_logo_scp�̏����𒆒f���܂��B
echo     exit /b
echo ^)
echo if not exist ".\log\logoframe_log.txt" ^(
echo     echo logoframe_log.txt ��������܂���Ajoin_logo_scp �𒆒f���܂�
echo ^) else if not exist ".\log\chapter_exe_log.txt" ^(
echo     echo chapter_exe_log.txt ��������܂���Ajoin_logo_scp �𒆒f���܂�
echo ^) else ^(
echo     if not "%%disable_cmcutter%%"=="1" ^(
echo         echo ����CM�J�b�g�͗L���ł��Ajoin_logo_scp�����s���܂�...[%%date%% %%time%%]
echo         call :run_join_logo_scp_log
echo     ^) else ^(
echo         echo ����CM�J�b�g�͖����ł��Ajoin_logo_scp�͎��s���܂���
echo     ^)
echo ^)
echo rem # trim_chars.txt �ɗL����Trim�s���܂܂�Ă��Ȃ����ŏI�`�F�b�N�A�܂܂�Ă��Ȃ����join_logo_scp�̏o�͌��ʂ��}�[�W����
echo set trim_chars_txt_counter=^0
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%T in ^(`findstr /R Trim^^^(.*^^^) "trim_chars.txt"`^) do ^(
echo     set /a trim_chars_txt_counter=trim_chars_txt_counter+^1
echo ^)
echo if not "%%trim_chars_txt_counter%%"=="0" ^(
echo     echo trim_chars.txt �ɂ͊��ɗL����Trim���܂܂�Ă��܂��A�N���A���Ă��� join_logo_scp �̏o�͌��ʂ��}�[�W���܂�
echo     echo # �\�[�X�ɑ΂��Ă�Trim���f�����o^> "trim_chars.txt"
echo ^) else ^(
echo     echo join_logo_scp �̏o�͌��ʂ��Atrim_chars.txt �Ƀ}�[�W���܂�
echo ^)
echo if not exist ".\tmp\join_logo_scp_out.txt" ^(
echo     echo join_logo_scp_out.txt ��������܂���A�}�[�W���X�L�b�v���܂�
echo ^) else ^(
echo     echo # join_logo_scp generated.^>^> ".\trim_chars.txt"
echo     copy /b ".\trim_chars.txt" + ".\tmp\join_logo_scp_out.txt" ".\trim_chars.txt"
echo     rem # main.avs/trim_line.txt/trim_multi.txt �ɗL����Trim�s���܂܂�Ă��Ȃ��ꍇ���Ajoin_logo_scp�̏o�͌��ʂ��}�[�W����
echo     if "%%trim_line_counter%%"=="0" ^(
echo         echo join_logo_scp �̏o�͌��ʂ��Atrim_line.txt �Ƀ}�[�W���܂�
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
echo                 echo join_logo_scp�̏o�̓��O��p���ă`���v�^�[�t�@�C���������������܂�
echo                 echo cscript //nologo ".\bat\func_chapter_jls.vbs" cut ".\tmp\join_logo_scp_out.txt" ".\log\obs_jlscp.txt"
echo                 cscript //nologo ".\bat\func_chapter_jls.vbs" cut ".\tmp\join_logo_scp_out.txt" ".\log\obs_jlscp.txt"^> ".\obs_jlscp.chapter.txt"
echo             ^)
echo         ^)
echo     ^) else ^(
echo         echo �`���v�^�[�t�@�C�������ɑ��݂��邽�߁A���������͎��{���܂���
echo     ^)
echo ^) else ^(
echo     echo �`���v�^�[�t�@�C�������ɑ��݂��邽�߁A���������͎��{���܂���
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :total_trim_line_check
echo rem # �L����Trim�s���܂܂�Ă��Ȃ����`�F�b�N�A�܂܂�Ă����ꍇ���ɕҏW�ς݂Ɣ��f���㑱�̏������X�L�b�v����
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
echo echo EraseLogo.avs �t�@�C���T�C�Y�F%%eraselogo_avs_filesize%%
echo exit /b
echo.
rem ------------------------------
echo :toolsdircheck
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo ���ϐ� ENCTOOLSROOTPATH ������`�ł�
echo     exit /b
echo ^)
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\
echo if exist "%%ENCTOOLSROOTPATH%%" ^(
echo     exit /b
echo ^) else ^(
echo     echo ���ϐ�ENCTOOLSROOTPATH���L���ȃp�X�ł͂���܂���
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
echo     echo .lgd �t�@�C��������ł�
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
echo     echo JL �t�@�C��������ł�
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
echo     echo JL�t���O�͖��ݒ�ł�
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
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set logoframe_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :logoframe_env_search "%%~nx1"
echo exit /b
echo :logoframe_env_search
echo set logoframe_path=%%~$PATH:1
echo if "%%logoframe_path%%"=="" ^(
echo     echo logoframe��������܂���
echo     set logoframe_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_chapter_exe
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set chapter_exe_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :chapter_exe_env_search "%%~nx1"
echo exit /b
echo :chapter_exe_env_search
echo set chapter_exe_path=%%~$PATH:1
echo if "%%chapter_exe_path%%"=="" ^(
echo     echo chapter_exe��������܂���
echo     set chapter_exe_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_join_logo_scp
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set join_logo_scp_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :join_logo_scp_env_search "%%~nx1"
echo exit /b
echo :join_logo_scp_env_search
echo set join_logo_scp_path=%%~$PATH:1
echo if "%%join_logo_scp_path%%"=="" ^(
echo     echo join_logo_scp��������܂���
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
echo ' Trim�t�@�C����join_logo_scp�\����̓t�@�C������`���v�^�[��W���o�͂ɏo��
echo ' �����P�F�i���́j�o�̓`���v�^�[�`���iorg cut tvtplay tvtcut�j
echo ' �����Q�F�i���́jTrim�t�@�C����
echo ' �����R�F�i���́jjoin_logo_scp�\����̓t�@�C����
echo.
echo Option Explicit
echo.
echo '--------------------------------------------------
echo ' �萔
echo '--------------------------------------------------
echo const PREFIX_TVTI = "ix"     ' �J�b�g�J�n��������itvtplay�p�j
echo const PREFIX_TVTO = "ox"     ' �J�b�g�I����������itvtplay�p�j
echo const PREFIX_ORGI = ""       ' �J�b�g�J�n��������i�J�b�g�Ȃ�chapter�j
echo const PREFIX_ORGO = ""       ' �J�b�g�I����������i�J�b�g�Ȃ�chapter�j
echo const PREFIX_CUTO = ""       ' �J�b�g�I����������i�J�b�g��j
echo const SUFFIX_CUTO = ""       ' �J�b�g�I���������ǉ�������i�J�b�g��j
echo.
echo const MODE_ORG = 0
echo const MODE_CUT = 1
echo const MODE_TVT = 2
echo const MODE_TVC = 3
echo.
echo const MSEC_DIVMIN = 100      ' �`���v�^�[�ʒu�𓯈�Ƃ��Ȃ����ԊԊu�imsec�P�ʁj
echo.
echo '--------------------------------------------------
echo ' �����ǂݍ���
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
echo '--- �o�͌`�� ---
echo If StrComp^(strFormat, "cut"^) = 0 Then           '�J�b�g���chapter
echo   nOutFormat = MODE_CUT
echo ElseIf StrComp^(strFormat, "tvtplay"^) = 0 Then   '�J�b�g���Ȃ�TvtPlay
echo   nOutFormat = MODE_TVT
echo ElseIf StrComp^(strFormat, "tvtcut"^) = 0 Then    '�J�b�g���TvtPlay
echo   nOutFormat = MODE_TVC
echo Else                                            '�J�b�g���Ȃ�chapter
echo   nOutFormat = MODE_ORG
echo End If
echo.
echo '--------------------------------------------------
echo ' Trim�ɂ��J�b�g���ǂݍ���
echo ' �ǂݍ��݃f�[�^�B�J�n�ʒu��\�����ߏI���ʒu�ł́{�P����B
echo ' nTrimTotal  : Trim�ʒu��񍇌v�iTrim�P�ɂ��i�J�n,�I���j�łQ�j
echo ' nItemTrim^(^) : Trim�ʒu���i�P�ʂ̓t���[���j
echo '--------------------------------------------------
echo '--- ���ʕϐ� ---
echo Dim objFileSystem, objStream
echo Dim strBufRead
echo Dim i
echo Dim re, matches
echo Set re = New RegExp
echo re.Global = True
echo.
echo '--- �t�@�C���ǂݍ��� ---
echo Set objFileSystem = WScript.CreateObject^("Scripting.FileSystemObject"^)
echo If Not objFileSystem.FileExists^(strFile1^) Then
echo   WScript.StdErr.WriteLine "�t�@�C����������܂���:" ^& strFile1
echo   WScript.Quit
echo End If
echo Set objStream = objFileSystem.OpenTextFile^(strFile1^)
echo strBufRead = objStream.ReadLine
echo.
echo '--- trim�p�^�[�� ---
echo Const strRegTrim = "Trim\((\d+)\,(\d+)\)"
echo '--- �p�^�[���}�b�` ---
echo re.Pattern = strRegTrim
echo Set matches = re.Execute^(strBufRead^)
echo If matches.Count = 0 Then
echo   WScript.StdErr.WriteLine "Trim�f�[�^���ǂݍ��߂܂���:" ^& strBufRead
echo   WScript.Quit
echo End If
echo.
echo '--- �f�[�^�ʌ��� ---
echo Dim nTrimTotal
echo nTrimTotal = matches.Count * 2
echo.
echo '--- �ϐ��Ɋi�[ ---
echo ReDim nItemTrim^(nTrimTotal^)
echo For i=0 To nTrimTotal/2 - 1
echo   nItemTrim^(i*2^)   = CLng^(matches^(i^).SubMatches^(0^)^)
echo   nItemTrim^(i*2+1^) = CLng^(matches^(i^).SubMatches^(1^)^) + 1
echo Next
echo Set matches = Nothing
echo.
echo '--- �t�@�C���N���[�Y ---
echo objStream.Close
echo Set objStream = Nothing
echo Set objFileSystem  = Nothing
echo.
echo '--------------------------------------------------
echo ' �\����̓t�@�C���ƃJ�b�g��񂩂�CHAPTER���쐬
echo '--------------------------------------------------
echo '--- CHAPTER���擾�ɕK�v�ȕϐ� ---
echo Dim clsChapter
echo Dim bCutOn, bShowOn, bShowPre, bPartExist
echo Dim nTrimNum, nType, nLastType, nPart
echo Dim nFrmTrim, nFrmSt, nFrmEd, nFrmMgn, nFrmBegin
echo Dim nSecRd, nSecCalc
echo Dim strCmt, strChapterName, strChapterLast
echo.
echo '--- CHAPTER���i�[�p�N���X ---
echo Set clsChapter = New ChapterData
echo.
echo '--- �t�@�C���I�[�v�� ---
echo Set objFileSystem = WScript.CreateObject^("Scripting.FileSystemObject"^)
echo If Not objFileSystem.FileExists^(strFile2^) Then
echo   WScript.StdErr.WriteLine "�t�@�C����������܂���:" ^& strFile2
echo   WScript.Quit
echo End If
echo Set objStream = objFileSystem.OpenTextFile^(strFile2^)
echo.
echo '--- trim�p�^�[�� ---
echo Const strRegJls  = "^\s*(\d+)\s+(\d+)\s+(\d+)\s+([-\d]+)\s+(\d+).*:(\S+)"
echo '--- �����ݒ� ---
echo re.Pattern = strRegJls
echo nFrmMgn    = 30          ' Trim�Ɠǂݍ��ݍ\���𓯂��ʒu�Ƃ݂Ȃ��t���[����
echo bShowOn    = 1           ' �ŏ��͕K���\��
echo nTrimNum   = 0           ' ���݂�Trim�ʒu�ԍ�
echo nFrmTrim   = 0           ' ���݂�Trim�t���[��
echo nLastType  = 0           ' ���O��ԃN���A
echo nPart      = 0           ' ������Ԃ�A�p�[�g
echo bPartExist = 0           ' ���݂̃p�[�g�͑��݂Ȃ�
echo nFrmBegin  = 0           ' ����chapter�J�n�n�_
echo.
echo '--- �J�n�n�_�ݒ� ---
echo ' nTrimNum �������F����Trim�J�n�ʒu������
echo ' nTrimNum ����F����Trim�I���ʒu������
echo If ^(nTrimTotal ^> 0^) Then
echo   If ^(nItemTrim^(0^) ^<= nFrmMgn^) Then  ' �ŏ��̗����オ���0�t���[���Ɠ��ꎋ
echo     nTrimNum   = 1
echo   End If
echo Else
echo   nTrimNum   = 1
echo End If
echo.
echo '--- �\�����f�[�^�����Ԃɓǂݏo�� ---
echo Do While objStream.AtEndOfLine = false
echo   strBufRead = objStream.ReadLine
echo   Set matches = re.Execute^(strBufRead^)
echo   If matches.Count ^> 0 Then
echo     '--- �ǂݏo���f�[�^�i�[ ---
echo     nFrmSt = CLng^(matches^(0^).SubMatches^(0^)^)     ' �J�n�t���[��
echo     nFrmEd = CLng^(matches^(0^).SubMatches^(1^)^)     ' �I���t���[��
echo     nSecRd = matches^(0^).SubMatches^(2^)           ' ���ԕb��
echo     strCmt = matches^(0^).SubMatches^(5^)           ' �\���R�����g
echo     '--- ���݌�������Trim�ʒu�f�[�^�擾 ---
echo     If nTrimNum ^< nTrimTotal Then
echo       nFrmTrim = nItemTrim^(nTrimNum^)
echo     End If
echo.
echo     '--- ���\���I���ʒu����O��Trim�n�_������ꍇ�̐ݒ菈�� ---
echo     Do While nFrmTrim ^< nFrmEd - nFrmMgn And nTrimNum ^< nTrimTotal
echo       bCutOn  = ^(nTrimNum+1^) Mod 2              ' Trim�̃J�b�g��ԁi�P�ŃJ�b�g�j
echo       '--- CHAPTER������擾���� ---
echo       nType = ProcChapterTypeTerm^(nSecCalc, nFrmBegin, nFrmTrim^)
echo       strChapterName = ProcChapterName^(bCutOn, nType, nPart, bPartExist, nSecCalc^)
echo       '--- CHAPTER�}������ ---
echo       Call clsChapter.InsertFrame^(nFrmBegin, bCutOn, strChapterName^)
echo       nFrmBegin = nFrmTrim                      ' chapter�J�n�ʒu�ύX
echo       nTrimNum = nTrimNum + 1                   ' Trim�ԍ������Ɉڍs
echo       If nTrimNum ^< nTrimTotal Then
echo         nFrmTrim = nItemTrim^(nTrimNum^)          ' ����Trim�ʒu�����ɕύX
echo       End If
echo     Loop
echo.
echo     '--- ���\���ʒu�̔��f�J�n ---
echo     bShowPre = 0
echo     bShowOn = 0
echo     bCutOn  = ^(nTrimNum+1^) Mod 2                ' Trim�̃J�b�g��ԁi�P�ŃJ�b�g�j
echo     '--- ���I���ʒu��Trim�n�_�����邩���f�i�����CHAPTER�\���m��j ---
echo     If ^(nFrmTrim ^<= nFrmEd + nFrmMgn^) And ^(nTrimNum ^< nTrimTotal^) Then
echo       nFrmEd  = nFrmTrim              ' Trim�ʒu�Ƀt���[����ύX
echo       bShowOn = 1                     ' �\�����s��
echo       nTrimNum = nTrimNum + 1         ' Trim�ʒu�����Ɉڍs
echo     End If
echo.
echo     '--- �R�����g����CHAPTER�\����ނ𔻒f ---
echo     ' nType 0:�X���[ 1:CM���� 10:�Ɨ��\�� 11:part�����ɂ��Ȃ��Ɨ��\��
echo     nType = ProcChapterTypeCmt^(strCmt, nSecRd^)
echo     '--- CHAPTER��؂���m�F�i�O��ƍ���̍\���ŋ�؂邩���f�j ---
echo     If bCutOn ^<^> 0 Then                  ' �J�b�g���镔��
echo       If nType = 1 Then                  ' �����I��CM��
echo         If nLastType ^<^> 1 Then           ' �O��CM�ȊO�������ꍇ�\��
echo           bShowPre = 1                   ' �O��I���i����J�n�j��chapter�\��
echo         End If
echo       Else                               ' �����I��CM�ȊO
echo         If nLastType = 1 Then            ' �O��CM�������ꍇ�\��
echo           bShowPre = 1                   ' �O��I���i����J�n�j��chapter�\��
echo         End If
echo       End If
echo     End If
echo.
echo     '--- CHAPTER�}���i�O��I���ʒu�j ---
echo     If bShowPre ^> 0 Or nType ^>= 10 Then      ' �ʒu�m��̃t���O�m�F
echo       If nFrmBegin ^< nFrmSt - nFrmMgn Then   ' chapter�J�n�ʒu������J�n���O
echo         If nLastType ^<^> 1 Then               ' �O��CM�ȊO�̎��͎�ލĊm�F
echo           nLastType = ProcChapterTypeTerm^(nSecCalc, nFrmBegin, nFrmSt^)
echo         End If
echo         '--- CHAPTER������������肵�}�� ---
echo         strChapterLast = ProcChapterName^(bCutOn, nLastType, nPart, bPartExist, nSecCalc^)
echo         Call clsChapter.InsertFrame^(nFrmBegin, bCutOn, strChapterLast^)
echo         nFrmBegin = nFrmSt                   ' chapter�J�n�ʒu������J�n�ʒu��
echo       End If
echo     End If
echo     '--- CHAPTER�}���i���I���ʒu�j ---
echo     If bShowOn ^> 0 Or nType ^>= 10 Then
echo       If nFrmEd ^> nFrmBegin + nFrmMgn Then   ' chapter�J�n�ʒu������I�����O
echo         '--- CHAPTER������������肵�}�� ---
echo         strChapterName = ProcChapterName^(bCutOn, nType, nPart, bPartExist, nSecRd^)
echo         Call clsChapter.InsertFrame^(nFrmBegin, bCutOn, strChapterName^)
echo         nFrmBegin = nFrmEd                   ' chapter�J�n�ʒu������I���ʒu��
echo       End If
echo     End If
echo.
echo     '--- ����m�F�p�̏��� ---
echo     nLastType = nType
echo.
echo   End If
echo   Set matches = Nothing
echo Loop
echo.
echo '--- Trim�ʒu�̏o�͊������Ă��Ȃ��ꍇ�̏��� ---
echo Do While nTrimNum ^< nTrimTotal
echo   nFrmTrim = nItemTrim^(nTrimNum^)
echo.
echo   '--- Trim�ʒu��chapter�֏o�� ---
echo   bCutOn  = ^(nTrimNum+1^) Mod 2                   ' Trim�̃J�b�g��ԁi�P�ŃJ�b�g�j
echo   nType = ProcChapterTypeTerm^(nSecCalc, nFrmBegin, nFrmTrim^)
echo   strChapterName = ProcChapterName^(bCutOn, nType, nPart, bPartExist, nSecCalc^)
echo   '--- CHAPTER�}������ ---
echo   Call clsChapter.InsertFrame^(nFrmBegin, bCutOn, strChapterName^)
echo   nTrimNum = nTrimNum + 1                            ' Trim�ԍ������Ɉڍs
echo Loop
echo.
echo '--- �ŏIchapter�̏o�� ---
echo If nFrmBegin ^< nFrmEd - nFrmMgn Then
echo   bCutOn  = ^(nTrimNum+1^) Mod 2                   ' Trim�̃J�b�g��ԁi�P�ŃJ�b�g�j
echo   nType = ProcChapterTypeTerm^(nSecCalc, nFrmBegin, nFrmEd^)
echo   strChapterName = ProcChapterName^(bCutOn, nType, nPart, bPartExist, nSecCalc^)
echo   '--- CHAPTER�}������ ---
echo   Call clsChapter.InsertFrame^(nFrmBegin, bCutOn, strChapterName^)
echo End If
echo.
echo '--- ���ʏo�� ---
echo Call clsChapter.OutputChapter^(nOutFormat^)
echo.
echo '--- �t�@�C���N���[�Y ---
echo objStream.Close
echo Set objStream = Nothing
echo Set objFileSystem  = Nothing
echo.
echo Set clsChapter = Nothing
echo.
echo '--- ���� ---
echo.
echo.
echo '--------------------------------------------------
echo ' Chapter��ނ��擾�i�J�n�I���ʒu����b�����擾����j
echo '   nSecRd : �i�o�́j���ԕb��
echo '   nFrmS  : �J�n�t���[��
echo '   nFrmE  : �I���t���[��
echo '  �o��
echo '   nType  : 0:�ʏ� 1:�����I��CM 2:part�����̔��f�����\��
echo '            10:�P�ƍ\�� 11:part�����̔��f�����P�ƍ\�� 12:��
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
echo ' Chapter��ނ��擾�i�R�����g�����g�p����j
echo '   strCmt : �R�����g������
echo '   nSecRd : �R�����g�̕b��
echo '  �o��
echo '   nType  : 0:�ʏ� 1:�����I��CM 2:part�����̔��f�����\��
echo '            10:�P�ƍ\�� 11:part�����̔��f�����P�ƍ\�� 12:��
echo '--------------------------------------------------
echo Function ProcChapterTypeCmt^(strCmt, nSecRd^)
echo   Dim nType
echo.
echo   '--- CHAPTER�\�����e�����f ---
echo   ' nType  : 0:�ʏ� 1:�����I��CM 2:part�����̔��f�����\��
echo   '          10:�P�ƍ\�� 11:part�����̔��f�����P�ƍ\�� 12:��
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
echo     nType   = 1             ' 15�b�P��CM�Ƃ���ȊO�𕪂���K�v�Ȃ����0�ɂ���
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
echo ' CHAPTER���̕���������߂�
echo '   bCutOn : 0=�J�b�g���Ȃ����� 1=�J�b�g����
echo '   nType  : 0:�ʏ� 1:�����I��CM 2:part�����̔��f�����\��
echo '            10:�P�ƍ\�� 11:part�����̔��f�����P�ƍ\�� 12:��
echo '   nPart  : A�p�[�g���珇�Ԃɐ���0�`�ifunction���ōX�V����j
echo '   bPartExist : part�\���̗v�f�������2�ifunction���ōX�V����j
echo '   nSecRd     : �P�ƍ\�����̕b��
echo ' �߂�l��CHAPTER��
echo '--------------------------------------------------
echo Function ProcChapterName^(bCutOn, nType, nPart, bPartExist, nSecRd^)
echo   Dim strChapterName
echo.
echo   If bCutOn = 0 Then                           ' �c������
echo     strChapterName = Chr^(Asc^("A"^) + ^(nPart Mod 23^)^)
echo     If nType ^>= 10 Then
echo       strChapterName = strChapterName ^& nSecRd ^& "Sec"
echo     Else
echo       strChapterName = strChapterName
echo     End If
echo     If nType = 11 Or nType = 2 Then            ' part�����̔��f�����\��
echo       If bPartExist = 0 Then
echo         bPartExist = 1
echo       End If
echo     ElseIf nType ^<^> 12 Then
echo       bPartExist = 2
echo     End If
echo   Else                                         ' �J�b�g���镔��
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
echo ' �t���[�����ɑΉ�����b���擾
echo '--------------------------------------------------
echo Function ProcGetSec^(nFrame^)
echo   '29.97fps�̐ݒ�ŌŒ�
echo   ProcGetSec = Int^(^(CLng^(nFrame^) * 1001 + 30000/2^) / 30000^)
echo End Function
echo.
echo.
echo '--------------------------------------------------
echo ' CHAPTER�i�[�p�N���X
echo '  InsertMSec     : CHAPTER�ɒǉ��i�~���b�Ŏw��j
echo '  InsertFrame    : CHAPTER�ɒǉ��i�t���[���ʒu�w��j
echo '  OutputChapter  : CHAPTER����W���o�͂ɏo��
echo '--------------------------------------------------
echo Class ChapterData
echo   Private m_nMaxList        ' ���݂̊i�[�ő�
echo   Private m_nList           ' CHAPTER�i�[��
echo   Private m_nMSec^(^)         ' CHAPTER�ʒu�i�~���b�P�ʁj
echo   Private m_bCutOn^(^)        ' 0:�J�b�g���Ȃ��ʒu 1:�J�b�g�ʒu
echo   Private m_strName^(^)       ' �`���v�^�[��
echo   Private m_strOutput       ' �o�͊i�[
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
echo   ' CHAPTER�\���p��������P���쐬�im_strOutput�Ɋi�[�j
echo   ' num     : �i�[chapter�ʂ��ԍ�
echo   ' nCount  : �o�͗pchapter�ԍ�
echo   ' nTime   : �ʒu�~���b�P��
echo   ' strName : chapter��
echo   '------------------------------------------------------------
echo   Private Sub GetDispChapter^(num, nCount, nTime, strName^)
echo     Dim strBuf
echo     Dim strCount, strTime
echo     Dim strHour, strMin, strSec, strMsec
echo     Dim nHour, nMin, nSec, nMsec
echo.
echo     '--- �`���v�^�[�ԍ� ---
echo     strCount = CStr^(nCount^)
echo     If ^(Len^(strCount^) = 1^) Then
echo       strCount = "0" ^& strCount
echo     End If
echo     '--- �`���v�^�[���� ---
echo     nHour = Int^(nTime / ^(60*60*1000^)^)
echo     nMin  = Int^(^(nTime Mod ^(60*60*1000^)^) / ^(60*1000^)^)
echo     nSec  = Int^(^(nTime Mod ^(60*1000^)^)    / 1000^)
echo     nMsec = nTime Mod 1000
echo     strHour = Right^("0" ^& CStr^(nHour^), 2^)
echo     strMin  = Right^("0" ^& CStr^(nMin^),  2^)
echo     strSec  = Right^("0" ^& CStr^(nSec^),  2^)
echo     strMsec = Right^("00" ^& CStr^(nMsec^), 3^)
echo     StrTime = strHour ^& ":" ^& strMin ^& ":" ^& strSec ^& "." ^& strMsec
echo     '--- �o�͕�����i�P�s�ځj ---
echo     strBuf = "CHAPTER" ^& strCount ^& "=" ^& strTime ^& vbCRLF
echo     '--- �o�͕�����i�Q�s�ځj ---
echo     strBuf = strBuf ^& "CHAPTER" ^& strCount ^& "NAME=" ^& strName ^& vbCRLF
echo     m_strOutput = m_strOutput ^& strBuf
echo   End Sub
echo.
echo.
echo   '---------------------------------------------
echo   ' CHAPTER�ɒǉ��i�~���b�Ŏw��j
echo   ' nMSec   : �ʒu�~���b
echo   ' bCutOn  : 1�̎��J�b�g
echo   ' strName : chapter�\���p������
echo   '---------------------------------------------
echo   Public Sub InsertMSec^(nMSec, bCutOn, strName^)
echo     If m_nList ^>= m_nMaxList Then      ' �z�񖞔t���͍Ċm��
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
echo   ' CHAPTER�ɒǉ��i�t���[���ʒu�w��j
echo   ' nFrame  : �t���[���ʒu
echo   ' bCutOn  : 1�̎��J�b�g
echo   ' strName : chapter�\���p������
echo   '---------------------------------------------
echo   Public Sub InsertFrame^(nFrame, bCutOn, strName^)
echo     Dim nTmp
echo     '29.97fps�̐ݒ�ŌŒ�
echo     nTmp = Int^(^(CLng^(nFrame^) * 1001 + 30/2^) / 30^)
echo     Call InsertMSec^(nTmp, bCutOn, strName^)
echo   End Sub
echo.
echo.
echo   '---------------------------------------------
echo   ' CHAPTER����W���o�͂ɏo��
echo   ' nCutType : MODE_ORG / MODE_CUT / MODE_TVT / MODE_TVC
echo   '---------------------------------------------
echo   Public Sub OutputChapter^(nCutType^)
echo     Dim i, inext, nCount
echo     Dim bCutState, bSkip
echo     Dim nSumTime
echo     Dim strName
echo.
echo     nSumTime  = CLng^(0^)      ' ���݂̈ʒu�i�~���b�P�ʁj
echo     nCount    = 1            ' CHAPTER�o�͔ԍ�
echo     bCutState = 0            ' �O��̏�ԁi0:��J�b�g�p 1:�J�b�g�p�j
echo     m_strOutput = ""         ' �o��
echo     '--- tvtplay�p���������� ---
echo     If nCutType = MODE_TVT Or nCutType = MODE_TVC Then
echo       m_strOutput = "c-"
echo     End If
echo.
echo     '--- CHAPTER�ݒ萔�����J��Ԃ� ---
echo     inext = 0
echo     For i=0 To m_nList - 1
echo       '--- ����CHAPTER�Əd�Ȃ��Ă���ꍇ�͏��� ---
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
echo         '--- �S���\�����[�hor�J�b�g���Ȃ��ʒu�̎��ɏo�� ---
echo         If nCutType = MODE_ORG Or nCutType = MODE_TVT Or m_bCutOn^(i^) = 0 Then
echo           '--- �ŏ���0�łȂ����̕␳ ---
echo           If nCutType = MODE_ORG Or nCutType = MODE_TVT Then
echo             If i = 0 And m_nMSec^(i^) ^> 0 Then
echo               nSumTime  = nSumTime + m_nMSec^(i^)
echo             End If
echo           End If
echo           '--- tvtplay�p ---
echo           If nCutType = MODE_TVT Or nCutType = MODE_TVC Then
echo             '--- CHAPTER����ݒ� ---
echo             If nCutType = MODE_TVC Then                    ' �J�b�g�ς�
echo               If bCutState ^> 0 And m_bCutOn^(i^) = 0 Then    ' �J�b�g�I��
echo                 strName = m_strName^(i^) ^& SUFFIX_CUTO
echo               Else
echo                 strName = m_strName^(i^)
echo               End If
echo             ElseIf bCutState = 0 And m_bCutOn^(i^) ^> 0 Then  ' �J�b�g�J�n
echo               strName = PREFIX_TVTI ^& m_strName^(i^)
echo             ElseIf bCutState ^> 0 And m_bCutOn^(i^) = 0 Then  ' �J�b�g�I��
echo               strName = PREFIX_TVTO ^& m_strName^(i^)
echo             Else
echo               strName = m_strName^(i^)
echo             End If
echo             strName = Replace^(strName, "-", "�|"^)
echo             '--- tvtplay�pCHAPTER�o�͕�����ݒ� ---
echo             m_strOutput = m_strOutput ^& nSumTime ^& "c" ^& strName ^& "-"
echo           '--- �ʏ��chapter�p ---
echo           Else
echo             '--- CHAPTER����ݒ� ---
echo             If bCutState = 0 And m_bCutOn^(i^) ^> 0 Then      ' �J�b�g�J�n
echo               strName = PREFIX_ORGI ^& m_strName^(i^)
echo             ElseIf bCutState ^> 0 And m_bCutOn^(i^) = 0 Then  ' �J�b�g�I��
echo               If nCutType = MODE_CUT Then
echo                 strName = PREFIX_CUTO ^& m_strName^(i^) ^& SUFFIX_CUTO
echo               Else
echo                 strName = PREFIX_ORGO ^& m_strName^(i^)
echo               End If
echo             Else
echo               strName = m_strName^(i^)
echo             End If
echo             '--- CHAPTER�o�͕�����ݒ� ---
echo             Call GetDispChapter^(i, nCount, nSumTime, strName^)
echo           End If
echo           '--- �������݌㋤�ʐݒ� ---
echo           nSumTime  = nSumTime + ^(m_nMSec^(inext^) - m_nMSec^(i^)^)
echo           nCount    = nCount + 1
echo         End If
echo         '--- ��CHAPTER�ɏ�ԍX�V ---
echo         bCutState = m_bCutOn^(i^)
echo       End If
echo     Next
echo.
echo     '--- tvtplay�p�ŏI������ ---
echo     If nCutType = MODE_TVT Then
echo       If bCutState ^> 0 Then   ' CM�I������
echo         m_strOutput = m_strOutput ^& "0e" ^& PREFIX_TVTO ^& "-"
echo       Else
echo         m_strOutput = m_strOutput ^& "0e-"
echo       End If
echo       m_strOutput = m_strOutput ^& "c"
echo     ElseIf nCutType = MODE_TVC Then
echo       m_strOutput = m_strOutput ^& "c"
echo     End If
echo     '--- ���ʏo�� ---
echo     WScript.StdOut.Write m_strOutput
echo   End Sub
echo End Class
)> "%work_dir%%main_project_name%\bat\func_chapter_jls.vbs"
rem ------------------------------
exit /b


:make_autovfr_phase
rem ### AutoVfr�������������邽�߂̃X�e�b�v
echo rem # AutoVfr�̎��s�t�F�[�Y>>"%main_bat_file%"
echo call ".\bat\autovfr_scan.bat">> "%main_bat_file%"
echo.>> "%main_bat_file%"
echo AutoVfr.avs�F"%autovfr_template%"
copy "%autovfr_template%" "%work_dir%%main_project_name%\\avs\"> nul
echo AutoVfr_Fast.avs�F"%autovfr_fast_template%"
copy "%autovfr_fast_template%" "%work_dir%%main_project_name%\\avs\"> nul
rem # "AutoVfr.ini"���R�s�[����Bautovfrini_path�Ŏw�肳�ꂽ�p�X�����݂��Ȃ��ꍇ�́AAutoVfr.exe�Ɠ����p�X���g�p����B
if exist "%autovfrini_path%" (
    echo AutoVfr.ini�F"%autovfrini_path%"
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
echo rem ��AutoVfr��Mode
echo call :autovfr_mode_detect
echo rem [0=Auto_Vfr�𗘗p] [1=Auto_Vfr_Fast�𗘗p]
echo rem set autovfr_mode=^0
echo.
echo rem ��AutoVfr�̎���/�蓮�ݒ蔻��
echo call :autovfr_deint_detect
echo rem [0=�}�j���A���ŃC���^���[�X�𗘗p] [1=�����f�C���^�[���[�X�𗘗p]
echo rem set autovfr_deint=^1
echo.
echo rem ���X���b�h���w��
echo call :autovfr_threadnum_detect
echo rem # AutoVfr���O���o�͂���ۂ̃X���b�h�����w�肵�܂��B���w��̏ꍇ�A�V�X�e���̘_��CPU���ɂȂ�܂��B
echo rem set autovfr_thread_num=
echo.
echo rem # �f�C���^�[���[�X�������m�F
echo call :deinterlace_filter_flag_detect
echo.
echo if not "%%deinterlace_filter_flag%%"=="Its" ^(
echo     echo �f�C���^�[���[�X������Its��p���Ȃ��ׁAAutoVfr�̎��s�𒆎~���܂��B
echo     title �R�}���h �v�����v�g
echo     echo end %%~nx0 bat job...
echo     exit /b
echo ^)
echo.
echo rem # �G���R�[�h�c�[�����܂Ƃ߂��f�B���N�g�����������ϐ�ENCTOOLSROOTPATH����`����Ă��邩�m�F
echo call :toolsdircheck
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o
echo call :project_name_check
echo rem # parameter�t�@�C������MPEG-2�f�R�[�_�[�^�C�v^(mpeg2dec_select_flag^)�����o
echo call :mpeg2dec_select_flag_check
echo rem # parameter�t�@�C������AutoVfr�̃p�����[�^�[�����o
echo call :autovfr_param_check
echo.
echo rem # �e���s�t�@�C�������݂��邩�m�F�B���݂��Ȃ��ꍇENCTOOLSROOTPATH������T������A�������̓V�X�e���̒T���p�X�Ɉς˂�
)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist "%avs2pipe_path%" ^(set avs2pipe_path=%avs2pipe_path%^) else ^(call :find_avs2pipe "%avs2pipe_path%"^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist "%autovfr_path%" ^(set autovfr_path=%autovfr_path%^) else ^(call :find_autovfr "%autovfr_path%"^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
(
echo.
echo rem # �e����s�t�@�C���ւ̃p�X���A�ŏI�I�ɂǂ̂悤�Ȓl�ɂȂ������m�F�B
echo echo avs2pipe: %%avs2pipe_path%%
echo echo AutoVfr : %%autovfr_path%%
echo.
echo rem *****************Auto_Vfr�Ŏg�p**********************
echo rem ��Auto_Vfr�̐ݒ�B^(^)�����ŋL�ځB���O�t�@�C���p�X,cut,number�͎w��s�v�B
echo rem [�ꗗ] cthresh=^(�R�[�~���O����-1-255^), mi=^(�R�[�~���O��0-blockx*blocky^), chroma=false, blockx=16^(����u���b�N�c�T�C�Y^), blocky=^(����u���b�N���T�C�Y^), IsCrop=false, crop_height=, IsTop=false, IsBottom=true, show_crop=false, IsDup=false, thr_m=10, thr_luma=0.01
echo rem �����lcthresh=60, mi=55, blockx=16, blocky=32 
echo rem �e���b�v����cthresh=110,mi=100���x�����^(70,60^)�B����������ƌ딻�葽���A�グ������Ǝ������莸�s���ăe���b�v���؂��Bcthresh�͂��̂܂܂ŁAmi�𓮂����Ē�������̂��ǂ��B^(60fps��Ԃ��L����ݒ肠��Ηǂ��̂�^)
echo rem crop_height�̒l��YV12�̏ꍇ4�̔{���łȂ��ƃG���[�ɂȂ�̂Œ��ӁI
echo rem @set autovfr_setting_normal=cthresh=80, mi=60, blockx=16, blocky=32, chroma=false, IsCrop=true, crop_height=92^0
echo rem ��AutoVfr.exe�̐ݒ�^(-i -o�ȊO�̃I�v�V�����w��^)
echo rem # ����s�\�Ȏ��������������ꍇ�A"-60F 0"�ł���"-30B 0^(default^)"�ł����24fps�֐����K�p�����
echo if "%%autovfr_deint%%"=="0" ^(
echo     @set EXESETTING=-INI "AutoVfr.ini" -30F 1 -60F 0 -30B 0 -skip 1 -ref 300 -24A 0 -30A 0 -FIX
echo ^) else ^(
echo     @set EXESETTING=-INI "AutoVfr.ini" -30F 1 -60F 0 -30B 0 -skip 1 -ref 300 -24A 1 -30A 1 -FIX
echo ^)
echo rem ��60i�e���͈͊g���t���[����^(60fps�E6to2�͈� �g��^)
echo rem �딚�h�~��臒l�ݒ�ׁ̈A60i�e�����o�������Z���Ȃ�ꍇ������܂��B�����␳���܂��B
echo rem ���̏�����AutoVFR.exe�̌�ɍs���܂��B"[24] txt60mc"�܂���"[60] f60"���܂ޔ͈͎w��s�������Ώۂɂ��܂��B
echo rem EXBIGIs�ɐ擪�́AEXLASTs�ɖ����̊g���t���[�������A�w�肵�Ă��������B5�̔{�������B
echo @set EXBIGIs=^5
echo @set EXLASTs=^5
echo rem *****************Auto_Vfr_Fast�ŗ��p*****************
echo rem ��Auto_Vfr_Fast�̐ݒ�B^(^)�����ŋL�ځB���O�t�@�C���p�X,cut,number�͎w��s�v�B
echo rem [�ꗗ] cthresh=^(�R�[�~���O����-1-255^), mi=^(�R�[�~���O��0-blockx*blocky^), chroma=false, blockx=^(����u���b�N�c�T�C�Y^), blocky=^(����u���b�N���T�C�Y^)
echo rem �����lcthresh=60, mi=55, blockx=16, blocky=32 
echo rem �e���b�v����cthresh=110,mi=100���x�����^(70,60^)�B����������ƌ딻�葽���A�グ������Ǝ������莸�s���ăe���b�v���؂��Bcthresh�͂��̂܂܂ŁAmi�𓮂����Ē�������̂��ǂ��B^(60fps��Ԃ��L����ݒ肠��Ηǂ��̂�^)
echo rem @set autovfr_setting_fast=cthresh=80, mi=60, blockx=16, blocky=32, chroma=false
echo rem ��AutoVfr.exe�̐ݒ�^(-i -o�ȊO�̃I�v�V�����w��^)
echo rem # ����s�\�Ȏ��������������ꍇ�A"-60F 0"�ł���"-30B 0^(default^)"�ł����24fps�֐����K�p�����
echo if "%%autovfr_deint%%"=="0" ^(
echo     @set FASTEXESETTING=-INI "AutoVfr.ini" -30F 1 -60F 0 -30B 0 -skip 1 -ref 250 -24A 0 -30A 0 -FIX
echo ^) else ^(
echo     @set FASTEXESETTING=-INI "AutoVfr.ini" -30F 1 -60F 0 -30B 0 -skip 1 -ref 250 -24A 1 -30A 1 -FIX
echo ^)
echo rem ��60i�e���͈͊g���t���[����^(60fps�͈͊g��^)
echo rem �딚�h�~��臒l�ݒ�ׁ̈A60i�e�����o�������Z���Ȃ�ꍇ������܂��B�����␳���܂��B
echo rem ���̏�����AutoVFR.exe�̌�ɍs���܂��B"[60] f60"���܂ޔ͈͎w��s�������Ώۂɂ��܂��B
echo rem EXBIGIf�ɐ擪�́AEXLASTf�ɖ����̊g���t���[�������A�w�肵�Ă��������B5�̔{�������B
echo @set EXBIGIf=^5
echo @set EXLASTf=^5
echo rem *****************************************************
echo.
echo :main
echo rem //----- main�J�n -----//
echo title %%project_name%%
echo echo ���[�Ƃ��[��VFR�iAutoVFR BAT�Łj �C���X�p�C�A
echo echo Auto_VFR��Auto_VFR_Fast�̏����������p���܂�
echo echo 臒l�m�F��
echo echo ShowCombedTIVTC^(debug=true,blockx=16,blocky=32,cthresh=60^)
echo echo ���ŉ\�ł��B
echo echo txt60mc�́A�uII�t���[���O�̍Ō��P�t���[���̃t���[���ԍ���Mod5�l���A�w�肷��l�v���w��
echo echo.
echo rem # �J�����g��.def�t�@�C�����f�t�H���g�̂��̂Ɣ�r���A����������΃��[�U�[�ҏW�ς݂Ƃ���AutoVfr�̓X�L�b�v
echo if not exist ".\main.def" ^(
echo     echo main.def�t�@�C�������݂��܂���BAutoVfr�����s���܂��B
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
echo rem AutoVFR��AutoVFR_Fast�𕪊�
echo set SEPARATETEMP=%%autovfr_thread_num%%
echo if "%%autovfr_mode%%"=="0" ^(
echo     call :MAKESLOWAVS
echo ^) else ^(
echo     call :MAKEFASTAVS
echo ^)
echo echo AutoVfr�𑖍����܂�. . .[%%date%% %%time%%]
echo call :AVS2PIPE_DECODE
echo call :MAKEDEF
echo call :EDITDEFm
echo rem # .def�t�@�C����V�������ꂽ���̂ɒu������
echo call :ReLOCATION
echo echo.
echo echo ***************************************************************
echo echo ���S�Ă̏������I�����܂����B
echo echo �J�n : %%STARTTIME%%
echo echo �I�� : %%DATE%% %%TIME%%
echo echo ***************************************************************
echo echo.
echo title �R�}���h �v�����v�g
echo rem //----- main�I�� -----//
echo echo end %%~nx0 bat job...
echo echo.
echo exit /b
echo.
rem ------------------------------
echo :def_diff_check
echo fc ".\main.def" ".\avs\main.def"^> NUL
echo if "%%errorlevel%%"=="1" ^(
echo     echo .def�t�@�C�����ҏW�ςׁ݂̈AAutoVfr�̎��s���X�L�b�v���܂�
echo     set exit_stat=^1
echo ^) else ^(
echo     set exit_stat=^0
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :SETPARAMETER
echo rem # ���ϐ��̃��Z�b�g
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
echo rem # �X���b�h����AutoVfr�pavs�t�@�C���쐬
echo if "%%SEPARATETEMP%%"=="0" ^(exit /b^)
echo copy ".\avs\LoadPlugin.avs" ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"
echo echo.^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"
echo copy /b ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs" + ".\avs\Auto_Vfr.avs" ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"
echo echo.^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs"
echo rem ���t�B�[���h�I�[�_�[�𖾎����Ȃ���AutoVfr�X�L���������Ő���Ɍ딚����\��������̂Œ���
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
rem # Trim�ҏW��1�s���o�t�@�C��"trim_chars.txt"�����݂���ꍇ�A�����AutoVfr�ɂ����f����
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
echo rem # �X���b�h����AutoVfr_Fast�pavs�t�@�C���쐬
echo if "%%SEPARATETEMP%%"=="0" ^(exit /b^)
echo copy ".\avs\LoadPlugin.avs" ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"
echo echo.^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"
echo copy /b ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs" + ".\avs\Auto_Vfr_Fast.avs" ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"
echo echo.^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs"
echo rem ���t�B�[���h�I�[�_�[�𖾎����Ȃ���AutoVfr�X�L���������Ő���Ɍ딚����\��������̂Œ���
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
rem # Trim�ҏW��1�s���o�t�@�C��"trim_chars.txt"�����݂���ꍇ�A�����AutoVfr�ɂ����f����
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
echo echo ���[�h            : %%MODE%%
echo echo ������            : %%autovfr_thread_num%%
echo echo �X�v���v�gOptis   : %%VFROPTIONS%%
echo echo avs2pipe.exe�p�X  : %%avs2pipe_path%%
echo echo AutoVfr.exe�p�X   : %%autovfr_path%%
echo echo AutoVfr.exe�ݒ�   : %%AUTOEXESET%%
echo echo �e���b�v�͈͊g��  : [�擪= %%EXBIGI%%] [�I�[= %%EXLAST%%]
echo echo.
echo echo Log�t�@�C���o�͐� : %%OUTLOG%%
echo echo Def�t�@�C���o�͐� : %%OUTDEF%%
echo if "%%DELLOG%%"=="1" ^(echo  [��] Log�t�@�C���͏������܂�^)
echo echo ===============================================================
echo echo �f�R�[�h�J�n : %%DATE%% %%TIME%%
echo echo.
echo echo �f�R�[�h�̈ꎞ��~ : �v�����v�g�� �E�N���b�N���͈͑I��
echo echo               �ĊJ : �v�����v�g�� �E�N���b�N
echo echo ===============================================================
echo %%PIPECOMMAND:^"^|^"=^|%%
echo echo ===============================================================
echo echo �f�R�[�h�I�� : %%DATE%% %%TIME%%
echo.
echo %%COPYCOMMAND%% ^>NUL
echo %%DELCOMMANDa:^"^&^"=^&%%
echo if exist "%%OUTLOG%%" ^(echo Log�t�@�C�����쐬����܂����B
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
echo echo def�t�@�C�����o�͂��܂�[%%date%% %%time%%]
echo if "%%autovfr_mode%%"=="0" ^(
echo     "%%autovfr_path%%" -i ".\log\AutoVFR.log" -o "%%OUTDEF%%" %%EXESETTING%%
echo ^) else if "%%autovfr_mode%%"=="1" ^(
echo     "%%autovfr_path%%" -i ".\log\AutoVFR_Fast.log" -o "%%OUTDEF%%" %%FASTEXESETTING%%
echo ^)
echo if exist "%%OUTDEF%%" ^(
echo     echo def�t�@�C�����쐬����܂����B
echo     if "%%DELLOG%%"=="1" ^(
echo         del "%%OUTLOG%%"
echo     ^)
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :EDITDEFm
echo if "%%EXBIGI%%" == "0" ^(if "%%EXLAST%%" == "0" ^(exit /b^)^)
echo rem �󔒍s����
echo if exist "%%OUTDEF%%.temp" ^(del "%%OUTDEF%%.temp"^)
echo for /f ^"usebackq delims=^" %%%%k in ^(^"%%OUTDEF%%^"^) do ^(echo %%%%k ^| find /v ^"mode fps_adjust = on^"^>^>^"%%OUTDEF%%.temp^"^)
echo if exist ^"%%OUTDEF%%.temp^" ^(del ^"%%OUTDEF%%^"^) else ^(echo ERROR1^)
echo rem �����s���擾
echo for /f ^"usebackq delims=]^" %%%%k in ^(`find /n ^"-^" ^"%%OUTDEF%%.temp^" ^^^| find /i ^"[60] f60^"`^) do ^(call set TXTLINE=%%%%TXTLINE%%%%_%%%%k[^)
echo for /f ^"usebackq delims=]^" %%%%k in ^(`find /n ^"-^" ^"%%OUTDEF%%.temp^" ^^^| find /i ^"[24] txt60mc^"`^) do ^(call set TXTLINE=%%%%TXTLINE%%%%_%%%%k[^)
echo rem �͈͎w��s�擾
echo for /f ^"usebackq delims=[]^" %%%%k in ^(`find /n ^"-^" ^"%%OUTDEF%%.temp^" ^^^| find ^"[^" ^^^| find ^"] ^" ^^^| sort /r`^) do ^(set BIGILINE=%%%%k^)
echo for /f ^"usebackq delims=[]^" %%%%k in ^(`find /n ^"-^" ^"%%OUTDEF%%.temp^" ^^^| find ^"[^" ^^^| find ^"] ^" ^^^| sort`^) do ^(set LASTLINE=%%%%k^)
echo rem �u��
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
echo rem ����
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
echo rem `echo %%~1`�\�L������ɓ����Ȃ��̂Œ��ԃt�@�C�����g�p
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
echo         echo �s���ȃp�����[�^�w��ł��B�f�t�H���g��AutoVfr^^^(Slow^^^)���[�h���g�p���܂��B
echo         set autovfr_mode=^0
echo     ^)
echo ^)
echo if "%%autovfr_mode%%"=="" ^(
echo     echo AutoVfr�̃��[�h�w�肪������܂���B�f�t�H���g��AutoVfr^^^(Slow^^^)���[�h���g�p���܂��B
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
echo         echo �s���ȃp�����[�^�w��ł��B�f�t�H���g�̎����f�C���^�[���[�X���[�h���g�p���܂��B
echo         set autovfr_deint=^0
echo     ^)
echo ^)
echo if "%%autovfr_deint%%"=="" ^(
echo     echo AutoVfr�̃f�C���^�[���[�X�w�肪������܂���B�f�t�H���g�̎����f�C���^�[���[�X���[�h���g�p���܂��B
echo     set autovfr_deint=^0
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :autovfr_threadnum_detect
echo rem # ���K�\������̌��ʂœ�����G���[���x���ɂ���ăp�����[�^�[�̎w�肪���������ۂ����肵�܂��B
echo rem # �o�b�`�t�@�C���Ő��l���ǂ������肵�����̂Łc�i�����j - �A�Z�g�A�~�m�t�F���̋C�܂܂ȓ���
echo rem # http://d.hatena.ne.jp/acetaminophen/20150809/1439150912
echo for /f "usebackq eol=# tokens=2 delims==" %%%%T in ^(`findstr /b /r autovfr_thread_num "parameter.txt"`^) do ^(
echo     set thread_tmp_num=%%%%T
echo     echo %%%%T^| findstr /x /r "^[+-]*[0-9]*[\.]*[0-9]*$" 1^>nul
echo ^)
echo if "%%ERRORLEVEL%%"=="0" ^(
echo     if not "%%thread_tmp_num%%"=="" ^(
echo         echo AutoVfr�̎��s�X���b�h�� %%thread_tmp_num%% �ł��B
echo         set autovfr_thread_num=%%thread_tmp_num%%
echo     ^) else ^(
echo         echo AutoVfr�̎��s�X���b�h�������w�肩�p�����[�^�[�w�肻�̂��̂�������܂���B����ɃV�X�e���̘_��CPU�� %%Number_Of_Processors%% ���g�p���܂��B
echo         set autovfr_thread_num=%%Number_Of_Processors%%
echo     ^)
echo ^) else if "%%ERRORLEVEL%%"=="1" ^(
echo     echo AutoVfr�̎��s�X���b�h���̎w�肩�p�����[�^�[�������l�ł͂���܂���B����ɃV�X�e���̘_��CPU�� %%Number_Of_Processors%% ���g�p���܂��B
echo     set autovfr_thread_num=%%Number_Of_Processors%%
echo ^)
echo set thread_tmp_num=
echo exit /b
echo.
rem ------------------------------
echo :toolsdircheck
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo ���ϐ� ENCTOOLSROOTPATH ������`�ł�
echo     exit /b
echo ^)
)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%ENCTOOLSROOTPATH%\>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
(
echo if exist "%%ENCTOOLSROOTPATH%%" ^(
echo     exit /b
echo ^) else ^(
echo     echo ���ϐ�ENCTOOLSROOTPATH���L���ȃp�X�ł͂���܂���
echo     set ENCTOOLSROOTPATH=
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :autovfr_param_check
echo rem # Autovfr.ini������txt_area_T�����o����
echo call :crop_height_search
echo rem # �p�����[�^�[�t�@�C�����T��
echo for /f "usebackq eol=# tokens=1 delims=" %%%%A in ^(`findstr /b autovfr_setting "parameter.txt"`^) do ^(
echo     set %%%%A
echo ^)
echo if "%%autovfr_setting%%"=="" ^(
echo     echo ��AutoVfr�̃p�����[�^�[����������܂���A��֒l���Z�b�g���܂�
echo     set autovfr_setting=cthresh=80, mi=60, blockx=16, blocky=32, chroma=false, IsCrop=true, crop_height=92^0
echo ^)
echo set autovfr_setting=%%autovfr_setting:,=","%%
echo call :autovfr_setting_shape_phase "%%autovfr_setting%%"
echo rem # Auto_Vfr_Fast�p�I�v�V������Auto_Vfr�p�I�v�V��������֌W�Ȃ����̂�����
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
echo     echo "AutoVfr.ini"���ɗL����"txt_area_T"��������܂���ł����B����Ɏb��l920��ݒ肵�܂��B
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
echo     echo ��MPEG-2�f�R�[�_�[�̎w�肪������܂���, MPEG2 VFAPI Plug-In���g�p���܂�
echo     set mpeg2dec_select_flag=^1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_avs2pipe
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     set avs2pipe_path=%%~nx1
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set avs2pipe_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo     call :avspipe_env_search %%~nx1
echo ^)
echo exit /b
echo :avspipe_env_search
echo set avs2pipe_path=%%~$PATH:1
echo if "%%avs2pipe_path%%"=="" ^(
echo     echo avs2pipe��������܂���
echo     set avs2pipe_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_autovfr
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     set autovfr_path=%%~nx1
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set autovfr_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��BAutoVfr.exe�͐�΃p�X�w������Ȃ���ini�t�@�C���̓ǂݍ��݂Ɏ��s���܂��̂ŕK�{^(ver0.1.1.1^)�B
echo     call :autovfr_env_search %%~nx1
echo ^)
echo exit /b
echo :autovfr_env_search
echo set autovfr_path=%%~$PATH:1
echo if "%%autovfr_path%%"=="" ^(
echo    echo AutoVfr��������܂���
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
    echo AutoVfr.ini�����݂��܂���B����̃f�t�H���g�ݒ�̃t�@�C�����쐬���܂��B
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
rem # �v���W�F�N�g���̖����̔��p�X�y�[�X���폜
set main_project_name=%main_project_name:~0,-1%
exit /b

:get_upperdir_path
rem # ���͂��ꂽ�t�@�C���̃p�X�Ə�ʃf�B���N�g�������擾����[���֐�
rem # ���̓t�@�C����AVS�̏ꍇ�Ɏg�p
set avs_upperdir_path=%~dp1
set avs_upperdir_name=%~n1
exit /b

:other_projectname_detect
rem # ���̓t�@�C����avs�ȊO�̏ꍇ�̃v���W�F�N�g������[���֐�
set main_project_name=%~n1
exit /b

:avs_projectname_detect
rem # ���̓t�@�C����avs�̏ꍇ�̃v���W�F�N�g������[���֐�
set main_project_name=%avs_upperdir_name%
exit /b

:Type_KeyIn
rem # KeyIn���g�����v���W�F�N�g���ݒ�A���̋[���֐����Ăяo��
echo ���C�ӂ̖��O�ɕҏW���Ă�������
"%KeyIn_path%" %main_project_name%
set /p new_project_name=type.
set main_project_name=%new_project_name%
exit /b

:noType_KeyIn
rem # KeyIn���g��Ȃ��v���W�F�N�g���ݒ�A���̋[���֐����Ăяo��
echo ���\�[�X�t�@�C���̌��ɒǉ����镶������͂��Ă�������
set /p new_project_name=type.
set avs_project_name=%~n1%new_project_name%
exit /b

:over_write_select
rem # ���Ƀt�@�C�������݂��Ă����ꍇ�ɂǂ��������邩�����[�U�[�ɐq�˂�[���֐�
rem # if����for����()�̒��ł͊��ϐ��������W�J����邽�߂��̂悤�Ɉ�x�O���ɓ����Ă��画�肷��
rem # �����͂��Ȃ����ȋ[���֐�(���x��)�ŁA�s���ƋA���goto�R�}���h�ōs�����Ƃ��K�{�ƂȂ�
echo.
echo ����AVS�t�@�C�������݂��܂��A�ǂ����܂����H
echo 1. �㏑��
echo 2. �ʖ��ō쐬
echo 3. ������AVS�X�N���v�g�𗬗p
echo 0. ���~
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="1" (
    echo �㏑�����܂�
    goto :esc_checkexist_avsfile
) else if "%choice%"=="2" (
    :make_newproject
    echo.
    echo ### �\�[�X�t�@�C���Ƃ͕ʂ̖��O��AVS�t�@�C�����쐬���܂� ###
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
    rem �s���ȓ���
    echo �������l��I�����Ă��������I
    goto :over_write_select
)
goto :space_blank_checker
exit /b

:copy_avssrc_dir
rem ### �\�[�X��avs�̏ꍇ�A����avs������f�B���N�g�����R�s�[���邽�߂̋[���֐�
rem # �R�s�[���ƃR�s�[��̃f�B���N�g�����������ǂ����̔�r
if "%avs_upperdir_path%"=="%work_dir%" (
    echo ��AVS�t�@�C���̃R�s�[���ƃR�s�[��̃f�B���N�g��������ł�
) else (
    call :xcopy_phase "%~1"
)
exit /b

:xcopy_phase
echo xcopy��F"%work_dir%%main_project_name%\"
set /p choice=%avs_upperdir_name% �f�B���N�g�����R�s�[���܂��A��낵���ł����H^(y/n^)
if "%choice%"=="" set choice=n
if "%choice%"=="y" (
    call :run_xcopy_action "%~1"
)
if "%choice%"=="1" (
    call :run_xcopy_action "%~1"
)
exit /b

:run_xcopy_action
rem # �f�B���N�g���̕����A�ꕔ�̊g���q�����O�ݒ�
rem # xcopy�R�}���h�ő��葤�Ɏw�肷��f�B���N�g���͖���"\"�s�B����Ē���
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
rem # %lgd_file_src_path%�f�B���N�g���̒���������ǖ����܂ރ��S�t�@�C��(.lgd)���ċA�I�Ɍ����o���āAwork�f�B���N�g������lgd�f�B���N�g���ɃR�s�[���܂�
rem # ����t�@�C�����ɔ��p�J�b�R���܂܂�Ă���ƌ�쓮����̂ŁAcall�����g�p���O���֐����Ăяo���܂��B
rem # �ΏۂƂȂ�.lgd�t�@�C����tsrenamec�Œ��o���������ǖ��ɍ��v�����t�@�C�����������̂ɂȂ�܂��̂ŁA�������ɋC��t���Ă�������
set lgd_file_counter=0
rem # �o�b�`���[�h�w��Ŗ����I�Ƀ��S�t�@�C�������߂��Ă���ꍇ�A�Y����������ǂ̃��S�t�@�C�����o�͍s��Ȃ�
if exist "%bat_lgd_file_path%" (
    call :broadcaster_lgd_copy_phase "%bat_lgd_file_path%"
    exit /b
)
for /f "usebackq delims=" %%B in (`%tsrenamec_path% "%~1" @CH`) do (
    call :set_broadcaster_name_phase "%%B"
)
if "%src_broadcaster_name%"=="" (
    echo �����ǖ������ʂł��܂���
) else (
    echo �����ǁF"%src_broadcaster_name%"
    rem # �t�@�C�������o�����forfiles�R�}���h���g���Əo�͂��ꂽ�t�@�C�����̗��[�Ƀ_�u���N�H�[�e�[�V�����������I�ɕt������đ��삵�Â炢�̂ŕs�̗p
    rem # [^\\]�̓f�B���N�g�����܂܂Ȃ����K�\���A$�͖�����\�����K�\��
    for /f "usebackq delims=" %%L in (`dir /A-D /B /S "%lgd_file_src_path%" ^| findstr ".*%src_broadcaster_name%.*.lgd[^\\]*$"`) do (
        call :broadcaster_lgd_copy_phase "%%L"
    )
)
if "%lgd_file_counter%"=="0" (
    echo �K�����郍�S�t�@�C����������܂���ł���
)
exit /b

:set_broadcaster_name_phase
set src_broadcaster_name=%~nx1
exit /b

:broadcaster_lgd_copy_phase
rem # �ŏ��ɓn���ꂽ�t�@�C�������C���̃��S�t�@�C���Ƃ��Ďg�p���܂��B
if "%lgd_file_counter%"=="0" (
    call :set_main_lgd_file_name "%~1"
)
set /a lgd_file_counter=lgd_file_counter+1
echo ���S�t�@�C��%lgd_file_counter%�F%~nx1
copy "%~1" "%work_dir%%main_project_name%\lgd\"> nul
exit /b

:set_main_lgd_file_name
rem # ���C���̃��S�t�@�C����parameter�t�@�C���ɋL�^����܂�
set lgd_file_name=%~nx1
exit /b

:copy_JL_file_phase
rem # �J�b�g�������@�X�N���v�g(JL)���R�s�[����
rem # �ʏ��%JL_file_name%�Ŏw�肵���f�t�H���g�t�@�C�����g�p���邪�A�I�v�V�����w�肳�ꂽ�ꍇ�͕ʂ̃X�N���v�g���g�p�\
if "%JL_src_file_full-path%"=="" (
    set JL_src_file_full-path=%JL_src_dir%%JL_file_name%
)
echo �J�b�g�������@�X�N���v�g�F%JL_src_file_full-path%
if not exist "%JL_src_file_full-path%" (
    echo �J�b�g�������@�X�N���v�g^(JL^)�����݂��܂���A�������X�L�b�v���܂�
) else (
    copy "%JL_src_file_full-path%" "%work_dir%%main_project_name%\JL\"> nul
    call :fix_JL_file_name_phase "%JL_src_file_full-path%"
)
exit /b
:fix_JL_file_name_phase
set JL_file_name=%~nx1
exit /b


:bat_video_resolution_detect
rem # �o�b�`���[�h�̍ۂ̖�����p�����[�^�[(���T�C�Y�w��ɔ����𑜓x�A�A�X��̎w��)�����肷��
if "%src_video_wide_pixel%"=="" (
    echo MediaInfoC�ɂ�鉡�𑜓x���o��������܂���ł����A�n��g�����ň�ʓI��1440��ݒ肵�܂��B
    set src_video_wide_pixel=1440
)
if "%src_video_hight_pixel%"=="" (
    echo MediaInfoC�ɂ��c�𑜓x���o��������܂���ł����A�n��g�����ň�ʓI��1080��ݒ肵�܂��B
    set src_video_hight_pixel=1080
)
if "%src_video_pixel_aspect_ratio%"=="" (
    echo MediaInfoC�ɂ��A�X�y�N�g�䌟�o��������܂���ł����B
    if "%src_video_wide_pixel%"=="1440" (
        echo ���𑜓x�� 1440 �ׁ̈A�A�X�y�N�g�� 1.333 ��ݒ肵�܂��B
        set src_video_pixel_aspect_ratio=1.333
    ) else if "%src_video_wide_pixel%"=="1920" (
        echo ���𑜓x�� 1920 �ׁ̈A�A�X�y�N�g�� 1.000 ��ݒ肵�܂��B
        set src_video_pixel_aspect_ratio=1.000
    ) else if "%src_video_wide_pixel%"=="720" (
        echo ���𑜓x�� 720 �ׁ̈A�A�X�y�N�g�� 1.212 ��ݒ肵�܂��B
        set src_video_pixel_aspect_ratio=1.212
    ) else (
        echo ���𑜓x���s���ׁ̈A�A�X�y�N�g�� 1.000 ��ݒ肵�܂��B
        set src_video_pixel_aspect_ratio=1.000
    )
)
rem # ���T�C�Y�������w��A�������̓\�[�X�r�f�I�̏c�𑜓x���o�b�`���[�h�̃��T�C�Y�w��ȉ��̏ꍇ�̓��T�C�Y���������{���Ȃ�
if "%bat_vresize_flag%"=="none" (
    echo �����T�C�Y�������w��ׁ̈A���T�C�Y���������{���܂���
    call :bat_none-vresize_phase
) else if not "%bat_vresize_flag%"=="custom" (
    if %src_video_hight_pixel% LEQ %bat_vresize_flag% (
        echo ���\�[�X�r�f�I�̏c�𑜓x�����T�C�Y�w��ȉ��ׁ̈A���T�C�Y���������{���܂���
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
rem # bat_vresize_flag=custom �̏ꍇ�s�N�Z���䂪�u�����N�Ȃ̂ŁA1:1�Ŗ��߂�
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
rem ### �蓮�Ŋe���ڂ�ݒ肷��ꍇ�̋[���֐��A�ʏ�template_job_select����Ăяo��
echo.
echo ### %main_project_name% ���蓮�Őݒ肵�܂� ###
echo 1. 1080i �\�[�X
echo 2. 720�~480i(16:9) �\�[�X
echo 3. 720�~480i(4:3)  �\�[�X
echo 0. TsSplitter ��ʂ�
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="" (
    echo �I�����Ă��������I
    goto :manual_job_settings
) else if "%choice%"=="1" (
    rem 1. 1080i �\�[�X
    set tssplitter_opt_param=
    call :1080input_edit_selector
    exit /b
) else if "%choice%"=="2" (
    rem 2. 720�~480i(16:9) �\�[�X
    set tssplitter_opt_param=
    set avs_filter_type=480p_template
    set src_video_wide_pixel=720
    set crop_size_flag=none
    set videoAspectratio_option=video_par40x33_option
    exit /b
) else if "%choice%"=="3" (
    rem 3. 720�~480i(4:3)  �\�[�X
    set tssplitter_opt_param=
    set avs_filter_type=480p_template
    set src_video_wide_pixel=720
    set crop_size_flag=none
    set videoAspectratio_option=video_par10x11_option
    exit /b
) else if "%choice%"=="0" (
    rem 0. TsSplitter ��ʂ�
    if "%~x1"==".ts" (
        call :TsSplitter_phase "%~1"
    ) else (
        echo ��MPEG-2 TS�t�@�C���ł͂���܂���
        goto :manual_job_settings
    )
    exit /b
) else (
    rem �s���ȓ���
    echo �������l��I�����Ă��������I
    goto :manual_job_settings
)
exit /b

:TsSplitter_phase
rem ### ���O��TsSplitter��ʂ��ꍇ�̋[���֐��A�ʏ�:manual_job_settings����Ăяo��
echo ### TsSplitter�ŕ�����̃t�@�C�����̖����ɂ���������w�肵�Ă�������[HD] [SD] ###
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
rem # 1080i���͂̏ꍇ�ɁA�ǂ̂悤�ɕҏW���邩����
rem # ������--sar�I�v�V�����̃t���O������(1080p�̏ꍇ�͂��̎���)
echo.
echo ### �ǂ̂悤�ɕҏW���܂����H ###
echo 1.  �t�����C�h �� 1080 �o��
echo 2.  �t�����C�h �� 900  �o��
echo 3.  �t�����C�h �� 810  �o��
echo 4.  �t�����C�h �� 720  �o��
echo 5.  �t�����C�h �� 540  �o��
echo 6.  �t�����C�h �� 16:9 480�o��
echo 7. �T�C�h�J�b�g�� 4:3  480�o��
echo 8.    ���z��   �� 16:9 480�o��
echo 9.  �t�����C�h �� PSP(270p)�o��
echo 10.�T�C�h�J�b�g�� PSP(270p)�o��
echo 11.   ���z��   �� PSP(270p)�o��
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="" (
    echo �I�����Ă��������I
    goto :1080input_edit_selector
) else if "%choice%"=="1" (
    rem 1.  �t�����C�h �� 1080 �o��
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
    rem 2.  �t�����C�h �� 900  �o��
    set avs_filter_type=1080p_template
    set crop_size_flag=none
    set videoAspectratio_option=video_par1x1_option
    set resize_wpix=1600
    set resize_hpix=900
    exit /b
) else if "%choice%"=="3" (
    rem 3.  �t�����C�h �� 810  �o��
    set avs_filter_type=1080p_template
    set crop_size_flag=none
    set videoAspectratio_option=video_par1x1_option
    set resize_wpix=1440
    set resize_hpix=810
    exit /b
) else if "%choice%"=="4" (
    rem 4.  �t�����C�h �� 720  �o��
    set avs_filter_type=720p_template
    set crop_size_flag=none
    set videoAspectratio_option=video_par1x1_option
    set resize_wpix=1280
    set resize_hpix=720
    exit /b
) else if "%choice%"=="5" (
    rem 5.  �t�����C�h �� 540  �o��
    set avs_filter_type=540p_template
    set crop_size_flag=none
    set videoAspectratio_option=video_par1x1_option
    set resize_wpix=960
    set resize_hpix=540
    exit /b
) else if "%choice%"=="6" (
    rem 6.  �t�����C�h �� 16:9 480�o��
    set avs_filter_type=480p_template
    set crop_size_flag=none
    set videoAspectratio_option=video_par40x33_option
    set resize_wpix=704
    set resize_hpix=480
    exit /b
) else if "%choice%"=="7" (
    rem 7. �T�C�h�J�b�g�� 4:3  480�o��
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
    rem 8.    ���z��   �� 16:9 480�o��
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
    rem 9.  �t�����C�h �� PSP(270p)�o��
    set avs_filter_type=272p_template
    set crop_size_flag=none
    set videoAspectratio_option=video_par1x1_option
    set resize_wpix=480
    set resize_hpix=270
    exit /b
) else if "%choice%"=="10" (
    rem 10.�T�C�h�J�b�g�� PSP(270p)�o��
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
    rem 11.   ���z��   �� PSP(270p)�o��
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
    rem �s���ȓ���
    echo �������l��I�����Ă��������I
    goto :1080input_edit_selector
)
exit /b

:480input_edit_selector
echo ���쐬
exit /b


:HDvideo_wideselector
rem # ���͂����t�@�C���̐����𑜓x�����
rem # �o�͂�HD�𑜓x�̏ꍇ�A���͉𑜓x���ێ������܂܏o�͂���r�f�I�̃A�X�y�N�g�����t�^���܂�
rem # ��Ɏg�p����MediaInfo CLI�Ō��o���ꂽ�𑜓x���L���ł���Ύ蓮�őI���͂��܂���
echo.
echo ### ���͂����HD�t�@�C���̐����𑜓x��I�����Ă������� ###
echo 1. 1440
echo 2. 1920
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="" (
    echo �I�����Ă��������I
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
    rem �s���ȓ���
    echo �������l��I�����Ă��������I
    goto :HDvideo_wideselector
)
exit /b

:deinterlace_filter_selector
rem # �ǂ̂悤�ɃC���^�[���[�X�������邩�̑I��
echo.
echo ### �C���^�[���[�X�������[�h��I�����Ă������� ###
echo 1. ����24fps(IT)
echo 2. ����30fps(IT)
echo 3. �蓮�C���^�[���[�X����(Its)
echo 4. �σt���[�����[�g�o��(itvfr+Its)
echo 5. Bob��
echo 6. �C���^�[���[�X�ێ�
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="" (
    echo �I�����Ă��������I
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
    rem �s���ȓ���
    echo �������l��I�����Ă��������I
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
echo ### AutoVFR�̃��[�h��I�����Ă������� ###
echo 1. AutoVFR
echo 2. AutoVFR_Fast
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="1" (
    set autovfr_mode=0
) else if "%choice%"=="2" (
    set autovfr_mode=1
) else (
    rem �s���ȓ���
    echo �������l��I�����Ă��������I
    goto :autovfr_mode_selector
)
exit /b

:vfr_rate_selecter
rem # �t���[�����[�g�̔���
echo.
if "%deinterlace_filter_flag%"=="Its" (
    echo �C���^�[���[�X������Its���g�p���܂�^(�o�̓t���[�����[�g�s��^)
    call :peak_rate_selecter
) else if "%deinterlace_filter_flag%"=="=24fps" (
    echo �o�̓t���[�����[�g��24fps�ł�
) else if "%deinterlace_filter_flag%"=="30fps" (
    echo �o�̓t���[�����[�g��30fps�ł�
) else if "%deinterlace_filter_flag%"=="bob" (
    echo �o�̓t���[�����[�g��60fps�ł�
)
exit /b

:peak_rate_selecter
rem # �f���̃t���[�����[�g���ς̏ꍇ�A�s�[�N���̃��[�g���w�肷��
echo ### �G���R�[�h����ۂ̃s�[�N�t���[�����[�g��I�����Ă������� ###
echo 1. 30.0fps
echo 2. 60.0fps
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="1" (
    set vfr_peak_rate=30fps
) else if "%choice%"=="2" (
    set vfr_peak_rate=60fps
) else (
    echo �I�����Ă��������I
    goto :peak_rate_selecter
)
exit /b


:video_job_selector
rem # �r�f�I�G���R�[�f�B���O�̃t�H�[�}�b�g��I��
echo.
echo ### �f���̃G���R�[�h������I�����Ă������� ###
echo 1. H.264/AVC  (x264)
echo 2. H.265/HEVC (x265)
echo 3. H.264/AVC  (QSVEncC)
echo 4. H.265/HEVC (QSVEncC)
echo 5. H.264/AVC  (NVEncC)
echo 6. H.265/HEVC (NVEncC)
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="" (
    echo �I�����Ă��������I
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
    rem �s���ȓ���
    echo �������l��I�����Ă��������I
    goto :video_job_selector
)
exit /b

:audio_job_selector
rem # ��������������I��
echo.
echo ### �����̏���������I�����Ă������� ###
echo 1. FakeAacWav(faw)
echo 2. �񃖍��ꉹ��(sox)
echo 3. �X�e���I�ăG���R�[�h(nero)
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="" (
    echo �I�����Ă��������I
    goto :audio_job_selector
) else if "%choice%"=="1" (
    set audio_job_flag=faw
) else if "%choice%"=="2" (
    set audio_job_flag=sox
) else if "%choice%"=="3" (
    set audio_job_flag=nero
) else (
    rem �s���ȓ���
    echo �������l��I�����Ă��������I
    goto :audio_job_selector
)
exit /b


:make_previewfile_phase
rem ### ���[�U�[�̓��͂����ݒ�ɂ���������avs�t�@�C�����쐬����[���֐�
rem %work_dir%%main_project_name%�ɃX�N���v�g���쐬���܂�
rem ----------
rem ### �f�ނ̂܂܃v���r���[���鐗�`�X�N���v�g���쐬(preview1_straight) ###
type nul > "%work_dir%%main_project_name%\preview1_straight.avs"
rem ----------
rem ### �f�ނɃJ�b�g�ҏW�̂ݓK�p�������`�X�N���v�g���쐬(preview2_trimed) ###
type nul > "%work_dir%%main_project_name%\preview2_trimed.avs"
rem ----------
rem ### �C���^�[���X�Ȃ��v���r���[���A�����ݒ���s���ׂ̐��`�X�N���v�g���쐬(preview3_anticomb) ###
type nul > "%work_dir%%main_project_name%\preview3_anticomb.avs"
rem ----------
rem ### �r�f�I�N���b�v�ɑ΂���ҏW��K�p�ς݂̐��`�X�N���v�g���쐬(preview4_deinterlace) ###
type nul > "%work_dir%%main_project_name%\preview4_deinterlace.avs"
rem ----------
exit /b


:make_previewplugin_phase
rem # �v���O�C���ǂݍ��ݕ���
if "%importloardpluguin_flag%"=="1" (
    echo ##### �v���O�C���ǂݍ��ݕ����̃C���|�[�g #####>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo Import^(".\avs\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo.>> "%work_dir%%main_project_name%\preview1_straight.avs"
    echo ##### �v���O�C���ǂݍ��ݕ����̃C���|�[�g #####>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo Import^(".\avs\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo.>> "%work_dir%%main_project_name%\preview2_trimed.avs"
    echo ##### �v���O�C���ǂݍ��ݕ����̃C���|�[�g #####>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo Import^(".\avs\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo.>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
    echo ##### �v���O�C���ǂݍ��ݕ����̃C���|�[�g #####>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
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
rem ### �\�[�X��TS�t�@�C�����v���r���[����ׂ̓ǂݍ��݃t�B���^���쐬����[���֐�
echo ##### �\�[�X�t�@�C���ǂݍ��� #####>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo ##### �\�[�X�t�@�C���ǂݍ��� #####>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo ##### �\�[�X�t�@�C���ǂݍ��� #####>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo ##### �\�[�X�t�@�C���ǂݍ��� #####>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
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
echo #video2=Adjust2clip^(video1,video2.BilinearResize^(1920, 1080^),0^)	#2�̃N���b�v�̊J�n�ʒu�����킹��>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #stacksubtract^(video1,video2, 0, f1=4000, f2=15000, f3=33000^)	#�J�n�t���[���̃Y�����m�F����֐�>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #Delogo_BS11ANIMEP^(100^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #BS11overlay2^(last, video2, 100, 80, "logo"^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #BS11overlay2^(last, video2, 110, 90, "separate"^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #FreezeFrame^(100, 100, 101^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo.>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #KillAudio^(^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #video2=Adjust2clip^(video1,video2.BilinearResize^(1920, 1080^),0^)	#2�̃N���b�v�̊J�n�ʒu�����킹��>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #stacksubtract^(video1,video2, 0, f1=4000, f2=15000, f3=33000^)	#�J�n�t���[���̃Y�����m�F����֐�>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #Delogo_BS11ANIMEP^(100^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #BS11overlay2^(last, video2, 100, 80, "logo"^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #BS11overlay2^(last, video2, 110, 90, "separate"^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #FreezeFrame^(100, 100, 101^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo.>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo KillAudio^(^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #video2=Adjust2clip^(video1,video2.BilinearResize^(1920, 1080^),0^)	#2�̃N���b�v�̊J�n�ʒu�����킹��>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #stacksubtract^(video1,video2, 0, f1=4000, f2=15000, f3=33000^)	#�J�n�t���[���̃Y�����m�F����֐�>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #Delogo_BS11ANIMEP^(100^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #BS11overlay2^(last, video2, 100, 80, "logo"^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #BS11overlay2^(last, video2, 110, 90, "separate"^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #FreezeFrame^(100, 100, 101^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo.>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #KillAudio^(^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #video2=Adjust2clip^(video1,video2.BilinearResize^(1920, 1080^),0^)	#2�̃N���b�v�̊J�n�ʒu�����킹��>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #stacksubtract^(video1,video2, 0, f1=4000, f2=15000, f3=33000^)	#�J�n�t���[���̃Y�����m�F����֐�>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #Delogo_BS11ANIMEP^(100^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #BS11overlay2^(last, video2, 100, 80, "logo"^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #BS11overlay2^(last, video2, 110, 90, "separate"^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #FreezeFrame^(100, 100, 101^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo.>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
exit /b


:avs_interlacebefore_privew
echo #//--- �t�B�[���h�I�[�_�[ ---//>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo AssumeFrameBased^(^).ComplementParity^(^)	#�g�b�v�t�B�[���h���x�z�I>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #AssumeFrameBased^(^)			#�{�g���t�B�[���h���x�z�I>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #AssumeTFF^(^)				#�g�b�v�t�@�[�X�g>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #AssumeBFF^(^)				#�{�g���t�@�[�X�g>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #SeparateFields^(^)			#�t�B�[���h�𕪗�>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo.>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #//--- �N���b�v�̑��� ---//>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #AlignedSplice^(clip clip1, clip clip2 [,...]^)	#���Z�q��++�ɑ�������r�f�I�N���b�v�����t�B���^>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #UnalignedSplice^(clip clip1, clip clip2 [,...]^)	#���Z�q��+�ɑ�������r�f�I�N���b�v�����t�B���^>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #FreezeFrame^(clip clip, int first-frame, int last-frame, int source-frame^)	#first-frame��last-frame�̊Ԃ̂��ׂẴt���[����source-frame�̃R�s�[�ɒu���B�T�E���h�g���b�N�͏C������܂���B>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #Try { Import^(".\avs\EraseLogo.avs"^) } catch(err_msg) { }	#�����߃��S����>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo ExtErsLOGO^(logofile=".\lgd\%lgd_file_name%", start=0, end=-1, itype_s=0, itype_e=0, fadein=0, fadeout=0^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo.>> "%work_dir%%main_project_name%\preview1_straight.avs"
rem ----------
echo #//--- �t�B�[���h�I�[�_�[ ---//>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo AssumeFrameBased^(^).ComplementParity^(^)	#�g�b�v�t�B�[���h���x�z�I>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #AssumeFrameBased^(^)			#�{�g���t�B�[���h���x�z�I>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #AssumeTFF^(^)				#�g�b�v�t�@�[�X�g>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #AssumeBFF^(^)				#�{�g���t�@�[�X�g>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #SeparateFields^(^)			#�t�B�[���h�𕪗�>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo.>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #//--- �N���b�v�̑��� ---//>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #AlignedSplice^(clip clip1, clip clip2 [,...]^)	#���Z�q��++�ɑ�������r�f�I�N���b�v�����t�B���^>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #UnalignedSplice^(clip clip1, clip clip2 [,...]^)	#���Z�q��+�ɑ�������r�f�I�N���b�v�����t�B���^>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #FreezeFrame^(clip clip, int first-frame, int last-frame, int source-frame^)	#first-frame��last-frame�̊Ԃ̂��ׂẴt���[����source-frame�̃R�s�[�ɒu���B�T�E���h�g���b�N�͏C������܂���B>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #Try { Import^(".\avs\EraseLogo.avs"^) } catch(err_msg) { }	#�����߃��S����>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo ExtErsLOGO^(logofile=".\lgd\%lgd_file_name%", start=0, end=-1, itype_s=0, itype_e=0, fadein=0, fadeout=0^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo.>> "%work_dir%%main_project_name%\preview2_trimed.avs"
rem ----------
echo #//--- �t�B�[���h�I�[�_�[ ---//>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo AssumeFrameBased^(^).ComplementParity^(^)	#�g�b�v�t�B�[���h���x�z�I>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #AssumeFrameBased^(^)			#�{�g���t�B�[���h���x�z�I>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #AssumeTFF^(^)				#�g�b�v�t�@�[�X�g>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #AssumeBFF^(^)				#�{�g���t�@�[�X�g>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #SeparateFields^(^)			#�t�B�[���h�𕪗�>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo.>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #//--- �N���b�v�̑��� ---//>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #AlignedSplice^(clip clip1, clip clip2 [,...]^)	#���Z�q��++�ɑ�������r�f�I�N���b�v�����t�B���^>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #UnalignedSplice^(clip clip1, clip clip2 [,...]^)	#���Z�q��+�ɑ�������r�f�I�N���b�v�����t�B���^>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #FreezeFrame^(clip clip, int first-frame, int last-frame, int source-frame^)	#first-frame��last-frame�̊Ԃ̂��ׂẴt���[����source-frame�̃R�s�[�ɒu���B�T�E���h�g���b�N�͏C������܂���B>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #Try { Import^(".\avs\EraseLogo.avs"^) } catch(err_msg) { }	#�����߃��S����>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo ExtErsLOGO^(logofile=".\lgd\%lgd_file_name%", start=0, end=-1, itype_s=0, itype_e=0, fadein=0, fadeout=0^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo.>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
rem ----------
echo #//--- �t�B�[���h�I�[�_�[ ---//>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo AssumeFrameBased^(^).ComplementParity^(^)	#�g�b�v�t�B�[���h���x�z�I>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #AssumeFrameBased^(^)			#�{�g���t�B�[���h���x�z�I>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #AssumeTFF^(^)				#�g�b�v�t�@�[�X�g>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #AssumeBFF^(^)				#�{�g���t�@�[�X�g>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #SeparateFields^(^)			#�t�B�[���h�𕪗�>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo.>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #//--- �N���b�v�̑��� ---//>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #AlignedSplice^(clip clip1, clip clip2 [,...]^)	#���Z�q��++�ɑ�������r�f�I�N���b�v�����t�B���^>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #UnalignedSplice^(clip clip1, clip clip2 [,...]^)	#���Z�q��+�ɑ�������r�f�I�N���b�v�����t�B���^>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #FreezeFrame^(clip clip, int first-frame, int last-frame, int source-frame^)	#first-frame��last-frame�̊Ԃ̂��ׂẴt���[����source-frame�̃R�s�[�ɒu���B�T�E���h�g���b�N�͏C������܂���B>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #Try { Import^(".\avs\EraseLogo.avs"^) } catch(err_msg) { }	#�����߃��S����>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo ExtErsLOGO^(logofile=".\lgd\%lgd_file_name%", start=0, end=-1, itype_s=0, itype_e=0, fadein=0, fadeout=0^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo.>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
exit /b


:preview_setting_filter
rem ----------
echo ##### �J�b�g�ҏW #####>> "%work_dir%%main_project_name%\preview1_straight.avs"
rem # �ȉ��̃C���|�[�g���t�@�C����Trim�����L�����Ă�������
echo #Try { Import^("trim_line.txt"^) } catch^(err_msg^) { }>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo.>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo ##### �v���r���[�p�t�B���^ #####>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #Its^(opt=1, def=".\main.def", fps=-1, debug=false, output="", chapter=""^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #AssumeFPS^("ntsc_film", sync_audio=false^)    #�t���[�����[�g��24fps�ɏC��>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #SelectField^(30, "top"^)    #�����R��Ή��A���t�B�[���h�I��>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #SelectField^(30, "bottom"^)    #�����R��Ή��A���t�B�[���h�I��>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo #FreezeFrame^(100, 100, 101^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo.>> "%work_dir%%main_project_name%\preview1_straight.avs"
rem ----------
echo ##### �J�b�g�ҏW #####>> "%work_dir%%main_project_name%\preview2_trimed.avs"
rem # �ȉ��̃C���|�[�g���t�@�C����Trim�����L�����Ă�������
echo Try { Import^("trim_line.txt"^) } catch^(err_msg^) { }>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo.>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo ##### �v���r���[�p�t�B���^ #####>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #Its^(opt=1, def=".\main.def", fps=-1, debug=false, output="", chapter=""^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #AssumeFPS^("ntsc_film", sync_audio=false^)    #�t���[�����[�g��24fps�ɏC��>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #SelectField^(30, "top"^)    #�����R��Ή��A���t�B�[���h�I��>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #SelectField^(30, "bottom"^)    #�����R��Ή��A���t�B�[���h�I��>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #FreezeFrame^(100, 100, 101^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo.>> "%work_dir%%main_project_name%\preview2_trimed.avs"
rem ----------
echo ##### �J�b�g�ҏW #####>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
rem # �ȉ��̃C���|�[�g���t�@�C����Trim�����L�����Ă�������
echo Try { Import^("trim_line.txt"^) } catch^(err_msg^) { }>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo.>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo ##### �v���r���[�p�t�B���^ #####>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo DoubleWeave^(^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo a = Pulldown^(0, 2^).Subtitle^("Pulldown(0, 2)", size=90^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo b = Pulldown^(1, 3^).Subtitle^("Pulldown(1, 3)", size=90^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo c = Pulldown^(2, 4^).Subtitle^("Pulldown(2, 4)", size=90^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo d = Pulldown^(0 ,3^).Subtitle^("Pulldown(0, 3)", size=90^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo e = Pulldown^(1, 4^).Subtitle^("Pulldown(1, 4)", size=90^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo ShowFiveVersions^(a, b, c, d, e^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo.>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
rem ----------
echo ##### �J�b�g�ҏW #####>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
rem # �ȉ��̃C���|�[�g���t�@�C����Trim�����L�����Ă�������
echo Try { Import^("trim_line.txt"^) } catch^(err_msg^) { }>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
rem echo Import^("trim_multi.txt"^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo.>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo ##### �v���r���[�p�t�B���^ #####>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo Its^(opt=1, def=".\main.def", fps=-1, debug=false, output="", chapter=""^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #AssumeFPS^("ntsc_film", sync_audio=false^)    #�t���[�����[�g��24fps�ɏC��>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #SelectField^(30, "top"^)    #�����R��Ή��A���t�B�[���h�I��>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #SelectField^(30, "bottom"^)    #�����R��Ή��A���t�B�[���h�I��>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #FreezeFrame^(100, 100, 101^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
rem ----------
echo ##### �F��ԕϊ� #####>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo ##### �F��ԕϊ� #####>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo ##### �F��ԕϊ� #####>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo ##### �F��ԕϊ� #####>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
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
echo #//--- �I�� ---//>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo return last>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo.>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo #//--- �I�� ---//>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo return last>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo.>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo #//--- �I�� ---//>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo return last>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
echo.>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo #//--- �I�� ---//>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo return last>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
exit /b

:edit_analyze_filter
rem # ���S���ҏW����͂̂��߂�AVS�t�@�C���쐬
echo ##### �ҏW����͂̂��߂�AVS #####
echo #//--- �v���O�C���ǂݍ��ݕ����̃C���|�[�g ---//
echo Import^(".\LoadPlugin.avs"^)
echo.
echo #//--- �\�[�X�̓ǂݍ��� ---//
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
echo #//--- �t�B�[���h�I�[�_�[ ---//
echo #AssumeFrameBased^(^).ComplementParity^(^)    #�g�b�v�t�B�[���h���x�z�I
echo #AssumeFrameBased^(^)            #�{�g���t�B�[���h���x�z�I
echo #AssumeTFF^(^)                #�g�b�v�t�@�[�X�g
echo #AssumeBFF^(^)                #�{�g���t�@�[�X�g
echo.
echo #//--- Trim���C���|�[�g ---//
echo #Import^("..\trim_chars.txt"^)
echo.
echo #//--- �F��ԕύX ---//
echo # chapter_exe���̓N���b�v�̐F��Ԃ�YUY2�K�{^(YV12���ƃV�[���`�F���W�Ȃ��딚����^)
echo # ���S��͂�YV12�K�{�����Alogoframe�������I��YV12�ɕϊ����Ă����̂Ŗ��Ȃ�
echo ConvertToYUY2^(^)
echo #ConvertToYV12^(^)
echo.
echo return last
exit /b

:eraselogo_filter
rem # �����߃��S�����֐�AVS�t�@�C���쐬�A���g��logoframe���s���ɏ㏑��
type nul
exit /b

:avs_template_main_phase
rem ########## �G���R�[�h���C�������p��AVS�t�@�C�����e���v���[�g�t�@�C�����琶��
echo AVS�e���v���[�g�t�@�C���F%avs_main_template%
echo �v���O�C���ǂݍ��݃e���v���[�g�F"%plugin_template%"
copy "%plugin_template%" "%work_dir%%main_project_name%\avs\LoadPlugin.avs"> nul
echo [%time%] AVS�e���v���[�g���琶���J�n
set last_phrase=
set eof_inuse_flag=
rem # for�Ō��o����������������Ƃ��ĊO�����x���ɔ�΂��Ɠ��ꕶ��"��>���������Ă���ꍇ�ɐ���ɋ@�\���Ȃ��ׁAdo�\������set���邱��
rem # ��F#ColorYUY2(levels="709->601")
for /f "usebackq delims=" %%L in (`findstr /n .* "%avs_main_template%"`) do (
    rem ������̒��ɓ��ꕶ�����܂܂�Ă���ƌ듮�삷��ꍇ������̂ŁA�_�u���N�H�[�g�ň͂�
    set str_temp="%%L"
    call :avs_template_line_edit
)
rem # �e���v���[�g�̍ŏI�s�� return last �ȊO�̕�����ł��܂���x�� return last ��}�����Ă��Ȃ��ꍇ�A�Ō�ɑ}������
if not "%last_phrase:~0,11%"=="return last" (
    if not "%eof_inuse_flag%"=="1" (
        call :avs_template_eof_phase
    )
)
echo [%time%] AVS�e���v���[�g���琶���I��
exit /b

:avs_template_line_edit
rem # �e���v���[�g�̊e�s�𕪐́A�v�u���Ώۂ̏ꍇ�͏���̃t�B���^���ɕύX
rem # �l�������Ă��Ȃ��ϐ�(=���s)�ɑ΂���set�ɂ�镶����u��������Ƒz��O�̕�����ɂȂ邽�߁A�s�����t�^���ꂽ��ԂŐ�Ɏ��{����
rem >�L���͏o�͐�t�@�C���Ƀ��_�C���N�g����ۂɌ듮�삷��̂ŁA�G�X�P�[�v����
set str_temp=%str_temp:>=^^^>%
rem if�����Ŕ���Ɏg�p���镶����̓_�u���N�H�[�g���܂܂��ƌ듮�삷��̂ŁA�ʂɕێ�����
set str_checker="%str_temp:"=%"
rem �ϐ� str_temp �͑O����_�u���N�H�[�g�ň͂܂ꂽ��Ԃׁ̈A�J�E���g����N�_��3�����ڂ���ƂȂ�
set avs_char_count=2
rem �f���~�^:��T�����邽�߂̃��[�v�J�n�ʒu
:avs_template_charset_loop
call set str_delim=%%str_temp:~%avs_char_count%,1%%
set /a avs_char_count+=1
rem �f���~�^:���o������܂Ń��[�v
if not "%str_delim%"==":" goto :avs_template_charset_loop
call set str_mod="%%str_temp:~%avs_char_count%, -1%%"
call set str_checker=%%str_checker:~%avs_char_count%, -1%%
rem ��x�s���ƍs���̃_�u���N�H�[�g���폜������Ԃ̕������ϐ��Ɋi�[���Ȃ��Ɛ������@�\���Ȃ�
set str_mod=%str_mod:~1,-1%
rem �ǂݍ��݃e���v���[�g�̍ŏI�s���L�^���邽�߁A�󔒂łȂ���Ώ㏑��
rem #iFilterB("LanczosResize(704, 480)") �Ō�쓮���
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
rem # �v���O�C���ǂݍ��݃e���v���[�g�̑}��
echo Import^(".\avs\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\main.avs"
exit /b

:avs_template_src_phase
rem # �f��/�����ǂݍ��݃e���v���[�g�̑}��
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
rem # ���S�����t�B���^�e���v���[�g�̑}��
echo Try { Import^(".\avs\EraseLogo.avs"^) } catch(err_msg) { }	#�����߃��S����>> "%work_dir%%main_project_name%\main.avs"
echo.>> "%work_dir%%main_project_name%\main.avs"
exit /b

:avs_template_trim_phase
rem # Trim�J�b�g�ҏW�e���v���[�g�̑}��
echo # �P��s�ŕ\�L����Trim�R�}���h�͂����ȉ��ɋL�����Ă�������>> "%work_dir%%main_project_name%\main.avs"
echo Try { Import^("trim_line.txt"^) } catch^(err_msg^) { }    # ��sTrim�\�L>> "%work_dir%%main_project_name%\main.avs"
echo #Trim^(0,99^) ++ Trim^(200,299^) ++ Trim^(300,399^)>> "%work_dir%%main_project_name%\main.avs"
echo.>> "%work_dir%%main_project_name%\main.avs"
echo # �����s�ŕ\�L����Trim�R�}���h�͂����ȉ��ɋL�����Ă�������>> "%work_dir%%main_project_name%\main.avs"
echo KillAudio^(^)    # ���G�ȕҏW������ꍇ�ɔ����ĉ������ꎞ������>> "%work_dir%%main_project_name%\main.avs"
echo Try { Import^("trim_multi.txt"^) } catch^(err_msg^) { }    # �����sTrim�\�L^(EasyVFR�Ȃ�^)>> "%work_dir%%main_project_name%\main.avs"
echo.>> "%work_dir%%main_project_name%\main.avs"
echo ### ��s�ŕ\�L����Trim�R�}���h�͂����ɋL�����Ă������� ###>> "%work_dir%%main_project_name%\trim_line.txt"
echo ### �����s�ŕ\�L����Trim�R�}���h�͂����ɋL�����Ă������� ###>> "%work_dir%%main_project_name%\trim_multi.txt"
exit /b

:avs_template_deint_phase
rem # �J���[�}�g���b�N�X�̒���
if "%avs_filter_type%"=="1080p_template" (
    echo #ColorMatrix^(mode="Rec.709->Rec.601", interlaced=true^)    #BT.709����BT.601�֕ϊ�>> "%work_dir%%main_project_name%\main.avs"
) else if "%avs_filter_type%"=="720p_template" (
    echo #ColorMatrix^(mode="Rec.709->Rec.601", interlaced=true^)    #BT.709����BT.601�֕ϊ�>> "%work_dir%%main_project_name%\main.avs"
) else if "%avs_filter_type%"=="540p_template" (
    echo #ColorMatrix^(mode="Rec.709->Rec.601", interlaced=true^)    #BT.709����BT.601�֕ϊ�>> "%work_dir%%main_project_name%\main.avs"
) else (
    echo ColorMatrix^(mode="Rec.709->Rec.601", interlaced=true^)    #BT.709����BT.601�֕ϊ�>> "%work_dir%%main_project_name%\main.avs"
    echo.>> "%work_dir%%main_project_name%\main.avs"
)
rem # �f�C���^�[���[�X�t�B���^�̑}��
if "%deinterlace_filter_flag%"=="24fps" (
    rem echo ### 24p �Ńf�C���^�[���[�X���܂� ###
    echo IT^(fps = 24, ref = "TOP", blend = false, diMode = 1^)>> "%work_dir%%main_project_name%\main.avs"
    echo #TDeint^(mode=2, full=false, cthresh=20, type=3, mthreshl=10, mtnmode=0, ap=10, aptype=2, expand=8^).TDecimate^(mode=1^)>> "%work_dir%%main_project_name%\main.avs"
) else if "%deinterlace_filter_flag%"=="Its" (
    rem echo ### Its �Ńf�C���^�[���[�X���܂� ###
    echo Its^(opt=1, def=".\main.def", fps=-1, debug=false, output=".\tmp\main.tmc", chapter=""^)>> "%work_dir%%main_project_name%\main.avs"
) else if "%deinterlace_filter_flag%"=="itvfr" (
    rem echo ### itvfr�Ńf�C���^�[���[�X���܂� ###
    echo Its^(opt=1, def=".\main.def", fps=-1, debug=false, output=".\tmp\main.tmc", chapter=""^)>> "%work_dir%%main_project_name%\main.avs"
) else if "%deinterlace_filter_flag%"=="30fps" (
    rem echo ### 30p�Ńf�C���^�[���[�X���܂� ###
    echo TomsMoComp^(1,5,0^)>> "%work_dir%%main_project_name%\main.avs"
    echo AntiComb^(^)>> "%work_dir%%main_project_name%\main.avs"
)
exit /b

:avs_template_resize_phase
rem # Crop, Resize, AddBorders
rem # Resize�O�A���OCrop
if "%crop_size_flag%"=="sidecut" (
    if "%src_video_wide_pixel%"=="1920" (
        echo Crop^(240, 0, -240, -0^)    #�N���b�s���O^(��, ��, -�E, -��^)>> "%work_dir%%main_project_name%\main.avs"
    ) else if "%src_video_wide_pixel%"=="720" (
        echo Crop^(96, 0, -96, -0^)    #�N���b�s���O^(��, ��, -�E, -��^)>> "%work_dir%%main_project_name%\main.avs"
    ) else (
        echo Crop^(180, 0, -180, -0^)    #�N���b�s���O^(��, ��, -�E, -��^)>> "%work_dir%%main_project_name%\main.avs"
    )
) else if "%crop_size_flag%"=="gakubuchi" (
    if "%src_video_wide_pixel%"=="1920" (
        echo Crop^(240, 134, -240, -136^)    #�N���b�s���O^(��, ��, -�E, -��^)>> "%work_dir%%main_project_name%\main.avs"
    ) else (
        echo Crop^(180, 134, -180, -136^)    #�N���b�s���O^(��, ��, -�E, -��^)>> "%work_dir%%main_project_name%\main.avs"
    )
) else (
    if "%src_video_wide_pixel%"=="720" (
        if "%avs_filter_type%"=="272p_template" (
            echo Crop^(8, 0, -8, -0^)    #�N���b�s���O^(��, ��, -�E, -��^)>> "%work_dir%%main_project_name%\main.avs"
        )
    )
)
rem # Resize�����E���T�C�Y�t�B���^�ݒ�
if "%bat_vresize_flag%"=="none" (
    echo #���T�C�Y����>> "%work_dir%%main_project_name%\main.avs"
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
        echo Dither_convert_8_to_16^(^)#�F�[�x��8�r�b�g����16�r�b�g�ɓW�J>> "%work_dir%%main_project_name%\main.avs"
        echo Dither_resize16nr^(%resize_wpix%,%resize_hpix%,kernel="spline36",taps=6,noring=true^)#�F�[�x16�r�b�g���T�C�Y^&�����M���O�}��>> "%work_dir%%main_project_name%\main.avs"
        echo f3kdb^(range=15,Y=56,Cb=40,Cr=40,grainY=0,grainC=0,keep_tv_range=true,input_mode=1,input_depth=16,output_mode=1,output_depth=16,random_algo_ref=2,random_algo_grain=2^)#�F�[�x16�r�b�g �o���f�B���O����>> "%work_dir%%main_project_name%\main.avs"
        echo DitherPost^(mode=6^)#�F�[�x��16�r�b�g����8�r�b�g�ɖ߂�^&�o���f�B���O����2>> "%work_dir%%main_project_name%\main.avs"
    ) else (
        echo Spline64Resize^(%resize_wpix%,%resize_hpix%^)>> "%work_dir%%main_project_name%\main.avs"
    )
)
rem # ���T�C�Y��A���ѕt��
if "%avs_filter_type%"=="480p_template" (
    if not "%src_video_wide_pixel%"=="720" (
        echo AddBorders^(8,0,8,0^)    #���ѕt��>> "%work_dir%%main_project_name%\main.avs"
    )
)
exit /b

:avs_template_eof_phase
rem # �ŏI�����i�̑}��
set eof_inuse_flag=1
echo #//---  ConvertToYV12 ---//>>"%work_dir%%main_project_name%\main.avs"
if "%deinterlace_filter_flag%"=="interlace" (
    echo ConvertToYV12^(interlaced=true^)>>"%work_dir%%main_project_name%\main.avs"
) else (
    echo ConvertToYV12^(interlaced=false^)>>"%work_dir%%main_project_name%\main.avs"
)
echo #ConvertToYUY2^(interlaced=false^)>>"%work_dir%%main_project_name%\main.avs"
echo.>>"%work_dir%%main_project_name%\main.avs"
echo #//--- �I�� ---//>>"%work_dir%%main_project_name%\main.avs"
echo AudioDub^(last, audio^)>>"%work_dir%%main_project_name%\main.avs"
if "%deinterlace_filter_flag%"=="itvfr" (
    echo ItsCut^(^)>>"%work_dir%%main_project_name%\main.avs"
) else (
    echo #ItsCut^(^)>>"%work_dir%%main_project_name%\main.avs"
)
echo return last>>"%work_dir%%main_project_name%\main.avs"
exit /b

:avs_template_redirect_phase
rem # �e���v���[�g�̕���������̂܂ܓ]�L
echo %str_mod%>> "%work_dir%%main_project_name%\main.avs"
exit /b

:avs_template_set_last_phrase
set last_phrase=%str_mod%
exit /b

:make_project_dir
rem # �v���W�F�N�g�f�B���N�g�����Ȃ���΍쐬
if not exist "%work_dir%%main_project_name%\" mkdir "%work_dir%%main_project_name%\"
rem # AVS�t�@�C����u�����߂̃T�u�f�B���N�g�����Ȃ���΍쐬
if not exist "%work_dir%%main_project_name%\avs\" mkdir "%work_dir%%main_project_name%\avs\"
rem # �f������щ����̃\�[�X��u���T�u�f�B���N�g�����Ȃ���΍쐬
if not exist "%work_dir%%main_project_name%\src\" mkdir "%work_dir%%main_project_name%\src\"
rem # �e��o�b�`�t�@�C����u���T�u�f�B���N�g�����Ȃ���΍쐬
if not exist "%work_dir%%main_project_name%\bat\" mkdir "%work_dir%%main_project_name%\bat\"
rem # ���O�t�@�C���u���T�u�f�B���N�g�����Ȃ���΍쐬
if not exist "%work_dir%%main_project_name%\log\" mkdir "%work_dir%%main_project_name%\log\"
rem # ���S�t�@�C��(.lgd)��u�����߂̃T�u�f�B���N�g�����Ȃ���΍쐬
if not exist "%work_dir%%main_project_name%\lgd\" mkdir "%work_dir%%main_project_name%\lgd\"
rem # �J�b�g�������@�X�N���v�g(JL)��u�����߂̃T�u�f�B���N�g�����Ȃ���΍쐬
if not exist "%work_dir%%main_project_name%\JL\" mkdir "%work_dir%%main_project_name%\JL\"
rem # �o�b�N�A�b�v�t�@�C���u���T�u�f�B���N�g�����Ȃ���΍쐬
if not exist "%work_dir%%main_project_name%\old\" mkdir "%work_dir%%main_project_name%\old\"
rem # �y�ʈꎞ�t�@�C���u���T�u�f�B���N�g�����Ȃ���΍쐬
if not exist "%work_dir%%main_project_name%\tmp\" mkdir "%work_dir%%main_project_name%\tmp\"
exit /b

:make_main_bat
rem ### ���ۂɍ�ƒ��j��S�����C���ƂȂ�o�b�`�t�@�C�����쐬����
rem # ���C���o�b�`�t�@�C���̍쐬�A%encode_catalog_list%����`����Ă���ꍇ�A�v���W�F�N�g�f�B���N�g��
rem # �ȉ���AVS�Ɠ����̃��C���o�b�`�t�@�C�����쐬�������%encode_catalog_list%���Ăяo���`���Aset���T�u���[�`����
set main_bat_file=%work_dir%%main_project_name%\main.bat
if not exist "%main_bat_file%" (
    echo ���C���o�b�`�t�@�C�����Ȃ��̂ō쐬���܂�...
    type nul > "%main_bat_file%"
    echo @echo off>> "%main_bat_file%"
    echo setlocal>> "%main_bat_file%"
    rem echo echo �J�n����[%%date%% %%time%%]>> "%main_bat_file%"
) else (
    if "%encode_catalog_list%"=="" (
        rem %encode_catalog_list%���g�p�����A�����Ƀ��C���o�b�`�t�@�C�������݂��Ă���ꍇ
        rem �ۗ����E�E�E
        exit /b
    ) else (
        echo ���Ƀo�b�`�t�@�C�������݂��Ă��܂��B���O��ύX���V�K�ɍ쐬���܂��B
        rename "%main_bat_file%" "backup%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%_main.bat"
        type nul > "%main_bat_file%"
        echo @echo off>> "%main_bat_file%"
        echo setlocal>> "%main_bat_file%"
        rem echo echo �J�n����[%%date%% %%time%%]>> "%main_bat_file%"
    )
)
echo.>> "%main_bat_file%"
rem %large_tmp_dir%�����݂��Ȃ��ꍇ�̑Ή�
echo :START>> "%main_bat_file%"
echo rem #�ꎞ�t�@�C���u����m�F>> "%main_bat_file%"
echo if not exist "%%large_tmp_dir%%" echo �傫�߂̈ꎞ�t�@�C�����쐬����%%%%large_tmp_dir%%%%�����݂��܂���B^&echo ���h���C�u���^�[����̃o�b�N�X���b�V��^^^(^^^\^^^)��Y��Ȃ�����^&echo �t�H���_�ւ̃t���p�X����͂��Ă��������B^&set /p large_tmp_dir=type.^&goto :START>> "%main_bat_file%"
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\>> "%main_bat_file%"
echo chdir /d %%~dp0>> "%main_bat_file%"
rem # �G���R�[�h����t�@�C���̌��o�������쐬
echo.>> "%main_bat_file%"
echo echo Project: %main_project_name% >> "%main_bat_file%"
echo echo ### �J�n����[%%date%% %%time%%] ###>> "%main_bat_file%"
echo.>> "%main_bat_file%"
exit /b

:MediaInfoC_phase
rem # MediaInfo CLI���g���ă��f�B�A�̉𑜓x�����o����(�����̃X�g���[�����܂܂�Ă��邱�Ƃ�z�肵�A�ŏ��Ƀq�b�g�������̂�ΏۂƂ���)
echo MediaInfo �Ń��f�B�A���̃��O���o�͂��܂�
rem set /a Width_count=0
rem set /a Height_count=0
if not exist "%MediaInfoC_path%" (
    echo MediaInfo CLI��������܂���B�𑜓x�̎������o�͍s���܂���B
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
echo Width ��������܂���ł����B
exit /b
:MediaInfo_Height_checker
for /f "usebackq tokens=3 delims= " %%H in (`findstr /C:"Height" "%work_dir%%main_project_name%\log\MediaInfo.log"`) do (
    set src_video_hight_pixel=%%~H
    echo Height: %%~H
    exit /b
)
echo Height ��������܂���ł����B
exit /b
:MediaInfo_Pixelaspect_checker
for /f "usebackq tokens=5 delims= " %%A in (`findstr /C:"Pixel aspect ratio" "%work_dir%%main_project_name%\log\MediaInfo.log"`) do (
    set src_video_pixel_aspect_ratio=%%~A
    echo Pixel aspect ratio: %%~A
    exit /b
)
echo Pixel aspect ratio ��������܂���ł����B
exit /b


:copy_source_phase
echo rem # �\�[�X�t�@�C���̃R�s�[����ю��O����>> "%main_bat_file%"
echo call ".\bat\copy_src.bat">> "%main_bat_file%"
echo.>> "%main_bat_file%"
rem ### �w�肵���h���C�u�̃��f�B�A�^�C�v�𔻕ʂ��邽�߂�VB�X�N���v�g�A�\�[�X�t�@�C�������[�J��HDD�h���C�u�ɂ��邩�m�F�p
echo WScript.Echo CStr^(CreateObject^("Scripting.FileSystemObject"^).GetDrive^(WScript.Arguments^(0^)^).DriveType^)> "%work_dir%%main_project_name%\bat\media_check.vbs"
rem ### TS�\�[�X���R�s�[����[���֐��ATsSplitter�ɂ�鏈��������
type nul > "%copysrc_batfile_path%"
(
echo @echo off
echo setlocal
echo echo start %%~nx0 bat job...
echo chdir /d %%~dp0..\
echo.
echo rem # �g�p����R�s�[�A�v���P�[�V������I�����܂�
echo call :copy_app_detect
echo rem copy^(Default^), fac^(FastCopy^), ffc^(FireFileCopy^)
echo rem set copy_app_flag=%copy_app_flag%
echo.
echo echo �\�[�X�����[�J���ɃR�s�[���Ă��܂�. . .[%%date%% %%time%%]
echo rem # %%large_tmp_dir%% �̑��݊m�F����і����`�F�b�N
echo if not exist "%%large_tmp_dir%%" ^(
echo     echo �傫�ȃt�@�C�����o�͂���ꎞ�t�H���_ %%%%large_tmp_dir%%%% �����݂��܂���A����ɃV�X�e���̃e���|�����t�H���_�ő�p���܂��B
echo     set large_tmp_dir=%%tmp%%
echo ^)
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\
echo rem # �G���R�[�h�c�[�����܂Ƃ߂��f�B���N�g�����������ϐ�ENCTOOLSROOTPATH����`����Ă��邩�m�F
echo call :toolsdircheck
echo rem # parameter�t�@�C�����̃\�[�X�t�@�C���ւ̃t���p�X^(src_file_path^)�����o
echo call :src_file_path_check
echo rem # ���o�����\�[�X�t�@�C���ւ̃t���p�X�̒�����t�@�C����^(src_file_name^)�̕����݂̂𒊏o
echo call :src_file_name_extraction "%%src_file_path%%"
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o
echo call :project_name_check
echo rem # parameter�t�@�C������MPEG-2�f�R�[�_�[�^�C�v^(mpeg2dec_select_flag^)�����o
echo call :mpeg2dec_select_flag_check
echo rem # parameter�t�@�C�����̋����R�s�[�t���O^(force_copy_src^)�����o
echo call :force_src_copy_check
echo rem # parameter�t�@�C������TsSplitter�I�v�V�����p�����[�^�[^(tssplitter_opt_param^)�����o
echo call :tssplitter_opt_param_check
echo rem # �\�[�X���f�B�A���^(src_media_type^)�����o
echo call :src_media_type_check "%%src_file_path%%"
echo.
echo rem # �e���s�t�@�C�������݂��邩�m�F�B���݂��Ȃ��ꍇENCTOOLSROOTPATH������T������A�������̓V�X�e���̒T���p�X�Ɉς˂�
echo rem # ����ł�������Ȃ��ꍇ�A�R�}���h�v�����v�g�W����copy�R�}���h���g�p����
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
echo rem # �e����s�t�@�C���ւ̃p�X���A�ŏI�I�ɂǂ̂悤�Ȓl�ɂȂ������m�F�B
echo echo FireFileCopy: %%ffc_path%%
echo echo FastCopy    : %%fac_path%%
echo echo ts2aac      : %%ts2aac_path%%
echo echo ts_parser   : %%ts_parser_path%%
echo echo faad        : %%faad_path%%
echo echo FakeAacWav  : %%FAW_path%%
echo echo TsSplitter  : %%TsSplitter_path%%
echo echo.
echo rem # �e������
echo echo �\�[�X�t�@�C���ւ̃t���p�X: %%src_file_path%%
echo echo �\�[�X�t�@�C����  �F %%src_file_name%%
echo echo �v���W�F�N�g��    �F %%project_name%%
echo echo �R�s�[�\�[�X�t���O : %%force_copy_src%%
echo echo �@0: �\�[�X���l�b�g���[�N�t�H���_�̏ꍇ�̂݃R�s�[
echo echo �@1: �\�[�X�̃��f�B�A�^�C�v�Ɋ֌W�Ȃ��R�s�[
echo echo �\�[�X���f�B�A��� : %%src_media_type%%
echo echo �@1�F�����[�o�u���h���C�u^(USB������/SD�J�[�h/FD�Ȃ�^)
echo echo �@2�FHDD
echo echo �@3�F�l�b�g���[�N�h���C�u
echo echo �@4�FCD-ROM/CD-R/DVD-ROM/DVD-R�Ȃ�
echo echo �@5�FRAM�f�B�X�N
echo.
echo :main
echo rem //----- main�J�n -----//
echo title %%project_name%%
echo set type-count=
echo set tssplitter_sepa_count=^0
echo set faad_audio_sep_flag=^0
echo if exist ".\avs\LoadSrc_Video.avs" ^(
echo     echo �f���pAVS�t�@�C�����ď�����
echo     del ".\avs\LoadSrc_Video.avs"
echo ^)
echo if exist ".\avs\LoadSrc_Audio*.avs" ^(
echo     echo �����pAVS�t�@�C�����ď�����
echo     del ".\avs\LoadSrc_Audio*.avs"
echo ^)
echo if exist ".\log\ts_parser_log.txt" ^(
echo     del ".\log\ts_parser_log.txt"
echo ^)
echo if "%%tssplitter_opt_param%%"=="" ^(
echo     if not exist ".\src\video*%~x1" ^(
echo         if not exist "%%src_file_path%%" ^(
echo             echo �\�[�X�t�@�C����������Ȃ��׏����𑱍s�ł��܂���A���f���܂�
echo             exit /b
echo         ^)
echo         if "%%force_copy_src%%"=="1" ^(
echo             echo �����R�s�[�t���O���L���ȈׁA�\�[�X�����[�J���t�H���_�Ɉꎞ�R�s�[���܂�
echo             call :copy_src_phase
echo         ^) else ^(
echo             if not "%%src_media_type%%"=="2" ^(
echo                 echo �\�[�X�t�@�C�����L�^����Ă��郁�f�B�A�����[�J��HDD�ȊO�ׁ̈A�ꎞ�R�s�[���܂�
echo                 call :copy_src_phase
echo             ^) else ^(
echo                 echo �\�[�X�t�@�C�����L�^����Ă��郁�f�B�A�����[�J��HDD�ł��A�V���{���b�N�����N�̍쐬�����݂܂�
echo                 call :mklink_src_phase
echo             ^)
echo         ^)
echo     ^) else ^(
echo         echo �T�u�f�B���N�g���Ɋ��Ƀ\�[�X�t�@�C�������݂��邽�߃R�s�[�͎��{���܂���
echo     ^)
echo     if exist ".\src\video1.ts" ^(
echo         set input_media_path=.\src\video1.ts
echo     ^) else ^(
echo         call :set_input_media_to_src
echo     ^)
echo     call :exec_audio_process
echo ^) else ^(
echo     echo TsSplitter�I�v�V�������w�肳��Ă��܂��B�\�[�X��TsSplitter�ŕ������܂��B
echo     call :set_input_media_to_src
echo     call :TsSplitter_exec_phase "%%src_file_path%%"
echo ^)
echo rem # faad�������������ďo�͂��ꂽ�ꍇ�͉����`�����l�����X�g���[���̓r���ŕύX����Ă���\��������̂ŁATsSplitter�ł�蒼��
echo rem # ������TsSplitter��-SEPA�n�I�v�V���������s�������т��Ȃ��ꍇ�Ɍ���
echo if "%%faad_audio_sep_flag%%"=="1" ^(
echo     if not %%tssplitter_sepa_count%% GEQ 1 ^(
echo         call :TsSplitter_exec_phase "%%input_media_path%%"
echo     ^)
echo ^)
echo rem �쐬���ꂽ�I�[�f�B�I�pAVS�t�@�C����PID����A�ԂɐU��Ȃ����܂�
echo set audio_faw_avs_num=
echo for /f "delims=" %%%%F in ^('dir /b ".\avs\LoadSrc_AudioFAW_*.avs"'^) do ^(
echo     call :audio_faw_renum "%%%%F"
echo ^)
echo set audio_pcm_avs_num=
echo for /f "delims=" %%%%P in ^('dir /b ".\avs\LoadSrc_AudioPCM_*.avs"'^) do ^(
echo     call :audio_pcm_renum "%%%%P"
echo ^)
echo.
echo title �R�}���h �v�����v�g
echo rem //----- main�I�� -----//
echo echo end %%~nx0 bat job...
echo echo.
echo exit /b
echo.
rem ------------------------------
echo :copy_src_phase
echo if "%%copy_app_flag%%"=="fac" ^(
echo     if exist "%%fac_path%%" ^(
echo         echo FastCopy �ŃR�s�[�����s���܂�
echo         "%%fac_path%%" /cmd=diff /force_close /disk_mode=auto "%%src_file_path%%" /to="..\"
echo     ^) else ^(
echo         set copy_app_flag=copy
echo     ^)
echo ^) else if "%%copy_app_flag%%"=="ffc" ^(
echo     if exist "%%ffc_path%%" ^(
echo         echo FireFileCopy �ŃR�s�[�����s���܂�
echo         "%%ffc_path%%" "%%src_file_path%%" /copy /a /bg /md /nk /ys /to:"..\"
echo     ^) else ^(
echo         set copy_app_flag=copy
echo     ^)
echo ^)
echo if "%%copy_app_flag%%"=="copy" ^(
echo     echo �R�}���h�v�����v�g�W����copy�R�}���h�ŃR�s�[�����s���܂�
echo     copy /z "%%src_file_path%%" "..\"
echo ^)
echo move "..\%%src_file_name%%" ".\src\video1.ts"^> nul
echo exit /b
echo.
rem ------------------------------
echo :mklink_src_phase
echo rem # ver�R�}���h�̏o�͌��ʂ��m�F���AWindowsXP�ȑO��OS�̏ꍇ�̓V���{���b�N�����N���g���Ȃ��̂ő����copy�����s���܂��B
echo for /f "tokens=2 usebackq delims=[]" %%%%W in ^(`ver`^) do ^(
echo     set os_version=%%%%W
echo ^)
echo echo OS %%os_version%%
echo for /f "tokens=2 usebackq delims=. " %%%%V in ^(`echo %%os_version%%`^) do ^(
echo     set major_version=%%%%V
echo ^)
echo if %%major_version%% LEQ 5 ^(
echo     echo ���s����WindowsXP�ȑO��OS�̈׃V���{���b�N�����N���g���܂���B�����copy���������s���܂��B
echo     call :copy_src_phase
echo ^) else ^(
echo     echo �\�[�X�t�@�C���̃V���{���b�N�����N���쐬���܂��B
echo     mklink ".\src\video1.ts" "%%src_file_path%%"
echo     if not exist ".\src\video1.ts" ^(
echo         echo �V���{���b�N�����N�쐬�Ɏ��s���܂����A�������s�����Ă���\��������܂��B
echo         echo �����copy���������s���܂��B
echo         call :copy_src_phase
echo     ^)
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :TsSplitter_exec_phase
echo rem TsSplitter�̃I�v�V�����w�肪���݂���ꍇ�����𐮌`����A�����łȂ��ꍇ�����ł̂ݕ�������
echo rem �J���}�͂��̂܂܂��ƈ����̋�؂蕶���Ƃ��Ĉ����Ă��܂��̂ŁA�ꎞ�I�Ƀ_�u���N�H�[�g�ň͂�
echo set tssplitter_opt_param_mod=%%tssplitter_opt_param:,=","%%
echo if not "%%tssplitter_opt_param%%"=="" ^(
echo     call :tssplitter_opt_shaping %%tssplitter_opt_param_mod%%
echo ^) else ^(
echo     set tssplitter_opt_fix=-EIT -ECM -EMM -SEPAC -1SEG 
echo     set /a tssplitter_sepa_count=tssplitter_sepa_count+^1
echo ^)
echo rem �ŏ�����TsSplitter���g���ꍇ�́A�J�����g�̐e�f�B���N�g���֏o��
echo rem �R�s�[���TsSplitter���g���ꍇ�́A.\src�z���Œ��ڎ��s
echo if exist ".\src\video1.ts" ^(
echo     echo %%TsSplitter_path%% %%tssplitter_opt_fix%%-OUT ".\src" ".\src\video1.ts"
echo     %%TsSplitter_path%% %%tssplitter_opt_fix%%-OUT ".\src" ".\src\video1.ts"
echo ^) else ^(
echo     echo %%TsSplitter_path%% %%tssplitter_opt_fix%%-OUT ".." "%%~1"
echo     %%TsSplitter_path%% %%tssplitter_opt_fix%%-OUT ".." "%%~1"
echo     for /f "delims=" %%%%F in ^('dir /b "..\%%~n1*%%~x1"'^) do ^(
echo         echo �����ΏہF%%%%F
echo         call :move_tssplitter_outfiles "%%%%F" "%%~n1"
echo     ^)
echo ^)
echo rem ������̘A�Ԃɂ���ׂɁA_HD/_SD�͂��ꂼ��_HD-0/_SD-0�Ƀ��l�[��
echo if exist ".\src\video1_HD.ts" ^(
echo     move ".\src\video1_HD.ts" ".\src\video1_HD-0.ts"
echo ^)
echo if exist ".\src\video1_SD.ts" ^(
echo     move ".\src\video1_SD.ts" ".\src\video1_SD-0.ts"
echo ^)
echo echo HD�T�C�Y�t�@�C���̈ꗗ
echo set tssplitter_HD_counter=^0
echo for /f "delims=" %%%%F in ^('dir /b ".\src\video1_HD*.ts"'^) do ^(
echo     echo %%%%F
echo     set /a tssplitter_HD_counter=tssplitter_HD_counter+^1
echo ^)
echo echo SD�T�C�Y�t�@�C���̈ꗗ
echo set tssplitter_SD_counter=^0
echo for /f "delims=" %%%%F in ^('dir /b ".\src\video1_SD*.ts"'^) do ^(
echo     echo %%%%F
echo     set /a tssplitter_SD_counter=tssplitter_SD_counter+^1
echo ^)
echo rem # _HD �t�@�C�������J�E���g^(total^)
echo set HD_total_count=^0
echo :HD_total_count_loop
echo if exist ".\src\video1_HD-%%HD_total_count%%.ts" ^(
echo     set /a HD_total_count=HD_total_count+1
echo     goto :HD_total_count_loop
echo ^) else ^(
echo     set /a HD_total_count=HD_total_count-1
echo ^)
echo rem # �����A�ԂƊ�A�Ԃ̃t�@�C�����e�ʂ��r���A�傫�����̃O���[�v���㑱�̏����ΏۂƂ���B
echo rem # Windows�̃o�b�`�t�@�C���� 2147483647 �܂ł̒l�����v�Z�ł��Ȃ��̂ŁAMB�T�C�Y�Ɋۂߍ���Ōv�Z����B
echo rem # �����ԃt�@�C�����J�E���g^(even^)
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
echo echo �����ԃg�[�^���t�@�C���T�C�Y^(Mbyte^)�F%%HD_even_total_filesize%%
echo rem # ��ԃt�@�C�����J�E���g^(odd^)
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
echo echo ��ԃg�[�^���t�@�C���T�C�Y^(Mbyte^)�F%%HD_odd_total_filesize%%
echo rem # �t�@�C�����e�ʂ��r
echo if %%HD_even_total_filesize%% GEQ %%HD_odd_total_filesize%% ^(
echo     echo �����Ԃ̃g�[�^���t�@�C���T�C�Y���傫���ł��B�ȍ~�̏����͂��̃O���[�v�ɑ΂��čs���܂��B
echo     set HD_tmp_count=^0
echo ^) else ^(
echo     echo ��Ԃ̃g�[�^���t�@�C���T�C�Y���傫���ł��B�ȍ~�̏����͂��̃O���[�v�ɑ΂��čs���܂��B
echo     set HD_tmp_count=^1
echo ^)
echo call :HD_retry_phase
echo exit /b
echo.
rem ------------------------------
echo :tssplitter_opt_shaping
echo rem ���p�X�y�[�X�ŋ�؂�ꂽTsSplitter�I�v�V�����𐮌`����
echo set tssplitter_opt_fix=
echo set tssplitter_opt_uni=%%~^1
echo rem �J���}�������̋�؂蕶���Ƃ��Ĉ����Ă��܂�Ȃ��悤�ꎞ�I�ɕt�^�����_�u���N�H�[�g���O��
echo set tssplitter_opt_uni=%%tssplitter_opt_uni:"=%%
echo :tssplitter_opt_shap_loop
echo set tssplitter_opt_fix=%%tssplitter_opt_fix%%%%tssplitter_opt_uni%% 
echo rem # -SEPA�n�I�v�V�����̏ꍇ�t���O�����Ă�
echo if "%%tssplitter_opt_uni:~0,5%%"=="-SEPA" ^(
echo     set /a tssplitter_sepa_count=tssplitter_sepa_count+^1
echo ^)
echo shift /^1
echo set tssplitter_opt_uni="%%~1"
echo set tssplitter_opt_uni=%%tssplitter_opt_uni:"=%%
echo if not "%%tssplitter_opt_uni%%"=="" ^(
echo     goto :tssplitter_opt_shap_loop
echo ^)
echo rem # faad�ɂ�鉹���`�����l���������������Ă���ɂ�������炸-SEPA�n�I�v�V�������܂܂�Ă��Ȃ��ꍇ�ǉ�����^(���g���C^)
echo if "%%faad_audio_sep_flag%%"=="1" ^(
echo     if "%%tssplitter_sepa_count%%"=="0" ^(
echo         set tssplitter_opt_fix=%%tssplitter_opt_fix%%-SEPAC 
echo         set /a tssplitter_sepa_count=tssplitter_sepa_count+^1
echo     ^)
echo ^)
echo rem # �I�v�V�����̒���-OUT��-FLIST���܂܂�Ă����ꍇ�A���������O����
echo set tssplitter_opt_fix=%%tssplitter_opt_fix:-OUT =%%
echo set tssplitter_opt_fix=%%tssplitter_opt_fix:-FLIST =%%
echo exit /b
echo.
rem ------------------------------
echo :move_tssplitter_outfiles
echo rem �J�����g�f�B���N�g���̐e�f�B���N�g���ɂ���TsSplitter�o�̓t�@�C����.\src�z���Ƀ��l�[�����Ȃ���ړ�����
echo set move_target_fname=%%~^1
echo rem �������؂�o���Ώۂ̒��ɕϐ����܂ޏꍇ�Acall���g���ăT�u���[�`��������
echo call set move_target_alias=%%%%move_target_fname:%%~2=%%%%
echo echo move "..\%%move_target_fname%%" ".\src\video1%%move_target_alias%%"
echo move "..\%%move_target_fname%%" ".\src\video1%%move_target_alias%%"
echo exit /b
echo.
rem ------------------------------
echo :filesize_calc_even
echo rem # �����ԃt�@�C���T�C�Y�v�Z
echo rem set /a HD_even_total_filesize=%%HD_even_total_filesize%%+%%~z1/1024/1024
echo set HD_even_each_filesize=%%~z1
echo set HD_even_each_filesize=%%HD_even_each_filesize:~0,-6%%
echo set /a HD_even_total_filesize=%%HD_even_total_filesize%%+%%HD_even_each_filesize%%
echo exit /b
echo.
rem ------------------------------
echo :filesize_calc_odd
echo rem # ��ԃt�@�C���T�C�Y�v�Z
echo rem set /a HD_odd_total_filesize=%%HD_odd_total_filesize%%+%%~z1/1024/1024
echo set HD_odd_each_filesize=%%~z1
echo set HD_odd_each_filesize=%%HD_odd_each_filesize:~0,-6%%
echo set /a HD_odd_total_filesize=%%HD_odd_total_filesize%%+%%HD_odd_each_filesize%%
echo exit /b
echo.
rem ------------------------------
echo :HD_retry_phase
echo rem # �������ꂽ _HD �e�t�@�C�����ƂɃI�[�f�B�I�������J��Ԃ��܂�
echo :HD_retry_loop
echo set type-count=_HD-%%HD_tmp_count%%
echo call :ext_aac_audio_phase ".\src\video1_HD-%%HD_tmp_count%%.ts"
echo rem call :wav_decode_audio_phase "%%aac_audio_source%%"
echo if not %%HD_tmp_count%% GTR 1 ^(
echo     rem # TsSplitter�����\�[�X�t�@�C���ǂݍ���AVS������
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
echo echo AAC�������o %%type-count%%...[%%date%% %%time%%]
echo set aac_audio_source=
echo set aac_audio_delay=
echo set aac_track_num=^1
echo if "%%mpeg2dec_select_flag%%"=="1" ^(
echo     echo # MPEG-2�f�R�[�_�[�� MPEG2 VFAPI Plug-In ���g�p���܂�
echo     rem echo "%%ts2aac_path%%" -D -i "%%~1" -o "%%large_tmp_dir%%%%project_name%%"
echo     rem "%%ts2aac_path%%" -D -i "%%~1" -o "%%large_tmp_dir%%%%project_name%%"^>^> ".\log\ts2aac_log.txt"
echo     echo "%%ts_parser_path%%" --mode da --delay-type 1 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1"
echo     "%%ts_parser_path%%" --mode da --delay-type 1 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1"^>^> ".\log\ts_parser_log.txt" ^2^>^&^1
echo ^) else if "%%mpeg2dec_select_flag%%"=="2" ^(
echo     echo # MPEG-2�f�R�[�_�[�� DGIndex ���g�p���܂�
echo     echo "%%ts_parser_path%%" --mode da --delay-type 2 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1"
echo     "%%ts_parser_path%%" --mode da --delay-type 2 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1"^>^> ".\log\ts_parser_log.txt" ^2^>^&^1
echo ^) else if "%%mpeg2dec_select_flag%%"=="3" ^(
echo     echo # MPEG-2�f�R�[�_�[�� L-SMASH Works ���g�p���܂�
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
echo echo �I�[�f�B�I�g���b�N[%%aac_track_num%%]�F%%aac_audio_source%%
echo set aac_audio_delay=%%aac_audio_source%%
echo set aac_audio_delay=%%aac_audio_delay:^"=%%
echo set aac_audio_delay=%%aac_audio_delay:*DELAY =%%
echo set aac_audio_delay=%%aac_audio_delay:ms.aac=%%
echo echo �I�[�f�B�I�f�B���C[%%aac_track_num%%]�F%%aac_audio_delay%%
echo set audio_pid=%%aac_audio_source%%
echo set audio_pid=%%audio_pid:"=%%
echo set audio_pid=%%audio_pid:*PID =%%
echo rem set�R�}���h�ɂ�镶����u���ł́A����̃��C���h�J�[�h���@�\���Ȃ��̂�for���ő�p
echo for /f "usebackq tokens=1 delims= " %%%%I in ^('%%audio_pid%%'^) do ^(
echo     set audio_pid=%%%%I
echo ^)
echo echo �I�[�f�B�IPID[%%aac_track_num%%]�F%%audio_pid%%
echo rem # WAV�f�R�[�h^(�v���r���[��CM�J�b�g�Ɏg�p^)
echo call :wav_decode_audio_phase "%%aac_audio_source%%"
echo echo �I�[�f�B�I�pAVS�t�@�C�����쐬���܂�
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
echo echo FAW�I�[�f�B�IAVS[%%audio_faw_avs_num%%]�F".\avs\%%~1"
echo echo ���l�[���F"LoadSrc_AudioFAW_%%audio_faw_avs_num%%.avs"
echo rename ".\avs\%%~1" "LoadSrc_AudioFAW_%%audio_faw_avs_num%%.avs"
echo exit /b
echo.
rem ------------------------------
echo :audio_pcm_renum
echo set /a audio_pcm_avs_num=audio_pcm_avs_num+^1
echo echo PCM�I�[�f�B�IAVS[%%audio_pcm_avs_num%%]�F".\avs\%%~1"
echo echo ���l�[���F"LoadSrc_AudioPCM_%%audio_pcm_avs_num%%.avs"
echo rename ".\avs\%%~1" "LoadSrc_AudioPCM_%%audio_pcm_avs_num%%.avs"
echo exit /b
echo.
rem ------------------------------
echo :wav_decode_audio_phase
echo rem # faad����-D��delay�������o��������ł��O��B
echo rem # faad�� -S �I�v�V�����ɂ���āA�����`�����l�����؂�ւ�����ꍇ�͕����̃t�@�C�����o�͂����B
echo rem # ^(2018/09/07 �ǋL^)FAAD ������ 0.7�łȂ��ƕs���ȉ����`�����l���w�b�_���ɏo�̓t�@�C������������Ă��܂��̂ŁA�Â��o�[�W�������g��Ȃ����B
echo rem # �s�������t���[���̂����C������Ȃ��������̂��t�@�C���o�͂���Ȃ��悤�A�ȉ��̃f�t�H���g�I�v�V�����p�����[�^�[�����O���Ďw��B^(-F 0x3D30D^)
echo rem # "0x2000: Output broken frames (default)."
echo rem # FAAD ������ 0.4�ŁADELAY���܂܂�Ă���ƂȂ���-o�I�v�V�������������ꂵ�܂����̉��^(������0.6�ŏC���ς�^)
echo echo WAV�f�R�[�h %%type-count%%...[%%date%% %%time%%]
echo rem title %%project_name%%
echo echo "%%faad_path%%" -F 0x3D30D -S -d -D %%aac_audio_delay%% -o ".\src\audio_pcm%%type-count%%_PID%%audio_pid%%.wav" "%%~1"
echo "%%faad_path%%" -F 0x3D30D -S -d -D %%aac_audio_delay%% -o ".\src\audio_pcm%%type-count%%_PID%%audio_pid%%.wav" "%%~1"^>^> ".\log\faad_log.txt" ^2^>^&^1
echo set faad_outfile_counter=^0
echo echo �o�͂��ꂽPCM�t�@�C�����A�����`�����l���ŕ�������Ă��Ȃ����J�E���g���܂�
echo echo �����Ώۃt�@�C���F ".\src\audio_pcm%%type-count%%_PID%%audio_pid%%[*].wav"
echo for /f "delims=" %%%%T in ^('dir /b ".\src\audio_pcm%%type-count%%_PID%%audio_pid%%[*].wav"'^) do ^(
echo     echo ���o�t�@�C���F%%%%T
echo     set /a faad_outfile_counter=faad_outfile_counter+^1
echo ^)
echo if %%faad_outfile_counter%% GTR 1 ^(
echo     echo faad�ɂ���ďo�͂��ꂽ�t�@�C�����������o����܂����B
echo     if not %%tssplitter_sepa_count%% GEQ 1 ^(
echo         echo �����`�����l���̐؂�ւ�肪�������Ă��邽�ߌ���TS�t�@�C����TsSplitter�ŕ������Ȃ����K�v������܂��B
echo         echo PCM�����t�@�C������U�폜
echo         del ".\src\audio_pcm*.wav"
echo         echo AAC�����t�@�C����U�폜
echo         del "%%aac_audio_source%%"
echo         echo ����AVS�t�@�C������U�폜
echo         del ".\avs\LoadSrc_Audio*.avs"
echo         set faad_audio_sep_flag=^1
echo     ^) else ^(
echo         echo ����TsSplitter��-SEPA�I�v�V�����t���Ŏ��s�����ɂ��ւ�炸�Ĕ����܂����B�����X�g���[���w�b�_�ɃG���[���܂܂�Ă���\���������ł��B
echo         echo �����`�����l���ύX�ɂ�镪����������faad���ēx���s���Č㑱�̏������p�����܂��B
echo         echo PCM�����t�@�C������U�폜
echo         del ".\src\audio_pcm%%type-count%%*.wav"
echo         echo "%%faad_path%%" -F 0x3D30D -d -D %%aac_audio_delay%% -o ".\src\audio_pcm%%type-count%%.wav" "%%~1"
echo         "%%faad_path%%" -F 0x3D30D -d -D %%aac_audio_delay%% -o ".\src\audio_pcm%%type-count%%.wav" "%%~1"^>^> ".\log\faad_log.txt" ^2^>^&^1
echo         call :ext_faw_audio_phase "%%~1"
echo     ^)
echo ^) else ^(
echo     echo �����`�����l���̐؂�ւ��͌��o����܂���ł����B���̂܂܏����𑱍s���܂��B
echo     rem # FAW�t�@�C���o��
echo     call :ext_faw_audio_phase "%%aac_audio_source%%"
echo     move "%%aac_audio_source%%" ".\src\audio%%type-count%%_%%aac_track_num%%_demux DELAY %%aac_audio_delay%%ms.aac"
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :ext_faw_audio_phase
echo echo FAW�o�� %%type-count%%...[%%date%% %%time%%]
echo echo "%%FAW_path%%" "%%~1" ".\src\audio_faw%%type-count%%_PID%%audio_pid%%.wav"
echo "%%FAW_path%%" "%%~1" ".\src\audio_faw%%type-count%%_PID%%audio_pid%%.wav"
echo exit /b
echo.
rem ------------------------------
echo :src_media_type_check
echo if "%%~d1"=="\\" ^(
echo     echo �\�[�X�t�@�C���ւ̃p�X��UNC�ׁ̈A�l�b�g���[�N�h���C�u�Ƃ��ď������܂�
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
echo rem # AAC�����t�@�C���̕���
echo call :ext_aac_audio_phase "%%input_media_path%%"
echo rem # WAV�f�R�[�h^(�v���r���[��CM�J�b�g�Ɏg�p^)
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
echo     echo �R�s�[�p�A�v���̃p�����[�^�[��������܂���A�f�t�H���g��copy�R�}���h���g�p���܂��B
echo     set copy_app_flag=copy
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :toolsdircheck
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo ���ϐ� ENCTOOLSROOTPATH ������`�ł�
echo     exit /b
echo ^)
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\
echo if exist "%%ENCTOOLSROOTPATH%%" ^(
echo     exit /b
echo ^) else ^(
echo     echo ���ϐ�ENCTOOLSROOTPATH���L���ȃp�X�ł͂���܂���
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
echo     echo ��MPEG-2�f�R�[�_�[�̎w�肪������܂���, MPEG2 VFAPI Plug-In���g�p���܂�
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
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set ffc_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :ffc_env_search %%~nx1
echo exit /b
echo :ffc_env_search
echo set ffc_path=%%~$PATH:1
echo if "%%ffc_path%%"=="" echo FireFileCopy��������܂���A����ɃR�}���h�v�����v�g�W����copy�R�}���h���g�p���܂��B
echo exit /b
echo.
rem ------------------------------
echo :find_fac
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set fac_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :fac_env_search %%~nx1
echo exit /b
echo :fac_env_search
echo set fac_path=%%~$PATH:1
echo if "%%fac_path%%"=="" echo FastCopy��������܂���A����ɃR�}���h�v�����v�g�W����copy�R�}���h���g�p���܂��B
echo exit /b
echo.
rem ------------------------------
echo :find_ts2aac
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set ts2aac_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :ts2aac_env_search %%~nx1
echo exit /b
echo :ts2aac_env_search
echo set ts2aac_path=%%~$PATH:1
echo if "%%ts2aac_path%%"=="" ^(
echo     echo ts2aac��������܂���B
echo     set ts2aac_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_ts_parser
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set ts_parser_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :ts_parser_env_search %%~nx1
echo exit /b
echo :ts_parser_env_search
echo set ts_parser_path=%%~$PATH:1
echo if "%%ts_parser_path%%"=="" ^(
echo     echo ts_parser��������܂���B
echo     set ts_parser_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_faad
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set faad_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :faad_env_search %%~nx1
echo exit /b
echo :faad_env_search
echo set faad_path=%%~$PATH:1
echo if "%%faad_path%%"=="" ^(
echo    echo faad��������܂���B
echo     set faad_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_FAW
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set FAW_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :FAW_env_search %%~nx1
echo exit /b
echo :FAW_env_search
echo set FAW_path=%%~$PATH:1
echo if "%%FAW_path%%"=="" ^(
echo     echo FAW��������܂���B
echo     set FAW_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_TsSplitter
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set TsSplitter_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :TsSplitter_env_search %%~nx1
echo exit /b
echo :TsSplitter_env_search
echo set TsSplitter_path=%%~$PATH:1
echo if "%%TsSplitter_path%%"=="" ^(
echo     echo TsSplitter��������܂���B
echo     set TsSplitter_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
)>> "%copysrc_batfile_path%"
exit /b


:make_d2vfile_phase
rem # DGIndex�ɓǂݍ��܂���ׂ�.d2v�t�@�C�����쐬����
rem # DGIndex���g�p���Ȃ��ꍇ�͓��Y�֐��X�L�b�v
if not "%mpeg2dec_select_flag%"=="2" exit /b
type nul > "%d2vgen_batfile_path%"
echo @echo off>> "%d2vgen_batfile_path%"
echo setlocal>> "%d2vgen_batfile_path%"
echo cd /d %%~dp0..\>> "%d2vgen_batfile_path%"
echo.>> "%d2vgen_batfile_path%"
echo echo DGIndex�̃v���W�F�N�g�t�@�C��(.d2v)���쐬���܂�[%%date%% %%time%%]>> "%d2vgen_batfile_path%"
call :d2v_exist_checker
echo echo DGIndex�̃v���W�F�N�g�t�@�C��(.d2v)�쐬��...>> "%d2vgen_batfile_path%"
echo echo ===============================================================>> "%d2vgen_batfile_path%"
echo echo �I�v�V�����F%dgindex_options_normal% >> "%d2vgen_batfile_path%"
echo echo ===============================================================>> "%d2vgen_batfile_path%"
echo call :dgindex_run "%~1">> "%d2vgen_batfile_path%"
echo exit /b>> "%d2vgen_batfile_path%"
echo.>> "%d2vgen_batfile_path%"
echo :dgindex_run>> "%d2vgen_batfile_path%"
echo rem # ���o�͂̃p�X���΃p�X�ɕϊ����Ă���DGIndex�ɓn���܂�>> "%d2vgen_batfile_path%"
echo %dgindex_path% -i "%%~f1" -o "%%~dpn1" %dgindex_options_normal% >> "%d2vgen_batfile_path%"
echo exit /b>> "%d2vgen_batfile_path%"
rem # ���C���o�b�`�t�@�C���ɓo�^
echo rem # DGMPDec�v���W�F�N�g�t�@�C��(.d2v)�������ꍇ�ɍ쐬>>"%main_bat_file%"
echo call ".\bat\DGMPGDec_prjct.bat">>"%main_bat_file%"
echo.>>"%main_bat_file%"
exit /b
:d2v_exist_checker
echo if exist "%~dpn1.d2v" ^(>> "%d2vgen_batfile_path%"
echo     echo �I���ɓ�����.d2v�t�@�C�������݂���ׁA�������X�L�b�v���܂��I>> "%d2vgen_batfile_path%"
echo     exit /b>> "%d2vgen_batfile_path%"
echo ^)>> "%d2vgen_batfile_path%"
rem ------------------------------
exit /b


:Video_Encoding_phase
rem ### x264/x265�G���R�[�h�����肷�邽�߂̃X�e�b�v
rem # H.265/HEVC�v���t�@�C�����x���Q�l����
rem https://www.jstage.jst.go.jp/article/itej/67/7/67_553/_pdf
rem # sar�̎w��B�����ɗv���p�X�y�[�X
if "%videoAspectratio_option%"=="video_par1x1_option" (
    set video_sar_option=--sar 1:1 
) else if "%videoAspectratio_option%"=="video_par4x3_option" (
    set video_sar_option=--sar 4:3 
) else if "%videoAspectratio_option%"=="video_par40x33_option" (
    set video_sar_option=--sar 40:33 
) else if "%videoAspectratio_option%"=="video_par10x11_option" (
    set video_sar_option=--sar 10:11 
) else (
    echo �� �A�X�y�N�g�̎w�肪����܂���Isar 1:1�ő�p���܂� ��
    set video_sar_option=--sar 1:1 
)
rem # x264/x265/QSVEncC/NVEncC�ɂ��G���R�[�h�ݒ���������ދ[���֐�
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
    echo �� �v���t�@�C�����x���̎w�肪����܂���I ��
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
rem # CRF�l���ݒ肳��Ă���ꍇ�̒u���t�F�[�Y
if not "%crf_value%"=="" (
    call :x264_Encode_option_shape %x264_Encode_option%
    call :x265_Encode_option_shape %x265_Encode_option%
)
rem # IDR�t���[���̍ő�Ԋu(�V�[�N���x����)�̐ݒ�
set x265_keyint= --keyint 240 --min-keyint 1
rem # itvfr���g���ꍇ�́AItsCut()�p�ݒ�
if "%deinterlace_filter_flag%"=="itvfr" (
    set bat_start_wait=start "%~nx1 �̃G���R�[�h..." /wait 
) else (
    set bat_start_wait=
)
echo rem # �r�f�I�G���R�[�h�̎��s�t�F�[�Y>>"%main_bat_file%"
echo call ".\bat\video_encode.bat">> "%main_bat_file%"
echo.>> "%main_bat_file%"
rem ------------------------------
(
echo @echo off
echo setlocal
echo echo start %%~nx0 bat job...
echo cd /d %%~dp0..\
echo.
echo rem # �g�p����G���R�[�_�[�̃^�C�v���w�肵�܂�
echo call :video_codecparam_detect
echo rem x264, x265, qsv_h264, qsv_hevc, nvenc_h264, nvenc_hevc
echo rem set video_encoder_type=%video_encoder_type%
echo.
echo rem # x264, x265, QSVEncC, NVEncC�̃G���R�[�h�I�v�V������ݒ�
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
echo rem # �G���R�[�h�c�[�����܂Ƃ߂��f�B���N�g�����������ϐ�ENCTOOLSROOTPATH����`����Ă��邩�m�F
echo call :toolsdircheck
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o
echo call :project_name_check
echo rem # parameter�t�@�C�����̃C���^�[���[�X�����t���O^(deinterlace_filter_flag^)�����o
echo call :deinterlace_filter_flag_check
echo.
echo rem # �e���s�t�@�C�������݂��邩�m�F�B���݂��Ȃ��ꍇENCTOOLSROOTPATH������T������A�������̓V�X�e���̒T���p�X�Ɉς˂�
)>> "%video_encode_batfile_path%"
echo if exist "%x264_path%" ^(set x264_path=%x264_path%^) else ^(call :find_x264 "%x264_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%x265_path%" ^(set x265_path=%x265_path%^) else ^(call :find_x265 "%x265_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%qsvencc_path%" ^(set qsvencc_path=%qsvencc_path%^) else ^(call :find_qsvencc "%qsvencc_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%nvencc_path%" ^(set nvencc_path=%nvencc_path%^) else ^(call :find_qsvencc "%nvencc_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%avs4x26x_path%" ^(set avs4x26x_path=%avs4x26x_path%^) else ^(call :find_avs4x26x "%avs4x26x_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%avs2pipe_path%" ^(set avs2pipe_path=%avs2pipe_path%^) else ^(call :find_avs2pipe "%avs2pipe_path%"^)>> "%video_encode_batfile_path%"
(
echo.
echo rem # �e����s�t�@�C���ւ̃p�X���A�ŏI�I�ɂǂ̂悤�Ȓl�ɂȂ������m�F�B
echo echo x264    : %%x264_path%%
echo echo x265    : %%x265_path%%
echo echo QSVEncC : %%qsvencc_path%%
echo echo NVEncC  : %%nvencc_path%%
echo echo avs4x26x: %%avs4x26x_path%%
echo echo avs2pipe: %%avs2pipe_path%%
echo echo.
echo rem # �e������
echo echo �v���W�F�N�g��    �F %%project_name%%
echo echo �C���^�[���[�X�����F %%deinterlace_filter_flag%%
echo.
echo rem # �G���R�[�h�I�v�V�����I�[�␳
echo if not "%%x264_enc_param:~-1%%"==" " set x264_enc_param=%%x264_enc_param%% 
echo if not "%%x265_enc_param:~-1%%"==" " set x265_enc_param=%%x265_enc_param%% 
echo if not "%%qsv_h264_enc_param:~-1%%"==" " set qsv_h264_enc_param=%%qsv_h264_enc_param%% 
echo if not "%%qsv_hevc_enc_param:~-1%%"==" " set qsv_hevc_enc_param=%%qsv_hevc_enc_param%% 
echo if not "%%nvenc_h264_enc_param:~-1%%"==" " set nvenc_h264_enc_param=%%nvenc_h264_enc_param%% 
echo if not "%%nvenc_hevc_enc_param:~-1%%"==" " set nvenc_hevc_enc_param=%%nvenc_hevc_enc_param%% 
echo echo.
echo :main
echo rem //----- main�J�n -----//
echo title %%project_name%%
echo rem # .def�t�@�C�����̃t���[�����[�g�w��̌���
echo if "%%deinterlace_filter_flag%%"=="Its" ^(
echo     echo �f�C���^�[���[�X�t���O��Its�ׁ̈A.def�t�@�C�����̃t���[�����[�g�w����J�E���g���܂��B
echo     call :def_file_composition_check
echo     echo.
echo ^)
echo.
echo rem # �t���[�����[�g�I�v�V����������
echo rem # �f�C���^�[���[�X��Its�t���O���w�肳��Ă���ꍇ.def�̒��g���S��30fps/60fps�̑g�ݍ��킹�̏ꍇ��
echo rem # 30000/1001�A����ȊO��24000/1001���w�肷��^(60000/1001��120000/1001�ł�crf�̃��[�g�R���g���[���������^)
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
echo rem # ����G���R�[�h���s�t�F�[�Y
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
echo title �R�}���h �v�����v�g
echo rem //----- main�I�� -----//
echo echo end %%~nx0 bat job...
echo echo.
echo exit /b
echo.
rem ------------------------------
echo :x264_exec_phase
echo echo x264�G���R�[�h. . .[%%date%% %%time%%]
echo echo "%%avs4x26x_path%%" -L "%%x264_path%%" %%x264_enc_param%%%%encoder_fps_opt%%--output ".\tmp\main_temp.264" "main.avs"
echo %bat_start_wait%"%%avs4x26x_path%%" -L "%%x264_path%%" %%x264_enc_param%%%%encoder_fps_opt%%--output ".\tmp\main_temp.264" "main.avs"
echo exit /b
echo.
rem ------------------------------
echo :x265_exec_phase
echo echo x265�G���R�[�h. . .[%%date%% %%time%%]
echo echo "%%avs4x26x_path%%" -L "%%x265_path%%" %%x265_enc_param%%%%encoder_fps_opt%%-o ".\tmp\main_temp.265" "main.avs"
echo %bat_start_wait%"%%avs4x26x_path%%" -L "%%x265_path%%" %%x265_enc_param%%%%encoder_fps_opt%%-o ".\tmp\main_temp.265" "main.avs"
echo exit /b
echo.
rem ------------------------------
echo :qsv_h264_exec_phase
echo echo QSVEncC^^^(H.264/AVC^^^)�G���R�[�h. . .[%%date%% %%time%%]
echo echo "%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%qsvencc_path%%" %%qsv_h264_enc_param%%%%encoder_fps_opt%%--codec h264 -i - -o ".\tmp\main_temp.264"
echo %bat_start_wait%"%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%qsvencc_path%%" %%qsv_h264_enc_param%%%%encoder_fps_opt%%--codec h264 -i - -o ".\tmp\main_temp.264"
echo exit /b
echo.
rem ------------------------------
echo :qsv_hevc_exec_phase
echo echo QSVEncC^^^(H.265/HEVC^^^)�G���R�[�h. . .[%%date%% %%time%%]
echo echo "%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%qsvencc_path%%" %%qsv_hevc_enc_param%%%%encoder_fps_opt%%--codec hevc -i - -o ".\tmp\main_temp.265"
echo %bat_start_wait%"%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%qsvencc_path%%" %%qsv_hevc_enc_param%%%%encoder_fps_opt%%--codec hevc -i - -o ".\tmp\main_temp.265"
echo exit /b
echo.
rem ------------------------------
echo :nvenc_h264_exec_phase
echo echo NVEncC^^^(H.264/AVC^^^)�G���R�[�h. . .[%%date%% %%time%%]
echo echo "%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%nvencc_path%%" %%nvenc_h264_enc_param%%%%encoder_fps_opt%%--codec h264 -i - -o ".\tmp\main_temp.264"
echo %bat_start_wait%"%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%nvencc_path%%" %%nvenc_h264_enc_param%%%%encoder_fps_opt%%--codec h264 -i - -o ".\tmp\main_temp.264"
echo exit /b
echo.
rem ------------------------------
echo :nvenc_hevc_exec_phase
echo echo NVEncC^^^(H.265/HEVC^^^)�G���R�[�h. . .[%%date%% %%time%%]
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
echo     echo ��QSVEnc�Ŏ��s�\�Ȋ��������ׁA�����x264�ŃG���R�[�h���܂�
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
echo     echo ��QSVEnc�Ŏ��s�\�Ȋ��������ׁA�����x265�ŃG���R�[�h���܂�
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
echo     echo ��NVEnc�Ŏ��s�\�Ȋ��������ׁA�����x264�ŃG���R�[�h���܂�
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
echo     echo ��NVEnc�Ŏ��s�\�Ȋ��������ׁA�����x265�ŃG���R�[�h���܂�
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
echo if not "%%def_24fps_flag%%"=="0" echo .def����24fps��`������܂�
echo if not "%%def_30fps_flag%%"=="0" echo .def����30fps��`������܂�
echo if not "%%def_60fps_flag%%"=="0" echo .def����60fps��`������܂�
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
echo     echo �r�f�I�G���R�[�h�̃R�[�f�b�N�w�肪������܂���B����Ƀf�t�H���g��x264���g�p���܂��B
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
echo     echo ���ϐ� ENCTOOLSROOTPATH ������`�ł�
echo     exit /b
echo ^)
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\
echo if exist "%%ENCTOOLSROOTPATH%%" ^(
echo     exit /b
echo ^) else ^(
echo     echo ���ϐ�ENCTOOLSROOTPATH���L���ȃp�X�ł͂���܂���
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
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set x264_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :x264_env_search "%%~nx1"
echo exit /b
echo :x264_env_search
echo set x264_path=%%~$PATH:1
echo if "%%x264_path%%"=="" ^(
echo     echo x264��������܂���
echo     set x264_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_x265
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set x265_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :x265_env_search "%%~nx1"
echo exit /b
echo :x265_env_search
echo set x265_path=%%~$PATH:1
echo if "%%x265_path%%"=="" ^(
echo    echo x265��������܂���
echo     set x265_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_qsvencc
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set qsvencc_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :qsvencc_env_search "%%~nx1"
echo exit /b
echo :qsvencc_env_search
echo set qsvencc_path=%%~$PATH:1
echo if "%%qsvencc_path%%"=="" ^(
echo    echo QSVEncC��������܂���
echo     set qsvencc_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_nvencc
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set nvencc_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :nvencc_env_search "%%~nx1"
echo exit /b
echo :nvencc_env_search
echo set nvencc_path=%%~$PATH:1
echo if "%%nvencc_path%%"=="" ^(
echo    echo NVEncC��������܂���
echo     set nvencc_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_avs4x26x
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set avs4x26x_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :avs4x26x_env_search "%%~nx1"
echo exit /b
echo :avs4x26x_env_search
echo set avs4x26x_path=%%~$PATH:1
echo if "%%avs4x26x_path%%"=="" ^(
echo     echo avs4x26x��������܂���
echo     set avs4x26x_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_avs2pipe
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     set avs2pipe_path=%%~nx1
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set avs2pipe_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo     call :avspipe_env_search %%~nx1
echo ^)
echo exit /b
echo :avspipe_env_search
echo set avs2pipe_path=%%~$PATH:1
echo if "%%avs2pipe_path%%"=="" ^(
echo     echo avs2pipe��������܂���
echo     set avs2pipe_path=%%~1
echo ^)
echo exit /b
rem ------------------------------
)>> "%video_encode_batfile_path%"
echo.
echo ### �f������ ###
echo �G���R�[�_�[�F%video_encoder_type%
if "%video_encoder_type%"=="x264" (
    echo �ݒ�F%bat_start_wait%"%avs4x26x_path%" -L "%x264_path%" %x264_Encode_option% %video_sar_option%%x264_VUI_opt%%x264_keyint%%x264_interlace_option%--output ".\tmp\main_temp.264" "main.avs"
) else if "%video_encoder_type%"=="x265" (
    echo �ݒ�F%bat_start_wait%"%avs4x26x_path%" -L "%x265_path%" %x265_Encode_option% %video_sar_option%%x265_VUI_opt%-o ".\tmp\main_temp.265" "main.avs"
) else if "%video_encoder_type%"=="qsv_h264" (
    echo �ݒ�F%bat_start_wait%"%avs2pipe_path%" -y4mp "main.avs" ^| "%qsvencc_path%" %qsv_h264_Encode_option% %video_sar_option%%qsv_VUI_opt%--codec h264 -i - -o ".\tmp\main_temp.264"
) else if "%video_encoder_type%"=="qsv_hevc" (
    echo �ݒ�F%bat_start_wait%"%avs2pipe_path%" -y4mp "main.avs" ^| "%qsvencc_path%" %qsv_hevc_Encode_option% %video_sar_option%%qsv_VUI_opt%--codec hevc -i - -o ".\tmp\main_temp.265"
) else if "%video_encoder_type%"=="nvenc_h264" (
    echo �ݒ�F%bat_start_wait%"%avs2pipe_path%" -y4mp "main.avs" ^| "%nvencc_path%" %nvenc_h264_Encode_option% %video_sar_option%%nvenc_VUI_opt%--codec h264 -i - -o ".\tmp\main_temp.264"
) else if "%video_encoder_type%"=="nvenc_hevc" (
    echo �ݒ�F%bat_start_wait%"%avs2pipe_path%" -y4mp "main.avs" ^| "%nvencc_path%" %nvenc_hevc_Encode_option% %video_sar_option%%nvenc_VUI_opt%--codec hevc -i - -o ".\tmp\main_temp.265"
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
rem # �I�[�f�B�I�̈�ʓI�����̋[���֐��AFAW / neroAacEnc / Bilingual���̏�������������ōs��
if "%audio_job_flag%"=="sox" (
    echo sox ���g�p
) else if "%audio_job_flag%"=="nero" (
    echo neroAacEnc ���g�p
) else if "%audio_job_flag%"=="faw" (
    echo FakeAacWav ���g�p
) else (
    echo ���������̎w�肪�s���ł��A��ւƂ���FakeAacWav ���g�p
)
echo.
echo rem # �I�[�f�B�I�t�@�C���̕ҏW���s�t�F�[�Y>>"%main_bat_file%"
echo call ".\bat\audio_edit.bat">> "%main_bat_file%"
echo.>> "%main_bat_file%"
rem # "%audio_edit_batfile_path%"�ւ̃��_�C���N�g�J�n
(
echo @echo off
echo setlocal
echo echo start %%~nx0 bat job...
echo cd /d %%~dp0..\
echo.
echo rem # �I�[�f�B�I�̏�������֐��Ăяo��
echo call :audio_job_detect
echo rem # Audio edit mode[faw^(Default^), sox, nero]
echo rem audio_job_flag=faw
echo.
echo rem # %%large_tmp_dir%% �̑��݊m�F����і����`�F�b�N
echo if not exist "%%large_tmp_dir%%" ^(
echo     echo �傫�ȃt�@�C�����o�͂���ꎞ�t�H���_ %%%%large_tmp_dir%%%% �����݂��܂���A����ɃV�X�e���̃e���|�����t�H���_�ő�p���܂��B
echo     set large_tmp_dir=%%tmp%%
echo ^)
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\
echo rem # �G���R�[�h�c�[�����܂Ƃ߂��f�B���N�g�����������ϐ�ENCTOOLSROOTPATH����`����Ă��邩�m�F
echo call :toolsdircheck
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o
echo call :project_name_check
echo rem # parameter�t�@�C������MPEG-2�f�R�[�_�[�^�C�v^(mpeg2dec_select_flag^)�����o
echo call :mpeg2dec_select_flag_check
echo rem # parameter�t�@�C�����̃I�[�f�B�I�Q�C���A�b�v�l^(audio_gain^)�����o
echo call :audio_gain_check
echo.
echo rem # �e���s�t�@�C�������݂��邩�m�F�B���݂��Ȃ��ꍇENCTOOLSROOTPATH������T������A�������̓V�X�e���̒T���p�X�Ɉς˂�
)>> "%audio_edit_batfile_path%"
echo if exist "%avs2wav_path%" ^(set avs2wav_path=%avs2wav_path%^) else ^(call :find_avs2wav "%avs2wav_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%sox_path%" ^(set sox_path=%sox_path%^) else ^(call :find_sox "%sox_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%neroAacEnc_path%" ^(set neroAacEnc_path=%neroAacEnc_path%^) else ^(call :find_neroAacEnc_path "%neroAacEnc_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%FAW_path%" ^(set FAW_path=%FAW_path%^) else ^(call :find_FAW "%FAW_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%muxer_path%" ^(set muxer_path=%muxer_path%^) else ^(call :find_muxer "%muxer_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%aacgain_path%" ^(set aacgain_path=%aacgain_path%^) else ^(call :find_aacgain "%aacgain_path%"^)>> "%audio_edit_batfile_path%"
(
echo.
echo rem # �e����s�t�@�C���ւ̃p�X���A�ŏI�I�ɂǂ̂悤�Ȓl�ɂȂ������m�F�B
echo echo avs2wav       : %%avs2wav_path%%
echo echo sox           : %%sox_path%%
echo echo neroAacEnc    : %%neroAacEnc_path%%
echo echo FakeAacWav    : %%FAW_path%%
echo echo muxer^(L-SMASH^): %%muxer_path%%
echo echo AACGain       : %%aacgain_path%%
echo.
echo rem �����Ӂ�
echo rem TS�t�@�C���̒��ɂ́A�ԑg�؂�ւ��Ȃǂ̃^�C�~���O�Ńr�f�I�ƃI�[�f�B�I�̊J�n�ʒu������Ȃ����Ƃ�����^(PCR Wrap-around���^)
echo rem TsSplitter��PMT^(ProgramMapTable^)���ɕ���^(-SEP3�I�v�V����^)�ŉ�����邩�APCR Wrap-around�΍�ς݂̃f�R�[�_�[���g�p���鎖
echo rem muxer �͓��͂Ɏw�肳�ꂽmp4�R���e�i�̂����ŏ��̃g���b�N���������p���Ȃ��̂ŁA�}���`�g���b�N�̉\���̂��鉹���͂����ł͈���Ȃ�
echo.
echo :main
echo rem //----- main�J�n -----//
echo title %%project_name%%
echo if "%%audio_job_flag%%"=="sox" ^(
echo     call :Bilingual_audio_encoding
echo ^) else if "%%audio_job_flag%%"=="nero" ^(
echo     call :Stereo_audio_encoding
echo ^) else if "%%audio_job_flag%%"=="faw" ^(
echo     call :FAW_audio_encoding
echo ^)
echo title �R�}���h �v�����v�g
echo rem //----- main�I�� -----//
echo echo end %%~nx0 bat job...
echo echo.
echo exit /b
echo.
rem ------------------------------
echo :Bilingual_audio_encoding
echo rem # �񃖍��ꉹ���̏ꍇ�̃G���R�[�h�����Asox���g���č��E�̃`�����l���𕪊�����
echo echo sox ���g�p
echo set audio_pcm_avs_num=^0
echo for /f "delims=" %%%%P in ^('dir /b ".\avs\LoadSrc_AudioPCM_*.avs"'^) do ^(
echo     call :make_pcmsrc_avs "%%%%P"
echo     call :Bilingual_audio_exec
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :Bilingual_audio_exec
echo echo avs2wav�ŕҏW�� %%audio_pcm_avs_num%%. . .[%%date%% %%time%%]
echo rem # avs2wav�̓o�[�W�����ɂ���Ă̓C���v�b�g�t�@�C���ɑ��΃p�X���w�肷��ƃG���[�Œ�~����̂ŁA�ꎞ�I�Ƀf�B���N�g����ύX���܂�
echo pushd avs
echo "%%avs2wav_path%%" "audio_export_pcm_%%audio_pcm_avs_num%%.avs" "%%large_tmp_dir%%%%project_name%%_%%audio_pcm_avs_num%%.wav"^>nul
echo popd
echo echo �񃖍��ꉹ���̕ҏW��. . .[%%date%% %%time%%]
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
echo rem # �X�e���I�����Ƃ��čăG���R�[�h����ꍇ�̏���
echo echo neroAacEnc ���g�p
echo set audio_pcm_avs_num=^0
echo for /f "delims=" %%%%P in ^('dir /b ".\avs\LoadSrc_AudioPCM_*.avs"'^) do ^(
echo     call :make_pcmsrc_avs "%%%%P"
echo     call :Stereo_audio_exec
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :Stereo_audio_exec
echo echo avs2wav�ŕҏW��[%%audio_pcm_avs_num%%]. . .[%%date%% %%time%%]
echo rem # avs2wav�̓o�[�W�����ɂ���Ă̓C���v�b�g�t�@�C���ɑ��΃p�X���w�肷��ƃG���[�Œ�~����̂ŁA�ꎞ�I�Ƀf�B���N�g����ύX���܂�
echo pushd avs
echo "%%avs2wav_path%%" "audio_export_pcm_%%audio_pcm_avs_num%%.avs" "%%large_tmp_dir%%%%project_name%%_%%audio_pcm_avs_num%%.wav"^>nul
echo popd
echo echo neroAacEnc�ŃG���R�[�h��. . .[%%date%% %%time%%]
echo "%%neroAacEnc_path%%" -q 0.40 -if "%%large_tmp_dir%%%%project_name%%_%%audio_pcm_avs_num%%.wav" -of ".\tmp\main_audio_%%audio_pcm_avs_num%%.m4a"
echo call :AACGain_phase ".\tmp\main_audio_%%audio_pcm_avs_num%%.m4a"
echo del "%%large_tmp_dir%%%%project_name%%_%%audio_pcm_avs_num%%.wav"
echo exit /b
echo.
rem ------------------------------
echo :FAW_audio_encoding
echo rem # FAW���g�p���ăJ�b�g�݂̂̏���
echo echo FakeAacWav ���g�p
echo set audio_faw_avs_num=^0
echo for /f "delims=" %%%%F in ^('dir /b ".\avs\LoadSrc_AudioFAW_*.avs"'^) do ^(
echo     call :make_fawsrc_avs "%%%%F"
echo     call :FAW_audio_exec
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :FAW_audio_exec
echo echo avs2wav�ŕҏW��[%%audio_faw_avs_num%%]. . .[%%date%% %%time%%]
echo rem # avs2wav�̓o�[�W�����ɂ���Ă̓C���v�b�g�t�@�C���ɑ��΃p�X���w�肷��ƃG���[�Œ�~����̂ŁA�ꎞ�I�Ƀf�B���N�g����ύX���܂�
echo pushd avs
echo echo avs2wav�͏o�͐�t�H���_�̎w����@����ŕs���I�����邱�Ƃ�����̂Œ���
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
echo rem # AACGain���g�p���ĉ��ʂ��A�b�v���鏈��
echo rem # AACGain�͉����`�����l����1���������܂܂Ȃ��t�@�C�����������ł��Ȃ��̂ŁAMUX�O�Ɏ��{����
echo echo AACGain�ŉ��ʒ���. . .[%%date%% %%time%%]
echo echo "%%~1" ���I�[�f�B�I�Q�C���A�b�v���܂�
echo if "%%audio_gain%%"=="0" ^(
echo     echo �I�[�f�B�I�Q�C���A�b�v�l��0�ׁ̈A�������X�L�b�v���܂�
echo ^) else ^(
echo     echo �Q�C���A�b�v�l�� %%audio_gain%% �ł�
echo     "%%aacgain_path%%" /g %%audio_gain%% "%%~1"
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :make_fawsrc_avs
echo set /a audio_faw_avs_num=audio_faw_avs_num+^1
echo rem # �^��WAV^(FAW^)���o�͂���ۂɐ��`�ς�Trim����n�����߂�AVS�t�@�C���쐬
echo ^(
echo echo ##### �^��WAV^^^(FAW^^^)���o�͂���ۂɐ��`�ς�Trim����n�����߂�AVS #####
echo echo #//--- �v���O�C���ǂݍ��ݕ����̃C���|�[�g ---//
echo echo Import^^^(".\LoadPlugin.avs"^^^)
echo echo.
echo echo #//--- �\�[�X�̓ǂݍ��� ---//^)^> ".\avs\audio_export_faw_%%audio_faw_avs_num%%.avs"
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
echo echo #//--- �t�B�[���h�I�[�_�[ ---//
echo echo #AssumeFrameBased^^^(^^^).ComplementParity^^^(^^^)    #�g�b�v�t�B�[���h���x�z�I
echo echo.
echo echo #//--- Trim���C���|�[�g ---//
echo echo Import^^^("..\trim_chars.txt"^^^)
echo echo.
echo echo return last^)^>^> ".\avs\audio_export_faw_%%audio_faw_avs_num%%.avs"
echo exit /b
echo.
rem ------------------------------
echo :make_pcmsrc_avs
echo rem # PCM WAV���o�͂���ۂɐ��`�ς�Trim����n�����߂�AVS�t�@�C���쐬
echo set /a audio_pcm_avs_num=audio_pcm_avs_num+^1
echo ^(
echo echo ##### PCM WAV���o�͂���ۂɐ��`�ς�Trim����n�����߂�AVS #####
echo echo #//--- �v���O�C���ǂݍ��ݕ����̃C���|�[�g ---//
echo echo Import^^^(".\LoadPlugin.avs"^^^)
echo echo.
echo echo #//--- �\�[�X�̓ǂݍ��� ---//^)^> ".\avs\audio_export_pcm_%%audio_pcm_avs_num%%.avs"
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
echo echo #//--- �t�B�[���h�I�[�_�[ ---//
echo echo #AssumeFrameBased^^^(^^^).ComplementParity^^^(^^^)    #�g�b�v�t�B�[���h���x�z�I
echo echo.
echo echo #//--- Trim���C���|�[�g ---//
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
echo     echo �p�����[�^�t�@�C���̒��ɃI�[�f�B�I�̏����w�肪������܂���B�f�t�H���g��FAW���g�p���܂��B
echo     set audio_job_flag=faw
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :toolsdircheck
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo ���ϐ� ENCTOOLSROOTPATH ������`�ł�
echo     exit /b
echo ^)
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\
echo if exist "%%ENCTOOLSROOTPATH%%" ^(
echo     exit /b
echo ^) else ^(
echo     echo ���ϐ�ENCTOOLSROOTPATH���L���ȃp�X�ł͂���܂���
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
echo     echo ��MPEG-2�f�R�[�_�[�̎w�肪������܂���, MPEG2 VFAPI Plug-In���g�p���܂�
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
echo     echo �p�����[�^�[ audio_gain ������`�ł��B0 �������܂��B
echo     set audio_gain=^0
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_avs2wav
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set avs2wav_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :avs2wav_env_search "%%~nx1"
echo exit /b
echo :avs2wav_env_search
echo set avs2wav_path=%%~$PATH:1
echo if "%%avs2wav_path%%"=="" ^(
echo     echo avs2wav��������܂���
echo     set avs2wav_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_sox
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set sox_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :sox_env_search "%%~nx1"
echo exit /b
echo :sox_env_search
echo set sox_path=%%~$PATH:1
echo if "%%sox_path%%"=="" ^(
echo     echo sox��������܂���
echo     set sox_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_neroAacEnc
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set neroAacEnc_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :neroAacEnc_env_search "%%~nx1"
echo exit /b
echo :neroAacEnc_env_search
echo set neroAacEnc_path=%%~$PATH:1
echo if "%%neroAacEnc_path%%"=="" ^(
echo     echo neroAacEnc��������܂���
echo     set neroAacEnc_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_FAW
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set FAW_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :FAW_env_search "%%~nx1"
echo exit /b
echo :FAW_env_search
echo set FAW_path=%%~$PATH:1
echo if "%%FAW_path%%"=="" ^(
echo     echo FakeAacWav^(FAW^)��������܂���
echo     set FAW_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_muxer
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set muxer_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :muxer_env_search %%~nx1
echo exit /b
echo :muxer_env_search
echo set muxer_path=%%~$PATH:1
echo if "%%muxer_path%%"=="" ^(
echo     echo muxer��������܂���
echo     set muxer_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_aacgain
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set aacgain_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :aacgain_env_search "%%~nx1"
echo exit /b
echo :aacgain_env_search
echo set aacgain_path=%%~$PATH:1
echo if "%%aacgain_path%%"=="" ^(
echo     echo AACGain��������܂���
echo     set aacgain_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
)>> "%audio_edit_batfile_path%"
exit /b


:srt_edit
echo rem # �f�W�^�������̎������o�t�F�[�Y>>"%main_bat_file%"
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
echo rem # %%large_tmp_dir%% �̑��݊m�F����і����`�F�b�N
echo if not exist "%%large_tmp_dir%%" ^(
echo     echo �傫�ȃt�@�C�����o�͂���ꎞ�t�H���_ %%%%large_tmp_dir%%%% �����݂��܂���A����ɃV�X�e���̃e���|�����t�H���_�ő�p���܂��B
echo     set large_tmp_dir=%%tmp%%
echo ^)
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\
echo rem # �G���R�[�h�c�[�����܂Ƃ߂��f�B���N�g�����������ϐ�ENCTOOLSROOTPATH����`����Ă��邩�m�F
echo call :toolsdircheck
echo rem # parameter�t�@�C�����̃\�[�X�t�@�C���ւ̃t���p�X^(src_file_path^)�����o
echo call :src_file_path_check
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o
echo call :project_name_check
echo.
echo rem # �e���s�t�@�C�������݂��邩�m�F�B���݂��Ȃ��ꍇENCTOOLSROOTPATH������T������A�������̓V�X�e���̒T���p�X�Ɉς˂�
)>> "%srtedit_batfile_path%"
echo if exist "%caption2Ass_path%" ^(set caption2Ass_path=%caption2Ass_path%^) else ^(call :find_caption2Ass "%caption2Ass_path%"^)>> "%srtedit_batfile_path%"
echo if exist "%SrtSync_path%" ^(set SrtSync_path=%SrtSync_path%^) else ^(call :find_SrtSync "%SrtSync_path%"^)>> "%srtedit_batfile_path%"
echo if exist "%nkf_path%" ^(set nkf_path=%nkf_path%^) else ^(call :find_nkf "%nkf_path%"^)>> "%srtedit_batfile_path%"
echo if exist "%sed_path%" ^(set sed_path=%sed_path%^) else ^(call :find_sed "%sed_path%"^)>> "%srtedit_batfile_path%"
echo if exist "%sedscript_path%" ^(set sedscript_path=%sedscript_path%^) else ^(call :find_sedscript "%sedscript_path%"^)>> "%srtedit_batfile_path%"
(
echo.
echo rem # �e����s�t�@�C���ւ̃p�X���A�ŏI�I�ɂǂ̂悤�Ȓl�ɂȂ������m�F�B
echo echo Caption2Ass: %%caption2Ass_path%%
echo echo SrtSync    : %%SrtSync_path%%
echo echo nkf        : %%nkf_path%%
echo echo Onigsed    : %%sed_path%%
echo echo sedscript  : %%sedscript_path%%
echo.
echo :main
echo rem //----- main�J�n -----//
echo title %%project_name%%
echo echo �f�W�^�������̎������o��. . .[%%date%% %%time%%]
echo.
echo rem # Caption2Ass���g�p����TS�t�@�C�����玚���𒊏o���܂�
echo set /a caption2Ass_retrycount=^0
echo rem # Caption2Ass_mod1�ŏo�͂��ꂽsrt�t�@�C���̕����R�[�h��UTF-8
echo rem # -tssp�I�v�V������������TsSplitter�ŉ����������ꂽ�t�@�C���̃^�C���R�[�h���������Ȃ�Ȃ�
echo rem # -forcepcr��forcePCR���[�h�A�I�v�V���������Ŏ��s�����ۂɑ傫���^�C���X�^���v���Y����ꍇ�̂ݎg�p����
echo rem # TsSplitter���g�p�������т�����ꍇ�̂�-tssp�I�v�V�������g�p���܂� ���\�[�X�̎��_�Ŏ��s����Ă����ꍇ�͔��ʕs��
echo if exist ".\src\video1_HD-*.ts" ^(
echo     echo _HD-*.ts�t�@�C�������݂��邽�߁A-tssp�I�v�V�������g�p���܂�
echo     set caption2ass_tssp=-tssp 
echo ^) else if exist ".\src\video1_SD-*.ts" ^(
echo     echo _SD-*.ts�t�@�C�������݂��邽�߁A-tssp�I�v�V�������g�p���܂�
echo     set caption2ass_tssp=-tssp 
echo ^) else ^(
echo     set caption2ass_tssp=
echo ^)
)>> "%srtedit_batfile_path%"
if "%kill_longecho_flag%"=="1" (
    echo if exist "%%src_file_path%%" ^(>> "%srtedit_batfile_path%"
    echo     echo "%%src_file_path%%" ���璊�o���܂�>> "%srtedit_batfile_path%"
    echo     "%%caption2Ass_path%%" -format srt %caption2ass_tssp%"%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.srt"^>nul>> "%srtedit_batfile_path%"
    echo ^) else if exist "%%src_file_path%%" ^(>> "%srtedit_batfile_path%"
    echo     echo "%%src_file_path%%" ���璊�o���܂�>> "%srtedit_batfile_path%"
    echo     "%%caption2Ass_path%%" -format srt %caption2ass_tssp%"%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.srt"^>nul>> "%srtedit_batfile_path%"
    echo ^) else ^(>> "%srtedit_batfile_path%"
    echo     echo �������𒊏o����\�[�X�ƂȂ�TS�t�@�C����������܂���B�����𒆒f���܂��B>> "%srtedit_batfile_path%"
    echo     exit /b>> "%srtedit_batfile_path%"
    echo ^)>> "%srtedit_batfile_path%"
) else (
    echo if exist "%%src_file_path%%" ^(>> "%srtedit_batfile_path%"
    echo     echo "%%src_file_path%%" ���璊�o���܂�>> "%srtedit_batfile_path%"
    echo     "%%caption2Ass_path%%" -format srt %caption2ass_tssp%"%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.srt">> "%srtedit_batfile_path%"
    echo ^) else if exist "%%src_file_path%%" ^(>> "%srtedit_batfile_path%"
    echo     echo "%%src_file_path%%" ���璊�o���܂�>> "%srtedit_batfile_path%"
    echo     "%%caption2Ass_path%%" -format srt %caption2ass_tssp%"%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.srt">> "%srtedit_batfile_path%"
    echo ^) else ^(>> "%srtedit_batfile_path%"
    echo     echo �������𒊏o����\�[�X�ƂȂ�TS�t�@�C����������܂���B�����𒆒f���܂��B>> "%srtedit_batfile_path%"
    echo     exit /b>> "%srtedit_batfile_path%"
    echo ^)>> "%srtedit_batfile_path%"
)
(
echo call :Srt_filesize_check
echo title �R�}���h �v�����v�g
echo rem //----- main�I�� -----//
echo echo end %%~nx0 bat job...
echo echo.
echo exit /b
echo.
rem ------------------------------
echo :Srt_filesize_check
echo rem # srt�t�@�C���̃t�@�C���T�C�Y��3�o�C�g�ȏ�ł���Ύ������܂܂�Ă����Ɣ��f���܂�
echo for %%%%F in ^("%%large_tmp_dir%%%%project_name%%.srt"^) do set srt_filesize=%%%%~zF
echo if %%srt_filesize%% GTR 3 ^(
rem # ��L�̔�r�������""�ł�����Ɛ��l�ł͂Ȃ�������Ƃ��ď�������A���ʌ������r����̂Ŗ�肪�o�� ex^)"10" GTR "3"
echo     call :search_unknown_char
echo     call :SrtCutter
echo ^) else ^(
echo     echo �������݂͂���܂���ł�����
echo     del "%%large_tmp_dir%%%%project_name%%.srt"
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :search_unknown_char
echo rem # �o�͂��ꂽsrt�t�@�C���̒��ɊO����p���t�H���g��\��"[�O"���܂܂�Ă��Ȃ����`�F�b�N���܂�
rem     # �o�͂��ꂽ�����t�@�C���̒��ɖ��m�̊O����p���t�H���g���������T��
rem     # findstr�R�}���h�́A�Ώۂ�Shift_JIS�łȂ���΋@�\���Ȃ��B/N�ōs�ԍ��I�v�V����
echo findstr /N "[�O" "%%large_tmp_dir%%%%project_name%%.srt"^>^> "%%large_tmp_dir%%%%project_name%%_sub.log"
echo for %%%%F in ^("%%large_tmp_dir%%%%project_name%%_sub.log"^) do set srtlog_filesize=%%%%~zF
rem     # findstr�ɂ���ďo�͂��ꂽ���O���L��^(3�o�C�g�ȏ�^)�Ȃ瓝���A��Ȃ�j������
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
echo rem # Trim�ҏW���ꂽ�`�Ղ����邩�`�F�b�N
rem # SrtSync�ŏo�͂��ꂽsrt�t�@�C���̕����R�[�h��Shift_JIS
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%S in ^(`findstr /r Trim^^^(.*^^^) "trim_line.txt"`^) do ^(
echo     set search_trimline=%%%%S
echo ^)
echo if "%%search_trimline%%"=="" ^(
echo     echo ��Trim�ҏW�Ȃ���
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
echo rem # Trim�R�}���h��ǂݍ����srt�t�@�C���̕K�v�ꏊ�����J�b�g���܂�
echo "%%SrtSync_path%%" -mode auto -nopause -trim "trim_line.txt" "%%large_tmp_dir%%%%project_name%%.srt"
echo for %%%%N in ^("%%large_tmp_dir%%%%project_name%%_new.srt"^) do set newsrt_filesize=%%%%~zN
echo if not %%newsrt_filesize%%==0 ^(
echo     echo ���w��͈͂Ɏ������聦
echo     move "%%large_tmp_dir%%%%project_name%%_new.srt" ".\tmp\main_sjis.srt"
echo     move "%%large_tmp_dir%%%%project_name%%.srt" ".\log\exported.srt"
rem     # ASS�������o�͂���ݒ肪�L���ɂȂ��Ă����ꍇ�̂�ASS���o�͂���
rem     # srt�����̏o�͂��I���A�L���͈͂Ɏ��������݂��邱�Ƃ��m�F����Ă���o�͂���
rem     # �������A����Trim�ɂ��킹���J�b�g�ҏW�̎�i���������킹�Ă��Ȃ�
)>> "%srtedit_batfile_path%"
if "%output_ass_flag%"=="1" (
    echo     echo ASS�t�@�C���𒊏o���܂�>> "%srtedit_batfile_path%"
    if "%kill_longecho_flag%"=="1" (
        rem echo     start "�����̒��o��..." /wait "%%caption2Ass_path%%" -format ass %caption2ass_tssp%"%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.ass">> "%srtedit_batfile_path%"
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
echo     echo ���w��͈͂Ɏ����Ȃ��A-forcepcr�I�v�V�����t���ōēx���s���܂���
echo     if %%caption2Ass_retrycount%%==0 ^(
echo         move "%%large_tmp_dir%%%%project_name%%.srt" ".\tmp\exported_noforcepcr.srt"
echo         del "%%large_tmp_dir%%%%project_name%%_new.srt"
echo         call :Re-caption2Ass
echo     ^) else ^(
echo         echo ����Caption2Ass�Ń��g���C�ςׁ݂̈A�����𒆒f���܂�
echo         move "%%large_tmp_dir%%%%project_name%%.srt" ".\tmp\exported_forcepcr.srt"
echo         del "%%large_tmp_dir%%%%project_name%%_new.srt"
echo     ^)
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :Re-caption2Ass
echo rem # �H�ɏo�͂��ꂽsrt�t�@�C�����̎��Ԃ��傫���Y���鎖������̂ŁA-forcepcr�I�v�V�����t���Ń��g���C���܂�
echo rem # -tssp�I�v�V������-forcepcr�I�v�V�����ƕ��p�����SrtSync�̏o�͂�NULL�ɂȂ�P�[�X������̂Ŏg�p���Ȃ�����
echo "%%caption2Ass_path%%" -format srt -forcepcr "%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.srt"^>nul
echo set /a caption2Ass_retrycount=%caption2Ass_retrycount%+^1
echo call :SubEdit_phase
echo exit /b
echo.
rem ------------------------------
echo :toolsdircheck
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo ���ϐ� ENCTOOLSROOTPATH ������`�ł�
echo     exit /b
echo ^)
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\
echo if exist "%%ENCTOOLSROOTPATH%%" ^(
echo     exit /b
echo ^) else ^(
echo     echo ���ϐ�ENCTOOLSROOTPATH���L���ȃp�X�ł͂���܂���
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
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set caption2Ass_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :caption2Ass_env_search "%%~nx1"
echo exit /b
echo :caption2Ass_env_search
echo set caption2Ass_path=%%~$PATH:1
echo if "%%caption2Ass_path%%"=="" ^(
echo     echo Caption2Ass��������܂���
echo     set caption2Ass_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_SrtSync
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set SrtSync_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :SrtSync_env_search "%%~nx1"
echo exit /b
echo :SrtSync_env_search
echo set SrtSync_path=%%~$PATH:1
echo if "%%SrtSync_path%%"=="" ^(
echo     echo SrtSync��������܂���
echo     set SrtSync_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_nkf
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set nkf_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :nkf_env_search "%%~nx1"
echo exit /b
echo :nkf_env_search
echo set nkf_path=%%~$PATH:1
echo if "%%nkf_path%%"=="" ^(
echo     echo nkf��������܂���
echo     set nkf_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_sed
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set sed_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :sed_env_search "%%~nx1"
echo exit /b
echo :sed_env_search
echo set sed_path=%%~$PATH:1
echo if "%%sed_path%%"=="" ^(
echo     echo Onigsed��������܂���
echo     set sed_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_sedscript
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set sedscript_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :sedscript_env_search "%%~nx1"
echo exit /b
echo :sedscript_env_search
echo set sedscript_path=%%~$PATH:1
echo if "%%sedscript_path%%"=="" ^(
echo     echo sedscript��������܂���
echo     set sedscript_path=%%~1
echo ^)
echo exit /b
)>> "%srtedit_batfile_path%"
rem ------------------------------
exit /b


:mux_option_selector
rem # MP4�R���e�i�ւ�mux�ƍŏI�t�H���_�ւ̈ړ��H��
echo rem # �e�g���b�N��MUX�ƍŏI�t�H���_�ւ̈ړ��t�F�[�Y>>"%main_bat_file%"
echo call ".\bat\mux_tracks.bat">>"%main_bat_file%"
echo.>>"%main_bat_file%"
type nul > "%muxtracks_batfile_path%"
rem ------------------------------
(
echo @echo off
echo setlocal
echo.
echo echo start %%~nx0 bat job...
echo echo �e��g���b�N��񓙂̓���. . .[%%date%% %%time%%]
echo chdir /d %%~dp0..\
echo.
echo rem # �g�p����R�s�[�A�v���P�[�V������I�����܂�
echo call :copy_app_detect
echo rem copy^(Default^), fac^(FastCopy^), ffc^(FireFileCopy^)
echo rem set copy_app_flag=%copy_app_flag%
echo.
echo rem # �ŏI�o�͐�t�H���_�����o
echo call :out_dir_detect
echo rem set final_out_dir=%%HOMEDRIVE%%\%%HOMEPATH%%
echo.
echo rem # �g�p����r�f�I�G���R�[�h�R�[�f�b�N�^�C�v�ɉ����Ċg���q�𔻒肷��֐����Ăяo���܂�
echo call :video_extparam_detect
echo rem # �g�p����I�[�f�B�I�����𔻒肷��֐����Ăяo���܂�
echo rem call :audio_job_detect
echo rem # �G���R�[�h�c�[�����܂Ƃ߂��f�B���N�g�����������ϐ�ENCTOOLSROOTPATH����`����Ă��邩�m�F
echo call :toolsdircheck
echo rem # parameter�t�@�C�����̃\�[�X�t�@�C���ւ̃t���p�X^(src_file_path^)�����o
echo call :src_file_path_check
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o
echo call :project_name_check
echo rem # �ړ���̃T�u�t�H���_^(sub_folder_name^)���\�[�X�t�@�C���̐e�f�B���N�g�����Ɍ���
echo call :sub_folder_name_detec "%%src_file_path%%"
echo rem # parameter�t�@�C�����̃C���^�[���[�X�����t���O^(deinterlace_filter_flag^)�����o
echo call :deinterlace_filter_flag_check
echo.
echo rem # �e���s�t�@�C�������݂��邩�m�F�B���݂��Ȃ��ꍇENCTOOLSROOTPATH������T������A�������̓V�X�e���̒T���p�X�Ɉς˂�
echo rem # ����ł�������Ȃ��ꍇ�A�R�}���h�v�����v�g�W����copy�R�}���h���g�p����
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
echo rem # �e����s�t�@�C���ւ̃p�X���A�ŏI�I�ɂǂ̂悤�Ȓl�ɂȂ������m�F�B
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
echo echo �v���W�F�N�g��         �F %%project_name%%
echo echo �T�u�t�H���_��         �F %%sub_folder_name%%
echo echo �C���^�[���[�X����     �F %%deinterlace_filter_flag%%
echo rem �����ӓ_��
echo rem mp4box�͓��{�ꕶ����̎�舵�������肩�W���o�͂�UTF-8�Ȃ̂ŁA���O�ɔ��p�p���Ƀ��l�[�����Ă��珈�����鎖�B
echo.
echo :main
echo rem //----- main�J�n -----//
echo title %%project_name%%
echo.
echo set lang_tokens_param=^1
echo set audio_mux_in_files=
echo rem # MUX�Ώۂ̃t�@�C�������݂��邩�A���킩�ǂ����m�F
echo set tmp-file_error_flag=^0
echo if exist ".\tmp\main_temp%%video_ext_type%%" ^(
echo     call :zero-byte_error_check ".\tmp\main_temp%%video_ext_type%%"
echo ^) else ^(
echo     echo ��"main_temp%%video_ext_type%%" �t�@�C�������݂��܂���
echo     set tmp-file_error_flag=^1
echo ^)
echo if exist ".\tmp\main_audio*.m4a" ^(
echo     for /f "delims=" %%%%A in ^('dir /b ".\tmp\main_audio*.m4a"'^) do ^(
echo         call :zero-byte_error_check ".\tmp\%%%%A"
echo         call :muxer_audio_in_param ".\tmp\%%%%A"
echo     ^)
echo ^) else ^(
echo     echo ��".\tmp\main_audio*.m4a" �t�@�C�������݂��܂���
echo     set tmp-file_error_flag=^1
echo ^)
echo if "%%tmp-file_error_flag%%"=="1" ^(
echo     echo ��MUX�Ώۃt�@�C���ɉ��炩�ُ̈킪���邽�߁AMUX�����𒆒f���܂��B
echo     echo end %%~nx0 bat job...
echo     exit /b
echo ^)
echo.
echo rem # .def�t�@�C�����̃t���[�����[�g�w��̌���
echo if "%%deinterlace_filter_flag%%"=="Its" ^(
echo     echo �f�C���^�[���[�X�t���O��Its�ׁ̈A.def�t�@�C�����̃t���[�����[�g�w����J�E���g���܂��B
echo     call :def_file_composition_check
echo     echo.
echo ^)
echo.
echo rem # �t���[�����[�g�I�v�V����������
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
echo     rem # timelineeditor�� --media-timescale / --media-timebase �I�v�V����������
echo     call :timeline_PTS_opt_detect
echo ^) else ^(
echo     set video_track_fps_opt=
echo ^)
echo.
echo rem # �f���Ɖ�����MUX
echo echo L-SMASH�ŉf���Ɖ�����MUX���܂�[%%date%% %%time%%]
echo rem # L-SMASH��-chapter�I�v�V������ogg�`���`���v�^�[�t�@�C����ǂݍ��߂Ȃ��׎g�p���܂���B�����mp4chaps���g�p���܂��B
echo rem # --file-format ��mov�𕹗p����Ƌ������s����ɂȂ邽�ߔ񐄏��B
echo rem # alternate_group track�I�v�V������mp4�R���e�i�ł͖�������܂��B
echo echo "%%muxer_path%%" --optimize-pd --file-format mp4 --isom-version 6 -i ".\tmp\main_temp%%video_ext_type%%"%%video_track_fps_opt%% %%audio_mux_in_files%%-o "%%project_name%%.mp4"
echo "%%muxer_path%%" --optimize-pd --file-format mp4 --isom-version 6 -i ".\tmp\main_temp%%video_ext_type%%"%%video_track_fps_opt%% %%audio_mux_in_files%%-o "%%project_name%%.mp4"
echo.
echo rem # �^�C���R�[�h�t�@�C�������݂���ꍇ�Atimelineeditor���g���ă^�C���R�[�h���ߍ��݂��܂�
echo if exist ".\tmp\main.tmc" ^(
echo     if "%%deinterlace_filter_flag%%"=="Its" ^(
echo         rename "%%project_name%%.mp4" "%%project_name%%_raw.mp4"
echo         rem # DtsEdit��H.265/HEVC��Ή�
echo         rem # timelineeditor��--media-timescale�I�v�V�������g�p���Ȃ���QuickTime�ōĐ��ł��Ȃ��t�@�C�����o�͂����^(QuickTime Player v7.7.9�Ŋm�F^)
echo         rem # timelineeditor^(rev1450^)�́AMPC-BE ver1.5.0^(build 2235^)������MP4/MOV�X�v���b�^�[�ŕs���I���AQT���Đ��s�\�̈ה񐄏�^(rev1432���Ȃ���Ȃ�^)
echo         rem # DtsEdit��mux�����t�@�C����PS4�ōĐ��s�b�`�����������Ȃ�̂ňꗥtimelineeditor�ɐ؂�ւ�
echo         if "%%video_ext_type%%"==".265" ^(
echo             echo �^�C���R�[�h�t�@�C���𔭌��������߁Atimelineeditor�œ������܂�
echo             echo "%%timelineeditor_path%%" --timecode ".\tmp\main.tmc"%%timeline_PTS_opt%% "%%project_name%%_raw.mp4" "%%project_name%%.mp4"
echo             "%%timelineeditor_path%%" --timecode ".\tmp\main.tmc"%%timeline_PTS_opt%% "%%project_name%%_raw.mp4" "%%project_name%%.mp4"
echo         ^) else if "%%video_ext_type%%"==".264" ^(
echo             echo �^�C���R�[�h�t�@�C���𔭌��������߁Atimelineeditor�œ������܂�
echo             echo "%%timelineeditor_path%%" --timecode ".\tmp\main.tmc"%%timeline_PTS_opt%% "%%project_name%%_raw.mp4" "%%project_name%%.mp4"
echo             "%%timelineeditor_path%%" --timecode ".\tmp\main.tmc"%%timeline_PTS_opt%% "%%project_name%%_raw.mp4" "%%project_name%%.mp4"
echo             rem echo �^�C���R�[�h�t�@�C���𔭌��������߁ADtsEdit�œ������܂�
echo             rem "%%DtsEdit_path%%" -no-dc -s 120000 -tv 2 -tc ".\tmp\main.tmc" -o "%%project_name%%.mp4" "%%project_name%%_raw.mp4"
echo         ^)
echo         del "%%project_name%%_raw.mp4"
echo     ^)
echo ^)
echo.
echo rem # �}�j���A��24fps�v���O�C���ō쐬���ꂽ.*.chapter.txt�t�@�C�������݂���ꍇ���l�[�����܂�
echo if exist "*.chapter.txt" ^(
echo     echo �}�j���A��24fps�v���O�C���`���̃`���v�^�[�t�@�C���𔭌��������߁A�`����ϊ����܂�
echo     for /f "delims=" %%%%N in ^('dir /b "*.chapter.txt"'^) do ^(
echo         rename "%%%%N" "%%project_name%%_sjis.chapters.txt"
echo         "%%nkf_path%%" -w "%%project_name%%_sjis.chapters.txt"^> "%%project_name%%.chapters.txt"
echo         del "%%project_name%%_sjis.chapters.txt"
echo     ^)
echo ^)
echo.
echo rem # �`���v�^�[����������t�F�[�X�Bmp4chaps�̎d�l��AMP4�t�@�C���Ɠ����f�B���N�g����
echo rem # "�C���|�[�g��MP4�t�@�C����.chapters.txt"�̖����K���ŁAOGG�`���̃`���v�^�[�t�@�C����z�u����K�v������܂��B
echo rem # QT�`���̃`���v�^�[�͊g���q��.m4v�łȂ����QuickTime Player�ŔF���ł��܂��񂪁AiTunes�ł����.mp4�ł��g�p�ł��܂��B
echo rem # QuickTime Player^(version 7.7.9^)��iTunes^(12.4.1.6^)�Ŋm�F
echo rem �I�v�V�����F -A QT��Nero�̃n�C�u���b�h / -Q QT�`�� / -N Nero�`��
echo if exist "%%project_name%%.chapters.txt" ^(
echo     echo �`���v�^�[�t�@�C���𔭌��������߁Amp4chaps�œ������܂�
echo     "%%mp4chaps_path%%" -i -Q "%%project_name%%.mp4"
echo ^)
echo.
echo rem # �����t�@�C�������݂��邩�`�F�b�N�A�������ꍇ�����mux�̍H���ɑg�ݍ��݂܂�
echo rem # L-SMASH�͎�����MUX���������ׁ̈Amp4box^(version 0.6.2�ȏ㐄��^)���g�p���܂�
echo if exist ".\tmp\main.srt" ^(
echo     echo ��������Amp4box�œ������܂�
echo     rename "%%project_name%%.mp4" "main_raw.mp4"
echo     rem # Identifier��"sbtl:tx3g"�̏ꍇApple�t�H�[�}�b�g�A"text:tx3g"�̏ꍇ3GPP/MPEG�A���C�A���X�t�H�[�}�b�g
echo     rem https://gpac.wp.mines-telecom.fr/2014/09/04/subtitling-with-gpac/
echo     rem "%%mp4box_path%%" -add "main_raw.mp4"  -add ".\tmp\main.srt":lang=jpn:group=3:hdlr="sbtl:tx3g":layout=0x60x0x-1 -add "main.srt":disable:lang=jpn:group=3:hdlr="text:tx3g":layout=0x60x0x-1 "mp4box_out.mp4"
echo     "%%mp4box_path%%" -add "main_raw.mp4" -add ".\tmp\main.srt":lang=jpn:group=3:hdlr="sbtl:tx3g":layout=0x60x0x-1 "mp4box_out.mp4"
echo     if exist "mp4box_out.mp4" ^(
echo         echo �����̓������������܂����B
echo         rename "mp4box_out.mp4" "%%project_name%%.mp4"
echo         del "main_raw.mp4"
echo     ^) else ^(
echo         echo �����̓����Ɏ��s�����͗l�ł��B�����O�̃t�@�C�����I���W�i���Ƃ��Ďg���܂��B
echo         rename "main_raw.mp4" "%%project_name%%.mp4"
echo     ^)
echo ^) else ^(
echo     echo �����Ȃ�
echo ^)
echo.
rem # �ԑg���𒊏o���ACSV�t�@�C�����o�R����MP4�t�@�C���ɖ��ߍ��ލ�ƁB�\�[�X��TS�t�@�C���̏ꍇ�̂ݗL��
rem # �啶���������i�j�𐳋K�\���Řb���Ƃ��Ĉ����ƁA�ԑg�ɂ���Ă͐��������Ƃ��Ďg����ꍇ�����邽�ߖ��
rem echo "%tsrenamec_path%" "%input_media_path%" "@NT1'\[��\]'@NT2'\[��\]'@C'\[�V\]'@C'\[�I\]'@C'���V��'@C'���I��'@C'\[��\]'@C'\[��\]'@C'\[�f\]'@NT3'^(#|��.+^)'@NT4'�i.+�j'@C' |�@*��.+'@C' |�@*#.+'@C'�i.+�j'@MST@TT,@sb,@PT3@PT4,@YY,@PT1@PT2@YY�N@MM��@DD��,@CH,"^> "%%~dp0main.csv"
rem # @C'�i.+�j'���g�p����ƁA�u�v���Ɂi�j���܂܂�Ă���Ƃ��������Ȃ�͗l�B����Ďb��I�ɔr���B^(2010/12/28^)
rem echo "%tsrenamec_path%" "%input_media_path%" "@NT1'\[��\]'@NT2'\[��\]'@C'\[�V\]'@C'\[�I\]'@C'���V��'@C'���I��'@C'\[��\]'@C'\[��\]'@C'\[�f\]'@NT3'^(#|��.+^)'@NT4'��.+�b'@C' |�@*��.+'@C' |�@*#.+'@C'�i.+�j'@MST@TT,@sb,@PT3@PT4,@YY,@PT1@PT2@YY�N@MM��@DD��,@CH,"^> "main.csv"
echo rem # �ԑg���̒��o��MP4�t�@�C���ւ̓����t�F�[�Y
echo if not exist "main.csv" ^(
echo     if exist ".\src\video1.ts" ^(
echo         echo tsrenamec��TS�t�@�C������ԑg���𒊏o���܂�
echo         echo ".\src\video1.ts"
echo         "%%tsrenamec_path%%" ".\src\video1.ts" "@NT1'\[��\]'@NT2'\[��\]'@C'\[�V\]'@C'\[�I\]'@C'���V��'@C'���I��'@C'\[��\]'@C'\[��\]'@C'\[�f\]'@NT3'^(#|��.+^)'@NT4'��.+�b'@C' |�@*��.+'@C' |�@*#.+'@MST@TT,@sb,@PT3@PT4,@YY,@PT1@PT2@YY�N@MM��@DD��,@CH,"^> "main.csv"
echo     ^) else if exist "%%src_file_path%%" ^(
echo         echo tsrenamec��TS�t�@�C������ԑg���𒊏o���܂�
echo         echo "%%src_file_path%%"
echo         "%%tsrenamec_path%%" "%%src_file_path%%" "@NT1'\[��\]'@NT2'\[��\]'@C'\[�V\]'@C'\[�I\]'@C'���V��'@C'���I��'@C'\[��\]'@C'\[��\]'@C'\[�f\]'@NT3'^(#|��.+^)'@NT4'��.+�b'@C' |�@*��.+'@C' |�@*#.+'@MST@TT,@sb,@PT3@PT4,@YY,@PT1@PT2@YY�N@MM��@DD��,@CH,"^> "main.csv"
echo     ^)
echo ^)
rem echo for /f "USEBACKQ tokens=1,2,3,4,5,6,7 delims=," %%%%a in ^("main.csv"^) do ^(
rem echo     "%%AtomicParsley_path%%" "%outputmp4_dir%%%project_name%%.mp4" --title "%%%%b" --album "%%%%a" --year "%%%%d" --grouping "%%%%f" --stik "TV Show" --description "%%%%e" --TVNetwork "%%%%f" --TVShowName "%%%%a" --TVEpisode "%%%%c%%%%b" --overWrite
rem echo ^)
rem # �f���~�^�[","�ŕ��������ۂɁA���g���u�����N�̗v�f������ƌ��̗v�f���J��オ���ĕϐ��ɑ������邽�߂����������邽�߂̏��Z
echo for /f "usebackq delims=" %%%%i in ^("main.csv"^) do ^(
echo     call :atomicparsley_phase %%%%i
echo ^)
echo.
echo rem # �o�͐�t�H���_�ւ̃t�@�C���ړ�
echo if exist "%%out_dir_1st%%" ^(
echo     call :moveto_final-dir_phase "%%out_dir_1st%%"
echo     if not exist "%%out_dir_1st%%%%sub_folder_name%%\%%project_name%%.mp4" ^(
echo         echo "%%out_dir_1st%%"�ւ̏o�͂Ɏ��s���܂����A�ړ���t�H���_�̋󂫂������\��������܂��B
echo         if exist "%%out_dir_2nd%%" ^(
echo             echo �\���t�H���_�ւ̏o�͂����s���܂��B[%%date%% %%time%%]
echo             call :moveto_final-dir_phase "%%out_dir_2nd%%"
echo             if not exist "%%out_dir_2nd%%%%sub_folder_name%%\%%project_name%%.mp4" ^(
echo                 echo "%%out_dir_2nd%%"�ւ̏o�͂Ɏ��s���܂����A�ړ���t�H���_�̋󂫂������\��������܂��B
echo                 echo ���[�U�[�̃z�[���f�B���N�g���ւ̏o�͂����s���܂��B[%%date%% %%time%%]
echo                 call :moveto_final-dir_phase "%%HOMEDRIVE%%\%%HOMEPATH%%"
echo             ^)
echo         ^)
echo     ^)
echo ^) else if exist "%%out_dir_2nd%%" ^(
echo     call :moveto_final-dir_phase "%%out_dir_2nd%%"
echo     if not exist "%%out_dir_2nd%%%%sub_folder_name%%\%%project_name%%.mp4" ^(
echo         echo "%%out_dir_2nd%%"�ւ̏o�͂Ɏ��s���܂����A�ړ���t�H���_�̋󂫂������\��������܂��B
echo         echo ���[�U�[�̃z�[���f�B���N�g���ւ̏o�͂����s���܂��B[%%date%% %%time%%]
echo         call :moveto_final-dir_phase "%%HOMEDRIVE%%\%%HOMEPATH%%"
echo     ^)
echo ^) else ^(
echo     echo �ݒ肳��Ă���ŏI�t�@�C���̏o�͐�f�B���N�g������������݂��܂���B
echo     echo ����Ƀ��[�U�[�̃z�[���f�B���N�g���ɏo�͂��܂��B
echo     call :moveto_final-dir_phase "%%HOMEDRIVE%%\%%HOMEPATH%%"
echo ^)
echo rem # �o�͐�t�@�C���̑��݊m�F
echo if exist "%%final_out_dir%%%%sub_folder_name%%\%%project_name%%.mp4" ^(
echo    echo "%%final_out_dir%%%%sub_folder_name%%\%%project_name%%.mp4" �֏o�͂��܂���[%%date%% %%time%%]
echo ^) else ^(
echo    echo "%%final_out_dir%%%%sub_folder_name%%\%%project_name%%.mp4" �̏o�͂Ɏ��s���܂���[%%date%% %%time%%]
echo    echo "%%final_out_dir%%%%sub_folder_name%%\%%project_name%%.mp4 �̏o�͂Ɏ��s���܂���[%%date%% %%time%%]"^>^>"%%USERPROFILE%%\mp4output_error.log"
echo ^)
echo.
echo title �R�}���h �v�����v�g
echo rem //----- main�I�� -----//
echo echo end %%~nx0 bat job...
echo echo.
echo exit /b
echo.
rem ------------------------------
echo :moveto_final-dir_phase
echo if not exist "%%~1%%sub_folder_name%%" ^(
echo     mkdir "%%~1%%sub_folder_name%%"
echo ^)
echo echo �ŏI�o�͐�t�H���_�Ƀt�@�C����]�����܂�
echo echo �t�H���_�p�X�F%%~1%%sub_folder_name%%
echo if "%%copy_app_flag%%"=="fac" ^(
echo     if exist "%%fac_path%%" ^(
echo         echo FastCopy �ňړ������s���܂�
echo         "%%fac_path%%" /cmd=move /force_close /disk_mode=auto "%%project_name%%.mp4" /to="%%~1%%sub_folder_name%%\"
echo     ^) else ^(
echo         set copy_app_flag=copy
echo     ^)
echo ^) else if "%%copy_app_flag%%"=="ffc" ^(
echo     if exist "%%ffc_path%%" ^(
echo         echo FireFileCopy �ňړ������s���܂�
echo         "%%ffc_path%%" "%%project_name%%.mp4" /move /a /bg /md /nk /ys /to:"%%~1%%sub_folder_name%%\"
echo     ^) else ^(
echo         set copy_app_flag=copy
echo     ^)
echo ^)
echo if "%%copy_app_flag%%"=="copy" ^(
echo     echo �R�}���h�v�����v�g�W����move�R�}���h�ňړ������s���܂�
echo     move /Y "%%project_name%%.mp4" "%%~1%%sub_folder_name%%\"
echo ^)
echo set final_out_dir=%%~1
echo exit /b
echo.
rem ------------------------------
echo :atomicparsley_phase
echo rem # AtomicParsley_path�p�̋^���֐�
echo set t=%%*
echo set t="%%t:,=","%%"
echo for /f "usebackq tokens=1-6 delims=," %%%%a in ^(`call echo %%%%t%%%%`^) do ^(
echo     echo �ԑg����AtomicParsley�œ������܂�
echo     echo --title "%%%%~b" --album "%%%%~a" --year "%%%%~d" --grouping "%%%%~f" --stik "TV Show" --description "%%%%~e" --TVNetwork "%%%%~f" --TVShowName "%%%%~a" --TVEpisode "%%%%~c%%%%~b" --overWrite
echo     "%%AtomicParsley_path%%" "%%project_name%%.mp4" --title "%%%%~b" --album "%%%%~a" --year "%%%%~d" --grouping "%%%%~f" --stik "TV Show" --description "%%%%~e" --TVNetwork "%%%%~f" --TVShowName "%%%%~a" --TVEpisode "%%%%~c%%%%~b" --overWrite
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :zero-byte_error_check
echo for %%%%F in ^("%%~1"^) do set tmp_mux-src_filesize=%%%%~zF
echo echo %%~nx1 �t�@�C���T�C�Y�F %%tmp_mux-src_filesize%% byte
echo if %%tmp_mux-src_filesize%% EQU 0 (
echo     echo ���[���o�C�g�t�@�C������
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
echo if not "%%def_24fps_flag%%"=="0" echo .def����24fps��`������܂�
echo if not "%%def_30fps_flag%%"=="0" echo .def����30fps��`������܂�
echo if not "%%def_60fps_flag%%"=="0" echo .def����60fps��`������܂�
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
echo     echo ���ϐ� ENCTOOLSROOTPATH ������`�ł�
echo     exit /b
echo ^)
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\
echo if exist "%%ENCTOOLSROOTPATH%%" ^(
echo     exit /b
echo ^) else ^(
echo     echo ���ϐ�ENCTOOLSROOTPATH���L���ȃp�X�ł͂���܂���
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
echo     echo �p�����[�^�t�@�C���̒��Ƀr�f�I�G���R�[�h�̃R�[�f�b�N�w�肪������܂���B�b��[�u�Ƃ��āA.264���g�p���܂��B
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
echo     echo �R�s�[�p�A�v���̃p�����[�^�[��������܂���A�f�t�H���g��copy�R�}���h���g�p���܂��B
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
echo     echo �ŏI�t�@�C���̏o�͐�1�F%%out_dir_1st%%
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
echo     echo �ŏI�t�@�C���̏o�͐�2�F%%out_dir_2nd%%
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
echo     echo ����w�肪������܂���ł����B����ɓ��{��^^^(jpn^^^)���w�肵�܂��B
echo     set audio_track_opt=language=jpn,alternate-group=^2
echo ^)
echo rem # �����Ƃ���2�ڈȍ~�̃g���b�N��disable�p�����[�^�[��t�^
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
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set muxer_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :muxer_env_search %%~nx1
echo exit /b
echo :muxer_env_search
echo set muxer_path=%%~$PATH:1
echo if "%%muxer_path%%"=="" ^(
echo     echo muxer��������܂���
echo     set muxer_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_timelineeditor
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set timelineeditor_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :timelineeditor_env_search %%~nx1
echo exit /b
echo :timelineeditor_env_search
echo set timelineeditor_path=%%~$PATH:1
echo if "%%timelineeditor_path%%"=="" ^(
echo     echo timelineeditor��������܂���
echo     set timelineeditor_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_DtsEdit
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set DtsEdit_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :DtsEdit_env_search %%~nx1
echo exit /b
echo :DtsEdit_env_search
echo set DtsEdit_path=%%~$PATH:1
echo if "%%DtsEdit_path%%"=="" ^(
echo     echo DtsEdit��������܂���
echo     set DtsEdit_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_mp4box
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set mp4box_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :mp4box_env_search %%~nx1
echo exit /b
echo :mp4box_env_search
echo set mp4box_path=%%~$PATH:1
echo if "%%mp4box_path%%"=="" ^(
echo     echo mp4box��������܂���
echo     set mp4box_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_mp4chaps
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set mp4chaps_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :mp4chaps_env_search %%~nx1
echo exit /b
echo :mp4chaps_env_search
echo set mp4chaps_path=%%~$PATH:1
echo if "%%mp4chaps_path%%"=="" ^(
echo     echo mp4chaps��������܂���
echo     set mp4chaps_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_nkf
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set nkf_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :nkf_env_search %%~nx1
echo exit /b
echo :nkf_env_search
echo set nkf_path=%%~$PATH:1
echo if "%%nkf_path%%"=="" ^(
echo     echo nkf��������܂���
echo     set nkf_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_AtomicParsley
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set AtomicParsley_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :AtomicParsley_env_search %%~nx1
echo exit /b
echo :AtomicParsley_env_search
echo set AtomicParsley_path=%%~$PATH:1
echo if "%%AtomicParsley_path%%"=="" ^(
echo     echo AtomicParsley��������܂���
echo     set AtomicParsley_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_tsrenamec
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set tsrenamec_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :tsrenamec_env_search %%~nx1
echo exit /b
echo :tsrenamec_env_search
echo set tsrenamec_path=%%~$PATH:1
echo if "%%tsrenamec_path%%"=="" ^(
echo     echo tsrenamec��������܂���
echo     set tsrenamec_path=%%~1
echo ^)
echo exit /b
echo.
rem ------------------------------
echo :find_ffc
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set ffc_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :ffc_env_search %%~nx1
echo exit /b
echo :ffc_env_search
echo set ffc_path=%%~$PATH:1
echo if "%%ffc_path%%"=="" echo FireFileCopy��������܂���A����ɃR�}���h�v�����v�g�W����copy�R�}���h���g�p���܂��B
echo exit /b
echo.
rem ------------------------------
echo :find_fac
echo echo findexe�����F"%%~1"
echo if not defined ENCTOOLSROOTPATH ^(
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^) else ^(
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%
echo     echo �T�����Ă��܂�...
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(
echo         echo ������܂���
echo         set fac_path=%%%%~E
echo         exit /b
echo     ^)
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B
echo ^)
echo call :fac_env_search %%~nx1
echo exit /b
echo :fac_env_search
echo set fac_path=%%~$PATH:1
echo if "%%fac_path%%"=="" echo FastCopy��������܂���A����ɃR�}���h�v�����v�g�W����copy�R�}���h���g�p���܂��B
echo exit /b
)>> "%muxtracks_batfile_path%"
rem ------------------------------
exit /b


:del_tmp_files
rem # ��Ɨp�̃\�[�X�t�@�C������ѕs�v�Ȉꎞ�t�@�C���̍폜�t�F�[�Y
echo call ".\bat\del_tmp.bat">>"%main_bat_file%"
echo.>> "%main_bat_file%"
type nul > "%deltmp_batfile_path%"
(
echo @echo off
echo setlocal
echo echo start %%~nx0 bat job...
echo cd /d %%~dp0..\
echo.
echo rem # %%large_tmp_dir%% �̑��݊m�F����і����`�F�b�N
echo if not exist "%%large_tmp_dir%%" ^(
echo     echo �傫�ȃt�@�C�����o�͂���ꎞ�t�H���_ %%%%large_tmp_dir%%%% �����݂��܂���A����ɃV�X�e���̃e���|�����t�H���_�ő�p���܂��B
echo     set large_tmp_dir=%%tmp%%
echo ^)
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o
echo call :project_name_check
echo.
echo rem //----- main�J�n -----//
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
echo title �R�}���h �v�����v�g
echo rem //----- main�I�� -----//
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
rem # ���C���o�b�`�ɏI�������\���R�}���h����������
echo echo ### �I������[%%date%% %%time%%] ###>> "%main_bat_file%"
echo echo.>> "%main_bat_file%"
exit /b


:cleanup_phase
rem ----------------------------
rem # �o�b�`���[�h�֌W
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
rem # 0:FAW / 1:faad��neroAacEnc / 2:sox / 3:5.1chMIX
set audio_job_flag=

rem # Video�G���R�[�h�I�v�V����
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
rem ### �o�b�`�p�����[�^���V�t�g ###
rem # %9 �� %8 �ɁA... %1 �� %0 ��
shift /1
rem # �o�b�`�p�����[�^����Ȃ�I��
if "%~1"=="" goto end
echo ------------------------------
echo.
goto :main_function

:error
echo.
echo ### error! ###
echo.
echo %error_message%
rem # �_�u���N���b�N�A��������D&D�ŌĂяo���ꂽ�ꍇ��pause
set cmd_env_chars=%CMDCMDLINE%
if not ""^%cmd_env_chars:~-1%""==""^ "" (
    echo �E�B���h�E�����ɂ́A�����L�[�������Ă��������B
    pause>nul
)
echo.
set exit_stat=1
exit /b

:end
echo ### ��ƏI������ ###
echo [%time%]
echo.
rem # �_�u���N���b�N�A��������D&D�ŌĂяo���ꂽ�ꍇ��pause
set cmd_env_chars=%CMDCMDLINE%
if not ""^%cmd_env_chars:~-1%""==""^ "" (
    echo �E�B���h�E�����ɂ́A�����L�[�������Ă��������B
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
rem # �_�u���N���b�N�A��������D&D�ŌĂяo���ꂽ�ꍇ��pause
set cmd_env_chars=%CMDCMDLINE%
if not ""^%cmd_env_chars:~-1%""==""^ "" (
    echo �E�B���h�E�����ɂ́A�����L�[�������Ă��������B
    pause>nul
)
exit /b


:exit
endlocal