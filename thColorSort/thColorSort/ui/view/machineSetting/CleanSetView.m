//
//  CleanSetView.m
//  thColorSort
//
//  Created by taihe on 2018/1/10.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "CleanSetView.h"
@interface CleanSetView()<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet BaseUITextField *cleanCycleTextField;
@property (strong, nonatomic) IBOutlet UIButton *cleanOpenCloseValveBtn;

@property (strong, nonatomic) IBOutlet BaseUITextField *cleanDelayTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *cleanTimeTextField;
@property (strong, nonatomic) IBOutlet UIButton *cleanGo;
@property (strong, nonatomic) IBOutlet UIButton *cleanBack;
@property (strong, nonatomic) IBOutlet UILabel *cleanDelayTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *cleanCycleTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *cleanTimeTitleLabel;
@end

@implementation CleanSetView
-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"CleanSetView" owner:self options:nil] firstObject];
        
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        [[NetworkFactory sharedNetWork] getCleanPara];
    }
    return self;
}
-(UIView *)getViewWithPara:(NSDictionary *)para{
    [[NetworkFactory sharedNetWork] changeLayerAndView];
    [self.cleanGo.layer setCornerRadius:3.0];
    [self.cleanBack.layer setCornerRadius:3.0];
    [self.cleanOpenCloseValveBtn.layer setCornerRadius:3.0];
    [self.cleanGo setTitle: kLanguageForKey(82) forState:UIControlStateNormal];
    [self.cleanBack setTitle: kLanguageForKey(83) forState:UIControlStateNormal];
    [self.cleanCycleTextField configInputView];
    self.cleanCycleTextField.mydelegate = self;
    self.cleanOpenCloseValveBtn.tintColor = [UIColor clearColor];
    [self updateCleanGoAndBackState];//系统开启时设置清灰去和回是否隐藏
    [self initLanguage];
    return self;
}

-(void) initLanguage{
    
    [self.cleanCycleTitleLabel setText:kLanguageForKey(79)];
    [self.cleanDelayTitleLabel setText:kLanguageForKey(80)];
    [self.cleanTimeTitleLabel setText:kLanguageForKey(80)];
    [self.cleanOpenCloseValveBtn setTitle: kLanguageForKey(85) forState:UIControlStateNormal];
    [self.cleanOpenCloseValveBtn setTitle: kLanguageForKey(84) forState:UIControlStateSelected];
}
#pragma mark - MyTextFieldDelegate
- (IBAction)textFieldDidBegin:(BaseUITextField *)sender {
    sender.mydelegate = self;
    [sender configInputView];
    if (sender.tag == 100) {
        [sender initKeyboardWithMax:60 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 101){
        [sender initKeyboardWithMax:60 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 102){
        [sender initKeyboardWithMax:15 Min:3 Value:sender.text.integerValue];
    }
}

-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [self sendCleanParaWithType:0];//设置清灰参数
    
}

- (IBAction)cleanOpenCloseBtnClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        sender.backgroundColor = [UIColor greenColor];
        sender.tintColor = sender.backgroundColor;
    }else{
        sender.backgroundColor = [UIColor colorWithRed:1/255.0 green:178.0/255.0 blue:181.0/255.0 alpha:1.0];
        sender.tintColor = sender.backgroundColor;
    }
    [self sendCleanParaWithType:1];//设置清灰开启关闭喷阀
}
-(void)sendCleanParaWithType:(Byte)type
{
    Byte data[4] = {0};
    data[0]= (Byte)(_cleanCycleTextField.text.intValue);
    data[1] =(Byte)(_cleanDelayTextField.text.intValue);
    data[2] = (Byte)(_cleanTimeTextField.text.intValue);
    if (self.cleanOpenCloseValveBtn.selected) {
        data[3] = 1;
    }
    else
    {
        data[3] = 0;
    }
    [[NetworkFactory sharedNetWork]setCleanParaWithData:data AndCloseValveType:type];
}
- (IBAction)cleanControlBtnClicked:(UIButton *)sender {
    Byte type;
    if (sender.tag == 0) {
        type = 0x01;
    }
    else
    {
        type = 0x02;
    }
    [[NetworkFactory sharedNetWork]sendCleanWithType:type];
}

- (void)refreshCurrentView{
   [[NetworkFactory sharedNetWork] getCleanPara];
}
-(void)updateWithHeader:(NSData*)headerData
{
    
    Device *device = kDataModel.currentDevice;
    const Byte *a = headerData.bytes;
    if (a[0] == 0x07 && a[1] == 0x03) {
        _cleanCycleTextField.text = [NSString stringWithFormat:@"%d",device->cleanPara.cleanCycle];
        _cleanDelayTextField.text = [NSString stringWithFormat:@"%d",device->cleanPara.cleanDelay];
        _cleanTimeTextField.text = [NSString stringWithFormat:@"%d",device->cleanPara.cleanTime];
        if (device->cleanPara.cleanSwitch == 0) {
            self.cleanOpenCloseValveBtn.backgroundColor = [UIColor colorWithRed:1/255.0 green:178.0/255.0 blue:181.0/255.0 alpha:1.0];
            self.cleanOpenCloseValveBtn.selected = false;
        }
        else{
            self.cleanOpenCloseValveBtn.selected = true;
            self.cleanOpenCloseValveBtn.backgroundColor = [UIColor greenColor];
            
        }
    }
    if(a[0] == 0x03 && a[1] == 0x03){
        [self updateCleanGoAndBackState];
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [self refreshCurrentView];
    }
}

-(void)updateCleanGoAndBackState{
    Device *device = kDataModel.currentDevice;
    if (device->machineData.startState == 1) {
        self.cleanGo.hidden = YES;
        self.cleanBack.hidden = YES;
    }else{
        self.cleanGo.hidden = NO;
        self.cleanBack.hidden = NO;
    }
}


@end
