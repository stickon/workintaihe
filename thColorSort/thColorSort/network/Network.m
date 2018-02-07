//
//  Network.m
//  thColorSort
//
//  Created by taiheMacos on 2017/3/25.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "Network.h"
#import "AppDelegate.h"
#import "TCPNetwork.h"
#import "InternationalControl.h"
@implementation Network
-(BOOL)open
{
    return true;
}
-(void)close
{
    
}
-(void)closeTimer
{
    
}
-(void)connectwithString1:(NSString*)string1 String2:(NSString*)string2
{
    
}
-(void)disconnect{
    
}
#pragma mark tcp连接服务器
-(void)registerUserInfo{
    
}
-(void)initSocketHeader{
    memset(&socketHeader, 0, HeaderLength);
    socketHeader.crc[0] = 0xab;
    socketHeader.crc[1] = 0xba;
}

-(void)initSocketHeaderNum{
    if (self.packetNum == 0xff) {
        self.packetNum = 0;
    }else{
        self.packetNum++;
    }
    socketHeader.number = self.packetNum;
}
#pragma mark 连接设备

-(void)getDeviceList:(NSString*)type data:(NSString*)namePwd{
    
}

-(void)getCurrentDeviceInfo{
    [self initSocketHeader];
    socketHeader.type = 0x01;
    socketHeader.extendType = 0x01;
    Byte type  = [InternationalControl getContryType];
    socketHeader.data1[0] = type;
#ifdef Engineer
    socketHeader.data1[1] = 2;
#else
    socketHeader.data1[1] = 1;
#endif
    [self initSocketHeaderNum];
}

-(void)updateDeviceList{
    
}
#pragma firstViewController
-(void)disconnnectCurrentDevice{
    [self initSocketHeader];
    socketHeader.type = 0x01;
    socketHeader.extendType = 0x02;
}

-(void)setDeviceRunState:(Byte)value withType:(Byte)type
{
    [self initSocketHeader];
    socketHeader.type = 0x03;
    socketHeader.extendType = type;
    socketHeader.data1[0] = value;
    [self netWorkSendData];
}
-(void)setDeviceFeedInOutState:(Byte)value withType:(Byte)index addOrDel:(Byte)isAdd IsAll:(Byte)all
{
    [self initSocketHeader];
    socketHeader.type = 0x08;
    socketHeader.extendType = 0x04;
    if (all) {
        socketHeader.data1[0] = isAdd;
        socketHeader.data1[1] = 0;
        socketHeader.data1[2] = value;//相对值
    }
    else
    {
        socketHeader.data1[0] = 0;
        socketHeader.data1[1] = index;
        socketHeader.data1[2] = value;//绝对值
    }
    [self netWorkSendData];
}

-(void)getVibSettingValue{
    [self initSocketHeader];
    socketHeader.type = 0x08;
    socketHeader.extendType = 0x05;
    [self netWorkSendData];
}
-(void)setVibInOut:(Byte)type Value:(Byte)value{
    [self initSocketHeader];
    socketHeader.type = 0x08;
    socketHeader.extendType = 0x06;
    socketHeader.data1[0] = type;
    socketHeader.data1[1] = value;
    [self netWorkSendData];
}
-(void)setVibInOutSwitchStateWithType:(Byte)type{
    [self initSocketHeader];
    socketHeader.type = 0x08;
    socketHeader.extendType = type;
    [self netWorkSendData];
}
-(void)setVibNum:(Byte)index Switch:(Byte)switchState{
    [self initSocketHeader];
    socketHeader.type = 0x08;
    socketHeader.extendType = 0x08;
    socketHeader.data1[0] = index;
    socketHeader.data1[1] =  switchState;
    [self netWorkSendData];
}
-(void)getCleanPara
{
    [self initSocketHeader];
    socketHeader.type = 0x07;
    socketHeader.extendType = 0x03;
    [self netWorkSendData];
}
-(void)sendCleanWithType:(Byte)cleanType{
    [self initSocketHeader];
    socketHeader.type = 0x07;
    socketHeader.extendType = cleanType;
    [self netWorkSendData];
}
-(void)setCleanParaWithData:(Byte *)cleanData AndCloseValveType:(Byte)type
{
    [self initSocketHeader];
    socketHeader.type = 0x07;
    if (type) {
        socketHeader.extendType = 0x05;
    }
    else
        socketHeader.extendType = 0x04;
    memcpy(socketHeader.data1, (const void*)cleanData, 4);
    [self netWorkSendData];
}
#pragma valveViewController

