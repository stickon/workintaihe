//
//  ValveSetView.m
//  thColorSort
//
//  Created by taihe on 2018/1/16.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "ValveSetView.h"
#import "valveTableViewCell.h"
#import "valveTitleTableViewCell.h"
#import "TableViewCellWithDefaultTitleLabel1TextField.h"
#import "TableViewCellWithDefaultTitleLabelAndUICombobox.h"
static NSString *valveTitleCellIdentifier = @"valveTitleTableViewCell";
static NSString *valveCellIdentifier = @"valveTableViewCell";
static NSString *valveWorkModeCellIdentifier = @"TableViewCellWithDefaultTitleLabelAndUICombobox";
static NSString *valveOpenTimeCellIdentifier = @"TableViewCellWithDefaultTitleLabel1TextField";
@interface ValveSetView()<UITableViewDelegate,UITableViewDataSource,TableViewCellChangedDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *valveType;
@property (nonatomic,assign) BOOL loadComplete;
@property (strong, nonatomic) NSIndexPath *selectPath;
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;

@end

@implementation ValveSetView
-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"ValveSetView" owner:self options:nil] firstObject];
        
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerNib:[UINib nibWithNibName:valveCellIdentifier bundle:nil] forCellReuseIdentifier:valveCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:valveTitleCellIdentifier bundle:nil] forCellReuseIdentifier:valveTitleCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:valveOpenTimeCellIdentifier bundle:nil] forCellReuseIdentifier:valveOpenTimeCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:valveWorkModeCellIdentifier bundle:nil] forCellReuseIdentifier:valveWorkModeCellIdentifier];
        self.loadComplete = false;
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [[NetworkFactory sharedNetWork]getValvePara];
        self.title = kLanguageForKey(18);
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
-(UIView *)getViewWithPara:(NSDictionary *)para{
    [[NetworkFactory sharedNetWork] changeLayerAndView];
    return self;
}
- (void)refreshCurrentView{
   [[NetworkFactory sharedNetWork]getValvePara];
}
-(void)updateWithHeader:(NSData*)headerData
{
    self.loadComplete = true;
    const Byte* a = headerData.bytes;
    if (a[0]== 0x09 && (a[1] == 0x01)) {
        [self.tableView reloadData];
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [self refreshCurrentView];
    }
}

#pragma tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Device *device = kDataModel.currentDevice;
    if (device) {
        if (section == 0) {
            if (self.loadComplete) {
                return device->machineData.chuteNumber+1;
            }
            return 1;
            
        }
        if (section == 1) {
            return 1;
        }
        if (section == 2) {
            return 1;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Device *device = kDataModel.currentDevice;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            valveTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:valveTitleCellIdentifier forIndexPath:indexPath];
            cell.chuteTitleLabel.text =  kLanguageForKey(41);
            cell.delayTimeTitleLabel.text =  kLanguageForKey(57);
            cell.blowTimeTitleLabel.text =  kLanguageForKey(58);
            cell.ejectTypeTitleLabel.text =  kLanguageForKey(59);
            cell.centerPointTitleLabel.text =  kLanguageForKey(60);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            if (device->machineData.chuteNumber>0) {
                valveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:valveCellIdentifier forIndexPath:indexPath];
                NSInteger index = indexPath.row-1;
                cell.chuteNumLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                cell.chuteNumLabel.font = SYSTEMFONT_14f;
                cell.textLabel.textColor = [UIColor TaiheColor];
                cell.delayTimeTextField.text =[NSString stringWithFormat:@"%d",device->delayTime[index]];
                cell.delayTimeTextField.font = SYSTEMFONT_14f;
                cell.blowTimeTextField.text = [NSString stringWithFormat:@"%d",device->blowTime[index]];
                cell.blowTimeTextField.font = SYSTEMFONT_14f;
                cell.ejectTypeSegmentedControl.selectedSegmentIndex = device->ejectorType[index];
                cell.delegate = self;
                cell.indexPath = indexPath;
                cell.delayTimeTextField.tag = 3;
                cell.blowTimeTextField.tag = 4;
                cell.ejectTypeSegmentedControl.tag = 5;
                cell.centerPointSwitch.tag = 6;
                if (device->bUseCenterPoint[index]) {
                    [cell.centerPointSwitch setOn:true];
                }
                else
                    [cell.centerPointSwitch setOn:false];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }else if(indexPath.section == 1)
    {
        TableViewCellWithDefaultTitleLabelAndUICombobox *cell = [tableView dequeueReusableCellWithIdentifier:valveWorkModeCellIdentifier forIndexPath:indexPath];
        NSArray *workModeArray = @[kLanguageForKey(51),kLanguageForKey(52),kLanguageForKey(53),kLanguageForKey(54)];
        cell.valveWorkModeComboBox.entries = workModeArray;
        cell.valveWorkModeComboBox.tableViewOnAbove = YES;
        [cell.valveWorkModeComboBox setFont:[UIFont systemFontOfSize:13.0f]];
        cell.textLabel.text =  kLanguageForKey(55);
        cell.textLabel.font = SYSTEMFONT_14f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        cell.valveWorkModeComboBox.tag = 2;
        cell.valveWorkModeComboBox.selectedItem =device->valvePara.valveWorkMode;
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 2)
    {
        TableViewCellWithDefaultTitleLabel1TextField *cell = [tableView dequeueReusableCellWithIdentifier:valveOpenTimeCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text =  kLanguageForKey(56);
        cell.textLabel.font = SYSTEMFONT_14f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        cell.textField.text =[NSString stringWithFormat:@"%d",device->valvePara.openValveTime];
        cell.indexPath = [indexPath copy];
        cell.textField.tag = 1;
        cell.delegate = self;
        cell.cellType = TableViewCellType_ValveOpenTime;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    UITableViewCell *defaultCell = [[UITableViewCell alloc]init];
    return defaultCell;
}

#pragma tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value
{
    Device *device = kDataModel.currentDevice;
    Byte data[4]= {0};
    data[0]=device.currentLayerIndex;
    data[1]= row-1;
    data[2]= index;
    data[3] = value;
    [[NetworkFactory sharedNetWork] setValveParaWithData:data];
    
}

#pragma mark 切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork]getValvePara];
}
@end
