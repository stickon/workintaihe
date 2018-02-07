//
//  valveOpenTimeTableViewCell.h
//  thColorSort
//
//  Created by taiheMacos on 2017/4/11.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface valveOpenTimeTableViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *valveOpenTimeLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *valveOpenTimeTextField;
@end
