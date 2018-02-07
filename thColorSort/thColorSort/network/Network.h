//
//  Network.h
//  thColorSort
//
//  Created by taiheMacos on 2017/3/25.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import <CocoaAsyncSocket/GCDAsyncUdpSocket.h>
#define LOG_LEVEL_DEF ddLogLevel
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "DataModel.h"
#import "MiddleManager.h"
#import "JX_GCDTimerManager.h"
@class TCPNetwork;
#define CurrentPort 5678
#define serverPort 1234
#define TCPserverIPAddress @"www.taiheservice.com"
//#define TCPserverIPAddress @"47.90.127.2"
//#define TCPserverIPAddress @"192.168.137.96"
#define HeaderLength sizeof(SocketHeader)
static NSString *registerInfoKey = @"registerInfo";
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
typedef struct
{
    Byte type;
    Byte extendType;
    Byte data1[8];
    Byte number;
    Byte len[2];
    Byte crc[2];
}SocketHeader;
//灵敏度
typedef struct SenseValue
{
    Byte Algorithm;   //色选算法
    Byte adjustType;  //0:单通道，1：所有通
    Byte layer;
    Byte view;
    Byte ch;
    Byte frtSnd;
    Byte type; //1:灵敏度，2：色差上限 3：色差下限
    Byte data;
}SenseValue;
//色选使能 只需要利用前三个字节数据 不分料槽 使能自动取反
typedef struct SenseUse
{
    Byte Algorithm;//色选算法
    Byte layer;
    Byte view;
    Byte ch;
    Byte data;
}SenseUse;

typedef struct RiceUserSense{
    Byte type;
    Byte layer;
    Byte view;
    Byte group;
    Byte index;
    Byte data[2];
}RiceUserSense;

typedef struct SenseSize
{
    Byte Algorithm;   //色选算法
    Byte layer;
    Byte view;
    Byte fSameR;//前后视相同
    Byte type; //长宽点(1/2/3)
    Byte data[2];
}SenseSize;

typedef struct WaveSendType
{
    Byte Algorithm;   //色选算法
    Byte layer;
    Byte view;
    Byte ch;
    Byte type; //波形的类形
}WaveSendType;

@interface Network : NSObject
{
    @public
    SocketHeader socketHeader;
    Byte networkType;
    
    NSString *registerUserName;//注册用
    NSString *registerPwd;
}

@property (nonatomic,assign) Byte packetNum;//包号
-(void)initSocketHeader;
-(void)initSocketHeaderNum;
-(void)disconnect;
#pragma mark tcp连接服务器
-(void)registerUserInfo;

#pragma mark deviceListView
-(void)getCurrentDeviceInfo;
-(void)updateDeviceList;
#pragma mark firstViewController
-(void)disconnnectCurrentDevice;
-(void)setDeviceRunState:(Byte)value withType:(Byte)type;
-(void)setDeviceFeedInOutState:(Byte)value withType:(Byte)type addOrDel:(Byte)isAdd  IsAll:(Byte)all;//isAdd 所有通道整体加还是减
-(void)getVibSettingValue;
-(void)setVibInOut:(Byte)type Value:(Byte)value;
-(void)setVibInOutSwitchStateWithType:(Byte)type;
-(void)setVibNum:(Byte)index Switch:(Byte)switchState;
#pragma mark cleanViewController

-(void)getCleanPara;
-(void)setCleanParaWithData:(Byte*)cleanData AndCloseValveType:(Byte)type;
-(void)sendCleanWithType:(Byte)cleanType;

#pragma mark valveViewController

-(void)getValvePara;
-(void)setValveParaWithData:(Byte*)valveData;
//
//
#pragma mark SenseViewController
//色选算法灵敏度 红外算法灵敏度
-(void)sendToGetDataIsIR:(Byte)isIR;//是否红外
-(void)sendAlgorithmSenseValueWithAjustType:(Byte)ajustType Sorter:(Byte)sorterIndex data:(Byte)dataValue algorithmType:(Byte)type FirstSecond:(Byte)index ValueType:(Byte)valueType IsIR:(Byte)isIR;
-(void)sendToChangeUseStateWithAlgorithm:(Byte)type IsIR:(Byte)isIR;


//大米用户版本灵敏度
-(void)sendToGetRiceUserSense;
-(void)sendToSetRiceUserSenseWithType:(Byte)type GroupIndex:(Byte)group RowIndex:(Byte)index Value:(int)value;
#pragma mark color ir AdvancedController
-(void)sendToGetSenseAdvancedData:(Byte)type IsIR:(Byte)isIR;
-(void)sendToChangeSizeWithAlgorithmType:(Byte)algorithmType Type:(Byte)type AndValue:(NSInteger)value IsIR:(Byte)isIR;//set size
-(void)sendToChangeLightAreaSizeLimitOrBorderUseWithType:(Byte)type;

#pragma mark 灰度色差 3-1 协议 芯白 反选
-(void)getReverseSharpenWithAlgorithmType:(Byte)algorithmType;
-(void)setReverseSharpenWithAlgorithmType:(Byte)algorithmType Type:(Byte)type Chute:(Byte)chute Value:(Byte)value;
#pragma mark 红外 3-1 锐化
-(void)getIRSharpenWithAlgorithmType:(Byte)irAlgorithmType;
-(void)setIRSharpenWithAlrotithmType:(Byte)irAlgorithmType Type:(Byte)type Value:(Byte)value;
#pragma mark 波形
-(void)sendToGetWaveDataWithAlgorithmType:(Byte)type AndWaveType:(Byte)waveType AndDataType:(Byte)dataType Position:(Byte)position;
#pragma mark thirdViewController
#pragma mark lightsettingviewcontroller
-(void)getLight;
-(void)setLightWithType:(Byte)type AndValue:(Byte)value;
#pragma mark cameraViewController
-(void)getCameraGain;
-(void)setCameraGainWithAjustTypeAll:(Byte)ajustType Type:(Byte)type GainType:(Byte)gainType Value:(NSInteger)value;
-(void)switchCameraGainWithGainType:(Byte)gainType;
#pragma mark 系统信息
-(void)getVersionWithType:(Byte)extendtype CameraType:(Byte)cameraType;//版本信息
-(void)getSysCheckInfo;//系统自检信息
-(void)getSysWorkTimeInfo;//系统工作信息

