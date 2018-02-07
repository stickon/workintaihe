//
//  RiceSharpenTableViewCell.h
//  thColorSort
//
//  Created by taihe on 2017/12/11.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface RiceSharpenTableViewCell : BaseTableViewCell<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *SharpenParaTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *SharpenParaTextField;
@property (strong, nonatomic) IBOutlet UILabel *SharpenUseTitleLabel;
@property (strong, nonatomic) IBOutlet UISwitch *SharpenUseSwitch;

@end
