//
//  FeedSettingTableViewCell.h
//  thColorSort
//
//  Created by taihe on 2017/6/26.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface FeedSettingTableViewCell : BaseTableViewCell<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *feedCellTitle;
@property (strong, nonatomic) IBOutlet BaseUITextField *feedNumTextField;
@property (strong, nonatomic) IBOutlet UISwitch *feedSwitch;

@end
