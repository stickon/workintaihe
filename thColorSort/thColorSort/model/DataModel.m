
//
//  DataModel.m
//  thColorSort
//
//  Created by taiheMacos on 2017/3/17.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "DataModel.h"
#import "Device.h"
#import "AppDelegate.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#define Socket_Header_Length 15
@interface DataModel()
{

}
@end
@implementation DataModel
static DataModel *model = nil;
+(DataModel*)globalDataModel
{
    if (model == nil) {
        model = [[[self class]alloc] init];
    }
    return model;
}
-(id)init
{
    if (self = [super init]) {
        self.loginState = Login;
        _deviceList = [NSMutableArray array];
        self.protocolMainVersion = 3;
    }
    return self;
}
#pragma data model

-(NSString*)getDeviceNameByIndex:(NSInteger)index
{
    Device *device = [_deviceList objectAtIndex:index];
    return device.deviceName;
}

-(NSString*)getDeviceIDByIndex:(NSInteger)index
{
    Device *device = [_deviceList objectAtIndex:index];
    return device.deviceID;
}

-(Device*)currentDevice
{
    if (self.deviceList.count>0) {
        return [_deviceList objectAtIndex:_currentDeviceIndex];
    }return nil;
}

-(void)setData:(NSData*)data withType:(Byte)type andIPaddress:(NSString *)ip
{
    const unsigned char *a = [data bytes];
    if (a[0] != 5 && a[0] != 6) {
        DDLogInfo(@"receive data:type:%d,ex_type:%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9],a[10],a[11],a[12],a[13],a[14]);
    }

    switch (type) {
        case 0:
            break;
            case 1:
        {
            if (a[1] == 1) {
                if (_deviceList.count>0) {
                    Device *device = kDataModel.currentDevice;
                    device->screenProtocolMainVersion = a[2];
                    device->screenProtocolMinVersion = a[3];
                    device->screenProtocolType = a[4];
                    unsigned short group = a[5]*256+a[6];
                    int num = 0;
                    Byte n = 0;
                    memset(device->groupLastSort, -1, sizeof(device->groupLastSort));
                    unsigned short tempgroup = group;
                    while(tempgroup){
                        tempgroup = group>>n;
                        if (device->groupLastSort[num] == -1) {
                            device->SortBelongToGroup[n] = num;
                        }
                        n++;
                        if(tempgroup&1)
                        {
                            if(device->groupLastSort[num] == -1)
                            {
                                device->groupLastSort[num] = n;
                            }
                           num++;
                            if (num>3) {
                                break;
                            }
                        }
                    }
                    
                    device->groupNum = num;
                    
                    memcpy(&(device->machineData), a+Socket_Header_Length, data.length-Socket_Header_Length);
                    device->caterpillar.state = device->machineData.wheel[device.currentLayerIndex-1];
                    device.modeName = [NSString stringWithUTF8String:device->machineData.modeName];
                }
            }
        }
            break;
        case 2:
        {
            NSData *deviceData = [data subdataWithRange:NSMakeRange(Socket_Header_Length, data.length-Socket_Header_Length)];
            NSString *dataStr = [[NSString alloc]initWithData:deviceData encoding:NSUTF8StringEncoding];
            
            

            if (a[1]>0) {
                if(a[1] == 1)
                {
                    NSArray *array = [dataStr componentsSeparatedByString:@"#"];
                    NSEnumerator *enumerator = [_deviceList objectEnumerator];
                    Device *anobject;
                    NSMutableString *name = [[array objectAtIndex:1] mutableCopy];
                    if ([name containsString:@"\0"]) {
                         [name replaceOccurrencesOfString:@"\0" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, name.length)];
                    }
                    while (anobject = [enumerator nextObject]) {
                        if([anobject.deviceIP isEqualToString:ip])
                        {
                            if (![anobject.deviceName isEqualToString:name]) {
                                anobject.deviceName = name;
                            }
                            return;
                        }
                    }
                    if(array.count>=2)
                    {
                        Device *device = [[Device alloc]initWithName:name ID:[array objectAtIndex:0] IP:ip];
                        [_deviceList addObject:device];
                    }
                }
            }else{
                 self.loginState = LoginOut;
            }
        }
            break;
            case 0x51:
        {
            Device *device = kDataModel.currentDevice;
            if (device&&[device.deviceIP isEqualToString:ip]) {
                
            }else{
                Device *tempdevice = [[Device alloc]initWithName:nil ID:kDataModel.tcpmachineID IP:ip];
                [_deviceList addObject:tempdevice];
            }
        }
            break;
        case 3:
        {
            Device *device = kDataModel.currentDevice;
            switch (a[1]) {
                case 1:
                    device->machineData.feederState = a[2];
                    break;
                case 2:
                    device->machineData.valveState = a[2];
                    break;
                case 3:
                    device->machineData.startState = a[2];
                    if (device->machineData.startState == 3) {
                        device.errorState = a[3];
                    }
                    break;
                case 4:
                    device->machineData.cleanState = a[2];
                    break;
                default:
                    break;
            }
        }
            break;
            case 0x04:
        {
            if(_deviceList.count>0)
            {
                
                Device *device = kDataModel.currentDevice;
                if (a[1] == 0x01) {
                    if (a[2]) {
                        device.colorAlgorithmNums = (data.length-Socket_Header_Length)/sizeof(ColorAlgorithm);
                        if(device->colorAlgorithm){
                            free(device->colorAlgorithm);
                        }
                        device->colorAlgorithm = malloc(data.length-Socket_Header_Length);
                        memcpy(device->colorAlgorithm, a+Socket_Header_Length, data.length-Socket_Header_Length);
                    }else{
                        device.colorAlgorithmNums = 0;
                    }
                }
                if (a[1] == 0x11) {
                    if (a[2]){
                        device.irAlogrithmNum = (data.length-Socket_Header_Length)/sizeof(ColorAlgorithm);
                        if (device->irAlgorithm) {
                            free(device->irAlgorithm);
                        }
                        device->irAlgorithm = malloc(data.length-Socket_Header_Length);
                        memcpy(device->irAlgorithm, a+Socket_Header_Length, data.length-Socket_Header_Length);
                    }else{
                        device.irAlogrithmNum = 0;
                    }
                }
                if (a[1] == 0x03||a[1]== 0x13) {
                    NSInteger datalength = (data.length-Socket_Header_Length)/device->machineData.chuteNumber;
                    device->IsirDiffOrSpot = a[2];
                    device->irDiffOrSpot[0] = a[3];
                    device->irDiffOrSpot[1] = a[4];
                    device->lightAreaLimit = a[2];
                    device->lightAreaBorderUse = a[3];
                    memset(&device->sense, 0, sizeof(Sense));
                    memcpy(&device->sense, a+Socket_Header_Length, sizeof(Sense));
                    if (device->data1 == NULL) {
                        device->data1 = malloc(device->machineData.chuteNumber);
                    }
                    if (device->data2 == NULL) {
                        device->data2 = malloc(device->machineData.chuteNumber);
                    }
                    if (device->data3 == NULL) {
                        device->data3 = malloc(device->machineData.chuteNumber);
                    }
                    if (datalength>0) {
                        memcpy(device->data1, a+Socket_Header_Length+sizeof(Sense), device->machineData.chuteNumber);
                    }
                    if (datalength>1) {
                        memcpy(device->data2, a+Socket_Header_Length+sizeof(Sense)+device->machineData.chuteNumber, device->machineData.chuteNumber);
                    }
                    if (datalength>2) {
                         memcpy(device->data3, a+Socket_Header_Length+sizeof(Sense)+device->machineData.chuteNumber*2, device->machineData.chuteNumber);
                    }
                    
                }
                if (a[1] == 6) {
                    if (a[4] == 1) {
                        device->lightAreaLimit = a[5];
                    }
                    if (a[4] == 2) {
                        device->lightAreaBorderUse = a[5];
                    }
                }
                if (a[1] == 7) {
                    device->reverse = a[5];
                    device->sharpen = a[6];
                    NSInteger datalength = (data.length-Socket_Header_Length)/device->machineData.chuteNumber;
                    memset(&device->riceSense, 0, sizeof(RiceSense));
                    memcpy(&device->riceSense, a+Socket_Header_Length, sizeof(RiceSense));
                    if (device->data4 == NULL) {
                        device->data4 = malloc(device->machineData.chuteNumber);
                    }
              
                    if (datalength>0) {
                        memcpy(device->data4, a+Socket_Header_Length+sizeof(RiceSense), device->machineData.chuteNumber);
                    }
                }
                if (a[1] == 8) {
                    if (a[5] == 11) {
                        *(device->data4 + a[6]) = a[7];
                    }else if (a[5] == 12){
                        device->riceSense.repair = a[7];
                    }else if (a[5] == 13){
                        device->riceSense.sharpenValue = a[7];
                    }else if (a[5] == 14){
                        device->riceSense.sharpenUse = a[7];
                    }
                }
                if (a[1] == 0x17) {
                    device->irSharpenEnable = a[5];
                    device->irSharpenValue = a[6];
                }
                if (a[1] == 0x18) {
                    if (a[5] == 1) {
                        device->irSharpenEnable = a[6];
                    }
                    if (a[5] == 2) {
                        device->irSharpenValue = a[6];
                    }
                }
                if (a[1] == 0x21) {
                    if (a[2]) {
                        device.userAlgorithmNums = (data.length-Socket_Header_Length)/sizeof(RiceUserAlgorithm);
                        if(device->riceUserAlgorithm){
                            free(device->riceUserAlgorithm);
                        }
                        device->riceUserAlgorithm = malloc(data.length-Socket_Header_Length);
                        memcpy(device->riceUserAlgorithm, a+Socket_Header_Length, data.length-Socket_Header_Length);
                    }else{
                        device.userAlgorithmNums = 0;
                    }
                }
            }
        }
            break;
        case 0x05:
        {
            Device *device = self.currentDevice;
            if (device) {
                if (a[1]<=wave_diff_IR || a[1] == wave_rgb_restrain) {
                    memcpy(&device->waveType, a+2, sizeof(WaveType));
                    device->waveDataCount = (data.length-15)/WaveLength;
                    if(device->waveDataCount>5)
                        device->waveDataCount = 5;
                    for (int i = 0; i<(int)(device->waveDataCount); i++) {
                        memset(device->waveData[i], 0, WaveLength);
                        memcpy(device->waveData[i], a+Socket_Header_Length+i*WaveLength, WaveLength);
                    }
                }else if (a[1] == wave_hsv){
                    memcpy(device->hsvPointX, a+15, 1024);
                    memcpy(device->hsvPointY, a+15+1024, 1024);
                    memcpy(device->hsvLight, a+15+1024+1024, 256);
                }else{//光学校准波形
                    device->waveDataCount = (data.length-15)/CalibrationWaveLength;
                    if(device->waveDataCount>5)
                        device->waveDataCount = 5;
                    for (int i = 0; i<(int)(device->waveDataCount); i++) {
                        memset(device->calibrationWaveData[i], 0, CalibrationWaveLength);
                        memcpy(device->calibrationWaveData[i], a+Socket_Header_Length+i*CalibrationWaveLength, CalibrationWaveLength);
                    }
                }

            }
        }
            break;
            case  0x55:
        {
            Device *device = kDataModel.currentDevice;
            device.offlineDeviceID = [[NSString alloc]initWithBytes:data.bytes+Socket_Header_Length length:data.length-Socket_Header_Length encoding:NSUTF8StringEncoding];
        }
            break;
            case 0x07:
        {
            if (a[1]==0x03) {
                 Device *device = kDataModel.currentDevice;
                memcpy(&device->cleanPara, a+2, 4);
                DDLogInfo(@"clean data param get");
            }
            if (a[1] == 0x05) {
                DDLogInfo(@"clean close valve return");
            }
        }
            break;
        case 0x08:
        {
            Device *device = kDataModel.currentDevice;
            if (a[1] == 0x01) {
                device->machineData.vibIn = a[2];
            }else if (a[1] == 0x02){
                device->machineData.vibOut = a[2];
            }else if (a[1] == 0x04){
                if (a[3] == 0) {
                    device->machineData.fristVib = a[2];
                }
            }else if (a[1] == 0x05){
                memcpy(&device->vibSet,a+Socket_Header_Length,sizeof(VibSet));
                if (device->vibdata == NULL) {
                    device->vibdata = malloc(device->vibSet.ch);
                }
                memcpy(device->vibdata, a+Socket_Header_Length+sizeof(VibSet), device->vibSet.ch);
                if (device->vibSwitch == NULL) {
                    device->vibSwitch = malloc(device->vibSet.ch);
                }
                memcpy(device->vibSwitch, a+Socket_Header_Length+sizeof(VibSet)+device->vibSet.ch, device->vibSet.ch);
            }else if (a[1] == 0x08){
                device->vibSwitch[a[2]]= a[3];
            }
        }
            break;
            case 0x09:
        {
            Device *device = kDataModel.currentDevice;
            if (a[1] == 0x01) {
                int chuteCount = device->machineData.chuteNumber;
                if (device->delayTime == NULL) {
                    device->delayTime = malloc(chuteCount);
                }
                if (device->blowTime == NULL) {
                    device->blowTime = malloc(chuteCount);
                }
                if (device->ejectorType == NULL) {
                    device->ejectorType = malloc(chuteCount);
                }
                if (device->bUseCenterPoint == NULL) {
                    device->bUseCenterPoint = malloc(chuteCount);
                }
                memcpy(&device->valvePara, a+Socket_Header_Length, 2);
                memcpy(device->delayTime, a+Socket_Header_Length+2, chuteCount);
                memcpy(device->blowTime, a+Socket_Header_Length+2+chuteCount, chuteCount);
                memcpy(device->ejectorType, a+Socket_Header_Length+2+chuteCount*2, chuteCount);
                memcpy(device->bUseCenterPoint, a+Socket_Header_Length+2+chuteCount*3, chuteCount);
            }
            if(a[1] == 0x02){
                if (a[4] == 3) {
                    device->delayTime[a[3]] = a[5];
                }else if (a[4] == 4){
                    device->blowTime[a[3]] = a[5];
                }else if (a[4] == 5){
                    device->ejectorType[a[3]] = a[5];
                }else if (a[4] == 6){
                    device->bUseCenterPoint[a[3]] = a[5];
                }
            }
        }
            break;
            case 0x0a:
        {
            Device *device = kDataModel.currentDevice;
            if(a[1] == 0x01)
            {
                NSData *deviceData = [data subdataWithRange:NSMakeRange(Socket_Header_Length, data.length-Socket_Header_Length)];
                const char* Data = deviceData.bytes;
                int position = 0;
                for (int i = 0; i<data.length-Socket_Header_Length; i++) {
                    if (Data[i] == '#') {
                        position = i;
                        break;
                    }
                }
                if (position>0) {
                    NSData *displayScreenVersion = [deviceData subdataWithRange:NSMakeRange(0, position)];
                    device.displayScreenVersion = [NSMutableString stringWithUTF8String:displayScreenVersion.bytes];
                    if ([device.displayScreenVersion containsString:@"\0"]) {
                        [device.displayScreenVersion replaceOccurrencesOfString:@"\0" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, device.displayScreenVersion.length)];
                    }
                    DDLogInfo(@"display:%@",device.displayScreenVersion);
                    memcpy(&device->baseVersion, Data+position+1, sizeof(BaseVersion)-1);
                }
            }
            if (a[1] == 0x02) {
                if (!device->colorBoardVersion) {
                    device->colorBoardVersion = malloc(sizeof(ColorBoardVersion)*(device->machineData.chuteNumber));
                    int count = (int)(data.length-Socket_Header_Length)/sizeof(ColorBoardVersion);
                    for(int i = 0;i<count;i++)
                    {
                        if (i == 0) {
                            for (int j =0; j<device->machineData.chuteNumber; j++) {
                                memcpy(device->colorBoardVersion+j, a+Socket_Header_Length, sizeof(ColorBoardVersion));
                            }
                        }
                        if (i > 0) {
                            ColorBoardVersion colorBoardVersion;
                            memcpy(&colorBoardVersion, a+Socket_Header_Length+i*(sizeof(ColorBoardVersion)), sizeof(ColorBoardVersion));
                            memcpy(device->colorBoardVersion+colorBoardVersion.ch, &colorBoardVersion, sizeof(ColorBoardVersion));
                        }
                    }
                }
            }
            if (a[1] == 0x03){
                if (a[3] == 1) {
                    if (!device->normalCameraVersion) {
                        device->normalCameraVersion = malloc(sizeof(CameraVersion)*(device->machineData.chuteNumber));
                        int count = (int)(data.length-Socket_Header_Length)/sizeof(CameraVersion);
                        for(int i = 0;i<count;i++)
                        {
                            if (i == 0) {
                                for (int j =0; j<device->machineData.chuteNumber; j++) {
                                    memcpy(device->normalCameraVersion+j, a+Socket_Header_Length, sizeof(CameraVersion));
                                }
                            }
                            if (i > 0) {
                                CameraVersion normalCameraVersion;
                                memcpy(&normalCameraVersion, a+Socket_Header_Length+i*(sizeof(CameraVersion)), sizeof(CameraVersion));
                                memcpy(device->normalCameraVersion+normalCameraVersion.ch, &normalCameraVersion, sizeof(CameraVersion));
                            }
                        }
                    }

                }
                 else if (a[3] == 2) {
                     if (!self.currentDevice->infraredCameraVersion) {
                         self.currentDevice->infraredCameraVersion = malloc(sizeof(CameraVersion)*(self.currentDevice->machineData.chuteNumber));
                         int count = (int)(data.length-Socket_Header_Length)/sizeof(CameraVersion);
                         for(int i = 0;i<count;i++)
                         {
                             if (i == 0) {
                                 for (int j =0; j<self.currentDevice->machineData.chuteNumber; j++) {
                                     memcpy(self.currentDevice->infraredCameraVersion+j, a+Socket_Header_Length, sizeof(CameraVersion));
                                 }
                             }
                             if (i > 0) {
                                 CameraVersion cameraVerison;
                                 memcpy(&cameraVerison, a+Socket_Header_Length+i*(sizeof(CameraVersion)), sizeof(CameraVersion));
                                 memcpy(self.currentDevice->infraredCameraVersion+cameraVerison.ch, &cameraVerison, sizeof(CameraVersion));
                             }
                         }
                     }
                 }else if (a[3] == 3) {
                     if (!self.currentDevice->infraredCameraVersion2) {
                         self.currentDevice->infraredCameraVersion2 = malloc(sizeof(CameraVersion)*(self.currentDevice->machineData.chuteNumber));
                         int count = (int)(data.length-Socket_Header_Length)/sizeof(CameraVersion);
                         for(int i = 0;i<count;i++)
                         {
                             if (i == 0) {
                                 for (int j =0; j<self.currentDevice->machineData.chuteNumber; j++) {
                                     memcpy(self.currentDevice->infraredCameraVersion2+j, a+Socket_Header_Length, sizeof(CameraVersion));
                                 }
                             }
                             if (i > 0) {
                                 CameraVersion cameraVerison;
                                 memcpy(&cameraVerison, a+Socket_Header_Length+i*(sizeof(CameraVersion)), sizeof(CameraVersion));
                                 memcpy(self.currentDevice->infraredCameraVersion2+cameraVerison.ch, &cameraVerison, sizeof(CameraVersion));
                             }
                         }
                     }
                 }

            }
        }
            break;
        case 0x0b://灯光
        {
            Device *device = kDataModel.currentDevice;
            if (a[1] == 0x01) {
                memset(&device->lightSetting,0 , sizeof(LightSetting));
                memcpy(&device->lightSetting, a+15, sizeof(LightSetting));
            }else if (a[1] == 0x02){
                Byte viewIndex = a[3];
                Byte type = a[4];
                if (type == LightType_R) {
                    device->lightSetting.r[viewIndex] = a[5];
                }else if (type == LightType_G){
                    device->lightSetting.g[viewIndex] = a[5];
                }else if (type == LightType_B){
                    device->lightSetting.b[viewIndex] = a[5];
                }else if (type == LightType_MainLight){
                    device->lightSetting.MainLight[viewIndex] = a[5];
                }else if (type == LightType_IR){
                    device->lightSetting.ir[viewIndex] = a[5];
                }
            }
        }
            break;
        case 0x0c://相机增益
        {
            Device *device = kDataModel.currentDevice;
            if (a[1] == 0x01 || a[1] == 0x03) {
                device.addDigitGain = a[4];
                device.currentCameraGain = a[5];
                memset(&device->cameraGain, 0, sizeof(CameraGain));
                memcpy(&device->cameraGain, a+15, sizeof(CameraGain));
            }
            else if (a[1] == 0x02){//协议暂时不使用,数字增益较大，需要用多个字节表示
                Byte viewIndex = a[3];
                if (viewIndex == 0) {
                    if (a[6] == 1) {
                        device->cameraGain.r[0] = a[8];
                        device->cameraGain.r[1] = a[9];
                    }else if (a[6] == 2){
                        device->cameraGain.g[0] = a[8];
                        device->cameraGain.g[1] = a[9];
                    }else if (a[6] == 3){
                        device->cameraGain.b[0] = a[8];
                        device->cameraGain.b[1] = a[9];
                    }else if (a[6] == 4){
                        device->cameraGain.ir1[0] = a[9];
                    }else if (a[6] == 5){
                        device->cameraGain.ir2[0] = a[9];
                    }
                }else{
                    if (a[6] == 1) {
                        device->cameraGain.r[2] = a[8];
                        device->cameraGain.r[3] = a[9];
                    }else if (a[6] == 2){
                        device->cameraGain.g[2] = a[8];
                        device->cameraGain.g[3] = a[9];
                    }else if (a[6] == 3){
                        device->cameraGain.b[2] = a[8];
                        device->cameraGain.b[3] = a[9];
                    }else if (a[6] == 4){
                        device->cameraGain.ir1[1] = a[9];
                    }else if (a[6] == 5){
                        device->cameraGain.ir2[1] = a[9];
                    }
                }
                
            }
        }
            break;
        case 0x0d://方案
        {
            Device *device = kDataModel.currentDevice;
            if (a[1] == 0x01) {
                NSString *dataStr = [[NSString alloc]initWithBytes:data.bytes+Socket_Header_Length length:data.length-Socket_Header_Length encoding:NSUTF8StringEncoding];
                
                NSArray *array = [dataStr componentsSeparatedByString:@"$"];
                for (int i = 0; i<array.count; i++) {
                    NSString *mode = [array objectAtIndex:i];
                    NSArray *modearr = [mode componentsSeparatedByString:@"#"];
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    if(modearr.count>2)
                    {
                        [dict setValue:[modearr objectAtIndex:0]forKey:@"modeName"];
                        [dict setValue:[modearr objectAtIndex:1] forKey:@"modifyTime"];
                        [dict setValue:[modearr objectAtIndex:2] forKey:@"modeRealIndex"];
                        if (device.currentSelectBigModeIndex == 0) {
                            [device.modeList1 addObject:dict];
                        }else if (device.currentSelectBigModeIndex == 1){
                            [device.modeList2 addObject:dict];
                        }else if (device.currentSelectBigModeIndex == 2){
                            [device.modeList3 addObject:dict];
                        }else if (device.currentSelectBigModeIndex == 3){
                            [device.modeList4 addObject:dict];
                        }else if (device.currentSelectBigModeIndex == 4){
                            [device.modeList5 addObject:dict];
                        }
                    }
                    
                }
                
            }else if (a[1]==0x02){
                
            }else if (a[1] == 0x03){
                int modeLength = a[2]*sizeof(Mode);
                if (!device->mode) {
                    device->mode = malloc(modeLength);
                }
                
                memcpy(device->mode, a+Socket_Header_Length, modeLength);
                device->shape = a[Socket_Header_Length+modeLength];
                device->useSvm = a[Socket_Header_Length+modeLength+1];
                device->useHsv = a[Socket_Header_Length+modeLength+2];
                
            }else if (a[1] == 0x04){
                
            }else if (a[1] == 0x05){
           
            }
        }
        case 0x0e:
            if (a[1] == 0x01) {
                Device *device = kDataModel.currentDevice;
                if (!device->valveFrequency) {
                        device->valveFrequency = malloc(a[3]*a[2]*2);
                }
                else{
                    Byte count = a[2];
                    Byte frontrear = a[3];
                    if (count*frontrear > (device->valveCount)*(device->valveFrontRear)) {
                        free(device->valveFrequency);
                        device->valveFrequency = malloc(count*frontrear*2);
                    }
                }
                device->valveCount = a[2];
                device->valveFrontRear = a[3];
                memcpy(device->valveFrequency, a+15, a[2]*a[3]*2);
            }
            break;
            case 0x0f:
        {
            Device *device = kDataModel.currentDevice;
            if (a[1] == 0x01) {
                device->machineData.wheel[a[2]-1] = a[3];
                DDLogInfo(@"%d layer:%d",a[2],a[3]);
                device->caterpillar.state = a[3];
            }else if (a[1] == 0x02){
                device->caterpillar.speed[0] = a[3];
                device->caterpillar.speed[1] = a[4];
            }else if (a[1] == 0x04){
                device->caterpillar.settingSpeedMin[0] = a[3];
                device->caterpillar.settingSpeedMin[1] = a[4];
                device->caterpillar.settingSpeedMax[0] = a[5];
                device->caterpillar.settingSpeedMax[1] = a[6];
            }
        }
            break;
        case 0x10:{
            Device *device = kDataModel.currentDevice;
            if (a[1] == 0x01 ||a[1] == 0x11) {
                device->showSvmSecond = a[4];
                device->svmIsProportion = a[5];
                device.groupNum = a[6];
                memcpy(&(device->svm), a+Socket_Header_Length, sizeof(Svm));
            }
            if (a[1] == 0x02) {
                if(a[4] == 0){
                    device->svm.used = a[6];
                }else if (a[4] ==1){
                    device->svm.blowSample = a[6];
                }else if (a[4] ==2){
                    device->svm.spotDiff_1[0] = a[5];
                    device->svm.spotDiff_1[1] = a[6];
                }else if (a[4] ==3){
                    device->svm.sensor_1 = a[6];
                }else if (a[4] ==4){
                    device->svm.spotDiff_2[0] = a[5];
                    device->svm.spotDiff_2[1] = a[6];
                }else if (a[4] ==5){
                    device->svm.sensor_2 = a[6];
                }
            }
            if (a[1] == 0x12) {
                if (a[4] == 0 || a[4] == 1) {
                    device->svm.used = a[6];
                }else if (a[4] == 2 || a[4] == 4){
                    device->svm.spotDiff_1[0] = a[5];
                    device->svm.spotDiff_1[1] = a[6];
                }else if (a[4] == 3 ||a[4] == 5){
                    device->svm.sensor_1 = a[6];
                }else if (a[4] == 6){
                    device->svm.blowSample = a[6];
                }
            }
        }break;
        case 0x11:
            if (a[1] == 0x01) {
                Device *device = kDataModel.currentDevice;
                device->waveAvgData = a[2];
                device->waveDiffData = a[3];
            }
            break;
        case 0x12:{
            Device *device = kDataModel.currentDevice;
            if (a[1] == 1) {
                memcpy(&device->cashew, a+15, sizeof(CashewSet));
            }else if (a[1] == 2){
                device->cashew.textView[a[3]-1][0] = a[4];
                device->cashew.textView[a[3]-1][1] = a[5];
            }else if (a[1] == 3){
                device->cashew.useType = a[3];
            }
            break;
        }
        case 0x13:{
            Device *device = kDataModel.currentDevice;
            if (a[1] ==1) {
                memcpy(&device->peanutbud, a+15, sizeof(PeanutbudSet));
            }else if (a[1] == 2){
                device->peanutbud.textView[a[3]-1]= a[4];
            }else if (a[1] == 3){
                device->peanutbud.buttonUse[a[3]] = a[4];
            }else if (a[1] == 0x11){
                memcpy(&device->peanutbud3, a+15, sizeof(Peanutbud3Set));
            }else if (a[1] == 0x12){
                if (a[3] < 5) {
                    device->peanutbud3.textView[a[3]-1] = a[5];
                }else if (a[3] == 5){
                    device->peanutbud3.textView[4] = a[4];
                    device->peanutbud3.textView[5] = a[5];
                }else if (a[3] >5 && a[3]<10){
                    device->peanutbud3.textView[a[3]] = a[5];
                }else if (a[3] == 10){
                    device->peanutbud3.textView[10] = a[4];
                    device->peanutbud3.textView[11] = a[5];
                }
            }else if (a[1] == 0x13){
                device->peanutbud3.buttonUse[a[3]] = a[4];
            }
            break;
        }
        case 0x14:{
            Device *device = kDataModel.currentDevice;
            if (a[1] ==1) {
                memcpy(&device->standardShape, a+15, sizeof(StandardShapeSet));
            }else if (a[1] == 2){
                device->standardShape.textView[a[3]-1][0]= a[4];
                device->standardShape.textView[a[3]-1][1]= a[5];
            }else if (a[1] == 3){
                device->standardShape.buttonUse[a[3]] = a[4];
            }
            break;
        }
        case 0x15:{
            Device *device = kDataModel.currentDevice;
            if (a[1] ==1) {
                memcpy(&device->tea, a+15, sizeof(TeaShapeSet));
            }else if (a[1] == 2){
                device->tea.textView[a[3]-1][0]= a[4];
                device->tea.textView[a[3]-1][1]= a[5];
            }else if (a[1] == 3){
                device->tea.buttonUse[a[3]-1] = a[4];
            }
            break;
        }
        case 0x16:{
            Device *device = kDataModel.currentDevice;
            if (a[1] ==1) {
                memcpy(&device->riceShape, a+15, sizeof(RiceShape));
            }else if (a[1] == 3){
                device->riceShape.buttonUse[a[3]-1] = a[4];
            }
            break;
        }
        case 0x17:{
            Device *device = kDataModel.currentDevice;
            if (a[1] ==1) {
                memcpy(&device->licorice, a+15, sizeof(Licorice));
            }else if (a[1] == 2){
                device->licorice.textView[a[3]-1] = a[4];
            }else if (a[1] == 3){
                device->licorice.buttonUse[a[3]-1] = a[4];
            }
            break;
        }
        case 0x18:{
            Device *device = kDataModel.currentDevice;
            if (a[1] ==1) {
                memcpy(&device->wheat, a+15, sizeof(WheatShapeSet));
            }else if (a[1] == 2){
                device->wheat.textView[a[3]-1][0] = a[4];
                device->wheat.textView[a[3]-1][1] = a[5];
            }else if (a[1] == 3){
                device->wheat.buttonUse= a[3];
            }
            break;
        }
        case 0x19:{
            Device *device = kDataModel.currentDevice;
            if (a[1] ==1) {
                memcpy(&device->seed, a+15, sizeof(SeedShapeSet));
            }else if (a[1] == 2){
                device->seed.textView[a[3]-1] = a[4];
            }else if (a[1] == 3){
                device->seed.buttonUse= a[3];
            }
            break;
        }
        case 0x1a:{
            Device *device = kDataModel.currentDevice;
            if (a[1] ==1) {
                memcpy(&device->sunflower, a+15, sizeof(SunflowerShapeSet));
            }else if (a[1] == 2){
                device->sunflower.textView[a[3]-1][0] = a[4];
                device->sunflower.textView[a[3]-1][1] = a[5];

            }else if (a[1] == 3){
                device->sunflower.buttonUse= a[3];
            }
            break;
        }
        case 0x1b:{
            Device *device = kDataModel.currentDevice;
            if (a[1] ==1) {
                memcpy(&device->corn, a+15, sizeof(CornShapeSet));
            }else if (a[1] == 2){
                device->corn.textView[a[3]-1]= a[4];
            }else if (a[1] == 3){
                device->corn.buttonUse[a[3]]= a[4];
            }
            break;
        }
        case 0x1c:{
            Device *device = kDataModel.currentDevice;
            if (a[1] ==1) {
                memcpy(&device->horseBean, a+15, sizeof(HorseBeanShapeSet));
            }else if (a[1] == 2){
                device->horseBean.textView[a[3]-1]= a[4];
            }else if (a[1] == 3){
                device->horseBean.buttonUse[a[3]]= a[4];
            }
            break;
        }
        case 0x1d:{
            Device *device = kDataModel.currentDevice;
            if (a[1] ==1) {
                memcpy(&device->greenTea, a+15, sizeof(GreenTeaShapeSet));
            }else if (a[1] == 2){
                if (a[3] < 4) {
                    device->greenTea.textView[a[3]-1]= a[5];
                }else{
                    device->greenTea.lastView[0]= a[4];
                    device->greenTea.lastView[1]= a[5];
                }
            }else if (a[1] == 3){
                device->greenTea.buttonUse[a[3]]= a[4];
            }
            break;
        }
        case 0x1e:{
            Device *device = kDataModel.currentDevice;
            if (a[1] ==1) {
                memcpy(&device->redTea, a+15, sizeof(RedTeaShapeSet));
            }else if (a[1] == 2){
                if (a[3] == 7) {
                    device->redTea.textView[6] = a[4];
                    device->redTea.textView[7] = a[5];
                }else if (a[3] == 8){
                    device->redTea.textView[8] = a[5];
                }else{
                    device->redTea.textView[a[3]-1]= a[5];
                }
            }else if (a[1] == 3){
                device->redTea.buttonUse[a[3]]= a[4];
            }
            break;
        }
        case 0x1f:{
            Device *device = kDataModel.currentDevice;
            if (a[1] ==1) {
                memcpy(&device->greenTeaSG, a+15, sizeof(GreenTeaSGShapeSet));
            }else if (a[1] == 2){
                if (a[3] == 5) {
                    device->greenTeaSG.lastView[0] = a[4];
                    device->greenTeaSG.lastView[1] = a[5];
                }else{
                    device->greenTeaSG.textView[a[3]-1]= a[5];
                }
            }else if (a[1] == 3){
                device->greenTeaSG.buttonUse[a[3]]= a[4];
            }
            break;
        }
        case 0xa0:{
            Device *device = kDataModel.currentDevice;
            if (a[1] == 0x02) {
                device.sysCheckInfo = [[NSString alloc]initWithBytes:a+Socket_Header_Length length:data.length-Socket_Header_Length encoding:NSUTF8StringEncoding];
                DDLogInfo(@"checkinfo:%@",device.sysCheckInfo);
            }else if(a[1] == 0x03){
                memcpy(&device->workTime, a+15, sizeof(WorkTime));
            }
            break;
        }
        case 0x30:{
            Device *device = kDataModel.currentDevice;
            if (a[1] == 1) {
                device->currentHsvIndex = a[3];
                device->currentHsvLightColorIndex = a[4];
                device->hsvOffset = a[5];
                memcpy(&device->hsv[0], a+15, sizeof(HsvSense));
                if (a[2] == 1) {
                    device->hasHsv2 = YES;
                    memcpy(&device->hsv[1], a+15+sizeof(HsvSense), sizeof(HsvSense));
                }else
                    device->hasHsv2 = NO;
            }else if (a[1] ==2){
                if (a[6] == 4) {
                    device->hsv[a[5]].v[0] = a[8];
                }else if (a[6] == 5){
                    device->hsv[a[5]].v[1] = a[8];
                }else if (a[6] == 6){
                    device->hsv[a[5]].s[0] = a[8];
                }else if (a[6] == 7){
                    device->hsv[a[5]].s[1] = a[8];
                }else if (a[6] == 8){
                    device->hsv[a[5]].h[0][0] = a[7];
                    device->hsv[a[5]].h[0][1] = a[8];
                }else if (a[6] == 9){
                    device->hsv[a[5]].h[1][0] = a[7];
                    device->hsv[a[5]].h[1][1] = a[8];
                }else if (a[6] == 10){
                    device->hsv[a[5]].width = a[8];
                }else if (a[6] == 11){
                    device->hsv[a[5]].height = a[8];
                }else if (a[6] == 12){
                    device->hsv[a[5]].number[0] = a[7];
                    device->hsv[a[5]].number[1] = a[8];
                }else if (a[6] == 13){
                    device->hsv[a[5]].hsvUse = a[8];
                }
            }else if (a[1] == 3){
                if (a[2] == 1) {
                    device->currentHsvIndex = a[3];
                }else if (a[2] == 2){
                    device->hsvOffset = a[3];
                }
                
            }
            break;
        }
        default:
            break;
    }
}

