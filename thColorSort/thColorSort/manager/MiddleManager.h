//
//  MiddleManager.h
//  ThColorSortNew
//
//  Created by honghua cai on 2017/11/12.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Subject.h"
@class BaseUI;

@interface MiddleManager : Subject

@property(nonatomic,strong) UIView *container;
@property(nonatomic,strong) NSMutableArray *viewHistoryArray;//存放view切换的历史记录
@property(nonatomic,strong) NSMutableArray *viewParaHistoryArray;
@property(nonatomic,strong) NSMutableDictionary *viewNameToObjectDictionary;//存放已经分配内存的view 对应的object，避免重复分配
@property(nonatomic,copy) NSArray *tabViewArray;
+(MiddleManager *)shareInstance;

-(void)attachView:(UIView *)view;

-(void)ChangeViewWithName:(NSString*)viewName Para:(NSDictionary*) para;
-(void)updateCurrentViewWithHeader:(NSData*)headerData;
-(void)Back;
-(void)ChangeLayer;
-(void)netWorkError:(NSError*)error;
-(void)netReconnect;
-(void)socketSendError;
-(void)LogOut;
-(BaseUI *)currentView;
@end
