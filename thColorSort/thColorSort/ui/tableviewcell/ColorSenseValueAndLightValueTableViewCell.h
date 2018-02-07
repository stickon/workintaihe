//
//  ColorSenseValueAndLightValueTableViewCell.h
//  thColorSort
//
//  Created by taiheMacos on 2017/3/24.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface ColorSenseValueAndLightValueTableViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *colorSenseChuteNumLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *colorSenseValueTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *colorSenseLightUpperLimitValueTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *colorSenseLightLowerLimitValueTextField;
@property (assign,nonatomic) Byte section;
@property (assign,nonatomic) Byte row;
@end
