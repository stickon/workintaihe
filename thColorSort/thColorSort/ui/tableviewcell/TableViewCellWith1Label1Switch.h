//
//  TableViewCellWith1Label1Switch.h
//  thColorSort
//
//  Created by taiheMacos on 2017/4/14.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
typedef NS_ENUM(NSUInteger,CellLabelAlignment) {
    CellLabelLeftAlignment = 0,
    CellLabelCenterAlignMent = 1,
};
@interface TableViewCellWith1Label1Switch : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (strong, nonatomic) IBOutlet UISwitch *switchBtn;
@property (assign,nonatomic) CellLabelAlignment alignment;
-(void)setSwitchBtnState:(Byte)state;
@end
