//
//  valveOpenTimeTableViewCell.m
//  thColorSort
//
//  Created by taiheMacos on 2017/4/11.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "valveOpenTimeTableViewCell.h"
@interface valveOpenTimeTableViewCell()<MyTextFieldDelegate>


@end

@implementation valveOpenTimeTableViewCell

-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    Byte value = sender.text.intValue;
    [super cellEditValueChangedWithTag:sender.tag AndValue:value];
}
- (IBAction)textFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:12 Min:7 Value:sender.text.integerValue];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
