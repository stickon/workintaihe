//
//  SetSenseSizeLightAreaTableViewCell.h
//  thColorSort
//
//  Created by taihe on 2017/6/9.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface SetSenseSizeLightAreaTableViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *setSizeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lightThresholdTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *lightThresholdTextField;
@property (strong, nonatomic) IBOutlet UILabel *minSizeTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *minSizeTextField;
@property (strong, nonatomic) IBOutlet UILabel *areaChooseTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *areaChooseTextField;
@property (strong, nonatomic) IBOutlet UIButton *limitBtn;
@property (strong, nonatomic) IBOutlet UIButton *borderUseBtn;

@end
