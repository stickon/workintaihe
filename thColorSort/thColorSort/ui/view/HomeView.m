//
//  HomeView.m
//  ThColorSortNew
//
//  Created by taihe on 2017/12/19.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "HomeView.h"
#import "DataModel.h"
#import "BaseUITextField.h"
#import "TableViewCellWithDefaultTitleLabel1Switch.h"
#import "TableViewCellWithDefaultTitleLabel1TextField.h"
#import "TableViewCellWith1button.h"
static NSString* switchCellName = @"TableViewCellWithDefaultTitleLabel1Switch";
static NSString* valveCellIdentifier = @"valveCellIdentifier";
static NSString* commonCellIdentifier = @"commonCellIdentifier";
static NSString* feedSettingCellIdentifier = @"TableViewCellWithDefaultTitleLabel1TextField";
static NSString* buttonCellIdentifier = @"TableViewCellWith1button";
@interface HomeView()<UITableViewDataSource,UITableViewDelegate,TableViewCellChangedDelegate>
{
    BOOL bChangeState;
    Byte feedState;
    Byte valveState;
    Byte vibInState;
    Byte vibOutState;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation HomeView

-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"HomeView" owner:self options:nil] firstObject];
        
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        bChangeState = false;
        [self.tableView registerNib:[UINib nibWithNibName:switchCellName bundle:nil] forCellReuseIdentifier:valveCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:switchCellName bundle:nil] forCellReuseIdentifier:commonCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:feedSettingCellIdentifier bundle:nil] forCellReuseIdentifier:feedSettingCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:buttonCellIdentifier bundle:nil] forCellReuseIdentifier:buttonCellIdentifier];
        self.tableView.delegate = self;
        self.tableView.dataSource =self;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.bounces = NO;
        self.tableView.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.3];
        
        Device *device = kDataModel.currentDevice;
        if (device->screenProtocolMainVersion > kDataModel.protocolMainVersion) {
            [self makeToast:kLanguageForKey(366) duration:3.0 position:CSToastPositionCenter];
        }
    }
    return self;
}
-(UIView *)getViewWithPara:(NSDictionary *)para{
    [[NetworkFactory sharedNetWork] changeLayerAndView];
    [self refreshCurrentView];
    return self;
}
- (void)refreshCurrentView{
    [[NetworkFactory sharedNetWork] getCurrentDeviceInfo];
}
-(void)updateWithHeader:(NSData*)headerData
{
    const unsigned char *a = headerData.bytes;
    if (a[0] == 3 || a[0] == 8 || a[0] == 0x0f || (a[0] == 0xa1 && a[1] == 1)) {
        [self.tableView reloadData];
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [self refreshCurrentView];
    }else if (a[0] == 0x0d){
        if (a[1] == 6) {
            if (a[2] == 1) {
                [self makeToast:kLanguageForKey(205) duration:2.0 position:CSToastPositionCenter];
            }else{
                [self makeToast:kLanguageForKey(206) duration:2.0 position:CSToastPositionCenter];
            }
        }else{
            [self.tableView reloadData];
        }
    }
}
#pragma mark tableview datasource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    Device *device = kDataModel.currentDevice;
    if (device) {
        return 4;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 0;
    }
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    Device *device = kDataModel.currentDevice;
    if (device) {
        if (section == 0) {
            return 7;
        }
        if (section == 1) {
            return 2;
        }
        if (section == 2) {
            return 2;
        }
        if (section == 3) {
            return 1;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Device *device = kDataModel.currentDevice;
    if (device) {
        if (indexPath.section == 0) {
            if (indexPath.row == 3) {
                if (device->machineData.vibIn>1) {
                    return 0;
                }
            }else if (indexPath.row == 4){
                if (device->machineData.vibOut>1) {
                    return 0;
                }
            }
            else if (indexPath.row == 5){
                if (device->machineData.machineType != MACHINE_TYPE_WHEEL&& device->machineData.machineType != MACHINE_TYPE_WHEEL_2) {
                    return 0;
                }
            }else if (indexPath.row == 6){
                if (device->machineData.machineType != MACHINE_TYPE_WHEEL_2) {
                    return 0;
                }
            }
        }
    }
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Device *device = kDataModel.currentDevice;
    if (device) {
        Byte tempfeedState = device->machineData.feederState;
        Byte tempvalveState = device->machineData.valveState;
        Byte tempcleanState = device->machineData.cleanState;
        Byte tempstartState = device->machineData.startState;
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                TableViewCellWithDefaultTitleLabel1Switch *tableCell = [tableView dequeueReusableCellWithIdentifier:commonCellIdentifier forIndexPath:indexPath];
                
                tableCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
                tableCell.textLabel.text = kLanguageForKey(19) ;
                tableCell.textLabel.font = [UIFont systemFontOfSize:14.0];
                tableCell.textLabel.textColor = [UIColor TaiheColor];
                if (tempfeedState) {
                    [tableCell.switchBtn setOn:true];
                }else{
                    [tableCell.switchBtn setOn:false];
                }
                tableCell.switchBtn.tag = 101;
                tableCell.delegate = self;
                tableCell.indexPath = indexPath;
                return tableCell;
            }else if(indexPath.row == 1){
                TableViewCellWithDefaultTitleLabel1Switch *tableCell = [tableView dequeueReusableCellWithIdentifier:valveCellIdentifier forIndexPath:indexPath];
#ifdef Engineer
                tableCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
#else
#endif
                tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                tableCell.textLabel.font = [UIFont systemFontOfSize:14.0];
                tableCell.textLabel.textColor = [UIColor TaiheColor];
                if (tempvalveState) {
                    tableCell.textLabel.text = kLanguageForKey(1006);
                    [tableCell.switchBtn setOn:true];
                }else{
                    tableCell.textLabel.text = kLanguageForKey(1007);
                    [tableCell.switchBtn setOn:false];
                }
                tableCell.switchBtn.tag = 102;
                tableCell.delegate = self;
                tableCell.indexPath = indexPath;
                return tableCell;
            }else if (indexPath.row == 2){
                TableViewCellWithDefaultTitleLabel1TextField *tableviewCell = [tableView dequeueReusableCellWithIdentifier:feedSettingCellIdentifier forIndexPath:indexPath];
                tableviewCell.textField.tag = 804;
                tableviewCell.selectionStyle = UITableViewCellSelectionStyleNone;
                tableviewCell.accessoryType = UITableViewCellAccessoryNone;
                tableviewCell.textLabel.text = kLanguageForKey(23) ;
                tableviewCell.textLabel.font = [UIFont systemFontOfSize:14.0];
                tableviewCell.textLabel.textColor = [UIColor TaiheColor];
                tableviewCell.textField.text = [NSString stringWithFormat:@"%d",device->machineData.fristVib];
                [tableviewCell.textField initKeyboardWithMax:99 Min:1 Value:tableviewCell.textField.text.integerValue];
                tableviewCell.delegate = self;
                tableviewCell.indexPath = indexPath;
                tableviewCell.cellType = TableViewCellType_Feeding;
                return tableviewCell;
            }else if (indexPath.row == 3){
                TableViewCellWithDefaultTitleLabel1Switch *tableCell = [tableView dequeueReusableCellWithIdentifier:commonCellIdentifier forIndexPath:indexPath];
                tableCell.switchBtn.tag = 801;
                tableCell.accessoryType = UITableViewCellAccessoryNone;
                tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
                tableCell.textLabel.font = [UIFont systemFontOfSize:14.0];
                tableCell.textLabel.textColor = [UIColor TaiheColor];
                if (device->machineData.vibIn>1) {
                    tableCell.hidden = YES;
                    tableCell.frame = CGRectZero;
                }else{
                    if(device->machineData.vibIn){
                        NSString *title = kLanguageForKey(87);
                        NSLog(@"%@",title);
                        tableCell.textLabel.text = kLanguageForKey(87);
                        [tableCell.switchBtn setOn:true];
                    }else{
                        NSString *title = kLanguageForKey(86);
                        NSLog(@"%@",title);
                        tableCell.textLabel.text = kLanguageForKey(86);
                        [tableCell.switchBtn setOn:false];
                    }
                    tableCell.hidden = NO;
                }
                tableCell.delegate = self;
                tableCell.indexPath = indexPath;
                return tableCell;
            }else if (indexPath.row == 4){
                TableViewCellWithDefaultTitleLabel1Switch *tableCell = [tableView dequeueReusableCellWithIdentifier:commonCellIdentifier forIndexPath:indexPath];
                tableCell.switchBtn.tag = 802;
                tableCell.accessoryType = UITableViewCellAccessoryNone;
                tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
                tableCell.textLabel.font = [UIFont systemFontOfSize:14.0];
                tableCell.textLabel.textColor = [UIColor TaiheColor];
                if (device->machineData.vibOut>1) {
                    tableCell.hidden = YES;
                    tableCell.frame = CGRectZero;
                }else{
                    if (device->machineData.vibOut) {
                        tableCell.textLabel.text = kLanguageForKey(89);
                        [tableCell.switchBtn setOn:true];
                    }else{
                        tableCell.textLabel.text = kLanguageForKey(88);
                        [tableCell.switchBtn setOn:false];
                    }
                    tableCell.hidden = NO;
                }
                tableCell.delegate = self;
                tableCell.indexPath = indexPath;
                return tableCell;
            }else if (indexPath.row == 5){
                TableViewCellWithDefaultTitleLabel1Switch *tableCell = [tableView dequeueReusableCellWithIdentifier:commonCellIdentifier forIndexPath:indexPath];
                tableCell.switchBtn.tag = 1000;
                tableCell.accessoryType = UITableViewCellAccessoryNone;
                tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
                tableCell.textLabel.font = [UIFont systemFontOfSize:14.0];
                tableCell.textLabel.textColor = [UIColor TaiheColor];
                if (device->machineData.machineType== MACHINE_TYPE_WHEEL||device->machineData.machineType== MACHINE_TYPE_WHEEL_2) {
                    if (device->machineData.wheel[0]) {
                        [tableCell.switchBtn setOn:true];
                        if (device->machineData.machineType == MACHINE_TYPE_WHEEL) {
                            tableCell.textLabel.text = kLanguageForKey(137) ;
                        }else if (device->machineData.machineType == MACHINE_TYPE_WHEEL_2){
                            tableCell.textLabel.text = kLanguageForKey(133) ;
                        }
                        
                    }else{
                        [tableCell.switchBtn setOn:false];
                        if (device->machineData.machineType == MACHINE_TYPE_WHEEL) {
                            tableCell.textLabel.text = kLanguageForKey(136) ;
                        }else if (device->machineData.machineType == MACHINE_TYPE_WHEEL_2){
                            tableCell.textLabel.text = kLanguageForKey(132) ;
                        }
                    }
                    tableCell.hidden = NO;
                }else{
                    tableCell.hidden = YES;
                    tableCell.frame = CGRectZero;
                }
                tableCell.delegate = self;
                tableCell.indexPath = indexPath;
                return tableCell;
            }else if (indexPath.row == 6){
                TableViewCellWithDefaultTitleLabel1Switch *tableCell = [tableView dequeueReusableCellWithIdentifier:commonCellIdentifier forIndexPath:indexPath];
                tableCell.switchBtn.tag = 1001;
                tableCell.accessoryType = UITableViewCellAccessoryNone;
                tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
                tableCell.textLabel.font = [UIFont systemFontOfSize:14.0];
                tableCell.textLabel.textColor = [UIColor TaiheColor];
                if (device->machineData.machineType== MACHINE_TYPE_WHEEL_2) {
                    if (device->machineData.wheel[1]) {
                        [tableCell.switchBtn setOn:true];
                        tableCell.textLabel.text = kLanguageForKey(135) ;
                    }else{
                        [tableCell.switchBtn setOn:false];
                        tableCell.textLabel.text = kLanguageForKey(134) ;
                    }
                    tableCell.hidden = NO;
                }else{
                    tableCell.hidden = YES;
                    tableCell.frame = CGRectZero;
                }
                tableCell.delegate = self;
                tableCell.indexPath = indexPath;
                return tableCell;
                
            }
            
        }
        else if (indexPath.section == 1){
            TableViewCellWith1button *tableViewCell = [tableView dequeueReusableCellWithIdentifier:buttonCellIdentifier forIndexPath:indexPath];
            tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableViewCell.button.tag = 202;
            tableViewCell.button.titleLabel.font = [UIFont systemFontOfSize:14.0];
            tableViewCell.delegate =self;
            tableViewCell.indexPath = indexPath;
            if (indexPath.row == 0) {
                if (tempcleanState == 0) {
                    [tableViewCell.button setTitle:kLanguageForKey(22)  forState:UIControlStateNormal];
                    tableViewCell.button.backgroundColor = [UIColor TaiheColor];
                    tableViewCell.button.userInteractionEnabled = YES;
                }else{
                    [tableViewCell.button setTitle:kLanguageForKey(24)  forState:UIControlStateNormal];
                    tableViewCell.button.backgroundColor = [UIColor greenColor];
                    [tableViewCell.button setUserInteractionEnabled:NO];
                }
                tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if (indexPath.row == 1){
                tableViewCell.accessoryType = UITableViewCellAccessoryNone;
                tableViewCell.button.tag = 201;
                switch (tempstartState) {
                    case 0:
                        [tableViewCell.button setTitle:kLanguageForKey(26)  forState:UIControlStateNormal];
                        [tableViewCell.button setUserInteractionEnabled:YES];
                        [tableViewCell.button setBackgroundColor:[UIColor TaiheColor]];
                        break;
                    case 1:
                        [tableViewCell.button setTitle:kLanguageForKey(25)  forState:UIControlStateNormal];
                        [tableViewCell.button setUserInteractionEnabled:YES];
                        [tableViewCell.button setBackgroundColor:[UIColor greenColor]];
                        break;
                    case 2:
                        [tableViewCell.button setTitle:kLanguageForKey(27)  forState:UIControlStateNormal];
                        [tableViewCell.button setUserInteractionEnabled:NO];
                        [tableViewCell.button setBackgroundColor:[UIColor greenColor]];
                        break;
                    case 3:
                    {
                        [tableViewCell.button setUserInteractionEnabled:YES];
                        [tableViewCell.button setBackgroundColor:[UIColor TaiheColor]];
                        [tableViewCell.button setTitle:kLanguageForKey(26)  forState:UIControlStateNormal];
                    }
                        break;
                    default:
                        break;
                }
            }
            return tableViewCell;
            
        }
    }
    static NSString* defaultCell = @"DefaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCell];
    if(cell== nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:defaultCell ];
    }
    if (indexPath.section == 2){
        if (indexPath.row == 0) {
            cell.textLabel.text = kLanguageForKey(336) ;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.textLabel.textColor = [UIColor TaiheColor];
            NSString *modeNameStr = [NSString stringWithFormat:@"%@ [%d-%d]",device.modeName,device->machineData.sortModeBig+1,device->machineData.sortModeSmall];
            cell.detailTextLabel.text = modeNameStr;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
            cell.detailTextLabel.textColor = [UIColor redColor];
            cell.textLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.tableView.rowHeight);
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.row == 1){
            TableViewCellWith1button *tableViewCell = [tableView dequeueReusableCellWithIdentifier:buttonCellIdentifier forIndexPath:indexPath];
            tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableViewCell.button.tag = 204;
            tableViewCell.button.titleLabel.font = [UIFont systemFontOfSize:14.0];
            tableViewCell.delegate =self;
            tableViewCell.indexPath = indexPath;
            [tableViewCell.button setTitle:kLanguageForKey(138)  forState:UIControlStateNormal];
            [tableViewCell.button setBackgroundColor:[UIColor TaiheColor]];
            return tableViewCell;
        }
    }
    else if (indexPath.section == 3){
        TableViewCellWith1button *tableViewCell = [tableView dequeueReusableCellWithIdentifier:buttonCellIdentifier forIndexPath:indexPath];
        tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableViewCell.button.tag = 203;
        tableViewCell.button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        tableViewCell.delegate =self;
        tableViewCell.indexPath = indexPath;
        [tableViewCell.button setTitle:kLanguageForKey(1001)  forState:UIControlStateNormal];
        [tableViewCell.button setBackgroundColor:[UIColor redColor]];
        return tableViewCell;
    }
    return cell;
}
#pragma mark tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.paraNextView setObject:kLanguageForKey(23) forKey:@"title"];
            [gMiddeUiManager ChangeViewWithName:@"FeedSetView" Para:self.paraNextView];
        }
