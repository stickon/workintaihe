//
//  TableViewCellWith1button.m
//  thColorSort
//
//  Created by taiheMacos on 2017/5/2.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "TableViewCellWith1button.h"

@implementation TableViewCellWith1button
- (IBAction)buttonClicked:(UIButton *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:0];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.button.frame = CGRectMake(self.frame.size.width/2-100, 5, 200, 40);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.button.layer.cornerRadius = 3.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
