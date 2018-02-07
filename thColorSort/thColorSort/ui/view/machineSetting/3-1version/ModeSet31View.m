//
//  ModeSet31View.m
//  thColorSort
//
//  Created by taihe on 2018/1/16.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "ModeSet31View.h"
#import "TableViewCellWithDefaultTitleLabel1Switch.h"
#import "TableViewCellWith1Label1Switch.h"
#import "UITableViewHeaderFooterViewWith1Switch.h"

#import "TableViewCellWith1Segment1Label.h"
#import "LGJFoldHeaderView.h"
#import "TipsView.h"
#import "SelectItemTableView.h"
static NSString *switchTableViewCell = @"TableViewCellWith1Label1Switch";
static NSString *headerViewIdentifier = @"rowHeaderViewCellIdentifier";
static NSString *segmentedTableViewCellIdentifier = @"TableViewCellWith1Segment1Label";
static NSString *foldHeaderViewIdentifier = @"LGJFoldHeaderView";
static NSString *defaultTitleWith1SwitchTableViewCell = @"TableViewCellWithDefaultTitleLabel1Switch";

@interface ModeSet31View()<UITableViewDelegate,UITableViewDataSource,SwitchHeaderViewDelegate,TableViewCellChangedDelegate,FoldSectionHeaderViewDelegate,TipsViewResultDelegate,SelectItemDelegate>
{
    Mode *mode;
    BOOL isLoadDataComplete;//数据是否通过网络获取到
}
@property (assign,nonatomic) Byte modeIndex;
@property (assign,nonatomic) Byte bigModeIndex;
@property (strong, nonatomic) TipsView *tipsView;
@property (strong, nonatomic) SelectItemTableView *selectItemView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign,nonatomic) Byte frontRearInCommon;// 1 true  0 false
@property (assign,nonatomic) Byte tempUseSvm;//是否使用svm
@property (assign,nonatomic) Byte tempUseHsv;
@property (assign,nonatomic) Byte tempShapeIndex;//形选索引（暂时不提供更改)
@property (nonatomic,strong) NSIndexPath* selectIndexPath;
@property(nonatomic, strong) NSDictionary* foldInfoDic;/**< 存储开关字典 */
@property (strong,nonatomic) NSArray* colorDiffArray;
@property (strong,nonatomic) NSArray* colorArray;
@property (strong,nonatomic) NSArray* irArray;
@property (strong,nonatomic) NSArray* irDiffArray;
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerHeightconstraint;
@property (strong, nonatomic) IBOutlet UIButton *applyBtn;
@end



@implementation ModeSet31View