#ifdef Engineer
        if (indexPath.row == 1) {
            [self.paraNextView setObject:kLanguageForKey(18) forKey:@"title"];
            [gMiddeUiManager ChangeViewWithName:@"ValveSetView" Para:self.paraNextView];
        }
#else
#endif
    }
    if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [self.paraNextView setObject:kLanguageForKey(21) forKey:@"title"];
            [gMiddeUiManager ChangeViewWithName:@"CleanSetView" Para:self.paraNextView];
        }
    }
    Device *device = kDataModel.currentDevice;
    if (device) {
        if (indexPath.section == 2) {
            [self.paraNextView setObject:kLanguageForKey(90) forKey:@"title"];
            [gMiddeUiManager ChangeViewWithName:@"ModeListView" Para:self.paraNextView];
        }
    }
}

#pragma mark tableviewcell delegate
-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value{
    if (index == 203) {
        [self disconnectDevice];
    }else if(index == 204){
        [[NetworkFactory sharedNetWork] saveCurrentMode];
    }
    else{
        bChangeState = true;
        [self setDeviceRunState:index Value:value];
    }
}

-(void)disconnectDevice
{
    [[NetworkFactory sharedNetWork] disconnnectCurrentDevice];
    [super logOut];
}
- (void)setDeviceRunState:(NSInteger)tag Value:(Byte)value
{
    bChangeState = true;
    Byte type = 0;
    if (tag<203) {
        switch (tag) {
            case 101:
                type = 1;
                feedState = value;
                break;
            case 102:
                type = 2;
                valveState = value;
                break;
            case 201://start
                
                type = 3;
                break;
            case 202://clean
                type = 4;
                break;
            default:
                break;
        }
        [[NetworkFactory sharedNetWork]setDeviceRunState:value withType:type];
    }else if(tag<1000)
    {
        Device *device = kDataModel.currentDevice;
        if (tag == 801) {
            type = 1;
            [[NetworkFactory sharedNetWork] setVibInOutSwitchStateWithType:type];
        }else if (tag == 802){
            type = 2;
            [[NetworkFactory sharedNetWork] setVibInOutSwitchStateWithType:type];
        }else if (tag == 804){
            type = 4;
            if (device->machineData.fristVib>value) {
                value = device->machineData.fristVib-value;
                [[NetworkFactory sharedNetWork] setDeviceFeedInOutState:value withType:type addOrDel:0 IsAll:1];
            }else{
                value = value-device->machineData.fristVib;
                [[NetworkFactory sharedNetWork] setDeviceFeedInOutState:value withType:type addOrDel:1 IsAll:1];
            }
        }
        
        
        
    }else{
        if (tag == 1000) {
            [[NetworkFactory sharedNetWork] switchCaterpillar:value withLayerIndex:1];
        }else if (tag == 1001){
            [[NetworkFactory sharedNetWork] switchCaterpillar:value withLayerIndex:2];
        }
    }
}

-(void)dealloc{
    NSLog(@"home view dealloc");
}
@end