-(void)getValvePara{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x09;
    socketHeader.extendType = 0x01;
    socketHeader.data1[0] = device.currentLayerIndex;
    [self netWorkSendData];
}
-(void)setValveParaWithData:(Byte*)valveData
{
    [self initSocketHeader];
    socketHeader.type = 0x09;
    socketHeader.extendType = 0x02;
    memcpy(socketHeader.data1, valveData, 4);
    [self netWorkSendData];
}
#pragma secondViewController

-(void)sendToGetDataIsIR:(Byte)isIR
{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x4;
    if (isIR) {
        socketHeader.extendType = 0x11;
    }else{
        socketHeader.extendType = 0x1;
    }
    socketHeader.data1[0] = (Byte)device.currentLayerIndex;
    socketHeader.data1[1] = (Byte)device.currentViewIndex;
    [self netWorkSendData];
}

-(void)sendAlgorithmSenseValueWithAjustType:(Byte)ajustType Sorter:(Byte)sorterIndex data:(Byte)dataValue algorithmType:(Byte)type FirstSecond:(Byte)index ValueType:(Byte)valueType IsIR:(Byte)isIR
{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x04;
    if (isIR) {
        socketHeader.extendType = 0x12;
    }else{
        socketHeader.extendType = 0x02;
    }
    SenseValue sense;
    memset(&sense, 0, sizeof(SenseValue));
    sense.Algorithm = type;
    sense.adjustType = ajustType;
    sense.layer = device.currentLayerIndex;
    sense.ch = sorterIndex-1;
    sense.view = device.currentViewIndex;
    sense.frtSnd = index;
    sense.type = valueType;
    sense.data = dataValue;
    memcpy(socketHeader.data1, (const void*)&sense,sizeof(SenseValue));
    [self netWorkSendData];
}


-(void)sendToGetRiceUserSense{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x4;
    socketHeader.extendType = 0x21;
    socketHeader.data1[0] = (Byte)device.currentLayerIndex;
    socketHeader.data1[1] = (Byte)device.currentViewIndex;
    [self netWorkSendData];
}
-(void)sendToSetRiceUserSenseWithType:(Byte)type GroupIndex:(Byte)group RowIndex:(Byte)index Value:(int)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x04;
    socketHeader.extendType = 0x22;
    RiceUserSense sense;
    memset(&sense, 0, sizeof(RiceUserSense));
    sense.type = type;
    sense.layer = device.currentLayerIndex;
    sense.view = device.currentViewIndex;
    sense.group = group;
    sense.index = index;
    sense.data[0] = value/256;
    sense.data[1] = value%256;
    memcpy(socketHeader.data1, (const void*)&sense,sizeof(RiceUserSense));
    [self netWorkSendData];
}
-(void)sendToSetRiceUserSenseUseWithType:(Byte)type Value:(Byte)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x04;
    socketHeader.extendType = 0x24;
    SenseUse senseUse;
    memset(&senseUse, 0, sizeof(SenseUse));
    senseUse.Algorithm = type;
    senseUse.layer = device.currentLayerIndex;
    senseUse.view = device.currentViewIndex;
    memcpy(socketHeader.data1,(const void*)&senseUse,sizeof(SenseUse));
    [self netWorkSendData];
}

