//
//  BaseVersionViewPages.h
//  ThColorSortNew
//
//  Created by taihe on 2017/12/28.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "types.h"
@interface BaseVersionViewPages : NSObject
@property(nonatomic,strong) NSMutableDictionary *VersionViewNameToClassDictionary;
-(void)createPage;
-(instancetype)init;
@end
