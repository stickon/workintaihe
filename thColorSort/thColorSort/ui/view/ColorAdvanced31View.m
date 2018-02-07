//
//  ColorAdvanced31View.m
//  ThColorSortNew
//
//  Created by taihe on 2017/12/28.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "ColorAdvanced31View.h"
#import "ColorTypeSenseAndReverseTitleTableViewCell.h"
#import "ColorTypeSenseAndReverseTableViewCell.h"
#import "TableViewCellWithDefaultTitleLabel1TextField.h"
#import "RiceSharpenTableViewCell.h"
#import "SetSenseSizeTableViewCell.h"
#import "LGJFoldHeaderView.h"
#import "WaveDataTableViewCell.h"
#import "tableViewCellValueChangedDelegate.h"
#import "TableViewCellWith2Button.h"
#import "TableViewCellWith2RadioButton.h"
static NSString *CellIdentifier = @"WaveDataTableViewCell";
static NSString *buttonCellIdentifier = @"TableViewCellWith2Button";
@interface ColorAdvanced31View()<UITableViewDataSource,UITableViewDelegate,TableViewCellChangedDelegate,FoldSectionHeaderViewDelegate>
{
    BOOL dataLoaded;
    Byte waveType;
    Byte currentSelectFrtsnd;//整体调整选中的一次还是二次 0:一次 2:二次
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSTimer *timer;
@property(nonatomic, strong) NSDictionary* foldInfoDic;/**< 存储开关字典 */
@property (strong, nonatomic) IBOutlet UILabel *useLabel;
@property (strong, nonatomic) IBOutlet UISwitch *UseSwitch;
@end
@implementation ColorAdvanced31View


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
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"ColorAdvanced31View" owner:self options:nil] firstObject];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        waveType = wave_rgb;
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
    currentSelectFrtsnd = 0;
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
            static NSString *cellIdentifier = @"ColorTypeSenseAndReverseTitleTableViewCell";
            ColorTypeSenseAndReverseTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil]lastObject];
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.chuteTitle.text = kLanguageForKey(41) ;
            cell.chuteTitle.textColor = [UIColor TaiheColor];
            cell.chuteTitle.font = SYSTEMFONT_14f;
            cell.sortTimes1.text = kLanguageForKey(180);
            cell.sortTimes1.font = SYSTEMFONT_14f;
            cell.sortTimes1.tag = 0;
            cell.sortTimes2.tag = 1;
            cell.sortTimes2.text = kLanguageForKey(181);
            cell.sortTimes2.font = SYSTEMFONT_14f;
            if (currentSelectFrtsnd == 0) {
                cell.sortTimes1.font = [UIFont systemFontOfSize:17.0f];
                cell.sortTimes1.textColor = [UIColor redColor];
            }else{
                cell.sortTimes2.font = [UIFont systemFontOfSize:17.0f];
                cell.sortTimes2.textColor = [UIColor redColor];
            }
            if (device->reverse == 1) {
                cell.mirrorTitle.hidden = NO;
                cell.mirrorTitle.text = kLanguageForKey(386);
            }else{
                cell.mirrorTitle.hidden = YES;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row<device->machineData.chuteNumber+1){
            static NSString *cellIdentifier = @"ColorTypeSenseAndReverseTableViewCell";
            ColorTypeSenseAndReverseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil]lastObject];
            }
            cell.chuteNum.text = [NSString stringWithFormat:@"%d", (int)indexPath.row];
            cell.chuteNum.font = SYSTEMFONT_14f;
            cell.chuteNum.textColor = [UIColor TaiheColor];
            if (device->data3[indexPath.row-1]  == 1) {
                cell.chuteSenseTimes1Value.text = [NSString stringWithFormat:@"%d",device->data1[indexPath.row-1]];
                [cell.chuteSenseTimes2Value setEnabled:false];
                cell.chuteSenseTimes2Value.text = @"0";
            }else if (device->data3[indexPath.row-1] == 2){
                cell.chuteSenseTimes1Value.text = @"0";
                [cell.chuteSenseTimes1Value setEnabled:false];
                cell.chuteSenseTimes2Value.text = [NSString stringWithFormat:@"%d",device->data2[indexPath.row-1]];
            }else if (device->data3[indexPath.row-1] == 3){
                cell.chuteSenseTimes1Value.text = [NSString stringWithFormat:@"%d",device->data1[indexPath.row-1]];
                cell.chuteSenseTimes2Value.text = [NSString stringWithFormat:@"%d",device->data2[indexPath.row-1]];
            }
            if (device->reverse == 1) {
                cell.reverseSwitch.hidden = NO;
                if (device->data4[indexPath.row-1] == 1) {
                    [cell.reverseSwitch setOn:YES];
                }else{
                    [cell.reverseSwitch setOn:NO];
                }
                if (device->machineData.startState) {
                    cell.reverseSwitch.userInteractionEnabled = NO;
                }else{
                    cell.reverseSwitch.userInteractionEnabled = YES;
                }
            }else{
                cell.reverseSwitch.hidden = YES;
            }
            
            cell.chuteSenseTimes1Value.tag = 0;
            cell.chuteSenseTimes2Value.tag = 1;
            cell.reverseSwitch.tag = 11;
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
            cell.sizeTitleLabel.text = kLanguageForKey(40);
            cell.LengthLabel.text = kLanguageForKey(37);
            cell.widthLabel.text = kLanguageForKey(38);
            cell.sizeLabel.text = kLanguageForKey(39);
            
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
            currentSelectFrtsnd = value;
            [self.tableView reloadData];
        }else if (row == device->machineData.chuteNumber+1)//整体料槽调整
        {
            [[NetworkFactory sharedNetWork]sendAlgorithmSenseValueWithAjustType:index Sorter:row data:value algorithmType:_type FirstSecond:currentSelectFrtsnd ValueType:1 IsIR:0];
        }else{
            if (index == 11) {
                [gNetwork setReverseSharpenWithAlgorithmType:self.type Type:index Chute:row Value:value];
            }else
                [[NetworkFactory sharedNetWork]sendAlgorithmSenseValueWithAjustType:0 Sorter:row data:value algorithmType:_type FirstSecond:index ValueType:1 IsIR:0];
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
            
            
        }
        if(row == 2){
            if (index <4) {
                [[NetworkFactory sharedNetWork]sendToChangeSizeWithAlgorithmType:_type Type:index AndValue:value IsIR:0];
            }else if (index == 5){
                device->sense.fSameR = value;
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
                    [[NetworkFactory sharedNetWork]sendAlgorithmSenseValueWithAjustType:1 Sorter:row data:value algorithmType:_type FirstSecond:currentSelectFrtsnd ValueType:1 IsIR:0];
                }else{
                    for (int i =0; i<device->machineData.chuteNumber; i++) {
                        if (currentSelectFrtsnd == 0) {
                            
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
                    [[NetworkFactory sharedNetWork]sendAlgorithmSenseValueWithAjustType:2 Sorter:row data:value algorithmType:_type FirstSecond:currentSelectFrtsnd ValueType:1 IsIR:0];
                }else{
                    for (int i =0; i<device->machineData.chuteNumber; i++) {
                        if (currentSelectFrtsnd == 0) {
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
-(void)dealloc{
    NSLog(@"sense view dealloc");
}

@end
