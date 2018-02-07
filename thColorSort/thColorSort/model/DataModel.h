//
//  DataModel.h
//  thColorSort
//
//  Created by taiheMacos on 2017/3/17.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"
#import "FileOperation.h"
typedef NS_ENUM(NSUInteger,LoginState) {
    Login = 0,//登录页面
    LoginOut = 1,//设备列表页面
    LoginIn = 2,//设备连接后的页面
};
@interface DataModel :NSObject
@property (nonatomic,strong) NSMutableArray *deviceList;
@property (nonatomic,assign) NSInteger currentDeviceIndex;
@property (nonatomic,strong) Device *currentDevice;
@property (nonatomic,strong) NSString *loginNamePassword;
@property (nonatomic,assign) NSInteger authorizationCode;//授权码
@property (nonatomic,strong) NSString *tcpmachineID;//机器编号
@property (nonatomic,assign) LoginState loginState;
@property (nonatomic,strong) NSMutableArray *tempLanguageArray;
@property (nonatomic,copy) NSDictionary *appVersionDictionary;
@property (nonatomic,strong) NSString *tempVersion;


@property (nonatomic,assign) Byte protocolMainVersion;//对应版本屏的协议 主版本号
+(instancetype)globalDataModel;


-(NSString*)getDeviceNameByIndex:(NSInteger)index;
-(NSString*)getDeviceIDByIndex:(NSInteger)index;

-(Device*)currentDevice;

-(void)setData:(NSData*)data withType:(Byte)type andIPaddress:(NSString*)ip;

-(NSInteger)getDeviceCount;
-(void)saveDownloadData:(NSData*)data withFileName:(NSString*)fileName withType:(Byte)type isEnd:(Byte)fileEnd;//下载配置文件和语言包
@end
