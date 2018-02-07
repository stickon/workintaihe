//
//  TableViewCellWith1Label1Switch.m
//  thColorSort
//
//  Created by taiheMacos on 2017/4/14.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "TableViewCellWith1Label1Switch.h"

@implementation TableViewCellWith1Label1Switch

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.hidden = YES;
    self.titleTextLabel.font = [UIFont systemFontOfSize:15.0];
    // Initialization code
}
- (IBAction)switchBtnClicked:(UISwitch *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.isOn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if(self.alignment == CellLabelLeftAlignment){
        self.titleTextLabel.frame = CGRectMake(20, 0, 180, 40);
    }
    else{
        self.titleTextLabel.frame = CGRectMake(self.frame.size.width/2-90, 0, 180, 40);
    }
    self.switchBtn.frame = CGRectMake(self.frame.size.width-60, 6, 51, 31);
}

-(void)setSwitchBtnState:(Byte)state{
    if (state == 1) {
        [_switchBtn setOn:true];
    }else{
        [_switchBtn setOn:false];
    }
}

@end
