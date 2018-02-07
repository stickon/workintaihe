//
//  RiceSharpenTableViewCell.m
//  thColorSort
//
//  Created by taihe on 2017/12/11.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "RiceSharpenTableViewCell.h"

@implementation RiceSharpenTableViewCell

-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    NSInteger value = sender.text.integerValue;
    [super cellEditValueChangedWithTag:sender.tag AndValue:value];
}
- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:255 Min:1 Value:sender.text.integerValue];
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.isOn];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    [self.SharpenParaTitleLabel setFrame:CGRectMake(20,4 , 100, 36)];
    [self.SharpenParaTextField setFrame:CGRectMake(self.SharpenParaTitleLabel.frame.size.width+20, 5, 50, 40)];
    [self.SharpenUseTitleLabel setFrame:CGRectMake(width/2, 5, 80, 40)];
    [self.SharpenUseSwitch setFrame:CGRectMake(width/2 +100, 6, 60, 31)];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
