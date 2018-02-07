//
//  CameraGainSettingTableViewCell.m
//  thColorSort
//
//  Created by taihe on 2017/6/16.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "CameraGainSettingTableViewCell.h"

@implementation CameraGainSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.checkBtn.layer.cornerRadius=5;
    self.checkBtn.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)ajustAllBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.selected];
}

- (IBAction)segmentedControlChanged:(UISegmentedControl *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.selectedSegmentIndex];
}
@end
