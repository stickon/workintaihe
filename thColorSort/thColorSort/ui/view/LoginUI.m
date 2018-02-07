//
//  LoginUI.m
//  ThColorSortNew
//
//  Created by honghua cai on 2017/11/12.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "LoginUI.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <QuartzCore/QuartzCore.h>
#import "FileDownLoader.h"
#import "FileOperation.h"
#import "TipsView.h"
static NSString *tcpMachineID = @"TcpMachineID";//机器编号
static NSString *udpMachineID = @"udpMachineID";//登录成功的用户名
static NSString *udpMachinePwd = @"udpMachinePwd";//密码
@interface LoginUI()<TipsViewResultDelegate>
{
    BOOL findDevice;//定时器触发前找到设备
    MBProgressHUD *hudLoading;
}
@property (strong, nonatomic) IBOutlet UILabel *versionLableTitle;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;//version

@property (strong, nonatomic) IBOutlet UISegmentedControl *loginTypeSegmentedControl;
@property (strong, nonatomic) IBOutlet UIImageView *userNameImageView;
@property (strong, nonatomic) IBOutlet UIImageView *passwordImageView;
@property (strong, nonatomic) IBOutlet UITextField *loginTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
@property (strong, nonatomic) IBOutlet UIButton *languageBtn;
@property (strong, nonatomic) TipsView *tipsView;
@end
@implementation LoginUI
-(void)awakeFromNib{
    [super awakeFromNib];
}

-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"loginUi" owner:self options:nil] firstObject];
        [self init2LoginTextField];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    
    return self;
}

-(UIView*) getViewWithPara:(NSDictionary *)para{
    [self initLanguage];
    findDevice = false;
    
    
    //1先获取当前工程项目版本号
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    NSString *versionTitle = [NSString stringWithFormat:@"V %@",currentVersion];
    self.versionLabel.text = versionTitle;
    [[FileDownLoader sharedDownloader] downloadFileWithType:1 FileName:@"config.json"];
    return self;
}

-(void)checkAppUpdate{
    //1先获取当前工程项目版本号
    NSLog(@"check update");
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    
    NSString *appStoreVersion = kDataModel.tempVersion;
    
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (currentVersion.length==2) {
        currentVersion  = [currentVersion stringByAppendingString:@"0"];
    }else if (currentVersion.length==1){
        currentVersion  = [currentVersion stringByAppendingString:@"00"];
    }
    NSString* tempAppStoreVersion = [appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (tempAppStoreVersion.length==2) {
        tempAppStoreVersion  = [tempAppStoreVersion stringByAppendingString:@"0"];
    }else if (tempAppStoreVersion.length==1){
        tempAppStoreVersion  = [tempAppStoreVersion stringByAppendingString:@"00"];
    }
    
    //5当前版本号小于商店版本号,就更新
    if([currentVersion floatValue] < [tempAppStoreVersion floatValue])
    {
         [self.tipsView showInView:self.window withFrame:CGRectMake(0, (self.frame.size.height-400)/2, self.frame.size.width, 400) okTitle:kLanguageForKey(130) cancelTitle:kLanguageForKey(131) tips:[NSString stringWithFormat:@"%@:%@",kLanguageForKey(246),appStoreVersion]];
    }else{
        NSLog(@"版本号好像比商店大噢!检测到不需要更新");
    }
}




-(void)showStoreVersion:(NSString *)storeVersion openUrl:(NSString *)openUrl{
    UIAlertController *alercConteoller = [UIAlertController alertControllerWithTitle:kLanguageForKey(244) message:[NSString stringWithFormat:@"%@:%@",kLanguageForKey(246),storeVersion] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:kLanguageForKey(130) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:kLanguageForKey(131) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alercConteoller addAction:actionYes];
    [alercConteoller addAction:actionNo];
//    [self presentViewController:alercConteoller animated:YES completion:nil];
}


- (void)initLanguage
{
    [self.loginBtn.layer setCornerRadius:3.0];
    [self.languageBtn.layer setCornerRadius:3.0];
    [self.registerBtn.layer setCornerRadius:3.0];
    if (self.loginTypeSegmentedControl.selectedSegmentIndex == 0) {
        [self.loginBtn setTitle:kLanguageForKey(4) forState:UIControlStateNormal];
    }else{
        [self.loginBtn setTitle:kLanguageForKey(5) forState:UIControlStateNormal];
    }

    [self.loginTypeSegmentedControl setTitle:kLanguageForKey(231) forSegmentAtIndex:0];
    [self.loginTypeSegmentedControl setTitle:kLanguageForKey(232) forSegmentAtIndex:1];
    [self.languageBtn setTitle:kLanguageForKey(3) forState:UIControlStateNormal];
#ifdef Engineer
    self.versionLableTitle.text = kLanguageForKey(259);
    [self.registerBtn setTitle:kLanguageForKey(234) forState:UIControlStateNormal];
    self.registerBtn.hidden = NO;
#else
    self.versionLableTitle.text = kLanguageForKey(258);
    self.registerBtn.hidden = YES;
#endif
    [self updateLoginView:self.loginTypeSegmentedControl.selectedSegmentIndex];
}


- (void)updateLoginView:(NSInteger)index{
    if (index == 0) {
        [self init2LoginTextField];
    }else{
        [self.loginBtn setTitle:kLanguageForKey(5) forState:UIControlStateNormal];
        self.passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.userNameImageView.hidden = YES;
        self.passwordImageView.hidden = YES;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *name = [defaults valueForKey:tcpMachineID];
        if (name) {
            self.loginTextField.text = name;
        }else{
            self.loginTextField.placeholder = kLanguageForKey(233);
        }
        self.passwordTextField.placeholder = kLanguageForKey(263);
    }
}
-(void)networkError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [hudLoading hideAnimated:YES];
        Network *network = gNetwork;
        if (network) {
            if (network->networkType == 0) {
                if (error.code == 8) {//网络没连接
                    [self makeToast:kLanguageForKey(224) duration:2.0 position:CSToastPositionCenter];
                }else if (error.code == 7){//连接被关闭
                    [self makeToast:kLanguageForKey(217) duration:2.0 position:CSToastPositionCenter];
                }else if (error.code == 3) {//连接超时
                    [self makeToast:kLanguageForKey(218) duration:2.0 position:CSToastPositionCenter];
                }else{//没有网络
                    [self makeToast:kLanguageForKey(224) duration:2.0 position:CSToastPositionCenter];
                }
            }
            else {
                if (error.code == 3) {
                    [self makeToast:kLanguageForKey(9) duration:2.0 position:CSToastPositionCenter];
                }
            }
            [[NetworkFactory sharedNetWork]disconnect];
        }
    });
}

