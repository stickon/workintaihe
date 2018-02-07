//
//  ColorDiffTypeAndReverseTableViewCell.m
//  thColorSort
//
//  Created by taihe on 2017/12/15.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "ColorDiffTypeAndReverseTableViewCell.h"

@implementation ColorDiffTypeAndReverseTableViewCell


-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    Byte value = (Byte)(sender.text.intValue);
    [super cellEditValueChangedWithTag:sender.tag AndValue:value];
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

- (IBAction)switchValueChanged:(UISwitch *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.isOn];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    [self.colorSenseChuteNumLabel setFrame:CGRectMake(10,4, 50, 36)];
    [self.colorSenseValueTextField setFrame:CGRectMake(width/5*1-10, 5, 60, 36)];
    [self.colorSenseLightUpperLimitValueTextField setFrame:CGRectMake(width/5*2-10, 5, 60, 40)];
    [self.colorSenseLightLowerLimitValueTextField setFrame:CGRectMake(width/5*3-10, 5, 60, 40)];
    [self.reverseUseSwitch setFrame:CGRectMake(width/5*4-10, 5, 60, 40)];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.colorSenseValueTextField.tag = 1;
    self.colorSenseLightUpperLimitValueTextField.tag = 2;
    self.colorSenseLightLowerLimitValueTextField.tag = 3;
    self.reverseUseSwitch.tag = 11;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
