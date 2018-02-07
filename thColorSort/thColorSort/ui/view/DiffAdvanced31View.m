//
//  DiffAdvanced31View.m
//  thColorSort
//
//  Created by taihe on 2018/1/12.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "DiffAdvanced31View.h"
#import "ColorDiffTypeAndReverseTitleTableViewCell.h"
#import "ColorDiffTypeAndReverseTableViewCell.h"
#import "TableViewCellWithDefaultTitleLabel1TextField.h"
#import "RiceSharpenTableViewCell.h"
#import "SetSenseSizeTableViewCell.h"
#import "LGJFoldHeaderView.h"
#import "WaveDataTableViewCell.h"
#import "tableViewCellValueChangedDelegate.h"
#import "TableViewCellWith2Button.h"
#import "TableViewCellWith2RadioButton.h"
#import "TableViewCellWithDefaultTitleLabel1TextField.h"
#import "TableViewCellWithDefaultLabelAnd1UIImageView.h"
#import "SetSenseSizeLightAreaTableViewCell.h"
static NSString *CellIdentifier = @"WaveDataTableViewCell";
static NSString *buttonCellIdentifier = @"TableViewCellWith2Button";
static NSString *cellIdentifier2RadioBtn = @"TableViewCellWith2RadioButton";
static NSString *irCellIdentifier = @"TableViewCellWithDefaultTitleLabel1TextField";
@interface DiffAdvanced31View()<UITableViewDataSource,UITableViewDelegate,TableViewCellChangedDelegate,FoldSectionHeaderViewDelegate>
{
    BOOL dataLoaded;
    Byte waveType;
    Byte currentSelectColordiffType;//1:灵敏度，2：色差上限 3：色差下限
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSTimer *timer;
@property(nonatomic, strong) NSDictionary* foldInfoDic;/**< 存储开关字典 */
@property (strong, nonatomic) IBOutlet UILabel *useLabel;
@property (strong, nonatomic) IBOutlet UISwitch *UseSwitch;

@end
@implementation DiffAdvanced31View


- (IBAction)useSwitchValueChanged:(UISwitch *)sender {
    [[NetworkFactory sharedNetWork]sendToChangeUseStateWithAlgorithm:_type IsIR:0];
    if (sender.isOn) {
        [self.useLabel setText:kLanguageForKey(35)];
    }else{
        [self.useLabel setText:kLanguageForKey(36)];
    }
}


-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"DiffAdvanced31View" owner:self options:nil] firstObject];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        waveType = wave_diff;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.bounces = NO;
        dataLoaded = false;
        _foldInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                       @"0":@"0",
                                                                       @"1":@"0",
                                                                       @"2":@"0",
                                                                       }];
        
        [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:buttonCellIdentifier bundle:nil] forCellReuseIdentifier:buttonCellIdentifier];
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return self;
}
-(UIView*)getViewWithPara:(NSDictionary *)para{
    if (para) {
        Device *device = kDataModel.currentDevice;
        NSString *index = [para valueForKey:@"algorithmIndex"];
        self.algorithmIndex = index.intValue;
        self.type = (*(device->colorAlgorithm+self.algorithmIndex)).type;
    }
    [self refreshCurrentView];
    return self;
}
-(void)refreshCurrentView{
    [[NetworkFactory sharedNetWork]sendToGetSenseAdvancedData:self.type IsIR:0];
    [gNetwork getReverseSharpenWithAlgorithmType:self.type];
    currentSelectColordiffType = 1;
}

-(void)updateWithHeader:(NSData *)headerData
{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x04 && (header[1]== 0x07||header[1] == 0x13)) {
        dataLoaded = true;
        if ((*(kDataModel.currentDevice->colorAlgorithm+(int)_algorithmIndex)).used == 1)
        {
            [self.UseSwitch setOn:YES];
            [self.useLabel setText:kLanguageForKey(35)];
        }
        else
        {
            [self.UseSwitch setOn:NO];
            [self.useLabel setText:kLanguageForKey(36)];
        }
        [self.tableView reloadData];
    }
    if (header[0] == 0x04 && (header[1] == 0x02||header[1] == 0x12)) {
        [[NetworkFactory sharedNetWork]sendToGetSenseAdvancedData:self.type IsIR:0];
    }
    if (header[0] == 0x04 && (header[1] == 0x08 || header[1] == 0x03)) {
        [self.tableView reloadData];
    }
    if (header[0] == 0x05) {
        if (_timer.isValid) {
            Device *device = kDataModel.currentDevice;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:2];
            WaveDataTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            for (int i = 0; i<device->waveDataCount; i++) {
                [cell bindWaveData:device->waveData[i] withIndex:i];
            }
            [cell bindWaveColorType:(Byte*)(&(device->waveType)) andColorDiffLightType:waveType andAlgriothmType:_type];
            
        }
    }else if (header[0] == 0x55) {
        if (_timer.isValid) {
            [_timer invalidate];
        }
        [super updateWithHeader:headerData];
    }else if (header[0]  == 0xb0){
        [self refreshCurrentView];
    }
}

