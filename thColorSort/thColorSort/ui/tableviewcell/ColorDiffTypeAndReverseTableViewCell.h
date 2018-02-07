//
//  ColorDiffTypeAndReverseTableViewCell.h
//  thColorSort
//
//  Created by taihe on 2017/12/15.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface ColorDiffTypeAndReverseTableViewCell : BaseTableViewCell<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *colorSenseChuteNumLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *colorSenseValueTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *colorSenseLightUpperLimitValueTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *colorSenseLightLowerLimitValueTextField;
@property (strong, nonatomic) IBOutlet UISwitch *reverseUseSwitch;

@end
