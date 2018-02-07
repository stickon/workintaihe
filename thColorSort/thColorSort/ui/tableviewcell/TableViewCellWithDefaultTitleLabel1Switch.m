//
//  TableViewCellWithDefaultTitleLabel1Switch.m
//  thColorSort
//
//  Created by taiheMacos on 2017/5/2.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "TableViewCellWithDefaultTitleLabel1Switch.h"

@implementation TableViewCellWithDefaultTitleLabel1Switch

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)switchBtnClicked:(UISwitch *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.isOn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(20, 0, 150, 40);
    self.accessoryView.frame = CGRectMake(self.frame.size.width-50, 6, 49, 31);

    self.switchBtn.frame = CGRectMake(self.frame.size.width-100, 6, 49, 31);
}

@end