-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"ModeSet31View" owner:self options:nil] firstObject];
        
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        mode = NULL;
        isLoadDataComplete = false;
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerNib:[UINib nibWithNibName:switchTableViewCell bundle:nil] forCellReuseIdentifier:switchTableViewCell];
        [self.tableView registerNib:[UINib nibWithNibName:switchTableViewCell bundle:nil] forCellReuseIdentifier:headerViewIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:segmentedTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:segmentedTableViewCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:defaultTitleWith1SwitchTableViewCell bundle:nil] forCellReuseIdentifier:defaultTitleWith1SwitchTableViewCell];
        
        Device *device = kDataModel.currentDevice;
        if (device->machineData.layerNumber>1) {
            self.baseLayerLabel = self.currentLayerLabel;
        }else{
            self.currentLayerLabel.frame = CGRectZero;
            self.currentLayerHeightconstraint.constant = 0.0;
        }
        
    }
    return self;
}
-(UIView*)getViewWithPara:(NSDictionary *)para{
    if (para) {
        NSString *bigModeIndex = [para valueForKey:@"bigModeIndex"];
        self.bigModeIndex = bigModeIndex.intValue;
        NSString *smallModeIndex = [para valueForKey:@"smallModeIndex"];
        self.modeIndex = smallModeIndex.intValue;
    }
    [self initView];
    [self initLanguage];
    return self;
}
- (void)initView{
    Device *device = kDataModel.currentDevice;
    if (self.modeIndex == device->machineData.sortModeSmall && self.bigModeIndex == device->machineData.sortModeBig) {
        [self.applyBtn setEnabled:true];
    }else{
        [self.applyBtn setEnabled:false];
    }
    [[NetworkFactory sharedNetWork]getModeSettingWithIndex:self.modeIndex BigModeIndex:self.bigModeIndex];
}
- (void)initLanguage{
    [super initLanguage];
    [self.applyBtn setTitle:kLanguageForKey(113) forState:UIControlStateNormal];
    
    _foldInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"1":@"0",@"2":@"0",}];
    
    NSString *redThanGreen = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(47),kLanguageForKey(49)];
    NSString *redThanBlue = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(47),kLanguageForKey(48)];
    NSString *greenThanRed = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(49),kLanguageForKey(47)];
    NSString *greenThanBlue = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(49),kLanguageForKey(48)];
    NSString *blueThanRed = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(48),kLanguageForKey(47)];
    NSString *blueThanGreen = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(48),kLanguageForKey(49)];
    _colorDiffArray = @[redThanGreen,redThanBlue,greenThanRed,greenThanBlue,blueThanRed,blueThanGreen];
    
    NSString *redGreen = [NSString stringWithFormat:@"%@+%@",kLanguageForKey(47),kLanguageForKey(49)];
    NSString *redBlue = [NSString stringWithFormat:@"%@+%@",kLanguageForKey(47),kLanguageForKey(48)];
    NSString *greenBlue = [NSString stringWithFormat:@"%@+%@",kLanguageForKey(49),kLanguageForKey(48)];
    NSString *redGreenBlue = [NSString stringWithFormat:@"%@+%@+%@",kLanguageForKey(47),kLanguageForKey(49),kLanguageForKey(48)];
    _colorArray = @[kLanguageForKey(47),kLanguageForKey(49),kLanguageForKey(48),redGreen,redBlue,greenBlue,redGreenBlue];
    NSString *irstring1 = [NSString stringWithFormat:@"%@%d",kLanguageForKey(104),1];
    NSString *irstring2 = [NSString stringWithFormat:@"%@%d",kLanguageForKey(104),2];
    _irArray = @[irstring1,irstring2];
    NSString *irCompareString1 = [NSString stringWithFormat:@"%@>%@",irstring1,irstring2];
    NSString *irCompareString2 = [NSString stringWithFormat:@"%@<%@",irstring1,irstring2];
    _irDiffArray = @[irCompareString1,irCompareString2];
}
- (void)updateWithHeader:(NSData *)headerData{
    const unsigned char *a  = headerData.bytes;
    if (a[0] == 0x0d) {
        if (a[1] == 0x04) {
            if (a[2] == 1) {
                [gNetwork getCurrentDeviceInfo];
                [self makeToast: kLanguageForKey(91) duration:2.0 position:CSToastPositionCenter];
            }else{
                [self makeToast: kLanguageForKey(92) duration:2.0 position:CSToastPositionCenter];
            }
            [[NetworkFactory sharedNetWork] getModeSettingWithIndex:self.modeIndex BigModeIndex:self.bigModeIndex];
        }else if(a[1] == 0x03){
            Device *device = kDataModel.currentDevice;
            if (!mode) {
                mode = malloc(device->machineData.layerNumber*sizeof(Mode));
            }
            memcpy(mode, device->mode, device->machineData.layerNumber*sizeof(Mode));
            self.tempUseSvm = device->useSvm;
            self.tempShapeIndex = device->shape;
            self.tempUseHsv = device->useHsv;
            isLoadDataComplete = true;
            [self.tableView reloadData];
        }
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getModeSettingWithIndex:self.modeIndex BigModeIndex:self.bigModeIndex];
    }
}

- (IBAction)btnClicked:(UIButton *)sender {
    Device *device = kDataModel.currentDevice;
    
    if (sender.tag == 100) {
        if (device->machineData.startState == 1) {
            [self makeToast:kLanguageForKey(93) duration:2.0 position:CSToastPositionCenter];
        }else
            [[NetworkFactory sharedNetWork] changeModeSettingWithMode:(Byte*)mode shape:_tempShapeIndex svm:_tempUseSvm hsv:self.tempUseHsv];
    }
}

