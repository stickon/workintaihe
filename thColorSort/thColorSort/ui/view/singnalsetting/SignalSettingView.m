//
//  SignalSettingView.m
//  thColorSort
//
//  Created by taihe on 2018/1/15.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "SignalSettingView.h"
#import "UIComboBox.h"
#import "BaseUITextField.h"
#import "BackgroundLightTableViewCell.h"
#import "MainLightTableViewCell.h"
#import "IRMainLightTableViewCell.h"
#import "CameraGainTableViewCell.h"
#import "CameraGainSettingTableViewCell.h"
#import "WaveDataTableViewCell.h"
static NSString *BackgroundLightTableViewCellIdentify = @"BackgroundLightTableViewCell";
static NSString *MainLightTableViewCellIdentify = @"MainLightTableViewCell";
static NSString *IRMainLightTableViewCellIdentify = @"IRMainLightTableViewCell";
static NSString *CameraGainTableViewCellIdentify = @"CameraGainTableViewCell";
static NSString *CameraGainSettingTableViewCellIdentify = @"CameraGainSettingTableViewCell";
static NSString *WaveDataTableViewCellIdentify = @"WaveDataTableViewCell";

@interface SignalSettingView()<UITableViewDelegate,UITableViewDataSource,TableViewCellChangedDelegate>{
    BOOL dataLoaded;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *signalTypeSegmentedControl;

@property (nonatomic,assign) Byte signalType;//light or cameragain
@property (nonatomic,assign) Byte ajustType;//0:single 1:all
@property (nonatomic,assign) Byte gainType;//digtal or
@property (strong,nonatomic) NSTimer *timer;

@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;



@end
@implementation SignalSettingView
-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"SignalSettingView" owner:self options:nil] firstObject];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        dataLoaded = false;
        [self.tableView registerNib:[UINib nibWithNibName:BackgroundLightTableViewCellIdentify bundle:nil] forCellReuseIdentifier:BackgroundLightTableViewCellIdentify];
        [self.tableView registerNib:[UINib nibWithNibName:MainLightTableViewCellIdentify bundle:nil] forCellReuseIdentifier:MainLightTableViewCellIdentify];
        [self.tableView registerNib:[UINib nibWithNibName:IRMainLightTableViewCellIdentify bundle:nil] forCellReuseIdentifier:IRMainLightTableViewCellIdentify];
        [self.tableView registerNib:[UINib nibWithNibName:CameraGainTableViewCellIdentify bundle:nil] forCellReuseIdentifier:CameraGainTableViewCellIdentify];
        [self.tableView registerNib:[UINib nibWithNibName:CameraGainSettingTableViewCellIdentify bundle:nil] forCellReuseIdentifier:CameraGainSettingTableViewCellIdentify];
        [self.tableView registerNib:[UINib nibWithNibName:WaveDataTableViewCellIdentify bundle:nil] forCellReuseIdentifier:WaveDataTableViewCellIdentify];
        self.signalType = 0;//default lighting
        self.ajustType = 0;//default ajusttype
        
        
        [self.signalTypeSegmentedControl setSelectedSegmentIndex:0];
        [self.signalTypeSegmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self requestData];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeout) userInfo:nil repeats:YES];
        Device *device = kDataModel.currentDevice;
        if (device->machineData.layerNumber>1) {
            self.baseLayerLabel = self.currentLayerLabel;
        }else{
            self.currentLayerLabel.frame = CGRectZero;
            self.currentLayerLabelHeightConstraint.constant = 0.0f;
        }
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    
    return self;
}
-(UIView*)getViewWithPara:(NSDictionary *)para{
    [self initLanguage];
    return self;
}

