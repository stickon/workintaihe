//
//  MiddleManager.m
//  ThColorSortNew
//
//  Created by honghua cai on 2017/11/12.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "MiddleManager.h"
#import "VersionViewPageManager.h"
#import "BaseUI.h"
#import <Masonry/Masonry.h>
@interface MiddleManager()
{
    
}

@end

@implementation MiddleManager

-(void)attachView:(UIView *)view{
    self.container=view;
}

+(MiddleManager *)shareInstance{
    static MiddleManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.viewHistoryArray = [NSMutableArray array];
        sharedInstance.viewParaHistoryArray = [NSMutableArray array];
        sharedInstance.viewNameToObjectDictionary = [NSMutableDictionary dictionary];
        sharedInstance.tabViewArray = [NSArray arrayWithObjects:@"HomeView",@"SenseView",@"SysinfoView",@"SettingView", nil];
        
    });
    return sharedInstance;
}


- (void)ChangeViewWithName:(NSString *)viewName Para:(NSDictionary*) para{
    
    BaseUI *baseUi=[self.viewNameToObjectDictionary objectForKey:viewName];
    if (baseUi == nil) {//创建跳转的view
        NSDictionary *classDic= [VersionViewPageManager shareInstance].curVersionViewPages.VersionViewNameToClassDictionary;
        Class viewClass = [classDic objectForKey:viewName];
        baseUi = [[viewClass alloc] init];
        [self.viewNameToObjectDictionary setObject:baseUi forKey:viewName];
    }
    
    UIView *currentView=[baseUi getViewWithPara:para];
    for(UIView *child in self.container.subviews){
        [child removeFromSuperview];
    }
    [self.container addSubview:currentView];
    [self autoLayout:currentView superView:_container];
    
    
    [self notifyObservers:viewName Title:[para valueForKey:@"title"]];
    
    if ([self.tabViewArray containsObject:self.viewHistoryArray.lastObject] && [self.tabViewArray containsObject:viewName]) {
        [self.viewHistoryArray removeLastObject];
        [self.viewParaHistoryArray removeLastObject];
    }
    if (![self.viewHistoryArray containsObject:viewName]) {
        [self.viewHistoryArray addObject:viewName];
        [self.viewParaHistoryArray addObject:para];
    }
}

- (void)Back { 
    NSString *curViewName = [self.viewHistoryArray lastObject];
    BaseUI *currentUi = [self.viewNameToObjectDictionary objectForKey:curViewName];
    if([currentUi Back]){
        [self.viewNameToObjectDictionary removeObjectForKey:curViewName];
        
        [self.viewHistoryArray removeLastObject];
        [self.viewParaHistoryArray removeLastObject];
        [self ChangeViewWithName:self.viewHistoryArray.lastObject Para:self.viewParaHistoryArray.lastObject];
    }
}

-(void)ChangeLayer{
    NSString *curViewName = [self.viewHistoryArray lastObject];
    BaseUI *currentUi = [self.viewNameToObjectDictionary objectForKey:curViewName];
    [currentUi showChangeLayerView];
}


- (void)updateCurrentViewWithHeader:(NSData *)headerData {
    BaseUI *baseUi = [self currentView];
    const char *a = headerData.bytes;
    if(a){
        if (a[0] == 0x03 && (a[1] == 0x03 || a[1] == 0x04)) {
            [baseUi updateDeviceStateWithType:a[1]];
        }
        if ((a[0]== 0x01 && a[1] == 0x01) || (a[0] == 0x51 && a[1] == 0x01)) {
            [[VersionViewPageManager shareInstance] setPages];
        }
        [baseUi updateWithHeader:headerData];
    }
    
}
-(BaseUI*)currentView{
    NSString *curViewName = [self.viewHistoryArray lastObject];
    BaseUI *baseUi = [self.viewNameToObjectDictionary objectForKey:curViewName];
    return baseUi;
}

- (void)netReconnect {
    dispatch_async(dispatch_get_main_queue(), ^{
        BaseUI *baseUi = [self currentView];
        [baseUi netReconnect];
    });;
}

- (void)netWorkError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        BaseUI *baseUi = [self currentView];
        [baseUi networkError:error];
    });
}

-(void)socketSendError
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BaseUI *baseUi = [self currentView];
        [baseUi socketSendError];
    });
}

- (void)backToLoginOrDeviceView{
    NSString *curViewName = [self.viewHistoryArray lastObject];
    if ([self.tabViewArray containsObject:curViewName]) {
        for (NSString* tabViewName in self.tabViewArray) {
            BaseUI *baseUi = [self.viewNameToObjectDictionary objectForKey:tabViewName];
            if (baseUi) {
                [self.viewNameToObjectDictionary removeObjectForKey:curViewName];
                [self.viewNameToObjectDictionary removeObjectForKey:tabViewName];
            }
        }
    }else{
        BaseUI *currentUi = [self.viewNameToObjectDictionary objectForKey:curViewName];
        if (currentUi) {
            [self.viewNameToObjectDictionary removeObjectForKey:curViewName];
        }
    }
    [self.viewHistoryArray removeLastObject];
    [self.viewParaHistoryArray removeLastObject];
}
- (void)LogOut { 
    kDataModel.loginState = LoginOut;
    while ([self.viewHistoryArray lastObject]) {
        NSString *LastViewName = [self.viewHistoryArray lastObject];
        if (gNetwork->networkType == 1) {
            if (![LastViewName isEqualToString:@"DeviceListUI"]) {
                [self backToLoginOrDeviceView];
            }else{
                [self ChangeViewWithName:@"DeviceListUI" Para:[self.viewParaHistoryArray lastObject]];
                [gNetwork disconnnectCurrentDevice];
                break;
            }
            
        }else{
            if (![LastViewName isEqualToString:@"LoginUI"]) {
                [self backToLoginOrDeviceView];
            }else{
                [kDataModel.deviceList removeAllObjects];
                [gNetwork disconnect];
                [self ChangeViewWithName:@"LoginUI" Para:[self.viewParaHistoryArray lastObject]];
                break;
            }
        }
    }
    kDataModel.loginState = LoginOut;
    kDataModel.currentDeviceIndex = 0;
}

@end
