//
//  SoftwareVersionView.m
//  thColorSort
//
//  Created by taihe on 2018/1/15.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "SoftwareVersionView.h"
#import "LGJFoldHeaderView.h"
#import "TableViewCellWith2Label.h"
#import "TableViewCellWith4Label.h"
#import "TableViewCellWith5Label.h"
#import "TableViewCellWith7Label.h"
static NSString *NibNameTableViewCellWith5Label = @"TableViewCellWith5Label";
static NSString *CameraVersionCellIdentifier = @"CameraVersionCellIdentifier";
static NSString *IRCameraVersionCellIdentifier = @"IRCameraVersionCellIdentifier";

static NSString *BaseVersionCellIdentifier = @"TableViewCellWith2Label";
static NSString *ColorBoardCellIdentifier = @"TableViewCellWith4Label";

static NSString *NibNameTableViewCellWith7Label = @"TableViewCellWith7Label";
static NSString *VisiableTitleCellIdentifier = @"VisiableTitleCellIdentifier";
static NSString *InvisiableTitleCellIdentifier = @"InvisiableTitleCellIdentifier";
@interface SoftwareVersionView()<UITableViewDelegate,UITableViewDataSource,FoldSectionHeaderViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSDictionary* foldInfoDic;/**< 存储开关字典 */
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;

@end
@implementation SoftwareVersionView


-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"SoftwareVersionView" owner:self options:nil] firstObject];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        _foldInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"0":@"0",@"1":@"0",@"2":@"0",@"3":@"0",@"4":@"0",}];
        [self.tableView registerNib:[UINib nibWithNibName:NibNameTableViewCellWith5Label bundle:nil] forCellReuseIdentifier:CameraVersionCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:NibNameTableViewCellWith5Label bundle:nil] forCellReuseIdentifier:IRCameraVersionCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:BaseVersionCellIdentifier bundle:nil] forCellReuseIdentifier:BaseVersionCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:ColorBoardCellIdentifier bundle:nil] forCellReuseIdentifier:ColorBoardCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:NibNameTableViewCellWith7Label bundle:nil] forCellReuseIdentifier:VisiableTitleCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:NibNameTableViewCellWith7Label bundle:nil] forCellReuseIdentifier:InvisiableTitleCellIdentifier];
        //在创建talbleView的下方添加这两个if
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        self.title = kLanguageForKey(77);
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

-(void)updateWithHeader:(NSData*)headerData
{
    const char *a = headerData.bytes;
    if (a[0] == 0x0a) {
        int section = 0;
        if (a[1] == 1) {
            section = 0;
        }else if (a[1] == 2){
            section = 1;
        }else if (a[1] == 3){
            if (a[3] == 1) {
                section = 2;
            }else if (a[3] == 2){
                section = 3;
            }else if (a[3] == 3){
                section =4;
            }
        }
        NSString *key = [NSString stringWithFormat:@"%d",section];
        BOOL folded = [[_foldInfoDic objectForKey:key]boolValue];
        if (folded) {
            [self.tableView reloadData];
        }
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }
}

