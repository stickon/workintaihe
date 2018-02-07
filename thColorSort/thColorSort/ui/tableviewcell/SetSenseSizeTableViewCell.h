//
//  SetSenseSizeTableViewCell.h
//  thColorSort
//
//  Created by taiheMacos on 2017/3/24.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface SetSenseSizeTableViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *LengthLabel;
@property (strong, nonatomic) IBOutlet UILabel *widthLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *irDiffSpotLabel;//标识当前是比例还是点数
@property (strong, nonatomic) IBOutlet UILabel *irDiffTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *lengthTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *widthTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *sizeTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *irDiffTextField;
@property (strong, nonatomic) IBOutlet UILabel *frontRearViewSameLabel;
@property (strong, nonatomic) IBOutlet UISwitch *frontRearViewSameSwitch;
@property (assign, nonatomic) Byte isIRDiff;//是否为红外比值类型 0非红外 1比例 2点数
@end