#pragma mark sense AdvancedController
-(void)sendToGetSenseAdvancedData:(Byte)type IsIR:(Byte)isIR
{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x4;
    if (isIR) {
        socketHeader.extendType = 0x13;
    }else{
        socketHeader.extendType = 0x03;
    }
    socketHeader.data1[0] = type;
    socketHeader.data1[1] = device.currentLayerIndex;
    socketHeader.data1[2] = device.currentViewIndex;
    [self netWorkSendData];
}
-(void)sendToChangeUseStateWithAlgorithm:(Byte)type IsIR:(Byte)isIR
{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x04;
    if (isIR) {
        socketHeader.extendType = 0x14;
    }else{
        socketHeader.extendType = 0x04;
    }
    SenseUse senseUse;
    memset(&senseUse, 0, sizeof(SenseUse));
    senseUse.Algorithm = type;
    senseUse.layer = device.currentLayerIndex;
    senseUse.view = device.currentViewIndex;
    memcpy(socketHeader.data1,(const void*)&senseUse,sizeof(SenseUse));
    [self netWorkSendData];
}
-(void)sendToChangeSizeWithAlgorithmType:(Byte)algorithmType Type:(Byte)type AndValue:(NSInteger)value IsIR:(Byte)isIR
{
    Device *device = kDataModel.currentDevice;
    SenseSize sense;
    memset(&sense, 0, sizeof(SenseSize));
    sense.Algorithm = algorithmType;
    sense.layer = device.currentLayerIndex;
    sense.view = device.currentViewIndex;
    sense.type = type;
    sense.data[0] = value/256;
    sense.data[1] = value%256;
    sense.fSameR = device->sense.fSameR;
    [self initSocketHeader];
    socketHeader.type = 0x04;
    if (isIR) {
        socketHeader.extendType = 0x15;
    }else{
        socketHeader.extendType = 0x05;
    }
    
    memcpy(socketHeader.data1, (const void*)&sense,sizeof(SenseSize));
    [self netWorkSendData];
}

-(void)sendToChangeLightAreaSizeLimitOrBorderUseWithType:(Byte)type{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x04;
    socketHeader.extendType = 0x06;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = device.currentViewIndex;
    socketHeader.data1[2] = type;
    [self netWorkSendData];
}

#pragma mark 芯白 反选
-(void)getReverseSharpenWithAlgorithmType:(Byte)algorithmType{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x04;
    socketHeader.extendType = 0x07;
    socketHeader.data1[0] = algorithmType;
    socketHeader.data1[1] = device.currentLayerIndex;
    socketHeader.data1[2] = device.currentViewIndex;
    [self netWorkSendData];
}

-(void)setReverseSharpenWithAlgorithmType:(Byte)algorithmType Type:(Byte)type Chute:(Byte)chute Value:(Byte)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x04;
    socketHeader.extendType = 0x08;
    socketHeader.data1[0] = algorithmType;
    socketHeader.data1[1] = device.currentLayerIndex;
    socketHeader.data1[2] = device.currentViewIndex;
    socketHeader.data1[3] = type;
    socketHeader.data1[4] = chute-1;
    socketHeader.data1[5] = value;
    socketHeader.data1[6] = device->sense.fSameR;
    [self netWorkSendData];
}

#pragma mark 红外 3-1 锐化
-(void)getIRSharpenWithAlgorithmType:(Byte)irAlgorithmType{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x04;
    socketHeader.extendType = 0x17;
    socketHeader.data1[0] = irAlgorithmType;
    socketHeader.data1[1] = device.currentLayerIndex;
    socketHeader.data1[2] = device.currentViewIndex;
    [self netWorkSendData];
}
-(void)setIRSharpenWithAlrotithmType:(Byte)irAlgorithmType Type:(Byte)type Value:(Byte)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x04;
    socketHeader.extendType = 0x18;
    socketHeader.data1[0] = irAlgorithmType;
    socketHeader.data1[1] = device.currentLayerIndex;
    socketHeader.data1[2] = device.currentViewIndex;
    socketHeader.data1[3] = type;
    socketHeader.data1[4] = value;
    [self netWorkSendData];
}
#pragma mark 灯光
-(void)getLight{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x0b;
    socketHeader.extendType = 0x01;
    socketHeader.data1[0] = device.currentLayerIndex;
    [self netWorkSendData];
}
-(void)setLightWithType:(Byte)type AndValue:(Byte)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x0b;
    socketHeader.extendType = 0x02;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = device.currentViewIndex;
    socketHeader.data1[2] = type;
    socketHeader.data1[3] = value;
    [self netWorkSendData];
}