#pragma tableview datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 2||indexPath.section == 3||indexPath.section == 4)&&(indexPath.row == 0)) {
        return 70;
    }
    if (indexPath.section == 0) {//隐藏cell
        Device *device = kDataModel.currentDevice;
        if (indexPath.row == 3) {
            if (device->machineData.machineType != MACHINE_TYPE_WHEEL&& device->machineData.machineType != MACHINE_TYPE_WHEEL_2) {
                return 0;
            }
        }else if (indexPath.row == 4){
            if (device->machineData.useSensor == 0) {
                return 0;
            }
        }
    }
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    Device *device = kDataModel.currentDevice;
    if (device->machineData.useIR == 0) {
        return 3;
    }else if (device->machineData.useIR == 4 ||device->machineData.useIR == 5|| device->machineData.useIR == 6){
        return 5;
    }
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [NSString stringWithFormat:@"%d",(int)section];
    BOOL folded = [[_foldInfoDic objectForKey:key]boolValue];
    
    Device *device = kDataModel.currentDevice;
    if (section == 0) {
        return folded?6:0;
    }
    if (section == 1) {
        if (device->colorBoardVersion) {
            return folded?device->machineData.chuteNumber+1:0;
        }
        return 0;
    }
    if (section == 2) {
        if (device->normalCameraVersion) {
            return folded?device->machineData.chuteNumber+1:0;
        }
        return 0;
    }
    if (section == 3) {
        if (device->infraredCameraVersion) {
            return folded?device->machineData.chuteNumber+1:0;
        }
        return 0;
    }
    if (section == 4) {
        if (device->infraredCameraVersion2) {
            return folded?device->machineData.chuteNumber+1:0;
        }
        return 0;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString* foldheaderview = @"LGJFoldHeaderView";
    LGJFoldHeaderView *foldHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:foldheaderview];
    if (!foldHeaderView) {
        foldHeaderView = [[LGJFoldHeaderView alloc]initWithReuseIdentifier:foldheaderview];
    }
    if (section == 0) {
        NSString *baseVersionFoldHeaderTitle =kLanguageForKey(63);
        [foldHeaderView setFoldSectionHeaderViewWithTitle:baseVersionFoldHeaderTitle detail:@"" type:HerderStyleTotal section:section canFold:YES];
        [foldHeaderView.separateView setHidden:YES];
        
    }else if(section == 1)
    {
        NSString *colorBoardVersionFoldHeaderTitle = kLanguageForKey(64);
        [foldHeaderView setFoldSectionHeaderViewWithTitle:colorBoardVersionFoldHeaderTitle detail:@"" type:HerderStyleTotal section:section canFold:YES];
    }else if (section ==2)
    {
        NSString *nomalCameraVersionFoldHeaderTitle = kLanguageForKey(65);
        [foldHeaderView setFoldSectionHeaderViewWithTitle:nomalCameraVersionFoldHeaderTitle detail:@"" type:HerderStyleTotal section:section canFold:YES];
    }else if(section == 3){
        NSString *irCameraVerisonFoldHeaderTitle = kLanguageForKey(66);
        [foldHeaderView setFoldSectionHeaderViewWithTitle:irCameraVerisonFoldHeaderTitle detail:@"" type:HerderStyleTotal section:section canFold:YES];
    }else if(section == 4){
        NSString *irCameraVerisonFoldHeaderTitle = [NSString stringWithFormat:@"%@%d",kLanguageForKey(66),2];
        [foldHeaderView setFoldSectionHeaderViewWithTitle:irCameraVerisonFoldHeaderTitle detail:@"" type:HerderStyleTotal section:section canFold:YES];
    }
    
    foldHeaderView.delegate = self;
    NSString *key = [NSString stringWithFormat:@"%d",(int)section];
    BOOL folded = [[_foldInfoDic valueForKey:key]boolValue];
    foldHeaderView.fold = folded;
    return foldHeaderView;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *defaultCell = [[UITableViewCell alloc]init];
    Device *device = kDataModel.currentDevice;
    if(indexPath.section == 0)
    {
        TableViewCellWith2Label *cell = [tableView dequeueReusableCellWithIdentifier:BaseVersionCellIdentifier forIndexPath:indexPath];
        cell.baseVersionTypeLabel.textColor = [UIColor TaiheColor];
        if (indexPath.row == 0) {
            cell.baseVersionTypeLabel.text = kLanguageForKey(67);
            cell.baseVersionValueLabel.text = device.displayScreenVersion;
            DDLogInfo(@"displayversion:%@",device.displayScreenVersion);
        }else if(indexPath.row ==1){
            cell.baseVersionTypeLabel.text = kLanguageForKey(68);
            float baseVersionControl = ((float)(device->baseVersion.control[0])*256+(float)(device->baseVersion.control[1]))/100.0;
            cell.baseVersionValueLabel.text = [NSString stringWithFormat:@"%.2f",baseVersionControl];
        }else if(indexPath.row == 2){
            cell.baseVersionTypeLabel.text = kLanguageForKey(69);
            float baseVersionConvert =((float)(device->baseVersion.led[0])*256+(float)(device->baseVersion.led[1]))/100.0;
            cell.baseVersionValueLabel.text = [NSString stringWithFormat:@"%.2f",baseVersionConvert];
        }else if(indexPath.row == 3){
            if (device->machineData.machineType== MACHINE_TYPE_WHEEL||device->machineData.machineType== MACHINE_TYPE_WHEEL_2) {
                
                cell.baseVersionTypeLabel.text = kLanguageForKey(70);
                float baseVersionLed =((float)(device->baseVersion.wheel[0])*256+(float)(device->baseVersion.wheel[1]))/100.0;
                cell.baseVersionValueLabel.text = [NSString stringWithFormat:@"%.2f",baseVersionLed];                cell.hidden = NO;
            }else{
                cell.hidden = YES;
                cell.frame = CGRectZero;
            }
        }else if(indexPath.row == 4){
            if(device->machineData.useSensor){
                cell.baseVersionTypeLabel.text = kLanguageForKey(71);
                float baseVersionSensor =((float)(device->baseVersion.sensor[0])*256+(float)(device->baseVersion.sensor[1]))/100.0;
                cell.baseVersionValueLabel.text = [NSString stringWithFormat:@"%.2f",baseVersionSensor];
                cell.hidden = NO;
            }else{
                cell.hidden = YES;
                cell.frame = CGRectZero;
            }
        }else if (indexPath.row == 5){
            cell.baseVersionTypeLabel.text = kLanguageForKey(78);
            float baseVersionSensor =((float)(device->baseVersion.convert[0])*256+(float)(device->baseVersion.convert[1]))/100.0;
            cell.baseVersionValueLabel.text = [NSString stringWithFormat:@"%.2f",baseVersionSensor];
        }
        return cell;
    }
    if (indexPath.section == 1) {
        TableViewCellWith4Label *cell = [tableView dequeueReusableCellWithIdentifier:ColorBoardCellIdentifier forIndexPath:indexPath];
        if(indexPath.row == 0)
        {
            cell.chuteTitleLabel.text = kLanguageForKey(41);
            cell.armVersionTitleLabel.text = kLanguageForKey(72);
            cell.fpgaVersionTitleLabel.text = kLanguageForKey(73);
            cell.hardwareVersionTitleLabel.text = kLanguageForKey(74);
            cell.chuteTitleLabel.textColor = [UIColor TaiheColor];
            cell.armVersionTitleLabel.textColor = [UIColor TaiheColor];
            cell.fpgaVersionTitleLabel.textColor = [UIColor TaiheColor];
            cell.hardwareVersionTitleLabel.textColor = [UIColor TaiheColor];
        }
        else
        {
            int index = (int)indexPath.row;
            cell.chuteTitleLabel.text = [NSString stringWithFormat:@"%d", index];
            NSUInteger arm1 = device->colorBoardVersion[index-1].arm[0];
            NSUInteger arm2 = device->colorBoardVersion[index-1].arm[1];
            NSUInteger fpga1 = device->colorBoardVersion[index-1].fpga[0];
            NSUInteger fpga2 = device->colorBoardVersion[index-1].fpga[1];
            float armversion =((arm1<<8)|arm2)/100.0;
            float fpgaversion = (fpga1<<8|fpga2)/100.0;
            cell.armVersionTitleLabel.text = [NSString stringWithFormat:@"%.2f",armversion];
            cell.fpgaVersionTitleLabel.text = [NSString stringWithFormat:@"%.2f",fpgaversion];
            cell.hardwareVersionTitleLabel.text = [NSString stringWithFormat:@"%x%x",device->colorBoardVersion[index-1].hardware[0],device->colorBoardVersion[index-1].hardware[1]];
        }
        return cell;
    }
    if (indexPath.section == 2) {
        
        if(indexPath.row == 0)
        {
            TableViewCellWith7Label *cell = [tableView dequeueReusableCellWithIdentifier:VisiableTitleCellIdentifier forIndexPath:indexPath];
            cell.chuteTitleLabel.text = kLanguageForKey(41);
            cell.frontTitleLabel.text = kLanguageForKey(75);
            
            if (device->machineData.hasRearView[device.currentLayerIndex-1]) {
                cell.rearTitleLabel.hidden = NO;
                cell.rearSoftwareTitleLabel.hidden = NO;
                cell.rearHardwareTitleLabel.hidden = NO;
                cell.rearTitleLabel.text = kLanguageForKey(76);
                
                cell.rearSoftwareTitleLabel.text = kLanguageForKey(77);
                cell.rearHardwareTitleLabel.text = kLanguageForKey(74);
            }else{
                cell.rearTitleLabel.hidden = YES;
                cell.rearSoftwareTitleLabel.hidden = YES;
                cell.rearHardwareTitleLabel.hidden = YES;
            }
            cell.frontSoftwareTitleLabel.text = kLanguageForKey(77);
            cell.frontHardwareTitleLabel.text = kLanguageForKey(74);
            cell.chuteTitleLabel.textColor = [UIColor TaiheColor];
            cell.frontTitleLabel.textColor = [UIColor TaiheColor];
            cell.rearTitleLabel.textColor = [UIColor TaiheColor];
            cell.frontSoftwareTitleLabel.textColor = [UIColor TaiheColor];
            cell.frontHardwareTitleLabel.textColor = [UIColor TaiheColor];
            cell.rearSoftwareTitleLabel.textColor = [UIColor TaiheColor];
            cell.rearHardwareTitleLabel.textColor = [UIColor TaiheColor];
            return cell;
        }else{
            TableViewCellWith5Label *cell = [tableView dequeueReusableCellWithIdentifier:CameraVersionCellIdentifier forIndexPath:indexPath];
            int index = (int)indexPath.row;
            cell.chuteIndexLabel.text = [NSString stringWithFormat:@"%d",index];
            cell.label1.text = [NSString stringWithFormat:@"%d",device->normalCameraVersion[index-1].front_software[1]];
            cell.label2.text = [NSString stringWithFormat:@"%x%x",device->normalCameraVersion[index-1].front_hardware[0],device->normalCameraVersion[index-1].front_hardware[1]];
            if (device->machineData.hasRearView[device.currentLayerIndex-1]) {
                cell.label3.hidden = NO;
                cell.label4.hidden = NO;
                cell.label3.text = [NSString stringWithFormat:@"%d",device->normalCameraVersion[index-1].rear_software[1]];
                cell.label4.text = [NSString stringWithFormat:@"%x%x",device->normalCameraVersion[index-1].rear_hardware[0],device->normalCameraVersion[index-1].rear_hardware[1]];
            }else{
                cell.label3.hidden = YES;
                cell.label4.hidden = YES;
            }
            return cell;
        }
        
    }
    if (indexPath.section == 3) {
        if(indexPath.row == 0)
        {
            TableViewCellWith7Label *cell = [tableView dequeueReusableCellWithIdentifier:InvisiableTitleCellIdentifier forIndexPath:indexPath];
            cell.chuteTitleLabel.text = kLanguageForKey(41);
            cell.frontTitleLabel.text = kLanguageForKey(75);
            cell.rearTitleLabel.text = kLanguageForKey(76);
            cell.rearTitleLabel.text = kLanguageForKey(77);
            cell.frontHardwareTitleLabel.text = kLanguageForKey(74);
            cell.rearSoftwareTitleLabel.text = kLanguageForKey(77);
            cell.rearHardwareTitleLabel.text = kLanguageForKey(74);
            cell.chuteTitleLabel.textColor = [UIColor TaiheColor];
            cell.frontTitleLabel.textColor = [UIColor TaiheColor];
            cell.rearTitleLabel.textColor = [UIColor TaiheColor];
            cell.frontSoftwareTitleLabel.textColor = [UIColor TaiheColor];
            cell.frontHardwareTitleLabel.textColor = [UIColor TaiheColor];
            cell.rearSoftwareTitleLabel.textColor = [UIColor TaiheColor];
            cell.rearHardwareTitleLabel.textColor = [UIColor TaiheColor];
            if ([self getFrontRearShowTypeByIRType:device->machineData.useIR]== 0) {
                [cell.rearTitleLabel setHidden:YES];
                [cell.rearSoftwareTitleLabel setHidden:YES];
                [cell.rearHardwareTitleLabel setHidden:YES];
            }else if ([self getFrontRearShowTypeByIRType:device->machineData.useIR] == 1){
                [cell.frontTitleLabel setHidden:YES];
                [cell.frontSoftwareTitleLabel setHidden:YES];
                [cell.frontHardwareTitleLabel setHidden:YES];
            }
            return cell;
            
        }else{
            TableViewCellWith5Label *cell = [tableView dequeueReusableCellWithIdentifier:IRCameraVersionCellIdentifier forIndexPath:indexPath];
            int index = (int)indexPath.row;
            cell.chuteIndexLabel.text = [NSString stringWithFormat:@"%d",index];
            cell.label1.text = [NSString stringWithFormat:@"%d",device->infraredCameraVersion[index-1].front_software[1]];
            cell.label2.text = [NSString stringWithFormat:@"%x%x",device->infraredCameraVersion[index-1].front_hardware[0],device->infraredCameraVersion[index-1].front_hardware[1]];
            cell.label3.text = [NSString stringWithFormat:@"%d",device->infraredCameraVersion[index-1].rear_software[1]];
            cell.label4.text = [NSString stringWithFormat:@"%x%x",device->infraredCameraVersion[index-1].rear_hardware[0],device->infraredCameraVersion[index-1].rear_hardware[1]];
            if ([self getFrontRearShowTypeByIRType:device->machineData.useIR]== 0) {
                [cell.label3 setHidden:YES];
                [cell.label4 setHidden:YES];
            }else if ([self getFrontRearShowTypeByIRType:device->machineData.useIR] == 1){
                [cell.label1 setHidden:YES];
                [cell.label2 setHidden:YES];
            }
            return cell;
        }
    }
    if (indexPath.section == 4) {
        if(indexPath.row == 0)
        {
            TableViewCellWith7Label *cell = [tableView dequeueReusableCellWithIdentifier:InvisiableTitleCellIdentifier forIndexPath:indexPath];
            cell.chuteTitleLabel.text = kLanguageForKey(41);
            cell.frontTitleLabel.text = kLanguageForKey(75);
            cell.rearTitleLabel.text = kLanguageForKey(76);
            cell.rearTitleLabel.text = kLanguageForKey(77);
            cell.frontHardwareTitleLabel.text = kLanguageForKey(74);
            cell.rearSoftwareTitleLabel.text = kLanguageForKey(77);
            cell.rearHardwareTitleLabel.text = kLanguageForKey(74);
            cell.chuteTitleLabel.textColor = [UIColor TaiheColor];
            cell.frontTitleLabel.textColor = [UIColor TaiheColor];
            cell.rearTitleLabel.textColor = [UIColor TaiheColor];
            cell.frontSoftwareTitleLabel.textColor = [UIColor TaiheColor];
            cell.frontHardwareTitleLabel.textColor = [UIColor TaiheColor];
            cell.rearSoftwareTitleLabel.textColor = [UIColor TaiheColor];
            cell.rearHardwareTitleLabel.textColor = [UIColor TaiheColor];
            if ([self getFrontRearShowTypeByIRType:device->machineData.useIR]== 0) {
                [cell.rearTitleLabel setHidden:YES];
                [cell.rearSoftwareTitleLabel setHidden:YES];
                [cell.rearHardwareTitleLabel setHidden:YES];
            }else if ([self getFrontRearShowTypeByIRType:device->machineData.useIR] == 1){
                [cell.frontTitleLabel setHidden:YES];
                [cell.frontSoftwareTitleLabel setHidden:YES];
                [cell.frontHardwareTitleLabel setHidden:YES];
            }
            return cell;
        }else{
            TableViewCellWith5Label *cell = [tableView dequeueReusableCellWithIdentifier:IRCameraVersionCellIdentifier forIndexPath:indexPath];
            int index = (int)indexPath.row;
            cell.chuteIndexLabel.text = [NSString stringWithFormat:@"%d",index];
            cell.label1.text = [NSString stringWithFormat:@"%d",device->infraredCameraVersion2[index-1].front_software[1]];
            cell.label2.text = [NSString stringWithFormat:@"%x%x",device->infraredCameraVersion2[index-1].front_hardware[0],device->infraredCameraVersion2[index-1].front_hardware[1]];
            cell.label3.text = [NSString stringWithFormat:@"%d",device->infraredCameraVersion2[index-1].rear_software[1]];
            cell.label4.text = [NSString stringWithFormat:@"%x%x",device->infraredCameraVersion2[index-1].rear_hardware[0],device->infraredCameraVersion2[index-1].rear_hardware[1]];
            if ([self getFrontRearShowTypeByIRType:device->machineData.useIR]== 0) {
                [cell.label3 setHidden:YES];
                [cell.label4 setHidden:YES];
            }else if ([self getFrontRearShowTypeByIRType:device->machineData.useIR] == 1){
                [cell.label1 setHidden:YES];
                [cell.label2 setHidden:YES];
            }
            return cell;
        }
    }
    return defaultCell;
}

