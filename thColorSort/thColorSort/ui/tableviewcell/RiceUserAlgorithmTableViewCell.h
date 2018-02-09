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
{
    @public
    Byte *svmRange;
}
@property (strong, nonatomic) IBOutlet UILabel *riceUserAlgorithmNameLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *group1TextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *group2TextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *group3TextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *group4TextField;
@property (strong, nonatomic) IBOutlet UISwitch *riceUserAlgorithmUseSwitch;
@property (strong, nonatomic) NSMutableArray<BaseUITextField*> *groupTextFieldArray;
@property (assign, nonatomic) Byte type;//算法类型，设置不同灵敏度范围
@end
