//
//  RiceUserAlgorithmTableViewCell.h
//  thColorSort
//
//  Created by taihe on 2018/2/7.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface RiceUserAlgorithmTableViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *riceUserAlgorithmNameLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *group1TextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *group2TextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *group3TextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *group4TextField;
@property (strong, nonatomic) IBOutlet UISwitch *riceUserAlgorithmUseSwitch;
@property (strong, nonatomic) NSMutableArray<BaseUITextField*> *groupTextFieldArray;
@end
