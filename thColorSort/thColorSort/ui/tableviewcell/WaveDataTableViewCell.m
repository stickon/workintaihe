//
//  WaveDataTableViewCell.m
//  thColorSort
//
//  Created by taiheMacos on 2017/3/27.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "WaveDataTableViewCell.h"
@interface WaveDataTableViewCell()<MyTextFieldDelegate>
@end
@implementation WaveDataTableViewCell

-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.text.integerValue];
}
- (IBAction)myTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:self.chuteNumCount Min:1 Value:sender.text.integerValue];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CGFloat width =[UIScreen mainScreen].bounds.size.width-40;
    CGFloat height = (width-40)*0.618+20;
    self.waveDataView.frame = CGRectMake(3, 10, width,height);
    self.chuteTextField.text = @"1";
    [self.waveDataView initGridView];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)bindWaveData:(Byte*)wavedata withIndex:(Byte)index
{
    [_waveDataView bindWaveData:wavedata withIndex:index];
}

-(void)bindWaveColorType:(Byte*)wavetype andColorDiffLightType:(Byte)colorDiffLightType andAlgriothmType:(Byte)alogriothmtype
{
    [_waveDataView bindWaveColorType:wavetype andColorDiffLightType:colorDiffLightType andAlgriothmType:alogriothmtype];
    [_waveDataView displayView];
}

-(void)bindWaveDataType:(Byte)type irUseType:(Byte)irType WaveCount:(Byte)count{
    [self.waveDataView bindWaveDataType:type irUseType:irType WaveCount:count];
    [self.waveDataView displayView];
}

@end