#pragma mark 相机增益
-(void)getCameraGain{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x0c;
    socketHeader.extendType = 0x01;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = device.currentSorterIndex-1;
    [self netWorkSendData];
}
-(void)setCameraGainWithAjustTypeAll:(Byte)ajustType Type:(Byte)type GainType:(Byte)gainType Value:(NSInteger)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x0c;
    socketHeader.extendType = 0x02;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = device.currentViewIndex;
    socketHeader.data1[2] = device.currentSorterIndex-1;
    socketHeader.data1[3] = ajustType;
    socketHeader.data1[4] = type;
    socketHeader.data1[5] = gainType;
    socketHeader.data1[6] = value/256;
    socketHeader.data1[7] = value%256;
    [self netWorkSendData];
}
-(void)switchCameraGainWithGainType:(Byte)gainType{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x0c;
    socketHeader.extendType = 0x03;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = device.currentSorterIndex-1;
    socketHeader.data1[2] = gainType;
    [self netWorkSendData];
}
#pragma mark 系统信息
#pragma mark 版本信息
-(void)getVersionWithType:(Byte)extendtype CameraType:(Byte)cameraType
{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x0a;
    socketHeader.extendType = extendtype;
    socketHeader.data1[0] = device.currentLayerIndex;
    if (extendtype == 0x03) {
        socketHeader.data1[1] = cameraType;
    }
    [self netWorkSendData];
}

-(void)getSysCheckInfo{
    [self initSocketHeader];
    socketHeader.type = 0xa0;
    socketHeader.extendType = 0x02;
    [self netWorkSendData];
}
-(void)getSysWorkTimeInfo{
    [self initSocketHeader];
    socketHeader.type = 0xa0;
    socketHeader.extendType = 0x03;
    [self netWorkSendData];
}
#pragma mark 波形
-(void)sendToGetWaveDataWithAlgorithmType:(Byte)type AndWaveType:(Byte)waveType AndDataType:(Byte)dataType Position:(Byte)position
{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x05;
    socketHeader.extendType = 0x01;
    socketHeader.data1[0] = type;
    socketHeader.data1[1] = device.currentLayerIndex;
    socketHeader.data1[2] = device.currentViewIndex;
    socketHeader.data1[3] = device.currentSorterIndex-1;
    socketHeader.data1[4] = waveType;
    if (waveType>= 0x08 &&waveType <= 10) {
        socketHeader.data1[5]= dataType;
        socketHeader.data1[6] = position;
    }
    [self netWorkSendData];
}
#pragma mark 方案
-(void)getSmallModeNameListWithBigModeIndex:(Byte)bigModeIndex{
    Device *device = kDataModel.currentDevice;
    if (bigModeIndex == 0) {
        if (device.modeList1.count>0) {
            [device.modeList1 removeAllObjects];
        }
    }else if (bigModeIndex == 1){
        if (device.modeList2.count>0) {
            [device.modeList2 removeAllObjects];
        }
    }else if (bigModeIndex == 2){
        if (device.modeList3.count>0) {
            [device.modeList3 removeAllObjects];
        }
    }else if (bigModeIndex == 3){
        if (device.modeList4.count>0) {
            [device.modeList4 removeAllObjects];
        }
    }else if (bigModeIndex == 4){
        if (device.modeList5.count>0) {
            [device.modeList5 removeAllObjects];
        }
    }
    [self initSocketHeader];
    socketHeader.type = 0x0d;
    socketHeader.extendType = 0x01;
    socketHeader.data1[0] = bigModeIndex+1;
    [self netWorkSendData];
}