#pragma mark 方案
-(void)getSmallModeNameListWithBigModeIndex:(Byte)bigModeIndex;
-(void)useModeWithIndex:(Byte)smallModeIndex BigModeIndex:(Byte)bigModeIndex;
-(void)getModeSettingWithIndex:(Byte)smallModeIndex BigModeIndex:(Byte)bigModeIndex;
-(void)changeModeSettingWithMode:(Byte*)mode shape:(Byte)shapeIndex svm:(Byte)useSvm hsv:(Byte)useHsv;
-(void)saveCurrentMode;
#pragma mark 喷阀频率
-(void)getValveFrequency;

#pragma mark 光学校准
-(void)getCalibrationPara;
-(void)setCalibrationParaWithType:(Byte)type Data:(Byte)value;
-(void)calibrateWithType:(Byte)type;
-(void)changeWaveDataWithType:(Byte)type;
#pragma mark 履带
-(void)switchCaterpillar:(Byte)value withLayerIndex:(Byte)index;
-(void)getCaterpillarSpeed;
-(void)setCaterpillarSpeedByte1:(Byte)highByte byte2:(Byte)lowByte;
-(void)getCaterpillarSettingSpeed;
#pragma mark svm
-(void)getSvmPara;
-(void)setSvmParaWithType:(Byte)type AndData:(NSInteger)data;

#pragma mark hsv
-(void)getHsvPara;
-(void)setHsvParaWithType:(Byte)type AndData:(NSInteger)data;
-(void)changeHsvWithType:(Byte)type Index:(Byte)index;//灵敏度1、2切换 偏移切换 料槽切换

#pragma mark 腰果
-(void)getCashewSet;
-(void)setCashewSetUseStateWithType:(Byte)type;
-(void)setCashewSetParaWithType:(Byte)type Value:(NSInteger)value;//type1 1：选小 2：选大   type2 1:最小点数 2：最大点数

#pragma mark 大米
-(void)getRice;
-(void)setRiceParaWithType:(Byte)type Value:(NSInteger)value;
-(void)setRiceUseStateWithType:(Byte)type;

#pragma mark 花生芽头
-(void)getPeanutbud;
-(void)setPeanutbudEditWithIndex:(Byte)index Data:(int)data;
-(void)setPeanutbudBtnWithIndex:(int)index Data:(int)data;
#pragma mark 标准形选或通用茶叶
-(void)getStandard;
-(void)setStandardValueWithType:(Byte)type Value:(NSInteger)value;
-(void)setStandardStateWithType:(Byte)type State:(Byte)state;

#pragma mark 茶叶
-(void)getTea;
-(void)setTeaValueWithType:(Byte)type Value:(NSInteger)value;
-(void)setTeaStateWithType:(Byte)type State:(Byte)state;

#pragma mark 甘草 0x17
-(void)getLicorice;
-(void)setLicoriceValueWithType:(Byte)type Value:(Byte)value;
-(void)setLicoriceStateWithType:(Byte)type State:(Byte)state;

#pragma mark 小麦 0x18
-(void)getWheat;
-(void)setWheatValueWithType:(Byte)type Value:(NSInteger)value;
-(void)setWheatState:(Byte)state;

#pragma mark 稻种0x19
-(void)getSeed;
-(void)setSeedValueWithType:(Byte)type Value:(Byte)value;
-(void)setSeedState:(Byte)state;

#pragma mark 葵花籽0x1a
-(void)getSunflower;
-(void)setSunflowerWithType:(Byte)type Value:(NSInteger)value;
-(void)setSunflowerState:(Byte)state;

#pragma mark 玉米 0x1b
-(void)getCorn;
-(void)setCornWithType:(Byte)type Value:(Byte)value;
-(void)setCornStateWithType:(Byte)type State:(Byte)state;

#pragma mark 蚕豆 0x1c
-(void)getHorseBean;
-(void)setHorseBeanWithType:(Byte)type Value:(Byte)value;
-(void)setHorseBeanStateWithType:(Byte)type State:(Byte)state;

#pragma mark 绿茶 0x1d
-(void)getGreenTea;
-(void)setGreenTeaWithType:(Byte)type Value:(NSInteger)value;
-(void)setGreenTeaStateWithType:(Byte)type State:(Byte)state;

#pragma mark 红茶 0x1e
-(void)getRedTea;
-(void)setRedTeaWithType:(Byte)type Value:(NSInteger)value;
-(void)setRedTeaStateWithType:(Byte)type State:(Byte)state;

#pragma mark 绿茶短梗 0x1f
-(void)getGreenTeaSG;
-(void)setGreenTeaSGWithType:(Byte)type Value:(NSInteger)value;
-(void)setGreenTeaSGStateWithType:(Byte)type State:(Byte)state;

#pragma mark 切换层和视
-(void)changeLayerAndView;

-(void)netWorkSendData;
-(void)netWorkSendDataWithData:(NSData*)data;
-(BOOL)open;
-(void)close;
-(void)closeTimer;
-(void)connectwithString1:(NSString*)string1 String2:(NSString*)string2;
-(void)didnotsend;
-(void)receiveSocketData:(NSData *)data fromAddressIP:(NSString *)IPaddress;

@end
