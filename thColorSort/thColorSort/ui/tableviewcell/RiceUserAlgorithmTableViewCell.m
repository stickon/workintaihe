//
//  RiceUserAlgorithmTableViewCell.m
//  thColorSort
//
//  Created by taihe on 2018/2/7.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "RiceUserAlgorithmTableViewCell.h"
static NSInteger g_areaMapMaxSize[16] = {1,9,25,49,81,121,169,225,289,323,357,391,425,459,493,100};
@interface RiceUserAlgorithmTableViewCell()<MyTextFieldDelegate>

@end
@implementation RiceUserAlgorithmTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.group1TextField.textColor = [UIColor colorWithRed:1.0 green:153.0/255.0 blue:18.0/255.0 alpha:1.0];
    self.group2TextField.textColor = [UIColor colorWithRed:6/255.0 green:128/255.0 blue:67/255.0 alpha:1.0];
    self.group3TextField.textColor = [UIColor colorWithRed:0 green:90/255.0 blue:1 alpha:1.0];
    self.group4TextField.textColor = [UIColor colorWithRed:186.0/255.0 green:40/255.0 blue:53/255.0 alpha:1.0];
    [self.groupTextFieldArray addObject:self.group1TextField];
    [self.groupTextFieldArray addObject:self.group2TextField];
    [self.groupTextFieldArray addObject:self.group3TextField];
    [self.groupTextFieldArray addObject:self.group4TextField];
    for (BaseUITextField *obj in self.groupTextFieldArray) {
        obj.hidden = YES;
    }
    svmRange = (Byte*)malloc(4);
}
- (NSMutableArray*)groupTextFieldArray{
    if (!_groupTextFieldArray) {
        _groupTextFieldArray = [NSMutableArray array];
    }
    return _groupTextFieldArray;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)myTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (self.type < 4) {
        [sender initKeyboardWithMax:100 Min:0 Value:sender.text.integerValue];
    }else if (self.type < 6){
         [sender initKeyboardWithMax:199 Min:1 Value:sender.text.integerValue];
    }else if (self.type == 6){
        [sender initKeyboardWithMax:g_areaMapMaxSize[svmRange[sender.tag]] Min:1 Value:sender.text.integerValue];
    }else if (self.type == 7){
        [sender initKeyboardWithMax:255 Min:1 Value:sender.text.integerValue];
    }else if (self.type == 8){
        [sender initKeyboardWithMax:1024 Min:1 Value:sender.text.integerValue];
    }
    
}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.text.intValue];
}
- (IBAction)switchValueChanged:(UISwitch *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.isOn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}
@end
