//
//  AlgorithmTableViewCell.m
//  thColorSort
//
//  Created by taiheMacos on 2017/3/22.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "AlgorithmTableViewCell.h"
@interface AlgorithmTableViewCell()<MyTextFieldDelegate>
@end
@implementation AlgorithmTableViewCell

-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    Byte value = (Byte)(self.algorithmValue.text.intValue);
    [super cellEditValueChangedWithTag:sender.tag AndValue:value];
}
- (IBAction)myTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:99 Min:0 Value:sender.text.integerValue];
}

- (IBAction)alogrithmdidEndOnExit:(UITextField *)sender {
    Byte value = (Byte)(self.algorithmValue.text.intValue);
    [super cellEditValueChangedWithTag:sender.tag AndValue:value];
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
