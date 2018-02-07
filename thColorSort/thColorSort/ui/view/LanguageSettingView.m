//
//  LanguageSettingView.m
//  thColorSort
//
//  Created by taihe on 2018/1/15.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "LanguageSettingView.h"
#import "InternationalControl.h"
#import "DownloadTableViewCell.h"
#import "FileDownLoader.h"
#import "MJRefresh.h"
static NSString * downloadCellIdentify = @"DownloadTableViewCell";
@interface LanguageSettingView() <UITableViewDelegate,UITableViewDataSource,TableViewCellChangedDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSIndexPath *selectPath;
@property (strong,nonatomic) NSIndexPath *currentUsePath;
@property (assign, nonatomic) Byte isRefreshing;//是否下拉刷新
@end

@implementation LanguageSettingView


-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"LanguageSettingView" owner:self options:nil] firstObject];
        [self initView];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    
    return self;
}

-(UIView*) getViewWithPara:(NSDictionary *)para{
    [self initLanguage];
    
    return self;
}



-(void)initView{
//    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:kLanguageForKey(138) style:UIBarButtonItemStyleDone target:self action:@selector(saveToChangeLanguage)];
    [self.tableView registerNib:[UINib nibWithNibName:downloadCellIdentify bundle:nil] forCellReuseIdentifier:downloadCellIdentify];
    self.isRefreshing = 0;
    
    // 设置header
    self.tableView.mj_header = self.refreshHeader;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
- (void)refreshTableView{
    self.isRefreshing = 1;
    [[FileDownLoader sharedDownloader] downloadFileWithType:1 FileName:@"config.json"];
}
- (void)updateCurrentViewController:(NSData *)headerData{
    unsigned const char* a = headerData.bytes;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (a[0] == 0xc2 && a[1] == 1) {
            if (self.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
                self.isRefreshing = 0;
            }else{
                [self makeToast:@"更新完成" duration:2.0 position:CSToastPositionCenter];
            }
            self.languageShowArray = kDataModel.tempLanguageArray;
            [self.tableView reloadData];
            
        }
    });
}

-(void)saveToChangeLanguage{
    NSInteger index = [InternationalControl findIndexInLanguageDefaultsArrayWithUrl:[[self.languageShowArray objectAtIndex:_selectPath.row] valueForKey:@"url"]];
    [InternationalControl setUserLanguageIndex:index];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(changeLanguage)]) {
//        [self.delegate changeLanguage];
//    }
}


#pragma tableview datasource

- (NSArray *)languageShowArray{
    if(!_languageShowArray){
        if (kDataModel.tempLanguageArray.count>0) {
            _languageShowArray = kDataModel.tempLanguageArray;
        }else{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            _languageShowArray = [defaults valueForKey:@"languageArray"];
            
        }
    }
    return _languageShowArray;
}
- (NSArray*)languageDefaultsArray{
    if (!_languageDefaultsArray) {
        
    }
    return _languageDefaultsArray;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.languageShowArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentLanguage = [defaults valueForKey:@"userLanguage"];
    NSArray* languageDefaultsArray = [defaults valueForKey:@"languageArray"];
    DownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:downloadCellIdentify forIndexPath:indexPath];
    if (indexPath.row < self.languageShowArray.count) {
        NSDictionary *serverdict = [self.languageShowArray objectAtIndex:indexPath.row];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.textLabel.text = [serverdict objectForKey:@"name"];
        NSArray *array = [[serverdict objectForKey:@"url"] componentsSeparatedByString:@"."];
        if ([currentLanguage isEqualToString:[array objectAtIndex:0]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            _selectPath = indexPath;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        NSString *serverVerison = [serverdict objectForKey:@"version"];
        if (kDataModel.tempLanguageArray == nil) {
            [cell updateViewWithDownloadState:DownloadCellStateNoUpdate];
        }else{
            NSInteger i =  [InternationalControl findIndexInLanguageDefaultsArrayWithUrl:[serverdict objectForKey:@"url"]];
            if (i>= 0) {
                NSDictionary *defaultsdict = [languageDefaultsArray objectAtIndex:i];
                NSString *defaultsVersion = [defaultsdict objectForKey:@"version"];
                
                //                NSComparisonResult result = [serverVerison compare:defaultsVersion];
                if( defaultsVersion.intValue >= serverVerison.intValue){
                    [cell updateViewWithDownloadState:DownloadCellStateNoUpdate];
                }else {
                    [cell updateViewWithDownloadState:DownloadCellStateUpdate];
                }
            }else{
                [cell updateViewWithDownloadState:DownloadCellStateNoFile];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.languageShowArray objectAtIndex:indexPath.row];
    if ([InternationalControl findIndexInLanguageDefaultsArrayWithUrl:[dict objectForKey:@"url"]]>=0) {
        int newRow = (int)[indexPath row];
        int oldRow = (int)(self.selectPath != nil) ? (int)[_selectPath row]:0;
        if (oldRow>=0) {
            if (newRow != oldRow) {
                UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
                newCell.accessoryType = UITableViewCellAccessoryCheckmark;
                
                UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.selectPath];
                oldCell.accessoryType = UITableViewCellAccessoryNone;
                self.selectPath = [indexPath copy];
                [self saveToChangeLanguage];
            }
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}


#pragma mark TableViewCellChangedDelegate
- (void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value{
    NSDictionary *dict = [self.languageShowArray objectAtIndex:row];
    if (value == 3) {
        [[FileDownLoader sharedDownloader]downloadFileWithType:3 FileName:[dict objectForKey:@"url"]];
    }
}

-(void)networkError{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        [self makeToast:kLanguageForKey(215) duration:2.0 position:CSToastPositionCenter];
        
    });
}


@end