#pragma mark - tableview datasource
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y > 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else if (scrollView.contentOffset.y >= sectionHeaderHeight){
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 6 ||section == 5) {
        return 0;
    }else
        return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LGJFoldHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:foldHeaderViewIdentifier];
    if (!header) {
        header = [[LGJFoldHeaderView alloc]initWithReuseIdentifier:foldHeaderViewIdentifier];
    }
    if (section == 1) {
        NSString *normalCameraTitle =kLanguageForKey(175);
        [header setFoldSectionHeaderViewWithTitle:normalCameraTitle detail:@"" type:HerderStyleTotal section:section canFold:YES];
        
    }else if (section == 2) {
        NSString *irCameraTitle = kLanguageForKey(176);
        [header setFoldSectionHeaderViewWithTitle:irCameraTitle detail:@"" type:HerderStyleTotal section:section canFold:YES];
    }
    else{
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
        }
        return headerView;
    }
    header.delegate = self;
    NSString *key = [NSString stringWithFormat:@"%d",(int)section];
    BOOL folded = [[_foldInfoDic valueForKey:key]boolValue];
    header.fold = folded;
    return header;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    Device *device = kDataModel.currentDevice;
    if (isLoadDataComplete) {
        NSInteger section = 2;
        if (device->machineData.useIR) {
            section++;
        }
        return section;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = [NSString stringWithFormat:@"%d",(int)section];
    BOOL folded = [[_foldInfoDic objectForKey:key]boolValue];
    
    Device *device = kDataModel.currentDevice;
    if (section == 0) {
        if (device->machineData.hasRearView[device.currentLayerIndex-1]) {
            return 5;
        }else
            return 3;
    }else if(section == 1){
        return folded?19:0;
    }else if (section == 2 ){
        NSInteger rowCount;
        if (device->machineData.useIR<4) {//单红外
            rowCount = 3;
        }else{
            rowCount =6;
        }
        return folded?rowCount:0;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Device *device = kDataModel.currentDevice;
    int viewIndex = device.currentViewIndex;
    int layerIndex = device.currentLayerIndex-1;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = kLanguageForKey(115);
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            if (self.tempShapeIndex>=0 &&self.tempShapeIndex<=18) {
                cell.detailTextLabel.text = [self.shapeArray objectAtIndex:self.tempShapeIndex];
            }else{
                [self makeToast:@"shape index error" duration:2.0 position:CSToastPositionCenter];
            }
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
            cell.detailTextLabel.textColor = [UIColor redColor];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            TableViewCellWithDefaultTitleLabel1Switch *cell = [tableView  dequeueReusableCellWithIdentifier:defaultTitleWith1SwitchTableViewCell forIndexPath:indexPath];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.textLabel.font = [UIFont systemFontOfSize:14.0];
            cell.textLabel.textColor = [UIColor blackColor];
            if (indexPath.row == 1) {
                cell.textLabel.text = kLanguageForKey(31);
                NSLog(@"tempusesvm:%d",self.tempUseSvm);
                [cell.switchBtn setOn:self.tempUseSvm];
            }
            else if (indexPath.row == 2) {
                cell.textLabel.text =  kLanguageForKey(114);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.switchBtn setOn:mode[layerIndex].FrontRearRelation];
            }else if(indexPath.row == 3){
                cell.textLabel.text =  kLanguageForKey(43);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.switchBtn setOn:self.frontRearInCommon];
            }else if (indexPath.row == 4){
                cell.textLabel.text = kLanguageForKey(338);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.switchBtn setOn:self.tempUseHsv];
            }
            return cell;
        }
        
    }else if(indexPath.section == 1){//可见算法
        if (indexPath.row == 0) {
            TableViewCellWith1Segment1Label *frontRearViewCell = [tableView dequeueReusableCellWithIdentifier:segmentedTableViewCellIdentifier forIndexPath:indexPath];
            frontRearViewCell.delegate = self;
            frontRearViewCell.indexPath = indexPath;
            if (device->machineData.hasRearView[device.currentLayerIndex-1]) {//前后视都有
                [frontRearViewCell.frontRearViewSegmentedControl setHidden:NO];
                [frontRearViewCell.frontViewLabel setHidden:YES];
                [frontRearViewCell.frontRearViewSegmentedControl setTitle:kLanguageForKey(75) forSegmentAtIndex:0];
                [frontRearViewCell.frontRearViewSegmentedControl setTitle:kLanguageForKey(76) forSegmentAtIndex:1];
            }else{//没有后视
                [frontRearViewCell.frontRearViewSegmentedControl setHidden:YES];
                [frontRearViewCell.frontViewLabel setHidden:NO];
                frontRearViewCell.frontViewLabel.text = kLanguageForKey(75);
            }
            frontRearViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return frontRearViewCell;
        }else if (indexPath.row == 1 ||indexPath.row == 5 ||indexPath.row ==9|| indexPath.row == 12 || indexPath.row == 15) {
            TableViewCellWith1Label1Switch *cell = [tableView dequeueReusableCellWithIdentifier:headerViewIdentifier forIndexPath:indexPath];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.alignment = CellLabelCenterAlignMent;
            cell.titleTextLabel.textColor = [UIColor TaiheColor];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 1) {
                [cell.switchBtn setHidden:YES];
                cell.titleTextLabel.text = kLanguageForKey(122);
            }else if (indexPath.row == 5){
                [cell.switchBtn setHidden:YES];
                cell.titleTextLabel.text = kLanguageForKey(123);
            }else if (indexPath.row == 9){
                [cell.switchBtn setHidden:NO];
                [cell setSwitchBtnState:mode[layerIndex].diff1[viewIndex][0]];
                NSString *title = [NSString stringWithFormat:@"%@%d",kLanguageForKey(120),1];
                cell.titleTextLabel.text = title;
            }else if (indexPath.row == 12){
                [cell.switchBtn setHidden:NO];
                [cell setSwitchBtnState:mode[layerIndex].diff2[viewIndex][0]];
                NSString *title = [NSString stringWithFormat:@"%@%d",kLanguageForKey(120),2];
                cell.titleTextLabel.text = title;
            }else if (indexPath.row == 15){
                cell.switchBtn.hidden = NO;
                [cell setSwitchBtnState:mode[layerIndex].lightLimit[viewIndex]];
                cell.titleTextLabel.text = kLanguageForKey(265);
            }
            return cell;
        }
        else if (indexPath.row == 2 || indexPath.row == 3||indexPath.row == 6 ||indexPath.row == 7  || indexPath.row == 17 || indexPath.row == 18) {
            
            TableViewCellWith1Label1Switch *cell = [tableView dequeueReusableCellWithIdentifier:switchTableViewCell forIndexPath:indexPath];
            cell.delegate = self;
            cell.indexPath  = indexPath;
            cell.alignment = CellLabelLeftAlignment;
            cell.titleTextLabel.textColor = [UIColor blackColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 2) {
                cell.titleTextLabel.text =  kLanguageForKey(116);
                [cell setSwitchBtnState:mode[layerIndex].rgbSpot[viewIndex][0]];
            }else if (indexPath.row == 3){
                cell.titleTextLabel.text =  kLanguageForKey(117);
                [cell setSwitchBtnState:mode[layerIndex].rgbSpot[viewIndex][1]];
            }else if (indexPath.row == 6){
                cell.titleTextLabel.text =  kLanguageForKey(124);
                [cell setSwitchBtnState:mode[layerIndex].rgbArea[viewIndex][0]];
            }else if (indexPath.row == 7){
                cell.titleTextLabel.text =  kLanguageForKey(125);
                [cell setSwitchBtnState:mode[layerIndex].rgbArea[viewIndex][1]];
            }else if (indexPath.row == 17){
                cell.switchBtn.hidden = NO;
                [cell setSwitchBtnState:mode[layerIndex].UseRiceReverse];
                cell.titleTextLabel.text = kLanguageForKey(386);
            }else if (indexPath.row == 18){
                cell.switchBtn.hidden = NO;
                [cell setSwitchBtnState:mode[layerIndex].UseRiceWhite];
                cell.titleTextLabel.text = kLanguageForKey(389);
            }
            return cell;
        }else if(indexPath.row == 4 ||indexPath.row == 8 ||indexPath.row == 10 ||indexPath.row == 11|| indexPath.row == 13||indexPath.row == 14 ||indexPath.row == 16){
            UITableViewCell *textCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            textCell.selectionStyle = UITableViewCellSelectionStyleNone;
            textCell.textLabel.font = [UIFont systemFontOfSize:15.0];
            textCell.textLabel.tintColor = [UIColor grayColor];
            NSString *colorStr = nil;
            if (indexPath.row == 4) {
                
                NSInteger index = mode[layerIndex].rgbSpotColor[viewIndex];
                if (index<= 6&&index>=0) {
                    colorStr = [self.colorArray objectAtIndex:mode[layerIndex].rgbSpotColor[viewIndex]];
                }else{
                    @throw @"";
                    //fix me
                }
                
                
                textCell.textLabel.text = kLanguageForKey(46);
                
            }else if(indexPath.row == 8){
                colorStr = [self.colorArray objectAtIndex:mode[layerIndex].rgbAreaColor[viewIndex]];
                NSLog(@"区域:%d",mode[layerIndex].rgbAreaColor[viewIndex]);
                textCell.textLabel.text = kLanguageForKey(46);
                
            }else if (indexPath.row == 10){
                textCell.textLabel.text =  kLanguageForKey(46);
                NSLog(@"色差1color:%d",mode[layerIndex].diff1[viewIndex][1]);
                colorStr = [self.colorDiffArray objectAtIndex:mode[layerIndex].diff1[viewIndex][1]];
            }else if(indexPath.row == 11) {
                textCell.textLabel.text = kLanguageForKey(45);
                colorStr = [self.colorArray objectAtIndex:mode[layerIndex].diff1[viewIndex][2]];
                NSLog(@"色差1亮度:%d",mode[layerIndex].diff1[viewIndex][2]);
            }else if(indexPath.row == 13) {
                textCell.textLabel.text =  kLanguageForKey(46);
                colorStr = [self.colorDiffArray objectAtIndex:mode[layerIndex].diff2[viewIndex][1]];
            }else if (indexPath.row == 14) {
                textCell.textLabel.text = kLanguageForKey(45);
                colorStr = [self.colorArray objectAtIndex:mode[layerIndex].diff2[viewIndex][2]];
            }else if (indexPath.row == 16){
                textCell.textLabel.text = kLanguageForKey(46);
                colorStr = [self.colorArray objectAtIndex:mode[layerIndex].lightLimitColor[viewIndex]];
            }
            textCell.detailTextLabel.text = colorStr;
            textCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return textCell;
        }
    }else if (indexPath.section == 2){//红外算法
        if (indexPath.row == 0) {
            TableViewCellWith1Segment1Label *frontRearViewCell = [tableView dequeueReusableCellWithIdentifier:segmentedTableViewCellIdentifier forIndexPath:indexPath];
            frontRearViewCell.delegate = self;
            frontRearViewCell.indexPath = indexPath;
            if (device->machineData.useIR%3 == 0) {//前后都有
                [frontRearViewCell.frontRearViewSegmentedControl setHidden:NO];
                [frontRearViewCell.frontRearViewSegmentedControl setTitle:kLanguageForKey(75) forSegmentAtIndex:0];
                [frontRearViewCell.frontRearViewSegmentedControl setTitle:kLanguageForKey(76) forSegmentAtIndex:1];
                [frontRearViewCell.frontViewLabel setHidden:YES];
            }else{//单视
                [frontRearViewCell.frontRearViewSegmentedControl setHidden:YES];
                [frontRearViewCell.frontViewLabel setHidden:NO];
                if (device->machineData.useIR%3== 1) {//仅前视
                    frontRearViewCell.frontViewLabel.text = kLanguageForKey(75);
                }else if (device->machineData.useIR%3== 2) {//仅后视
                    frontRearViewCell.frontViewLabel.text = kLanguageForKey(76);
                }
            }
            frontRearViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return frontRearViewCell;
        }else if (indexPath.row == 1 ||indexPath.row == 2 ||indexPath.row ==4) {
            TableViewCellWith1Label1Switch *cell = [tableView dequeueReusableCellWithIdentifier:switchTableViewCell forIndexPath:indexPath];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.alignment = CellLabelLeftAlignment;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 1) {
                [cell.switchBtn setHidden:NO];
                cell.titleTextLabel.text = kLanguageForKey(177);
                [cell setSwitchBtnState:mode[layerIndex].irRgb[viewIndex][0]];
            }else if (indexPath.row == 2){
                [cell.switchBtn setHidden:NO];
                cell.titleTextLabel.text = kLanguageForKey(178);
                [cell setSwitchBtnState:mode[layerIndex].irRgb[viewIndex][1]];
            }else if (indexPath.row == 4){
                [cell.switchBtn setHidden:NO];
                cell.titleTextLabel.text = kLanguageForKey(179);
                [cell setSwitchBtnState:mode[layerIndex].irDiff[viewIndex]];
            }
            return cell;
        }else if (indexPath.row == 3 ||indexPath.row == 5){
            UITableViewCell *textCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            textCell.selectionStyle = UITableViewCellSelectionStyleNone;
            textCell.textLabel.font = [UIFont systemFontOfSize:15.0];
            textCell.textLabel.tintColor = [UIColor grayColor];
            NSString *colorStr = nil;
            if (indexPath.row == 3) {
                colorStr = [self.irArray objectAtIndex:mode[layerIndex].irRgbColor[viewIndex]];
                
            }else if(indexPath.row == 5){
                colorStr = [self.irDiffArray objectAtIndex:mode[layerIndex].irDiffColor[viewIndex]];
                
            }
            textCell.textLabel.text = kLanguageForKey(46);
            textCell.detailTextLabel.text = colorStr;
            textCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return textCell;
        }
    }
    UITableViewCell *defaultCell = [[UITableViewCell alloc]init];
    return defaultCell;
}

