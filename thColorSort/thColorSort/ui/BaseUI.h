//
//  BaseUI.h
//  ThColorSortNew
//
//  Created by honghua cai on 2017/11/12.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NetworkFactory.h"
#import "InternationalControl.h"
#import "MiddleManager.h"
#import "ResponderAuto.h"
#import "UIView+Toast.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "types.h"
#import "Device.h"
#import "DataModel.h"
#import "MJRefresh.h"
#import "BaseUITextField.h"
#import "LayerChangedView.h"
@interface BaseUI: ResponderAuto<MMNumberKeyboardDelegate,LayerChangedDelegate,MyTextFieldDelegate>{
    MBProgressHUD *hud;
    NSInteger netWorkTimeOutCount;
     UIButton *viewBtn[2];
}
- (void)frontRearViewBtnAddTargetEvent;//绑定事件
- (void)frontRearViewChanged;
@property (nonatomic,weak) UILabel *baseLayerLabel;
@property (strong,nonatomic) NSArray* shapeArray;
@property (strong,nonatomic) NSString *title;
@property (copy,nonatomic) NSMutableDictionary *paraNextView;
@property (nonatomic,strong) MJRefreshNormalHeader *refreshHeader;//下拉刷新的头

-(UIView *)getViewWithPara:(NSDictionary*)para;
-(void)updateWithHeader:(NSData*)headerData;

-(void)updateDeviceStateWithType:(Byte)type;//清灰和启动系统处理
-(void)changeCurrentLayer:(NSUInteger)layer Sorter:(NSUInteger)sorter View:(NSUInteger)view;

-(void)showChangeLayerView;

- (void)networkError:(NSError*)error;
- (void)netReconnect;//udp网络重连
- (void)socketSendError;
- (void)initView;
- (void)initLanguage;
- (BOOL)Back;
//- (void)addChangeLayerNavigationItem;
- (void)initCurrentLayerLabel;//设置当前层label
-(void)logOut;

#pragma ui 相关
-(void)refreshTableView;//下拉刷新
@end
