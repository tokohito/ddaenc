@echo off
setlocal

:start
rem #//--- �o�[�W������� ---//
set release_version=3.2.12.180511

rem #//--- �e��o�͐�f�B���N�g���ւ̃p�X ---//

rem ### ��Ɨp�f�B���N�g��(%work_dir%) ###
set work_dir=I:\avs temp\

rem ### �e���|�����f�B���N�g��(%large_tmp_dir%) ###
rem # TsSplitter�O�̈ꎞ�R�s�[�� / ts2aac&FAW��AAC�o�� / �����G���R�[�_�[�ɓn���O��WAV�Ȃ�
rem %large_tmp_dir%�����ϐ��Ŏ��O�ɐݒ�

rem ### �ŏI�o�̓t�@�C�����ړ�����t�H���_�ւ̃p�X ###
rem # �����̃t�H���_����������݂��Ȃ��ꍇ�A���[�U�[�̃z�[���t�H���_�Ɉړ�����܂�
set out_dir_1st=\\Servername\share\mp4 video\
set out_dir_2nd=D:\output video\

rem ### �A�����s�p�o�b�`�t�@�C���܂ł̃p�X ###
set calling_bat_file=%USERPROFILE%\Call_Encoding.bat

rem ### �o�͎��s�����ۂ̃G���[���O ###
set error_log_file=%USERPROFILE%\mp4output_error.log

rem ### ���m�̊O����p�������������Ƃ��̌x�����O ###
set unknown_letter_log=%USERPROFILE%\unknown_letter.log

rem # �G���R�[�_�[�I��
rem x265, x264, qsv_h264, qsv_hevc, nvenc_h264, nvenc_hevc
set video_encoder_type=x264

rem //--- x265 �I�v�V���� ---//
rem ### x265.exe �ւ�path ###
rem # �����
:   https://onedrive.live.com/?authkey=%21AJWOVN55IpaFffo&id=6BDD4375AC8933C6%213306&cid=6BDD4375AC8933C6
set x265_path=%USERPROFILE%\AppData\Local\rootfs\bin\x265_2.1+11_x64_pgo.exe

rem ### MainProfile@Level 4.1 (Main Tier)�I�v�V����(VUI options������) ###
set x265_MP@L41_option=--crf 18 --profile main --level-idc 4.1 --preset slow --no-high-tier

rem ### MainProfile@Level 4.0 (Main Tier)�I�v�V����(VUI options������) ###
set x265_MP@L40_option=--crf 18 --profile main --level-idc 4.0 --preset slow --no-high-tier

rem ### MainProfile@Level 3.1 (Main Tier)�I�v�V����(VUI options������) ###
set x265_MP@L31_option=--crf 18 --profile main --level-idc 3.1 --preset slow --no-high-tier

rem ### MainProfile@Level 3.0 (Main Tier)�I�v�V����(VUI options������) ###
set x265_MP@L30_option=--crf 18 --profile main --level-idc 3.0 --preset slow --no-high-tier


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
rem set x264_path=%USERPROFILE%\AppData\Local\rootfs\bin\x264_r2851_8dpt_x86.exe
set x264_path=%USERPROFILE%\AppData\Local\rootfs\bin\x264_r2901_8dpt_x64.exe

rem ### HighProfile@Level 4.2 �I�v�V����(VUI options������) ###
set x264_HP@L42_option=--crf 18 --profile high --level 4.2 --ref 3 --bframes 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --8x8dct --nal-hrd vbr --vbv-maxrate 62500 --vbv-bufsize 78125 --no-fast-pskip --qpstep 8

rem ### HighProfile@Level 4.0 �I�v�V����(VUI options������) ###
rem set x264_HP@L40_option=--crf 21 --profile high --level 4 --sar 4:3 --ref 3 --bframes 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --8x8dct --nal-hrd vbr --vbv-maxrate 25000 --vbv-bufsize 31250 --no-fast-pskip --qpstep 8 --videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 --threads 4
set x264_HP@L40_option=--crf 18 --profile high --level 4 --ref 3 --bframes 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --8x8dct --nal-hrd vbr --vbv-maxrate 25000 --vbv-bufsize 31250 --no-fast-pskip --qpstep 8

rem ### MainProfile@Level 3.2 �I�v�V����(VUI options������) ###
set x264_MP@L32_option=--crf 18 --profile main --level 3.2 --ref 2 --bframes 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --nal-hrd vbr --vbv-maxrate 20000 --vbv-bufsize 10000 --no-fast-pskip --qpstep 8

rem ### MainProfile@Level 3.1 �I�v�V����(VUI options������) ###
set x264_MP@L31_option=--crf 18 --profile main --level 3.1 --ref 2 --bframes 2 --cqm flat --subme 9 --me umh --psy-rd 0.5:0.0 --trellis 2 --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --nal-hrd vbr --vbv-maxrate 14000 --vbv-bufsize 10000 --no-fast-pskip --qpstep 8

rem ### MainProfile@Level 3.0 �I�v�V����(VUI options������) ###
set x264_MP@L30_option=--crf 18 --profile main --level 3 --ref 2 --bframes 2 --b-pyramid none --cqm flat --subme 9 --me umh --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --nal-hrd vbr --vbv-maxrate 10000 --vbv-bufsize 10000 --no-fast-pskip --qpstep 8

rem ### MainProfile@Level 2.1 �I�v�V����(VUI options������) ###
set x264_MP@L21_option=--crf 20 --profile main --level 21 --ref 2 --bframes 2 --b-pyramid none --cqm flat --subme 9 --me umh --deblock 0:0 --aq-mode 0 --no-dct-decimate --analyse p8x8,b8x8,i4x4 --nal-hrd vbr --vbv-maxrate 4000 --vbv-bufsize 4000 --no-fast-pskip --qpstep 8

rem ### �C���^�[���[�X�ێ��G���R�[�f�B���O������ꍇ�̃I�v�V���� ###
rem # Profile Level3
set x264_interlace_Lv3=--interlace --tff 
rem # Profile Level4
set x264_interlace_Lv4=--interlace --tff --weightp 0 


rem ### QSVEncC.exe �ւ�path ###
rem # �����
:   http://rigaya34589.blog135.fc2.com/blog-entry-337.html
set qsvencc_path=%USERPROFILE%\AppData\Local\rootfs\opt\QSVEnc\QSVEncC\x86\QSVEncC.exe

set qsv_Encode_option=--y4m 


rem ### NVEncC.exe �ւ�path ###
rem # �����
:   http://rigaya34589.blog135.fc2.com/blog-entry-739.html
set nvencc_path=%USERPROFILE%\AppData\Local\rootfs\opt\NVEnc\NVEncC\x86\NVEncC.exe

set nvenc_Encode_option=--y4m 


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
set dgindex_path="%USERPROFILE%\AppData\Local\rootfs\usr\DGMPGDec\DGIndex.exe"

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
set ffc_path=%USERPROFILE%\AppData\Local\rootfs\usr\FireFileCopy\FFC.exe

rem # FastCopy �ւ̃p�X
set fac_path=C:\Program Files\FastCopy\fastcopy.exe

rem ### MPEG-2 VIDEO VFAPI Plug-In�im2v.vfp�j �̃p�X###
rem # mpeg2dec_select_flag=1 �̏ꍇ�ɕK�v�B
set m2v_vfp_path=%USERPROFILE%\AppData\Local\rootfs\opt\m2v_vfp\m2v.vfp

rem ### avs4x26x.exe �ւ�path ###
set avs4x26x_path=%USERPROFILE%\AppData\Local\rootfs\bin\avs4x26x.exe

rem ### TsSplitter �ւ̃p�X###
set TsSplitter_path=%USERPROFILE%\AppData\Local\rootfs\usr\TsSplitter\TsSplitter.exe

rem ### FakeAacWave �ւ̃p�X ###
set FAW_path=%USERPROFILE%\AppData\Local\rootfs\usr\FakeAacWav\fawcl.exe

rem ### ts2aac �ւ̃p�X ###
rem ��ts2aac�͌����Ƃ���MPEG2 VFAPI Plug-In���r�f�I�̐擪��closed GOP�łȂ���ΐ���ɋ@�\���Ȃ�, ts_parser�̎g�p�𐄏�
set ts2aac_path=%USERPROFILE%\AppData\Local\rootfs\usr\ts2aac\ts2aac.exe

