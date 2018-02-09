//
//  Rice20SenseView.m
//  thColorSort
//
//  Created by taihe on 2018/2/6.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "Rice20SenseView.h"
#import "RiceUserAlgorithmTableViewCell.h"
@interface Rice20SenseView()<UITableViewDelegate,UITableViewDataSource,TableViewCellChangedDelegate>

@property (nonatomic,strong) NSIndexPath* selectIndexPath;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *frontViewBtn;
@property (strong, nonatomic) IBOutlet UIButton *rearViewBtn;
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@end
@implementation Rice20SenseView

-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"Rice20SenseView" owner:self options:nil] firstObject];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
//        self.tableView.mj_header = self.refreshHeader;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self initView];
        Device *device = kDataModel.currentDevice;
        if (device->machineData.layerNumber>1) {
            self.baseLayerLabel = self.currentLayerLabel;
            
        }else{
            self.currentLayerLabel.frame = CGRectZero;
            self.currentLayerLabelHeightConstraint.constant = 0.0f;
        }
    }
    
    return self;
}

-(UIView*)getViewWithPara:(NSDictionary *)para{
    [self refreshCurrentView];
    return self;
}
- (void)initView{
    Device *device = kDataModel.currentDevice;
    self->viewBtn[0] = self.frontViewBtn;
    self->viewBtn[1] = self.rearViewBtn;
    [super frontRearViewBtnAddTargetEvent];
    if (device.currentViewIndex == 0) {
        self.frontViewBtn.selected = true;
        self.frontViewBtn.backgroundColor = [UIColor greenColor];
        self.frontViewBtn.userInteractionEnabled = NO;
        self.rearViewBtn.userInteractionEnabled = YES;
        self.rearViewBtn.selected = false;
        self.rearViewBtn.backgroundColor = [UIColor TaiheColor];
    }else if (device.currentViewIndex == 1){
        self.frontViewBtn.selected = false;
        self.frontViewBtn.backgroundColor = [UIColor TaiheColor];
        self.rearViewBtn.selected = true;
        self.rearViewBtn.backgroundColor = [UIColor greenColor];
        self.frontViewBtn.userInteractionEnabled = YES;
        self.rearViewBtn.userInteractionEnabled = NO;
    }
    if (device->machineData.hasRearView[device.currentLayerIndex-1]) {
        self.rearViewBtn.hidden = NO;
    }else{
        self.rearViewBtn.hidden = YES;
    }
}

-(void)refreshCurrentView{
    [[NetworkFactory sharedNetWork]sendToGetRiceUserSense];
}

-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* a = headerData.bytes;
    if (a[0] == 0x04 && a[1] == 0x21) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [self refreshCurrentView];
    }
}
- (void)initLanguage{
    [self.frontViewBtn setTitle:kLanguageForKey(75) forState:UIControlStateNormal];
    [self.rearViewBtn setTitle:kLanguageForKey(76) forState:UIControlStateNormal];
}
#pragma changeViewDelegate
- (void)selectLayer:(NSUInteger)layer View:(NSUInteger)view
{
    kDataModel.currentDevice.currentLayerIndex = layer;
    kDataModel.currentDevice.currentViewIndex = 0;
    [self refreshCurrentView];
}

#pragma tableview data source

- (NSInteger)numberOfSectionsInTableVeiw:(UITableView*)tableView
{
    Device *device = kDataModel.currentDevice;
    if (device->machineData.useColor) {
        return 1;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.5;
}
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    Device *device = kDataModel.currentDevice;
    if (device->machineData.useColor) {
        return device.userAlgorithmNums;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    Device *device = kDataModel.currentDevice;
    
    if (device->machineData.useColor) {
        if (indexPath.row<device.userAlgorithmNums) {
            static NSString *cellIdentifier = @"RiceUserAlgorithmTableViewCell";
            RiceUserAlgorithmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil]lastObject];
            }
            cell.textLabel.font = SYSTEMFONT_14f;
            if ((*(device->riceUserAlgorithm+indexPath.row)).used) {
                [cell.riceUserAlgorithmUseSwitch setOn:YES];
            }else{
                [cell.riceUserAlgorithmUseSwitch setOn:NO];
            }
            cell.riceUserAlgorithmUseSwitch.tag = 5;
            cell.riceUserAlgorithmNameLabel.text =[NSString stringWithUTF8String:(*(device->riceUserAlgorithm+indexPath.row)).name];
            cell->svmRange = (*(device->riceUserAlgorithm+indexPath.row)).range;
            cell.type = (*(device->riceUserAlgorithm+indexPath.row)).type;
            for (int i = 0; i < device->groupNum; i++) {
                NSInteger sense = ((*(device->riceUserAlgorithm+indexPath.row)).sense[i][0])*256+(*(device->riceUserAlgorithm+indexPath.row)).sense[i][1];
                cell.groupTextFieldArray[i].text = [NSString stringWithFormat:@"%lu",(long)sense];
                cell.groupTextFieldArray[i].hidden = NO;
                cell.groupTextFieldArray[i].tag = i;
                cell.groupTextFieldArray[i].font = SYSTEMFONT_14f;
            }
           
            cell.indexPath = indexPath;
            cell.delegate = self;
            if ((cell.indexPath.row)%2 == 0) {
                cell.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    UITableViewCell *defaultCell = [[UITableViewCell alloc]init];
    return defaultCell;
}



#pragma celldatachangeddelegate

-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value
{
    Device *device = kDataModel.currentDevice;
    if (index>4) {
        [[NetworkFactory sharedNetWork] sendToSetRiceUserSenseUseWithType:(*(device->riceUserAlgorithm+row)).type Value:value];
    }else{
        [[NetworkFactory sharedNetWork] sendToSetRiceUserSenseWithType:(*(device->riceUserAlgorithm+row)).type GroupIndex:index RowIndex:(Byte)row Value:(int)value];
    }
}


#pragma mark 切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [self initView];
    [self refreshCurrentView];
}

- (void)frontRearViewChanged{
    [[NetworkFactory sharedNetWork] changeLayerAndView];
    [self refreshCurrentView];
}
@end
