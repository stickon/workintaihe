//
//  ModeListView.m
//  thColorSort
//
//  Created by taihe on 2018/1/11.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "ModeListView.h"
#import "TableViewCellWithDefaultLabel2Button.h"
#import "LGJFoldHeaderView.h"
static NSString* modeCellIdentifier = @"TableViewCellWithDefaultLabel2Button";
@interface ModeListView()<UITableViewDelegate,UITableViewDataSource,TableViewCellChangedDelegate,FoldSectionHeaderViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSIndexPath *selectPath;
@property (strong,nonatomic) NSIndexPath *currentUsePath;
@property(nonatomic, strong) NSDictionary* foldInfoDic;/**< 存储开关字典 */
@end
@implementation ModeListView
-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"HomeView" owner:self options:nil] firstObject];
        
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        _foldInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"0":@"0",                                  @"1":@"0",@"2":@"0",@"3":@"0",@"4":@"0",}];
        Device *device = kDataModel.currentDevice;
        NSString *key = [NSString stringWithFormat:@"%d",(int)device->machineData.sortModeBig];
        NSString *fold = @"1";
        [_foldInfoDic setValue:fold forKey:key];
        [self.tableView registerNib:[UINib nibWithNibName:modeCellIdentifier bundle:nil] forCellReuseIdentifier:modeCellIdentifier];
        
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    }
    return self;
}
-(UIView *)getViewWithPara:(NSDictionary *)para{
  
    Device *device = kDataModel.currentDevice;
    device.currentSelectBigModeIndex = device->machineData.sortModeBig;
    [[NetworkFactory sharedNetWork] getSmallModeNameListWithBigModeIndex:device->machineData.sortModeBig];
    return self;
}
- (void)refreshCurrentView{
    [[NetworkFactory sharedNetWork] getCurrentDeviceInfo];
}

-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char*a = headerData.bytes;
    Device *device = kDataModel.currentDevice;
    if (a[0] == 0x0d) {
        if (a[1] == 0x05)
        {
            if (a[2] == 1) {
                [self makeToast: kLanguageForKey(91) duration:2.0 position:CSToastPositionCenter];
                device->machineData.sortModeBig = self.selectPath.section;
                
                NSMutableArray *smallModeList = [device.bigModeList objectAtIndex:device->machineData.sortModeBig];
                NSMutableDictionary *dict = [smallModeList objectAtIndex:self.selectPath.row];
                NSString *index = [dict valueForKey:@"modeRealIndex"];
                device->machineData.sortModeSmall = index.intValue;
                device.modeName = [dict valueForKey:@"modeName"];
                [self.tableView reloadData];
                [[NetworkFactory sharedNetWork] getCurrentDeviceInfo];
            }else if (a[2] == 2){
                [self makeToast: kLanguageForKey(92) duration:2.0 position:CSToastPositionCenter];
            }
        }else if (a[1] == 1){
            NSMutableIndexSet *set = [[NSMutableIndexSet alloc]initWithIndex:device.currentSelectBigModeIndex];
            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [[NetworkFactory sharedNetWork]getSmallModeNameListWithBigModeIndex:device->machineData.sortModeBig];
    }
}


