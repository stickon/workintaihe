//
//  BaseUI.m
//  ThColorSortNew
//
//  Created by honghua cai on 2017/11/12.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "BaseUI.h"
@interface BaseUI()
@property (nonatomic,strong) LayerChangedView *layerChangeView;
@property (nonatomic,strong) NSTimer *cleanTimeOutTimer;
@property (nonatomic,assign) BOOL layerChangeViewShowIn;
@end
@implementation BaseUI

-(NSMutableDictionary *)paraNextView{
    if (!_paraNextView) {
        _paraNextView = [NSMutableDictionary dictionary];
    }
    return _paraNextView;
}
-(UIView *)getViewWithPara:(NSDictionary*)para{
    return self;
}

-(id)refreshHeader{
    if (!_refreshHeader) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
        header.automaticallyChangeAlpha = YES;
        
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        // 隐藏状态
        header.stateLabel.hidden = YES;
        _refreshHeader = header;
    }
    return _refreshHeader;
}

-(void)refreshTableView{
    //do nothing
}

- (void)updateWithHeader:(NSData *)NetworkHeader {
    unsigned const char *a = NetworkHeader.bytes;
    if (a[0] == 0x55) {
        Device *device = kDataModel.currentDevice;
        dispatch_async(dispatch_get_main_queue(), ^{
            Network *network = gNetwork;
            if (network->networkType) {
                [self.window makeToast:[NSString stringWithFormat:@"%@ %@",kLanguageForKey(213),kLanguageForKey(214)] duration:2.0 position:CSToastPositionBottom];
            }else{
                [self.window makeToast:[NSString stringWithFormat:@"%@ %@",device.offlineDeviceID,kLanguageForKey(215)] duration:2.0 position:CSToastPositionBottom];
            }
            [self logOut];
        });
    }
}

-(void)cleanTimeOut{
    [hud hideAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

-(BOOL)Back{
    return YES;
}

- (void)netReconnect {
    [self.window makeToast:kLanguageForKey(319) duration:2.0 position:CSToastPositionCenter];
}

- (void)networkError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.window makeToast:kLanguageForKey(215) duration:2.0 position:CSToastPositionCenter];
        [self performSelector:@selector(logOut) withObject:nil afterDelay:2.0];
    });
}
- (void)socketSendError {
    if (netWorkTimeOutCount>3) {
        [self.window makeToast:kLanguageForKey(215) duration:2.0 position:CSToastPositionCenter];
        [self performSelector:@selector(logOut) withObject:nil afterDelay:2.0];
        
        netWorkTimeOutCount = 0;
    }else{
        [self.window makeToast:kLanguageForKey(215) duration:2.0 position:CSToastPositionCenter];
        netWorkTimeOutCount++;
    };
}
- (void)logOut {
    [gMiddeUiManager LogOut];
}

- (void)updateDeviceStateWithType:(Byte)type { 
    Device *device = kDataModel.currentDevice;
    if (type == 3) {
        if (device->machineData.startState == 2) {
            hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
            // Set the label text.
            hud.label.text = NSLocalizedString(kLanguageForKey(27) , @"HUD loading title");
            hud.label.font = [UIFont italicSystemFontOfSize:16.f];
            self.cleanTimeOutTimer = [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(cleanTimeOut) userInfo:nil repeats:NO];
        }else {
            if(self.cleanTimeOutTimer.valid)
            {
                [self.cleanTimeOutTimer invalidate];
            }
            [hud hideAnimated:YES];
            if (device->machineData.startState == 3){
                switch (device.errorState) {
                    case 1:
                        [self.window makeToast:kLanguageForKey(207)  duration:2.0 position:CSToastPositionCenter];
                        break;
                    case 2:
                        [self.window makeToast:kLanguageForKey(208)  duration:2.0 position:CSToastPositionCenter];
                        break;
                    case 3:
                        
                        [self.window makeToast:kLanguageForKey(209)  duration:2.0 position:CSToastPositionCenter];
                        break;
                    default:
                        break;
                }
            }
        }
    }else if (type == 4){
        if (device->machineData.cleanState == 1) {
            if (device->machineData.startState !=2) {

                hud= [MBProgressHUD showHUDAddedTo:self.window animated:YES];
                
                // Set the label text.
                hud.label.text = NSLocalizedString(kLanguageForKey(24) , @"HUD loading title");
                hud.label.font = [UIFont italicSystemFontOfSize:16.f];
                self.cleanTimeOutTimer = [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(cleanTimeOut) userInfo:nil repeats:NO];
            }
        }else if(device->machineData.cleanState == 0){
            if (device->machineData.startState != 2) {
                [hud hideAnimated:YES];
                if(self.cleanTimeOutTimer.valid)
                {
                    [self.cleanTimeOutTimer invalidate];
                }
            }
        }
    }
}

- (void)initView{
    [self initCurrentLayerLabel];
}
- (void)initLanguage
{
    _shapeArray = @[@"",kLanguageForKey(155),kLanguageForKey(156),kLanguageForKey(157),kLanguageForKey(158),kLanguageForKey(159),kLanguageForKey(160),kLanguageForKey(161),kLanguageForKey(162),kLanguageForKey(163),kLanguageForKey(164),kLanguageForKey(165),kLanguageForKey(166),kLanguageForKey(167),kLanguageForKey(168),kLanguageForKey(169),kLanguageForKey(170),kLanguageForKey(171),kLanguageForKey(172),kLanguageForKey(173),[NSString stringWithFormat:@"%@%@",kLanguageForKey(167),kLanguageForKey(284)]];
}

