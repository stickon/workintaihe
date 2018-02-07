//
//  IRAlgorithmView.m
//  thColorSort
//
//  Created by taihe on 2018/1/29.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "IRAlgorithmView.h"
#import "TableViewCellWithDefaultTitleLabel1TextField.h"
@interface IRAlgorithmView ()<UITableViewDelegate,UITableViewDataSource,TableViewCellChangedDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSIndexPath* selectIndexPath;
@property (strong, nonatomic) IBOutlet UIButton *frontViewBtn;
@property (strong, nonatomic) IBOutlet UIButton *rearViewBtn;
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@end
@implementation IRAlgorithmView


-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"IRAlgorithmView" owner:self options:nil] firstObject];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        self.tableView.mj_header = self.refreshHeader;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    [[NetworkFactory sharedNetWork]sendToGetDataIsIR:0];
    return self;
}
- (void)initView{
    Device *device = kDataModel.currentDevice;
    self->viewBtn[0] = self.frontViewBtn;
    self->viewBtn[1] = self.rearViewBtn;
    [super frontRearViewBtnAddTargetEvent];
    if (device->machineData.useIR%3 == 0) {//前后都有
        self.frontViewBtn.hidden = NO;
        self.rearViewBtn.hidden = NO;
    }else if (device->machineData.useIR%3== 1) {//仅前视
        self.frontViewBtn.hidden = NO;
        self.rearViewBtn.hidden = YES;
    }else if (device->machineData.useIR%3== 2) {//仅后视
        self.frontViewBtn.hidden = YES;
        self.rearViewBtn.hidden = NO;
        device.currentViewIndex = 1;
    }
    if (device.currentViewIndex == 0) {
        self.frontViewBtn.selected = true;
        self.frontViewBtn.backgroundColor = [UIColor greenColor];
        self.frontViewBtn.userInteractionEnabled = NO;
        self.rearViewBtn.userInteractionEnabled = YES;
        self.rearViewBtn.selected = false;
    }else if (device.currentViewIndex == 1){
        self.frontViewBtn.selected = false;
        self.rearViewBtn.selected = true;
        self.rearViewBtn.backgroundColor = [UIColor greenColor];
        self.frontViewBtn.userInteractionEnabled = YES;
        self.rearViewBtn.userInteractionEnabled = NO;
    }
}

-(void)refreshCurrentView{
    [[NetworkFactory sharedNetWork]sendToGetDataIsIR:1];
}

-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* a = headerData.bytes;
    if (a[0] == 0x04 && a[1] == 0x01) {
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
    [[NetworkFactory sharedNetWork]sendToGetDataIsIR:1];
}

#pragma tableview data source

- (NSInteger)numberOfSectionsInTableVeiw:(UITableView*)tableView
{
    Device *device = kDataModel.currentDevice;
    if (device->machineData.useIR) {
        return 1;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    Device *device = kDataModel.currentDevice;
    if (device->machineData.useIR) {
        return device.irAlogrithmNum;
    }
    
    
    //fix me
    return 0;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    Device *device = kDataModel.currentDevice;
    
    if (device->machineData.useIR) {
        if (indexPath.row<device.irAlogrithmNum) {
            static NSString *cellIdentifier = @"TableViewCellWithDefaultTitleLabel1TextField";
            TableViewCellWithDefaultTitleLabel1TextField *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil]lastObject];
            }
            
            cell.textLabel.font = SYSTEMFONT_14f;
            if ((*(device->irAlgorithm+indexPath.row)).used) {
                cell.textLabel.textColor = [UIColor redColor];
            }else{
                cell.textLabel.textColor = [UIColor blackColor];
            }
            cell.textLabel.text =[NSString stringWithUTF8String:(*(device->irAlgorithm+indexPath.row)).name];
            NSLog(@"algorithm name:%@",cell.textLabel.text);
            NSInteger sense = ((*(device->irAlgorithm+indexPath.row)).sense[0])*256+(*(device->irAlgorithm+indexPath.row)).sense[1];
            cell.textField.text = [NSString stringWithFormat:@"%lu",(long)sense];
            NSLog(@"sense:%@",cell.textField.text);
            cell.indexPath = indexPath;
            cell.textField.tag = indexPath.section*1000+indexPath.row+1;
            cell.textField.font = SYSTEMFONT_14f;
            cell.delegate = self;
            if ((*(device->irAlgorithm+indexPath.row)).type < 2) {
                cell.cellType = TableViewCellType_IRSpot;
            }else{
                if (device->machineData.useIR>=7) {
                    cell.cellType = TableViewCellType_DevideIRDiff;
                }else{
                    cell.cellType = TableViewCellType_IRDiff;
                }
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }
    UITableViewCell *defaultCell = [[UITableViewCell alloc]init];
    return defaultCell;
}
#pragma mark - tableviewdelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    _selectIndexPath = indexPath;
    Device *device = kDataModel.currentDevice;
    [self.paraNextView setObject:[NSString stringWithUTF8String:(*(device->irAlgorithm+_selectIndexPath.row)).name]forKey:@"title"];
    [self.paraNextView setObject:[NSString stringWithFormat:@"%ld",(long)self.selectIndexPath.row] forKey:@"algorithmIndex"];
     if ((*(device->irAlgorithm+indexPath.row)).type < 2) {
        [[MiddleManager shareInstance] ChangeViewWithName:@"IRColorAdvancedView" Para:self.paraNextView];
    }else{
         [[MiddleManager shareInstance] ChangeViewWithName:@"IRDiffAdvancedView" Para:self.paraNextView];
    }
}


#pragma celldatachangeddelegate

-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value
{
    Device *device = kDataModel.currentDevice;
    NSUInteger oldValue =((*(device->irAlgorithm+row)).sense[0])*256+(*(device->irAlgorithm+row)).sense[1];
    if((NSUInteger)value >oldValue){
        [[NetworkFactory sharedNetWork]sendAlgorithmSenseValueWithAjustType:1 Sorter:0 data:value-oldValue algorithmType:(*(device->irAlgorithm+row)).type FirstSecond:0 ValueType:1 IsIR:1];
    }else{
        [[NetworkFactory sharedNetWork]sendAlgorithmSenseValueWithAjustType:2 Sorter:0 data:oldValue-value algorithmType:(*(device->irAlgorithm+row)).type FirstSecond:0 ValueType:1 IsIR:1];
    }
    
}


#pragma mark 切换前后视
- (void)frontRearViewChanged{
    [[NetworkFactory sharedNetWork] changeLayerAndView];
    [[NetworkFactory sharedNetWork]sendToGetDataIsIR:1];
}

@end
