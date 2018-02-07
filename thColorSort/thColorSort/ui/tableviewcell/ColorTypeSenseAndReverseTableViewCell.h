//
//  ColorTypeSenseAndReverseTableViewCell.h
//  thColorSort
//
//  Created by taihe on 2017/12/8.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface ColorTypeSenseAndReverseTableViewCell : BaseTableViewCell<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *chuteNum;
@property (strong, nonatomic) IBOutlet BaseUITextField*chuteSenseTimes1Value;
@property (strong, nonatomic) IBOutlet BaseUITextField*chuteSenseTimes2Value;
@property (strong, nonatomic) IBOutlet UISwitch *reverseSwitch;

@end