- (IBAction)languageChangeBtnClicked:(id)sender {
    [self.paraNextView setObject:kLanguageForKey(3) forKey:@"title"];
    [gMiddeUiManager ChangeViewWithName:@"LanguageSettingView" Para:self.paraNextView];
}

- (IBAction)registerBtnClicked:(id)sender {
    [self.paraNextView setObject:kLanguageForKey(234) forKey:@"title"];
    [gMiddeUiManager ChangeViewWithName:@"RegisterView" Para:self.paraNextView];
}

-(void)updateWithHeader:(NSData*)headerData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [hudLoading hideAnimated:YES];
    });
    unsigned const char *a = headerData.bytes;
    if(a[0] == 0xc2 && a[1] == 1){
        NSLog(@"c2 01");
        [self checkAppUpdate];
        return;
    }
    if (self.loginTypeSegmentedControl.selectedSegmentIndex == 1) {
        
        if (headerData.length>0) {
            const unsigned char*a = headerData.bytes;
            if (a[0]== 0x01 && a[1] == 0x01) {
                kDataModel.loginState = LoginIn;
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.loginTextField.text forKey:tcpMachineID];
                [self.paraNextView setObject:kLanguageForKey(13) forKey:@"title"];
                [gMiddeUiManager ChangeViewWithName:@"HomeView" Para:self.paraNextView];
            }
            else if(a[0] == 0x02){
                
            }
            else if(a[0] == 0x01 && a[1] == 0x03)
            {
                [self makeToast:kLanguageForKey(12) duration:2.0 position:CSToastPositionCenter];
            }
            else if(a[0] == 0x01 && a[1] == 0x04)
            {
                [self makeToast:[NSString stringWithFormat:@"%@ %@",kLanguageForKey(213),kLanguageForKey(214)] duration:2.0 position:CSToastPositionCenter];
            }else if (a[0] == 0x01 && a[1] == 0x05){
                
                [self makeToast:kLanguageForKey(316) duration:2.0 position:CSToastPositionCenter];
            }else if (a[0] == 0x51)
            {
                if (a[1] == 0x01) {
                    NSLog(@"login success");
                }else if (a[1] == 2){
                    if (a[2] == 2) {
                        [self makeToast:kLanguageForKey(261) duration:2.0 position:CSToastPositionCenter];
                    }else if (a[2] == 3){//用户数据错误 设备编号 授权码 注册的用户名密码不对
                        [self makeToast:kLanguageForKey(262) duration:2.0 position:CSToastPositionCenter];
                    }
                }
                
            }
            
        }
    }else{
        if (kDataModel.getDeviceCount>0) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.loginTextField.text forKey:udpMachineID];
            [defaults setObject:self.passwordTextField.text forKey:udpMachinePwd];
            [self.paraNextView setObject:kLanguageForKey(15) forKey:@"title"];
            [gMiddeUiManager ChangeViewWithName:@"DeviceListUI" Para:self.paraNextView];
        }
        else
        {
            [self makeToast:kLanguageForKey(11) duration:2.0 position:CSToastPositionCenter];
            [[NetworkFactory sharedNetWork]disconnect];
        }
    }
}

