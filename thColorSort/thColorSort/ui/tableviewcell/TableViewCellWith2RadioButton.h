//
//  TableViewCellWith2RadioButton.h
//  thColorSort
//
//  Created by taihe on 2017/5/10.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@interface TableViewCellWith2RadioButton : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UIButton *colorRadioBtn;
@property (strong, nonatomic) IBOutlet UIButton *lightRadioBtn;
@property (strong, nonatomic) IBOutlet UILabel *colorTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lightTitleLabel;
@end
