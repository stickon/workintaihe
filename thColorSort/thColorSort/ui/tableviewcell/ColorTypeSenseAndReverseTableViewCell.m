//
//  ColorTypeSenseAndReverseTableViewCell.m
//  thColorSort
//
//  Created by taihe on 2017/12/8.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "ColorTypeSenseAndReverseTableViewCell.h"

@implementation ColorTypeSenseAndReverseTableViewCell

-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    NSInteger value = sender.text.integerValue;
    [super cellEditValueChangedWithTag:sender.tag AndValue:value];
}
- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:99 Min:0 Value:sender.text.integerValue];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (IBAction)switchValueChanged:(UISwitch *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.isOn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    [self.chuteNum setFrame:CGRectMake(10,4 , 50, 36)];
    [self.chuteSenseTimes1Value setFrame:CGRectMake(width/4*1-10, 5, 60, 40)];
    [self.chuteSenseTimes2Value setFrame:CGRectMake(width/4*2-10, 5, 60, 40)];
    [self.reverseSwitch setFrame:CGRectMake(width/4*3-10, 5, 60, 40)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
