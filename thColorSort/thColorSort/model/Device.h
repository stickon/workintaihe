//
//  Device.h
//  thColorSort
//
//  Created by taiheMacos on 2017/3/15.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "types.h"


typedef struct
{
    //状态
    Byte valveState;         //阀状态
    Byte feederState;        //给料器
    Byte startState;         //启动状态
    Byte cleanState;         //清灰状态
    
    Byte machineType;        //机器类型
    Byte layerNumber;        //层数
    Byte chuteNumber;        //通道数

    Byte shapeType;                 //型选类型
    Byte useIR;                     //是否使用红外
    Byte useSvm;                    //是否使用SVM
    Byte useColor;           //色选算法的个数，0：未使用

    Byte hasRearView[6];     //每层是否有后视

    Byte fristVib;	     //第一通道给料量
    
    Byte vibIn;              //进料开关状态        //>1,不显示
    Byte vibOut;             //出料开关状态        //>1,不显示
    Byte useSensor;          //使用料位传器
    
    Byte wheel[3];           //履带开关   3层，目前只用二层[ 0：关 1：表示开]


    //方案参数
    Byte			sortModeBig;     //大模式
    SignedByte 			sortModeSmall;   //小模式
    char            modeName[100];    //当前方案名称
    Byte            useHsv;            //是否使用hsv
}MachineData;
typedef struct ColorAlgorithm
{
    Byte type;            //算法类型 [1-6]
    Byte view;            //前视、后视[0/1]
    Byte sense[2];           //灵敏度值  sense[0]:高位  sense[1]:低位
    Byte used;            //使能是否打开
    char name[100];       //算法名称
}ColorAlgorithm;

typedef struct RiceUserAlgorithm{
    Byte type;
    Byte view;
    Byte sense[4][2];
    Byte range[4];
    Byte used;
    char name[100];
}RiceUserAlgorithm;

typedef struct sense
{
    Byte layer;           //层
    Byte view;            //视
    Byte algorithm;       //算法
    Byte width;           //长
    Byte height;          //宽
    Byte size[2];            //点数
    Byte fSameR;          //前后视相同
    Byte color;           //色差颜色
}Sense;
typedef struct RiceSense{//针对选大米用
    Byte repair; //修复值
    Byte sharpenUse; //是否增强
    Byte sharpenValue; //锐化值
}RiceSense;
typedef struct{
    Byte algorithm;
    Byte layer;
    Byte view;
    Byte ch;
    Byte type;
}RequestWaveType;
typedef struct waveType
{
    Byte waveDataColorType;
    Byte terminal;//一次终止 灰度分割点
    Byte firstUpperLimit;
    Byte firstLowerLimit;
    Byte SecondUpperLimit;
    Byte SecondLowerLimit;
}WaveType;

typedef struct CleanPara
{
    Byte cleanCycle;
    Byte cleanDelay;
    Byte cleanTime;
    Byte cleanSwitch;
}CleanPara;

typedef struct ValvePara
{
    Byte openValveTime;
    Byte valveWorkMode;
}ValvePara;

typedef struct BaseVersion
{
    Byte control[2];
    Byte convert[2];
    Byte led[2];
    Byte sensor[2];
    Byte wheel[2];
    Byte loaded;
}BaseVersion;

typedef struct ColorBoardVersion
{
    Byte ch;
    Byte arm[2];
    Byte fpga[2];
    Byte hardware[2];
}ColorBoardVersion;

typedef struct CameraVersion
{
    Byte ch;
    Byte front_software[2];
    Byte front_hardware[2];
    Byte rear_software[2];
    Byte rear_hardware[2];
}CameraVersion;

typedef struct
{
    Byte r[2]; 		  	//r
    Byte g[2];         	//g
    Byte b[2];         	//b
    Byte MainLight[2];     //前后主灯
    Byte ir[2];  		    //前后红外开关
}LightSetting;

typedef struct{
    Byte r[4]; 		//r  r[0] :front high r[1]: front low ; r[2] :rear high r[3]: rear low
    Byte g[4];         	//g
    Byte b[4];         	//b
    Byte ir1[2];           //红外1
    Byte ir2[2];  		//红外2
}CameraGain;

