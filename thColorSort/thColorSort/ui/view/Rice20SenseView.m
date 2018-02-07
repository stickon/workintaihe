//
//  Rice20SenseView.m
//  thColorSort
//
//  Created by taihe on 2018/2/6.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "Rice20SenseView.h"
@interface Rice20SenseView()<UITableViewDelegate,UITableViewDataSource>

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
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"ColorAlgorithmView" owner:self options:nil] firstObject];
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
    [[NetworkFactory sharedNetWork]sendToGetDataIsIR:0];
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
    [[NetworkFactory sharedNetWork]sendToGetDataIsIR:0];
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
    return 50;
}
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    Device *device = kDataModel.currentDevice;
    if (device->machineData.useColor) {
        return device.colorAlgorithmNums;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    Device *device = kDataModel.currentDevice;
    
    if (device->machineData.useColor) {
        if (indexPath.row<device.colorAlgorithmNums) {
            static NSString *cellIdentifier = @"TableViewCellWithDefaultTitleLabel1TextField";
            TableViewCellWithDefaultTitleLabel1TextField *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil]lastObject];
            }
            cell.textLabel.font = SYSTEMFONT_14f;
            if ((*(device->colorAlgorithm+indexPath.row)).used) {
                cell.textLabel.textColor = [UIColor redColor];
                cell.textField.enabled = YES;
            }else{
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textField.enabled = NO;
            }
            cell.textLabel.text =[NSString stringWithUTF8String:(*(device->colorAlgorithm+indexPath.row)).name];
            NSInteger sense = ((*(device->colorAlgorithm+indexPath.row)).sense[0])*256+(*(device->colorAlgorithm+indexPath.row)).sense[1];
            cell.textField.text = [NSString stringWithFormat:@"%lu",(long)sense];
            cell.indexPath = indexPath;
            cell.textField.tag = indexPath.section*1000+indexPath.row+1;
            cell.textField.font = SYSTEMFONT_14f;
            cell.delegate = self;
            if ((*(device->colorAlgorithm+indexPath.row)).type < 4 || (*(device->colorAlgorithm+indexPath.row)).type == 6) {
                cell.cellType = TableViewCellType_SenseType;
            }else{
                cell.cellType = TableViewCellType_ColorSense;
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    [self.paraNextView setObject:[NSString stringWithUTF8String:(*(device->colorAlgorithm+_selectIndexPath.row)).name]forKey:@"title"];
    [self.paraNextView setObject:[NSString stringWithFormat:@"%ld",(long)self.selectIndexPath.row] forKey:@"algorithmIndex"];
    if((*(device->colorAlgorithm+_selectIndexPath.row)).type<4){
        [[MiddleManager shareInstance] ChangeViewWithName:@"ColorAdvancedView" Para:self.paraNextView];
        
    }else if ((*(device->colorAlgorithm+_selectIndexPath.row)).type == 6){
        [[MiddleManager shareInstance] ChangeViewWithName:@"RestrainAdvancedView" Para:self.paraNextView];
    }else{
        [[MiddleManager shareInstance] ChangeViewWithName:@"DiffAdvancedView"Para:self.paraNextView];
    }
}


#pragma celldatachangeddelegate

-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value
{
    Device *device = kDataModel.currentDevice;
    NSUInteger oldValue =((*(device->colorAlgorithm+row)).sense[0])*256+(*(device->colorAlgorithm+row)).sense[1];
    if((NSUInteger)value >oldValue){
        [[NetworkFactory sharedNetWork]sendAlgorithmSenseValueWithAjustType:1 Sorter:0 data:value-oldValue algorithmType:(*(device->colorAlgorithm+row)).type FirstSecond:0 ValueType:1 IsIR:0];
    }else{
        [[NetworkFactory sharedNetWork]sendAlgorithmSenseValueWithAjustType:2 Sorter:0 data:oldValue-value algorithmType:(*(device->colorAlgorithm+row)).type FirstSecond:0 ValueType:1 IsIR:0];
    }
    
}


#pragma mark 切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [self initView];
    [[NetworkFactory sharedNetWork]sendToGetDataIsIR:0];
}

- (void)frontRearViewChanged{
    [[NetworkFactory sharedNetWork] changeLayerAndView];
    [[NetworkFactory sharedNetWork]sendToGetDataIsIR:0];
}
@end
