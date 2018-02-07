//
//  valveTableViewCell.h
//  thColorSort
//
//  Created by taiheMacos on 2017/4/11.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface valveTableViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *chuteNumLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *delayTimeTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *blowTimeTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ejectTypeSegmentedControl;
@property (strong, nonatomic) IBOutlet UISwitch *centerPointSwitch;
@end