-(void)useModeWithIndex:(Byte)smallModeIndex BigModeIndex:(Byte)bigModeIndex{
    Device *device = kDataModel.currentDevice;
    NSMutableArray *smallModeList = device.bigModeList[bigModeIndex];
    NSMutableDictionary *dict = [smallModeList objectAtIndex:smallModeIndex];
    NSString *modeIndex = [dict valueForKey:@"modeRealIndex"];
    [self initSocketHeader];
    socketHeader.type = 0x0d;
    socketHeader.extendType = 0x05;
    socketHeader.data1[0] = modeIndex.intValue;
    socketHeader.data1[1] = bigModeIndex+1;
    [self netWorkSendData];
}
-(void)getModeSettingWithIndex:(Byte)smallModeIndex BigModeIndex:(Byte)bigModeIndex{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x0d;
    socketHeader.extendType = 0x03;
    socketHeader.data1[0] = device->machineData.layerNumber;
    socketHeader.data1[1] = smallModeIndex;//小模式索引从1开始
    socketHeader.data1[2] = bigModeIndex+1;//大模式索引从1开始
    [self netWorkSendData];
}
-(void)changeModeSettingWithMode:(Byte*)mode shape:(Byte)shapeIndex svm:(Byte)useSvm hsv:(Byte)useHsv{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x0d;
    socketHeader.extendType = 0x04;
    
    NSInteger modeLength = (device->machineData.layerNumber)*sizeof(Mode);
    
    Byte shapeSvm[3] = {0};
    shapeSvm[0] = shapeIndex;
    shapeSvm[1] = useSvm;
    shapeSvm[2] = useHsv;
    socketHeader.len[0] = (modeLength+3)/256;
    socketHeader.len[1] = (modeLength+3)%256;
    NSLog(@"len0:%d",socketHeader.len[0]);
    NSLog(@"len1:%d",socketHeader.len[1]);
    [self initSocketHeaderNum];
    NSMutableData *data = [NSMutableData dataWithBytes:&socketHeader length:HeaderLength];
    [data appendBytes:mode length:modeLength];
    [data appendBytes:shapeSvm  length:3];
   
    [self netWorkSendDataWithData:data];
}

-(void)saveCurrentMode{
    [self initSocketHeader];
    socketHeader.type = 0x0d;
    socketHeader.extendType = 0x06;
    [self netWorkSendData];

}

#pragma mark 喷阀频率
-(void)getValveFrequency{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x0e;
    socketHeader.extendType = 0x01;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = device.currentSorterIndex-1;
    [self netWorkSendData];
}

#pragma mark 光学校准
-(void)getCalibrationPara{
    [self initSocketHeader];
    socketHeader.type = 0x11;
    socketHeader.extendType = 0x01;
    [self netWorkSendData];
}
-(void)setCalibrationParaWithType:(Byte)type Data:(Byte)value{
    [self initSocketHeader];
    socketHeader.type = 0x11;
    socketHeader.extendType = 0x02;
    socketHeader.data1[0] = type;
    socketHeader.data1[1] = value;
    [self netWorkSendData];
}
-(void)calibrateWithType:(Byte)type{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x11;
    socketHeader.extendType = 0x03;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = device.currentViewIndex;
    socketHeader.data1[2] = device.currentSorterIndex-1;
    socketHeader.data1[3] = type;
    [self netWorkSendData];
}
-(void)changeWaveDataWithType:(Byte)type{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x11;
    socketHeader.extendType = 0x04;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    [self netWorkSendData];
}

#pragma mark 履带
-(void)switchCaterpillar:(Byte)value withLayerIndex:(Byte)index{
    [self initSocketHeader];
    socketHeader.type = 0x0f;
    socketHeader.extendType = 0x01;
    socketHeader.data1[0]= index;
    socketHeader.data1[1] = value;
    [self netWorkSendData];
}
-(void)getCaterpillarSpeed{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x0f;
    socketHeader.extendType = 0x02;
    socketHeader.data1[0]= device.currentLayerIndex;
    [self netWorkSendData];
}
-(void)setCaterpillarSpeedByte1:(Byte)highByte byte2:(Byte)lowByte{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x0f;
    socketHeader.extendType = 0x03;
    socketHeader.data1[0]= device.currentLayerIndex;
    socketHeader.data1[1] = highByte;
    socketHeader.data1[2] = lowByte;
    [self netWorkSendData];
}
-(void)getCaterpillarSettingSpeed{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x0f;
    socketHeader.extendType = 0x04;
    socketHeader.data1[0]= device.currentLayerIndex;
    [self netWorkSendData];
}