#pragma foldsectiondelegate

-(void)foldHeaderInSection:(NSInteger)SectionHeader
{
    NSString *key = [NSString stringWithFormat:@"%d",(int)SectionHeader];
    BOOL folded = [[_foldInfoDic objectForKey:key]boolValue];
    NSString *fold = folded?@"0":@"1";
    [_foldInfoDic setValue:fold forKey:key];
    
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc]initWithIndex:SectionHeader];
    [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark -table delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectIndexPath = [indexPath copy];
    Device *device = kDataModel.currentDevice;
    int viewIndex = device.currentViewIndex;
    int layerIndex = device.currentLayerIndex-1;
    if (indexPath.section == 1) {
        if (indexPath.row == 4 ||indexPath.row == 8|| indexPath.row == 10|| indexPath.row == 11||indexPath.row == 13|| indexPath.row == 14 || indexPath.row == 16){
            if (indexPath.row == 4) {
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.colorArray CurrentIndexPath:self.selectIndexPath CurrentRow:mode[layerIndex].rgbSpotColor[viewIndex]];
            }else if (indexPath.row == 8){
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.colorArray CurrentIndexPath:self.selectIndexPath CurrentRow:mode[layerIndex].rgbAreaColor[viewIndex]];
            }else if (indexPath.row == 10){
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.colorDiffArray CurrentIndexPath:self.selectIndexPath CurrentRow:mode[layerIndex].diff1[viewIndex][1]];
            }else if (indexPath.row == 11){
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.colorArray CurrentIndexPath:self.selectIndexPath CurrentRow:mode[layerIndex].diff1[viewIndex][2]];
            }else if (indexPath.row == 13){
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.colorDiffArray CurrentIndexPath:self.selectIndexPath CurrentRow:mode[layerIndex].diff2[viewIndex][1]];
            }else if (indexPath.row == 14){
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.colorArray CurrentIndexPath:self.selectIndexPath CurrentRow:mode[layerIndex].diff2[viewIndex][2]];
            }else if (indexPath.row == 16){
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.colorArray CurrentIndexPath:self.selectIndexPath CurrentRow:mode[layerIndex].lightLimitColor[viewIndex]];
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == 3) {
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.irArray CurrentIndexPath:self.selectIndexPath CurrentRow:mode[layerIndex].irRgbColor[viewIndex]];
            }else if (indexPath.row == 5){
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.irDiffArray CurrentIndexPath:self.selectIndexPath CurrentRow:mode[layerIndex].irDiffColor[viewIndex]];
            }
        }
    }
}


