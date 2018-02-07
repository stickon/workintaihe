//
//  BaseTableViewCell.m
//  thColorSort
//
//  Created by taihe on 2017/5/13.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellEditValueChangedWithTag:(long)tag AndValue:(NSInteger)value{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellValueChangedWithSection:row:tag:value:)]) {
        [self.delegate cellValueChangedWithSection:self.indexPath.section row:self.indexPath.row tag:tag value:value];
    }
}

-(void)cellEditValueChangedWithTag:(long)tag AndValue:(NSInteger)value bSend:(BOOL)bsend{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellBtnClicked:row:tag:value:bSend:)]) {
        [self.delegate cellBtnClicked:self.indexPath.section row:self.indexPath.row tag:tag value:value bSend:bsend];
    }
}
@end