#pragma mark table datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = [NSString stringWithFormat:@"%d",(int)section];
    BOOL folded = [[_foldInfoDic objectForKey:key]boolValue];
    
    Device *device = kDataModel.currentDevice;
    if (section == 0) {
        return folded?device.modeList1.count:0;
    }
    if (section == 1) {
        return folded?device.modeList2.count:0;
    }
    if (section == 2) {
        return folded?device.modeList3.count:0;
    }
    if (section == 3) {
        return folded?device.modeList4.count:0;
    }
    if (section == 4) {
        return folded?device.modeList5.count:0;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Device *device = kDataModel.currentDevice;
    static NSString* foldheaderview = @"LGJFoldHeaderView";
    LGJFoldHeaderView *foldHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:foldheaderview];
    if (!foldHeaderView) {
        foldHeaderView = [[LGJFoldHeaderView alloc]initWithReuseIdentifier:foldheaderview];
    }
    if (section == 0) {
        NSString *baseVersionFoldHeaderTitle =[NSString stringWithFormat:@"%@ 1",kLanguageForKey(336)];
        [foldHeaderView setFoldSectionHeaderViewWithTitle:baseVersionFoldHeaderTitle detail:@"" type:HerderStyleTotal section:section canFold:YES];
        [foldHeaderView.separateView setHidden:YES];
        
    }else if(section == 1)
    {
        NSString *colorBoardVersionFoldHeaderTitle = [NSString stringWithFormat:@"%@ 2",kLanguageForKey(336)];
        [foldHeaderView setFoldSectionHeaderViewWithTitle:colorBoardVersionFoldHeaderTitle detail:@"" type:HerderStyleTotal section:section canFold:YES];
    }else if (section ==2)
    {
        NSString *nomalCameraVersionFoldHeaderTitle = [NSString stringWithFormat:@"%@ 3",kLanguageForKey(336)];
        [foldHeaderView setFoldSectionHeaderViewWithTitle:nomalCameraVersionFoldHeaderTitle detail:@"" type:HerderStyleTotal section:section canFold:YES];
    }else if(section == 3){
        NSString *irCameraVerisonFoldHeaderTitle = [NSString stringWithFormat:@"%@ 4",kLanguageForKey(336)];
        [foldHeaderView setFoldSectionHeaderViewWithTitle:irCameraVerisonFoldHeaderTitle detail:@"" type:HerderStyleTotal section:section canFold:YES];
    }else if(section == 4){
        NSString *irCameraVerisonFoldHeaderTitle = [NSString stringWithFormat:@"%@ 5",kLanguageForKey(336)];
        [foldHeaderView setFoldSectionHeaderViewWithTitle:irCameraVerisonFoldHeaderTitle detail:@"" type:HerderStyleTotal section:section canFold:YES];
    }
    if ( device->machineData.sortModeBig == section) {
        [foldHeaderView setFoldSectionHeaderViewTitleColor:[UIColor redColor]];
    }else{
        [foldHeaderView setFoldSectionHeaderViewTitleColor:[UIColor blackColor]];
    }
    
    foldHeaderView.delegate = self;
    NSString *key = [NSString stringWithFormat:@"%d",(int)section];
    BOOL folded = [[_foldInfoDic valueForKey:key]boolValue];
    foldHeaderView.fold = folded;
    return foldHeaderView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Device *device = kDataModel.currentDevice;
    TableViewCellWithDefaultLabel2Button *cell = [tableView dequeueReusableCellWithIdentifier:modeCellIdentifier forIndexPath:indexPath];
    NSMutableArray *smallModeList = [device.bigModeList objectAtIndex:indexPath.section];
    NSMutableDictionary *dict = [smallModeList objectAtIndex:indexPath.row];
    cell.title.text = [dict valueForKey:@"modeName"];
    cell.detailTitle.text = [dict valueForKey:@"modifyTime"];
    NSString *index = [dict valueForKey:@"modeRealIndex"];
    if (index.intValue == device->machineData.sortModeSmall && device->machineData.sortModeBig == indexPath.section) {
        self.selectPath = indexPath;
        cell.title.textColor = [UIColor redColor];
        [cell.applyBtn setHidden:NO];
#ifdef Engineer
        [cell.configBtn setHidden:NO];
#else
        [cell.configBtn setHidden:YES];
        cell.configBtnConstraintWidth.constant = 0.0f;
        cell.configBtn.frame = CGRectZero;
#endif
        
    }else{
        cell.title.textColor = [UIColor blackColor];
        [cell.applyBtn setHidden:YES];
        [cell.configBtn setHidden:YES];
    }
    
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.applyBtn.tag = 1;
    [cell.applyBtn setTitle: kLanguageForKey(94) forState:UIControlStateNormal];
    [cell.configBtn setTitle: kLanguageForKey(95) forState:UIControlStateNormal];
    //按钮自适应
    CGSize titleSize =
    [kLanguageForKey(95) sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:cell.configBtn.titleLabel.font.fontName size:cell.configBtn.titleLabel.font.pointSize]}];
    
    titleSize.height = 20;
    titleSize.width += 20;
    
    cell.configBtn.frame = CGRectMake(cell.configBtn.frame.origin.x,cell.configBtn.frame.origin.y, titleSize.width, cell.configBtn.frame.size.height);
    
    
    cell.configBtn.tag = 2;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark table delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectPath.section != indexPath.section || self.selectPath.row != indexPath.row) {
        TableViewCellWithDefaultLabel2Button *newCell = [tableView cellForRowAtIndexPath:indexPath];
        [newCell.applyBtn setHidden:NO];
#ifdef Engineer
        [newCell.configBtn setHidden:NO];
#else
        [newCell.configBtn setHidden:YES];
        newCell.configBtnConstraintWidth.constant = 0.0f;
        newCell.configBtn.frame = CGRectZero;
#endif
        TableViewCellWithDefaultLabel2Button *oldCell = [tableView cellForRowAtIndexPath:self.selectPath];
        [oldCell.applyBtn setHidden:YES];
        [oldCell.configBtn setHidden:YES];
        self.selectPath = indexPath;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)Back{
    [[NetworkFactory sharedNetWork] getCurrentDeviceInfo];
    return [super Back];
}

#pragma foldsectiondelegate

-(void)foldHeaderInSection:(NSInteger)SectionHeader
{
    Device *device = kDataModel.currentDevice;
    device.currentSelectBigModeIndex = SectionHeader;
    NSString *key = [NSString stringWithFormat:@"%d",(int)SectionHeader];
    BOOL folded = [[_foldInfoDic objectForKey:key]boolValue];
    NSString *fold = folded?@"0":@"1";
    [_foldInfoDic setValue:fold forKey:key];
    if (!folded) {
        [[NetworkFactory sharedNetWork] getSmallModeNameListWithBigModeIndex:SectionHeader];
    }
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc]initWithIndex:SectionHeader];
    [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - tableviewcell delegate
-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value{
    if (index == 1) {
        [[NetworkFactory sharedNetWork]useModeWithIndex:row BigModeIndex:section];
    }else{
        Device *device = kDataModel.currentDevice;
        NSMutableArray *smallModeList = [device.bigModeList objectAtIndex:self.selectPath.section];
        NSMutableDictionary *dict = [smallModeList objectAtIndex:self.selectPath.row];

        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        [para setObject:[NSString stringWithFormat:@"%ld",(long)self.selectPath.section] forKey:@"bigModeIndex"];
        [para setObject:[dict valueForKey:@"modeName"] forKey:@"title"];
        [para setObject:[dict valueForKey:@"modeRealIndex"] forKey:@"smallModeIndex"];

        [gMiddeUiManager ChangeViewWithName:@"ModeSetView" Para:para];
    }
}
@end