#pragma mark svm
-(void)getSvmPara{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x10;
    if (device->screenProtocolMainVersion == 3) {
        socketHeader.extendType = 0x11;
        if (device->machineData.layerNumber == 1&&device.groupNum>1) {
            socketHeader.data1[0] = device.currentGroupIndex+1;
        }else{
            socketHeader.data1[0] = device.currentLayerIndex;
        }
    }else if (device->screenProtocolMainVersion == 2){
        socketHeader.extendType = 0x01;
        socketHeader.data1[0] = device.currentLayerIndex;
    }
    socketHeader.data1[1] = device.currentViewIndex;
    [self netWorkSendData];
    
}
-(void)setSvmParaWithType:(Byte)type AndData:(NSInteger)data{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x10;
    if (device->screenProtocolMainVersion == 3) {
        socketHeader.extendType = 0x12;
        if (device->machineData.layerNumber == 1&&device.groupNum>1) {
            socketHeader.data1[0] = device.currentGroupIndex+1;
        }else{
            socketHeader.data1[0] = device.currentLayerIndex;
        }
    }else if (device->screenProtocolMainVersion == 2){
        socketHeader.extendType = 0x02;
        socketHeader.data1[0] = device.currentLayerIndex;
    }
    
    socketHeader.data1[1] = device.currentViewIndex;
    socketHeader.data1[2] = type;
    socketHeader.data1[3] = data/256;
    socketHeader.data1[4] = data%256;
    [self netWorkSendData];
}

#pragma mark hsv
-(void)getHsvPara{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x30;
    socketHeader.extendType = 1;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = device.currentSorterIndex-1;
    socketHeader.data1[2] = device.currentViewIndex;
    [self netWorkSendData];
}
-(void)setHsvParaWithType:(Byte)type AndData:(NSInteger)data{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x30;
    socketHeader.extendType = 0x02;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = device.currentSorterIndex-1;
    socketHeader.data1[2] = device.currentViewIndex;
    socketHeader.data1[3] = device->currentHsvIndex;
    socketHeader.data1[4] = type;
    socketHeader.data1[5] = data/256;
    socketHeader.data1[6] = data%256;
    [self netWorkSendData];
}
-(void)changeHsvWithType:(Byte)type Index:(Byte)index{
    [self initSocketHeader];
    socketHeader.type = 0x30;
    socketHeader.extendType = 0x03;
    socketHeader.data1[0] = type;
    socketHeader.data1[1] = index;
    [self netWorkSendData];
}

#pragma mark 腰果
-(void)getCashewSet{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x12;
    socketHeader.extendType = 0x01;
    socketHeader.data1[0] = device.currentLayerIndex;
    [self netWorkSendData];
}
-(void)setCashewSetUseStateWithType:(Byte)type{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x12;
    socketHeader.extendType = 0x03;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    [self netWorkSendData];
}
-(void)setCashewSetParaWithType:(Byte)type Value:(NSInteger)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x12;
    socketHeader.extendType = 0x02;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = value/256;
    socketHeader.data1[3] = value%256;
    [self netWorkSendData];
}
#pragma mark 大米
-(void)getRice{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x16;
    socketHeader.extendType = 0x01;
    socketHeader.data1[0] = device.currentLayerIndex;
    [self netWorkSendData];
}
-(void)setRiceParaWithType:(Byte)type Value:(NSInteger)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x16;
    socketHeader.extendType = 0x02;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = value/256;
    socketHeader.data1[3] = value%256;
    [self netWorkSendData];
}
-(void)setRiceUseStateWithType:(Byte)type{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x16;
    socketHeader.extendType = 0x03;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    [self netWorkSendData];
}
#pragma mark 花生芽头
-(void)getPeanutbud{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x13;
    if (device->screenProtocolMainVersion == 2) {
        socketHeader.extendType = 1;
    }else if (device->screenProtocolMainVersion == 3){
        socketHeader.extendType = 0x11;
    }
    socketHeader.data1[0] = device.currentLayerIndex;
    [self netWorkSendData];
}
-(void)setPeanutbudEditWithIndex:(Byte)index Data:(int)data{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x13;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = index;
    if (device->screenProtocolMainVersion == 2) {
        socketHeader.extendType = 0x2;
        socketHeader.data1[2] = data;
    }else if (device->screenProtocolMainVersion == 3){
        socketHeader.extendType = 0x12;
        socketHeader.data1[2] = data/256;
        socketHeader.data1[3] = data%256;
    }
    [self netWorkSendData];
}