#pragma mark - Navigation

#pragma mark SelectItemDelegate

-(void)selectItemWithIndexPath:(NSIndexPath *)indexPath itemIndex:(Byte)index{//选择颜色种类
    Device *device = kDataModel.currentDevice;
    int viewIndex = device.currentViewIndex;
    int layerIndex = device.currentLayerIndex-1;
    if (indexPath.section == 1) {
        if (indexPath.row == 4) {
            if (self.frontRearInCommon) {
                mode[layerIndex].rgbSpotColor[0]= index;
                mode[layerIndex].rgbSpotColor[1]= index;
            }else{
                mode[layerIndex].rgbSpotColor[viewIndex]= index;
            }
        }else if (indexPath.row == 8) {
            if (self.frontRearInCommon) {
                mode[layerIndex].rgbAreaColor[0] = index;
                mode[layerIndex].rgbAreaColor[1] = index;
            }else{
                mode[layerIndex].rgbAreaColor[viewIndex] = index;
            }
        }else if(indexPath.row == 10){
            if (self.frontRearInCommon) {
                mode[layerIndex].diff1[0][1] = index;
                mode[layerIndex].diff1[1][1] = index;
            }else{
                mode[layerIndex].diff1[viewIndex][1] = index;
            }
        }else if (indexPath.row == 11){
            if (self.frontRearInCommon) {
                mode[layerIndex].diff1[0][2] = index;
                mode[layerIndex].diff1[1][2] = index;
            }else{
                mode[layerIndex].diff1[viewIndex][2] = index;
            }
        }else if(indexPath.row == 13){
            if (self.frontRearInCommon) {
                mode[layerIndex].diff2[0][1] = index;
                mode[layerIndex].diff2[1][1] = index;
            }else{
                mode[layerIndex].diff2[viewIndex][1] = index;
            }
        }else if (indexPath.row == 14){
            if (self.frontRearInCommon) {
                mode[layerIndex].diff2[0][2] = index;
                mode[layerIndex].diff2[1][2] = index;
            }else{
                mode[layerIndex].diff2[viewIndex][2] = index;
            }
        }else if (indexPath.row == 16){
            if (self.frontRearInCommon) {
                mode[layerIndex].lightLimitColor[0] = index;
                mode[layerIndex].lightLimitColor[1] = index;
            }else{
                mode[layerIndex].lightLimitColor[viewIndex] = index;
            }
        }
    }
    else if (indexPath.section == 2){
        if(indexPath.row == 3){
            if (self.frontRearInCommon) {
                mode[layerIndex].irRgbColor[0] = index;
                mode[layerIndex].irRgbColor[1] = index;
            }else{
                mode[layerIndex].irRgbColor[viewIndex] = index;
            }
        }else if (indexPath.row == 5){
            if (self.frontRearInCommon) {
                mode[layerIndex].irDiffColor[0] = index;
                mode[layerIndex].irDiffColor[1] = index;
            }else{
                mode[layerIndex].irDiffColor[viewIndex] = index;
            }
        }
    }
    NSArray *array = [NSArray arrayWithObject:indexPath];
    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark switchbtn relate to

#pragma mark - SwitchHeaderViewDelegate
-(void)switchHeaderInSection:(NSInteger)section withSwitchState:(Byte)state{
    Device *device = kDataModel.currentDevice;
    int viewIndex = device.currentViewIndex;
    int layerIndex = device.currentLayerIndex-1;
    if (section == 3) {
        mode[layerIndex].diff1[viewIndex][0] = state;
    }else if(section == 4){
        mode[layerIndex].diff1[viewIndex][0] = state;
    }else if (section == 5){
        device->shape = state;
    }
}

#pragma mark - tableviewcellchanged delegate

-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value{//使能
    Device *device = kDataModel.currentDevice;
    int viewIndex = device.currentViewIndex;
    int layerIndex = device.currentLayerIndex-1;
    if (section == 0) {
        if (row == 1) {
            self.tempUseSvm = value;
            if (value) {
                self.tempUseHsv = 0;
                [self.tableView reloadData];
            }
        }else if (row == 2) {
            mode[layerIndex].FrontRearRelation = value;
        }else if (row == 3){
            self.frontRearInCommon = value;
        }else if (row == 4){
            self.tempUseHsv = value;
            if (value) {
                self.tempUseSvm = 0;
                [self.tableView reloadData];
            }
        }
    }else if (section == 1){
        if (row == 0) {
            device.currentViewIndex = value;
            [self.tableView reloadData];
        }else if(row == 2)
        {
            if (_frontRearInCommon) {
                mode[layerIndex].rgbSpot[0][0] = value;
                mode[layerIndex].rgbSpot[1][0] = value;
            }else{
                mode[layerIndex].rgbSpot[viewIndex][0] = value;
            }
        }else if (row == 3){
            if (_frontRearInCommon) {
                mode[layerIndex].rgbSpot[0][1] = value;
                mode[layerIndex].rgbSpot[1][1] = value;
            }else{
                mode[layerIndex].rgbSpot[viewIndex][1] = value;
            }
        }else if (row == 6) {
            if (_frontRearInCommon) {
                mode[layerIndex].rgbArea[0][0] = value;
                mode[layerIndex].rgbArea[1][0] = value;
            }else{
                mode[layerIndex].rgbArea[viewIndex][0] =value;
            }
        }else if (row == 7){
            if (_frontRearInCommon) {
                mode[layerIndex].rgbArea[0][1] = value;
                mode[layerIndex].rgbArea[1][1] = value;
            }else{
                mode[layerIndex].rgbArea[viewIndex][1] = value;
            }
        }else if (row == 9){
            if (_frontRearInCommon) {
                mode[layerIndex].diff1[0][0] = value;
                mode[layerIndex].diff1[1][0] = value;
            }else{
                mode[layerIndex].diff1[viewIndex][0] = value;
            }
        }else if (row == 12){
            if (_frontRearInCommon) {
                mode[layerIndex].diff2[0][0] = value;
                mode[layerIndex].diff2[1][0] = value;
            }else{
                mode[layerIndex].diff2[viewIndex][0] = value;
            }
        }else if (row == 15){
            if (_frontRearInCommon) {
                mode[layerIndex].lightLimit[0] = value;
                mode[layerIndex].lightLimit[1] = value;
            }else{
                mode[layerIndex].lightLimit[viewIndex] = value;
            }
        }else if (row == 17){
            mode[layerIndex].UseRiceReverse = value;
        }else if (row == 18){
            mode[layerIndex].UseRiceWhite = value;
        }
    }else if (section == 2){
        if (row == 0) {
            device.currentViewIndex = value;
            [self.tableView reloadData];
        }else if (row == 1) {
            if (_frontRearInCommon) {
                mode[layerIndex].irRgb[0][0] = value;
                mode[layerIndex].irRgb[1][0] = value;
            }else{
                mode[layerIndex].irRgb[viewIndex][0] = value;
            }
            
        }else if (row == 2){
            if (_frontRearInCommon) {
                mode[layerIndex].irRgb[0][1] = value;
                mode[layerIndex].irRgb[1][1] = value;
            }else{
                mode[layerIndex].irRgb[viewIndex][0] = value;
            }
        }else if (row == 4){
            if (_frontRearInCommon) {
                mode[layerIndex].irDiff[0] = value;
                mode[layerIndex].irDiff[1] = value;
            }else{
                mode[layerIndex].irDiff[viewIndex] = value;
            }
        }
    }
}

-(BOOL)modeIsChanged{
    Device *device = kDataModel.currentDevice;
    if (device->mode == NULL) {
        return false;//没有返回方案
    }
    for (int layer = 0; layer<device->machineData.layerNumber; layer++) {
        for (int i = 0; i<2; i++) {
            for (int j= 0; j<2; j++) {
                if (device->mode[layer].rgbSpot[i][j] !=mode[layer].rgbSpot[i][j]){
                    return true;
                }
                if(device->mode[layer].rgbArea[i][j] != mode[layer].rgbArea[i][j]){
                    return true;
                }
                if(device->mode[layer].irRgb[i][j] != mode[layer].irRgb[i][j]) {
                    NSLog(@"%d %d",device->mode[layer].irRgb[i][j],mode[layer].irRgb[i][j] );
                    return true;
                }
            }
        }
        for (int i =0; i<2; i++) {
            for (int j= 0; j<3; j++) {
                if ((device->mode[layer].diff1[i][j] != mode[layer].diff1[i][j]) ||(device->mode[layer].diff2[i][j]!= mode[layer].diff2[i][j])) {
                    return true;
                }
            }
        }
        for (int i= 0; i<2; i++) {
            if ((device->mode[layer].rgbSpotColor[i]!=mode[layer].rgbSpotColor[i])\
                ||(device->mode[layer].rgbAreaColor[i]!= mode[layer].rgbAreaColor[i])\
                ||(device->mode[layer].irRgbColor[i]!= mode[layer].irRgbColor[i])\
                ||(device->mode[layer].irDiffColor[i]!= mode[layer].irDiffColor[i])\
                ||(device->mode[layer].lightLimit[i]!= mode[layer].lightLimit[i])\
                ||(device->mode[layer].lightLimitColor[i] != mode[layer].lightLimitColor[i])) {
                return true;
            }
        }
        if (device->mode[layer].FrontRearRelation != mode[layer].FrontRearRelation) {
            return true;
        }
        if (device->mode[layer].UseRiceReverse != mode[layer].UseRiceReverse) {
            return true;
        }
        if (device->mode[layer].UseRiceWhite != mode[layer].UseRiceWhite) {
            return true;
        }
        if (device->useSvm != self.tempUseSvm) {
            return true;
        }
        if (device->useHsv != self.tempUseHsv) {
            return true;
        }
    }
    return false;
}

-(BOOL)Back{
    Device *device = kDataModel.currentDevice;
    if (device->machineData.startState) {
        return [super Back];
    }else{
        if ([self modeIsChanged]&& self.modeIndex == device->machineData.sortModeSmall && self.bigModeIndex == device->machineData.sortModeBig) {
            [self.tipsView showInView:self.window withFrame:CGRectMake(0, (self.frame.size.height-400)/2, self.frame.size.width, self.frame.size.height)];
            
        }else{
            return [super Back];
        }
    }
    return NO;
}

#pragma mark tipsview delegate

-(void)tipsViewResult:(Byte)value{
    if (value) {
        [[NetworkFactory sharedNetWork] changeModeSettingWithMode:(Byte*)mode shape:self.tempShapeIndex svm:self.tempUseSvm hsv:self.tempUseHsv];
    }else{
         [[NetworkFactory sharedNetWork]getModeSettingWithIndex:self.modeIndex BigModeIndex:self.bigModeIndex];
    }
}
-(TipsView*)tipsView{
    if (!_tipsView) {
        _tipsView = [[TipsView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2-130, self.bounds.size.height / 2-80, 260, 160) okTitle:kLanguageForKey(130) cancelTitle:kLanguageForKey(131) tips:kLanguageForKey(129)];
        _tipsView.delegate=self;
        _tipsView.backgroundColor=[UIColor whiteColor];
        _tipsView.layer.cornerRadius=10;
    }
    return _tipsView;
}

-(SelectItemTableView*)selectItemView{
    if(!_selectItemView){
        _selectItemView = [[SelectItemTableView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-100, self.bounds.size.height/2-140, 200, 280)];
        _selectItemView.delegate = self;
        _selectItemView.backgroundColor = [UIColor whiteColor];
        _selectItemView.layer.cornerRadius = 10;
    }
    return _selectItemView;
}
- (void)dealloc{
    if (mode) {
        free(mode);
        mode = NULL;
    }
}

-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [self.tableView reloadData];
}
@end
