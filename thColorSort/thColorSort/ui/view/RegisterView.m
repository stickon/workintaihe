//
//  RegisterView.m
//  thColorSort
//
//  Created by taihe on 2018/1/15.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "RegisterView.h"
@interface RegisterView(){
    MBProgressHUD *hudLoading;
}
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *pwdTextField;
@property (strong, nonatomic) IBOutlet UITextField *insurePwdTextField;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
@end
@implementation RegisterView

-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"RegisterView" owner:self options:nil] firstObject];
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
    self.userNameTextField.borderStyle=UITextBorderStyleNone;
    self.userNameTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.userNameTextField.layer.cornerRadius=3.0f;
    self.userNameTextField.layer.masksToBounds=YES;
    self.userNameTextField.layer.borderColor = [UIColor colorWithRed:125.0/255.0 green:125.0/255.0 blue:125.0/255.0 alpha:0.3].CGColor;
    self.userNameTextField.layer.borderWidth = 1.0f;
    
    self.pwdTextField.borderStyle=UITextBorderStyleNone;
    self.pwdTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    self.pwdTextField.layer.cornerRadius=3.0f;
    self.pwdTextField.layer.masksToBounds=YES;
    self.pwdTextField.layer.borderColor = [UIColor colorWithRed:125.0/255.0 green:125.0/255.0 blue:125.0/255.0 alpha:0.3].CGColor;
    self.pwdTextField.layer.borderWidth = 1.0f;
    
    self.insurePwdTextField.borderStyle=UITextBorderStyleNone;
    self.insurePwdTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.insurePwdTextField.leftViewMode = UITextFieldViewModeAlways;
    self.insurePwdTextField.layer.cornerRadius=3.0f;
    self.insurePwdTextField.layer.masksToBounds=YES;
    self.insurePwdTextField.layer.borderColor = [UIColor colorWithRed:125.0/255.0 green:125.0/255.0 blue:125.0/255.0 alpha:0.3].CGColor;
    self.insurePwdTextField.layer.borderWidth = 1.0f;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *registerInfo = [defaults valueForKey:registerInfoKey];
    if (registerInfo) {
        NSArray *registerArray = [registerInfo componentsSeparatedByString:@"#"];
        if (registerArray.count == 2) {
            self.userNameTextField.text = [registerArray objectAtIndex:0];
            self.pwdTextField.text = [registerArray objectAtIndex:1];
            self.insurePwdTextField.text = [registerArray objectAtIndex:1];
        }
    }else{
        self.registerBtn.enabled = NO;
    }
}

- (void)initLanguage{
    self.userNameTextField.placeholder = kLanguageForKey(235);
    self.pwdTextField.placeholder =kLanguageForKey(236);
    self.insurePwdTextField.placeholder = kLanguageForKey(237);
    [self.registerBtn setTitle:kLanguageForKey(234) forState:UIControlStateNormal];
    [self.registerBtn.layer setCornerRadius:3.0];
    self.title = kLanguageForKey(234);
}
- (IBAction)textFieldEditDidEnd:(UITextField *)sender {
    if (self.userNameTextField.text.length != 0&&self.pwdTextField.text.length != 0 && self.insurePwdTextField.text.length != 0) {
        self.registerBtn.enabled = YES;
    }
}

- (IBAction)registerBtnClicked:(id)sender {
    NSString *nameStr = self.userNameTextField.text;
    NSString *pwdStr = self.pwdTextField.text;
    NSString *insurePwdStr = self.insurePwdTextField.text;
    if ([pwdStr isEqualToString:insurePwdStr]) {
        [NetworkFactory createNetworkWithType:0];
        [NetworkFactory sharedNetWork]->registerUserName = nameStr;
        [NetworkFactory sharedNetWork]->registerPwd = pwdStr;
        hudLoading = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hudLoading.label.text = NSLocalizedString(kLanguageForKey(234), @"HUD loading title");
        hudLoading.label.font = [UIFont italicSystemFontOfSize:16.f];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NetworkFactory sharedNetWork] registerUserInfo];});
    }else{
        [self makeToast:kLanguageForKey(238) duration:2.0 position:CSToastPositionCenter];
    }
}


-(void)updateWithHeader:(NSData*)headerData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [hudLoading hideAnimated:YES];
    });
    unsigned const char *a = headerData.bytes;
    if(a[0] == 0x56){
        if (a[1] == 1) {
            [self.window makeToast:kLanguageForKey(249) duration:2.0 position:CSToastPositionCenter];
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            NSString *registerInfoStr = [NSString stringWithFormat:@"%@#%@",self.userNameTextField.text,self.pwdTextField.text];
            [def setValue:registerInfoStr forKey:registerInfoKey];
            [def synchronize];
            [super Back];
        }else if (a[1] == 2){
            [self.window makeToast:kLanguageForKey(250) duration:2.0 position:CSToastPositionCenter];
            [super Back];
        }else if (a[1] == 3){
            [self makeToast:kLanguageForKey(251) duration:2.0 position:CSToastPositionCenter];
        }
    }
    
    
    
}

-(void)networkError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [hudLoading hideAnimated:YES];
        if ([NetworkFactory sharedNetWork]) {
            if ([NetworkFactory sharedNetWork]->networkType == 0) {
                if (error.code == 8) {//网络没连接
                    [self makeToast:kLanguageForKey(224) duration:2.0 position:CSToastPositionCenter];
                }else if (error.code == 7){//连接被关闭
                    //[self.view makeToast:kLanguageForKey(217) duration:2.0 position:CSToastPositionCenter];
                }else if (error.code == 3) {//连接超时
                    [self makeToast:kLanguageForKey(218) duration:2.0 position:CSToastPositionCenter];
                }else{//没有网络
                    [self makeToast:kLanguageForKey(224) duration:2.0 position:CSToastPositionCenter];
                }
            }
            [[NetworkFactory sharedNetWork]disconnect];
        }
    });
}
@end
