//
//  IRSharpenTableViewCell.m
//  thColorSort
//
//  Created by taihe on 2017/12/7.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "IRSharpenTableViewCell.h"

@implementation IRSharpenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.SharpenUseBtn.tintColor = [UIColor clearColor];
    self.SharpenUseBtn.layer.cornerRadius = 3.0f;
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
    [sender initKeyboardWithMax:19 Min:2 Value:sender.text.integerValue];

}
- (IBAction)btnClicked:(UIButton *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:!sender.selected];
}
@end
