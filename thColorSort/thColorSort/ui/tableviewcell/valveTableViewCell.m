//
//  valveTableViewCell.m
//  thColorSort
//
//  Created by taiheMacos on 2017/4/11.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "valveTableViewCell.h"
#import "BaseUITextField.h"
@interface valveTableViewCell()<MyTextFieldDelegate>

@end
@implementation valveTableViewCell

-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    Byte value = sender.text.intValue;
    [super cellEditValueChangedWithTag:sender.tag AndValue:value];
}

- (IBAction)MytextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag == 3) {
        [sender initKeyboardWithMax:255 Min:8 Value:sender.text.integerValue];
    }else if (sender.tag == 4){
        [sender initKeyboardWithMax:160 Min:12 Value:sender.text.integerValue];
    }else if (sender.tag == 5){
        [sender initKeyboardWithMax:1 Min:0 Value:sender.text.integerValue];
    }
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.isOn];
}
- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    Byte value = sender.selectedSegmentIndex;
    [super cellEditValueChangedWithTag:sender.tag AndValue:value];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat frameWidth = self.frame.size.width;
    [self.chuteNumLabel setFrame:CGRectMake(10, 4, 40, 36)];
    [self.delayTimeTextField setFrame:CGRectMake(frameWidth/5*1-10, 4, 50, 36)];
    [self.blowTimeTextField setFrame:CGRectMake(frameWidth/5*2-10, 4, 50, 36)];
    [self.ejectTypeSegmentedControl setFrame:CGRectMake(frameWidth/5*3-10, 4, 50, 36)];
    [self.centerPointSwitch setFrame:CGRectMake(frameWidth/5*4-10, 4, 50, 36)];
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
