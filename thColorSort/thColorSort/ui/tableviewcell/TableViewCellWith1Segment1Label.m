//
//  TableViewCellWith1Segment1Label.m
//  thColorSort
//
//  Created by taihe on 2017/5/17.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "TableViewCellWith1Segment1Label.h"

@implementation TableViewCellWith1Segment1Label

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    [self cellEditValueChangedWithTag:sender.tag AndValue:sender.selectedSegmentIndex];
}

@end
