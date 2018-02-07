//
//  WaveDataTableViewCell.h
//  thColorSort
//
//  Created by taiheMacos on 2017/3/27.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaveDataView.h"
#import "BaseUITextField.h"
#import "BaseTableViewCell.h"
@interface WaveDataTableViewCell : BaseTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *chuteTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *chuteTextField;
@property (strong, nonatomic) IBOutlet WaveDataView *waveDataView;
@property (assign,nonatomic) NSInteger chuteNumCount;
-(void)bindWaveData:(Byte*)wavedata withIndex:(Byte)index;
-(void)bindWaveColorType:(Byte*)wavetype andColorDiffLightType:(Byte)colorDiffLightType andAlgriothmType:(Byte)alogriothmtype;

-(void)bindWaveDataType:(Byte)type irUseType:(Byte)irType WaveCount:(Byte)count;//信号页面绑定数据
@end
