//
//  MainLightTableViewCell.h
//  thColorSort
//
//  Created by taihe on 2017/6/16.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface MainLightTableViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *mainLightLabel;//主灯标题

@property (strong, nonatomic) IBOutlet UILabel *frontMainLightTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *frontMainLightTextField;//前主灯
@property (strong, nonatomic) IBOutlet UILabel *rearMainLightTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *rearMainLightTextField;//后主灯
@end
