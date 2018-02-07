//
//  TableViewCellWithDefaultLabel2Button.m
//  thColorSort
//
//  Created by taihe on 2017/5/6.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "TableViewCellWithDefaultLabel2Button.h"

@implementation TableViewCellWithDefaultLabel2Button

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.frame = CGRectMake(0, 0, 0, 20);
    self.textLabel.font = [UIFont systemFontOfSize:14.0];
    self.applyBtn.layer.cornerRadius = 3.0f;
    self.configBtn.layer.cornerRadius = 3.0f;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cellValueChangedWithSection:row:tag:value:)]) {
        [self.delegate cellValueChangedWithSection:self.indexPath.section row:self.indexPath.row tag:sender.tag value:1];
    }
}

@end