-(BOOL)Back
{
    if (_timer.valid) {
        [_timer invalidate];
    }
    return [super Back];
}

-(void)networkError:(NSError *)error{
    if (_timer.valid) {
        [_timer invalidate];
    }
    [super networkError:error];
}
#pragma tableview data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataLoaded) {
        return 3;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [NSString stringWithFormat:@"%d", (int)section];
    BOOL folded = [[_foldInfoDic objectForKey:key] boolValue];
    if (dataLoaded) {
        Device *device = kDataModel.currentDevice;
        if (section == 0) {
            return device->machineData.chuteNumber+2;
        }
        if (section == 1) {
            return 3;
        }
        if (section == 2) {
            return folded?1:0;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 40;
    }
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
    }
    
    if (section == 0) {
        [headerView setHidden:NO];
    } else if (section == 1) {
        [headerView setHidden:NO];
    } else if (section == 2){
        LGJFoldHeaderView *lgheaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LGheader"];
        if (!lgheaderView) {
            lgheaderView = [[LGJFoldHeaderView alloc]initWithReuseIdentifier:@"LGheader"];
        }
        [lgheaderView setFoldSectionHeaderViewWithTitle:kLanguageForKey(42)  detail:@"" type:HerderStyleTotal section:2 canFold:YES];
        lgheaderView.delegate = self;
        NSString *key = [NSString stringWithFormat:@"%d", (int)section];
        BOOL folded = [[_foldInfoDic valueForKey:key] boolValue];
        lgheaderView.fold = folded;
        return lgheaderView;
    }
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Device *device = kDataModel.currentDevice;
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (device->reverse) {
                return 50;
            }else{
                return 0;
            }
        }
        if (indexPath.row == 1) {
            if (device->sharpen) {
                return 50;
            }else{
                return 0;
            }
        }
        if (indexPath.row == 2) {
            return 165;
        }
    }
    if (indexPath.section == 2) {
        CGFloat width =[UIScreen mainScreen].bounds.size.width-40;
        CGFloat height = (width-40)*0.618+60;
        return height;
    }
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Device *device = kDataModel.currentDevice;
    if (indexPath.section ==0) {
        if (indexPath.row ==0) {
            static NSString* cellIdentifier = @"ColorDiffTypeAndReverseTitleTableViewCell";
            ColorDiffTypeAndReverseTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil]lastObject];
            }
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.chuteTitle.text = kLanguageForKey(41) ;
            cell.chuteTitle.font = SYSTEMFONT_14f;
            cell.chuteTitle.textColor = [UIColor TaiheColor];
            cell.senseValueTitle.text = kLanguageForKey(14);
            cell.senseLightUpperLimitValue.text = kLanguageForKey(1010) ;
            cell.senseLightLowerLimitValue.text = kLanguageForKey(1011) ;
            cell.senseValueTitle.tag = 1;
            cell.senseLightUpperLimitValue.tag = 2;
            cell.senseLightLowerLimitValue.tag = 3;
            if (currentSelectColordiffType == 1) {
                cell.senseValueTitle.font = [UIFont systemFontOfSize:16.0f];
                cell.senseValueTitle.textColor = [UIColor redColor];
            }else if (currentSelectColordiffType == 2){
                cell.senseLightUpperLimitValue.font = [UIFont systemFontOfSize:16.0f];
                cell.senseLightUpperLimitValue.textColor = [UIColor redColor];
            }else{
                cell.senseLightLowerLimitValue.font = [UIFont systemFontOfSize:16.0f];
                cell.senseLightLowerLimitValue.textColor = [UIColor redColor];
            }
            if (device->reverse == 1) {
                cell.reverseTitle.hidden = NO;
                cell.reverseTitle.text = kLanguageForKey(386);
            }else{
                cell.reverseTitle.hidden = YES;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row<device->machineData.chuteNumber+1){
            static NSString *cellIndentifier = @"ColorDiffTypeAndReverseTableViewCell";
            ColorDiffTypeAndReverseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellIndentifier owner:self options:nil]lastObject];
            }
            cell.colorSenseChuteNumLabel.text = [NSString stringWithFormat:@"%d",(int)indexPath.row];
            cell.colorSenseChuteNumLabel.font = SYSTEMFONT_14f;
            cell.colorSenseChuteNumLabel.textColor = [UIColor TaiheColor];
            cell.colorSenseValueTextField.text = [NSString stringWithFormat:@"%d",device->data1[indexPath.row-1]];
            cell.colorSenseValueTextField.font = SYSTEMFONT_14f;
            cell.colorSenseLightUpperLimitValueTextField.text = [NSString stringWithFormat:@"%d",device->data2[indexPath.row-1]];
            cell.colorSenseLightUpperLimitValueTextField.font = SYSTEMFONT_14f;
            cell.colorSenseLightLowerLimitValueTextField.text = [NSString stringWithFormat:@"%d",device->data3[indexPath.row-1]];
            cell.colorSenseLightLowerLimitValueTextField.font = SYSTEMFONT_14f;
            if (device->reverse == 1) {
                cell.reverseUseSwitch.hidden = NO;
                if (device->data4[indexPath.row-1] == 1) {
                    [cell.reverseUseSwitch setOn:YES];
                }else{
                    [cell.reverseUseSwitch setOn:NO];
                }
                if (device->machineData.startState) {
                    cell.reverseUseSwitch.userInteractionEnabled = NO;
                }else{
                    cell.reverseUseSwitch.userInteractionEnabled = YES;
                }
            }else{
                cell.reverseUseSwitch.hidden = YES;
            }
            
            cell.reverseUseSwitch.tag = 11;
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == device->machineData.chuteNumber+1){
            TableViewCellWith2Button *cell = [tableView dequeueReusableCellWithIdentifier:buttonCellIdentifier forIndexPath:indexPath];
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            static NSString *cellIdentifier = @"TableViewCellWithDefaultTitleLabel1TextField";
            TableViewCellWithDefaultTitleLabel1TextField *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil]lastObject];
            }
            cell.cellType = TableViewCellType_RiceMirror;
            if (device->reverse) {
                if ([device bHaveChuteUseReverse]) {
                    cell.textField.userInteractionEnabled = YES;
                    cell.textField.text = [NSString stringWithFormat:@"%d",device->riceSense.repair];
                }else{
                    cell.textField.userInteractionEnabled = NO;
                    cell.textField.text = @"0";
                    device->riceSense.repair = 0;
                }
                cell.hidden = NO;
                cell.textLabel.text = kLanguageForKey(388);
                cell.textLabel.font = SYSTEMFONT_14f;
            }else{
                cell.hidden = YES;
                cell.frame = CGRectZero;
            }
            cell.textField.tag = 12;
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row == 1) {
            static NSString *cellIdentifier = @"RiceSharpenTableViewCell";
            RiceSharpenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] lastObject];
            }
            cell.SharpenParaTitleLabel.text  = kLanguageForKey(391);
            cell.SharpenUseTitleLabel.text = kLanguageForKey(389);
            cell.SharpenUseTitleLabel.font = SYSTEMFONT_14f;
            cell.SharpenParaTitleLabel.font = SYSTEMFONT_14f;
            if (device->sharpen) {
                cell.hidden = NO;
                if (device->riceSense.sharpenUse) {
                    [cell.SharpenUseSwitch setOn:YES];
                    cell.SharpenParaTextField.text = [NSString stringWithFormat:@"%d",device->riceSense.sharpenValue];
                    cell.SharpenParaTextField.userInteractionEnabled = YES;
                }else{
                    [cell.SharpenUseSwitch setOn:NO];
                    cell.SharpenParaTextField.text = @"0";
                    cell.SharpenParaTextField.userInteractionEnabled = NO;
                }
            }else{
                cell.hidden = YES;
                cell.frame = CGRectZero;
            }
            cell.SharpenParaTextField.tag = 13;
            cell.SharpenUseSwitch.tag = 14;
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row == 2) {//设置杂质大小
            static NSString *cellIdentifier = @"SetSenseSizeTableViewCell";
            SetSenseSizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil]lastObject];
            }
            cell.sizeTitleLabel.text = kLanguageForKey(40) ;
            cell.LengthLabel.text = kLanguageForKey(37) ;
            cell.widthLabel.text = kLanguageForKey(38) ;
            cell.sizeLabel.text = kLanguageForKey(39) ;
            
            
            cell.irDiffSpotLabel.hidden = YES;
            cell.irDiffTitleLabel.hidden = YES;
            cell.irDiffTextField.hidden = YES;
            cell.lengthTextField.text=[NSString stringWithFormat:@"%d", device->sense.width];
            cell.widthTextField.text = [NSString stringWithFormat:@"%d",device->sense.height];
            cell.sizeTextField.text = [NSString stringWithFormat:@"%d",device->sense.size[0]*256+device->sense.size[1]];
            
            cell.delegate = self;
            cell.indexPath = indexPath;
            
            if (device->machineData.hasRearView[device.currentLayerIndex-1]) {
                cell.frontRearViewSameLabel.hidden = NO;
                cell.frontRearViewSameSwitch.hidden = NO;
            }else{
                cell.frontRearViewSameLabel.hidden = YES;
                cell.frontRearViewSameSwitch.hidden = YES;
            }
            cell.frontRearViewSameLabel.text = kLanguageForKey(43) ;
            if (device->sense.fSameR) {
                cell.frontRearViewSameSwitch.on = YES;
            }
            else{
                cell.frontRearViewSameSwitch.on = NO;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row == 3){//切换色差的亮度和颜色
            TableViewCellWith2RadioButton *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2RadioBtn forIndexPath:indexPath];
            if (waveType == wave_diff) {
                cell.colorRadioBtn.selected = true;
                cell.lightRadioBtn.selected = false;
                cell.colorRadioBtn.userInteractionEnabled = false;
                cell.lightRadioBtn.userInteractionEnabled = true;
            }else if(waveType == wave_light){
                cell.colorRadioBtn.selected = false;
                cell.lightRadioBtn.selected = true;
                cell.colorRadioBtn.userInteractionEnabled = true;
                cell.lightRadioBtn.userInteractionEnabled = false;
            }
            
            
            NSString *redThanGreen = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(47),kLanguageForKey(49)];
            NSString *redThanBlue = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(47),kLanguageForKey(48)];
            NSString *greenThanRed = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(49),kLanguageForKey(47)];
            NSString *greenThanBlue = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(49),kLanguageForKey(48)];
            NSString *blueThanRed = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(48),kLanguageForKey(47)];
            NSString *blueThanGreen = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(48),kLanguageForKey(49)];
            NSArray *stringItemsArray = @[redThanGreen,redThanBlue,greenThanRed,greenThanBlue,blueThanRed,blueThanGreen];
            cell.colorTitleLabel.text = [stringItemsArray objectAtIndex:device->sense.color];
            cell.colorTitleLabel.font = SYSTEMFONT_14f;
            cell.lightTitleLabel.text = kLanguageForKey(45) ;
            cell.lightTitleLabel.font = SYSTEMFONT_14f;
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            WaveDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.chuteTitleLabel.text = kLanguageForKey(41) ;
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.chuteNumCount = device->machineData.chuteNumber;
            for (int i = 0; i<device->waveDataCount; i++) {
                [cell bindWaveData:device->waveData[i] withIndex:i];
            }
            [cell bindWaveColorType:(Byte*)(&(device->waveType)) andColorDiffLightType:waveType andAlgriothmType:_type];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    UITableViewCell *defaultCell = [[UITableViewCell alloc]init];
    return defaultCell;
}
#pragma table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma foldHeaderSectionDelegate

