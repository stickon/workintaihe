//
//  RestrainAdvancedView.m
//  thColorSort
//
//  Created by taihe on 2018/1/13.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "RestrainAdvancedView.h"
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

@interface RestrainAdvancedView()<UITableViewDataSource,UITableViewDelegate,TableViewCellChangedDelegate,FoldSectionHeaderViewDelegate>
{
    BOOL dataLoaded;
    Byte waveType;
    Byte currentSelectFrtsnd;//整体调整选中的一次还是二次 0:一次 2:二次
    Byte currentSelectColordiffType;//1:灵敏度，2：色差上限 3：色差下限
}


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSTimer *timer;
@property(nonatomic, strong) NSDictionary* foldInfoDic;/**< 存储开关字典 */
@property (strong, nonatomic) IBOutlet UILabel *useLabel;
@property (strong, nonatomic) IBOutlet UISwitch *UseSwitch;
@end

@implementation RestrainAdvancedView

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
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"RestrainAreaAdvancedView" owner:self options:nil] firstObject];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        waveType = wave_rgb_restrain;
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
        [self.tableView registerNib:[UINib nibWithNibName:cellIdentifier2RadioBtn bundle:nil] forCellReuseIdentifier:cellIdentifier2RadioBtn];
        [self.tableView registerNib:[UINib nibWithNibName:irCellIdentifier bundle:nil] forCellReuseIdentifier:irCellIdentifier];
        [self refreshCurrentView];
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
    currentSelectFrtsnd = 0;
    currentSelectColordiffType = 1;
}

-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x04 && (header[1]== 0x03||header[1] == 0x13)) {
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
    if (header[0] == 0x04 && header[1] == 0x06) {
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
            if (waveType == 1 || waveType == 2) {
                return 2;
            }else
                return 1;
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
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 165;
        }else{
            return 50;
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
            static NSString *irTitleCellIdentifier = @"TableViewCellWithDefaultLabelAnd1UIImageView";
            TableViewCellWithDefaultLabelAnd1UIImageView *cell = [tableView dequeueReusableCellWithIdentifier:irTitleCellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:irTitleCellIdentifier owner:self options:nil]lastObject];
            }
            cell.textLabel.text = kLanguageForKey(41) ;
            cell.textLabel.font = SYSTEMFONT_14f;
            cell.textLabel.textColor = [UIColor TaiheColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row<device->machineData.chuteNumber+1){
            TableViewCellWithDefaultTitleLabel1TextField *cell = [tableView dequeueReusableCellWithIdentifier:irCellIdentifier forIndexPath:indexPath];
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.textLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.row];
            cell.textLabel.font = SYSTEMFONT_14f;
            cell.textLabel.textColor = [UIColor TaiheColor];
            cell.textField.tag = 1;
            cell.cellType = TableViewCellType_SenseType;
            cell.textField.text = [NSString stringWithFormat:@"%d",device->data1[indexPath.row-1]];
            
            NSInteger data = (device->data1[indexPath.row-1])+(device->data2[indexPath.row-1])*256;
            NSLog(@"%ld",(long)data);
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
        if (indexPath.row == 0) {//设置杂质大小
            //亮度区域
            static NSString *cellIdentifier = @"SetSenseSizeLightAreaTableViewCell";
            SetSenseSizeLightAreaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil]lastObject];
            }
            cell.setSizeTitleLabel.text = kLanguageForKey(266) ;
            cell.lightThresholdTitleLabel.text = kLanguageForKey(267) ;
            cell.minSizeTitleLabel.text = kLanguageForKey(228) ;
            cell.areaChooseTitleLabel.text = kLanguageForKey(268) ;
            
            cell.lightThresholdTextField.text = [NSString stringWithFormat:@"%d",device->sense.size[0]*256+device->sense.size[1]];
            cell.minSizeTextField.text=[NSString stringWithFormat:@"%d", device->sense.height];
            cell.areaChooseTextField.text = [NSString stringWithFormat:@"%d", device->sense.width];
            if (device->lightAreaLimit) {
                cell.limitBtn.selected = YES;
                cell.limitBtn.backgroundColor = [UIColor greenColor];
                [cell.limitBtn setTitle:kLanguageForKey(270) forState:UIControlStateSelected];
            }else{
                cell.limitBtn.selected = NO;
                cell.limitBtn.backgroundColor = [UIColor TaiheColor];
                [cell.limitBtn setTitle:kLanguageForKey(269) forState:UIControlStateNormal];
            }
            
            if (device->lightAreaBorderUse) {
                cell.borderUseBtn.selected = YES;
                cell.borderUseBtn.backgroundColor = [UIColor greenColor];
                [cell.borderUseBtn setTitle:kLanguageForKey(271) forState:UIControlStateSelected];
            }else{
                cell.borderUseBtn.selected = NO;
                cell.borderUseBtn.backgroundColor = [UIColor TaiheColor];
                [cell.borderUseBtn setTitle:kLanguageForKey(272) forState:UIControlStateNormal];
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1){//切换色差的亮度和颜色
            TableViewCellWith2RadioButton *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2RadioBtn forIndexPath:indexPath];
            
            cell.colorRadioBtn.selected = false;
            cell.lightRadioBtn.selected = true;
            cell.colorRadioBtn.userInteractionEnabled = true;
            cell.lightRadioBtn.userInteractionEnabled = false;
            
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
            if (index == 1) {
                [[NetworkFactory sharedNetWork]sendAlgorithmSenseValueWithAjustType:1 Sorter:row data:value algorithmType:_type FirstSecond:currentSelectFrtsnd ValueType:1 IsIR:0];
            }
            if (index == 2) {
                [[NetworkFactory sharedNetWork]sendAlgorithmSenseValueWithAjustType:2 Sorter:row data:value algorithmType:_type FirstSecond:currentSelectFrtsnd ValueType:1 IsIR:0];
            }
            
        }else{
            [[NetworkFactory sharedNetWork]sendAlgorithmSenseValueWithAjustType:0 Sorter:row data:value algorithmType:_type FirstSecond:index ValueType:1 IsIR:0];
            
        }
        
    }else if (section == 1) {
        if(row == 0){
            if (index <4) {
                [[NetworkFactory sharedNetWork]sendToChangeSizeWithAlgorithmType:_type Type:index AndValue:value IsIR:0];
            }else if(index == 4){//亮度区域中 高级 设置杂质大小 上限 下限
                [[NetworkFactory sharedNetWork] sendToChangeLightAreaSizeLimitOrBorderUseWithType:1];
            }else if (index == 5){//亮度区域中 高级 设置杂质大小 边缘使能
                [[NetworkFactory sharedNetWork] sendToChangeLightAreaSizeLimitOrBorderUseWithType:2];
            }
        }else if(row == 1){
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

@end
