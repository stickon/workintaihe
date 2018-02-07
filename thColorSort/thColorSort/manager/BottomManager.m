//
//  BottomManager.m
//  ThColorSortNew
//
//  Created by honghua cai on 2017/11/12.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "BottomManager.h"
#import <Masonry/Masonry.h>
#import "TabBarItem.h"
#import "MiddleManager.h"
#import "types.h"
@interface BottomManager()
{
    
}

@property (strong, nonatomic) IBOutlet TabBarItem *tabBarItem1;
@property (strong, nonatomic) IBOutlet TabBarItem *tabBarItem2;
@property (strong, nonatomic) IBOutlet TabBarItem *tabBarItem3;
@property (strong, nonatomic) IBOutlet TabBarItem *tabBarItem4;
@property (assign, nonatomic) NSInteger selectIndex;
@property (nonatomic, strong) TabBarItem *currentTabItem;//当前选中的
@property (strong, nonatomic) NSArray *tabBarItemArray;
@end
@implementation BottomManager



-(void)attachView:(UIView *)view{
    self.container=view;
    [self.container addSubview:self];
    [self autoLayout:self superView:_container];
}

+(BottomManager *)shareInstance{
    static BottomManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle]loadNibNamed:@"BottomView" owner:self options:nil] firstObject];
        self.tabBarItemArray = [NSArray arrayWithObjects:self.tabBarItem1,self.tabBarItem2,self.tabBarItem3,self.tabBarItem4, nil];
        NSArray *selectedArr = @[@"tab_home1",@"tab_sensitive1",@"tab_sysinfo1",@"tab_settings1"];
        NSArray *unSeleceArr = @[@"tab_home0",@"tab_sensitive0",@"tab_sysinfo0",@"tab_settings0"];
    
        NSArray *titleArr = @[kLanguageForKey(13),kLanguageForKey(14),kLanguageForKey(16),kLanguageForKey(17)] ;
        for (TabBarItem*obj in self.tabBarItemArray) {
            NSInteger index = [self.tabBarItemArray indexOfObject:obj];
            [obj setItemWithUnSelectedImg:[UIImage imageNamed:unSeleceArr[index]] withSelectedImg:[UIImage imageNamed:selectedArr[index]] withTitle:titleArr[index]];
            obj.tag=index+1000;
            [obj setClickEventTarget:self action:@selector(tabBtnClick:)];
        }
        self.selectIndex = 1000;
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}


-(void)tabBtnClick:(TabBarItem *)btn
{
    self.currentTabItem = [self viewWithTag:self.selectIndex];
    if (self.currentTabItem != btn) {
        [self.currentTabItem setSelected:NO];
        self.selectIndex = btn.tag;
        if (btn.tag == 1000) {
            NSDictionary *para = @{@"title":kLanguageForKey(13)};
            [[MiddleManager shareInstance] ChangeViewWithName:@"HomeView" Para:para];
        }else if (btn.tag == 1001){
           NSDictionary *para = @{@"title":kLanguageForKey(14)};
            [[MiddleManager shareInstance] ChangeViewWithName:@"SenseView" Para:para];
        }else if (btn.tag == 1002){
            NSDictionary *para = @{@"title":kLanguageForKey(16)};
            [[MiddleManager shareInstance] ChangeViewWithName:@"SysinfoView" Para:para];
        }else if (btn.tag == 1003){
            NSDictionary *para = @{@"title":kLanguageForKey(17)};
            [[MiddleManager shareInstance] ChangeViewWithName:@"SettingView" Para:para];
        }
    }
    
}
-(void)updateWithViewid:(NSString*)viewId TopTitle:(NSString *)title{
    if ([[MiddleManager shareInstance].tabViewArray containsObject:viewId]) {
        [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@60);
        }];
        
        [self.container layoutIfNeeded];
        [self setHidden:NO];
        NSArray *titleArr = @[kLanguageForKey(13),kLanguageForKey(14),kLanguageForKey(16),kLanguageForKey(17)] ;
        for (TabBarItem *obj in self.tabBarItemArray) {
            [obj setSelected:NO];
            [obj.tabBarItemTitle setText:titleArr[[self.tabBarItemArray indexOfObject:obj]]];
        }
        if ([viewId isEqualToString:@"HomeView"]) {
            [self.tabBarItem1 setSelected:YES];
        }else if ([viewId isEqualToString:@"SenseView"]){
            [self.tabBarItem2 setSelected:YES];
        }else if ([viewId isEqualToString:@"SysinfoView"]){
            [self.tabBarItem3 setSelected:YES];
        }else if ([viewId isEqualToString:@"SettingView"]){
            [self.tabBarItem4 setSelected:YES];
        }
    }else{
        if ([viewId isEqualToString:@"DeviceListUI"] || [viewId isEqualToString:@"LoginUI"]) {
            self.selectIndex = -1;
        }
        [self setHidden:YES];
        [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
}
-(void)update:(NSObject *)arg message:(NSString *)msg{
    if ([[MiddleManager shareInstance].tabViewArray containsObject:msg]) {
        
    }else{
        if ([msg isEqualToString:@"DeviceListUI"] || [msg isEqualToString:@"LoginUI"]) {
            self.selectIndex = -1;
        }
        [self setHidden:YES];
        [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
}
@end
