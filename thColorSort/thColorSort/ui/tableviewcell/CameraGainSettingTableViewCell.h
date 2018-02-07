//
//  CameraGainSettingTableViewCell.h
//  thColorSort
//
//  Created by taihe on 2017/6/16.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@interface CameraGainSettingTableViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UISegmentedControl *cameraGainSegmentControl;
@property (strong, nonatomic) IBOutlet UILabel *switchLabel;//整体调整title
//整体调整
@property (strong, nonatomic) IBOutlet UIButton *checkBtn;

@end
