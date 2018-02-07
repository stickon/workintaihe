//
//  FeedSetView.m
//  thColorSort
//
//  Created by taihe on 2018/1/9.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "FeedSetView.h"
#import "FeedSettingTitleTableViewCell.h"
#import "FeedSettingTableViewCell.h"
#import "TableViewCellWith2Button.h"
static NSString *FeedCellIdentifier = @"FeedSettingTableViewCell";
static NSString *TotalAddDelCellIdentifier = @"TableViewCellWith2Button";
static NSString *FeedCellTitleIdentifier = @"FeedSettingTitleTableViewCell";
@interface FeedSetView()<UITableViewDelegate,UITableViewDataSource,TableViewCellChangedDelegate>
{
    BOOL dataloaded;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
@implementation FeedSetView
-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"FeedSet" owner:self options:nil] firstObject];
        
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.bounces = NO;
        [self.tableView registerNib:[UINib nibWithNibName:FeedCellTitleIdentifier bundle:nil] forCellReuseIdentifier:FeedCellTitleIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:FeedCellIdentifier bundle:nil] forCellReuseIdentifier:FeedCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:TotalAddDelCellIdentifier bundle:nil] forCellReuseIdentifier:TotalAddDelCellIdentifier];
        
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        self.title = kLanguageForKey(23);
        dataloaded = false;
        [[NetworkFactory sharedNetWork] getVibSettingValue];
    }
    return self;
}
-(UIView *)getViewWithPara:(NSDictionary *)para{
    [[NetworkFactory sharedNetWork] changeLayerAndView];
    return self;
}
- (void)refreshCurrentView{
    [[NetworkFactory sharedNetWork] getVibSettingValue];
}
-(void)updateWithHeader:(NSData*)headerData
{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x08) {
        if (header[1] == 0x05) {
            dataloaded = true;
            [self.tableView reloadData];
        }else if (header[1] == 0x04){
            [[NetworkFactory sharedNetWork] getVibSettingValue];
        }else if (header[1] == 0x1 || header[1] == 0x2){
            [self.tableView reloadData];
        }
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }
}

#pragma tableview data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataloaded) {
        Device *device = kDataModel.currentDevice;
        if (device) {
            if (device->machineData.vibIn<2 || device->machineData.vibOut <2) {
                return 2;
            }
            return 1;
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataloaded) {
        Device *device = kDataModel.currentDevice;
        if (section == 0) {
            return device->vibSet.ch+2;
        }else if (section == 1){
            return 2;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Device *device = kDataModel.currentDevice;
    if (dataloaded) {
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                if (device->machineData.vibIn>1) {
                    return 0;
                }else{
                    if (device->machineData.machineType == MACHINE_TYPE_CHUTE && (device->machineData.chuteNumber == 1 ||device->machineData.chuteNumber == 2)) {
                        return 44;
                    }else if (device->machineData.machineType == MACHINE_TYPE_TEA && device->machineData.chuteNumber == 1){
                        return 44;
                    }else {
                        return 0;
                    }
                }
            }else if (indexPath.row == 1){
                if (device->machineData.vibOut>1){
                    return 0;
                }else{
                    if (device->machineData.machineType == MACHINE_TYPE_CHUTE && (device->machineData.chuteNumber == 1 ||device->machineData.chuteNumber == 2)) {
                        return 44;
                    }else if (device->machineData.machineType == MACHINE_TYPE_TEA && device->machineData.chuteNumber == 1){
                        return 44;
                    }else if (device->machineData.machineType == MACHINE_TYPE_WHEEL_2){
                        return 44;
                    }else{
                        return 0;
                    }
                }
            }
        }
    }
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Device *device = kDataModel.currentDevice;
    if (indexPath.section ==0) {
        if (indexPath.row == 0) {
            FeedSettingTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedCellTitleIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.feedChuteTitleLabel.text =kLanguageForKey(41);
            cell.feedTitleLabel.text = kLanguageForKey(333);
            cell.feedSwitchTitleLabel.text = kLanguageForKey(334);
            return cell;
        }else if (indexPath.row <= device->vibSet.ch && indexPath.row >0) {
            FeedSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedCellIdentifier forIndexPath:indexPath];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.feedCellTitle.text = [NSString stringWithFormat:@"%d",(int)indexPath.row];
            cell.feedNumTextField.text = [NSString stringWithFormat:@"%d",device->vibdata[indexPath.row-1]];
            if (device->vibSwitch[indexPath.row-1]) {
                cell.feedSwitch.on = YES;
            }else{
                cell.feedSwitch.on = NO;
            }
            return cell;
        }else if (indexPath.row == device->vibSet.ch+1){
            TableViewCellWith2Button *cell = [tableView dequeueReusableCellWithIdentifier:TotalAddDelCellIdentifier forIndexPath:indexPath];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if (indexPath.section == 1){
        FeedSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedCellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.feedCellTitle.text = kLanguageForKey(318);
            if (device->machineData.vibIn>1) {
                cell.hidden = YES;
            }else{
                if (device->machineData.machineType == MACHINE_TYPE_CHUTE && (device->machineData.chuteNumber == 1 ||device->machineData.chuteNumber == 2)) {
                    cell.hidden = NO;
                    cell.feedNumTextField.text = [NSString stringWithFormat:@"%d",device->vibSet.inOutData[0]];
                    if (device->machineData.vibIn) {
                        cell.feedSwitch.on = YES;
                    }else{
                        cell.feedSwitch.on = NO;
                    }
                }else if (device->machineData.machineType == MACHINE_TYPE_TEA && device->machineData.chuteNumber == 1){
                    cell.hidden = NO;
                    cell.feedNumTextField.text = [NSString stringWithFormat:@"%d",device->vibSet.inOutData[0]];
                    if (device->machineData.vibIn) {
                        cell.feedSwitch.on = YES;
                    }else{
                        cell.feedSwitch.on = NO;
                    }
                }else{
                    cell.hidden = YES;
                }
            }
            return cell;
        }else if (indexPath.row == 1){
            cell.feedCellTitle.text = kLanguageForKey(317);
            if (device->machineData.vibOut>1) {
                cell.hidden = YES;
            }else{
                if (device->machineData.machineType == MACHINE_TYPE_CHUTE && (device->machineData.chuteNumber == 1 ||device->machineData.chuteNumber == 2)) {
                    cell.hidden = NO;
                    
                    cell.feedNumTextField.text = [NSString stringWithFormat:@"%d",device->vibSet.inOutData[1]];
                    if (device->machineData.vibOut) {
                        cell.feedSwitch.on = YES;
                    }else{
                        cell.feedSwitch.on = NO;
                    }
                }else if (device->machineData.machineType == MACHINE_TYPE_TEA && device->machineData.chuteNumber == 1){
                    cell.hidden = NO;
                    cell.feedNumTextField.text = [NSString stringWithFormat:@"%d",device->vibSet.inOutData[1]];
                    if (device->machineData.vibOut) {
                        cell.feedSwitch.on = YES;
                    }else{
                        cell.feedSwitch.on = NO;
                    }
                }else if (device->machineData.machineType == MACHINE_TYPE_WHEEL_2) {
                    cell.hidden = NO;
                    cell.feedNumTextField.hidden = YES;
                    if (device->machineData.vibOut) {
                        cell.feedSwitch.on = YES;
                    }else{
                        cell.feedSwitch.on = NO;
                    }
                }else{
                    cell.hidden = YES;
                }
            }
            return cell;
        }
    }
    static NSString* defaultCell = @"DefaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCell];
    return cell;
}

