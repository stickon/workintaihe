//
//  RiceView.m
//  thColorSort
//
//  Created by taihe on 2018/1/18.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "RiceView.h"
#import "tableViewCellValueChangedDelegate.h"
#import "TableViewCellWith1Label1Switch.h"
#import "TableViewCellWithDefaultTitleLabel1TextField.h"
static NSString *switchTableViewCell = @"TableViewCellWith1Label1Switch";
static NSString *cell1Label1TextFieldIdentify = @"TableViewCellWithDefaultTitleLabel1TextField";
@interface RiceView ()<UITableViewDataSource,UITableViewDelegate,TableViewCellChangedDelegate>
{
    BOOL dataLoaded;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;

@end
@implementation RiceView

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle]loadNibNamed:@"RiceView" owner:self options:nil] firstObject];
        [self initView];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}

-(UIView*)getViewWithPara:(NSDictionary *)para{
    dataLoaded = false;
    [[NetworkFactory sharedNetWork] getRice];
    return self;
}

-(void)initView{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:switchTableViewCell bundle:nil] forCellReuseIdentifier:switchTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:cell1Label1TextFieldIdentify bundle:nil] forCellReuseIdentifier:cell1Label1TextFieldIdentify];
    
    Device *device = kDataModel.currentDevice;
    if (device->machineData.layerNumber>1) {
        self.baseLayerLabel = self.currentLayerLabel;

    }else{
        self.currentLayerLabel.frame = CGRectZero;
        self.currentLayerLabelHeightConstraint.constant = 0.0f;
    }
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self initLanguage];
   
}

-(void)initLanguage{
    
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x16) {
        if (header[1] == 0x01) {
            dataLoaded = true;
        }else if (header[1] == 0x02){
            
        }
        [self.tableView reloadData];
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (header[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getRice];
    }
}

-(void)updateView{
    
}


#pragma tableview data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataLoaded) {
        return 2;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 2;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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
    }
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Device *device = kDataModel.currentDevice;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TableViewCellWith1Label1Switch *cell = [tableView dequeueReusableCellWithIdentifier:switchTableViewCell forIndexPath:indexPath];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.alignment = CellLabelCenterAlignMent;
            cell.titleTextLabel.text = kLanguageForKey(273);
            cell.titleTextLabel.textColor = [UIColor TaiheColor];
            if (device->riceShape.buttonUse[0] == 1) {
                [cell.switchBtn setOn:YES];
            }else{
                [cell.switchBtn setOn:NO];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if (indexPath.row == 1){
            TableViewCellWithDefaultTitleLabel1TextField *cell = [tableView dequeueReusableCellWithIdentifier:cell1Label1TextFieldIdentify forIndexPath:indexPath];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.textLabel.text =kLanguageForKey(14);
            NSInteger value = device->riceShape.textView[0][0]*256+device->riceShape.textView[0][1];
            cell.textField.text = [NSString stringWithFormat:@"%ld",(long)value];
            cell.cellType = TableViewCellType_RiceShapeSense1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 2){
            TableViewCellWithDefaultTitleLabel1TextField *cell = [tableView dequeueReusableCellWithIdentifier:cell1Label1TextFieldIdentify forIndexPath:indexPath];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.textLabel.text = kLanguageForKey(275);
            cell.cellType = TableViewCellType_RiceShapeLimit;
            NSInteger value = device->riceShape.textView[1][0]*256+device->riceShape.textView[1][1];
            cell.textField.text = [NSString stringWithFormat:@"%ld",(long)value];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            TableViewCellWith1Label1Switch *cell = [tableView dequeueReusableCellWithIdentifier:switchTableViewCell forIndexPath:indexPath];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.alignment = CellLabelCenterAlignMent;
            cell.titleTextLabel.text =kLanguageForKey(274);
            if (device->riceShape.buttonUse[1] == 1) {
                [cell.switchBtn setOn:YES];
            }else{
                [cell.switchBtn setOn:NO];
            }
            cell.titleTextLabel.textColor = [UIColor TaiheColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1){
            TableViewCellWithDefaultTitleLabel1TextField *cell = [tableView dequeueReusableCellWithIdentifier:cell1Label1TextFieldIdentify forIndexPath:indexPath];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.cellType = TableViewCellType_RiceShapeSense2;
            cell.textLabel.text = kLanguageForKey(14);;
            NSInteger value = device->riceShape.textView[2][0]*256+device->riceShape.textView[2][1];
            cell.textField.text = [NSString stringWithFormat:@"%ld",(long)value];
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

#pragma mark cell delegate
- (void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value{
    Device *device = kDataModel.currentDevice;
    if (section == 0) {
        if (row == 0) {
            [[NetworkFactory sharedNetWork] setRiceUseStateWithType:1];
        }else if (row == 1){
            device->riceShape.textView[0][0]= value/256;
            device->riceShape.textView[0][1]= value%256;
            [[NetworkFactory sharedNetWork] setRiceParaWithType:1 Value:value];
        }else if (row == 2){
            
            NSInteger senseValue = device->riceShape.textView[0][0]*256+device->riceShape.textView[0][1];
            
            if (value<=senseValue) {
                device->riceShape.textView[1][0] = value/256;
                device->riceShape.textView[1][1] = value%256;
                [[NetworkFactory sharedNetWork] setRiceParaWithType:2 Value:value];
            }else{
                [self makeToast:kLanguageForKey(313) duration:2.0 position:CSToastPositionCenter];
                [self.tableView reloadData];
            }
            
        }
    }else if (section == 1){
        if (row == 0) {
            [[NetworkFactory sharedNetWork] setRiceUseStateWithType:2];
        }else if (row == 1){
            device->riceShape.textView[2][0] = value/256;
            device->riceShape.textView[2][1] = value%256;
            [[NetworkFactory sharedNetWork] setRiceParaWithType:3 Value:value];
        }
    }
}

-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork] getRice];
}
@end