typedef struct Mode //方案
{
    Byte rgbSpot[2][2]; 			//[前/后] [上限/下限]是否使用
    Byte rgbSpotColor[2];           //[前/后], 颜色索引
    Byte rgbArea[2][2];         	//
    Byte rgbAreaColor[2];          	//
    Byte diff1[2][3];  			//色差1  1：是否使用，2：颜色索引 3：亮度限制颜色索引
    Byte diff2[2][3];  			//色差2
    Byte FrontRearRelation ;     	//前与后
    //红外部分
    Byte irRgb[2][2]; 			//[前/后] [上限/下限]是否使用
    Byte irRgbColor[2];         //[前/后], 颜色索引
    Byte irDiff[2]; 			//[前/后] 是否使用
    Byte irDiffColor[2];         //[前/后], 颜色索引
    Byte lightLimit[2];          //[前/后]亮度区域使用
    Byte lightLimitColor[2];     //[前/后]亮度区域颜色
    Byte UseRiceReverse;         // 大米反选
    Byte UseRiceWhite;           // 大米芯白
}Mode;

typedef struct{//履带
    Byte state;//开关
    Byte speed[2];//转速
    Byte settingSpeedMin[2];//最小设置速度
    Byte settingSpeedMax[2];//最大设置速度
}Caterpillar;
typedef struct
{
    Byte used;
    Byte blowSample;
    Byte spotDiff_1[2];  //1次杂质比
    Byte sensor_1;   //1次灵敏度
    Byte spotDiff_2[2];  //2次杂质比
    Byte sensor_2;   //2次灵敏度
}Svm;

typedef struct//腰果形选
{
    Byte useType; 			//选中状态 0：禁用 1：选小 2：选大
    Byte textView[3][2];     //选大灵敏度小，选小灵敏度 灰尘限制
}CashewSet;

typedef struct//大米形选
{
    Byte buttonUse[2];		//4 button 从左到右，从上到下
    Byte textView[3][2];    //3 edit 从左到右，从上到下,双字节};
}RiceShape;

typedef struct//标准形选和通用茶叶
{
    Byte buttonUse[5];
    Byte textView[10][2];
    
}StandardShapeSet;

typedef struct//花生芽头
{
    Byte buttonUse[3];			//1次二次灵敏度
    Byte textView[2];   //1次二次,皮抑制开关
    Byte isHasSecond;          //是否有二次
}PeanutbudSet;

typedef struct{//协议 3 花生芽头
    Byte buttonUse[3];  //同上
    Byte textView[12];
    Byte isHasSecond;
} Peanutbud3Set;
typedef struct//茶叶 铁观音和大红袍
{
    Byte buttonUse[4];		//4 button 从左到右，从上到下
    Byte textView[5][2];    //5 edit 从左到右，从上到下,双字节
}TeaShapeSet;
typedef struct//甘草
{
    Byte buttonUse[4];		//4 button 从左到右，从上到下
    Byte textView[7];      //7 edit 从左到右，从上到下,双字节
}Licorice;

typedef struct // 小麦
{
    Byte buttonUse;		//1 button 从左到右，从上到下
    Byte textView[4][2];    //4 edit 从左到右，从上到下,双字节};
    Byte isHasSecond;          //是否有二次
}WheatShapeSet;

typedef struct //稻种
{
    Byte buttonUse;		//1 button 从左到右，从上到下
    Byte textView[8];    //8 edit 从左到右，从上到下,单字节};
    Byte isHasSecond;          //是否有二次
}SeedShapeSet;


typedef struct
{
    Byte buttonUse;		//1 button 从左到右，从上到下
    Byte textView[4][2];    //4 edit 从左到右，从上到下,双字节};
    Byte isHasSecond;          //是否有二次
}SunflowerShapeSet;

typedef struct
{
    Byte buttonUse[2];		//2 button 从左到右，从上到下
    Byte textView[8];       //8 edit 从左到右，从上到下,单字节};
}CornShapeSet;

