//
//  TableViewCellWith7Label.h
//  thColorSort
//
//  Created by taihe on 2017/5/12.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCellWith7Label : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *frontTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *rearTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *chuteTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *frontSoftwareTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *frontHardwareTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *rearSoftwareTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *rearHardwareTitleLabel;

@end