- (void)foldHeaderInSection:(NSInteger)SectionHeader
{
    NSString *key = [NSString stringWithFormat:@"%d",(int)SectionHeader];
    BOOL folded = [[_foldInfoDic objectForKey:key] boolValue];
    NSString *fold = folded ? @"0" : @"1";
    [_foldInfoDic setValue:fold forKey:key];
    if (!folded) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeout) userInfo:nil repeats:YES];
    }
    else
    {
        [_timer invalidate];
    }
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndex:SectionHeader];
    [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    if (!folded) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:2];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)timeout
{
    [[NetworkFactory sharedNetWork]sendToGetWaveDataWithAlgorithmType:_type AndWaveType:waveType AndDataType:0 Position:0];
}

#pragma tableview cell delegate
-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value
{
    Device *device = kDataModel.currentDevice;
    if (section == 0)
    {
        if (row == 0) {
            currentSelectColordiffType = value;
            [self.tableView reloadData];
        }else if (row == device->machineData.chuteNumber+1)//整体料槽调整
        {
            [[NetworkFactory sharedNetWork]sendAlgorithmSenseValueWithAjustType:index Sorter:row data:value algorithmType:_type FirstSecond:currentSelectColordiffType ValueType:currentSelectColordiffType IsIR:0];
        }else{
            if (index == 11) {
                [gNetwork setReverseSharpenWithAlgorithmType:self.type Type:index Chute:row Value:value];
            }else
                [[NetworkFactory sharedNetWork]sendAlgorithmSenseValueWithAjustType:0 Sorter:row data:value algorithmType:_type FirstSecond:index ValueType:currentSelectColordiffType IsIR:0];
        }
    }else if (section == 1) {
        if (row == 0 || row == 1) {
            [gNetwork setReverseSharpenWithAlgorithmType:self.type Type:index Chute:1 Value:value];
            if (row == 1) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:1];
                RiceSharpenTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                if (value == 0) {
                    cell.SharpenParaTextField.text = @"0";
                    cell.userInteractionEnabled = NO;
                }else{
                    cell.userInteractionEnabled = YES;
                }
            }
        }else if(row == 2){
            if(index == 5){
                device->sense.fSameR = value;
            }else{
                
                [[NetworkFactory sharedNetWork]sendToChangeSizeWithAlgorithmType:_type Type:index AndValue:value IsIR:0];
                
            }
        }else if(row == 3){
            if (value == 1) {
                waveType = wave_diff;
            }
            if (value == 2) {
                waveType = wave_light;
            }
        }
    }else if (section == 2){
        device.currentSorterIndex = value;
    }
}