- (void)initLanguage{
    [self.signalTypeSegmentedControl setTitle:kLanguageForKey(102) forSegmentAtIndex:0];
    [self.signalTypeSegmentedControl setTitle:kLanguageForKey(103) forSegmentAtIndex:1];
    
    self.title = kLanguageForKey(96);
}
-(void)updateWithHeader:(NSData *)headerData
{
    Device *device = kDataModel.currentDevice;
    const unsigned char*a = headerData.bytes;
    if (a[0] == 0x05) {
        dataLoaded = true;
        if(a[1] == 0x03 ||a[1] == 0x04 || a[1] == 0x05){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            WaveDataTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            for (int i = 0; i<device->waveDataCount; i++) {
                [cell bindWaveData:device->waveData[i] withIndex:i];
            }
            [cell bindWaveDataType:a[1] irUseType:device->machineData.useIR WaveCount:device->waveDataCount];
        }
    }
    if (a[0] == 0x0c || a[0]== 0x0b) {
        dataLoaded = true;
        [self.tableView reloadData];
    }
    if(a[0] == 0x03 && a[1] == 0x03){
        dataLoaded = true;
        [self.tableView reloadData];
    }
    if (a[0]  == 0x55) {
        [self.timer invalidate];
        [super updateWithHeader:headerData];
    }
    if (a[0] == 0xb0) {
        [self requestData];
    }
}


-(BOOL)Back{
    [_timer invalidate];
    return [super Back];
}

