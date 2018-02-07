//
//  TableViewCellWithDefaultLabel2Button.h
//  thColorSort
//
//  Created by taihe on 2017/5/6.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@interface TableViewCellWithDefaultLabel2Button : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *detailTitle;
@property (strong, nonatomic) IBOutlet UIButton *applyBtn;
@property (strong, nonatomic) IBOutlet UIButton *configBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *configBtnConstraintWidth;
@end
