//
//  VersionViewPageManager.h
//  ThColorSortNew
//
//  Created by taihe on 2017/12/28.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseVersionViewPages.h"
@interface VersionViewPageManager : NSObject
@property(nonatomic,strong) BaseVersionViewPages *curVersionViewPages;

+(VersionViewPageManager *)shareInstance;
-(BaseVersionViewPages*)curVersionViewPages;
-(void) setPages;
@end
