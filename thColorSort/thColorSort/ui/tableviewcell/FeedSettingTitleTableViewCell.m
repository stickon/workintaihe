//
//  FeedSettingTitleTableViewCell.m
//  thColorSort
//
//  Created by taihe on 2017/7/10.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "FeedSettingTitleTableViewCell.h"

@implementation FeedSettingTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.feedChuteTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.feedTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.feedSwitchTitleLabel.textAlignment = NSTextAlignmentCenter;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.feedChuteTitleLabel.frame = CGRectMake(0, 2, 80, 40);
    self.feedTitleLabel.frame = CGRectMake(self.frame.size.width/2-40, 2, 80, 40);
    self.feedSwitchTitleLabel.frame = CGRectMake(self.frame.size.width-80, 2, 80, 40);
}

@end