-(void)cellBtnClicked:(long)section row:(long)row tag:(long)tag value:(NSInteger)value bSend:(BOOL)bsend{
    Device *device = kDataModel.currentDevice;
    if (section == 0)
    {
        if (row == device->machineData.chuteNumber+1)//整体料槽调整
        {
            if (tag == 1) {
                if (bsend) {
                    [[NetworkFactory sharedNetWork]sendAlgorithmSenseValueWithAjustType:1 Sorter:row data:value algorithmType:_type FirstSecond:currentSelectColordiffType ValueType:1 IsIR:0];
                }else{
                    for (int i =0; i<device->machineData.chuteNumber; i++) {
                        if (currentSelectColordiffType == 0) {
                            
                            if (device->data1[i] <99) {
                                device->data1[i] +=1;
                            }
                        }
                        else{
                            if (device->data2[i] <99) {
                                device->data2[i] +=1;
                            }
                        }
                    }
                    [self reloadRows];
                }
            }
            if (tag == 2) {
                if (bsend) {
                    [[NetworkFactory sharedNetWork]sendAlgorithmSenseValueWithAjustType:2 Sorter:row data:value algorithmType:_type FirstSecond:currentSelectColordiffType ValueType:1 IsIR:0];
                }else{
                    for (int i =0; i<device->machineData.chuteNumber; i++) {
                        if (currentSelectColordiffType == 0) {
                            if (device->data1[i] <=1) {
                                device->data1[i] = 0;
                            }else{
                                device->data1[i] -=1;
                            }
                        }
                        else{
                            if (device->data2[i] <=1) {
                                device->data2[i] = 0;
                            }else{
                                device->data2[i] -=1;
                            }
                        }
                    }
                    [self reloadRows];
                }
            }
        }
    }
}

-(void)reloadRows{
    Device *device = kDataModel.currentDevice;
    NSArray *rowArray =[NSArray array];
    for (int i= 1; i<=device->machineData.chuteNumber;i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        rowArray  = [rowArray arrayByAddingObject:indexPath];
    }
    [self.tableView reloadRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationNone];
}

@end