typedef struct
{
    Byte buttonUse[2];		//2 button 从左到右，从上到下
    Byte textView[4];      //4 edit 从左到右，从上到下,单字节};
}HorseBeanShapeSet;

typedef struct
{
    Byte buttonUse[3];		//3 button 从左到右，从上到下
    Byte textView[3];      //4 edit 从左到右，从上到下,单字节};
    Byte lastView[2];       //最后一个文本框，双字节
}GreenTeaShapeSet;
typedef struct
{
    Byte buttonUse[4];		//4 button 从左到右，从上到下
    Byte textView[9];      //8 edit 从左到右，从上到下,单字节（杂质大小双字节），
}RedTeaShapeSet;


typedef struct
{
    Byte buttonUse[4];		//4 button 从左到右，从上到下
    Byte textView[4];      //4 edit 从左到右，从上到下,单字节
    Byte lastView [2];      //最后一个EDIT 双字节
}GreenTeaSGShapeSet;
typedef struct{
    Byte year[2];
    Byte month;
    Byte day;
    Byte hour;
    Byte minute;
    Byte second;
    Byte totalTime[4];
    Byte workTime[4];
}WorkTime;//机器工作时间

typedef struct{
    Byte ch;
    Byte inOutData[2];//入料 和 出料器的给料量
}VibSet;

typedef struct{
    Byte  v[2];           //v上限下限,2个字节
    Byte  s[2];           //s上限下限
    Byte  h[2][2];        //h上限下限
    Byte  width;          //长
    Byte  height;         //宽
    Byte  number[2]; //杂质个数 2个字节
    Byte  hsvUse;    //使能
}HsvSense;

@interface Device : NSObject
{
    @public
    Byte screenProtocolMainVersion;//当前连接的屏的协议的主版本号
    Byte screenProtocolMinVersion;//次版本号
    Byte screenProtocolType;//协议类型，大米机型为1 其它机型为0
    MachineData machineData;
    ColorAlgorithm *colorAlgorithm;
    ColorAlgorithm *irAlgorithm;
    RiceUserAlgorithm *riceUserAlgorithm;
    Sense sense;
    RiceSense riceSense;
    Byte reverse;//镜像   0 无  1 有
    Byte sharpen;//锐化 0 无  1 有
    Byte irSharpenEnable;//红外锐化使用禁用
    Byte irSharpenValue;//红外锐化值
    Byte IsirDiffOrSpot;//设置杂质大小中是否为红外比例 比例为0 点数为1
    Byte irDiffOrSpot[2];//设置杂质大小中存放红外比例或点数
    Byte lightAreaLimit;//亮度区域高级设置杂质大小中 上限 下限
    Byte lightAreaBorderUse;//亮度区域高级设置杂质大小中 边缘使能
    Byte *data1;//x:实际数量  如果是RGB，一次的值；
    Byte *data2;//x:实际数量 如果是RGB，二次的值；如果是色差，亮度下限的值
    Byte *data3;//x:实际数量 如果是色差，亮度下限的值
    Byte *data4;//x:反选的值
    Byte waveData[5][WaveLength];//r g b ir1 ir2
    Byte waveDataCount;
    Byte calibrationWaveData[5][CalibrationWaveLength];//光学校准数据
    Byte hsvPointX[1024];//hsv 噪声点x坐标
    Byte hsvPointY[1024];//hsv 噪声点y坐标
    Byte hsvLight[256];//hsv亮度线
    RequestWaveType requestWaveType;
    WaveType waveType;
    CleanPara cleanPara;
    ValvePara valvePara;
    Byte *delayTime;//阀设置
    Byte *blowTime;
    Byte *ejectorType;
    Byte *bUseCenterPoint;
    
    /***软件版本**/
    BaseVersion baseVersion;
    ColorBoardVersion *colorBoardVersion;
    CameraVersion *normalCameraVersion;
    CameraVersion *infraredCameraVersion;
    CameraVersion *infraredCameraVersion2;//双红外
    LightSetting lightSetting;
    CameraGain cameraGain;
    Mode *mode;
    