-(void)timeout{
    Device *device = kDataModel.currentDevice;
    if (_signalType == 0) {
        [[NetworkFactory sharedNetWork]sendToGetWaveDataWithAlgorithmType:0 AndWaveType:wave_background AndDataType:0 Position:0];
    }
    else{
        if (device.addDigitGain) {
            if (device.currentCameraGain) {
                [[NetworkFactory sharedNetWork] sendToGetWaveDataWithAlgorithmType:0 AndWaveType:wave_cameraGain AndDataType:0 Position:0];
            }
            else{
                [[NetworkFactory sharedNetWork]sendToGetWaveDataWithAlgorithmType:0 AndWaveType:wave_cameraGainDigit AndDataType:0 Position:0];
            }
        }else{
            [[NetworkFactory sharedNetWork] sendToGetWaveDataWithAlgorithmType:0 AndWaveType:wave_cameraGain AndDataType:0 Position:0];
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    Device *device = kDataModel.currentDevice;
    if (dataLoaded) {
        if (self.signalType == 0){
            if (device->machineData.useIR>0) {
                return 4;
            }else{
                return 3;
            }
        }else{
            return 3;
        }
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataLoaded) {
        return 1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        return 10;
    }return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGFloat width =[UIScreen mainScreen].bounds.size.width-40;
        CGFloat height = (width-40)*0.618+60;
        return height;
    }else if (indexPath.section == 1){
        if (self.signalType == 0) {
            return 180;
        }else{
            return 44;
        }
    }else if (indexPath.section == 2){
        if (self.signalType == 0) {
            return 100;
        }else{
            return 135;
        }
        
    }else if (indexPath.section == 3){
        return 80;
    }
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Device *device = kDataModel.currentDevice;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            WaveDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WaveDataTableViewCellIdentify forIndexPath:indexPath];
            cell.chuteTitleLabel.text = kLanguageForKey(41) ;
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.chuteNumCount = device->machineData.chuteNumber;
            for (int i = 0; i<device->waveDataCount; i++) {
                [cell bindWaveData:device->waveData[i] withIndex:i];
            }
            if (self.signalType == 0) {
                [cell bindWaveDataType:wave_background irUseType:device->machineData.useIR WaveCount:device->waveDataCount];
            }else{
                if (self.gainType == 0) {
                    [cell bindWaveDataType:wave_cameraGain irUseType:device->machineData.useIR WaveCount:device->waveDataCount];
                }else{
                    [cell bindWaveDataType:wave_cameraGainDigit irUseType:device->machineData.useIR WaveCount:device->waveDataCount];
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            
            if (self.signalType == 0) {//灯光背景灯cell
                BackgroundLightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BackgroundLightTableViewCellIdentify];
                cell.indexPath = indexPath;
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                bool enable = NO;
                if (device->machineData.startState != 1) {
                    enable = YES;
                }
                [cell.backgroundLightTitleLabel setText:kLanguageForKey(101)];
                [cell.frontTitleLabel setText:kLanguageForKey(75)];
                [cell.rearTitleLabel setText:kLanguageForKey(76)];
                cell.redTextField.enabled = enable;
                cell.greenTextField.enabled = enable;
                cell.blueTextField.enabled = enable;
                cell.rearRedTextField.enabled = enable;
                cell.rearGreenTextField.enabled = enable;
                cell.rearBlueTextField.enabled = enable;
                if (device->machineData.hasRearView[device.currentLayerIndex-1]==0) {
                    [cell.rearTitleLabel setHidden:YES];
                    [cell.rearRedTextField setHidden:YES];
                    [cell.rearGreenTextField setHidden:YES];
                    [cell.rearBlueTextField setHidden:YES];
                }else{
                    [cell.rearTitleLabel setHidden:NO];
                    [cell.rearRedTextField setHidden:NO];
                    [cell.rearGreenTextField setHidden:NO];
                    [cell.rearBlueTextField setHidden:NO];
                }
                cell.redTextField.text = [NSString stringWithFormat:@"%d",device->lightSetting.r[0]];
                cell.greenTextField.text = [NSString stringWithFormat:@"%d",device->lightSetting.g[0]];
                cell.blueTextField.text = [NSString stringWithFormat:@"%d",device->lightSetting.b[0]];
                cell.rearRedTextField.text = [NSString stringWithFormat:@"%d",device->lightSetting.r[1]];
                cell.rearGreenTextField.text = [NSString stringWithFormat:@"%d",device->lightSetting.g[1]];
                cell.rearBlueTextField.text = [NSString stringWithFormat:@"%d",device->lightSetting.b[1]];
                return cell;
            }
            else{
                CameraGainSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CameraGainSettingTableViewCellIdentify];
                cell.indexPath = indexPath;
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.cameraGainSegmentControl setTitle:kLanguageForKey(98) forSegmentAtIndex:0];
                [cell.cameraGainSegmentControl setTitle:kLanguageForKey(99) forSegmentAtIndex:1];
                [cell.switchLabel setText:kLanguageForKey(100)];
                if (device.addDigitGain) {
                    [cell.cameraGainSegmentControl setHidden:NO];
                    if (device.currentCameraGain) {
                        cell.cameraGainSegmentControl.selectedSegmentIndex = 1;
                    }else{
                        cell.cameraGainSegmentControl.selectedSegmentIndex = 0;
                    }
                }else{
                    [cell.cameraGainSegmentControl setHidden:YES];
                }
                
                cell.switchLabel.text = kLanguageForKey(100);
                return cell;
            }
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            if (self.signalType == 1){
                CameraGainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CameraGainTableViewCellIdentify];
                cell.indexPath = indexPath;
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.gainType = device.currentCameraGain;
                bool enable = NO;
                if (device->machineData.startState != 1) {
                    enable = YES;
                }
                [cell.frontTitleLabel setText:kLanguageForKey(75)];
                [cell.rearTitleLabel setText:kLanguageForKey(76)];
                
                cell.ir1CameraTextField.enabled = enable;
                cell.ir2CameraTextField.enabled = enable;
                cell.redTextField.enabled = enable;
                cell.greenTextField.enabled = enable;
                cell.blueTextField.enabled = enable;
                cell.rearIR1TextField.enabled = enable;
                cell.rearIR2TextField.enabled = enable;
                cell.rearRedTextField.enabled = enable;
                cell.rearGreenTextField.enabled = enable;
                cell.rearBlueTextField.enabled = enable;
                cell.redTextField.text = [NSString stringWithFormat:@"%d",(int)Combine((NSUInteger)(device->cameraGain.r[0]),(NSUInteger)(device->cameraGain.r[1]))];
                cell.greenTextField.text = [NSString stringWithFormat:@"%d",(int)Combine((NSUInteger)(device->cameraGain.g[0]),(NSUInteger)(device->cameraGain.g[1]))];
                cell.blueTextField.text = [NSString stringWithFormat:@"%d",(int)Combine((NSUInteger)(device->cameraGain.b[0]),(NSUInteger)(device->cameraGain.b[1]))];
                
                
                cell.rearRedTextField.text = [NSString stringWithFormat:@"%d",(int)Combine((NSUInteger)(device->cameraGain.r[2]),(NSUInteger)(device->cameraGain.r[3]))];
                cell.rearGreenTextField.text = [NSString stringWithFormat:@"%d",(int)Combine((NSUInteger)(device->cameraGain.g[2]),(NSUInteger)(device->cameraGain.g[3]))];
                cell.rearBlueTextField.text = [NSString stringWithFormat:@"%d",(int)Combine((NSUInteger)(device->cameraGain.b[2]),(NSUInteger)(device->cameraGain.b[3]))];
                
                if (device->machineData.useIR>0) {
                    cell.ir1CameraTextField.text = [NSString stringWithFormat:@"%d",device->cameraGain.ir1[0]];
                    cell.ir2CameraTextField.text = [NSString stringWithFormat:@"%d",device->cameraGain.ir2[0]];
                    cell.rearIR1TextField.text = [NSString stringWithFormat:@"%d",device->cameraGain.ir1[1]];
                    cell.rearIR2TextField.text = [NSString stringWithFormat:@"%d",device->cameraGain.ir2[1]];
                }
                
                
                if (device->machineData.useIR == 0) {
                    [cell.irCameraLabel1 setHidden:true];
                    [cell.irCameraLabel2 setHidden:true];
                    [cell.ir1CameraTextField setHidden:true];
                    [cell.ir2CameraTextField setHidden:true];
                    [cell.rearIR1TextField setHidden:true];
                    [cell.rearIR2TextField setHidden:true];
                    if (device->machineData.hasRearView[device.currentLayerIndex-1]==0) {
                        [cell.rearTitleLabel setHidden:YES];
                        [cell.rearRedTextField setHidden:YES];
                        [cell.rearGreenTextField setHidden:YES];
                        [cell.rearBlueTextField setHidden:YES];
                    }else{
                        [cell.rearTitleLabel setHidden:NO];
                        [cell.rearRedTextField setHidden:NO];
                        [cell.rearGreenTextField setHidden:NO];
                        [cell.rearBlueTextField setHidden:NO];
                    }
                }else if (device->machineData.useIR == 1) {
                    [cell.irCameraLabel1 setHidden:NO];
                    [cell.irCameraLabel2 setHidden:YES];
                    [cell.ir1CameraTextField setHidden:NO];
                    [cell.ir2CameraTextField setHidden:YES];
                    [cell.rearIR2TextField setHidden:YES];
                    [cell.rearIR1TextField setHidden:YES];
                }else if (device->machineData.useIR == 2){
                    [cell.irCameraLabel1 setHidden:NO];
                    [cell.irCameraLabel2 setHidden:YES];
                    [cell.ir1CameraTextField setHidden:YES];
                    [cell.ir2CameraTextField setHidden:NO];
                    [cell.rearIR2TextField setHidden:YES];
                    [cell.rearIR1TextField setHidden:YES];
                }else if (device->machineData.useIR == 3){
                    [cell.irCameraLabel1 setHidden:NO];
                    [cell.irCameraLabel2 setHidden:YES];
                    [cell.ir1CameraTextField setHidden:NO];
                    [cell.ir2CameraTextField setHidden:YES];
                    [cell.rearIR2TextField setHidden:YES];
                    [cell.rearIR1TextField setHidden:NO];
                }else if (device->machineData.useIR == 4 || device->machineData.useIR == 7){
                    [cell.irCameraLabel1 setHidden:NO];
                    [cell.irCameraLabel2 setHidden:NO];
                    [cell.ir1CameraTextField setHidden:NO];
                    [cell.ir2CameraTextField setHidden:NO];
                    [cell.rearIR2TextField setHidden:YES];
                    [cell.rearIR1TextField setHidden:YES];
                }else if (device->machineData.useIR == 5 ||device->machineData.useIR == 8){
                    [cell.irCameraLabel1 setHidden:NO];
                    [cell.irCameraLabel2 setHidden:NO];
                    [cell.ir1CameraTextField setHidden:YES];
                    [cell.ir2CameraTextField setHidden:YES];
                    [cell.rearIR2TextField setHidden:NO];
                    [cell.rearIR1TextField setHidden:NO];
                }else if (device->machineData.useIR == 6 || device->machineData.useIR == 9){
                    [cell.irCameraLabel1 setHidden:NO];
                    [cell.irCameraLabel2 setHidden:NO];
                    [cell.ir1CameraTextField setHidden:NO];
                    [cell.ir2CameraTextField setHidden:NO];
                    [cell.rearIR2TextField setHidden:NO];
                    [cell.rearIR1TextField setHidden:NO];
                }
                return cell;
            }else{
                MainLightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MainLightTableViewCellIdentify];
                cell.indexPath = indexPath;
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.frontMainLightTextField.text = [NSString stringWithFormat:@"%d",device->lightSetting.MainLight[0]];
                cell.rearMainLightTextField.text = [NSString stringWithFormat:@"%d",device->lightSetting.MainLight[1]];
                [cell.frontMainLightTitleLabel setText:kLanguageForKey(75)];
                [cell.rearMainLightTitleLabel setText:kLanguageForKey(76)];
                
                [cell.mainLightLabel setText:kLanguageForKey(102)];
                return cell;
            }
            
        }
    }else if (indexPath.section == 3){
        if(indexPath.row == 0){
            IRMainLightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IRMainLightTableViewCellIdentify forIndexPath:indexPath];
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (device->machineData.useIR<7) {
                cell.mainIRLightLabel.text = kLanguageForKey(1003);
            }else{
                cell.mainIRLightLabel.text = kLanguageForKey(1004);
            }
            cell.frontIRLightTitleLabel.text = kLanguageForKey(75);
            cell.rearIRLightTitleLabel.text = kLanguageForKey(76);
            if(device->lightSetting.ir[0])
            {
                [cell.frontIRSwitch setOn:YES];
            }else{
                [cell.frontIRSwitch setOn:NO];
            }
            if (device->lightSetting.ir[1]) {
                [cell.rearIRSwitch setOn:YES];
            }else{
                [cell.rearIRSwitch setOn:NO];
            }
            return cell;
        }
    }
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}

