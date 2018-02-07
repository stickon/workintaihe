//
//  TableViewCellWithDefaultLabelAnd1UIImageView.m
//  thColorSort
//
//  Created by taihe on 2017/5/24.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "TableViewCellWithDefaultLabelAnd1UIImageView.h"

@implementation TableViewCellWithDefaultLabelAnd1UIImageView

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
    self.textLabel.frame = CGRectMake(10, 5, 150, 44);
    //    self.accessoryView.frame = CGRectMake(self.frame.size.width-50, 6, 49, 31);
    
    self.myImageView.frame = CGRectMake(self.frame.size.width-100, 6, 40, 40);
}

@end
