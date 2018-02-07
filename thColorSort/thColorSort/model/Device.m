//
//  Device.m
//  thColorSort
//
//  Created by taiheMacos on 2017/3/15.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "Device.h"

@implementation Device
-(instancetype)initWithName:(NSString*)deviceName ID:(NSString*)deviceID IP:(NSString*)deviceIP
{
    if (self = [super init]) {
        screenProtocolMainVersion = 0;
        self.deviceName = deviceName;
        self.deviceID = deviceID;
        self.deviceIP = deviceIP;
        self.currentLayerIndex = 1;
        self.currentSorterIndex = 1;
        self.currentViewIndex = 0;
        colorAlgorithm = NULL;
        irAlgorithm = NULL;
        riceUserAlgorithm = NULL;
        self->data1 = NULL;
        self->data2 = NULL;
        self->data3 = NULL;
        self->data4 = NULL;
        self->delayTime = NULL;
        self->blowTime = NULL;
        self->bUseCenterPoint = NULL;
        self->ejectorType = NULL;
        self->colorBoardVersion = NULL;
        self->normalCameraVersion = NULL;
        frontValveFrequency = NULL;
        rearValveFrequency = NULL;
        valveFrequency = NULL;
        infraredCameraVersion = NULL;
        infraredCameraVersion2 = NULL;
        /*方案相关*/
        self->mode = NULL;
        self->shape = 0;
        self->useSvm = 0;
        
        self.addDigitGain = 0;
        self.currentCameraGain = 0;
        self.modeList1 = [NSMutableArray array];
        self.modeList2 = [NSMutableArray array];
        self.modeList3 = [NSMutableArray array];
        self.modeList4 = [NSMutableArray array];
        self.modeList5 = [NSMutableArray array];
        
        self.bigModeList = [NSMutableArray arrayWithObjects:self.modeList1,self.modeList2,self.modeList3,self.modeList4,self.modeList5,nil];
        //给料器设置
        vibdata = NULL;
        vibSwitch = NULL;
        
        self->currentHsvIndex = 0;
    }
    return self;
}
-(void)dealloc{
    free(self->data1);
    free(self->data2);
    free(self->data3);
    free(self->data4);
    free(self->delayTime);
    free(self->blowTime);
    free(self->bUseCenterPoint);
    free(self->ejectorType);
    free(self->colorBoardVersion);
    free(self->normalCameraVersion);
    free(self->frontValveFrequency);
    free(self->rearValveFrequency);
    free(self->valveFrequency);
    free(self->infraredCameraVersion);
    free(self->infraredCameraVersion2);
    free(vibdata);
    free(vibSwitch);
    free(colorAlgorithm);
    free(irAlgorithm);
    free(riceUserAlgorithm);
}
- (BOOL)bHaveChuteUseReverse { 
    if (data4) {
        BOOL find = NO;
        for (int i = 0; i < machineData.chuteNumber; i++) {
            if (data4[i] == 1) {
                find = YES;
                break;
            }
        }
        return find;
    }
    return NO;
}

@end
