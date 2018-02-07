//
//  WaveDataView.h
//  thColorSort
//
//  Created by taiheMacos on 2017/4/17.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "types.h"

//颜色组合类型（灰度使用）
typedef enum COLOR_COMB_TYPE_TAG
{
    ClrRed				= 0,		//红色
    ClrGreen			= 1,		//绿色
    ClrBlue				= 2,		//蓝色
    ClrRedGreen			= 3,		//红色+绿色
    ClrRedBlue			= 4,		//红色+蓝色
    ClrGreenBlue		= 5,		//绿色+蓝色
    ClrRedGreenBlue		= 6,		//红色+绿色+蓝色
    ClrIR1              = 7,        //红外1
    ClrIR2              = 8         //红外2
}
COLOR_COMB_TYPE;

//颜色比较类型（色差使用）
typedef enum COLOR_COMPARE_TYPE_TAG
{
    ClrRedAboveGreen	= 0,		//红>绿
    ClrRedAboveBlue		= 1,		//红>蓝
    ClrGreenAboveRed	= 2,		//绿>红
    ClrGreenAboveBlue	= 3,		//绿>蓝
    ClrBlueAboveRed		= 4,		//蓝>红
    ClrBlueAboveGreen	= 5		   //蓝>绿
}
COLOR_COMPARE_TYPE;


@interface WaveDataView : UIView
{
    Byte waveData[5][WaveLength];
    Byte calibrationWaveData[5][CalibrationWaveLength];
    Byte _colorDiffLightType;
    Byte _separate;//rgb 一次终止    diff colortype2
    Byte _algriothmtype;
    Byte _colorType;//rgb colortype  diff colortype1
    Byte _firstUpperlimit;
    Byte _firstLowerlimit;
    Byte _secondUpperlimit;
    Byte _secondLowerlimit;
}
@property (nonatomic,assign) CGFloat gridWidth;//网格宽度
@property (nonatomic,assign) CGFloat gridHeight;//网格高度
@property (nonatomic,assign) WaveDataType waveDataType;// 灰度 色差 亮度 灯光 相机增益
@property (nonatomic,assign) Byte irUseType;//红外类型，针对相机增益
@property (nonatomic,assign) Byte viewIndex;//前\后视
@property (nonatomic,assign) Byte dataType;////数据类型   0：详细数据 1：压缩数据  2：相机调整
@property (nonatomic,assign) CGFloat currentShowWaveLength;
@property (nonatomic,assign) Byte waveDataCount;//显示的波形的数量
-(void)bindWaveData:(Byte*)wavedata withIndex:(Byte)index;
-(void)bindCalibrationWaveData:(Byte*)calibrationwavedata withIndex:(Byte)index;
-(void)bindWaveColorType:(Byte*)wavetype andColorDiffLightType:(Byte)colorDiffLightType andAlgriothmType:(Byte)alogriothmtype;
-(void)bindColorDiffLightType:(Byte)colorDiffLightType;



//信号相关
-(void)bindWaveDataType:(Byte)type irUseType:(Byte)irType WaveCount:(Byte)count;
-(void)displayView;

-(void)initGridView;
@end
