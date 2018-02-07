//
//  IRMainLightTableViewCell.h
//  thColorSort
//
//  Created by taihe on 2017/6/16.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@interface IRMainLightTableViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *mainIRLightLabel;
//红外主灯 分时led灯

@property (strong, nonatomic) IBOutlet UILabel *frontIRLightTitleLabel;//红外前  分时led前
@property (strong, nonatomic) IBOutlet UISwitch *frontIRSwitch;

@property (strong, nonatomic) IBOutlet UILabel *rearIRLightTitleLabel; //红外后 分时led后
@property (strong, nonatomic) IBOutlet UISwitch *rearIRSwitch;
@end
