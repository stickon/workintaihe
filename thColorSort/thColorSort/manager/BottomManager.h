//
//  BottomManager.h
//  ThColorSortNew
//
//  Created by honghua cai on 2017/11/12.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Subject.h"
#import "ResponderAuto.h"
@interface BottomManager : ResponderAuto<ObserverDelegate>
@property(nonatomic,strong) UIView *container;

+(BottomManager *)shareInstance;

-(void)attachView:(UIView *)view;
@end
