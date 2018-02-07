//
//  BaseVersionViewPagesManager.m
//  ThColorSortNew
//
//  Created by taihe on 2017/12/28.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "BaseVersionViewPagesManager.h"

@implementation BaseVersionViewPagesManager

+ (BaseVersionViewPagesManager *)shareInstance { 
    static BaseVersionViewPagesManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.VersionViewNameToClassDictionary = [NSMutableDictionary dictionary];
        
    });
    return instance;
}

@end