- (void)initCurrentLayerLabel{
    self.layerChangeViewShowIn = false;
    Device *device = kDataModel.currentDevice;
    NSInteger layerNumber = device->machineData.layerNumber;
    int currentLayerNumber = device.currentLayerIndex;
    if (layerNumber>1) {
        self.baseLayerLabel.hidden = NO;
        NSString *layerTitle = nil;
        if (layerNumber == 2) {
            if (currentLayerNumber == 1) {
                layerTitle =[NSString stringWithFormat:@">>%@", kLanguageForKey(140)];
            }else{
                layerTitle =[NSString stringWithFormat:@">>%@", kLanguageForKey(139)];
            }
        }else if (layerNumber == 3){
            if (currentLayerNumber == 1) {
                layerTitle =[NSString stringWithFormat:@">>%@", kLanguageForKey(140)];
            }else if (currentLayerNumber == 2){
                layerTitle =[NSString stringWithFormat:@">>%@", kLanguageForKey(141)];
            }else if (currentLayerNumber == 3){
                layerTitle =[NSString stringWithFormat:@">>%@", kLanguageForKey(139)];
            }
        }else{
            layerTitle = [NSString stringWithFormat:@">>%d %@",currentLayerNumber,kLanguageForKey(142)];
        }
        self.baseLayerLabel.text = layerTitle;
    }else{
        self.baseLayerLabel.hidden = YES;
    }
}


-(void)showChangeLayerView{
    Device *device = kDataModel.currentDevice;
    self.layerChangeViewShowIn = true;
    [self.layerChangeView showInView:self.window withFrame:CGRectMake(self.bounds.size.width/2-160, self.bounds.size.height / 2-100, 320, 200) AndLayerNum:device->machineData.layerNumber CurrentLayerIndex:device.currentLayerIndex];
}
-(void)changeCurrentLayer:(NSUInteger)layer Sorter:(NSUInteger)sorter View:(NSUInteger)view{
   
}
#pragma mark - layerChangedDelegate


-(LayerChangedView*)layerChangeView{
    if (!_layerChangeView) {
        Device *device = kDataModel.currentDevice;
        NSArray *array = [NSArray array];
        if (device) {
            if (device->machineData.layerNumber <=3) {
                array = @[kLanguageForKey(140),kLanguageForKey(139),kLanguageForKey(139),kLanguageForKey(140),kLanguageForKey(141),kLanguageForKey(139),kLanguageForKey(131),kLanguageForKey(130)];
            }else if (device->machineData.layerNumber >3){
                NSArray *layerTitle = kLanguageForKey(142);
                NSString *layer1 = [NSString stringWithFormat:@"1 %@",layerTitle];
                NSString *layer2 = [NSString stringWithFormat:@"2 %@",layerTitle];
                NSString *layer3 = [NSString stringWithFormat:@"3 %@",layerTitle];
                NSString *layer4 = [NSString stringWithFormat:@"4 %@",layerTitle];
                NSString *layer5 = [NSString stringWithFormat:@"5 %@",layerTitle];
                NSString *layer6 = [NSString stringWithFormat:@"6 %@",layerTitle];
                
                array = @[layer1,layer2,layer3,layer4,layer5,layer6,kLanguageForKey(131),kLanguageForKey(130)];
            }
            _layerChangeView = [[LayerChangedView alloc]initWithFrame:CGRectMake(self.window.bounds.size.width/2-160, -100, 320, 220-20) andBtnTitleArray:array];
            _layerChangeView.delegate=self;
            _layerChangeView.backgroundColor=[UIColor whiteColor];
            _layerChangeView.layer.cornerRadius=10;
        }
        
    }
    return _layerChangeView;
}
-(void)didSelectLayerIndex:(Byte)layerIndex{
    Device *device = kDataModel.currentDevice;
    device.currentLayerIndex = layerIndex;
    if (device->machineData.hasRearView[layerIndex-1]==0) {
        device.currentViewIndex = 0;
    }
    [self initCurrentLayerLabel];
    [[NetworkFactory sharedNetWork] changeLayerAndView];
    NSLog(@"select layer:%d",layerIndex);
}

- (void)frontRearViewBtnClicked:(UIButton*)sender{
    sender.backgroundColor = [UIColor greenColor];
    sender.userInteractionEnabled = NO;
    kDataModel.currentDevice.currentViewIndex = sender.tag;
    if (sender.tag == 0) {
        viewBtn[1].userInteractionEnabled = YES;
        viewBtn[1].backgroundColor = [UIColor TaiheColor];
    }
    else{
        viewBtn[0].userInteractionEnabled = YES;
        viewBtn[0].backgroundColor = [UIColor TaiheColor];
    }
    [self frontRearViewChanged];
}
- (void)frontRearViewBtnAddTargetEvent{
    viewBtn[0].tag = 0;
    viewBtn[1].tag = 1;
    viewBtn[0].layer.cornerRadius = 3.0f;
    viewBtn[1].layer.cornerRadius = 3.0f;
    viewBtn[0].tintColor = [UIColor clearColor];
    viewBtn[1].tintColor = [UIColor clearColor];
    [viewBtn[0] addTarget:self action:@selector(frontRearViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewBtn[1] addTarget:self action:@selector(frontRearViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)frontRearViewChanged{
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    Device *device = kDataModel.currentDevice;
    if (device && self.layerChangeViewShowIn) {
    self.layerChangeView.backgroundView.frame = CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height);
    self.layerChangeView.frame = CGRectMake(self.bounds.size.width/2-160, 0, 320, 200);
    }
}
@end
