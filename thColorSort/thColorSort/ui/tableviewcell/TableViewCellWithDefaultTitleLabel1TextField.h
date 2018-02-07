//
//  TableViewCellWithDefaultTitleLabel1TextField.h
//  thColorSort
//
//  Created by taiheMacos on 2017/5/2.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUITextField.h"
#import "BaseTableViewCell.h"
typedef NS_ENUM(NSInteger,TableViewCellType) {
    TableViewCellType_Feeding = 0,
    TableViewCellType_ValveOpenTime = 1,
    TableViewCellType_SenseType = 2,
    TableViewCellType_ColorSense = 3,
    TableViewCellType_IRSpot = 4,
    TableViewCellType_IRDiff = 5,
    TableViewCellType_DevideIRDiff = 6,
    TableViewCellType_CashewShape = 7,
    TableViewCellType_RiceShapeSense1,//碎米灵敏度
    TableViewCellType_RiceShapeLimit,//灰尘限制
    TableViewCellType_RiceShapeSense2, //长米灵敏度
    TableViewCellType_RiceMirror//大米 反选(镜像)
};
@interface TableViewCellWithDefaultTitleLabel1TextField : BaseTableViewCell
@property (strong, nonatomic) IBOutlet BaseUITextField *textField;
@property (assign,nonatomic) TableViewCellType cellType;
@end