#pragma table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma tableview cell delegate
-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value
{
    Device *device = kDataModel.currentDevice;
    if (section == 0) {
        if (row > 0 && row <= device->vibSet.ch) {
            if (index == 1) {
                [[NetworkFactory sharedNetWork] setDeviceFeedInOutState:value withType:row-1 addOrDel:0 IsAll:0];
            }else if (index == 2){
                [[NetworkFactory sharedNetWork] setVibNum:row-1 Switch:value];
            }
        }else if (row == device->vibSet.ch+1){
            [[NetworkFactory sharedNetWork] setDeviceFeedInOutState:1 withType:0 addOrDel:index IsAll:1];
        }
    }
    if (section == 1) {
        if (index == 1) {//改变入料出料量
            [[NetworkFactory sharedNetWork] setVibInOut:row+1 Value:value];
        }else if (index == 2){//入料出料开关
            [[NetworkFactory sharedNetWork] setVibInOutSwitchStateWithType:row+1];
        }
    }
}


-(void)cellBtnClicked:(long)section row:(long)row tag:(long)tag value:(NSInteger)value bSend:(BOOL)bsend{
    Device *device = kDataModel.currentDevice;
    if (section == 0)
    {
        if (row == device->vibSet.ch+1) {
            if (bsend) {
                [[NetworkFactory sharedNetWork] setDeviceFeedInOutState:value withType:0 addOrDel:tag IsAll:1];
            }else{
                if (tag == 1) {
                    for (int i = 0; i<device->vibSet.ch; i++) {
                        if (device->vibdata[i]<99) {
                            device->vibdata[i]+=1;
                        }
                    }
                }else if (tag == 2){
                    for (int i = 0; i<device->vibSet.ch; i++) {
                        if (device->vibdata[i]>2) {
                            device->vibdata[i]-=1;
                        }
                    }
                }
                
                [self reloadRows];
            }
        }
    }
}


-(void)reloadRows{
    Device *device = kDataModel.currentDevice;
    NSArray *rowArray =[NSArray array];
    for (int i= 1; i<=device->vibSet.ch;i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        rowArray  = [rowArray arrayByAddingObject:indexPath];
    }
    [self.tableView reloadRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationNone];
}
@end
