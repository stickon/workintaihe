//
//  ViewController.m
//  ThColorSortNew
//
//  Created by honghua cai on 2017/11/12.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "ViewController.h"
#import "TopManager.h"
#import "MiddleManager.h"
#import "BottomManager.h"
#import "VersionViewPageManager.h"
#import "InternationalControl.h"
#import "FileOperation.h"
#import "types.h"
@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [FileOperation checkIsFirst];
    [InternationalControl initUserLanguage];
    // Do any additional setup after loading the view, typically from a nib.
    [_middleView setUserInteractionEnabled:YES];
    [[TopManager shareInstance] attachView:_topView];
    
    [[MiddleManager shareInstance] attachView:_middleView];
    
    [[BottomManager shareInstance] attachView:_bottomView];
    
    
    [[MiddleManager shareInstance] attachObserver:[TopManager shareInstance]];
    
    [[MiddleManager shareInstance] attachObserver:[BottomManager shareInstance]];
    
    NSDictionary *dic = @{@"title":kLanguageForKey(5)};
    [[MiddleManager shareInstance] ChangeViewWithName:@"LoginUI" Para:dic];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)click:(id)sender {
    NSLog(@"........");
}
@end