-(void)setPeanutbudBtnWithIndex:(int)index Data:(int)data{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x13;
    if (device->screenProtocolMainVersion == 2) {
        socketHeader.extendType = 0x3;
    }else if (device->screenProtocolMainVersion == 3){
        socketHeader.extendType = 0x13;
    }
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = index;
    socketHeader.data1[2] = data;
    [self netWorkSendData];
}
#pragma mark 标准形选或通用茶叶
-(void)getStandard{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x14;
    socketHeader.extendType = 1;
    socketHeader.data1[0] = device.currentLayerIndex;
    [self netWorkSendData];
}
-(void)setStandardValueWithType:(Byte)type Value:(NSInteger)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x14;
    socketHeader.extendType = 0x02;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = value/256;
    socketHeader.data1[3] = value%256;
    [self netWorkSendData];
}
-(void)setStandardStateWithType:(Byte)type State:(Byte)state{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x14;
    socketHeader.extendType = 3;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = state;
    [self netWorkSendData];
}


#pragma mark 茶叶
-(void)getTea{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x15;
    socketHeader.extendType = 1;
    socketHeader.data1[0] = device.currentLayerIndex;
    [self netWorkSendData];
}
-(void)setTeaValueWithType:(Byte)type Value:(NSInteger)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x15;
    socketHeader.extendType = 0x02;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = value/256;
    socketHeader.data1[3] = value%256;
    [self netWorkSendData];
}
-(void)setTeaStateWithType:(Byte)type State:(Byte)state{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x15;
    socketHeader.extendType = 3;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = state;
    [self netWorkSendData];
}


#pragma mark 甘草 0x17
-(void)getLicorice {
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x17;
    socketHeader.extendType = 1;
    socketHeader.data1[0] = device.currentLayerIndex;
    [self netWorkSendData];
}
-(void)setLicoriceValueWithType:(Byte)type Value:(Byte)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x17;
    socketHeader.extendType = 2;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = value;
    [self netWorkSendData];
}
-(void)setLicoriceStateWithType:(Byte)type State:(Byte)state{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x17;
    socketHeader.extendType = 3;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = state;
    [self netWorkSendData];
}

#pragma mark 小麦 0x18
-(void)getWheat{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x18;
    socketHeader.extendType = 1;
    socketHeader.data1[0] = device.currentLayerIndex;
    [self netWorkSendData];
}
-(void)setWheatValueWithType:(Byte)type Value:(NSInteger)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x18;
    socketHeader.extendType = 2;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = value/256;
    socketHeader.data1[3] = value%256;
    [self netWorkSendData];
}
-(void)setWheatState:(Byte)state{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x18;
    socketHeader.extendType = 3;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = state;
    [self netWorkSendData];
}

#pragma mark 稻种0x19
-(void)getSeed{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x19;
    socketHeader.extendType = 1;
    socketHeader.data1[0] = device.currentLayerIndex;
    [self netWorkSendData];
}
-(void)setSeedValueWithType:(Byte)type Value:(Byte)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x19;
    socketHeader.extendType = 2;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = value;
    [self netWorkSendData];
}
-(void)setSeedState:(Byte)state{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x19;
    socketHeader.extendType = 3;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = state;
    [self netWorkSendData];
}


#pragma mark 葵花籽0x1a
-(void)getSunflower{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1a;
    socketHeader.extendType = 1;
    socketHeader.data1[0] = device.currentLayerIndex;
    [self netWorkSendData];
}
-(void)setSunflowerWithType:(Byte)type Value:(NSInteger)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1a;
    socketHeader.extendType = 2;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = value/256;
    socketHeader.data1[3] = value%256;
    [self netWorkSendData];
}
-(void)setSunflowerState:(Byte)state{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1a;
    socketHeader.extendType = 3;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = state;
    [self netWorkSendData];
}


