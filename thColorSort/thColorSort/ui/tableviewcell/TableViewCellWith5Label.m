//
//  TableViewCellWith5Label.m
//  thColorSort
//
//  Created by taiheMacos on 2017/4/17.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "TableViewCellWith5Label.h"

@implementation TableViewCellWith5Label

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
