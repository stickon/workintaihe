//
//  ColorSenseValueAndLightValueTableViewCell.m
//  thColorSort
//
//  Created by taiheMacos on 2017/3/24.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "ColorSenseValueAndLightValueTableViewCell.h"

@interface ColorSenseValueAndLightValueTableViewCell()<MyTextFieldDelegate>

@end

@implementation ColorSenseValueAndLightValueTableViewCell


-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    Byte value = (Byte)(sender.text.intValue);
    [super cellEditValueChangedWithTag:sender.tag AndValue:value];
//    if ([self.delegate respondsToSelector:@selector(cellValueChangedWithSection:row:tag:value:)]) {
//        [self.delegate cellValueChangedWithSection:self.section row:self.row tag:(int)sender.tag value:value];
//    }
}
- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag == 1) {
        [sender initKeyboardWithMax:199 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 2){
        [sender initKeyboardWithMax:255 Min:self.colorSenseLightLowerLimitValueTextField.text.integerValue+1 Value:sender.text.integerValue];
    }else if (sender.tag == 3){
        [sender initKeyboardWithMax:self.colorSenseLightUpperLimitValueTextField.text.integerValue Min:0 Value:sender.text.integerValue];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    [self.colorSenseChuteNumLabel setFrame:CGRectMake(10,4, 50, 36)];
    [self.colorSenseValueTextField setFrame:CGRectMake(width/4*1-10, 5, 60, 36)];
    [self.colorSenseLightUpperLimitValueTextField setFrame:CGRectMake(width/4*2-10, 5, 60, 40)];
    [self.colorSenseLightLowerLimitValueTextField setFrame:CGRectMake(width/4*3-10, 5, 60, 40)];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
