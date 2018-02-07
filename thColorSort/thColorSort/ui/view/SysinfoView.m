//
//  SysinfoView.m
//  ThColorSortNew
//
//  Created by taihe on 2017/12/19.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "SysinfoView.h"
@interface SysinfoView()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SysinfoView

-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"SysinfoView" owner:self options:nil] firstObject];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.bounces = NO;
    }
    
    return self;
}

-(void)updateWithHeader:(NSData*)headerData
{
    const unsigned char *a = headerData.bytes;
    if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }
}

#pragma mark tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#ifdef Engineer
    return 5;
#else
    return 4;
#endif
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *defaultTableViewCell = @"defaultcell";
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
        cell.textLabel.text = kLanguageForKey(77) ;
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
        cell.textLabel.text = kLanguageForKey(304) ;
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 2){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
        cell.textLabel.text = kLanguageForKey(305) ;
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = kLanguageForKey(149) ;
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        return cell;
    }
#ifdef Engineer
    else if (indexPath.row == 4){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = kLanguageForKey(1012);
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        return cell;
    }
#endif
    UITableViewCell *defaultCell = [[UITableViewCell alloc]init];
    return defaultCell;
}

#pragma mark tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.paraNextView setObject:kLanguageForKey(77) forKey:@"title"];
        [gMiddeUiManager ChangeViewWithName:@"SoftwareVersionView" Para:self.paraNextView];
    }else if (indexPath.row == 1){
        [self.paraNextView setObject:kLanguageForKey(304) forKey:@"title"];
        [gMiddeUiManager ChangeViewWithName:@"SyscheckInfoView" Para:self.paraNextView];
    }else if (indexPath.row == 2){
        [self.paraNextView setObject:kLanguageForKey(305) forKey:@"title"];
        [gMiddeUiManager ChangeViewWithName:@"SysworkTimeView" Para:self.paraNextView];
    }else if (indexPath.row == 3){
        [self.paraNextView setObject:kLanguageForKey(149) forKey:@"title"];
        [gMiddeUiManager ChangeViewWithName:@"ValveShowInfoView" Para:self.paraNextView];
    }else if (indexPath.row == 4){
        [self.paraNextView setObject:kLanguageForKey(1012) forKey:@"title"];
        [gMiddeUiManager ChangeViewWithName:@"RunningLogView" Para:self.paraNextView];
    }
}


-(void)dealloc{
    NSLog(@"sysinfo view dealloc");
}
@end