#pragma mark 玉米 0x1b
-(void)getCorn{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1b;
    socketHeader.extendType = 1;
    socketHeader.data1[0] = device.currentLayerIndex;
    [self netWorkSendData];

}
-(void)setCornWithType:(Byte)type Value:(Byte)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1b;
    socketHeader.extendType = 2;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = value;
    [self netWorkSendData];
}
-(void)setCornStateWithType:(Byte)type State:(Byte)state{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1b;
    socketHeader.extendType = 3;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = state;
    [self netWorkSendData];
}

#pragma mark 蚕豆 0x1c
-(void)getHorseBean{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1c;
    socketHeader.extendType = 1;
    socketHeader.data1[0] = device.currentLayerIndex;
    [self netWorkSendData];
}
-(void)setHorseBeanWithType:(Byte)type Value:(Byte)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1c;
    socketHeader.extendType = 2;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = value;
    [self netWorkSendData];
}
-(void)setHorseBeanStateWithType:(Byte)type State:(Byte)state{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1c;
    socketHeader.extendType = 3;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = state;
    [self netWorkSendData];
}

#pragma mark 绿茶 0x1d
-(void)getGreenTea{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1d;
    socketHeader.extendType = 1;
    socketHeader.data1[0] = device.currentLayerIndex;
    [self netWorkSendData];
}
-(void)setGreenTeaWithType:(Byte)type Value:(NSInteger)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1d;
    socketHeader.extendType = 2;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = value/256;
    socketHeader.data1[3] = value%256;
    [self netWorkSendData];
}
-(void)setGreenTeaStateWithType:(Byte)type State:(Byte)state{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1d;
    socketHeader.extendType = 3;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = state;
    [self netWorkSendData];
}


#pragma mark 红茶 0x1e
-(void)getRedTea{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1e;
    socketHeader.extendType = 1;
    socketHeader.data1[0] = device.currentLayerIndex;
    [self netWorkSendData];
}
-(void)setRedTeaWithType:(Byte)type Value:(NSInteger)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1e;
    socketHeader.extendType = 2;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = value/256;
    socketHeader.data1[3] = value%256;
    [self netWorkSendData];
}
-(void)setRedTeaStateWithType:(Byte)type State:(Byte)state{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1e;
    socketHeader.extendType = 3;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = state;
    [self netWorkSendData];
}

#pragma mark 绿茶短梗 0x1f
-(void)getGreenTeaSG{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1f;
    socketHeader.extendType = 1;
    socketHeader.data1[0] = device.currentLayerIndex;
    [self netWorkSendData];
}
-(void)setGreenTeaSGWithType:(Byte)type Value:(NSInteger)value{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1f;
    socketHeader.extendType = 2;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = value/256;
    socketHeader.data1[3] = value%256;
    [self netWorkSendData];
}
-(void)setGreenTeaSGStateWithType:(Byte)type State:(Byte)state{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0x1f;
    socketHeader.extendType = 3;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = type;
    socketHeader.data1[2] = state;
    [self netWorkSendData];
}

#pragma mark 切换层
-(void)changeLayerAndView{
    Device *device = kDataModel.currentDevice;
    [self initSocketHeader];
    socketHeader.type = 0xa1;
    socketHeader.extendType  = 1;
    socketHeader.data1[0] = device.currentLayerIndex;
    socketHeader.data1[1] = device.currentViewIndex;
    [self netWorkSendData];
}
-(void)receiveSocketData:(NSData *)data fromAddressIP:(NSString *)IPaddress
{
    const unsigned char *a =[data bytes];
    if ([data length] > 0) {
        [kDataModel setData:data withType:*a andIPaddress:IPaddress];
         dispatch_async(dispatch_get_main_queue(), ^{
        [gMiddeUiManager updateCurrentViewWithHeader:[NSData dataWithBytes:data.bytes length:15]];
         });
    }
    else
    {
        DDLogInfo(@"no data receive");
    }
    
}
-(void)netWorkSendData{
    
}
-(void)netWorkSendDataWithData:(NSData*)data{
    
}
-(void)didnotsend
{
    [gMiddeUiManager socketSendError];
}

-(void)receiveData
{
    
}
@end