- (IBAction)segmentedControlChanged:(UISegmentedControl *)sender {
    if (sender.tag == 100) {
        _signalType = _signalTypeSegmentedControl.selectedSegmentIndex;
        [self requestData];
    }
}


#pragma mark tableviewcellChangedDelegate
-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value{
    Device *device = kDataModel.currentDevice;
    if (section == 0) {
        device.currentSorterIndex = value;
        [self requestData];
    }else if (section == 1){
        if (_signalType == 0) {
            if (index<4) {
                device.currentViewIndex = 0;
                [[NetworkFactory sharedNetWork] setLightWithType:(Byte)index AndValue:value];
            }else if (index>10 &&index<14) {
                device.currentViewIndex = 1;
                [[NetworkFactory sharedNetWork] setLightWithType:(Byte)index-10 AndValue:value];
            }
        }else{
            if (index == 0) {
                device.currentCameraGain = value;
                _gainType = value;
                [[NetworkFactory sharedNetWork] switchCameraGainWithGainType:value];
            }else if (index == 1){
                self.ajustType = value;
            }
        }
    }else if (section == 2){
        if (_signalType == 0) {
            if (index == 6 ||index == 7) {
                if (index == 6) {
                    device.currentViewIndex = 0;
                }else{
                    device.currentViewIndex = 1;
                }
                [[NetworkFactory sharedNetWork] setLightWithType:4 AndValue:value];
            }
            
        }else{
            if (index <6) {
                device.currentViewIndex = 0;
                [[NetworkFactory sharedNetWork] setCameraGainWithAjustTypeAll:_ajustType Type:index GainType:_gainType Value:value];
            }else if (index>10 &&index<16){
                device.currentViewIndex = 1;
                [[NetworkFactory sharedNetWork] setCameraGainWithAjustTypeAll:_ajustType Type:index-10 GainType:_gainType Value:value];
            }
        }
    }
    else if (section == 3){
        if (index == 200 || index == 201) {
            if (index == 200) {
                device.currentViewIndex = 0;
            }else{
                device.currentViewIndex = 1;
            }
            if (_signalType == 0) {
                if (device->machineData.useIR>0) {//红外主灯 or 分时led灯  前视
                    if (value) {
                        [[NetworkFactory sharedNetWork] setLightWithType:LightType_IR AndValue:1];
                    }else{
                        [[NetworkFactory sharedNetWork]setLightWithType:LightType_IR AndValue:0];
                    }
                }
            }
        }
        
    }
    [[NetworkFactory sharedNetWork] changeLayerAndView];
}

#pragma mark -baseviewcontroller

- (void)networkError:error{
    [self.timer invalidate];
    [super networkError:error];
}
-(void)socketSendError{
    [self.timer invalidate];
    [super socketSendError];
}

#pragma mark -切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [self requestData];
}

- (void)requestData{
    if (_signalType == 0) {
        [[NetworkFactory sharedNetWork] getLight];
    }else
        [[NetworkFactory sharedNetWork] getCameraGain];
}

@end
