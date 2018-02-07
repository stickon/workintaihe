//
//  CameraGainTableViewCell.m
//  thColorSort
//
//  Created by taihe on 2017/6/16.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "CameraGainTableViewCell.h"
@interface CameraGainTableViewCell()<MyTextFieldDelegate>

@end

@implementation CameraGainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)MyTextFieldEditingDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (self.gainType == 0) {
        if (sender.tag<4 ||(sender.tag>10&&sender.tag<14)) {
            [sender initKeyboardWithMax:1023 Min:0 Value:sender.text.integerValue];
        }else
            [sender initKeyboardWithMax:31 Min:0 Value:sender.text.integerValue];
    }else{
        if(sender.tag <4 || (sender.tag>10&&sender.tag<14)){
        [sender initKeyboardWithMax:255 Min:1 Value:sender.text.integerValue];
        }else{
            [sender initKeyboardWithMax:4 Min:0 Value:sender.text.integerValue];
        }
    }
}

- (void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.text.integerValue];
}
@end
