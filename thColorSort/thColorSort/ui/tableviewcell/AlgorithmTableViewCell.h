//
//  AlgorithmTableViewCell.h
//  thColorSort
//
//  Created by taiheMacos on 2017/3/22.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface AlgorithmTableViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *algorithmName;
@property (strong, nonatomic) IBOutlet BaseUITextField *algorithmValue;
@property (strong, nonatomic) IBOutlet UIButton *algorithmAdvanced;
@end
