//
//  TableViewCellWithDefaultTitleLabel1TextField.m
//  thColorSort
//
//  Created by taiheMacos on 2017/5/2.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "TableViewCellWithDefaultTitleLabel1TextField.h"
@interface TableViewCellWithDefaultTitleLabel1TextField()<MyTextFieldDelegate>

@end
@implementation TableViewCellWithDefaultTitleLabel1TextField

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.font = [UIFont systemFontOfSize:15.0];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)myTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if(self.cellType == TableViewCellType_Feeding)
    {
        [sender initKeyboardWithMax:99 Min:1 Value:sender.text.integerValue];
    }else if (self.cellType == TableViewCellType_ValveOpenTime){
        [sender initKeyboardWithMax:12 Min:7 Value:sender.text.integerValue];
    }else if (self.cellType == TableViewCellType_SenseType){
        [sender initKeyboardWithMax:99 Min:0 Value:sender.text.integerValue];
    }else if (self.cellType == TableViewCellType_ColorSense){
        [sender initKeyboardWithMax:199 Min:1 Value:sender.text.integerValue];
    }else if (self.cellType == TableViewCellType_IRSpot){
        [sender initKeyboardWithMax:255 Min:1 Value:sender.text.integerValue];
    }else if(self.cellType == TableViewCellType_IRDiff){
        [sender initKeyboardWithMax:500 Min:0 Value:sender.text.integerValue];
    }else if (self.cellType == TableViewCellType_DevideIRDiff){
        [sender initKeyboardWithMax:255 Min:0 Value:sender.text.integerValue];
    }else if (self.cellType == TableViewCellType_CashewShape){
        [sender initKeyboardWithMax:16000 Min:1 Value:sender.text.integerValue];
    }else if (self.cellType == TableViewCellType_RiceShapeSense1){
        [sender initKeyboardWithMax:1024 Min:1 Value:sender.text.integerValue];
    }else if (self.cellType == TableViewCellType_RiceShapeLimit){
        [sender initKeyboardWithMax:128 Min:1 Value:sender.text.integerValue];
    }else if (self.cellType == TableViewCellType_RiceShapeSense2){
        [sender initKeyboardWithMax:255 Min:1 Value:sender.text.integerValue];
    }else if (self.cellType == TableViewCellType_RiceMirror){
        [sender initKeyboardWithMax:38 Min:0 Value:sender.text.integerValue];
    }
}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.text.intValue];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(20, 2, 150, 40);
    
    self.textField.frame = CGRectMake(self.frame.size.width-100, 4, 49, 36);
}
@end
