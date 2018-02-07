//
//  SetSenseSizeTableViewCell.m
//  thColorSort
//
//  Created by taiheMacos on 2017/3/24.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "SetSenseSizeTableViewCell.h"
@interface SetSenseSizeTableViewCell()<MyTextFieldDelegate>
@end
@implementation SetSenseSizeTableViewCell

-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.text.intValue];
}

- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag == 1) {
        [sender initKeyboardWithMax:38 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 2){
        [sender initKeyboardWithMax:19 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 3){
        if (self.isIRDiff) {
            [sender initKeyboardWithMax:63 Min:1 Value:sender.text.integerValue];
        }else{
            NSInteger length =  self.lengthTextField.text.integerValue;
            NSInteger width = self.widthTextField.text.integerValue;
            [sender initKeyboardWithMax:length*width Min:1 Value:sender.text.integerValue];
        }
    }else if(sender.tag == 4){
        if (self.isIRDiff == 1) {
            [sender initKeyboardWithMax:100 Min:1 Value:sender.text.integerValue];
        }else if(self.isIRDiff == 2){
            NSInteger length =  self.lengthTextField.text.integerValue;
            NSInteger width = self.widthTextField.text.integerValue;
            [sender initKeyboardWithMax:length*width Min:1 Value:sender.text.integerValue];
        }
    }
}
- (IBAction)switchValueChanged:(UISwitch *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.isOn];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"awakefromnib");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
