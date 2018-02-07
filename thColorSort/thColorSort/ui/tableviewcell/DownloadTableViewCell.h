//
//  DownloadTableViewCell.h
//  thColorSort
//
//  Created by taihe on 2017/6/13.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
typedef NS_ENUM(NSInteger, DownloadCellState){
    DownloadCellStateNoFile = 0,//没有这个语言包
    DownloadCellStateNoUpdate = 1,//是最新的包
    DownloadCellStateUpdate = 2,//需要更新
    DownloadCellStateUpdateing = 3,//更新中
};
@interface DownloadTableViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UIButton *stateBtn;
- (void)updateViewWithDownloadState:(DownloadCellState)state;
@end