- (IBAction)LoginTypeChanged:(UISegmentedControl *)sender {
    [self endEditing:YES];
    self.loginTextField.text = @"";
    self.passwordTextField.text = @"";
    [self updateLoginView:sender.selectedSegmentIndex];
}
- (IBAction)login:(id)sender {
    [self endEditing:YES];
#ifdef Engineer
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *registerInfo = [defaults valueForKey:registerInfoKey];
    if (registerInfo.length == 0) {
        NSString *string = kLanguageForKey(239);
        [self.window makeToast:kLanguageForKey(239)  duration:2.0 position:CSToastPositionCenter];
    }else{
#endif
        if(self.loginTypeSegmentedControl.selectedSegmentIndex == 0){
            [NetworkFactory createNetworkWithType:1];
            if([gNetwork open]){
                [self loginWithNetworkString:@"udp"];
            }else{
                [hudLoading hideAnimated:YES];
                [self makeToast:kLanguageForKey(9) duration:2.0 position:CSToastPositionCenter];
            }
        }else{
            [NetworkFactory createNetworkWithType:0];
            [self loginWithNetworkString:@"tcp"];
        }
#ifdef Engineer
    }
#endif
}
-(void)loginWithNetworkString:(NSString*)loginString
{
    NSString *nameStr = self.loginTextField.text;
    NSString *pwdStr = self.passwordTextField.text;
    if ([loginString isEqualToString:@"udp"]) {
        if (nameStr.length == 0 || pwdStr.length == 0) {
            [self makeToast:kLanguageForKey(7) duration:2.0 position:CSToastPositionCenter];
        }else{
            hudLoading = [MBProgressHUD showHUDAddedTo:self animated:YES];
            hudLoading.label.text = NSLocalizedString(kLanguageForKey(8), @"HUD loading title");
            hudLoading.label.font = [UIFont italicSystemFontOfSize:16.f];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NetworkFactory sharedNetWork] connectwithString1:nameStr String2:pwdStr];});
        }
    }else{
        if (nameStr.length == 0) {
            [self makeToast:kLanguageForKey(243) duration:2.0 position:CSToastPositionCenter];
        }else if (pwdStr.length == 0) {
            [self makeToast:kLanguageForKey(264) duration:2.0 position:CSToastPositionCenter];
        }else{
            hudLoading = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
            hudLoading.label.text = NSLocalizedString(kLanguageForKey(6), @"HUD loading title");
            hudLoading.label.font = [UIFont italicSystemFontOfSize:16.f];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NetworkFactory sharedNetWork] connectwithString1:nameStr String2:pwdStr];
            });
        }
    }
}
#pragma mark updateTipsDelegate
-(void)tipsViewResult:(Byte)value{
    if (value) {
        NSString *urlstring=[[kDataModel.appVersionDictionary valueForKey:@"url"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:urlstring];
        
        [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:^(BOOL success) {
            if (!success) {
            }
            
        }];
    }else{
 
    }
}
-(TipsView*)tipsView{
    if (!_tipsView) {
        _tipsView = [[TipsView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2-130, self.bounds.size.height / 2-80, 260, 160)];
        _tipsView.delegate=self;
        _tipsView.backgroundColor=[UIColor whiteColor];
        _tipsView.layer.cornerRadius=10;
    }
    return _tipsView;
}

- (void)init2LoginTextField{
    [self.loginBtn setTitle:kLanguageForKey(4) forState:UIControlStateNormal];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults valueForKey:udpMachineID];
    NSString *pwd = [defaults valueForKey:udpMachinePwd];
    if (name) {
        self.loginTextField.text = name;
        if (pwd) {
            self.passwordTextField.text = pwd;
        }else{
            self.passwordTextField.placeholder = kLanguageForKey(236);
        }
    }else{
        self.loginTextField.placeholder = kLanguageForKey(235);
        self.passwordTextField.placeholder = kLanguageForKey(236);
    }
    self.userNameImageView.hidden = NO;
    self.passwordImageView.hidden = NO;
    self.passwordTextField.keyboardType = UIKeyboardTypeDefault;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.tipsView.backgroundView.frame = CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height);
    self.tipsView.frame = CGRectMake(self.bounds.size.width / 2-130, self.bounds.size.height / 2-80, 260, 160);
}
@end
