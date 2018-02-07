//
//  TableViewCellWith2RadioButton.m
//  thColorSort
//
//  Created by taihe on 2017/5/10.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "TableViewCellWith2RadioButton.h"

@implementation TableViewCellWith2RadioButton

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnClicked:(UIButton *)sender {
    if (sender.tag == 100) {
        sender.selected = !sender.isSelected;
        self.lightRadioBtn.selected = !self.lightRadioBtn.isSelected;
        
        if (sender.selected) {
            sender.userInteractionEnabled = false;
            self.lightRadioBtn.userInteractionEnabled = true;
            if ([self.delegate respondsToSelector:@selector(cellValueChangedWithSection:row:tag:value:)]) {
                [self.delegate cellValueChangedWithSection:self.indexPath.section row:self.indexPath.row tag:sender.tag value:1];
            }
        }
    }else{
        sender.selected = !sender.isSelected;
        self.colorRadioBtn.selected = !self.colorRadioBtn.isSelected;
        if (sender.selected) {
            sender.userInteractionEnabled = false;
            self.colorRadioBtn.userInteractionEnabled = true;
            if ([self.delegate respondsToSelector:@selector(cellValueChangedWithSection:row:tag:value:)]) {
                [self.delegate cellValueChangedWithSection:self.indexPath.section row:self.indexPath.row tag:sender.tag value:2];
            }
        }
    }
}

@end