-(NSInteger)getDeviceCount
{
    return self.deviceList.count;
}

-(void)saveDownloadData:(NSData*)data withFileName:(NSString*)fileName withType:(Byte)type isEnd:(Byte)fileEnd{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *tmpPath = [tmpDir stringByAppendingString:fileName];
    if (![fileManager fileExistsAtPath:tmpPath]) {
            if(![fileManager createFileAtPath:tmpPath contents:nil attributes:nil]){
                DDLogInfo(@"file create success");
            }
        }
    NSFileHandle *handle  = [NSFileHandle fileHandleForWritingAtPath:tmpPath];
    if (handle) {
        [handle seekToEndOfFile];
        [handle writeData:data];
        [handle closeFile];
        if (fileEnd){
            if (type == 1) {
                NSString *content = [NSString stringWithContentsOfFile:tmpPath encoding:NSUTF8StringEncoding error:nil];
                
                NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSMutableArray *languageArray = [[dict objectForKey:@"language"] mutableCopy];
                if (self.tempLanguageArray.count>0) {
                     [self.tempLanguageArray removeAllObjects];
                }
                self.tempLanguageArray = languageArray;
                NSDictionary *version = [dict objectForKey:@"ios"];
                if (version) {
#ifdef Engineer
                    NSDictionary *engineerVersion = [version objectForKey:@"engineer"];
                    self.appVersionDictionary = engineerVersion;
                    self.tempVersion = [engineerVersion objectForKey:@"version"];
#else
                    NSDictionary *userVersion = [version objectForKey:@"user"];
                    self.appVersionDictionary = userVersion;
                    self.tempVersion = [userVersion objectForKey:@"version"];
#endif
                    
                }
                if ([fileManager removeItemAtPath:tmpPath error:nil]) {
                    DDLogInfo(@"temp config remove success");
                }
            }else if(type == 3){
                NSArray *array = [fileName componentsSeparatedByString:@"."];
                [FileOperation copyFile2Documents:[array objectAtIndex:0] fromPath:tmpPath];
                if ([fileManager removeItemAtPath:tmpPath error:nil]) {
                    DDLogInfo(@"temp language remove success");
                }
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSMutableArray *languageArray = [[defaults objectForKey:languageDefaultsArrayKey] mutableCopy];
                bool exist = false;
                int i = 0;
                NSMutableDictionary *dict = nil;
                for (id obj in languageArray) {//搜索下载的语言包是否存在
                    dict = obj;
                    if ([[dict valueForKey:@"url"] isEqualToString:fileName]) {
                        exist = true;
                        break;
                    }
                    i++;
                }
                for (id obj in _tempLanguageArray) {
                    NSMutableDictionary *dicttemp = obj;
                    if ([[dicttemp valueForKey:@"url"] isEqualToString:fileName]) {
                        if (exist) {//存在则替换在userdefaults中的
                            [languageArray replaceObjectAtIndex:i withObject:dicttemp];
                        }else{//不存在则追加
                            [languageArray addObject:dicttemp];
                        }
                        [defaults setObject:languageArray forKey:languageDefaultsArrayKey];
                    }
                }
                DDLogInfo(@"%@",languageArray);
            }
        }
        
    }
}
@end
