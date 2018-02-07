//
//  TableViewCellWithDefaultTitleLabelAndUICombobox.m
//  thColorSort
//
//  Created by taiheMacos on 2017/5/3.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "TableViewCellWithDefaultTitleLabelAndUICombobox.h"

@implementation TableViewCellWithDefaultTitleLabelAndUICombobox

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.frame = CGRectMake(0, 0, 80, 40);
    self.valveWorkModeComboBox = [[UIComboBox alloc]init];
    self.valveWorkModeComboBox.frame = CGRectMake(180, 4, 120, 36);
    
    self.valveWorkModeComboBox.selectedItem = 0;
    __block TableViewCellWithDefaultTitleLabelAndUICombobox *blockSelf = self;
    [self.valveWorkModeComboBox setOnItemSelected:^(NSString *selectedObject,NSInteger selectedIndex){
        if ([blockSelf.delegate respondsToSelector:@selector(cellValueChangedWithSection:row:tag:value:)]) {
            [blockSelf.delegate cellValueChangedWithSection:blockSelf.indexPath.section row:blockSelf.indexPath.row tag:(int)blockSelf.valveWorkModeComboBox.tag value:selectedIndex];
        }
    }];
    [self.contentView addSubview:self.valveWorkModeComboBox];
    // Initialization code
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(20, 0, 160, 40);
    [self.valveWorkModeComboBox setFrame:CGRectMake(self.frame.size.width-140, 4, 130, 36)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
