//
//  SetSenseSizeLightAreaTableViewCell.m
//  thColorSort
//
//  Created by taihe on 2017/6/9.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "SetSenseSizeLightAreaTableViewCell.h"
#import "types.h"
@interface SetSenseSizeLightAreaTableViewCell()<MyTextFieldDelegate>

@end
@implementation SetSenseSizeLightAreaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.limitBtn.tintColor = [UIColor clearColor];
    self.borderUseBtn.tintColor = [UIColor clearColor];
    self.limitBtn.layer.cornerRadius = 3.0f;
    self.borderUseBtn.layer.cornerRadius = 3.0f;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.text.intValue];
}

- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag == 1) {
        [sender initKeyboardWithMax:1000 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 2){
        [sender initKeyboardWithMax:100 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 3){
        [sender initKeyboardWithMax:31 Min:1 Value:sender.text.integerValue];
    }
}
- (IBAction)btnClicked:(UIButton *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:!sender.selected];
}

@end
