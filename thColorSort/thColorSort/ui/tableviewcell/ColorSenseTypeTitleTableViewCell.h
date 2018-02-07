//
//  ColorSenseTypeTitleTableViewCell.h
//  thColorSort
//
//  Created by taiheMacos on 2017/3/24.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@interface ColorSenseTypeTitleTableViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *chuteTitle;
@property (strong, nonatomic) IBOutlet UILabel *senseValueTitle;
@property (strong, nonatomic) IBOutlet UILabel *senseLightUpperLimitValue;
@property (strong, nonatomic) IBOutlet UILabel *senseLightLowerLimitValue;
@end
