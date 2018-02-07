//
//  BaseTableViewCell.h
//  thColorSort
//
//  Created by taihe on 2017/5/13.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tableViewCellValueChangedDelegate.h"
@interface BaseTableViewCell : UITableViewCell
@property (strong,nonatomic)  NSIndexPath *indexPath;
@property (weak,nonatomic) id<TableViewCellChangedDelegate> delegate;
-(void)cellEditValueChangedWithTag:(long)tag AndValue:(NSInteger)value;
-(void)cellEditValueChangedWithTag:(long)tag AndValue:(NSInteger)value bSend:(BOOL)bsend;
@end
