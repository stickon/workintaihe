//
//  TableViewCellWithDefaultTitleLabelAndUICombobox.h
//  thColorSort
//
//  Created by taiheMacos on 2017/5/3.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIComboBox.h"
#import "BaseTableViewCell.h"
@interface TableViewCellWithDefaultTitleLabelAndUICombobox : BaseTableViewCell
@property (nonatomic,strong) UIComboBox<NSString*> *valveWorkModeComboBox;
@end
