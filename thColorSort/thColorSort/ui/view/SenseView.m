//
//  SenseView.m
//  ThColorSortNew
//
//  Created by taihe on 2017/12/19.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "SenseView.h"
@interface SenseView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSIndexPath* selectIndexPath;
@end
@implementation SenseView

-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"SenseView" owner:self options:nil] firstObject];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.bounces = NO;
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    
    return self;
}
-(UIView*)getViewWithPara:(NSDictionary *)para{
    [self refreshCurrentView];
    [self initLanguage];
    return self;
}
-(void)initLanguage{
    [super initLanguage];
}
-(void)refreshCurrentView{
    [self.tableView reloadData];
}
-(void)updateWithHeader:(NSData*)headerData
{
    const char* a = headerData.bytes;
    if (a[0] == 0x04 && a[1] == 0x01) {
        [self refreshCurrentView];
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }
}

#pragma tableview data source

- (NSInteger)numberOfSectionsInTableVeiw:(UITableView*)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    Device *device = kDataModel.currentDevice;
    if (device) {
        
        if (indexPath.row == 0) {
            if (device->machineData.useColor==0) {
                return 0;
            }
        }
        if (indexPath.row == 1) {
            if (device->machineData.useIR == 0) {
                return 0;
            }
        }
        if (indexPath.row == 2) {
            if (device->machineData.shapeType<=1) {
                return 0;
            }
        }
        if (indexPath.row == 3) {
            if (device->machineData.useSvm== 0) {
                return 0;
            }
        }
        if (indexPath.row == 4) {
            if (device->machineData.useHsv == 0) {
                return 0;
            }
        }
    }
    return 50;
}
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    Device *device = kDataModel.currentDevice;
    NSString *defaultTableViewCell = @"defaultcell";
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
        cell.textLabel.text = kLanguageForKey(29);
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (device->machineData.useColor) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
            cell.frame = CGRectZero;
        }
        return cell;
    }
    if (indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = kLanguageForKey(104);
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        if (device->machineData.useIR>0) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
            cell.frame = CGRectZero;
        }
        return cell;
    }
    if (indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [self.shapeArray objectAtIndex:device->machineData.shapeType];
        NSString *shapestring = [self.shapeArray objectAtIndex:device->machineData.shapeType];
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        if (device->machineData.shapeType>1) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
            cell.frame = CGRectZero;
        }
        return cell;
    }
    if (indexPath.row == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = kLanguageForKey(31);
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        if (device->machineData.useSvm) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
            cell.frame = CGRectZero;
        }
        return cell;
        
    }
    if (indexPath.row == 4) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = kLanguageForKey(338);
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        if (device->machineData.useHsv) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
            cell.frame = CGRectZero;
        }
        
        return cell;
    }
    UITableViewCell *defaultCell = [[UITableViewCell alloc]init];
    return defaultCell;
}
#pragma mark - tableviewdelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    Device *device = kDataModel.currentDevice;
    if (indexPath.row == 0) {
        [self.paraNextView setObject:kLanguageForKey(29) forKey:@"title"];
        [gMiddeUiManager ChangeViewWithName:@"ColorAlgorithmView" Para:self.paraNextView];
    }
    if (indexPath.row == 1) {
        [self.paraNextView setObject:kLanguageForKey(176) forKey:@"title"];
        [gMiddeUiManager ChangeViewWithName:@"IRAlgorithmView" Para:self.paraNextView];
    }
    if (indexPath.row == 2) {
        if (device) {
            switch (device->machineData.shapeType) {
                case SHAPE_NONE:
                    [self makeToast:@"NO shape" duration:2.0 position:CSToastPositionCenter];
                    break;
                case SHAPE_TEA_TIEGUANYIN:
                    [self.paraNextView setObject:kLanguageForKey(156) forKey:@"title"];
                    [gMiddeUiManager ChangeViewWithName:@"TeaView" Para:self.paraNextView];
                    break;

                case SHAPE_TEA_DAHONGPAO:
                    [self.paraNextView setObject:kLanguageForKey(157) forKey:@"title"];
                    [gMiddeUiManager ChangeViewWithName:@"TeaView" Para:self.paraNextView];
                    break;
                case SHAPE_TEA_HONGCHA:
                    [self.paraNextView setObject:kLanguageForKey(159) forKey:@"title"];
                    [gMiddeUiManager ChangeViewWithName:@"RedTeaView" Para:self.paraNextView];
                    break;
                case SHAPE_TEA_SRILANKA:
                    [self.paraNextView setObject:kLanguageForKey(159) forKey:@"title"];
                    [gMiddeUiManager ChangeViewWithName:@"RedTeaView" Para:self.paraNextView];
                    break;
                case SHAPE_CASHEW:
                    [self.paraNextView setObject:kLanguageForKey(160) forKey:@"title"];
                    [gMiddeUiManager ChangeViewWithName:@"CashewView" Para:self.paraNextView];
                    break;
                case SHAPE_CORN:
                    [self.paraNextView setObject:kLanguageForKey(161) forKey:@"title"];
                    [gMiddeUiManager ChangeViewWithName:@"CornView" Para:self.paraNextView];
                    break;
                case SHAPE_PEANUTBUD:            //花生芽头
                {
                    [self.paraNextView setObject:kLanguageForKey(162) forKey:@"title"];
                    [gMiddeUiManager ChangeViewWithName:@"PeanutView" Para:self.paraNextView];
                }
                    break;
                case SHAPE_WHEAT:                //小麦
                    [self.paraNextView setObject:kLanguageForKey(163) forKey:@"title"];
                    [gMiddeUiManager ChangeViewWithName:@"WheatView" Para:self.paraNextView];
                    break;
                case SHAPE_SEEDRICE:            //稻种
                    [self.paraNextView setObject:kLanguageForKey(164) forKey:@"title"];
                    [gMiddeUiManager ChangeViewWithName:@"SeedView" Para:self.paraNextView];
                    break;
                case SHAPE_SUN_FLOWER:            //葵花籽
                    [self.paraNextView setObject:kLanguageForKey(165) forKey:@"title"];
                    [gMiddeUiManager ChangeViewWithName:@"SunflowerView" Para:self.paraNextView];
                    break;
                case SHAPE_BLACK_QOUQI:            //枸杞
                    [self makeToast:@"In developing" duration:2.0 position:CSToastPositionCenter];
                    break;
                case SHAPE_TEA_LVCHA:            //绿茶
                    [self.paraNextView setObject:kLanguageForKey(167) forKey:@"title"];
                    [gMiddeUiManager ChangeViewWithName:@"GreenTeaView" Para:self.paraNextView];
                    break;
                case SHAPE_PEANUT:                //花生
                    [self makeToast:@"In developing" duration:2.0 position:CSToastPositionCenter];
                    break;
                case SHAPE_RICE:                //大米形选
                    [self.paraNextView setObject:kLanguageForKey(170) forKey:@"title"];
                    [gMiddeUiManager ChangeViewWithName:@"RiceView" Para:self.paraNextView];
                    break;
                case SHAPE_STANDARD:            //标准形选
                    [self.paraNextView setObject:kLanguageForKey(170) forKey:@"title"];
                     [gMiddeUiManager ChangeViewWithName:@"StandardShapeView" Para:self.paraNextView];
                    break;
                case SHAPE_GENERAL_TEA:         //通用茶叶
                     [self.paraNextView setObject:kLanguageForKey(171) forKey:@"title"];
                    [gMiddeUiManager ChangeViewWithName:@"StandardShapeView" Para:self.paraNextView];
                    break;
                case SHAPE_LIQUORICE:           //甘草
                    [self.paraNextView setObject:kLanguageForKey(172) forKey:@"title"];
                    [gMiddeUiManager ChangeViewWithName:@"LicoriceView" Para:self.paraNextView];
                    break;
                case SHAPE_HORSEBEAN:           //蚕豆
                    [self.paraNextView setObject:kLanguageForKey(173) forKey:@"title"];
                    [gMiddeUiManager ChangeViewWithName:@"HorseBeanView" Para:self.paraNextView];
                    break;
                case SHAPE_GREENTEA_SHORTSTEM:      //绿茶短梗
                {
                    [self.paraNextView setObject:[NSString stringWithFormat:@"%@%@",kLanguageForKey(167),kLanguageForKey(284)] forKey:@"title"];
                    [gMiddeUiManager ChangeViewWithName:@"GreenTeaShortStemView" Para:self.paraNextView];
                }
                    break;
                default:
                    break;
            }
        }
    }
    if (indexPath.row == 3) {
        [self.paraNextView setObject:kLanguageForKey(31) forKey:@"title"];
        [gMiddeUiManager ChangeViewWithName:@"SvmView" Para:self.paraNextView];
    }
    
    if (indexPath.row == 4) {
        [self.paraNextView setObject:kLanguageForKey(338) forKey:@"title"];
        [gMiddeUiManager ChangeViewWithName:@"HsvView" Para:self.paraNextView];
    }
}


-(void)dealloc{
    NSLog(@"sense view dealloc");
}
@end