#pragma foldsectiondelegate

-(void)foldHeaderInSection:(NSInteger)SectionHeader
{
    NSString *key = [NSString stringWithFormat:@"%d",(int)SectionHeader];
    BOOL folded = [[_foldInfoDic objectForKey:key]boolValue];
    NSString *fold = folded?@"0":@"1";
    [_foldInfoDic setValue:fold forKey:key];
    if (!folded) {
        if (SectionHeader == 0) {
            [[NetworkFactory sharedNetWork] getVersionWithType:1 CameraType:0];
        }
        if (SectionHeader == 1) {
            [[NetworkFactory sharedNetWork] getVersionWithType:2 CameraType:0];
            
        }
        if (SectionHeader == 2) {
            [[NetworkFactory sharedNetWork] getVersionWithType:3 CameraType:1];
        }
        if (SectionHeader == 3) {
            [[NetworkFactory sharedNetWork] getVersionWithType:3 CameraType:2];
        }
        if (SectionHeader == 4) {
            [[NetworkFactory sharedNetWork] getVersionWithType:3 CameraType:3];
        }
    }else{
        [self.tableView reloadData];
    }
}

//实现tableview的代理方法
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

//隐藏表视图多余单元格的分割线，此方法在创建talbeview的后面调用
- (void)setExtraCellLineHidden: (UITableView *)tableView

{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:view];
}
//return
//0 前视
//1 后视
//2 前后视
//3 无红外
-(NSInteger)getFrontRearShowTypeByIRType:(Byte)irType{
    if (irType == 1|| irType == 4 || irType == 7) {
        return 0;
    }else if (irType == 2|| irType == 5 ||irType == 8){
        return 1;
    }else if (irType == 3|| irType == 6 || irType == 9){
        return 2;
    }
    return 3;
}

-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    for (int i =0;i<_foldInfoDic.count;i++) {
        static NSString *fold = @"0";
        [_foldInfoDic setValue:fold forKey:[NSString stringWithFormat:@"%d",i]];
    }
    [self.tableView reloadData];
}
@end