    Byte shape;              	//型选索引,0 不使用。
    Byte useSvm;                	//智能分选 0不使用 1使用
    Byte useHsv;                //色度分选 0不使用 1使用
    Byte valveCount;
    Byte valveFrontRear;
    Byte *frontValveFrequency;
    Byte *rearValveFrequency;
    Byte *valveFrequency;
    Caterpillar caterpillar; //当前层履带
    Byte waveAvgData;
    Byte waveDiffData;
    
    WorkTime workTime;//系统工作时间
    
    Svm svm;
    Byte showSvmSecond;//是否显示svm二次
    Byte svmIsProportion;//比例还是点数 比例1 点数0
    
    HsvSense hsv[2];//灵敏度1 灵敏度2
    BOOL hasHsv2;//是否有hsv2
    Byte currentHsvIndex;//当前hsv索引
    Byte currentHsvLightColorIndex;//当前hsv亮度线颜色索引
    Byte hsvOffset;//是否偏移
    CashewSet cashew;//腰果
    RiceShape riceShape;//大米
    PeanutbudSet peanutbud;//花生芽头
    Peanutbud3Set peanutbud3;//花生芽头3
    StandardShapeSet standardShape;//标准形选和通用茶叶
    TeaShapeSet tea;//茶叶
    Licorice licorice;//甘草
    WheatShapeSet wheat;// 小麦
    SeedShapeSet seed;//稻种
    SunflowerShapeSet sunflower;
    CornShapeSet corn;
    HorseBeanShapeSet horseBean;//蚕豆
    GreenTeaShapeSet greenTea;//绿茶
    RedTeaShapeSet redTea;
    GreenTeaSGShapeSet greenTeaSG;//绿茶短梗
    VibSet vibSet;
    Byte *vibdata;//每个通道的给料量
    Byte *vibSwitch;//每个通道的给料量开关
    
    
    Byte groupNum;//大米分次
    int groupLastSort[4];
    Byte SortBelongToGroup[10];
    
}
@property (nonatomic,strong) NSString *deviceName;
@property (nonatomic,strong) NSString *deviceID;
@property (nonatomic,strong) NSString *deviceIP;
@property (nonatomic,assign) Byte errorState;//失败类型 1: 配置文件错误 2: 控制板通信异常，不能启动3: 气压异常，不能启动
@property (nonatomic,strong) NSString *modeName;//用于首页显示的当前方案名称
@property (nonatomic,assign) NSInteger colorAlgorithmNums;
@property (nonatomic,assign) NSInteger irAlogrithmNum;

@property (nonatomic,assign) NSInteger userAlgorithmNums;//用户版本显示的算法数量
@property (nonatomic,assign) Byte currentLayerIndex;
@property (nonatomic,assign) Byte currentSorterIndex;
@property (nonatomic,assign) Byte currentViewIndex;
@property (nonatomic,assign) Byte currentGroupIndex;
@property (nonatomic,assign) Byte groupNum;
@property (nonatomic,strong) NSMutableString *displayScreenVersion;
@property (nonatomic,strong) NSMutableArray *modeList1;//大方案1中小方案列表数组
@property (nonatomic,strong) NSMutableArray *modeList2;//大方案2中小方案列表数组
@property (nonatomic,strong) NSMutableArray *modeList3;//大方案3中小方案列表数组
@property (nonatomic,strong) NSMutableArray *modeList4;//大方案4中小方案列表数组
@property (nonatomic,strong) NSMutableArray *modeList5;//大方案5中小方案列表数组

@property (nonatomic,strong) NSMutableArray *bigModeList;//大方案列表数组

@property (nonatomic,assign) Byte currentSelectBigModeIndex;//当前选择查看的大模式索引
@property (nonatomic,assign) Byte addDigitGain;//是否显示数字增益
@property (nonatomic,assign) Byte currentCameraGain;// 0模拟 1数字
@property (nonatomic,strong) NSString *sysCheckInfo;//系统自检信息

@property (nonatomic,strong) NSString *offlineDeviceID;//下线的设备名称
-(instancetype)initWithName:(NSString*)deviceName ID:(NSString*)deviceID IP:(NSString*)deviceIP;
-(BOOL)bHaveChuteUseReverse;// 是否有料槽使用反选功能
@end
