//
//  valveTitleTableViewCell.m
//  thColorSort
//
//  Created by taiheMacos on 2017/4/11.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "valveTitleTableViewCell.h"

@implementation valveTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat frameWidth = self.frame.size.width;
    [self.chuteTitleLabel setFrame:CGRectMake(10, 0, 40, 44)];
    [self.delayTimeTitleLabel setFrame:CGRectMake(frameWidth/5*1-20, 0, 70, 44)];
    [self.blowTimeTitleLabel setFrame:CGRectMake(frameWidth/5*2-20, 0, 70, 44)];
    [self.ejectTypeTitleLabel setFrame:CGRectMake(frameWidth/5*3-20, 0, 70, 44)];
    [self.centerPointTitleLabel setFrame:CGRectMake(frameWidth/5*4-20, 0, 80, 44)];
}
@end
