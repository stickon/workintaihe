//
//  BackgroundLightTableViewCell.h
//  thColorSort
//
//  Created by taihe on 2017/6/16.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface BackgroundLightTableViewCell : BaseTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *backgroundLightTitleLabel;//背景灯
//front
@property (strong, nonatomic) IBOutlet UILabel *frontTitleLabel;

@property (strong, nonatomic) IBOutlet BaseUITextField *redTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *greenTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *blueTextField;

//rear
@property (strong, nonatomic) IBOutlet UILabel *rearTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *rearRedTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *rearGreenTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *rearBlueTextField;

@end
