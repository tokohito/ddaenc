/*
    Auto_VFR_Fast  ver 0.1.0.1
    written by putin
    
    <�Ή��o�[�W����>
        AutoVfr.exe ver0.1.1.0�ȍ~
        
    <�K�v�ȃv���O�C��>
        TIVTC              �K�{
            
    <���>
        Auto_VFR�̍����łł��B
        �@�\�I�ɂ͉��L�̂悤�ɐ�������܂����A��̓t���[�������ʏ�ł�1/6�ɂȂ�܂��B
        
        �E�@�\��24/60fps�A�܂���24/30fps�̕����̂݁B
        �Eini�Ŏw�肵�������֐��݂̂��g�p����A�}�j���A���v���_�E�������͂ł��܂���B     
        
    
    <�g�p��>
        ��{�I�ɂ�Auto_VFR�Ɠ����ł��B
                
        ��avs��    
        MPEG2Source("video_file")
        Trim()#CM�J�b�g
        Auto_VFR_Fast("log_file")   
        return last    
    
        ���R�}���h��
        AutoVfr.exe -i "log_file" -o "output.def" -ref 150 -30f 1 -60f 1 -fix 0
        
        Auto_VFR_Fast�ō쐬�������O����͂���Ǝ����I��Fast-Mode�ɂȂ�܂��B
        ���̎��A-REF �͔�24fps��Ԃ̍ŏ��t���[�������w�肷��R�}���h�Ƃ��Ďg���܂�(�ŏ�30 / 15�t���[���P��)
        
*/


function Auto_VFR_Fast(clip c,string file,int "cut",int "number"
                                  \,int "cthresh",int "mi", bool "chroma", int "blockx", int "blocky"){
  
    #�N���b�v����xDoubleWeave().SelectOdd()�Ƃ���̂�30p��ߑ����邽�߁B
    
    h=c.height()
    total=c.framecount()
    c1=c.DoubleWeave().SelectOdd().SelectEvery(3,1)
    total2=c1.framecount()
    
    Iscut=Defined(cut)?true:false
    Isnumber=Defined(number)?true:false
    
    Assert(Iscut==Isnumber,"specify 'cut' and 'number'")
    Assert(number>0,"'number' should be more than 0.") 
    #Assert(number<=cut,"'number' should be less than or equal to 'cut'.") 
    
    global start=Isnumber?int(total2*float(float(number-1)/float(cut))):0
    end=Isnumber?int((total2 *float(float(number)/float(cut))))-1:0   
    c1=Iscut?c1.Trim(start,end):c1
             
    HDsize=720
    cthresh_default=(h>=HDsize)?9:7
    mi_default=(h>=HDsize)?80:50
    blocks_default=(h>=HDsize)?16:32    
    
    cth=default(cthresh,cthresh_default)
    mi=default(mi,mi_default)
    chrm=default(chroma,false)
    bx=default(blockx,blocks_default)
    by=default(blocky,blocks_default)    
                                      
    
    str_total=(start==0)?"total_f-" + string(total):""
    WriteFileStart(c1, file,"str_total",append=false)   
    (start==0)?WriteFileStart(c1, file,""""fast_f-"""","string(total2)",append=true):nop    
    
    return WriteFile(c1,file,"string(current_frame+start)",""""-""""
        \,"""string((IsCombedTIVTC(cthresh="""+string(cth)+""",MI="""+string(mi)+""",chroma="""
        \+string(chrm)+""",blockx="""+string(bx)+""",blocky="""+string(by)+"""))?"1":"0")"""
        \,flush=false)
}