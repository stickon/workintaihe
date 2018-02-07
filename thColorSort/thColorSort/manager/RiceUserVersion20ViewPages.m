//
//  RiceUserVersion20ViewPages.m
//  thColorSort
//
//  Created by taihe on 2018/2/7.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "RiceUserVersion20ViewPages.h"
#import "Rice20SenseView.h"
@implementation RiceUserVersion20ViewPages

-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
-(void)createPage{
    [super createPage];
#ifdef Engineer
#else
    [self.VersionViewNameToClassDictionary setObject:[Rice20SenseView class] forKey:@"SenseView"];
#endif
}
@end
