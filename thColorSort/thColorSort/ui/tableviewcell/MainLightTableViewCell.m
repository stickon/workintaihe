//
//  MainLightTableViewCell.m
//  thColorSort
//
//  Created by taihe on 2017/6/16.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "MainLightTableViewCell.h"
@interface MainLightTableViewCell()<MyTextFieldDelegate>
@end

@implementation MainLightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)MyTextFieldEditingDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:255 Min:0 Value:sender.text.integerValue];
}

- (void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.text.integerValue];
}

@end
