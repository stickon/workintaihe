//
//  types.h
//  thColorSort
//
//  Created by taihe on 2017/5/20.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#ifndef types_h
#define types_h
#import "InternationalControl.h"
#define Combine(x,y) ((x<<8)|y)
#define WaveLength 256
#define CalibrationWaveLength 512
#define TaiheColor colorWithRed:1.0/255.0 green:181.0/255.0 blue:178.0/255.0 alpha:1.0
#define kLanguageForKey(X) [[InternationalControl languageDictionary] valueForKey:@#X]
#define kDataModel [DataModel globalDataModel]
#define gNetwork [NetworkFactory sharedNetWork]
#define gMiddeUiManager [MiddleManager shareInstance]
//字体
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT_15f   [UIFont systemFontOfSize:15.0f]
#define SYSTEMFONT_14f   [UIFont systemFontOfSize:14.0f]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]


//机器类型
typedef NS_ENUM(Byte,MachineType) {
 MACHINE_TYPE_CHUTE     =0,	      //单层滑道式
 MACHINE_TYPE_WHEEL     =1,	      //单层履带式
 MACHINE_TYPE_CHUTE_2   =2,	      //双层滑道式，前排后排
 MACHINE_TYPE_WHEEL_2	=3,	      //双层履带式，上下两层履带
 MACHINE_TYPE_TEA	    =4,    //茶叶机，上层前视，下层前后视
 MACHINE_TYPE_CHUTE_3	=5,	      //三层茶叶机，上层、中层前视，下层前后视
 MACHINE_TYPE_CHUTE_4	=6,	      //四层茶叶机，所有层都只有前视
};
//波形类型
typedef NS_ENUM(NSUInteger,WaveDataType) {
    wave_rgb=0x00,
    wave_diff,
    wave_light,
    wave_background,
    wave_cameraGain,
    wave_cameraGainDigit,
    wave_rgb_IR,
    wave_diff_IR,
    wave_origin,
    wave_calibration,
    wave_test_data,
    wave_rgb_restrain = 0x11,
    wave_hsv,
};
//型选类型定义
enum SHAPE_NAME
{
    SHAPE_NONE					= 1,					//无形选
    SHAPE_TEA_TIEGUANYIN		= 2,					//铁观音
    SHAPE_TEA_DAHONGPAO			= 3,					//大红袍
    SHAPE_TEA_HONGCHA			= 4,					//红茶 ---
    SHAPE_TEA_SRILANKA			= 5,					//斯里兰卡红茶
    SHAPE_CASHEW				= 6,					//腰果
    SHAPE_CORN					= 7,					//玉米
    SHAPE_PEANUTBUD				= 8,					//花生芽头
    SHAPE_WHEAT					= 9,					//小麦
    SHAPE_SEEDRICE				= 10,					//稻种
    SHAPE_SUN_FLOWER			= 11,					//葵花籽
    SHAPE_BLACK_QOUQI			= 12,					//枸杞  ---
    SHAPE_TEA_LVCHA				= 13,					//绿茶
    SHAPE_PEANUT				= 14,					//花生  ---
    SHAPE_RICE					= 15,					//大米形选
    SHAPE_STANDARD				= 16,					//标准形选
    SHAPE_GENERAL_TEA			= 17,					//通用茶叶
    SHAPE_LIQUORICE             = 18,                   //甘草
    SHAPE_HORSEBEAN             = 19,                   //蚕豆
    
    SHAPE_GREENTEA_SHORTSTEM    = 20,                   //绿茶短梗
    //无效形选索引，超过或等于这个索引值表示无效
    //请在上面添加新增的形选类型
    SHAPE_INVILID,
};


typedef NS_ENUM(Byte,IRType) {
    IRType_NO = 0,
    IRType_Single_Front,
    IRType_Single_Rear,
    IRType_Single_FrontRear,
    IRType_Double_Front,
    IRType_Double_Rear,
    IRType_Double_FrontRear,
    IRType_DoubleDevide_Front,
    IRType_DoubleDevide_Rear,
    IRType_DoubleDevice_FrontRear,
};
typedef NS_ENUM(Byte,LightType){
    LightType_R = 1,
    LightType_G,
    LightType_B,
    LightType_MainLight,
    LightType_IR,
};
typedef NS_ENUM(Byte,COUNTRY_TYPE)
{	COUNTRY_BEGIN,
    COUNTRY_CHINESE           = 1,  //中文
    COUNTRY_ENGLISH           = 2,	//英文
    COUNTRY_CHINESE_TAIWAN	  = 3,	//繁体中文
    COUNTRY_RUSSIAN           = 4,	//俄文
    COUNTRY_TURKEY            = 5,	//土耳其
    COUNTRY_CAMBODIA          = 6,	//柬埔寨
    COUNTRY_VIETNAM           = 7,	//越南语
    COUNTRY_THAI              = 8,	//泰语
    COUNTRY_SPAIN             = 9,	//西班牙
    COUNTRY_POLAND            = 10,	//波兰
    COUNTRY_BURMA             = 11,	//缅甸
    COUNTRY_PERSIA            = 12,	//波斯语
    COUNTRY_UKRAINE           = 13, //乌克兰语
    COUNTRY_ITALY             = 14,	//意大利语
    COUNTRY_GREEK             = 15,	//希腊语
    COUNTRY_UIGHUR            = 16,	//维吾尔族语
    COUNTRY_ARABIC            = 17, //阿拉伯语
    COUNTRY_KOREAN            = 18, //韩语
    COUNTRY_END
};
#endif /* types_h */