rem ### ts_parser �ւ̃p�X ###
rem ���g�p����MPEG-2�f�R�[�_�[�ɉ����� --delay-type �I�v�V������ύX����, �\�[�XTS��Drop������ꍇ�̂�ts2aac�̎g�p�𐄏�
set ts_parser_path=%USERPROFILE%\AppData\Local\rootfs\bin\ts_parser.exe

rem ### faad �ւ̃p�X ###
set faad_path=%USERPROFILE%\AppData\Local\rootfs\bin\faad.exe

rem ### avs2wav �ւ̃p�X ###
rem set avs2wav_path=%USERPROFILE%\AppData\Local\rootfs\bin\avs2wav.exe
rem http://www.ku6.jp/keyword19/1.html
set avs2wav_path=%USERPROFILE%\AppData\Local\rootfs\bin\avs2wav32.exe

rem ### avs2pipe(mod) �ւ̃p�X ###
set avs2pipe_path=%USERPROFILE%\AppData\Local\rootfs\bin\avs2pipemod.exe

rem ### logoframe �ւ̃p�X ###
set logoframe_path=%USERPROFILE%\AppData\Local\rootfs\usr\logoframe\logoframe.exe

rem ### chapter_exe �ւ̃p�X ###
set chapter_exe_path=%USERPROFILE%\AppData\Local\rootfs\usr\chapter_exe\chapter_exe.exe

rem ### join_logo_scp �ւ̃p�X ###
set join_logo_scp_path=%USERPROFILE%\AppData\Local\rootfs\usr\join_logo_scp\join_logo_scp.exe

rem ### AutoVfr �ւ̃p�X ###
set autovfr_path=%USERPROFILE%\AppData\Local\rootfs\bin\AutoVfr.exe

rem ### AutoVfr.ini �ւ̃p�X(���݂��Ȃ��ꍇ�AAutoVfr.exe�Ɠ����t�H���_��T��) ###
set autovfrini_path=%USERPROFILE%\AppData\Local\rootfs\bin\AutoVfr.ini

rem ### ext_bs �ւ̃p�X ###
set ext_bs_path=%USERPROFILE%\AppData\Local\rootfs\bin\ext_bs.exe

rem ### muxer.exe(L-SMASH) �ւ̃p�X ###
set muxer_path=%USERPROFILE%\AppData\Local\rootfs\bin\muxer.exe

rem ### remuxer.exe(L-SMASH) �ւ̃p�X ###
set remuxer_path=%USERPROFILE%\AppData\Local\rootfs\bin\remuxer.exe

rem ### timelineeditor.exe(L-SMASH) �ւ̃p�X ###
set timelineeditor_path=%USERPROFILE%\AppData\Local\rootfs\bin\timelineeditor.exe

rem ### mp4box �ւ̃p�X ### ���폜�\��
rem # �����X�g���[����disable�I�v�V�����̂��߁A�vversion 0.4.5�ȍ~
set mp4box_path=C:\Program Files\GPAC\mp4box.exe

rem ### mp4chaps �ւ̃p�X ### ���폜�\��
set mp4chaps_path=%USERPROFILE%\AppData\Local\rootfs\bin\mp4chaps.exe

rem ### DtsEdit �ւ̃p�X ###
rem # QT�Đ��݊��ׂ̈ɕK�v
set DtsEdit_path=%USERPROFILE%\AppData\Local\rootfs\bin\DtsEdit.exe

rem ### sox �ւ̃p�X ###
set sox_path=%USERPROFILE%\AppData\Local\rootfs\usr\sox-14.2.0\sox.exe

rem ### neroAacEnc �ւ̃p�X ###
set neroAacEnc_path=%USERPROFILE%\AppData\Local\rootfs\bin\neroAacEnc.exe

rem ### mp4creator60 �ւ̃p�X ### ���폜�\��
set mp4creator60_path=%USERPROFILE%\AppData\Local\rootfs\bin\mp4creator60.exe

rem ### aacgain �ւ̃p�X ###
set aacgain_path=%USERPROFILE%\AppData\Local\rootfs\bin\aacgain.exe

rem ### ffmpeg �ւ̃p�X ###
set ffmpeg_path=%USERPROFILE%\AppData\Local\rootfs\bin\ffmpeg.exe

rem ### Comskip �ւ̃p�X ###
set comskip_path=%USERPROFILE%\AppData\Local\rootfs\usr\Comskip\comskip.exe

rem ### comskip.ini �ւ̃p�X ###
set comskipini_path=%USERPROFILE%\AppData\Local\rootfs\usr\Comskip\comskip.ini

rem ### caption2Ass(_mod) �ւ̃p�X ###
set caption2Ass_path=%USERPROFILE%\AppData\Local\rootfs\usr\Caption2Ass_mod1\Caption2Ass_mod1.exe

rem ### SrtSync �ւ̃p�X ###
rem # �v.NET Framework 3.5
set SrtSync_path=%USERPROFILE%\AppData\Local\rootfs\bin\SrtSync.exe

rem ### nkf(�����R�[�h�ύX�c�[��) �ւ̃p�X ###
set nkf_path=%USERPROFILE%\AppData\Local\rootfs\bin\nkf.exe

rem ### sed(onigsed) �փp�X ###
set sed_path=%USERPROFILE%\AppData\Local\rootfs\bin\onigsed.exe

rem ### sed�X�N���v�g �ւ̃p�X ###
set sedscript_path=%USERPROFILE%\AppData\Local\rootfs\usr\Caption2Ass_mod1\Gaiji\ARIB2Unicode.txt

rem ### tsrenamec �ւ̃p�X ###
set tsrenamec_path=%USERPROFILE%\AppData\Local\rootfs\bin\tsrenamec.exe

rem ### AtomicParsley �ւ̃p�X ###
set AtomicParsley_path=%USERPROFILE%\AppData\Local\rootfs\bin\AtomicParsley.exe

rem ### KeyIn.VB.NET �ւ̃p�X ###
rem http://www.vector.co.jp/soft/winnt/util/se461954.html
rem # .NET Framework 3.5 ���K�v�BKeyIn���g�����ǂ�����%use_NetFramework_switch%�Ŏw��
set KeyIn_path=%USERPROFILE%\AppData\Local\rootfs\bin\KeyIn.exe

rem ### MediaInfo CLI �ւ̃p�X ###
set MediaInfoC_path=%USERPROFILE%\AppData\Local\rootfs\usr\MediaInfo_CLI\MediaInfo.exe


rem //--- �e��e���v���[�g�ւ̃p�X ---//

rem ### ���S�t�@�C��(.lgd)�̃\�[�X�t�H���_���w�� ###
set lgd_file_src_path=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\lgd

rem ### �J�b�g�������@�X�N���v�g(JL)�̃\�[�X�t�H���_���w�� ###
set JL_src_dir=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\JL

rem ### �f�t�H���g�Ŏg�p����J�b�g�������@�X�N���v�g(JL)�̃t�@�C�������w�� ###
set JL_file_name=JL_�W��.txt

rem ### �v���O�C���ǂݍ��݃e���v���[�g�̃p�X ###
rem # use_auto_loading=0 �̏ꍇ�ɕK�v�B
set plugin_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\LoadPlugin.avs

rem ### AutoVfr �e���v���[�g�̃p�X ###
set autovfr_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\Auto_Vfr.avs

rem ### AutoVfr_Fast �e���v���[�g�̃p�X ###
set autovfr_fast_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\Auto_Vfr_Fast.avs

rem ### AutoVfr �̋t�e���V�l���蓮/�����ǂ���ł�邩�ݒ肵�܂� ###
rem # 0: �蓮 / 1: ����
set autovfr_deint=1

rem ### �\�[�X�ǂݍ��݃t�B���^�e���v���[�g�̃p�X ###
set load_source=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\LoadSource.avs

rem ### �t�B�[���h�t�@�[�X�g�w��e���v���[�g�̃p�X ###
set aff_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\assume_field_first.avs

rem ### �C���^�[���[�X��ԂœK�p����t�B���^�̃e���v���[�g�p�X ###
set interlaced_filter_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\interlaced_filter.avs

rem ### �C���^�[���[�X�����t�B���^�e���v���[�g�̃p�X ###
set deinterlace_filter_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\deinterlace_filter.avs

rem ### �C���^�[���[�X������ԂœK�p����t�B���^�e���v���[�g�̃p�X ###
set uninterlaced_filter_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\uninterlaced_filter.avs

rem ### return_last �t�B���^�e���v���[�g�̃p�X ###
set return_last_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\return_last.avs

rem ### def �t�@�C���փp�X ###
set def_itvfr_file=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\foo.def

rem ### itvfr �t�B���^�e���v���[�g�̃p�X ###
set itvfr_filter_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\itvfr.avs

rem ### 24p �t�B���^�e���v���[�g�̃p�X ###
set 24p_filter_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\24p.avs

rem ### interlace �t�B���^�e���v���[�g�̃p�X ###
set interlace_filter_template=%USERPROFILE%\AppData\Local\rootfs\opt\AviSynth\Script\interlace.avs

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


:bat_option_detect_phase
rem # ��Ԑe�̈����ϐ���shift����悤�ɁAcall�͎g�p���Ȃ���
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
rem # �o�b�`���[�h�p�����[�^�[�ɕs���Ȓl���܂܂�Ă����ꍇ�A�����I��
if "%exit_stat%"=="1" (
    exit /b
)

rem # �������̐擪������-�̏ꍇ�A�I�v�V�����Ƃ݂Ȃ��čċA���s����
set fast_param=%~1
if "%fast_param:~0,1%"=="-" (
    goto :bat_option_detect_phase
)
rem # �o�b�`���[�h�̖��w��p�����[�^�[���f�t�H���g�l�ɃZ�b�g����
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
rem # work_dir �����݂��邩�`�F�b�N
if not exist "%work_dir%" (
    rem # �G���[���b�Z�[�W�̐ݒ�
    set error_message=AVS ���o�͂���t�H���_�̃p�X���Ԉ���Ă��܂��B
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
    echo �v���W�F�N�g��ƃt�H���_�F%work_dir%
    echo �o�̓t�H���_�F%out_dir_1st%
    echo �G���R�[�_�[�F%video_encoder_type%
    echo �I�[�f�B�I�F%audio_job_flag%
    echo ���T�C�Y�F%bat_vresize_flag%
    echo JL�t�@�C���F%JL_src_file_full-path%
    echo �f�C���^�[���[�X�����F%deinterlace_filter_flag%
    echo AutoVfr�����F%autovfr_mode%
    echo TsSplitter�F%TsSplitter_flag%
    echo Crop�w��F%Crop_size_flag%
    echo NR�t�B���^�F%NR_filter_flag%
    echo �V���[�v�t�B���^�F%Sharp_filter_flag%
    echo DeDot�t�B���^�F%DeDot_cc_filter_flag%
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
    echo --- ���̓t�@�C���F %~1
) else if "%~x1"==".m2ts" (
    echo --- ���̓t�@�C���F %~1
) else if "%~x1"==".mpg" (
    echo --- ���̓t�@�C���F %~1
) else if "%~x1"==".mpeg" (
    echo --- ���̓t�@�C���F %~1
) else if "%~x1"==".m2p" (
    echo --- ���̓t�@�C���F %~1
) else if "%~x1"==".mpv" (
    echo --- ���̓t�@�C���F %~1
) else if "%~x1"==".m2v" (
    echo --- ���̓t�@�C���F %~1
) else if "%~x1"==".dv" (
    echo --- ���̓t�@�C���F %~1
) else if "%~x1"==".avs" (
    echo --- ���̓t�@�C���F %~1
) else if "%~x1"==".d2v" (
    echo ����A�g���q��.d2v�̓ǂݍ��݂ɑΉ����Ă��܂���B�{�̂��w�肵�Ă�������
    set mpeg2dec_select_flag=2
    goto :parameter_shift
) else (
    echo.
    echo ��Ή��g���q
    goto :parameter_shift
)


echo ### ��ƊJ�n���� ###
echo %time%
echo.

rem ### �\�[�X�t�@�C���ւ̃t���p�X^(src_file_path^)�����ϐ��ɏ�������.�B��Ńp�����[�^�[�t�@�C���ɂ��������ށB
set src_file_path=%~1

rem ### �\�[�X�Ƃ���t�@�C���ւ̃p�X�A�ʏ�͓��͂��ꂽ�t�@�C�� ###
set input_media_path=%~1

rem ### AVS�t�@�C���̖��O�A�ʏ�͓��͂��ꂽ�t�@�C���Ɠ��� ###
set avs_project_name=%~n1

rem ### �f�B���N�g����(%main_project_name%)�ƁA�t�@�C����(%avs_project_name%)�����肷��֐�
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
    rem �o�b�`���[�h�Ŗ����莖���m�胋�[�`��������
    call :bat_video_resolution_detect
) else (
    rem # �e���[�U�[�ݒ�����肷�鍀��
    call :manual_job_settings "%~1"
    call :deinterlace_filter_selector
    call :NR_filter_selector
    call :video_job_selector
    call :vfr_rate_selecter
    call :audio_job_selector
)

rem # ���C���o�b�`�t�@�C�����쐬����
call :make_main_bat "%~1"
rem # �e�\�[�X���̉������̐���(.ts|.dv|.avs)
rem # ���̓t�@�C����TS�̏ꍇ�̏����A�K�v�ȏꍇ�̉����\�[�X�̍쐬���܂�
call :sub_video_encodebatfile_detec
call :sub_audio_editbatfile_detec
call :sub_d2vgenbatfile_detec
call :sub_copybatfile_detec
call :copy_source_phase "%~1"
echo rem # �\�[�X�t�@�C���̃R�s�[����ю��O����>> "%main_bat_file%"
echo call ".\bat\copy_src.bat">> "%main_bat_file%"
echo.>> "%main_bat_file%"
rem # .d2v�t�@�C���쐬
call :make_d2vfile_phase "%input_media_path%"
rem �����t�@�C������p�o�b�`�t�@�C���p�X��ݒ�
call :sub_srteditfile_detec
rem �g���b�Nmux�p�o�b�`�t�@�C���p�X��ݒ�
call :sub_muxtracksfile_detec
rem �ꎞ�t�@�C���폜�p�o�b�`�t�@�C���p�X��ݒ�
call :sub_deltmpfile_detec
rem ���S��������ю���CM�J�b�g�֘A�o�b�`���e�쐬
call :make_logoframe_phase
rem # Trim���̐��`
call :sub_trimlinefile_detec
rem Trim�ҏW�p�o�b�`���e�쐬
call :make_trimline_phase
rem AutoVfr�p�o�b�`����ѐݒ�t�@�C���쐬
call :make_autovfr_phase
rem # AVS�t�@�C�����쐬����A���̓t�@�C����.avs�̏ꍇ�̓X�L�b�v
if "%~x1"==".avs" (
    rem # ���͂�avs�̏ꍇ�V�K��avs�t�@�C���͍쐬���Ȃ�
) else (
    rem # avs�t�@�C���쐬
    call :make_avsfile_phase "%~1"
    rem # �v���O�C���ǂݍ��݁`�\�[�X�ǂݍ��݃t�B���^�쐬
    call :make_avsplugin_phase "%~1"
    rem # ���̓t�@�C���ǂݍ��ݕ��@�𒼐ړǂݍ��݂��A�e���|�����Ɉꎞ�R�s�[���ŕ��ނ���
    call :load_mpeg2ts_source "%~1"
    rem # �t�B�[���h�I�[�_�[�`�C���^�������O�̃t�B���^�̓���
    call :avs_interlacebefore_phase
    rem # Trim���̃C���|�[�g
    call :trim_edit_phase
    rem # �C���^�[���[�X��ԂœK�p����t�B���^�̌���
    call :interlaced_filter_phase
    rem # �F��ԕϊ��t�B���^�̋L�q�AEarthsoftDV��BT.601�Ř^�悷�邽�ߕϊ��Ȃ��BTS�ł���SD�ȉ��ɕϊ��̏ꍇ�ɋL�q
    call :make_ColorMatrix_filter
    rem # �C���^�[���[�X�����t�B���^�̓���
    call :avs_interlacemain_phase
    rem # �h�b�g�W�Q�A�N���X�J���[�����t�B���^
    call :DeDotCC_filter_phase
    rem # �f�C���^�[���[�X�t�B���^
    call :deinterlace_filter_phase
    rem # �N���b�v�t�B���^
    call :crop_filter_phase
    rem # NR�t�B���^�`���̑��̃t�B���^����
    call :avs_interlaceafter_phase
    rem # NR �t�B���^
    call :nr_filter_phase
    rem # ���T�C�Y�t�B���^
    call :resize_filter_phase
    rem # Sharp �t�B���^
    call :sharp_filter_phase
    rem # ���ђǉ�
    call :add_border_phase
    rem # ConvertToYV12�t�B���^
    call :ConvertToYV12_filter_phase
    rem # ItsCut�t�B���^
    call :ItsCut_filter_phase
    rem # Its�p.def�t�@�C���̃R�s�[
    copy "%def_itvfr_file%" "%work_dir%%main_project_name%\avs\main.def"
    copy "%def_itvfr_file%" "%work_dir%%main_project_name%\main.def"
    rem # �e�퉹����ǂݍ���ł���ATrim�ҏW��̃I�[�f�B�I�X�g���[�����o�͂��邽�߂�avs�t�@�C���쐬
    call :make_fawsrc_avs
    call :make_pcmsrc_avs
    rem # �J�b�g�ҏW�pavs�t�@�C���쐬
    call :make_cuteditfile_phase "%~1"
    rem # �v���r���[(�����m�F�p)avs�t�@�C���쐬
    call :make_previewfile_phase "%~1"
    rem # �v���O�C���ǂݍ��݃t�B���^�쐬
    call :make_previewplugin_phase "%~1"
    rem # �\�[�X�t�@�C������
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
    call :edit_analyze_filter
    rem # �����߃��S�����֐�avs�t�@�C���o��^(��t�@�C��^)
    call :eraselogo_filter
)
rem # ���S�t�@�C��(.lgd)�̃R�s�[�t�F�[�Y
call :copy_lgd_file_phase "%~1"
rem # �J�b�g�������@�X�N���v�g(JL)�̃R�s�[�t�F�[�Y
call :copy_JL_file_phase "%~1"
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
rem # ffmpeg�ɂ��edts�C���AQT�Ȃǈꕔ�\�t�g�ŃA�X�y�N�g���񂪋@�\���Ȃ��Ȃ鋰�ꂠ��
if "%fix_edts_flag%"=="1" (
    call :fix_edts_select "%~1"
)
rem # ��Ɨp�̃\�[�X�t�@�C������ѕs�v�Ȉꎞ�t�@�C���̍폜
echo rem # ��Ɨp�̃\�[�X�t�@�C������ѕs�v�Ȉꎞ�t�@�C���̍폜�t�F�[�Y>> "%main_bat_file%"
call :del_tmp_files
rem # �p�����[�^�[�t�@�C���쐬
call :make_parameterfile_phase "%src_file_path%"
rem # �I�����ԋL�q
call :last_order "%~1"
rem # �o�b�`�t�@�C���Ăяo��
if not "%calling_bat_file%"=="" (
    call :call_bat_phase
)
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
rem # JL�t�@�C���̎w��
if exist "%~1" (
    set JL_src_file_full-path=%~1
) else (
    set error_message=Do not exist "%~1" !
    goto :error
)
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

:bat_cropsize_detect
rem # ���ѓ��̕\���O�̈��Crop�w��
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
rem # ���s���O�ɎQ�Ƃ���p�����[�^�[�t�@�C�����쐬
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
rem # ���O�ɃJ�b�g�ҏW���邽�߂�AVS�t�@�C���쐬
echo ##### ���O�ɃJ�b�g�ҏW���邽�߂�AVS #####> "%work_dir%%main_project_name%\cutedit.avs"
echo #//--- �v���O�C���ǂݍ��ݕ����̃C���|�[�g ---//>> "%work_dir%%main_project_name%\cutedit.avs"
echo Import^(".\avs\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\cutedit.avs"
echo.>> "%work_dir%%main_project_name%\cutedit.avs"
echo #//--- �\�[�X�̓ǂݍ��� ---//>> "%work_dir%%main_project_name%\cutedit.avs"
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
echo #//--- �t�B�[���h�I�[�_�[ ---//>> "%work_dir%%main_project_name%\cutedit.avs"
echo #AssumeFrameBased^(^).ComplementParity^(^)    #�g�b�v�t�B�[���h���x�z�I>> "%work_dir%%main_project_name%\cutedit.avs"
echo.>> "%work_dir%%main_project_name%\cutedit.avs"
echo #//--- Trim���C���|�[�g ---//>> "%work_dir%%main_project_name%\cutedit.avs"
echo #Import^("trim_line.txt"^)>> "%work_dir%%main_project_name%\cutedit.avs"
echo.>> "%work_dir%%main_project_name%\cutedit.avs"
echo #//--- �I�� ---//>> "%work_dir%%main_project_name%\cutedit.avs"
echo return last>> "%work_dir%%main_project_name%\cutedit.avs"
exit /b

:make_fawsrc_avs
rem # �^��WAV(FAW)���o�͂���ۂɐ��`�ς�Trim����n�����߂�AVS�t�@�C���쐬
echo ##### �^��WAV^(FAW^)���o�͂���ۂɐ��`�ς�Trim����n�����߂�AVS #####> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo #//--- �v���O�C���ǂݍ��ݕ����̃C���|�[�g ---//>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo Import^(".\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo.>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo #//--- �\�[�X�̓ǂݍ��� ---//>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
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
echo #//--- �t�B�[���h�I�[�_�[ ---//>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo #AssumeFrameBased^(^).ComplementParity^(^)    #�g�b�v�t�B�[���h���x�z�I>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo.>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo #//--- Trim���C���|�[�g ---//>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo Import^("..\trim_chars.txt"^)>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo.>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
echo return last>> "%work_dir%%main_project_name%\avs\audio_export_faw.avs"
exit /b

:make_pcmsrc_avs
rem # PCM WAV���o�͂���ۂɐ��`�ς�Trim����n�����߂�AVS�t�@�C���쐬
echo ##### PCM WAV���o�͂���ۂɐ��`�ς�Trim����n�����߂�AVS #####> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo #//--- �v���O�C���ǂݍ��ݕ����̃C���|�[�g ---//>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo Import^(".\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo.>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo #//--- �\�[�X�̓ǂݍ��� ---//>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
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
echo #//--- �t�B�[���h�I�[�_�[ ---//>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo #AssumeFrameBased^(^).ComplementParity^(^)    #�g�b�v�t�B�[���h���x�z�I>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo.>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo #//--- Trim���C���|�[�g ---//>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo Import^("..\trim_chars.txt"^)>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo.>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
echo return last>> "%work_dir%%main_project_name%\avs\audio_export_pcm.avs"
exit /b

:make_trimline_phase
rem # ���`�������ʂ̕����񂪋󂾂����ꍇ�͉������Ȃ�
echo rem # Trim������̐��`�t�F�[�Y>>"%main_bat_file%"
echo call ".\bat\trim_chars.bat">>"%main_bat_file%"
echo.>>"%main_bat_file%"
type nul > "%work_dir%%main_project_name%\trim_chars.txt"
type nul > "%trimchars_batfile_path%"
echo @echo off>> "%trimchars_batfile_path%"
echo setlocal>> "%trimchars_batfile_path%"
echo echo start %%~nx0 bat job...>> "%trimchars_batfile_path%"
echo chdir /d %%~dp0..\>> "%trimchars_batfile_path%"
echo.>> "%trimchars_batfile_path%"
echo rem # �G���R�[�h�c�[�����܂Ƃ߂��f�B���N�g�����������ϐ�ENCTOOLSROOTPATH����`����Ă��邩�m�F>> "%trimchars_batfile_path%"
echo call :toolsdircheck>> "%trimchars_batfile_path%"
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o>> "%trimchars_batfile_path%"
echo call :project_name_check>> "%trimchars_batfile_path%"
echo.>> "%trimchars_batfile_path%"
echo rem # �e����s�t�@�C����Windows�W���R�}���h�Q�̂݁B>> "%trimchars_batfile_path%"
echo.>> "%trimchars_batfile_path%"
echo :main>> "%trimchars_batfile_path%"
echo rem //----- main�J�n -----//>> "%trimchars_batfile_path%"
echo title %%project_name%%>> "%trimchars_batfile_path%"
echo echo Trim���𐮌`���Ă��܂�. . .[%%time%%]>> "%trimchars_batfile_path%"
echo echo # �\�[�X�ɑ΂��Ă�Trim���f�����o^> "trim_chars.txt">> "%trimchars_batfile_path%"
echo rem # "trim_line.txt"����P��s�𒊏o>> "%trimchars_batfile_path%"
echo set count=^0>> "%trimchars_batfile_path%"
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%Q in ^(`findstr /b /r Trim^^(.*^^) "trim_line.txt"`^) do ^(>> "%trimchars_batfile_path%"
echo     set trim_detect=%%%%Q>> "%trimchars_batfile_path%"
echo     call :linecount_checker>> "%trimchars_batfile_path%"
echo     set /a count=count+1>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo rem # "main.avs"����P��s�𒊏o>> "%trimchars_batfile_path%"
echo if not "%%trim_detect:~0,4%%"=="Trim" ^(>> "%trimchars_batfile_path%"
echo     call :conv_mainline2char>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo rem # "trim_multi.txt"���畡���s���o>> "%trimchars_batfile_path%"
echo if not "%%trim_detect:~0,4%%"=="Trim" ^(>> "%trimchars_batfile_path%"
echo     call :conv_multi2char>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo rem # "main.avs"���畡���s���o>> "%trimchars_batfile_path%"
echo if not "%%trim_detect:~0,4%%"=="Trim" ^(>> "%trimchars_batfile_path%"
echo     call :conv_mainmulti2char>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo rem # Trim�s�����o�����Ώ����I��>> "%trimchars_batfile_path%"
echo if "%%trim_detect:~0,4%%"=="Trim" ^(>> "%trimchars_batfile_path%"
echo     call :show_trim_chars>> "%trimchars_batfile_path%"
echo ^) else ^(>> "%trimchars_batfile_path%"
echo     call echo Trim�͌��o����܂���ł����B>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo rem # �����񒊏o�I��>> "%trimchars_batfile_path%"
echo title �R�}���h �v�����v�g>> "%trimchars_batfile_path%"
echo rem //----- main�I�� -----//>> "%trimchars_batfile_path%"
echo echo end %%~nx0 bat job...>> "%trimchars_batfile_path%"
echo exit /b>> "%trimchars_batfile_path%"
echo.>> "%trimchars_batfile_path%"
rem ------------------------------
echo :toolsdircheck>> "%trimchars_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%trimchars_batfile_path%"
echo     echo ���ϐ� ENCTOOLSROOTPATH ������`�ł�>> "%trimchars_batfile_path%"
echo     exit /b>> "%trimchars_batfile_path%"
echo ^)>> "%trimchars_batfile_path%"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\>> "%trimchars_batfile_path%"
echo if exist "%%ENCTOOLSROOTPATH%%" ^(>> "%trimchars_batfile_path%"
echo     exit /b>> "%trimchars_batfile_path%"
echo ^) else ^(>> "%trimchars_batfile_path%"
echo     echo ���ϐ�ENCTOOLSROOTPATH���L���ȃp�X�ł͂���܂���>> "%trimchars_batfile_path%"
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
echo     echo "trim_line.txt"�ɒP��s��Trim�����o����܂���>> "%trimchars_batfile_path%"
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
echo     echo "main.avs"�ɒP��s��Trim�����o����܂���>> "%trimchars_batfile_path%"
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
echo     echo "trim_multi.txt"����Trim���𒊏o���܂�>> "%trimchars_batfile_path%"
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
echo     echo "main.avs"�ɕ����s��Trim�����o����܂���>> "%trimchars_batfile_path%"
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
echo echo Trim���F%%trim_detect%%>> "%trimchars_batfile_path%"
echo exit /b>> "%trimchars_batfile_path%"
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
echo @echo off>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo setlocal>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo start %%~nx0 bat job...>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo chdir /d %%~dp0..\>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # �G���R�[�h�c�[�����܂Ƃ߂��f�B���N�g�����������ϐ�ENCTOOLSROOTPATH����`����Ă��邩�m�F>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :toolsdircheck>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :project_name_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # parameter�t�@�C�����̓��ߐ����S�t�B���^�������p�����[�^�[^(disable_delogo^)�����o>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :disable_delogo_status_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # parameter�t�@�C�����̎���CM�J�b�g�������p�����[�^�[^(disable_cmcutter^)�����o>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :disable_cmcutter_status_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # parameter�t�@�C������lgd�t�@�C���������o>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :lgd_file_name_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # parameter�t�@�C������JL�t�@�C���������o>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :JL_file_name_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # �eAVS�t�@�C���̒�����L����Trim�s���܂܂�Ă��Ȃ������o>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :total_trim_line_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # EraseLogo.avs �̃t�@�C���T�C�Y�����o>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :eraselogo_avs_filesize_check ".\avs\EraseLogo.avs">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # �e���s�t�@�C�������݂��邩�m�F�B���݂��Ȃ��ꍇENCTOOLSROOTPATH������T������A�������̓V�X�e���̒T���p�X�Ɉς˂�>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if exist "%logoframe_path%" ^(set logoframe_path=%logoframe_path%^) else ^(call :find_logoframe "%logoframe_path%"^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if exist "%chapter_exe_path%" ^(set chapter_exe_path=%chapter_exe_path%^) else ^(call :find_chapter_exe "%chapter_exe_path%"^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if exist "%join_logo_scp_path%" ^(set join_logo_scp_path=%join_logo_scp_path%^) else ^(call :find_join_logo_scp "%join_logo_scp_path%"^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # �e����s�t�@�C���ւ̃p�X���A�ŏI�I�ɂǂ̂悤�Ȓl�ɂȂ������m�F�B>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo logoframe    : %%logoframe_path%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo chapter_exe  : %%chapter_exe_path%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo join_logo_scp: %%join_logo_scp_path%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :main>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem //----- main�J�n -----//>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo title %%project_name%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo ���S��CM�J�b�g�Ɋւ��鏈���H�������s���܂�. . .[%%time%%]>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # logoframe���s�̃T�u���[�`���Ăяo��>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :logoframe_subroutine>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if "%%trim_line_counter%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     rem # chapter_exe���s�̃T�u���[�`���Ăяo��>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     call :chapter_exe_subroutine>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     rem # join_logo_scp���s�̃T�u���[�`���Ăяo��>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     call :join_logo_scp_subroutine>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo Trim�����ɑ}������Ă��܂��A����CM�J�b�g�͕K�v����܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo title �R�}���h �v�����v�g>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem //----- main�I�� -----//>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo end %%~nx0 bat job...>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :toolsdircheck>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not defined ENCTOOLSROOTPATH ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo ���ϐ� ENCTOOLSROOTPATH ������`�ł�>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if exist "%%ENCTOOLSROOTPATH%%" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo ���ϐ�ENCTOOLSROOTPATH���L���ȃp�X�ł͂���܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
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
echo     echo .lgd �t�@�C��������ł�>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
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
echo     echo JL �t�@�C��������ł�>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     call :JL_file_path_set>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :JL_file_path_set>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo set JL_file_path=.\JL\%%JL_file_name%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :total_trim_line_check>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # �L����Trim�s���܂܂�Ă��Ȃ����`�F�b�N�A�܂܂�Ă����ꍇ���ɕҏW�ς݂Ɣ��f���㑱�̏������X�L�b�v����>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
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
echo echo EraseLogo.avs �t�@�C���T�C�Y�F%%eraselogo_avs_filesize%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :find_logoframe>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo findexe�����F"%%~1">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not defined ENCTOOLSROOTPATH ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo �T�����Ă��܂�...>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo ������܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         set logoframe_path=%%%%~E>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :logoframe_env_search "%%~nx1">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :logoframe_env_search>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo set logoframe_path=%%~$PATH:1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if "%%logoframe_path%%"=="" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo logoframe��������܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     set logoframe_path=%%~1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :find_chapter_exe>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo findexe�����F"%%~1">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not defined ENCTOOLSROOTPATH ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo �T�����Ă��܂�...>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo ������܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         set chapter_exe_path=%%%%~E>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :chapter_exe_env_search "%%~nx1">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :chapter_exe_env_search>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo set chapter_exe_path=%%~$PATH:1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if "%%chapter_exe_path%%"=="" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo chapter_exe��������܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     set chapter_exe_path=%%~1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :find_join_logo_scp>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo echo findexe�����F"%%~1">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not defined ENCTOOLSROOTPATH ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo �T�����Ă��܂�...>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo ������܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         set join_logo_scp_path=%%%%~E>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo call :join_logo_scp_env_search "%%~nx1">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :join_logo_scp_env_search>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo set join_logo_scp_path=%%~$PATH:1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if "%%join_logo_scp_path%%"=="" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo join_logo_scp��������܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     set join_logo_scp_path=%%~1>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :logoframe_subroutine>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo pushd avs>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not exist "%%lgd_file_path%%" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo .lgd �t�@�C�������o�ł��܂���B�����𑱂��邱�Ƃ��o���Ȃ��ׁAlogoframe�̏����𒆒f���܂��B>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     popd>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo popd>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # logoframe�����s���邽�߂̃T�u���[�`���ł�>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not exist ".\log\logoframe_log.txt" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo logoframe_log.txt�����݂��܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     if "%%eraselogo_avs_filesize%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo EraseLogo.avs�ɗL���Ȓl���}������Ă��܂���B>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         if not "%%disable_delogo%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             echo �����߃��S�����͗L���ł�>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             if not "%%disable_cmcutter%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 echo logoframe�����s���܂�^^^(avs+log^^^)...[%%time%%]>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 call :run_logoframe_all>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 echo logoframe�͎��s���܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             echo �����߃��S�����͖����ł�>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             if not "%%trim_line_counter%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 echo Trim�����ɑ}������Ă��܂��Alogoframe�͎��s���܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 if not "%%disable_cmcutter%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                     echo ����CM�J�b�g�͗L���ł��Alogoframe�����s���܂�^^^(log^^^)...[%%time%%]>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                     call :run_logoframe_log>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                     echo ����CM�J�b�g�͖����ł��Alogoframe�͎��s���܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo EraseLogo.avs�͗L���ł��A�����߃��S����������܂��B>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         if not "%%trim_line_counter%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             echo Trim�����ɑ}������Ă��܂��Alogoframe�͎��s���܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             if not "%%disable_cmcutter%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 echo ����CM�J�b�g�͗L���ł��Alogoframe�����s���܂�^^^(log^^^)...[%%time%%]>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 call :run_logoframe_log>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo                 echo ����CM�J�b�g�͖����ł��Alogoframe�͎��s���܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo logoframe_log.txt�����݂��Ă��܂�>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     if "%%eraselogo_avs_filesize%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo EraseLogo.avs�ɗL���Ȓl���}������Ă��܂���B>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         if not "%%disable_delogo%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             echo �����߃��S�����͗L���ł��Alogoframe�����s���܂�^^^(avs+log��logoframe_log.txt�͏㏑������܂�^^^)...[%%time%%]>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             call :run_logoframe_all>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo             echo �����߃��S�����͖����ł��Alogoframe�͎��s���܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo EraseLogo.avs�͗L���ł��A�����߃��S����������܂��Blogoframe �����͕s�v�ׁ̈A�X�L�b�v���܂��B>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :run_logoframe_all>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # EraseLogo.avs �ɏ�ʂ̑��΃p�X���L�����邽�߂ɁA�ꎞ�I�ɍ�ƃt�H���_�ړ�^(log�̂ݍ쐬�̏ꍇ�A�{���͕s�v^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo pushd avs>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo "%%logoframe_path%%" -outform 1 ".\edit_analyze.avs" -logo "%%lgd_file_path%%" -oa "..\log\logoframe_log.txt" -o ".\EraseLogo.avs">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo popd>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :run_logoframe_log>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # EraseLogo.avs �ɏ�ʂ̑��΃p�X���L�����邽�߂ɁA�ꎞ�I�ɍ�ƃt�H���_�ړ�^(log�̂ݍ쐬�̏ꍇ�A�{���͕s�v^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo pushd avs>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo "%%logoframe_path%%" -outform 1 ".\edit_analyze.avs" -logo "%%lgd_file_path%%" -oa "..\log\logoframe_log.txt">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo popd>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :chapter_exe_subroutine>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo pushd avs>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not exist "%%lgd_file_path%%" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo .lgd �t�@�C�������o�ł��܂���B�����𑱂��邱�Ƃ��o���Ȃ��ׁAchapter_exe�̏����𒆒f���܂��B>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     popd>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo popd>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not "%%disable_cmcutter%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo ����CM�J�b�g�͗L���ł��Achapter_exe�����s���܂�...[%%time%%]>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     call :run_chapter_exe_log>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo ����CM�J�b�g�͖����ł��Achapter_exe�͎��s���܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :run_chapter_exe_log>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo "%%chapter_exe_path%%" -v ".\avs\edit_analyze.avs" -o ".\log\chapter_exe_log.txt">> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo :join_logo_scp_subroutine>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # comskip�̃��[�`������ň����p������>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not exist "%%JL_file_path%%" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo JL �t�@�C�������o�ł��܂���B�����𑱂��邱�Ƃ��o���Ȃ��ׁAjoin_logo_scp�̏����𒆒f���܂��B>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     exit /b>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo if not exist ".\log\logoframe_log.txt" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo logoframe_log.txt ��������܂���Ajoin_logo_scp �𒆒f���܂�>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else if not exist ".\log\chapter_exe_log.txt" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     echo chapter_exe_log.txt ��������܂���Ajoin_logo_scp �𒆒f���܂�>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     if not "%%disable_cmcutter%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo ����CM�J�b�g�͗L���ł��Ajoin_logo_scp�����s���܂�...[%%time%%]>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         call :run_join_logo_scp_log>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo ����CM�J�b�g�͖����ł��Ajoin_logo_scp�͎��s���܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo rem # trim_chars.txt �ɗL����Trim�s���܂܂�Ă��Ȃ����ŏI�`�F�b�N�A�܂܂�Ă��Ȃ����join_logo_scp�̏o�͌��ʂ��}�[�W����>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
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
echo     echo trim_chars.txt �ɂ͊��ɗL����Trim���܂܂�Ă��܂��Ajoin_logo_scp �̏o�͌��ʂ̓}�[�W���܂���>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo     if not exist ".\tmp\join_logo_scp_out.txt" ^(>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
echo         echo join_logo_scp_out.txt ��������܂���A�}�[�W���X�L�b�v���܂�>> "%work_dir%%main_project_name%\bat\logoframe_chapter_scan.bat"
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
rem ### AutoVfr�������������邽�߂̃X�e�b�v
echo rem # AutoVfr�̎��s�t�F�[�Y>>"%main_bat_file%"
echo call ".\bat\autovfr_scan.bat">> "%main_bat_file%"
echo.>> "%main_bat_file%"
copy "%autovfr_template%" "%work_dir%%main_project_name%\\avs\"
copy "%autovfr_fast_template%" "%work_dir%%main_project_name%\\avs\"
rem # "AutoVfr.ini"���R�s�[����Bautovfrini_path�Ŏw�肳�ꂽ�p�X�����݂��Ȃ��ꍇ�́AAutoVfr.exe�Ɠ����p�X���g�p����B
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
echo rem ��AutoVfr��Mode>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :autovfr_mode_detect>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem [0=Auto_Vfr�𗘗p] [1=Auto_Vfr_Fast�𗘗p]>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem set autovfr_mode=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ��AutoVfr�̎���/�蓮�ݒ蔻��>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :autovfr_deint_detect>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem [0=�}�j���A���ŃC���^���[�X�𗘗p] [1=�����f�C���^�[���[�X�𗘗p]>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem set autovfr_deint=^1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ���X���b�h���w��>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :autovfr_threadnum_detect>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # AutoVfr���O���o�͂���ۂ̃X���b�h�����w�肵�܂��B���w��̏ꍇ�A�V�X�e���̘_��CPU���ɂȂ�܂��B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem set autovfr_thread_num=>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem *****************Auto_Vfr�Ŏg�p**********************>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ��Auto_Vfr�̐ݒ�B^(^)�����ŋL�ځB���O�t�@�C���p�X,cut,number�͎w��s�v�B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem [�ꗗ] cthresh=^(�R�[�~���O����-1-255^), mi=^(�R�[�~���O��0-blockx*blocky^), chroma=false, blockx=16^(����u���b�N�c�T�C�Y^), blocky=^(����u���b�N���T�C�Y^), IsCrop=false, crop_height=, IsTop=false, IsBottom=true, show_crop=false, IsDup=false, thr_m=10, thr_luma=0.01>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem �����lcthresh=60, mi=55, blockx=16, blocky=32 >> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem �e���b�v����cthresh=110,mi=100���x�����^(70,60^)�B����������ƌ딻�葽���A�グ������Ǝ������莸�s���ăe���b�v���؂��Bcthresh�͂��̂܂܂ŁAmi�𓮂����Ē�������̂��ǂ��B^(60fps��Ԃ��L����ݒ肠��Ηǂ��̂�^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem crop_height�̒l��YV12�̏ꍇ4�̔{���łȂ��ƃG���[�ɂȂ�̂Œ��ӁI>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo @set AUTOVFRSETTING=cthresh=80, mi=60, blockx=16, blocky=32, chroma=false, IsCrop=true, crop_height=92^4>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ��AutoVfr.exe�̐ݒ�^(-i -o�ȊO�̃I�v�V�����w��^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%autovfr_deint%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     @set EXESETTING=-INI "AutoVfr.ini" -30F 1 -60F 1 -skip 1 -ref 300 -24A 0 -30A 0 -FIX>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     @set EXESETTING=-INI "AutoVfr.ini" -30F 1 -60F 1 -skip 1 -ref 300 -24A 1 -30A 1 -FIX>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ��60i�e���͈͊g���t���[����^(60fps�E6to2�͈� �g��^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem �딚�h�~��臒l�ݒ�ׁ̈A60i�e�����o�������Z���Ȃ�ꍇ������܂��B�����␳���܂��B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ���̏�����AutoVFR.exe�̌�ɍs���܂��B"[24] txt60mc"�܂���"[60] f60"���܂ޔ͈͎w��s�������Ώۂɂ��܂��B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem EXBIGIs�ɐ擪�́AEXLASTs�ɖ����̊g���t���[�������A�w�肵�Ă��������B5�̔{�������B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo @set EXBIGIs=^5>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo @set EXLASTs=^5>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem *****************Auto_Vfr_Fast�ŗ��p*****************>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ��Auto_Vfr_Fast�̐ݒ�B^(^)�����ŋL�ځB���O�t�@�C���p�X,cut,number�͎w��s�v�B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem [�ꗗ] cthresh=^(�R�[�~���O����-1-255^), mi=^(�R�[�~���O��0-blockx*blocky^), chroma=false, blockx=^(����u���b�N�c�T�C�Y^), blocky=^(����u���b�N���T�C�Y^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem �����lcthresh=60, mi=55, blockx=16, blocky=32 >> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem �e���b�v����cthresh=110,mi=100���x�����^(70,60^)�B����������ƌ딻�葽���A�グ������Ǝ������莸�s���ăe���b�v���؂��Bcthresh�͂��̂܂܂ŁAmi�𓮂����Ē�������̂��ǂ��B^(60fps��Ԃ��L����ݒ肠��Ηǂ��̂�^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo @set AUTOVFRFASTSETTING=cthresh=80, mi=60, blockx=16, blocky=32, chroma=false>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ��AutoVfr.exe�̐ݒ�^(-i -o�ȊO�̃I�v�V�����w��^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%autovfr_deint%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     @set FASTEXESETTING=-INI "AutoVfr.ini" -30F 1 -60F 1 -skip 1 -ref 250 -24A 0 -30A 0 -FIX>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     @set FASTEXESETTING=-INI "AutoVfr.ini" -30F 1 -60F 1 -skip 1 -ref 250 -24A 1 -30A 1 -FIX>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ��60i�e���͈͊g���t���[����^(60fps�͈͊g��^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem �딚�h�~��臒l�ݒ�ׁ̈A60i�e�����o�������Z���Ȃ�ꍇ������܂��B�����␳���܂��B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ���̏�����AutoVFR.exe�̌�ɍs���܂��B"[60] f60"���܂ޔ͈͎w��s�������Ώۂɂ��܂��B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem EXBIGIf�ɐ擪�́AEXLASTf�ɖ����̊g���t���[�������A�w�肵�Ă��������B5�̔{�������B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo @set EXBIGIf=^5>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo @set EXLASTf=^5>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem *****************************************************>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # �G���R�[�h�c�[�����܂Ƃ߂��f�B���N�g�����������ϐ�ENCTOOLSROOTPATH����`����Ă��邩�m�F>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :toolsdircheck>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :project_name_check>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # �e���s�t�@�C�������݂��邩�m�F�B���݂��Ȃ��ꍇENCTOOLSROOTPATH������T������A�������̓V�X�e���̒T���p�X�Ɉς˂�>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist "%avs2pipe_path%" ^(set avs2pipe_path=%avs2pipe_path%^) else ^(call :find_avs2pipe "%avs2pipe_path%"^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist "%autovfr_path%" ^(set autovfr_path=%autovfr_path%^) else ^(call :find_autovfr "%autovfr_path%"^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # �e����s�t�@�C���ւ̃p�X���A�ŏI�I�ɂǂ̂悤�Ȓl�ɂȂ������m�F�B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo avs2pipe: %%avs2pipe_path%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo AutoVfr : %%autovfr_path%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo :main>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem //----- main�J�n -----//>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo title %%project_name%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ���[�Ƃ��[��VFR�iAutoVFR BAT�Łj �C���X�p�C�A>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo Auto_VFR��Auto_VFR_Fast�̏����������p���܂�>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo 臒l�m�F��>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ShowCombedTIVTC^(debug=true,blockx=16,blocky=32,cthresh=60^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ���ŉ\�ł��B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo txt60mc�́A�uII�t���[���O�̍Ō��P�t���[���̃t���[���ԍ���Mod5�l���A�w�肷��l�v���w��>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # �J�����g��.def�t�@�C�����f�t�H���g�̂��̂Ɣ�r���A����������΃��[�U�[�ҏW�ς݂Ƃ���AutoVfr�̓X�L�b�v>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if not exist ".\main.def" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo main.def�t�@�C�������݂��܂���BAutoVfr�����s���܂��B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
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
echo rem AutoVFR��AutoVFR_Fast�𕪊�>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set SEPARATETEMP=%%autovfr_thread_num%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%autovfr_mode%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     call :MAKESLOWAVS>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     call :MAKEFASTAVS>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo AutoVfr�𑖍����܂�. . .[%%time%%]>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :AVS2PIPE_DECODE>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :MAKEDEF>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :EDITDEFm>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # .def�t�@�C����V�������ꂽ���̂ɒu������>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo call :ReLOCATION>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ***************************************************************>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ���S�Ă̏������I�����܂����B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo �J�n : %%STARTTIME%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo �I�� : %%DATE%% %%TIME%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ***************************************************************>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo title �R�}���h �v�����v�g>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem //----- main�I�� -----//>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
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
echo         echo �s���ȃp�����[�^�w��ł��B�f�t�H���g��AutoVfr^^^(Slow^^^)���[�h���g�p���܂��B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         set autovfr_mode=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%autovfr_mode%%"=="" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo AutoVfr�̃��[�h�w�肪������܂���B�f�t�H���g��AutoVfr^^^(Slow^^^)���[�h���g�p���܂��B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
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
echo         echo �s���ȃp�����[�^�w��ł��B�f�t�H���g�̎����f�C���^�[���[�X���[�h���g�p���܂��B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         set autovfr_deint=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%autovfr_deint%%"=="" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo AutoVfr�̃f�C���^�[���[�X�w�肪������܂���B�f�t�H���g�̎����f�C���^�[���[�X���[�h���g�p���܂��B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set autovfr_deint=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :autovfr_threadnum_detect>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # ���K�\������̌��ʂœ�����G���[���x���ɂ���ăp�����[�^�[�̎w�肪���������ۂ����肵�܂��B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # �o�b�`�t�@�C���Ő��l���ǂ������肵�����̂Łc�i�����j - �A�Z�g�A�~�m�t�F���̋C�܂܂ȓ���>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # http://d.hatena.ne.jp/acetaminophen/20150809/1439150912>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f "usebackq eol=# tokens=2 delims==" %%%%T in ^(`findstr /b /r autovfr_thread_num "parameter.txt"`^) do ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set thread_tmp_num=%%%%T>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo %%%%T^| findstr /x /r "^[+-]*[0-9]*[\.]*[0-9]*$" 1^>nul>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%ERRORLEVEL%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     if not "%%thread_tmp_num%%"=="" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         echo AutoVfr�̎��s�X���b�h�� %%thread_tmp_num%% �ł��B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         set autovfr_thread_num=%%thread_tmp_num%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         echo AutoVfr�̎��s�X���b�h�������w�肩�p�����[�^�[�w�肻�̂��̂�������܂���B����ɃV�X�e���̘_��CPU�� %%Number_Of_Processors%% ���g�p���܂��B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         set autovfr_thread_num=%%Number_Of_Processors%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else if "%%ERRORLEVEL%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo AutoVfr�̎��s�X���b�h���̎w�肩�p�����[�^�[�������l�ł͂���܂���B����ɃV�X�e���̘_��CPU�� %%Number_Of_Processors%% ���g�p���܂��B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set autovfr_thread_num=%%Number_Of_Processors%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set thread_tmp_num=>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :toolsdircheck>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if not defined ENCTOOLSROOTPATH ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo ���ϐ� ENCTOOLSROOTPATH ������`�ł�>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%ENCTOOLSROOTPATH%\>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist "%%ENCTOOLSROOTPATH%%" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo ���ϐ�ENCTOOLSROOTPATH���L���ȃp�X�ł͂���܂���>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
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
echo echo findexe�����F"%%~1">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if not defined ENCTOOLSROOTPATH ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set avs2pipe_path=%%~nx1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo �T�����Ă��܂�...>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         echo ������܂���>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         set avs2pipe_path=%%%%~E>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     call :avspipe_env_search %%~nx1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo :avspipe_env_search>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set avs2pipe_path=%%~$PATH:1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%avs2pipe_path%%"=="" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo avs2pipe��������܂���>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set avs2pipe_path=%%~1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :find_autovfr>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo findexe�����F"%%~1">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if not defined ENCTOOLSROOTPATH ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set autovfr_path=%%~nx1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo �T�����Ă��܂�...>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         echo ������܂���>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         set autovfr_path=%%%%~E>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��BAutoVfr.exe�͐�΃p�X�w������Ȃ���ini�t�@�C���̓ǂݍ��݂Ɏ��s���܂��̂ŕK�{^(ver0.1.1.1^)�B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     call :autovfr_env_search %%~nx1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo :autovfr_env_search>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo set autovfr_path=%%~$PATH:1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%autovfr_path%%"=="" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo    echo AutoVfr��������܂���>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set autovfr_path=%%~1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :def_diff_check>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo fc ".\main.def" ".\avs\main.def"^> NUL>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%errorlevel%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo .def�t�@�C�����ҏW�ςׁ݂̈AAutoVfr�̎��s���X�L�b�v���܂�>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set exit_stat=^1>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     set exit_stat=^0>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :SETPARAMETER>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem # ���ϐ��̃��Z�b�g>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
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
echo rem # �X���b�h����AutoVfr�pavs�t�@�C���쐬>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%SEPARATETEMP%%"=="0" ^(exit /b^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo copy /b ".\avs\LoadPlugin.avs" + ".\avs\Auto_Vfr.avs" ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo.^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ���t�B�[���h�I�[�_�[�𖾎����Ȃ���AutoVfr�X�L���������Ő���Ɍ딚����\��������̂Œ���>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
if "%mpeg2dec_select_flag%"=="1" (
    echo echo MPEG2VIDEO^("..\src\video.ts"^).AssumeTFF^(^)^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
) else if "%mpeg2dec_select_flag%"=="2" (
    echo echo MPEG2Source^("..\src\video.d2v",upconv=0^).AssumeTFF^(^)^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
) else if "%mpeg2dec_select_flag%"=="3" (
    echo echo video = LWLibavVideoSource^("..\src\video.ts", dr=false, repeat=true, dominance=0^).AssumeTFF^(^)^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
    echo echo video = video.height^(^) == 1088 ? video.Crop^(0, 0, 0, -8^) : video^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
    echo echo video^>^> ".\tmp\AutoVFR_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
)
rem # Trim�ҏW��1�s���o�t�@�C��"trim_chars.txt"�����݂���ꍇ�A�����AutoVfr�ɂ����f����
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
echo rem # �X���b�h����AutoVfr_Fast�pavs�t�@�C���쐬>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%SEPARATETEMP%%"=="0" ^(exit /b^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo copy /b ".\avs\LoadPlugin.avs" + ".\avs\Auto_Vfr_Fast.avs" ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo.^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem ���t�B�[���h�I�[�_�[�𖾎����Ȃ���AutoVfr�X�L���������Ő���Ɍ딚����\��������̂Œ���>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
if "%mpeg2dec_select_flag%"=="1" (
    echo echo MPEG2VIDEO^("..\src\video.ts"^).AssumeTFF^(^)^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
) else if "%mpeg2dec_select_flag%"=="2" (
    echo echo MPEG2Source^("..\src\video.d2v",upconv=0^).AssumeTFF^(^)^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
) else if "%mpeg2dec_select_flag%"=="3" (
    echo echo video = LWLibavVideoSource^("..\src\video.ts", dr=false, repeat=true, dominance=0^).AssumeTFF^(^)^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
    echo echo video = video.height^(^) == 1088 ? video.Crop^(0, 0, 0, -8^) : video^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
    echo echo video^>^> ".\tmp\AutoVFR_Fast_log_temp%%SEPARATETEMP%%.avs">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
)
rem # Trim�ҏW��1�s���o�t�@�C��"trim_chars.txt"�����݂���ꍇ�A�����AutoVfr�ɂ����f����
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
echo echo ���[�h            : %%MODE%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ������            : %%autovfr_thread_num%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo �X�v���v�gOptis   : %%VFROPTIONS%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo avs2pipe.exe�p�X  : %%avs2pipe_path%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo AutoVfr.exe�p�X   : %%autovfr_path%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo AutoVfr.exe�ݒ�   : %%AUTOEXESET%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo �e���b�v�͈͊g��  : [�擪= %%EXBIGI%%] [�I�[= %%EXLAST%%]>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo Log�t�@�C���o�͐� : %%OUTLOG%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo Def�t�@�C���o�͐� : %%OUTDEF%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%DELLOG%%"=="1" ^(echo  [��] Log�t�@�C���͏������܂�^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ===============================================================>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo �f�R�[�h�J�n : %%DATE%% %%TIME%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo �f�R�[�h�̈ꎞ��~ : �v�����v�g�� �E�N���b�N���͈͑I��>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo               �ĊJ : �v�����v�g�� �E�N���b�N>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ===============================================================>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo %%PIPECOMMAND:^"^|^"=^|%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo ===============================================================>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo echo �f�R�[�h�I�� : %%DATE%% %%TIME%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo %%COPYCOMMAND%% ^>NUL>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo %%DELCOMMANDa:^"^&^"=^&%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist "%%OUTLOG%%" ^(echo Log�t�@�C�����쐬����܂����B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
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
echo echo def�t�@�C�����o�͂��܂�[%%time%%]>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%autovfr_mode%%"=="0" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     "%%autovfr_path%%" -i ".\log\AutoVFR.log" -o "%%OUTDEF%%" %%EXESETTING%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^) else if "%%autovfr_mode%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     "%%autovfr_path%%" -i ".\log\AutoVFR_Fast.log" -o "%%OUTDEF%%" %%FASTEXESETTING%%>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist "%%OUTDEF%%" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     echo def�t�@�C�����쐬����܂����B>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     if "%%DELLOG%%"=="1" ^(>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo         del "%%OUTLOG%%">> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo     ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo ^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo exit /b>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo.>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
rem ------------------------------
echo :EDITDEFm>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if "%%EXBIGI%%" == "0" ^(if "%%EXLAST%%" == "0" ^(exit /b^)^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem �󔒍s����>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist "%%OUTDEF%%.temp" ^(del "%%OUTDEF%%.temp"^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f ^"usebackq delims=^" %%%%k in ^(^"%%OUTDEF%%^"^) do ^(echo %%%%k ^| find /v ^"mode fps_adjust = on^"^>^>^"%%OUTDEF%%.temp^"^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo if exist ^"%%OUTDEF%%.temp^" ^(del ^"%%OUTDEF%%^"^) else ^(echo ERROR1^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem �����s���擾>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f ^"usebackq delims=]^" %%%%k in ^(`find /n ^"-^" ^"%%OUTDEF%%.temp^" ^^^| find /i ^"[60] f60^"`^) do ^(call set TXTLINE=%%%%TXTLINE%%%%_%%%%k[^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f ^"usebackq delims=]^" %%%%k in ^(`find /n ^"-^" ^"%%OUTDEF%%.temp^" ^^^| find /i ^"[24] txt60mc^"`^) do ^(call set TXTLINE=%%%%TXTLINE%%%%_%%%%k[^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem �͈͎w��s�擾>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f ^"usebackq delims=[]^" %%%%k in ^(`find /n ^"-^" ^"%%OUTDEF%%.temp^" ^^^| find ^"[^" ^^^| find ^"] ^" ^^^| sort /r`^) do ^(set BIGILINE=%%%%k^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo for /f ^"usebackq delims=[]^" %%%%k in ^(`find /n ^"-^" ^"%%OUTDEF%%.temp^" ^^^| find ^"[^" ^^^| find ^"] ^" ^^^| sort`^) do ^(set LASTLINE=%%%%k^)>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
echo rem �u��>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
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
echo rem ����>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
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
echo rem `echo %%~1`�\�L������ɓ����Ȃ��̂Œ��ԃt�@�C�����g�p>> "%work_dir%%main_project_name%\bat\autovfr_scan.bat"
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


:call_bat_phase
if not exist "%calling_bat_file%" (
    type nul > "%calling_bat_file%"
    echo @echo off>> "%calling_bat_file%"
    echo setlocal>> "%calling_bat_file%"
    echo echo �J�n����[%%time%%]>> "%calling_bat_file%"
    echo.>> "%calling_bat_file%"
)
echo call "%main_bat_file%">> "%calling_bat_file%"
exit /b


:del_tmp_files
rem # ��Ɨp�̃\�[�X�t�@�C������ѕs�v�Ȉꎞ�t�@�C���̍폜�t�F�[�Y
echo call ".\bat\del_tmp.bat">>"%main_bat_file%"
echo.>> "%main_bat_file%"
type nul > "%deltmp_batfile_path%"
echo @echo off>> "%deltmp_batfile_path%"
echo setlocal>> "%deltmp_batfile_path%"
echo echo start %%~nx0 bat job...>> "%deltmp_batfile_path%"
echo cd /d %%~dp0..\>> "%deltmp_batfile_path%"
echo.>> "%deltmp_batfile_path%"
echo rem # %%large_tmp_dir%% �̑��݊m�F����і����`�F�b�N>> "%deltmp_batfile_path%"
echo if not exist "%%large_tmp_dir%%" ^(>> "%deltmp_batfile_path%"
echo     echo �傫�ȃt�@�C�����o�͂���ꎞ�t�H���_ %%%%large_tmp_dir%%%% �����݂��܂���A����ɃV�X�e���̃e���|�����t�H���_�ő�p���܂��B>> "%deltmp_batfile_path%"
echo     set large_tmp_dir=%%tmp%%>> "%deltmp_batfile_path%"
echo ^)>> "%deltmp_batfile_path%"
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\>> "%deltmp_batfile_path%"
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o>> "%deltmp_batfile_path%"
echo call :project_name_check>> "%deltmp_batfile_path%"
echo.>> "%deltmp_batfile_path%"
echo rem //----- main�J�n -----//>> "%deltmp_batfile_path%"
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
echo title �R�}���h �v�����v�g>> "%deltmp_batfile_path%"
echo rem //----- main�I�� -----//>> "%deltmp_batfile_path%"
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
rem # %lgd_file_src_path%�f�B���N�g���̒���������ǖ����܂ރ��S�t�@�C��(.lgd)���ċA�I�Ɍ����o���āAwork�f�B���N�g������lgd�f�B���N�g���ɃR�s�[���܂�
rem # ����t�@�C�����ɔ��p�J�b�R���܂܂�Ă���ƌ�쓮����̂ŁAcall�����g�p���O���֐����Ăяo���܂��B
rem # �ΏۂƂȂ�.lgd�t�@�C����tsrenamec�Œ��o���������ǖ��ɍ��v�����t�@�C�����������̂ɂȂ�܂��̂ŁA�������ɋC��t���Ă�������
set lgd_file_counter=0
for /f "usebackq delims=" %%B in (`%tsrenamec_path% "%~1" @CH`) do (
    call :set_broadcaster_name_phase %%B
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
rem # �֋X�I�ɍŏ��Ɍ��������t�@�C�������C���̃��S�t�@�C���Ƃ��Ďg�p���܂��B
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

rem echo �f�C���^�[���[�X�t�B���^�ݒ�̋[���֐�
:deinterlace_filter_phase
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
) else if %src_video_hight_pixel% leq %bat_vresize_flag% (
    echo ���\�[�X�r�f�I�̏c�𑜓x�����T�C�Y�w��ȉ��ׁ̈A���T�C�Y���������{���܂���
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
    set TsSplitter_flag=0
    set video_format_type=HD
    call :1080input_edit_selector
    exit /b
) else if "%choice%"=="2" (
    rem 2. 720�~480i(16:9) �\�[�X
    set TsSplitter_flag=0
    set video_format_type=SD
    set avs_filter_type=480p_template
    set src_video_wide_pixel=720
    set Crop_size_flag=none
    set videoAspectratio_option=video_par40x33_option
    exit /b
) else if "%choice%"=="3" (
    rem 3. 720�~480i(4:3)  �\�[�X
    set TsSplitter_flag=0
    set video_format_type=SD
    set avs_filter_type=480p_template
    set src_video_wide_pixel=720
    set Crop_size_flag=none
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
echo ### TsSplitter�ŕ�����̃t�@�C�����̖����ɂ���������w�肵�Ă������� ###
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
rem # 1080i���͂̏ꍇ�ɁA�ǂ̂悤�ɕҏW���邩�̋[���֐�
rem # ������--sar�I�v�V�����̃t���O������(1080p�̏ꍇ�͂��̎���)
echo.
echo ### �ǂ̂悤�ɕҏW���܂����H ###
echo 1.  �t�����C�h �� 1080 �o��
echo 2.  �t�����C�h �� 720  �o��
echo 3.  �t�����C�h �� 540  �o��
echo 4.  �t�����C�h �� 16:9 480�o��
echo 5. �T�C�h�J�b�g�� 4:3  480�o��
echo 6.    ���z��   �� 16:9 480�o��
echo 7.  �t�����C�h �� PSP(270p)�o��
echo 8. �T�C�h�J�b�g�� PSP(270p)�o��
echo 9.    ���z��   �� PSP(270p)�o��
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="" (
    echo �I�����Ă��������I
    goto :1080input_edit_selector
) else if "%choice%"=="1" (
    rem 1.  �t�����C�h �� 1080 �o��
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
    rem 2.  �t�����C�h �� 720  �o��
    set avs_filter_type=720p_template
    set Crop_size_flag=none
    set videoAspectratio_option=video_par1x1_option
    exit /b
) else if "%choice%"=="3" (
    rem 3.  �t�����C�h �� 540  �o��
    set avs_filter_type=540p_template
    set Crop_size_flag=none
    set videoAspectratio_option=video_par1x1_option
    exit /b
) else if "%choice%"=="4" (
    rem 4.  �t�����C�h �� 16:9 480�o��
    set avs_filter_type=480p_template
    set Crop_size_flag=none
    set videoAspectratio_option=video_par40x33_option
    exit /b
) else if "%choice%"=="5" (
    rem 5. �T�C�h�J�b�g�� 4:3  480�o��
    set avs_filter_type=480p_template
    set Crop_size_flag=sidecut
    set videoAspectratio_option=video_par10x11_option
    if "%src_video_wide_pixel%"=="" (
        call :HDvideo_wideselector
    )
    exit /b
) else if "%choice%"=="6" (
    rem 6.    ���z��   �� 16:9 480�o��
    set avs_filter_type=480p_template
    set Crop_size_flag=gakubuchi
    set videoAspectratio_option=video_par40x33_option
    if "%src_video_wide_pixel%"=="" (
        call :HDvideo_wideselector
    )
    exit /b
) else if "%choice%"=="7" (
    rem 7.  �t�����C�h �� PSP(270p)�o��
    set avs_filter_type=272p_template
    set Crop_size_flag=none
    set videoAspectratio_option=video_par1x1_option
    exit /b
) else if "%choice%"=="8" (
    rem 8. �T�C�h�J�b�g�� PSP(270p)�o��
    set avs_filter_type=PSP_square_template
    set Crop_size_flag=sidecut
    set videoAspectratio_option=video_par1x1_option
    if "%src_video_wide_pixel%"=="" (
        call :HDvideo_wideselector
    )
    exit /b
) else if "%choice%"=="9" (
    rem 9.    ���z��   �� PSP(270p)�o��
    set avs_filter_type=272p_template
    set Crop_size_flag=gakubuchi
    set videoAspectratio_option=video_par1x1_option
    if "%src_video_wide_pixel%"=="" (
        call :HDvideo_wideselector
    )
    exit /b
) else (
    rem �s���ȓ���
    echo �������l��I�����Ă��������I
    goto :1080input_edit_selector
)
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
    )
) else if "%choice%"=="2" (
    set src_video_wide_pixel=1920
    if "%avs_filter_type%"=="1080p_template" (
        set videoAspectratio_option=video_par1x1_option
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

:NR_filter_selector
rem # �m�C�Y���_�N�V�����t�B���^�̑I��
echo.
echo ### �g�p����m�C�Y�����t�B���^��I�����Ă������� ###
echo 1. �h�b�g�W�Q/�N���X�J���[����
echo 2. �����M���O����
echo 3. �h�b�g�W�Q�N���X�J���[�����{�����M���O����
echo 0. �Ȃ�
set choice=
set /p choice=Type the number to print text.
if "%choice%"=="" (
    echo �I�����Ă��������I
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


:make_avsplugin_phase
rem # �v���O�C���ǂݍ��ݕ���
if "%importloardpluguin_flag%"=="1" (
    copy "%plugin_template%" "%work_dir%%main_project_name%\avs\LoadPlugin.avs"
    echo ##### �v���O�C���ǂݍ��ݕ����̃C���|�[�g #####>> "%work_dir%%main_project_name%\main.avs"
    echo Import^(".\avs\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\main.avs"
    echo.>> "%work_dir%%main_project_name%\main.avs"
) else (
    copy /b "%work_dir%%main_project_name%\main.avs" + "%plugin_template%" "%work_dir%%main_project_name%\main.avs"
    echo.>>"%work_dir%%main_project_name%\main.avs"
)
rem # �\�[�X���͑O�̃t�B���^�Q
copy /b "%work_dir%%main_project_name%\main.avs" + "%load_source%" "%work_dir%%main_project_name%\main.avs"
echo.>>"%work_dir%%main_project_name%\main.avs"
exit /b


:make_previewfile_phase
rem ### ���[�U�[�̓��͂����ݒ�ɂ���������avs�t�@�C�����쐬����[���֐�
rem %work_dir%%main_project_name%�ɃX�N���v�g���쐬���܂�
echo.
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
echo ##### �J�b�g�ҏW #####>> "%work_dir%%main_project_name%\preview1_straight.avs"
rem # �ȉ��̃C���|�[�g���t�@�C����Trim�����L�����Ă�������
echo #Import^("trim_line.txt"^)>> "%work_dir%%main_project_name%\preview1_straight.avs"
echo.>> "%work_dir%%main_project_name%\preview1_straight.avs"
rem ----------
echo ##### �J�b�g�ҏW #####>> "%work_dir%%main_project_name%\preview2_trimed.avs"
rem # �ȉ��̃C���|�[�g���t�@�C����Trim�����L�����Ă�������
echo Import^("trim_line.txt"^)>> "%work_dir%%main_project_name%\preview2_trimed.avs"
echo.>> "%work_dir%%main_project_name%\preview2_trimed.avs"
rem ----------
echo ##### �J�b�g�ҏW #####>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
rem # �ȉ��̃C���|�[�g���t�@�C����Trim�����L�����Ă�������
echo Import^("trim_line.txt"^)>> "%work_dir%%main_project_name%\preview3_anticomb.avs"
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
echo Import^("trim_line.txt"^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
rem echo Import^("trim_multi.txt"^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo.>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo ##### �v���r���[�p�t�B���^ #####>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo Its^(opt=1, def=".\main.def", fps=-1, debug=false, output="", chapter=""^)>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
echo.>> "%work_dir%%main_project_name%\preview4_deinterlace.avs"
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
echo ##### �ҏW����͂̂��߂�AVS #####> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #//--- �v���O�C���ǂݍ��ݕ����̃C���|�[�g ---//>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo Import^(".\LoadPlugin.avs"^)>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo.>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #//--- �\�[�X�̓ǂݍ��� ---//>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
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
echo #//--- �t�B�[���h�I�[�_�[ ---//>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #AssumeFrameBased^(^).ComplementParity^(^)    #�g�b�v�t�B�[���h���x�z�I>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #AssumeFrameBased^(^)            #�{�g���t�B�[���h���x�z�I>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #AssumeTFF^(^)                #�g�b�v�t�@�[�X�g>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #AssumeBFF^(^)                #�{�g���t�@�[�X�g>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo.>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #//--- Trim���C���|�[�g ---//>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo Import^("..\trim_chars.txt"^)>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo.>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
echo #//--- �F��ԕύX^(���S��ׂ͂̈�YV12�K�{^) ---//>> "%work_dir%%main_project_name%\avs\edit_analyze.avs"
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
rem # �����߃��S�����֐�AVS�t�@�C���쐬�A���g��logoframe���s���ɏ㏑��
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
    echo ColorMatrix^(mode="Rec.709->Rec.601", interlaced=true^)    #BT.709����BT.601�֕ϊ�>> "%work_dir%%main_project_name%\main.avs"
    echo.>> "%work_dir%%main_project_name%\main.avs"
)
exit /b

:avs_interlacemain_phase
copy /b "%work_dir%%main_project_name%\main.avs" + "%deinterlace_filter_template%" "%work_dir%%main_project_name%\main.avs"
exit /b

:crop_filter_phase
if "%Crop_size_flag%"=="sidecut" (
    if "%src_video_wide_pixel%"=="1920" (
        echo Crop^(240, 0, -240, -0^)    #�N���b�s���O^(��, ��, -�E, -��^)>> "%work_dir%%main_project_name%\main.avs"
    ) else if "%src_video_wide_pixel%"=="720" (
        echo Crop^(96, 0, -96, -0^)    #�N���b�s���O^(��, ��, -�E, -��^)>> "%work_dir%%main_project_name%\main.avs"
    ) else (
        echo Crop^(180, 0, -180, -0^)    #�N���b�s���O^(��, ��, -�E, -��^)>> "%work_dir%%main_project_name%\main.avs"
    )
) else if "%Crop_size_flag%"=="gakubuchi" (
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
        echo AddBorders^(8,0,8,0^)    #���ѕt��>> "%work_dir%%main_project_name%\main.avs"
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
echo #gradfun2db^(^)    #�o���f�B���O�����t�B���^�E�v���O�C��>>"%work_dir%%main_project_name%\main.avs"
exit /b

:ItsCut_filter_phase
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
rem # ���C���o�b�`�t�@�C���̍쐬�A%calling_bat_file%����`����Ă���ꍇ�A�v���W�F�N�g�f�B���N�g��
rem # �ȉ���AVS�Ɠ����̃��C���o�b�`�t�@�C�����쐬�������%calling_bat_file%���Ăяo���`���Aset���T�u���[�`����
set main_bat_file=%work_dir%%main_project_name%\main.bat
if not exist "%main_bat_file%" (
    echo ���C���o�b�`�t�@�C�����Ȃ��̂ō쐬���܂�...
    type nul > "%main_bat_file%"
    echo @echo off>> "%main_bat_file%"
    echo setlocal>> "%main_bat_file%"
    rem echo echo �J�n����[%%time%%]>> "%main_bat_file%"
) else (
    if "%calling_bat_file%"=="" (
        rem %calling_bat_file%���g�p�����A�����Ƀ��C���o�b�`�t�@�C�������݂��Ă���ꍇ
        rem �ۗ����E�E�E
        exit /b
    ) else (
        echo ���Ƀo�b�`�t�@�C�������݂��Ă��܂��B���O��ύX���V�K�ɍ쐬���܂��B
        rename "%main_bat_file%" "backup%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%_main.bat"
        type nul > "%main_bat_file%"
        echo @echo off>> "%main_bat_file%"
        echo setlocal>> "%main_bat_file%"
        rem echo echo �J�n����[%%time%%]>> "%main_bat_file%"
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
echo echo ### %main_project_name% �̃G���R�[�h[%%time%%] ###>> "%main_bat_file%"
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
rem ### �w�肵���h���C�u�̃��f�B�A�^�C�v�𔻕ʂ��邽�߂�VB�X�N���v�g�A�\�[�X�t�@�C�������[�J��HDD�h���C�u�ɂ��邩�m�F�p
echo WScript.Echo CStr^(CreateObject^("Scripting.FileSystemObject"^).GetDrive^(WScript.Arguments^(0^)^).DriveType^)> "%work_dir%%main_project_name%\bat\media_check.vbs"
rem ### TS�\�[�X���R�s�[����[���֐��ATsSplitter�ɂ�鏈��������
type nul > "%copysrc_batfile_path%"
echo @echo off>> "%copysrc_batfile_path%"
echo setlocal>> "%copysrc_batfile_path%"
echo echo start %%~nx0 bat job...>> "%copysrc_batfile_path%"
echo chdir /d %%~dp0..\>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
echo rem # �g�p����R�s�[�A�v���P�[�V������I�����܂�>> "%copysrc_batfile_path%"
echo call :copy_app_detect>> "%copysrc_batfile_path%"
echo rem copy^(Default^), fac^(FastCopy^), ffc^(FireFileCopy^)>> "%copysrc_batfile_path%"
echo rem set copy_app_flag=%copy_app_flag%>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
echo echo �\�[�X�����[�J���ɃR�s�[���Ă��܂�. . .[%%time%%]>> "%copysrc_batfile_path%"
echo rem # %%large_tmp_dir%% �̑��݊m�F����і����`�F�b�N>> "%copysrc_batfile_path%"
echo if not exist "%%large_tmp_dir%%" ^(>> "%copysrc_batfile_path%"
echo     echo �傫�ȃt�@�C�����o�͂���ꎞ�t�H���_ %%%%large_tmp_dir%%%% �����݂��܂���A����ɃV�X�e���̃e���|�����t�H���_�ő�p���܂��B>> "%copysrc_batfile_path%"
echo     set large_tmp_dir=%%tmp%%>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\>> "%copysrc_batfile_path%"
echo rem # �G���R�[�h�c�[�����܂Ƃ߂��f�B���N�g�����������ϐ�ENCTOOLSROOTPATH����`����Ă��邩�m�F>> "%copysrc_batfile_path%"
echo call :toolsdircheck>> "%copysrc_batfile_path%"
echo rem # parameter�t�@�C�����̃\�[�X�t�@�C���ւ̃t���p�X^(src_file_path^)�����o>> "%copysrc_batfile_path%"
echo call :src_file_path_check>> "%copysrc_batfile_path%"
echo rem # ���o�����\�[�X�t�@�C���ւ̃t���p�X�̒�����t�@�C����^(src_file_name^)�̕����݂̂𒊏o>> "%copysrc_batfile_path%"
echo call :src_file_name_extraction "%%src_file_path%%">> "%copysrc_batfile_path%"
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o>> "%copysrc_batfile_path%"
echo call :project_name_check>> "%copysrc_batfile_path%"
echo rem # parameter�t�@�C������MPEG-2�f�R�[�_�[�^�C�v^(mpeg2dec_select_flag^)�����o>> "%copysrc_batfile_path%"
echo call :mpeg2dec_select_flag_check>> "%copysrc_batfile_path%"
echo rem # parameter�t�@�C�����̋����R�s�[�t���O^(force_copy_src^)�����o>> "%copysrc_batfile_path%"
echo call :force_src_copy_check>> "%copysrc_batfile_path%"
echo rem # �\�[�X���f�B�A���^(src_media_type^)�����o>> "%copysrc_batfile_path%"
echo call :src_media_type_check "%%src_file_path%%">> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
echo rem # �e���s�t�@�C�������݂��邩�m�F�B���݂��Ȃ��ꍇENCTOOLSROOTPATH������T������A�������̓V�X�e���̒T���p�X�Ɉς˂�>> "%copysrc_batfile_path%"
echo rem # ����ł�������Ȃ��ꍇ�A�R�}���h�v�����v�g�W����copy�R�}���h���g�p����>> "%copysrc_batfile_path%"
echo if exist "%ffc_path%" ^(set ffc_path=%ffc_path%^) else ^(call :find_ffc "%ffc_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%fac_path%" ^(set fac_path=%fac_path%^) else ^(call :find_fac "%fac_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%ts2aac_path%" ^(set ts2aac_path=%ts2aac_path%^) else ^(call :find_ts2aac "%ts2aac_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%ts_parser_path%" ^(set ts_parser_path=%ts_parser_path%^) else ^(call :find_ts_parser "%ts_parser_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%faad_path%" ^(set faad_path=%faad_path%^) else ^(call :find_faad "%faad_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%FAW_path%" ^(set FAW_path=%FAW_path%^) else ^(call :find_FAW "%FAW_path%"^)>> "%copysrc_batfile_path%"
echo if exist "%TsSplitter_path%" ^(set TsSplitter_path=%TsSplitter_path%^) else ^(call :find_TsSplitter "%TsSplitter_path%"^)>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
echo rem # �e����s�t�@�C���ւ̃p�X���A�ŏI�I�ɂǂ̂悤�Ȓl�ɂȂ������m�F�B>> "%copysrc_batfile_path%"
echo echo FireFileCopy: %%ffc_path%%>> "%copysrc_batfile_path%"
echo echo FastCopy    : %%fac_path%%>> "%copysrc_batfile_path%"
echo echo ts2aac      : %%ts2aac_path%%>> "%copysrc_batfile_path%"
echo echo ts_parser   : %%ts_parser_path%%>> "%copysrc_batfile_path%"
echo echo faad        : %%faad_path%%>> "%copysrc_batfile_path%"
echo echo FakeAacWav  : %%FAW_path%%>> "%copysrc_batfile_path%"
echo echo TsSplitter  : %%TsSplitter_path%%>> "%copysrc_batfile_path%"
echo echo.>> "%copysrc_batfile_path%"
echo rem # �e������>> "%copysrc_batfile_path%"
echo echo �\�[�X�t�@�C���ւ̃t���p�X: %%src_file_path%%>> "%copysrc_batfile_path%"
echo echo �\�[�X�t�@�C����  �F %%src_file_name%%>> "%copysrc_batfile_path%"
echo echo �v���W�F�N�g��    �F %%project_name%%>> "%copysrc_batfile_path%"
echo echo �R�s�[�\�[�X�t���O : %%force_copy_src%%>> "%copysrc_batfile_path%"
echo echo �@0: �\�[�X���l�b�g���[�N�t�H���_�̏ꍇ�̂݃R�s�[>> "%copysrc_batfile_path%"
echo echo �@1: �\�[�X�̃��f�B�A�^�C�v�Ɋ֌W�Ȃ��R�s�[>> "%copysrc_batfile_path%"
echo echo �\�[�X���f�B�A��� : %%src_media_type%%>> "%copysrc_batfile_path%"
echo echo �@1�F�����[�o�u���h���C�u^(USB������/SD�J�[�h/FD�Ȃ�^)>> "%copysrc_batfile_path%"
echo echo �@2�FHDD>> "%copysrc_batfile_path%"
echo echo �@3�F�l�b�g���[�N�h���C�u>> "%copysrc_batfile_path%"
echo echo �@4�FCD-ROM/CD-R/DVD-ROM/DVD-R�Ȃ�>> "%copysrc_batfile_path%"
echo echo �@5�FRAM�f�B�X�N>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
echo :main>> "%copysrc_batfile_path%"
echo rem //----- main�J�n -----//>> "%copysrc_batfile_path%"
echo title %%project_name%%>> "%copysrc_batfile_path%"
echo if not exist ".\src\video*%~x1" ^(>> "%copysrc_batfile_path%"
echo     if not exist "%%src_file_path%%" ^(>> "%copysrc_batfile_path%"
echo         echo �\�[�X�t�@�C����������Ȃ��׏����𑱍s�ł��܂���A���f���܂�>> "%copysrc_batfile_path%"
echo         exit /b>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo     if "%%force_copy_src%%"=="1" ^(>> "%copysrc_batfile_path%"
echo         echo �����R�s�[�t���O���L���ȈׁA�\�[�X�����[�J���t�H���_�Ɉꎞ�R�s�[���܂�>> "%copysrc_batfile_path%"
echo         call :copy_src_phase>> "%copysrc_batfile_path%"
echo     ^) else ^(>> "%copysrc_batfile_path%"
echo         if not "%%src_media_type%%"=="2" ^(>> "%copysrc_batfile_path%"
echo             echo �\�[�X�t�@�C�����L�^����Ă��郁�f�B�A�����[�J��HDD�ȊO�ׁ̈A�ꎞ�R�s�[���܂�>> "%copysrc_batfile_path%"
echo             call :copy_src_phase>> "%copysrc_batfile_path%"
echo         ^) else ^(>> "%copysrc_batfile_path%"
echo             echo �\�[�X�t�@�C�����L�^����Ă��郁�f�B�A�����[�J��HDD�ł��A�V���{���b�N�����N�̍쐬�����݂܂�>> "%copysrc_batfile_path%"
echo             call :mklink_src_phase>> "%copysrc_batfile_path%"
echo         ^)>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo �T�u�f�B���N�g���Ɋ��Ƀ\�[�X�t�@�C�������݂��邽�߃R�s�[�͎��{���܂���>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo if exist ".\src\video.ts" ^(>> "%copysrc_batfile_path%"
echo     set input_media_path=.\src\video.ts>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     call :set_input_media_to_src>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
echo set src_tsfile_counter=^0>> "%copysrc_batfile_path%"
echo set type-count=>> "%copysrc_batfile_path%"
echo rem # AAC�����t�@�C���̕���>> "%copysrc_batfile_path%"
echo call :ext_aac_audio_phase "%%input_media_path%%">> "%copysrc_batfile_path%"
echo rem # WAV�f�R�[�h^(�v���r���[��CM�J�b�g�Ɏg�p^)>> "%copysrc_batfile_path%"
echo call :wav_decode_audio_phase %%aac_audio_source%%>> "%copysrc_batfile_path%"
echo rem # FAW�t�@�C���o��>> "%copysrc_batfile_path%"
echo call :ext_faw_audio_phase %%aac_audio_source%%>> "%copysrc_batfile_path%"
echo del %%aac_audio_source%%>> "%copysrc_batfile_path%"
echo title �R�}���h �v�����v�g>> "%copysrc_batfile_path%"
echo rem //----- main�I�� -----//>> "%copysrc_batfile_path%"
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
echo         echo FastCopy �ŃR�s�[�����s���܂�>> "%copysrc_batfile_path%"
echo         "%%fac_path%%" /cmd=diff /force_close /disk_mode=auto "%%src_file_path%%" /to="%copy_to_path%">> "%copysrc_batfile_path%"
echo     ^) else ^(>> "%copysrc_batfile_path%"
echo         set copy_app_flag=copy>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo ^) else if "%%copy_app_flag%%"=="ffc" ^(>> "%copysrc_batfile_path%"
echo     if exist "%%ffc_path%%" ^(>> "%copysrc_batfile_path%"
echo         echo FireFileCopy �ŃR�s�[�����s���܂�>> "%copysrc_batfile_path%"
echo         "%%ffc_path%%" "%%src_file_path%%" /copy /a /bg /md /nk /ys /to:"%copy_to_path%">> "%copysrc_batfile_path%"
echo     ^) else ^(>> "%copysrc_batfile_path%"
echo         set copy_app_flag=copy>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo if "%%copy_app_flag%%"=="copy" ^(>> "%copysrc_batfile_path%"
echo     echo �R�}���h�v�����v�g�W����copy�R�}���h�ŃR�s�[�����s���܂�>> "%copysrc_batfile_path%"
echo     copy /z "%%src_file_path%%" "%copy_to_path%">> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo %tssp_comment_flag%"%%TsSplitter_path%%" -EIT -ECM -EMM -1SEG -OUT ".\src" "%copy_to_path%%%src_file_name%%">> "%copysrc_batfile_path%"
echo %rename_src_flag%move "%copy_to_path%%%src_file_name%%" ".\src\video%~x1"^> nul>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :mklink_src_phase>> "%copysrc_batfile_path%"
echo rem # ver�R�}���h�̏o�͌��ʂ��m�F���AWindowsXP�ȑO��OS�̏ꍇ�̓V���{���b�N�����N���g���Ȃ��̂ő����copy�����s���܂��B>> "%copysrc_batfile_path%"
echo for /f "tokens=2 usebackq delims=[]" %%%%W in ^(`ver`^) do ^(>> "%copysrc_batfile_path%"
echo     set os_version=%%%%W>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo echo OS %%os_version%%>> "%copysrc_batfile_path%"
echo for /f "tokens=2 usebackq delims=. " %%%%V in ^(`echo %%os_version%%`^) do ^(>> "%copysrc_batfile_path%"
echo     set major_version=%%%%V>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo if %%major_version%% leq 5 ^(>> "%copysrc_batfile_path%"
echo     echo ���s����WindowsXP�ȑO��OS�̈׃V���{���b�N�����N���g���܂���B�����copy���������s���܂��B>> "%copysrc_batfile_path%"
echo     call :copy_src_phase>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo �\�[�X�t�@�C���̃V���{���b�N�����N���쐬���܂��B>> "%copysrc_batfile_path%"
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
echo echo HD�T�C�Y�t�@�C���̈ꗗ>> "%copysrc_batfile_path%"
echo set tssplitter_HD_counter=^0>> "%copysrc_batfile_path%"
echo for /f "delims=" %%%%F in ^('dir /b ".\src\video_HD*.ts"'^) do ^(>> "%copysrc_batfile_path%"
echo     echo %%%%F>> "%copysrc_batfile_path%"
echo     set /a tssplitter_HD_counter=tssplitter_HD_counter+1>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo echo SD�T�C�Y�t�@�C���̈ꗗ>> "%copysrc_batfile_path%"
echo set tssplitter_SD_counter=^0>> "%copysrc_batfile_path%"
echo for /f "delims=" %%%%F in ^('dir /b ".\src\video_SD*.ts"'^) do ^(>> "%copysrc_batfile_path%"
echo     echo %%%%F>> "%copysrc_batfile_path%"
echo     set /a tssplitter_SD_counter=tssplitter_SD_counter+1>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo rem # �����A�ԂƊ�A�Ԃ̃t�@�C�����e�ʂ��r���A�傫�����̃O���[�v���㑱�̏����ΏۂƂ���B>> "%copysrc_batfile_path%"
echo rem # Windows�̃o�b�`�t�@�C���� 2147483647 �܂ł̒l�����v�Z�ł��Ȃ��̂ŁAMB�T�C�Y�Ɋۂߍ���Ōv�Z����B>> "%copysrc_batfile_path%"
echo rem # �����ԃt�@�C�����J�E���g^(even^)>> "%copysrc_batfile_path%"
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
echo echo �����ԃg�[�^���t�@�C���T�C�Y^(MB^)�F%%HD_even_total_filesize%%>> "%copysrc_batfile_path%"
echo rem # ��ԃt�@�C�����J�E���g^(odd^)>> "%copysrc_batfile_path%"
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
echo echo ��ԃg�[�^���t�@�C���T�C�Y^(MB^)�F%%HD_odd_total_filesize%%>> "%copysrc_batfile_path%"
echo rem # �t�@�C�����e�ʂ��r>> "%copysrc_batfile_path%"
echo if %%HD_odd_total_filesize%% geq %%HD_even_total_filesize%% ^(>> "%copysrc_batfile_path%"
echo     echo ��Ԃ̃g�[�^���t�@�C���T�C�Y���傫���ł��B�ȍ~�̏����͂��̃O���[�v�ɑ΂��čs���܂��B>> "%copysrc_batfile_path%"
echo     call :HD_odd_retry_phase>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo �����Ԃ̃g�[�^���t�@�C���T�C�Y���傫���ł��B�ȍ~�̏����͂��̃O���[�v�ɑ΂��čs���܂��B>> "%copysrc_batfile_path%"
echo     call :HD_even_retry_phase>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :filesize_calc_even>> "%copysrc_batfile_path%"
echo rem # �����ԃt�@�C���T�C�Y�v�Z>> "%copysrc_batfile_path%"
echo set /a HD_even_total_filesize=HD_even_total_filesize+%%~z1/1024/1024>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :filesize_calc_odd>> "%copysrc_batfile_path%"
echo rem # ��ԃt�@�C���T�C�Y�v�Z>> "%copysrc_batfile_path%"
echo set /a HD_odd_total_filesize=HD_odd_total_filesize+%%~z1/1024/1024>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :HD_even_retry_phase>> "%copysrc_batfile_path%"
echo rem # �����Ԃ̊e�t�@�C�����ƂɃI�[�f�B�I�������J��Ԃ��܂�>> "%copysrc_batfile_path%"
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
echo rem # ��Ԃ̊e�t�@�C�����ƂɃI�[�f�B�I�������J��Ԃ��܂�>> "%copysrc_batfile_path%"
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
echo echo AAC�������o %%type-count%%...[%%time%%]>> "%copysrc_batfile_path%"
echo set aac_audio_source=>> "%copysrc_batfile_path%"
echo set aac_audio_delay=>> "%copysrc_batfile_path%"
echo if "%%mpeg2dec_select_flag%%"=="1" ^(>> "%copysrc_batfile_path%"
echo     echo # MPEG-2�f�R�[�_�[�� MPEG2 VFAPI Plug-In ���g�p���܂�>> "%copysrc_batfile_path%"
echo     rem echo "%%ts2aac_path%%" -D -i "%%~1" -o "%%large_tmp_dir%%%%project_name%%">> "%copysrc_batfile_path%"
echo     rem "%%ts2aac_path%%" -D -i "%%~1" -o "%%large_tmp_dir%%%%project_name%%"^>^> ".\log\demuxed-aac_log.log">> "%copysrc_batfile_path%"
echo     echo "%%ts_parser_path%%" --mode da --delay-type 1 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1">> "%copysrc_batfile_path%"
echo     "%%ts_parser_path%%" --mode da --delay-type 1 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1"^>^> ".\log\demuxed-aac_log.log">> "%copysrc_batfile_path%"
echo ^) else if "%%mpeg2dec_select_flag%%"=="2" ^(>> "%copysrc_batfile_path%"
echo     echo # MPEG-2�f�R�[�_�[�� DGIndex ���g�p���܂�>> "%copysrc_batfile_path%"
echo     echo "%%ts_parser_path%%" --mode da --delay-type 2 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1">> "%copysrc_batfile_path%"
echo     "%%ts_parser_path%%" --mode da --delay-type 2 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1"^>^> ".\log\demuxed-aac_log.log">> "%copysrc_batfile_path%"
echo ^) else if "%%mpeg2dec_select_flag%%"=="3" ^(>> "%copysrc_batfile_path%"
echo     echo # MPEG-2�f�R�[�_�[�� L-SMASH Works ���g�p���܂�>> "%copysrc_batfile_path%"
echo     echo "%%ts_parser_path%%" --mode da --delay-type 3 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1">> "%copysrc_batfile_path%"
echo     "%%ts_parser_path%%" --mode da --delay-type 3 --rb-size 4096 --wb-size 8192 --debug 1 -o "%%large_tmp_dir%%%%project_name%%" "%%~1"^>^> ".\log\demuxed-aac_log.log">> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo type ".\log\demuxed-aac_log.log">> "%copysrc_batfile_path%"
echo for /f "delims=" %%^%%A in ^('dir /b "%%large_tmp_dir%%%%project_name%%*DELAY *ms.aac"'^) do ^(>> "%copysrc_batfile_path%"
echo     set aac_audio_source="%%large_tmp_dir%%%%%%A">> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo echo �I�[�f�B�I�\�[�X�F%%aac_audio_source%%>> "%copysrc_batfile_path%"
echo set aac_audio_delay=%%aac_audio_source%%>> "%copysrc_batfile_path%"
echo set aac_audio_delay=%%aac_audio_delay:^"=%%>> "%copysrc_batfile_path%"
echo set aac_audio_delay=%%aac_audio_delay:*DELAY =%%>> "%copysrc_batfile_path%"
echo set aac_audio_delay=%%aac_audio_delay:ms.aac=%%>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :wav_decode_audio_phase>> "%copysrc_batfile_path%"
echo rem # faad����-D��delay�������o��������ł��O��>> "%copysrc_batfile_path%"
echo rem # faad�̃I�v�V�����ɂ���āA�����`�����l�����؂�ւ�����ꍇ�͕����̃t�@�C�����o�͂���܂�>> "%copysrc_batfile_path%"
echo echo WAV�f�R�[�h %%type-count%%...[%%time%%]>> "%copysrc_batfile_path%"
rem # FAAD ������ 0.4�ŁADELAY���܂܂�Ă���ƂȂ���-o�I�v�V�������������ꂵ�܂����̉��
rem # set�R�}���h���ŃA�X�^���X�N���g����̂́A������1�̐擪�݂̂̂悤�ł��B
rem # ���Q�l http://questionbox.jp.msn.com/qa2638625.html
rem # 2010/11/28 �ǋL
rem # ���Ȃ��Ƃ�������0.6�ł͏�L�̏Ǐ�͎����Ă���͗l�B�O�̂��߃R�����g�A�E�g�Ƃ��Ďc���Ă���
rem echo for /f "delims=" %%%%W in ('dir /b "%%large_tmp_dir%%%main_project_name%*DELAY 0ms.wav"') do (>> "%copysrc_batfile_path%"
rem echo     set outputwav_path="%%large_tmp_dir%%%%%%W">> "%copysrc_batfile_path%"
rem echo )>> "%copysrc_batfile_path%"
rem echo if not exist "%%~dp0src\audio_pcm.wav" (>> "%copysrc_batfile_path%"
rem echo     if exist "%%outputwav_path%%" (>> "%copysrc_batfile_path%"
rem echo         move /Y "%%outputwav_path%%" "%%~dp0src\audio_pcm.wav">> "%copysrc_batfile_path%"
rem echo     )>> "%copysrc_batfile_path%"
rem echo )>> "%copysrc_batfile_path%"
if "%kill_longecho_flag%"=="1" (
    rem echo start "FAAD�f�R�[�h��..." /wait "%faad_path%" -d -o ".\src\audio_pcm.wav" "%%~1">> "%copysrc_batfile_path%"
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
echo echo �o�͂��ꂽPCM�t�@�C�����A�����`�����l���ŕ�������Ă��Ȃ����J�E���g���܂�>> "%copysrc_batfile_path%"
echo echo �����Ώۃt�@�C���F ".\src\audio_pcm[*].wav">> "%copysrc_batfile_path%"
echo for /f "delims=" %%%%T in ^('dir /b ".\src\audio_pcm[*].wav"'^) do ^(>> "%copysrc_batfile_path%"
echo     echo ���o�t�@�C���F%%%%T>> "%copysrc_batfile_path%"
echo     set /a faad_outfile_counter=faad_outfile_counter+1>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo if not "%%faad_outfile_counter%%"=="0" ^(>> "%copysrc_batfile_path%"
echo     echo faad�ɂ���ďo�͂��ꂽ�t�@�C�����������o����܂����B>> "%copysrc_batfile_path%"
echo     echo �����`�����l���̐؂�ւ�肪�������Ă��邽�ߌ���TS�t�@�C����TsSplitter�ŕ������Ȃ����K�v������܂��B>> "%copysrc_batfile_path%"
echo     echo PCM�����t�@�C������U�폜>> "%copysrc_batfile_path%"
echo     del ".\src\audio_pcm*.wav">> "%copysrc_batfile_path%"
echo     call :TsSplitter_src_retry_phase>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo �����`�����l���̐؂�ւ��͌��o����܂���ł����B���̂܂܏����𑱍s���܂��B>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :ext_faw_audio_phase>> "%copysrc_batfile_path%"
echo echo FAW���o %%type-count%%...[%%time%%]>> "%copysrc_batfile_path%"
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
echo     echo �R�s�[�p�A�v���̃p�����[�^�[��������܂���A�f�t�H���g��copy�R�}���h���g�p���܂��B>> "%copysrc_batfile_path%"
echo     set copy_app_flag=copy>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :toolsdircheck>> "%copysrc_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%copysrc_batfile_path%"
echo     echo ���ϐ� ENCTOOLSROOTPATH ������`�ł�>> "%copysrc_batfile_path%"
echo     exit /b>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\>> "%copysrc_batfile_path%"
echo if exist "%%ENCTOOLSROOTPATH%%" ^(>> "%copysrc_batfile_path%"
echo     exit /b>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo ���ϐ�ENCTOOLSROOTPATH���L���ȃp�X�ł͂���܂���>> "%copysrc_batfile_path%"
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
echo     echo ��MPEG-2�f�R�[�_�[�̎w�肪������܂���, MPEG2 VFAPI Plug-In���g�p���܂�>> "%copysrc_batfile_path%"
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
echo     echo �\�[�X�t�@�C���ւ̃p�X��UNC�ׁ̈A�l�b�g���[�N�h���C�u�Ƃ��ď������܂�>> "%copysrc_batfile_path%"
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
echo echo findexe�����F"%%~1">> "%copysrc_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%copysrc_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%copysrc_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%copysrc_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%copysrc_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%copysrc_batfile_path%"
echo         echo ������܂���>> "%copysrc_batfile_path%"
echo         set ffc_path=%%%%~E>> "%copysrc_batfile_path%"
echo         exit /b>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo call :ffc_env_search %%~nx1>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo :ffc_env_search>> "%copysrc_batfile_path%"
echo set ffc_path=%%~$PATH:1>> "%copysrc_batfile_path%"
echo if "%%ffc_path%%"=="" echo FireFileCopy��������܂���A����ɃR�}���h�v�����v�g�W����copy�R�}���h���g�p���܂��B>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :find_fac>> "%copysrc_batfile_path%"
echo echo findexe�����F"%%~1">> "%copysrc_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%copysrc_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%copysrc_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%copysrc_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%copysrc_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%copysrc_batfile_path%"
echo         echo ������܂���>> "%copysrc_batfile_path%"
echo         set fac_path=%%%%~E>> "%copysrc_batfile_path%"
echo         exit /b>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo call :fac_env_search %%~nx1>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo :fac_env_search>> "%copysrc_batfile_path%"
echo set fac_path=%%~$PATH:1>> "%copysrc_batfile_path%"
echo if "%%fac_path%%"=="" echo FastCopy��������܂���A����ɃR�}���h�v�����v�g�W����copy�R�}���h���g�p���܂��B>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :find_ts2aac>> "%copysrc_batfile_path%"
echo echo findexe�����F"%%~1">> "%copysrc_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%copysrc_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%copysrc_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%copysrc_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%copysrc_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%copysrc_batfile_path%"
echo         echo ������܂���>> "%copysrc_batfile_path%"
echo         set ts2aac_path=%%%%~E>> "%copysrc_batfile_path%"
echo         exit /b>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo call :ts2aac_env_search %%~nx1>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo :ts2aac_env_search>> "%copysrc_batfile_path%"
echo set ts2aac_path=%%~$PATH:1>> "%copysrc_batfile_path%"
echo if "%%ts2aac_path%%"=="" ^(>> "%copysrc_batfile_path%"
echo     echo ts2aac��������܂���B>> "%copysrc_batfile_path%"
echo     set ts2aac_path=%%~1>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :find_ts_parser>> "%copysrc_batfile_path%"
echo echo findexe�����F"%%~1">> "%copysrc_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%copysrc_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%copysrc_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%copysrc_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%copysrc_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%copysrc_batfile_path%"
echo         echo ������܂���>> "%copysrc_batfile_path%"
echo         set ts_parser_path=%%%%~E>> "%copysrc_batfile_path%"
echo         exit /b>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo call :ts_parser_env_search %%~nx1>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo :ts_parser_env_search>> "%copysrc_batfile_path%"
echo set ts_parser_path=%%~$PATH:1>> "%copysrc_batfile_path%"
echo if "%%ts_parser_path%%"=="" ^(>> "%copysrc_batfile_path%"
echo     echo ts_parser��������܂���B>> "%copysrc_batfile_path%"
echo     set ts_parser_path=%%~1>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :find_faad>> "%copysrc_batfile_path%"
echo echo findexe�����F"%%~1">> "%copysrc_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%copysrc_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%copysrc_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%copysrc_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%copysrc_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%copysrc_batfile_path%"
echo         echo ������܂���>> "%copysrc_batfile_path%"
echo         set faad_path=%%%%~E>> "%copysrc_batfile_path%"
echo         exit /b>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo call :faad_env_search %%~nx1>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo :faad_env_search>> "%copysrc_batfile_path%"
echo set faad_path=%%~$PATH:1>> "%copysrc_batfile_path%"
echo if "%%faad_path%%"=="" ^(>> "%copysrc_batfile_path%"
echo    echo faad��������܂���B>> "%copysrc_batfile_path%"
echo     set faad_path=%%~1>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :find_FAW>> "%copysrc_batfile_path%"
echo echo findexe�����F"%%~1">> "%copysrc_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%copysrc_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%copysrc_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%copysrc_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%copysrc_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%copysrc_batfile_path%"
echo         echo ������܂���>> "%copysrc_batfile_path%"
echo         set FAW_path=%%%%~E>> "%copysrc_batfile_path%"
echo         exit /b>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo call :FAW_env_search %%~nx1>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo :FAW_env_search>> "%copysrc_batfile_path%"
echo set FAW_path=%%~$PATH:1>> "%copysrc_batfile_path%"
echo if "%%FAW_path%%"=="" ^(>> "%copysrc_batfile_path%"
echo     echo FAW��������܂���B>> "%copysrc_batfile_path%"
echo     set FAW_path=%%~1>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo.>> "%copysrc_batfile_path%"
rem ------------------------------
echo :find_TsSplitter>> "%copysrc_batfile_path%"
echo echo findexe�����F"%%~1">> "%copysrc_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%copysrc_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%copysrc_batfile_path%"
echo ^) else ^(>> "%copysrc_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%copysrc_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%copysrc_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%copysrc_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%copysrc_batfile_path%"
echo         echo ������܂���>> "%copysrc_batfile_path%"
echo         set TsSplitter_path=%%%%~E>> "%copysrc_batfile_path%"
echo         exit /b>> "%copysrc_batfile_path%"
echo     ^)>> "%copysrc_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%copysrc_batfile_path%"
echo ^)>> "%copysrc_batfile_path%"
echo call :TsSplitter_env_search %%~nx1>> "%copysrc_batfile_path%"
echo exit /b>> "%copysrc_batfile_path%"
echo :TsSplitter_env_search>> "%copysrc_batfile_path%"
echo set TsSplitter_path=%%~$PATH:1>> "%copysrc_batfile_path%"
echo if "%%TsSplitter_path%%"=="" ^(>> "%copysrc_batfile_path%"
echo     echo TsSplitter��������܂���B>> "%copysrc_batfile_path%"
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
rem # DGIndex�ɓǂݍ��܂���ׂ�.d2v�t�@�C�����쐬����
rem # DGIndex���g�p���Ȃ��ꍇ�͓��Y�֐��X�L�b�v
if not "%mpeg2dec_select_flag%"=="2" exit /b
type nul > "%d2vgen_batfile_path%"
echo @echo off>> "%d2vgen_batfile_path%"
echo setlocal>> "%d2vgen_batfile_path%"
echo cd /d %%~dp0..\>> "%d2vgen_batfile_path%"
echo.>> "%d2vgen_batfile_path%"
echo echo DGIndex�̃v���W�F�N�g�t�@�C��(.d2v)���쐬���܂�[%%time%%]>> "%d2vgen_batfile_path%"
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
exit /b
:d2v_exist_checker
echo if exist "%~dpn1.d2v" ^(>> "%d2vgen_batfile_path%"
echo     echo �I���ɓ�����.d2v�t�@�C�������݂���ׁA�������X�L�b�v���܂��I>> "%d2vgen_batfile_path%"
echo     exit /b>> "%d2vgen_batfile_path%"
echo ^)>> "%d2vgen_batfile_path%"
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
echo rem # �I�[�f�B�I�t�@�C���̕ҏW���s�t�F�[�Y>>"%main_bat_file%"
echo call ".\bat\audio_edit.bat">> "%main_bat_file%"
echo.>> "%main_bat_file%"
echo @echo off>> "%audio_edit_batfile_path%"
echo setlocal>> "%audio_edit_batfile_path%"
echo echo start %%~nx0 bat job...>> "%audio_edit_batfile_path%"
echo cd /d %%~dp0..\>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
echo rem # �I�[�f�B�I�̏�������֐��Ăяo��>> "%audio_edit_batfile_path%"
echo call :audio_job_detect>> "%audio_edit_batfile_path%"
echo rem # Audio edit mode[faw^(Default^), sox, nero]>> "%audio_edit_batfile_path%"
echo rem audio_job_flag=faw>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
echo rem # %%large_tmp_dir%% �̑��݊m�F����і����`�F�b�N>> "%audio_edit_batfile_path%"
echo if not exist "%%large_tmp_dir%%" ^(>> "%audio_edit_batfile_path%"
echo     echo �傫�ȃt�@�C�����o�͂���ꎞ�t�H���_ %%%%large_tmp_dir%%%% �����݂��܂���A����ɃV�X�e���̃e���|�����t�H���_�ő�p���܂��B>> "%audio_edit_batfile_path%"
echo     set large_tmp_dir=%%tmp%%>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\>> "%audio_edit_batfile_path%"
echo rem # �G���R�[�h�c�[�����܂Ƃ߂��f�B���N�g�����������ϐ�ENCTOOLSROOTPATH����`����Ă��邩�m�F>> "%audio_edit_batfile_path%"
echo call :toolsdircheck>> "%audio_edit_batfile_path%"
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o>> "%audio_edit_batfile_path%"
echo call :project_name_check>> "%audio_edit_batfile_path%"
echo rem # parameter�t�@�C�����̃I�[�f�B�I�Q�C���A�b�v�l^(audio_gain^)�����o>> "%audio_edit_batfile_path%"
echo call :audio_gain_check>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
echo rem # �e���s�t�@�C�������݂��邩�m�F�B���݂��Ȃ��ꍇENCTOOLSROOTPATH������T������A�������̓V�X�e���̒T���p�X�Ɉς˂�>> "%audio_edit_batfile_path%"
echo if exist "%avs2wav_path%" ^(set avs2wav_path=%avs2wav_path%^) else ^(call :find_avs2wav "%avs2wav_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%sox_path%" ^(set sox_path=%sox_path%^) else ^(call :find_sox "%sox_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%neroAacEnc_path%" ^(set neroAacEnc_path=%neroAacEnc_path%^) else ^(call :find_neroAacEnc_path "%neroAacEnc_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%FAW_path%" ^(set FAW_path=%FAW_path%^) else ^(call :find_FAW "%FAW_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%muxer_path%" ^(set muxer_path=%muxer_path%^) else ^(call :find_muxer "%muxer_path%"^)>> "%audio_edit_batfile_path%"
echo if exist "%aacgain_path%" ^(set aacgain_path=%aacgain_path%^) else ^(call :find_aacgain "%aacgain_path%"^)>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
echo rem # �e����s�t�@�C���ւ̃p�X���A�ŏI�I�ɂǂ̂悤�Ȓl�ɂȂ������m�F�B>> "%audio_edit_batfile_path%"
echo echo avs2wav       : %%avs2wav_path%%>> "%audio_edit_batfile_path%"
echo echo sox           : %%sox_path%%>> "%audio_edit_batfile_path%"
echo echo neroAacEnc    : %%neroAacEnc_path%%>> "%audio_edit_batfile_path%"
echo echo FakeAacWav    : %%FAW_path%%>> "%audio_edit_batfile_path%"
echo echo muxer^(L-SMASH^): %%muxer_path%%>> "%audio_edit_batfile_path%"
echo echo AACGain       : %%aacgain_path%%>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
echo rem �����Ӂ�>> "%audio_edit_batfile_path%"
echo rem TS�t�@�C���̒��ɂ́A�ԑg�؂�ւ��Ȃǂ̃^�C�~���O�Ńr�f�I�ƃI�[�f�B�I�̊J�n�ʒu������Ȃ����Ƃ�����^(�s�a�r�ǂȂǂŔ���^)>> "%audio_edit_batfile_path%"
echo rem ���̏ꍇ�ATsSplitter��PMT^(ProgramMapTable^)���ɕ������邱�Ƃŉ���ł���ꍇ������^(-SEP3�I�v�V����^)>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
echo :main>> "%audio_edit_batfile_path%"
echo rem //----- main�J�n -----//>> "%audio_edit_batfile_path%"
echo title %%project_name%%>> "%audio_edit_batfile_path%"
echo if "%%audio_job_flag%%"=="sox" ^(>> "%audio_edit_batfile_path%"
echo     call :Bilingual_audio_encoding>> "%audio_edit_batfile_path%"
echo ^) else if "%%audio_job_flag%%"=="nero" ^(>> "%audio_edit_batfile_path%"
echo     call :Stereo_audio_encoding>> "%audio_edit_batfile_path%"
echo ^) else if "%%audio_job_flag%%"=="faw" ^(>> "%audio_edit_batfile_path%"
echo     call :FAW_audio_encoding>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo title �R�}���h �v�����v�g>> "%audio_edit_batfile_path%"
echo rem //----- main�I�� -----//>> "%audio_edit_batfile_path%"
echo echo end %%~nx0 bat job...>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :Bilingual_audio_encoding>> "%audio_edit_batfile_path%"
echo rem # �񃖍��ꉹ���̏ꍇ�̃G���R�[�h�����Asox���g���č��E�̃`�����l���𕪊�����>> "%audio_edit_batfile_path%"
echo echo sox ���g�p>> "%audio_edit_batfile_path%"
echo echo avs2wav�ŕҏW��. . .[%%time%%]>> "%audio_edit_batfile_path%"
echo rem # avs2wav�̓o�[�W�����ɂ���Ă̓C���v�b�g�t�@�C���ɑ��΃p�X���w�肷��ƃG���[�Œ�~����̂ŁA�ꎞ�I�Ƀf�B���N�g����ύX���܂�>> "%audio_edit_batfile_path%"
echo pushd avs>> "%audio_edit_batfile_path%"
echo "%%avs2wav_path%%" "audio_export_pcm.avs" "%%large_tmp_dir%%%%project_name%%.wav"^>nul>> "%audio_edit_batfile_path%"
echo popd>> "%audio_edit_batfile_path%"
echo echo �񃖍��ꉹ���̕ҏW��. . .[%%time%%]>> "%audio_edit_batfile_path%"
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
echo rem # �X�e���I�����Ƃ��čăG���R�[�h����ꍇ�̏���>> "%audio_edit_batfile_path%"
echo echo neroAacEnc ���g�p>> "%audio_edit_batfile_path%"
echo echo avs2wav�ŕҏW��. . .[%%time%%]>> "%audio_edit_batfile_path%"
echo rem # avs2wav�̓o�[�W�����ɂ���Ă̓C���v�b�g�t�@�C���ɑ��΃p�X���w�肷��ƃG���[�Œ�~����̂ŁA�ꎞ�I�Ƀf�B���N�g����ύX���܂�>> "%audio_edit_batfile_path%"
echo pushd avs>> "%audio_edit_batfile_path%"
echo "%%avs2wav_path%%" "audio_export_pcm.avs" "%%large_tmp_dir%%%%project_name%%.wav"^>nul>> "%audio_edit_batfile_path%"
echo popd>> "%audio_edit_batfile_path%"
echo echo neroAacEnc�ŃG���R�[�h��. . .[%%time%%]>> "%audio_edit_batfile_path%"
echo "%%neroAacEnc_path%%" -q 0.40 -if "%%large_tmp_dir%%%%project_name%%.wav" -of ".\tmp\main_audio.m4a">> "%audio_edit_batfile_path%"
echo call :AACGain_phase ".\tmp\main_audio.m4a">> "%audio_edit_batfile_path%"
echo del "%%large_tmp_dir%%%%project_name%%.wav">> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :FAW_audio_encoding>> "%audio_edit_batfile_path%"
echo rem # FAW���g�p���ăJ�b�g�݂̂̏���>> "%audio_edit_batfile_path%"
echo echo FakeAacWav ���g�p>> "%audio_edit_batfile_path%"
echo echo avs2wav�ŕҏW��. . .[%%time%%]>> "%audio_edit_batfile_path%"
echo rem # avs2wav�̓o�[�W�����ɂ���Ă̓C���v�b�g�t�@�C���ɑ��΃p�X���w�肷��ƃG���[�Œ�~����̂ŁA�ꎞ�I�Ƀf�B���N�g����ύX���܂�>> "%audio_edit_batfile_path%"
echo pushd avs>> "%audio_edit_batfile_path%"
echo echo avs2wav�͏o�͐�t�H���_�̎w����@����ŕs���I�����邱�Ƃ�����̂Œ���>> "%audio_edit_batfile_path%"
echo "%%avs2wav_path%%" "audio_export_faw.avs" "%%large_tmp_dir%%%%project_name%%_aac_edit.wav"^>nul>> "%audio_edit_batfile_path%"
echo popd>> "%audio_edit_batfile_path%"
echo "%%FAW_path%%" "%%large_tmp_dir%%%%project_name%%_aac_edit.wav" ".\tmp\main_edit.aac">> "%audio_edit_batfile_path%"
echo echo muxer ���g����m4a�R���e�i�֓������܂�>> "%audio_edit_batfile_path%"
echo "%%muxer_path%%" -i ".\tmp\main_edit.aac" -o ".\tmp\main_audio.m4a">> "%audio_edit_batfile_path%"
echo call :AACGain_phase ".\tmp\main_audio.m4a">> "%audio_edit_batfile_path%"
echo del "%%large_tmp_dir%%%%project_name%%_aac_edit.wav">> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :AACGain_phase>> "%audio_edit_batfile_path%"
echo rem # AACGain���g�p���ĉ��ʂ��A�b�v���鏈��>> "%audio_edit_batfile_path%"
echo echo AACGain�ŉ��ʒ���. . .[%%time%%]>> "%audio_edit_batfile_path%"
echo echo "%%~1" ���I�[�f�B�I�Q�C���A�b�v���܂�>> "%audio_edit_batfile_path%"
echo if "%%audio_gain%%"=="0" ^(>> "%audio_edit_batfile_path%"
echo     echo �I�[�f�B�I�Q�C���A�b�v�l��0�ׁ̈A�������X�L�b�v���܂�>> "%audio_edit_batfile_path%"
echo ^) else ^(>> "%audio_edit_batfile_path%"
echo     echo �Q�C���A�b�v�l�� %%audio_gain%% �ł�>> "%audio_edit_batfile_path%"
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
echo     echo �p�����[�^�t�@�C���̒��ɃI�[�f�B�I�̏����w�肪������܂���B�f�t�H���g��FAW���g�p���܂��B>> "%audio_edit_batfile_path%"
echo     set audio_job_flag=faw>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :toolsdircheck>> "%audio_edit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%audio_edit_batfile_path%"
echo     echo ���ϐ� ENCTOOLSROOTPATH ������`�ł�>> "%audio_edit_batfile_path%"
echo     exit /b>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\>> "%audio_edit_batfile_path%"
echo if exist "%%ENCTOOLSROOTPATH%%" ^(>> "%audio_edit_batfile_path%"
echo     exit /b>> "%audio_edit_batfile_path%"
echo ^) else ^(>> "%audio_edit_batfile_path%"
echo     echo ���ϐ�ENCTOOLSROOTPATH���L���ȃp�X�ł͂���܂���>> "%audio_edit_batfile_path%"
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
echo     echo �p�����[�^�[ audio_gain ������`�ł��B0 �������܂��B>> "%audio_edit_batfile_path%"
echo     set audio_gain=^0>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :find_avs2wav>> "%audio_edit_batfile_path%"
echo echo findexe�����F"%%~1">> "%audio_edit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%audio_edit_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%audio_edit_batfile_path%"
echo ^) else ^(>> "%audio_edit_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%audio_edit_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%audio_edit_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%audio_edit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%audio_edit_batfile_path%"
echo         echo ������܂���>> "%audio_edit_batfile_path%"
echo         set avs2wav_path=%%%%~E>> "%audio_edit_batfile_path%"
echo         exit /b>> "%audio_edit_batfile_path%"
echo     ^)>> "%audio_edit_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo call :avs2wav_env_search "%%~nx1">> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo :avs2wav_env_search>> "%audio_edit_batfile_path%"
echo set avs2wav_path=%%~$PATH:1>> "%audio_edit_batfile_path%"
echo if "%%avs2wav_path%%"=="" ^(>> "%audio_edit_batfile_path%"
echo     echo avs2wav��������܂���>> "%audio_edit_batfile_path%"
echo     set avs2wav_path=%%~1>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :find_sox>> "%audio_edit_batfile_path%"
echo echo findexe�����F"%%~1">> "%audio_edit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%audio_edit_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%audio_edit_batfile_path%"
echo ^) else ^(>> "%audio_edit_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%audio_edit_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%audio_edit_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%audio_edit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%audio_edit_batfile_path%"
echo         echo ������܂���>> "%audio_edit_batfile_path%"
echo         set sox_path=%%%%~E>> "%audio_edit_batfile_path%"
echo         exit /b>> "%audio_edit_batfile_path%"
echo     ^)>> "%audio_edit_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo call :sox_env_search "%%~nx1">> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo :sox_env_search>> "%audio_edit_batfile_path%"
echo set sox_path=%%~$PATH:1>> "%audio_edit_batfile_path%"
echo if "%%sox_path%%"=="" ^(>> "%audio_edit_batfile_path%"
echo     echo sox��������܂���>> "%audio_edit_batfile_path%"
echo     set sox_path=%%~1>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :find_neroAacEnc>> "%audio_edit_batfile_path%"
echo echo findexe�����F"%%~1">> "%audio_edit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%audio_edit_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%audio_edit_batfile_path%"
echo ^) else ^(>> "%audio_edit_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%audio_edit_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%audio_edit_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%audio_edit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%audio_edit_batfile_path%"
echo         echo ������܂���>> "%audio_edit_batfile_path%"
echo         set neroAacEnc_path=%%%%~E>> "%audio_edit_batfile_path%"
echo         exit /b>> "%audio_edit_batfile_path%"
echo     ^)>> "%audio_edit_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo call :neroAacEnc_env_search "%%~nx1">> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo :neroAacEnc_env_search>> "%audio_edit_batfile_path%"
echo set neroAacEnc_path=%%~$PATH:1>> "%audio_edit_batfile_path%"
echo if "%%neroAacEnc_path%%"=="" ^(>> "%audio_edit_batfile_path%"
echo     echo neroAacEnc��������܂���>> "%audio_edit_batfile_path%"
echo     set neroAacEnc_path=%%~1>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :find_FAW>> "%audio_edit_batfile_path%"
echo echo findexe�����F"%%~1">> "%audio_edit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%audio_edit_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%audio_edit_batfile_path%"
echo ^) else ^(>> "%audio_edit_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%audio_edit_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%audio_edit_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%audio_edit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%audio_edit_batfile_path%"
echo         echo ������܂���>> "%audio_edit_batfile_path%"
echo         set FAW_path=%%%%~E>> "%audio_edit_batfile_path%"
echo         exit /b>> "%audio_edit_batfile_path%"
echo     ^)>> "%audio_edit_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo call :FAW_env_search "%%~nx1">> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo :FAW_env_search>> "%audio_edit_batfile_path%"
echo set FAW_path=%%~$PATH:1>> "%audio_edit_batfile_path%"
echo if "%%FAW_path%%"=="" ^(>> "%audio_edit_batfile_path%"
echo     echo FakeAacWav^(FAW^)��������܂���>> "%audio_edit_batfile_path%"
echo     set FAW_path=%%~1>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :find_muxer>> "%audio_edit_batfile_path%"
echo echo findexe�����F"%%~1">> "%audio_edit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%audio_edit_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%audio_edit_batfile_path%"
echo ^) else ^(>> "%audio_edit_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%audio_edit_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%audio_edit_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%audio_edit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%audio_edit_batfile_path%"
echo         echo ������܂���>> "%audio_edit_batfile_path%"
echo         set muxer_path=%%%%~E>> "%audio_edit_batfile_path%"
echo         exit /b>> "%audio_edit_batfile_path%"
echo     ^)>> "%audio_edit_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo call :muxer_env_search %%~nx1>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo :muxer_env_search>> "%audio_edit_batfile_path%"
echo set muxer_path=%%~$PATH:1>> "%audio_edit_batfile_path%"
echo if "%%muxer_path%%"=="" ^(>> "%audio_edit_batfile_path%"
echo     echo muxer��������܂���>> "%audio_edit_batfile_path%"
echo     set muxer_path=%%~1>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
echo :find_aacgain>> "%audio_edit_batfile_path%"
echo echo findexe�����F"%%~1">> "%audio_edit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%audio_edit_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%audio_edit_batfile_path%"
echo ^) else ^(>> "%audio_edit_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%audio_edit_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%audio_edit_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%audio_edit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%audio_edit_batfile_path%"
echo         echo ������܂���>> "%audio_edit_batfile_path%"
echo         set aacgain_path=%%%%~E>> "%audio_edit_batfile_path%"
echo         exit /b>> "%audio_edit_batfile_path%"
echo     ^)>> "%audio_edit_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo call :aacgain_env_search "%%~nx1">> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo :aacgain_env_search>> "%audio_edit_batfile_path%"
echo set aacgain_path=%%~$PATH:1>> "%audio_edit_batfile_path%"
echo if "%%aacgain_path%%"=="" ^(>> "%audio_edit_batfile_path%"
echo     echo AACGain��������܂���>> "%audio_edit_batfile_path%"
echo     set aacgain_path=%%~1>> "%audio_edit_batfile_path%"
echo ^)>> "%audio_edit_batfile_path%"
echo exit /b>> "%audio_edit_batfile_path%"
echo.>> "%audio_edit_batfile_path%"
rem ------------------------------
exit /b


:last_order
echo echo ### �I������[%%time%%] ###>> "%main_bat_file%"
echo echo.>> "%main_bat_file%"
exit /b

:fix_edts_select
echo rename "%outputmp4_dir%%%project_name%%.mp4" "%%project_name%%_bak.mp4">> "%audio_edit_batfile_path%"
echo "%ffmpeg_path%" -i "%outputmp4_dir%%%project_name%%_bak.mp4" -vcodec copy -acodec copy -f mp4 "%outputmp4_dir%%%project_name%%.mp4" ^&^& del "%outputmp4_dir%%%project_name%%_bak.mp4">> "%audio_edit_batfile_path%"
exit /b


:mux_option_selector
rem # MP4�R���e�i�ւ�mux�ƍŏI�t�H���_�ւ̈ړ��H��
rem # �t���[�����[�g�I�v�V����������
if "%deinterlace_filter_flag%"=="24fps" (
    set video_track_fps_opt=?fps=24000/1001
) else if "%deinterlace_filter_flag%"=="30fps" (
    set video_track_fps_opt=?fps=30000/1001
) else (
    set video_track_fps_opt=
)
echo rem # �e�g���b�N��MUX�ƍŏI�t�H���_�ւ̈ړ��t�F�[�Y>>"%main_bat_file%"
echo call ".\bat\mux_tracks.bat">>"%main_bat_file%"
echo.>>"%main_bat_file%"
type nul > "%muxtracks_batfile_path%"
echo @echo off>> "%muxtracks_batfile_path%"
echo setlocal>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo echo start %%~nx0 bat job...>>"%muxtracks_batfile_path%"
echo echo �e��g���b�N��񓙂̓���. . .[%%time%%]>>"%muxtracks_batfile_path%"
echo chdir /d %%~dp0..\>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
echo rem # �g�p����R�s�[�A�v���P�[�V������I�����܂�>> "%muxtracks_batfile_path%"
echo call :copy_app_detect>> "%muxtracks_batfile_path%"
echo rem copy^(Default^), fac^(FastCopy^), ffc^(FireFileCopy^)>> "%muxtracks_batfile_path%"
echo rem set copy_app_flag=%copy_app_flag%>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # �ŏI�o�͐�t�H���_�����o>> "%muxtracks_batfile_path%"
echo call :out_dir_detect>> "%muxtracks_batfile_path%"
echo rem set final_out_dir=%%HOMEDRIVE%%\%%HOMEPATH%%>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # �g�p����r�f�I�G���R�[�h�R�[�f�b�N�^�C�v�ɉ����Ċg���q�𔻒肷��֐����Ăяo���܂�>> "%muxtracks_batfile_path%"
echo call :video_extparam_detect>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # �g�p����I�[�f�B�I�����𔻒肷��֐����Ăяo���܂�>> "%muxtracks_batfile_path%"
echo call :audio_job_detect>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # �G���R�[�h�c�[�����܂Ƃ߂��f�B���N�g�����������ϐ�ENCTOOLSROOTPATH����`����Ă��邩�m�F>> "%muxtracks_batfile_path%"
echo call :toolsdircheck>> "%muxtracks_batfile_path%"
echo rem # parameter�t�@�C�����̃\�[�X�t�@�C���ւ̃t���p�X^(src_file_path^)�����o>> "%muxtracks_batfile_path%"
echo call :src_file_path_check>> "%muxtracks_batfile_path%"
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o>> "%muxtracks_batfile_path%"
echo call :project_name_check>> "%muxtracks_batfile_path%"
echo rem # �ړ���̃T�u�t�H���_^(sub_folder_name^)���\�[�X�t�@�C���̐e�f�B���N�g���������Ɍ���>> "%muxtracks_batfile_path%"
echo call :sub_folder_name_detec "%%src_file_path%%">> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # �e���s�t�@�C�������݂��邩�m�F�B���݂��Ȃ��ꍇENCTOOLSROOTPATH������T������A�������̓V�X�e���̒T���p�X�Ɉς˂�>> "%muxtracks_batfile_path%"
echo rem # ����ł�������Ȃ��ꍇ�A�R�}���h�v�����v�g�W����copy�R�}���h���g�p����>> "%muxtracks_batfile_path%"
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
echo rem # �e����s�t�@�C���ւ̃p�X���A�ŏI�I�ɂǂ̂悤�Ȓl�ɂȂ������m�F�B>> "%muxtracks_batfile_path%"
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
echo echo �v���W�F�N�g��         �F %%project_name%%>> "%muxtracks_batfile_path%"
echo echo �T�u�t�H���_��         �F %%sub_folder_name%%>> "%muxtracks_batfile_path%"
echo rem �����ӓ_��>> "%muxtracks_batfile_path%"
echo rem mp4box�͓��{�ꕶ����̎�舵�������肩�W���o�͂�UTF-8�Ȃ̂ŁA���O�ɔ��p�p���Ƀ��l�[�����Ă��珈�����鎖�B>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo :main>> "%muxtracks_batfile_path%"
echo rem //----- main�J�n -----//>> "%muxtracks_batfile_path%"
echo title %%project_name%%>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # MUX�Ώۂ̃t�@�C�������݂��邩�A���킩�ǂ����m�F>> "%muxtracks_batfile_path%"
echo set tmp-file_error_flag=^0>> "%muxtracks_batfile_path%"
echo if exist ".\tmp\main_temp%%video_ext_type%%" ^(>> "%muxtracks_batfile_path%"
echo     call :zero-byte_error_check ".\tmp\main_temp%%video_ext_type%%">> "%muxtracks_batfile_path%"
echo ^) else ^(>> "%muxtracks_batfile_path%"
echo     echo ��"main_temp%%video_ext_type%%" �t�@�C�������݂��܂���>> "%muxtracks_batfile_path%"
echo     set tmp-file_error_flag=^1>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo if "%%audio_job_flag%%"=="sox" ^(>> "%muxtracks_batfile_path%"
echo     if exist ".\tmp\main_left.m4a" ^(>> "%muxtracks_batfile_path%"
echo         call :zero-byte_error_check ".\tmp\main_left.m4a">> "%muxtracks_batfile_path%"
echo     ^) else ^(>> "%muxtracks_batfile_path%"
echo         echo ��"main_left.m4a" �t�@�C�������݂��܂���>> "%muxtracks_batfile_path%"
echo         set tmp-file_error_flag=^1>> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo     if exist ".\tmp\main_right.m4a" ^(>> "%muxtracks_batfile_path%"
echo         call :zero-byte_error_check ".\tmp\main_right.m4a">> "%muxtracks_batfile_path%"
echo     ^) else ^(>> "%muxtracks_batfile_path%"
echo         echo ��"main_right.m4a" �t�@�C�������݂��܂���>> "%muxtracks_batfile_path%"
echo         set tmp-file_error_flag=^1>> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^) else if "%%audio_job_flag%%"=="nero" ^(>> "%muxtracks_batfile_path%"
echo     if exist ".\tmp\main_audio.m4a" ^(>> "%muxtracks_batfile_path%"
echo         call :zero-byte_error_check ".\tmp\main_audio.m4a">> "%muxtracks_batfile_path%"
echo     ^) else ^(>> "%muxtracks_batfile_path%"
echo         echo ��"main_audio.m4a" �t�@�C�������݂��܂���>> "%muxtracks_batfile_path%"
echo         set tmp-file_error_flag=^1>> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^) else ^(>> "%muxtracks_batfile_path%"
echo     if exist ".\tmp\main_audio.m4a" ^(>> "%muxtracks_batfile_path%"
echo         call :zero-byte_error_check ".\tmp\main_audio.m4a">> "%muxtracks_batfile_path%"
echo     ^) else ^(>> "%muxtracks_batfile_path%"
echo         echo ��".\tmp\main_audio.m4a" �t�@�C�������݂��܂���>> "%muxtracks_batfile_path%"
echo         set tmp-file_error_flag=^1>> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo if "%%tmp-file_error_flag%%"=="1" ^(>> "%muxtracks_batfile_path%"
echo     echo ��MUX�Ώۃt�@�C���ɉ��炩�ُ̈킪���邽�߁AMUX�����𒆒f���܂��B>> "%muxtracks_batfile_path%"
echo     echo end %%~nx0 bat job...>> "%muxtracks_batfile_path%"
echo     exit /b>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # �f���Ɖ�����MUX>> "%muxtracks_batfile_path%"
echo echo L-SMASH�ŉf���Ɖ����𓝍����܂�>> "%muxtracks_batfile_path%"
echo rem # L-SMASH��-chapter�I�v�V������ogg�`���`���v�^�[�t�@�C����ǂݍ��߂Ȃ��׎g�p���܂���B�����mp4chaps���g�p���܂��B>> "%muxtracks_batfile_path%"
echo rem # --file-format ��mov�𕹗p����Ƌ������s����ɂȂ邽�ߔ񐄏�>> "%muxtracks_batfile_path%"
echo if "%%audio_job_flag%%"=="sox" ^(>> "%muxtracks_batfile_path%"
echo     echo �񂩍��ꉹ�����ʂ̃��m���������Ƃ���MUX���܂�[%%time%%]>> "%muxtracks_batfile_path%"
echo     "%%muxer_path%%" -i ".\tmp\main_temp%%video_ext_type%%"%video_track_fps_opt% -i ".\tmp\main_left.m4a"?language=jpn,group=2 -i ".\tmp\main_right.m4a"?disable,language=eng,group=2 --optimize-pd --file-format mp4 --isom-version 6 -o "%%project_name%%.mp4">> "%muxtracks_batfile_path%"
echo ^) else if "%%audio_job_flag%%"=="nero" ^(>> "%muxtracks_batfile_path%"
echo     echo �ăG���R�[�h�����X�e���IAAC������MUX���܂�[%%time%%]>> "%muxtracks_batfile_path%"
echo     "%%muxer_path%%" -i ".\tmp\main_temp%%video_ext_type%%"%video_track_fps_opt% -i ".\tmp\main_audio.m4a"?language=jpn --optimize-pd --file-format mp4 --isom-version 6 -o "%%project_name%%.mp4">> "%muxtracks_batfile_path%"
echo ^) else ^(>> "%muxtracks_batfile_path%"
echo     echo �\�[�X�𖳗򉻕ҏW����FAW������MUX���܂�[%%time%%]>> "%muxtracks_batfile_path%"
echo     "%%muxer_path%%" -i ".\tmp\main_temp%%video_ext_type%%"%video_track_fps_opt% -i ".\tmp\main_audio.m4a"?language=jpn --optimize-pd --file-format mp4 --isom-version 6 -o "%%project_name%%.mp4">> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # �^�C���R�[�h�t�@�C�������݂���ꍇ�Atimelineeditor���g���ă^�C���R�[�h���ߍ��݂��܂�>> "%muxtracks_batfile_path%"
echo if exist ".\tmp\main.tmc" ^(>> "%muxtracks_batfile_path%"
echo     rename "%%project_name%%.mp4" "%%project_name%%_raw.mp4">> "%muxtracks_batfile_path%"
echo     rem # DtsEdit��H.265/HEVC��Ή�>> "%muxtracks_batfile_path%"
echo     rem # timelineeditor��--media-timescale�I�v�V�������g�p���Ȃ���QuickTime�ōĐ��ł��Ȃ��t�@�C�����o�͂����^(QuickTime Player v7.7.9�Ŋm�F^)>> "%muxtracks_batfile_path%"
echo     rem # timelineeditor^(rev1450^)�́AMPC-BE ver1.5.0^(build 2235^)������MP4/MOV�X�v���b�^�[�ŕs���I���AQT���Đ��s�\�̈ה񐄏�^(rev1432���Ȃ���Ȃ�^)>> "%muxtracks_batfile_path%"
echo     rem # DtsEdit��mux�����t�@�C����PS4�ōĐ��s�b�`�����������Ȃ�̂ňꗥtimelineeditor�ɐ؂�ւ�>> "%muxtracks_batfile_path%"
echo     if "%%video_ext_type%%"==".265" ^(>> "%muxtracks_batfile_path%"
echo         echo �^�C���R�[�h�t�@�C���𔭌��������߁Atimelineeditor�œ������܂�>> "%muxtracks_batfile_path%"
echo         "%%timelineeditor_path%%" --timecode ".\tmp\main.tmc" --media-timescale 24000 "%%project_name%%_raw.mp4" "%%project_name%%.mp4">> "%muxtracks_batfile_path%"
echo         rem "%%DtsEdit_path%%" -no-dc -s 24000 -tv 2 -tc ".\tmp\main.tmc" -o "%%project_name%%.mp4" "%%project_name%%_raw.mp4">> "%muxtracks_batfile_path%"
echo     ^) else if "%%video_ext_type%%"==".264" ^(>> "%muxtracks_batfile_path%"
echo         echo �^�C���R�[�h�t�@�C���𔭌��������߁Atimelineeditor�œ������܂�>> "%muxtracks_batfile_path%"
echo         "%%timelineeditor_path%%" --timecode ".\tmp\main.tmc" --media-timescale 24000 "%%project_name%%_raw.mp4" "%%project_name%%.mp4">> "%muxtracks_batfile_path%"
echo         rem echo �^�C���R�[�h�t�@�C���𔭌��������߁ADtsEdit�œ������܂�>> "%muxtracks_batfile_path%"
echo         rem "%%DtsEdit_path%%" -no-dc -s 24000 -tv 2 -tc ".\tmp\main.tmc" -o "%%project_name%%.mp4" "%%project_name%%_raw.mp4">> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo     del "%%project_name%%_raw.mp4">>"%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # �}�j���A��24fps�v���O�C���ō쐬���ꂽ.*.chapter.txt�t�@�C�������݂���ꍇ���l�[�����܂�>> "%muxtracks_batfile_path%"
echo if exist "*.chapter.txt" ^(>> "%muxtracks_batfile_path%"
echo     echo �}�j���A��24fps�v���O�C���`���̃`���v�^�[�t�@�C���𔭌��������߁A�`����ϊ����܂�>> "%muxtracks_batfile_path%"
echo     for /f "delims=" %%%%N in ^('dir /b "*.chapter.txt"'^) do ^(>> "%muxtracks_batfile_path%"
echo         rename "%%%%N" "%%project_name%%_sjis.chapters.txt">> "%muxtracks_batfile_path%"
echo         "%%nkf_path%%" -w "%%project_name%%_sjis.chapters.txt"^> "%%project_name%%.chapters.txt">> "%muxtracks_batfile_path%"
echo         del "%%project_name%%_sjis.chapters.txt">> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # �`���v�^�[����������t�F�[�X�Bmp4chaps�̎d�l��AMP4�t�@�C���Ɠ����f�B���N�g����>> "%muxtracks_batfile_path%"
echo rem # "�C���|�[�g��MP4�t�@�C����.chapters.txt"�̖����K���ŁAOGG�`���̃`���v�^�[�t�@�C����z�u����K�v������܂��B>> "%muxtracks_batfile_path%"
echo rem # QT�`���̃`���v�^�[�͊g���q��.m4v�łȂ����QuickTime Player�ŔF���ł��܂��񂪁AiTunes�ł����.mp4�ł��g�p�ł��܂��B>>"%muxtracks_batfile_path%"
echo rem # QuickTime Player^(version 7.7.9^)��iTunes^(12.4.1.6^)�Ŋm�F>>"%muxtracks_batfile_path%"
echo rem �I�v�V�����F -A QT��Nero�̃n�C�u���b�h / -Q QT�`�� / -N Nero�`��>>"%muxtracks_batfile_path%"
echo if exist "%%project_name%%.chapters.txt" ^(>> "%muxtracks_batfile_path%"
echo     echo �`���v�^�[�t�@�C���𔭌��������߁Amp4chaps�œ������܂�>> "%muxtracks_batfile_path%"
echo     "%%mp4chaps_path%%" -i -Q "%%project_name%%.mp4">> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
echo rem # �����t�@�C�������݂��邩�`�F�b�N�A�������ꍇ�����mux�̍H���ɑg�ݍ��݂܂�>>"%muxtracks_batfile_path%"
echo rem # L-SMASH�͎�����MUX���������ׁ̈Amp4box(version 0.6.2�ȏ㐄��)���g�p���܂�>>"%muxtracks_batfile_path%"
echo if exist ".\tmp\main.srt" ^(>>"%muxtracks_batfile_path%"
echo     echo ��������Amp4box�œ������܂�>>"%muxtracks_batfile_path%"
echo     rename "%%project_name%%.mp4" "main_raw.mp4">> "%muxtracks_batfile_path%"
echo     rem # Identifier��"sbtl:tx3g"�̏ꍇApple�t�H�[�}�b�g�A"text:tx3g"�̏ꍇ3GPP/MPEG�A���C�A���X�t�H�[�}�b�g>> "%muxtracks_batfile_path%"
echo     rem https://gpac.wp.mines-telecom.fr/2014/09/04/subtitling-with-gpac/>> "%muxtracks_batfile_path%"
echo     rem "%%mp4box_path%%" -add "main_raw.mp4"  -add ".\tmp\main.srt":lang=jpn:group=3:hdlr="sbtl:tx3g":layout=0x60x0x-1 -add "main.srt":disable:lang=jpn:group=3:hdlr="text:tx3g":layout=0x60x0x-1 "mp4box_out.mp4">> "%muxtracks_batfile_path%"
echo     "%%mp4box_path%%" -add "main_raw.mp4" -add ".\tmp\main.srt":lang=jpn:group=3:hdlr="sbtl:tx3g":layout=0x60x0x-1 "mp4box_out.mp4">> "%muxtracks_batfile_path%"
echo     if exist "mp4box_out.mp4" ^(>> "%muxtracks_batfile_path%"
echo         echo �����̓������������܂����B>> "%muxtracks_batfile_path%"
echo         rename "mp4box_out.mp4" "%%project_name%%.mp4">> "%muxtracks_batfile_path%"
echo         del "main_raw.mp4">> "%muxtracks_batfile_path%"
echo     ^) else ^(>> "%muxtracks_batfile_path%"
echo         echo �����̓����Ɏ��s�����͗l�ł��B�����O�̃t�@�C�����I���W�i���Ƃ��Ďg���܂��B>> "%muxtracks_batfile_path%"
echo         rename "main_raw.mp4" "%%project_name%%.mp4">> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo �����Ȃ�>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem # �ԑg���𒊏o���ACSV�t�@�C�����o�R����MP4�t�@�C���ɖ��ߍ��ލ�ƁB�\�[�X��TS�t�@�C���̏ꍇ�̂ݗL��
rem # �啶���������i�j�𐳋K�\���Řb���Ƃ��Ĉ����ƁA�ԑg�ɂ���Ă͐��������Ƃ��Ďg����ꍇ�����邽�ߖ��
rem echo "%tsrenamec_path%" "%input_media_path%" "@NT1'\[��\]'@NT2'\[��\]'@C'\[�V\]'@C'\[�I\]'@C'���V��'@C'���I��'@C'\[��\]'@C'\[��\]'@C'\[�f\]'@NT3'(#|��.+)'@NT4'�i.+�j'@C' |�@*��.+'@C' |�@*#.+'@C'�i.+�j'@MST@TT,@sb,@PT3@PT4,@YY,@PT1@PT2@YY�N@MM��@DD��,@CH,"^> "%%~dp0main.csv">> "%muxtracks_batfile_path%"
rem # @C'�i.+�j'���g�p����ƁA�u�v���Ɂi�j���܂܂�Ă���Ƃ��������Ȃ�͗l�B����Ďb��I�ɔr���B(2010/12/28)
rem echo "%tsrenamec_path%" "%input_media_path%" "@NT1'\[��\]'@NT2'\[��\]'@C'\[�V\]'@C'\[�I\]'@C'���V��'@C'���I��'@C'\[��\]'@C'\[��\]'@C'\[�f\]'@NT3'(#|��.+)'@NT4'��.+�b'@C' |�@*��.+'@C' |�@*#.+'@C'�i.+�j'@MST@TT,@sb,@PT3@PT4,@YY,@PT1@PT2@YY�N@MM��@DD��,@CH,"^> "main.csv">> "%muxtracks_batfile_path%"
echo rem # �ԑg���̒��o��MP4�t�@�C���ւ̓����t�F�[�Y>> "%muxtracks_batfile_path%"
echo if not exist "main.csv" ^(>> "%muxtracks_batfile_path%"
echo     if exist "%input_media_path%" ^(>> "%muxtracks_batfile_path%"
echo         echo tsrenamec��TS�t�@�C������ԑg���𒊏o���܂�>> "%muxtracks_batfile_path%"
echo         "%%tsrenamec_path%%" "%input_media_path%" "@NT1'\[��\]'@NT2'\[��\]'@C'\[�V\]'@C'\[�I\]'@C'���V��'@C'���I��'@C'\[��\]'@C'\[��\]'@C'\[�f\]'@NT3'(#|��.+)'@NT4'��.+�b'@C' |�@*��.+'@C' |�@*#.+'@MST@TT,@sb,@PT3@PT4,@YY,@PT1@PT2@YY�N@MM��@DD��,@CH,"^> "main.csv">> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
rem echo for /f "USEBACKQ tokens=1,2,3,4,5,6,7 delims=," %%%%a in ("main.csv") do (>> "%muxtracks_batfile_path%"
rem echo     "%%AtomicParsley_path%%" "%outputmp4_dir%%%project_name%%.mp4" --title "%%%%b" --album "%%%%a" --year "%%%%d" --grouping "%%%%f" --stik "TV Show" --description "%%%%e" --TVNetwork "%%%%f" --TVShowName "%%%%a" --TVEpisode "%%%%c%%%%b" --overWrite>> "%muxtracks_batfile_path%"
rem echo )>> "%muxtracks_batfile_path%"
rem # �f���~�^�[","�ŕ��������ۂɁA���g���u�����N�̗v�f������ƌ��̗v�f���J��オ���ĕϐ��ɑ������邽�߂����������邽�߂̏��Z
echo for /f "usebackq delims=" %%%%i in ("main.csv") do (>> "%muxtracks_batfile_path%"
echo     call :atomicparsley_phase %%%%i>> "%muxtracks_batfile_path%"
echo )>> "%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
echo rem # �o�͂��ꂽ�t�@�C�����ŏI�o�͐�t�H���_�Ɉړ����܂�>> "%muxtracks_batfile_path%"
echo if not "%%final_out_dir:~-1%%"=="\" ^(>> "%muxtracks_batfile_path%"
echo     set final_out_dir=%%final_out_dir%%\>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo if not exist "%%final_out_dir%%%%sub_folder_name%%" ^(>> "%muxtracks_batfile_path%"
echo     mkdir "%%final_out_dir%%%%sub_folder_name%%">> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo echo �ŏI�o�͐�t�H���_�Ƀt�@�C����]�����܂�>> "%muxtracks_batfile_path%"
echo if "%%copy_app_flag%%"=="fac" ^(>> "%muxtracks_batfile_path%"
echo     if exist "%%fac_path%%" ^(>> "%muxtracks_batfile_path%"
echo         echo FastCopy �ňړ������s���܂�>> "%muxtracks_batfile_path%"
echo         "%%fac_path%%" /cmd=move /force_close /disk_mode=auto "%%project_name%%.mp4" /to="%%final_out_dir%%%%sub_folder_name%%\">> "%muxtracks_batfile_path%"
echo     ^) else ^(>> "%muxtracks_batfile_path%"
echo         set copy_app_flag=copy>> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^) else if "%%copy_app_flag%%"=="ffc" ^(>> "%muxtracks_batfile_path%"
echo     if exist "%%ffc_path%%" ^(>> "%muxtracks_batfile_path%"
echo         echo FireFileCopy �ňړ������s���܂�>> "%muxtracks_batfile_path%"
echo         "%%ffc_path%%" "%%project_name%%.mp4" /move /a /bg /md /nk /ys /to:"%%final_out_dir%%%%sub_folder_name%%\">> "%muxtracks_batfile_path%"
echo     ^) else ^(>> "%muxtracks_batfile_path%"
echo         set copy_app_flag=copy>> "%muxtracks_batfile_path%"
echo     ^)>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo if "%%copy_app_flag%%"=="copy" ^(>> "%muxtracks_batfile_path%"
echo     echo �R�}���h�v�����v�g�W����move�R�}���h�ňړ������s���܂�>> "%muxtracks_batfile_path%"
echo     move /Y "%%project_name%%.mp4" "%%final_out_dir%%">> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo rem # �o�͐�t�@�C���̑��݊m�F>> "%muxtracks_batfile_path%"
echo if not exist "%%final_out_dir%%%%sub_folder_name%%\%%project_name%%.mp4" ^(>> "%muxtracks_batfile_path%"
echo    echo "%%project_name%%.mp4�̏o�͂Ɏ��s���܂���[%%time%%]"^>^>"%error_log_file%">> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo title �R�}���h �v�����v�g>> "%muxtracks_batfile_path%"
echo rem //----- main�I�� -----//>> "%muxtracks_batfile_path%"
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
echo     echo �p�����[�^�t�@�C���̒��Ƀr�f�I�G���R�[�h�̃R�[�f�b�N�w�肪������܂���B�b��[�u�Ƃ��āA.264���g�p���܂��B>> "%muxtracks_batfile_path%"
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
echo     echo �p�����[�^�t�@�C���̒��ɃI�[�f�B�I�̏����w�肪������܂���B�f�t�H���g��FAW���g�p���܂��B>> "%muxtracks_batfile_path%"
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
echo     echo �R�s�[�p�A�v���̃p�����[�^�[��������܂���A�f�t�H���g��copy�R�}���h���g�p���܂��B>> "%muxtracks_batfile_path%"
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
echo     echo �ŏI�t�@�C���̏o�͐�F%%out_dir_1st%%>> "%muxtracks_batfile_path%"
echo     set final_out_dir=%%out_dir_1st%%>> "%muxtracks_batfile_path%"
echo ^) else if exist "%%out_dir_2nd%%" ^(>> "%muxtracks_batfile_path%"
echo     echo �ŏI�t�@�C���̏o�͐�F%%out_dir_2nd%%>> "%muxtracks_batfile_path%"
echo     set final_out_dir=%%out_dir_2nd%%>> "%muxtracks_batfile_path%"
echo ^) else ^(>> "%muxtracks_batfile_path%"
echo     echo �ݒ肳��Ă���ŏI�t�@�C���̏o�͐�f�B���N�g������������݂��܂���B>> "%muxtracks_batfile_path%"
echo     echo ����Ƀ��[�U�[�̃z�[���f�B���N�g���ɏo�͂��܂��B>> "%muxtracks_batfile_path%"
echo     set final_out_dir=%%HOMEDRIVE%%\%%HOMEPATH%%>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo exit /b>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
rem ------------------------------
echo :zero-byte_error_check>> "%muxtracks_batfile_path%"
echo for %%%%F in ^("%%~1"^) do set tmp_mux-src_filesize=%%%%~zF>> "%muxtracks_batfile_path%"
echo echo %%~nx1 �t�@�C���T�C�Y�F %%tmp_mux-src_filesize%% byte>> "%muxtracks_batfile_path%"
echo if %%tmp_mux-src_filesize%% EQU 0 (>> "%muxtracks_batfile_path%"
echo     echo ���[���o�C�g�t�@�C������>> "%muxtracks_batfile_path%"
echo     set tmp-file_error_flag=^1>> "%muxtracks_batfile_path%
echo ^)>> "%muxtracks_batfile_path%"
echo exit /b>> "%muxtracks_batfile_path%"
echo.>> "%muxtracks_batfile_path%"
rem ------------------------------
echo :toolsdircheck>>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo ���ϐ� ENCTOOLSROOTPATH ������`�ł�>>"%muxtracks_batfile_path%"
echo     exit /b>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\>>"%muxtracks_batfile_path%"
echo if exist "%%ENCTOOLSROOTPATH%%" ^(>>"%muxtracks_batfile_path%"
echo     exit /b>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo ���ϐ�ENCTOOLSROOTPATH���L���ȃp�X�ł͂���܂���>>"%muxtracks_batfile_path%"
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
echo echo findexe�����F"%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo �T�����Ă��܂�...>>"%muxtracks_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo ������܂���>>"%muxtracks_batfile_path%"
echo         set muxer_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :muxer_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo :muxer_env_search>>"%muxtracks_batfile_path%"
echo set muxer_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%muxer_path%%"=="" ^(>>"%muxtracks_batfile_path%"
echo     echo muxer��������܂���>>"%muxtracks_batfile_path%"
echo     set muxer_path=%%~1>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_timelineeditor>>"%muxtracks_batfile_path%"
echo echo findexe�����F"%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo �T�����Ă��܂�...>>"%muxtracks_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo ������܂���>>"%muxtracks_batfile_path%"
echo         set timelineeditor_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :timelineeditor_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo :timelineeditor_env_search>>"%muxtracks_batfile_path%"
echo set timelineeditor_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%timelineeditor_path%%"=="" ^(>>"%muxtracks_batfile_path%"
echo     echo timelineeditor��������܂���>>"%muxtracks_batfile_path%"
echo     set timelineeditor_path=%%~1>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_DtsEdit>>"%muxtracks_batfile_path%"
echo echo findexe�����F"%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo �T�����Ă��܂�...>>"%muxtracks_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo ������܂���>>"%muxtracks_batfile_path%"
echo         set DtsEdit_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :DtsEdit_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo :DtsEdit_env_search>>"%muxtracks_batfile_path%"
echo set DtsEdit_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%DtsEdit_path%%"=="" ^(>>"%muxtracks_batfile_path%"
echo     echo DtsEdit��������܂���>>"%muxtracks_batfile_path%"
echo     set DtsEdit_path=%%~1>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_mp4box>>"%muxtracks_batfile_path%"
echo echo findexe�����F"%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo �T�����Ă��܂�...>>"%muxtracks_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo ������܂���>>"%muxtracks_batfile_path%"
echo         set mp4box_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :mp4box_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo :mp4box_env_search>>"%muxtracks_batfile_path%"
echo set mp4box_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%mp4box_path%%"=="" ^(>>"%muxtracks_batfile_path%"
echo     echo mp4box��������܂���>>"%muxtracks_batfile_path%"
echo     set mp4box_path=%%~1>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_mp4chaps>>"%muxtracks_batfile_path%"
echo echo findexe�����F"%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo �T�����Ă��܂�...>>"%muxtracks_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo ������܂���>>"%muxtracks_batfile_path%"
echo         set mp4chaps_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :mp4chaps_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo :mp4chaps_env_search>>"%muxtracks_batfile_path%"
echo set mp4chaps_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%mp4chaps_path%%"=="" ^(>>"%muxtracks_batfile_path%"
echo     echo mp4chaps��������܂���>>"%muxtracks_batfile_path%"
echo     set mp4chaps_path=%%~1>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_nkf>>"%muxtracks_batfile_path%"
echo echo findexe�����F"%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo �T�����Ă��܂�...>>"%muxtracks_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo ������܂���>>"%muxtracks_batfile_path%"
echo         set nkf_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :nkf_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo :nkf_env_search>>"%muxtracks_batfile_path%"
echo set nkf_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%nkf_path%%"=="" ^(>>"%muxtracks_batfile_path%"
echo     echo nkf��������܂���>>"%muxtracks_batfile_path%"
echo     set nkf_path=%%~1>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_AtomicParsley>>"%muxtracks_batfile_path%"
echo echo findexe�����F"%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo �T�����Ă��܂�...>>"%muxtracks_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo ������܂���>>"%muxtracks_batfile_path%"
echo         set AtomicParsley_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :AtomicParsley_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
echo :AtomicParsley_env_search>>"%muxtracks_batfile_path%"
echo set AtomicParsley_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%AtomicParsley_path%%"=="" ^(>>"%muxtracks_batfile_path%"
echo     echo AtomicParsley��������܂���>>"%muxtracks_batfile_path%"
echo     set AtomicParsley_path=%%~1>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_tsrenamec>>"%muxtracks_batfile_path%"
echo echo findexe�����F"%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo �T�����Ă��܂�...>>"%muxtracks_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo ������܂���>>"%muxtracks_batfile_path%"
echo         set tsrenamec_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :tsrenamec_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
echo :tsrenamec_env_search>>"%muxtracks_batfile_path%"
echo set tsrenamec_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%tsrenamec_path%%"=="" ^(>>"%muxtracks_batfile_path%"
echo     echo tsrenamec��������܂���>>"%muxtracks_batfile_path%"
echo     set tsrenamec_path=%%~1>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_ffc>>"%muxtracks_batfile_path%"
echo echo findexe�����F"%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo �T�����Ă��܂�...>>"%muxtracks_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo ������܂���>>"%muxtracks_batfile_path%"
echo         set ffc_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :ffc_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo :ffc_env_search>>"%muxtracks_batfile_path%"
echo set ffc_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%ffc_path%%"=="" echo FireFileCopy��������܂���A����ɃR�}���h�v�����v�g�W����copy�R�}���h���g�p���܂��B>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :find_fac>>"%muxtracks_batfile_path%"
echo echo findexe�����F"%%~1">>"%muxtracks_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^) else ^(>>"%muxtracks_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>>"%muxtracks_batfile_path%"
echo     echo �T�����Ă��܂�...>>"%muxtracks_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in ^(%%~nx1^) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>>"%muxtracks_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%muxtracks_batfile_path%"
echo         echo ������܂���>>"%muxtracks_batfile_path%"
echo         set fac_path=%%%%~E>>"%muxtracks_batfile_path%"
echo         exit /b>>"%muxtracks_batfile_path%"
echo     ^)>>"%muxtracks_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%muxtracks_batfile_path%"
echo ^)>>"%muxtracks_batfile_path%"
echo call :fac_env_search %%~nx1>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo :fac_env_search>>"%muxtracks_batfile_path%"
echo set fac_path=%%~$PATH:1>>"%muxtracks_batfile_path%"
echo if "%%fac_path%%"=="" echo FastCopy��������܂���A����ɃR�}���h�v�����v�g�W����copy�R�}���h���g�p���܂��B>>"%muxtracks_batfile_path%"
echo exit /b>>"%muxtracks_batfile_path%"
echo.>>"%muxtracks_batfile_path%"
rem ------------------------------
echo :atomicparsley_phase>> "%muxtracks_batfile_path%"
echo rem # AtomicParsley_path�p�̋^���֐�>> "%muxtracks_batfile_path%"
echo set t=%%*>> "%muxtracks_batfile_path%"
echo set t="%%t:,=","%%">> "%muxtracks_batfile_path%"
echo for /f "usebackq tokens=1-6 delims=," %%%%a in (`call echo %%%%t%%%%`) do (>> "%muxtracks_batfile_path%"
echo     echo �ԑg����AtomicParsley�œ������܂�>> "%muxtracks_batfile_path%"
echo     echo --title "%%%%~b" --album "%%%%~a" --year "%%%%~d" --grouping "%%%%~f" --stik "TV Show" --description "%%%%~e" --TVNetwork "%%%%~f" --TVShowName "%%%%~a" --TVEpisode "%%%%~c%%%%~b" --overWrite>> "%muxtracks_batfile_path%"
echo     "%%AtomicParsley_path%%" "%%project_name%%.mp4" --title "%%%%~b" --album "%%%%~a" --year "%%%%~d" --grouping "%%%%~f" --stik "TV Show" --description "%%%%~e" --TVNetwork "%%%%~f" --TVShowName "%%%%~a" --TVEpisode "%%%%~c%%%%~b" --overWrite>> "%muxtracks_batfile_path%"
echo ^)>> "%muxtracks_batfile_path%"
echo exit /b>> "%muxtracks_batfile_path%"
rem ------------------------------
exit /b


:srt_edit
rem # Caption2Ass_mod1�ŏo�͂��ꂽsrt�t�@�C���̕����R�[�h��UTF-8
rem # -tssp�I�v�V������������TsSplitter�ŉ����������ꂽ�t�@�C���̃^�C���R�[�h���������Ȃ�Ȃ�
rem # -forcepcr��forcePCR���[�h�A�I�v�V���������Ŏ��s�����ۂɑ傫���^�C���X�^���v���Y����ꍇ�̂ݎg�p����
rem # TsSplitter���g�p����Ƃ��̂�-tssp�I�v�V�������g�p���܂��B
if "%TsSplitter_flag%"=="1" (
    set caption2ass_tssp= -tssp
)
echo rem # �f�W�^�������̎������o�t�F�[�Y>>"%main_bat_file%"
echo call ".\bat\srt_edit.bat">>"%main_bat_file%"
echo.>>"%main_bat_file%"
type nul > "%srtedit_batfile_path%"
echo @echo off>> "%srtedit_batfile_path%"
echo setlocal>> "%srtedit_batfile_path%"
echo echo start %%~nx0 bat job...>> "%srtedit_batfile_path%"
echo chdir /d %%~dp0..\>> "%srtedit_batfile_path%"
echo.>> "%srtedit_batfile_path%"
echo rem # %%large_tmp_dir%% �̑��݊m�F����і����`�F�b�N>> "%srtedit_batfile_path%"
echo if not exist "%%large_tmp_dir%%" ^(>> "%srtedit_batfile_path%"
echo     echo �傫�ȃt�@�C�����o�͂���ꎞ�t�H���_ %%%%large_tmp_dir%%%% �����݂��܂���A����ɃV�X�e���̃e���|�����t�H���_�ő�p���܂��B>> "%srtedit_batfile_path%"
echo     set large_tmp_dir=%%tmp%%>> "%srtedit_batfile_path%"
echo ^)>> "%srtedit_batfile_path%"
echo if not "%%large_tmp_dir:~-1%%"=="\" set large_tmp_dir=%%large_tmp_dir%%\>> "%srtedit_batfile_path%"
echo rem # �G���R�[�h�c�[�����܂Ƃ߂��f�B���N�g�����������ϐ�ENCTOOLSROOTPATH����`����Ă��邩�m�F>>"%srtedit_batfile_path%"
echo call :toolsdircheck>>"%srtedit_batfile_path%"
echo rem # parameter�t�@�C�����̃\�[�X�t�@�C���ւ̃t���p�X^(src_file_path^)�����o>>"%srtedit_batfile_path%"
echo call :src_file_path_check>>"%srtedit_batfile_path%"
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o>>"%srtedit_batfile_path%"
echo call :project_name_check>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
echo rem # �e���s�t�@�C�������݂��邩�m�F�B���݂��Ȃ��ꍇENCTOOLSROOTPATH������T������A�������̓V�X�e���̒T���p�X�Ɉς˂�>>"%srtedit_batfile_path%"
echo if exist "%caption2Ass_path%" ^(set caption2Ass_path=%caption2Ass_path%^) else ^(call :find_caption2Ass "%caption2Ass_path%"^)>>"%srtedit_batfile_path%"
echo if exist "%SrtSync_path%" ^(set SrtSync_path=%SrtSync_path%^) else ^(call :find_SrtSync "%SrtSync_path%"^)>>"%srtedit_batfile_path%"
echo if exist "%nkf_path%" ^(set nkf_path=%nkf_path%^) else ^(call :find_nkf "%nkf_path%"^)>>"%srtedit_batfile_path%"
echo if exist "%sed_path%" ^(set sed_path=%sed_path%^) else ^(call :find_sed "%sed_path%"^)>>"%srtedit_batfile_path%"
echo if exist "%sedscript_path%" ^(set sedscript_path=%sedscript_path%^) else ^(call :find_sedscript "%sedscript_path%"^)>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
echo rem # �e����s�t�@�C���ւ̃p�X���A�ŏI�I�ɂǂ̂悤�Ȓl�ɂȂ������m�F�B>>"%srtedit_batfile_path%"
echo echo Caption2Ass: %%caption2Ass_path%%>>"%srtedit_batfile_path%"
echo echo SrtSync    : %%SrtSync_path%%>>"%srtedit_batfile_path%"
echo echo nkf        : %%nkf_path%%>>"%srtedit_batfile_path%"
echo echo Onigsed    : %%sed_path%%>>"%srtedit_batfile_path%"
echo echo sedscript  : %%sedscript_path%%>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
echo :main>>"%srtedit_batfile_path%"
echo rem //----- main�J�n -----//>>"%srtedit_batfile_path%"
echo title %%project_name%%>>"%srtedit_batfile_path%"
echo echo �f�W�^�������̎������o��. . .[%%time%%]>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
echo rem # Caption2Ass���g�p����TS�t�@�C�����玚���𒊏o���܂�>>"%srtedit_batfile_path%"
echo set /a caption2Ass_retrycount=^0>>"%srtedit_batfile_path%"
if "%kill_longecho_flag%"=="1" (
    echo if exist "%input_media_path%" ^(>>"%srtedit_batfile_path%"
    echo     echo "%input_media_path%" ���璊�o���܂�>>"%srtedit_batfile_path%"
    echo     "%%caption2Ass_path%%" -format srt%caption2ass_tssp% "%input_media_path%" "%%large_tmp_dir%%%%project_name%%.srt"^>nul>>"%srtedit_batfile_path%"
    echo ^) else if exist "%%src_file_path%%" ^(>>"%srtedit_batfile_path%"
    echo     echo "%%src_file_path%%" ���璊�o���܂�>>"%srtedit_batfile_path%"
    echo     "%%caption2Ass_path%%" -format srt%caption2ass_tssp% "%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.srt"^>nul>>"%srtedit_batfile_path%"
    echo ^) else ^(>>"%srtedit_batfile_path%"
    echo     echo �������𒊏o����\�[�X�ƂȂ�TS�t�@�C����������܂���B�����𒆒f���܂��B>>"%srtedit_batfile_path%"
    echo     exit /b>>"%srtedit_batfile_path%"
    echo ^)>>"%srtedit_batfile_path%"
) else (
    echo if exist "%input_media_path%" ^(>>"%srtedit_batfile_path%"
    echo     echo "%input_media_path%" ���璊�o���܂�>>"%srtedit_batfile_path%"
    echo     "%%caption2Ass_path%%" -format srt%caption2ass_tssp% "%input_media_path%" "%%large_tmp_dir%%%%project_name%%.srt">>"%srtedit_batfile_path%"
    echo ^) else if exist "%%src_file_path%%" ^(>>"%srtedit_batfile_path%"
    echo     echo "%%src_file_path%%" ���璊�o���܂�>>"%srtedit_batfile_path%"
    echo     "%%caption2Ass_path%%" -format srt%caption2ass_tssp% "%%src_file_path%%" "%%large_tmp_dir%%%%project_name%%.srt">>"%srtedit_batfile_path%"
    echo ^) else ^(>>"%srtedit_batfile_path%"
    echo     echo �������𒊏o����\�[�X�ƂȂ�TS�t�@�C����������܂���B�����𒆒f���܂��B>>"%srtedit_batfile_path%"
    echo     exit /b>>"%srtedit_batfile_path%"
    echo ^)>>"%srtedit_batfile_path%"
)
echo call :Srt_filesize_check>>"%srtedit_batfile_path%"
echo title �R�}���h �v�����v�g>>"%srtedit_batfile_path%"
echo rem //----- main�I�� -----//>>"%srtedit_batfile_path%"
echo echo end %%~nx0 bat job...>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :toolsdircheck>>"%srtedit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%srtedit_batfile_path%"
echo     echo ���ϐ� ENCTOOLSROOTPATH ������`�ł�>>"%srtedit_batfile_path%"
echo     exit /b>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\>>"%srtedit_batfile_path%"
echo if exist "%%ENCTOOLSROOTPATH%%" ^(>>"%srtedit_batfile_path%"
echo     exit /b>>"%srtedit_batfile_path%"
echo ^) else ^(>>"%srtedit_batfile_path%"
echo     echo ���ϐ�ENCTOOLSROOTPATH���L���ȃp�X�ł͂���܂���>>"%srtedit_batfile_path%"
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
echo echo findexe�����F"%%~1">>"%srtedit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%srtedit_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%srtedit_batfile_path%"
echo ^) else ^(>>"%srtedit_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>>"%srtedit_batfile_path%"
echo     echo �T�����Ă��܂�...>>"%srtedit_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>>"%srtedit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%srtedit_batfile_path%"
echo         echo ������܂���>>"%srtedit_batfile_path%"
echo         set caption2Ass_path=%%%%~E>>"%srtedit_batfile_path%"
echo         exit /b>>"%srtedit_batfile_path%"
echo     ^)>>"%srtedit_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo call :caption2Ass_env_search "%%~nx1">>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo :caption2Ass_env_search>>"%srtedit_batfile_path%"
echo set caption2Ass_path=%%~$PATH:1>>"%srtedit_batfile_path%"
echo if "%%caption2Ass_path%%"=="" ^(>>"%srtedit_batfile_path%"
echo     echo Caption2Ass��������܂���>>"%srtedit_batfile_path%"
echo     set caption2Ass_path=%%~1>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :find_SrtSync>>"%srtedit_batfile_path%"
echo echo findexe�����F"%%~1">>"%srtedit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%srtedit_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%srtedit_batfile_path%"
echo ^) else ^(>>"%srtedit_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>>"%srtedit_batfile_path%"
echo     echo �T�����Ă��܂�...>>"%srtedit_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>>"%srtedit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%srtedit_batfile_path%"
echo         echo ������܂���>>"%srtedit_batfile_path%"
echo         set SrtSync_path=%%%%~E>>"%srtedit_batfile_path%"
echo         exit /b>>"%srtedit_batfile_path%"
echo     ^)>>"%srtedit_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo call :SrtSync_env_search "%%~nx1">>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo :SrtSync_env_search>>"%srtedit_batfile_path%"
echo set SrtSync_path=%%~$PATH:1>>"%srtedit_batfile_path%"
echo if "%%SrtSync_path%%"=="" ^(>>"%srtedit_batfile_path%"
echo     echo SrtSync��������܂���>>"%srtedit_batfile_path%"
echo     set SrtSync_path=%%~1>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :find_nkf>>"%srtedit_batfile_path%"
echo echo findexe�����F"%%~1">>"%srtedit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%srtedit_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%srtedit_batfile_path%"
echo ^) else ^(>>"%srtedit_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>>"%srtedit_batfile_path%"
echo     echo �T�����Ă��܂�...>>"%srtedit_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>>"%srtedit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%srtedit_batfile_path%"
echo         echo ������܂���>>"%srtedit_batfile_path%"
echo         set nkf_path=%%%%~E>>"%srtedit_batfile_path%"
echo         exit /b>>"%srtedit_batfile_path%"
echo     ^)>>"%srtedit_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo call :nkf_env_search "%%~nx1">>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo :nkf_env_search>>"%srtedit_batfile_path%"
echo set nkf_path=%%~$PATH:1>>"%srtedit_batfile_path%"
echo if "%%nkf_path%%"=="" ^(>>"%srtedit_batfile_path%"
echo     echo nkf��������܂���>>"%srtedit_batfile_path%"
echo     set nkf_path=%%~1>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :find_sed>>"%srtedit_batfile_path%"
echo echo findexe�����F"%%~1">>"%srtedit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%srtedit_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%srtedit_batfile_path%"
echo ^) else ^(>>"%srtedit_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>>"%srtedit_batfile_path%"
echo     echo �T�����Ă��܂�...>>"%srtedit_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>>"%srtedit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%srtedit_batfile_path%"
echo         echo ������܂���>>"%srtedit_batfile_path%"
echo         set sed_path=%%%%~E>>"%srtedit_batfile_path%"
echo         exit /b>>"%srtedit_batfile_path%"
echo     ^)>>"%srtedit_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo call :sed_env_search "%%~nx1">>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo :sed_env_search>>"%srtedit_batfile_path%"
echo set sed_path=%%~$PATH:1>>"%srtedit_batfile_path%"
echo if "%%sed_path%%"=="" ^(>>"%srtedit_batfile_path%"
echo     echo Onigsed��������܂���>>"%srtedit_batfile_path%"
echo     set sed_path=%%~1>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :find_sedscript>>"%srtedit_batfile_path%"
echo echo findexe�����F"%%~1">>"%srtedit_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>>"%srtedit_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%srtedit_batfile_path%"
echo ^) else ^(>>"%srtedit_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>>"%srtedit_batfile_path%"
echo     echo �T�����Ă��܂�...>>"%srtedit_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>>"%srtedit_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>>"%srtedit_batfile_path%"
echo         echo ������܂���>>"%srtedit_batfile_path%"
echo         set sedscript_path=%%%%~E>>"%srtedit_batfile_path%"
echo         exit /b>>"%srtedit_batfile_path%"
echo     ^)>>"%srtedit_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo call :sedscript_env_search "%%~nx1">>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo :sedscript_env_search>>"%srtedit_batfile_path%"
echo set sedscript_path=%%~$PATH:1>>"%srtedit_batfile_path%"
echo if "%%sedscript_path%%"=="" ^(>>"%srtedit_batfile_path%"
echo     echo sedscript��������܂���>>"%srtedit_batfile_path%"
echo     set sedscript_path=%%~1>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :Srt_filesize_check>>"%srtedit_batfile_path%"
echo rem # srt�t�@�C���̃t�@�C���T�C�Y��3�o�C�g�ȏ�ł���Ύ������܂܂�Ă����Ɣ��f���܂�>>"%srtedit_batfile_path%"
echo for %%%%F in ^("%%large_tmp_dir%%%%project_name%%.srt"^) do set srt_filesize=%%%%~zF>>"%srtedit_batfile_path%"
echo if %%srt_filesize%% GTR 3 ^(>>"%srtedit_batfile_path%"
rem # ��L�̔�r�������""�ł�����Ɛ��l�ł͂Ȃ�������Ƃ��ď�������A���ʌ������r����̂Ŗ�肪�o�� ex)"10" GTR "3"
echo     call :search_unknown_char>>"%srtedit_batfile_path%"
echo     call :SrtCutter>>"%srtedit_batfile_path%"
echo ^) else ^(>>"%srtedit_batfile_path%"
echo     echo �������݂͂���܂���ł�����>>"%srtedit_batfile_path%"
echo     del "%%large_tmp_dir%%%%project_name%%.srt">>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :search_unknown_char>> "%srtedit_batfile_path%"
echo rem # �o�͂��ꂽsrt�t�@�C���̒��ɊO����p���t�H���g��\��"[�O"���܂܂�Ă��Ȃ����`�F�b�N���܂�>>"%srtedit_batfile_path%"
rem     # �o�͂��ꂽ�����t�@�C���̒��ɖ��m�̊O����p���t�H���g���������T��
rem     # findstr�R�}���h�́A�Ώۂ�Shift_JIS�łȂ���΋@�\���Ȃ��B/N�ōs�ԍ��I�v�V����
echo findstr /N "[�O" "%%large_tmp_dir%%%%project_name%%.srt"^>^> "%%large_tmp_dir%%%%project_name%%_sub.log">> "%srtedit_batfile_path%"
echo for %%%%F in ^("%%large_tmp_dir%%%%project_name%%_sub.log"^) do set srtlog_filesize=%%%%~zF>> "%srtedit_batfile_path%"
rem     # findstr�ɂ���ďo�͂��ꂽ���O���L��(3�o�C�g�ȏ�)�Ȃ瓝���A��Ȃ�j������
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
echo rem # Trim�ҏW���ꂽ�`�Ղ����邩�`�F�b�N>>"%srtedit_batfile_path%"
rem # SrtSync�ŏo�͂��ꂽsrt�t�@�C���̕����R�[�h��Shift_JIS
echo for /f "usebackq eol=# tokens=1 delims=*" %%%%S in ^(`findstr /r Trim^^^(.*^^^) "trim_line.txt"`^) do ^(>> "%srtedit_batfile_path%"
echo     set search_trimline=%%%%S>> "%srtedit_batfile_path%"
echo ^)>> "%srtedit_batfile_path%"
echo if "%%search_trimline%%"=="" ^(>> "%srtedit_batfile_path%"
echo     echo ��Trim�ҏW�Ȃ���>> "%srtedit_batfile_path%"
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
echo rem # Trim�R�}���h��ǂݍ����srt�t�@�C���̕K�v�ꏊ�����J�b�g���܂�>>"%srtedit_batfile_path%"
echo "%%SrtSync_path%%" -mode auto -nopause -trim "trim_line.txt" "%%large_tmp_dir%%%%project_name%%.srt">>"%srtedit_batfile_path%"
echo for %%%%N in ^("%%large_tmp_dir%%%%project_name%%_new.srt"^) do set newsrt_filesize=%%%%~zN>>"%srtedit_batfile_path%"
echo if not %%newsrt_filesize%%==0 ^(>> "%srtedit_batfile_path%"
echo     echo ���w��͈͂Ɏ������聦>>"%srtedit_batfile_path%"
echo     move "%%large_tmp_dir%%%%project_name%%_new.srt" ".\tmp\main_sjis.srt">>"%srtedit_batfile_path%"
echo     move "%%large_tmp_dir%%%%project_name%%.srt" ".\log\exported.srt">>"%srtedit_batfile_path%"
rem     # ASS�������o�͂���ݒ肪�L���ɂȂ��Ă����ꍇ�̂�ASS���o�͂���
rem     # srt�����̏o�͂��I���A�L���͈͂Ɏ��������݂��邱�Ƃ��m�F����Ă���o�͂���
rem     # �������A����Trim�ɂ��킹���J�b�g�ҏW�̎�i���������킹�Ă��Ȃ�
if "%output_ass_flag%"=="1" (
    echo     echo ASS�t�@�C���𒊏o���܂�>>"%srtedit_batfile_path%"
    if "%kill_longecho_flag%"=="1" (
        rem echo     start "�����̒��o��..." /wait "%%caption2Ass_path%%" -format ass%caption2ass_tssp% "%input_media_path%" "%%large_tmp_dir%%%%project_name%%.ass">>"%srtedit_batfile_path%"
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
echo     echo ���w��͈͂Ɏ����Ȃ��A-forcepcr�I�v�V�����t���ōēx���s���܂���>> "%srtedit_batfile_path%"
echo     if %%caption2Ass_retrycount%%==0 ^(>>"%srtedit_batfile_path%"
echo         move "%%large_tmp_dir%%%%project_name%%.srt" ".\tmp\exported_noforcepcr.srt">> "%srtedit_batfile_path%"
echo         del "%%large_tmp_dir%%%%project_name%%_new.srt">> "%srtedit_batfile_path%"
echo         call :Re-caption2Ass>> "%srtedit_batfile_path%"
echo     ^) else ^(>>"%srtedit_batfile_path%"
echo         echo ����Caption2Ass�Ń��g���C�ςׁ݂̈A�����𒆒f���܂�>>"%srtedit_batfile_path%"
echo         move "%%large_tmp_dir%%%%project_name%%.srt" ".\tmp\exported_forcepcr.srt">> "%srtedit_batfile_path%"
echo         del "%%large_tmp_dir%%%%project_name%%_new.srt">> "%srtedit_batfile_path%"
echo     ^)>>"%srtedit_batfile_path%"
echo ^)>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
echo.>>"%srtedit_batfile_path%"
rem ------------------------------
echo :Re-caption2Ass>> "%srtedit_batfile_path%"
echo rem # �H�ɏo�͂��ꂽsrt�t�@�C�����̎��Ԃ��傫���Y���鎖������̂ŁA-forcepcr�I�v�V�����t���Ń��g���C���܂�>>"%srtedit_batfile_path%"
echo rem # -tssp�I�v�V������-forcepcr�I�v�V�����ƕ��p�����SrtSync�̏o�͂�NULL�ɂȂ�P�[�X������̂Ŏg�p���Ȃ�����>>"%srtedit_batfile_path%"
echo "%%caption2Ass_path%%" -format srt -forcepcr "%input_media_path%" "%%large_tmp_dir%%%%project_name%%.srt"^>nul>>"%srtedit_batfile_path%"
echo set /a caption2Ass_retrycount=%caption2Ass_retrycount%+^1>>"%srtedit_batfile_path%"
echo call :SubEdit_phase>>"%srtedit_batfile_path%"
echo exit /b>>"%srtedit_batfile_path%"
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
rem # x264/x265�ɂ��G���R�[�h�ݒ���������ދ[���֐�
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
    echo �� �v���t�@�C�����x���̎w�肪����܂���I ��
    set x264_VUI_opt=--videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 
    set x265_VUI_opt=--videoformat ntsc --colorprim bt709 --transfer bt709 --colormatrix bt709 
    set qsv_VUI_opt=--videoformat ntsc --colormatrix bt709 --colorprim bt709 --transfer bt709 
    set nvenc_VUI_opt=--videoformat ntsc --colormatrix bt709 --colorprim bt709 --transfer bt709 
    set x264_Encode_option=%x264_HP@L40_option%
    set x265_Encode_option=%x265_MP@L40_option%
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
echo @echo off>> "%video_encode_batfile_path%"
echo setlocal>> "%video_encode_batfile_path%"
echo echo start %%~nx0 bat job...>> "%video_encode_batfile_path%"
echo cd /d %%~dp0..\>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
echo rem # �g�p����G���R�[�_�[�̃^�C�v���w�肵�܂�>> "%video_encode_batfile_path%"
echo call :video_codecparam_detect>> "%video_encode_batfile_path%"
echo rem x264, x265, qsv_h264, qsv_hevc, nvenc_h264, nvenc_hevc>> "%video_encode_batfile_path%"
echo rem set video_encoder_type=%video_encoder_type%>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
echo rem # x264, x265, QSVEncC, NVEncC�̃G���R�[�h�I�v�V������ݒ�>> "%video_encode_batfile_path%"
echo call :x264_encparam_detect>> "%video_encode_batfile_path%"
echo rem set x264_enc_param=%x264_Encode_option% %video_sar_option%%x264_VUI_opt%%x264_keyint% %x264_interlace_option%>> "%video_encode_batfile_path%"
echo call :x265_encparam_detect>> "%video_encode_batfile_path%"
echo rem set x265_enc_param=%x265_Encode_option% %video_sar_option%%x265_VUI_opt%>> "%video_encode_batfile_path%"
echo call :qsv_encparam_detect>> "%video_encode_batfile_path%"
echo rem set qsv_enc_param=%qsv_Encode_option% %video_sar_option%%qsv_VUI_opt%>> "%video_encode_batfile_path%"
echo call :nvenc_encparam_detect>> "%video_encode_batfile_path%"
echo rem set nvenc_enc_param=%nvenc_Encode_option% %video_sar_option%%nvenc_VUI_opt%>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
echo rem # �G���R�[�h�c�[�����܂Ƃ߂��f�B���N�g�����������ϐ�ENCTOOLSROOTPATH����`����Ă��邩�m�F>> "%video_encode_batfile_path%"
echo call :toolsdircheck>> "%video_encode_batfile_path%"
echo rem # parameter�t�@�C�����̃v���W�F�N�g��^(project_name^)�����o>> "%video_encode_batfile_path%"
echo call :project_name_check>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
echo rem # �e���s�t�@�C�������݂��邩�m�F�B���݂��Ȃ��ꍇENCTOOLSROOTPATH������T������A�������̓V�X�e���̒T���p�X�Ɉς˂�>> "%video_encode_batfile_path%"
echo if exist "%x264_path%" ^(set x264_path=%x264_path%^) else ^(call :find_x264 "%x264_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%x265_path%" ^(set x265_path=%x265_path%^) else ^(call :find_x265 "%x265_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%qsvencc_path%" ^(set qsvencc_path=%qsvencc_path%^) else ^(call :find_qsvencc "%qsvencc_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%nvencc_path%" ^(set nvencc_path=%nvencc_path%^) else ^(call :find_qsvencc "%nvencc_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%avs4x26x_path%" ^(set avs4x26x_path=%avs4x26x_path%^) else ^(call :find_avs4x26x "%avs4x26x_path%"^)>> "%video_encode_batfile_path%"
echo if exist "%avs2pipe_path%" ^(set avs2pipe_path=%avs2pipe_path%^) else ^(call :find_avs2pipe "%avs2pipe_path%"^)>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
echo rem # �e����s�t�@�C���ւ̃p�X���A�ŏI�I�ɂǂ̂悤�Ȓl�ɂȂ������m�F�B>> "%video_encode_batfile_path%"
echo echo x264    : %%x264_path%%>> "%video_encode_batfile_path%"
echo echo x265    : %%x265_path%%>> "%video_encode_batfile_path%"
echo echo QSVEncC : %%qsvencc_path%%>> "%video_encode_batfile_path%"
echo echo NVEncC  : %%nvencc_path%%>> "%video_encode_batfile_path%"
echo echo avs4x26x: %%avs4x26x_path%%>> "%video_encode_batfile_path%"
echo echo avs2pipe: %%avs2pipe_path%%>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
echo rem # �G���R�[�h�I�v�V�����I�[�␳>> "%video_encode_batfile_path%"
echo if not "%%x264_enc_param:~-1%%"==" " set x264_enc_param=%%x264_enc_param%% >> "%video_encode_batfile_path%"
echo if not "%%x265_enc_param:~-1%%"==" " set x265_enc_param=%%x265_enc_param%% >> "%video_encode_batfile_path%"
echo if not "%%qsv_enc_param:~-1%%"==" " set qsv_enc_param=%%qsv_enc_param%% >> "%video_encode_batfile_path%"
echo if not "%%nvenc_enc_param:~-1%%"==" " set nvenc_enc_param=%%nvenc_enc_param%% >> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
echo :main>> "%video_encode_batfile_path%"
echo rem //----- main�J�n -----//>> "%video_encode_batfile_path%"
echo title %%project_name%%>> "%video_encode_batfile_path%"
echo rem # ����G���R�[�h���s�t�F�[�Y>> "%video_encode_batfile_path%"
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
echo title �R�}���h �v�����v�g>> "%video_encode_batfile_path%"
echo rem //----- main�I�� -----//>> "%video_encode_batfile_path%"
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
echo     echo �r�f�I�G���R�[�h�̃R�[�f�b�N�w�肪������܂���B����Ƀf�t�H���g��x264���g�p���܂��B>> "%video_encode_batfile_path%"
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
echo     echo ��QSVEnc�Ŏ��s�\�Ȋ��������ׁA�����x264�ŃG���R�[�h���܂�>> "%video_encode_batfile_path%"
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
echo     echo ��QSVEnc�Ŏ��s�\�Ȋ��������ׁA�����x265�ŃG���R�[�h���܂�>> "%video_encode_batfile_path%"
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
echo     echo ��NVEnc�Ŏ��s�\�Ȋ��������ׁA�����x264�ŃG���R�[�h���܂�>> "%video_encode_batfile_path%"
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
echo     echo ��NVEnc�Ŏ��s�\�Ȋ��������ׁA�����x265�ŃG���R�[�h���܂�>> "%video_encode_batfile_path%"
echo     call :x265_exec_phase>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :x264_exec_phase>> "%video_encode_batfile_path%"
echo echo x264�G���R�[�h. . .[%%time%%]>> "%video_encode_batfile_path%"
echo %bat_start_wait%"%%avs4x26x_path%%" -L "%%x264_path%%" %%x264_enc_param%%--output ".\tmp\main_temp.264" "main.avs">> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :x265_exec_phase>> "%video_encode_batfile_path%"
echo echo x265�G���R�[�h. . .[%%time%%]>> "%video_encode_batfile_path%"
echo %bat_start_wait%"%%avs4x26x_path%%" -L "%%x265_path%%" %%x265_enc_param%%-o ".\tmp\main_temp.265" "main.avs">> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :qsv_h264_exec_phase>> "%video_encode_batfile_path%"
echo echo QSVEncC^^^(H.264/AVC^^^)�G���R�[�h. . .[%%time%%]>> "%video_encode_batfile_path%"
echo %bat_start_wait%"%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%qsvencc_path%%" %%qsv_enc_param%%--codec h264 -i - -o ".\tmp\main_temp.264" >> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :qsv_hevc_exec_phase>> "%video_encode_batfile_path%"
echo echo QSVEncC^^^(H.265/HEVC^^^)�G���R�[�h. . .[%%time%%]>> "%video_encode_batfile_path%"
echo %bat_start_wait%"%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%qsvencc_path%%" %%qsv_enc_param%%--codec hevc -i - -o ".\tmp\main_temp.265" >> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :nvenc_h264_exec_phase>> "%video_encode_batfile_path%"
echo echo NVEncC^^^(H.264/AVC^^^)�G���R�[�h. . .[%%time%%]>> "%video_encode_batfile_path%"
echo %bat_start_wait%"%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%nvencc_path%%" %%nvenc_enc_param%%--codec h264 -i - -o ".\tmp\main_temp.264" >> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :nvenc_hevc_exec_phase>> "%video_encode_batfile_path%"
echo echo NVEncC^^^(H.265/HEVC^^^)�G���R�[�h. . .[%%time%%]>> "%video_encode_batfile_path%"
echo %bat_start_wait%"%%avs2pipe_path%%" -y4mp "main.avs" ^| "%%nvencc_path%%" %%nvenc_enc_param%%--codec hevc -i - -o ".\tmp\main_temp.265" >> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :toolsdircheck>> "%video_encode_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%video_encode_batfile_path%"
echo     echo ���ϐ� ENCTOOLSROOTPATH ������`�ł�>> "%video_encode_batfile_path%"
echo     exit /b>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo if not "%%ENCTOOLSROOTPATH:~-1%%"=="\" set ENCTOOLSROOTPATH=%%ENCTOOLSROOTPATH%%\>> "%video_encode_batfile_path%"
echo if exist "%%ENCTOOLSROOTPATH%%" ^(>> "%video_encode_batfile_path%"
echo     exit /b>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo ���ϐ�ENCTOOLSROOTPATH���L���ȃp�X�ł͂���܂���>> "%video_encode_batfile_path%"
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
echo echo findexe�����F"%%~1">> "%video_encode_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%video_encode_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%video_encode_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%video_encode_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%video_encode_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%video_encode_batfile_path%"
echo         echo ������܂���>> "%video_encode_batfile_path%"
echo         set x264_path=%%%%~E>> "%video_encode_batfile_path%"
echo         exit /b>> "%video_encode_batfile_path%"
echo     ^)>> "%video_encode_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo call :x264_env_search "%%~nx1">> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo :x264_env_search>> "%video_encode_batfile_path%"
echo set x264_path=%%~$PATH:1>> "%video_encode_batfile_path%"
echo if "%%x264_path%%"=="" ^(>> "%video_encode_batfile_path%"
echo     echo x264��������܂���>> "%video_encode_batfile_path%"
echo     set x264_path=%%~1>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :find_x265>> "%video_encode_batfile_path%"
echo echo findexe�����F"%%~1">> "%video_encode_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%video_encode_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%video_encode_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%video_encode_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%video_encode_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%video_encode_batfile_path%"
echo         echo ������܂���>> "%video_encode_batfile_path%"
echo         set x265_path=%%%%~E>> "%video_encode_batfile_path%"
echo         exit /b>> "%video_encode_batfile_path%"
echo     ^)>> "%video_encode_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo call :x265_env_search "%%~nx1">> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo :x265_env_search>> "%video_encode_batfile_path%"
echo set x265_path=%%~$PATH:1>> "%video_encode_batfile_path%"
echo if "%%x265_path%%"=="" ^(>> "%video_encode_batfile_path%"
echo    echo x265��������܂���>> "%video_encode_batfile_path%"
echo     set x265_path=%%~1>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :find_qsvencc>> "%video_encode_batfile_path%"
echo echo findexe�����F"%%~1">> "%video_encode_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%video_encode_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%video_encode_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%video_encode_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%video_encode_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%video_encode_batfile_path%"
echo         echo ������܂���>> "%video_encode_batfile_path%"
echo         set qsvencc_path=%%%%~E>> "%video_encode_batfile_path%"
echo         exit /b>> "%video_encode_batfile_path%"
echo     ^)>> "%video_encode_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo call :qsvencc_env_search "%%~nx1">> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo :qsvencc_env_search>> "%video_encode_batfile_path%"
echo set qsvencc_path=%%~$PATH:1>> "%video_encode_batfile_path%"
echo if "%%qsvencc_path%%"=="" ^(>> "%video_encode_batfile_path%"
echo    echo QSVEncC��������܂���>> "%video_encode_batfile_path%"
echo     set qsvencc_path=%%~1>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :find_nvencc>> "%video_encode_batfile_path%"
echo echo findexe�����F"%%~1">> "%video_encode_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%video_encode_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%video_encode_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%video_encode_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%video_encode_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%video_encode_batfile_path%"
echo         echo ������܂���>> "%video_encode_batfile_path%"
echo         set nvencc_path=%%%%~E>> "%video_encode_batfile_path%"
echo         exit /b>> "%video_encode_batfile_path%"
echo     ^)>> "%video_encode_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo call :nvencc_env_search "%%~nx1">> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo :nvencc_env_search>> "%video_encode_batfile_path%"
echo set nvencc_path=%%~$PATH:1>> "%video_encode_batfile_path%"
echo if "%%nvencc_path%%"=="" ^(>> "%video_encode_batfile_path%"
echo    echo NVEncC��������܂���>> "%video_encode_batfile_path%"
echo     set nvencc_path=%%~1>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :find_avs4x26x>> "%video_encode_batfile_path%"
echo echo findexe�����F"%%~1">> "%video_encode_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%video_encode_batfile_path%"
echo     echo �T���f�B���N�g��������`�ł��A�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%video_encode_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%video_encode_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%video_encode_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%video_encode_batfile_path%"
echo         echo ������܂���>> "%video_encode_batfile_path%"
echo         set avs4x26x_path=%%%%~E>> "%video_encode_batfile_path%"
echo         exit /b>> "%video_encode_batfile_path%"
echo     ^)>> "%video_encode_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo call :avs4x26x_env_search "%%~nx1">> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo :avs4x26x_env_search>> "%video_encode_batfile_path%"
echo set avs4x26x_path=%%~$PATH:1>> "%video_encode_batfile_path%"
echo if "%%avs4x26x_path%%"=="" ^(>> "%video_encode_batfile_path%"
echo     echo avs4x26x��������܂���>> "%video_encode_batfile_path%"
echo     set avs4x26x_path=%%~1>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo :find_avs2pipe>> "%video_encode_batfile_path%"
echo echo findexe�����F"%%~1">> "%video_encode_batfile_path%"
echo if not defined ENCTOOLSROOTPATH ^(>> "%video_encode_batfile_path%"
echo     set avs2pipe_path=%%~nx1>> "%video_encode_batfile_path%"
echo ^) else ^(>> "%video_encode_batfile_path%"
echo     echo �T���f�B���N�g���F%%ENCTOOLSROOTPATH%%>> "%video_encode_batfile_path%"
echo     echo �T�����Ă��܂�...>> "%video_encode_batfile_path%"
echo     rem # for /r "�f�B���N�g��" %%%%E in (%%~nx1) �̃R�}���h�ł͂Ȃ������݂��Ȃ��t�@�C�������������ƂɂȂ��Ă��܂����̂ŁAdir�R�}���h�ƕ��p>> "%video_encode_batfile_path%"
echo     for /f "usebackq tokens=1 delims=*" %%%%E in ^(`dir "%%ENCTOOLSROOTPATH%%%%~nx1" /b /a-d /s`^) do ^(>> "%video_encode_batfile_path%"
echo         echo ������܂���>> "%video_encode_batfile_path%"
echo         set avs2pipe_path=%%%%~E>> "%video_encode_batfile_path%"
echo         exit /b>> "%video_encode_batfile_path%"
echo     ^)>> "%video_encode_batfile_path%"
echo     echo ������܂���ł����B�V�X�e���̃p�X�T���Ɉς˂܂��B>> "%video_encode_batfile_path%"
echo     call :avspipe_env_search %%~nx1>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo :avspipe_env_search>> "%video_encode_batfile_path%"
echo set avs2pipe_path=%%~$PATH:1>> "%video_encode_batfile_path%"
echo if "%%avs2pipe_path%%"=="" ^(>> "%video_encode_batfile_path%"
echo     echo avs2pipe��������܂���>> "%video_encode_batfile_path%"
echo     set avs2pipe_path=%%~1>> "%video_encode_batfile_path%"
echo ^)>> "%video_encode_batfile_path%"
echo exit /b>> "%video_encode_batfile_path%"
echo.>> "%video_encode_batfile_path%"
rem ------------------------------
echo.
if "%video_encoder_type%"=="x264" (
    echo ### x264 �̏����o�� ###
    echo �ݒ�F%bat_start_wait%"%avs4x26x_path%" -L "%x264_path%" %x264_Encode_option% %video_sar_option%%x264_VUI_opt%%x264_keyint% %x264_interlace_option%--output ".\tmp\main_temp.264" "main.avs"
) else if "%video_encoder_type%"=="x265" (
    echo ### x265 �̏����o�� ###
    echo �ݒ�F%bat_start_wait%"%avs4x26x_path%" -L "%x265_path%" %x265_Encode_option% %video_sar_option%%x265_VUI_opt%-o ".\tmp\main_temp.265" "main.avs"
) else if "%video_encoder_type%"=="qsv_h264" (
    echo ### QSVEncC^(H.264/AVC^) �̏����o�� ###
    echo �ݒ�F%bat_start_wait%"%avs2pipe_path%" -y4mp "main.avs" ^| "%qsvencc_path%" %qsv_Encode_option% %video_sar_option%%qsv_VUI_opt%--codec h264 -i - -o ".\tmp\main_temp.264"
) else if "%video_encoder_type%"=="qsv_hevc" (
    echo ### QSVEncC^(H.265/HEVC^) �̏����o�� ###
    echo �ݒ�F%bat_start_wait%"%avs2pipe_path%" -y4mp "main.avs" ^| "%qsvencc_path%" %qsv_Encode_option% %video_sar_option%%qsv_VUI_opt%--codec hevc -i - -o ".\tmp\main_temp.265"
) else if "%video_encoder_type%"=="nvenc_h264" (
    echo ### NVEncC^(H.264/AVC^) �̏����o�� ###
    echo �ݒ�F%bat_start_wait%"%avs2pipe_path%" -y4mp "main.avs" ^| "%nvencc_path%" %nvenc_Encode_option% %video_sar_option%%nvenc_VUI_opt%--codec h264 -i - -o ".\tmp\main_temp.264"
) else if "%video_encoder_type%"=="nvenc_hevc" (
    echo ### NVEncC^(H.265/HEVC^) �̏����o�� ###
    echo �ݒ�F%bat_start_wait%"%avs2pipe_path%" -y4mp "main.avs" ^| "%nvencc_path%" %nvenc_Encode_option% %video_sar_option%%nvenc_VUI_opt%--codec hevc -i - -o ".\tmp\main_temp.265"
)
exit /b


:load_mpeg2ts_source
rem ### �\�[�X��TS�t�@�C���̏ꍇ�̓ǂݍ��݃t�B���^���쐬����[���֐�
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
echo ##### �J�b�g�ҏW #####>> "%work_dir%%main_project_name%\main.avs"
echo # �P��s�ŕ\�L����Trim�R�}���h�͂����ȉ��ɋL�����Ă�������>> "%work_dir%%main_project_name%\main.avs"
echo Import^("trim_line.txt"^)    # ��sTrim�\�L>> "%work_dir%%main_project_name%\main.avs"
echo #Trim^(0,99^) ++ Trim^(200,299^) ++ Trim^(300,399^)>> "%work_dir%%main_project_name%\main.avs"
echo ### ��s�ŕ\�L����Trim�R�}���h�͂����ɋL�����Ă������� ###>> "%work_dir%%main_project_name%\trim_line.txt"
echo.>> "%work_dir%%main_project_name%\main.avs"
echo # �����s�ŕ\�L����Trim�R�}���h�͂����ȉ��ɋL�����Ă�������>> "%work_dir%%main_project_name%\main.avs"
echo KillAudio^(^)    # ���G�ȕҏW������ꍇ�ɔ����ĉ������ꎞ������>> "%work_dir%%main_project_name%\main.avs"
echo Import^("trim_multi.txt"^)    # �����sTrim�\�L^(EasyVFR�Ȃ�^)>> "%work_dir%%main_project_name%\main.avs"
echo.>> "%work_dir%%main_project_name%\main.avs"
echo ### �����s�ŕ\�L����Trim�R�}���h�͂����ɋL�����Ă������� ###>> "%work_dir%%main_project_name%\trim_multi.txt"
exit /b


:make_avsfile_phase
rem ### ���[�U�[�̓��͂����ݒ�ɂ���������avs�t�@�C�����쐬����[���֐�
echo.
echo ### Avisynth�X�N���v�g�̐��`���쐬 ###
echo %work_dir%%main_project_name%�ɃX�N���v�g���쐬���܂�
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
rem # 0:FAW / 1:faad��neroAacEnc / 2:sox / 3:5.1chMIX
audio_job_flag=

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

rem # �o�b�`���[�h�֌W
set src_video_wide_pixel=
set src_video_hight_pixel=
set src_video_pixel_aspect_ratio=
set videoAspectratio_option=
set avs_filter_type=


goto :parameter_shift

:parameter_shift
rem ### �o�b�`�p�����[�^���V�t�g ###
rem # %9 �� %8 �ɁA... %1 �� %0 ��
shift /1
rem # �o�b�`�p�����[�^����Ȃ�I��
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
rem # �_�u���N���b�N�A��������D&D�ŌĂяo���ꂽ�ꍇ��pause
set cmd_env_chars=%CMDCMDLINE%
if not ""^%cmd_env_chars:~-1%""==""^ "" (
    echo �E�B���h�E�����ɂ́A�����L�[�������Ă��������B
    pause>nul
)
exit /b

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
echo.
echo ### ��ƏI������ ###
echo %time%
echo.
rem # �_�u���N���b�N�A��������D&D�ŌĂяo���ꂽ�ꍇ��pause
set cmd_env_chars=%CMDCMDLINE%
if not ""^%cmd_env_chars:~-1%""==""^ "" (
    echo �E�B���h�E�����ɂ́A�����L�[�������Ă��������B
    pause>nul
)
echo.
exit /b

:exit
endlocal