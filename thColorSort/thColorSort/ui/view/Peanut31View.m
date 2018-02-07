//
//  Peanut31View.m
//  thColorSort
//
//  Created by taihe on 2018/1/18.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "Peanut31View.h"
#import "MyGroupView.h"
@interface Peanut31View ()<MyTextFieldDelegate,GroupBtnDelegate>{
    int currentgroup;//一次 二次
}
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *SenseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *LimitSenseTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *SenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *LimitSenseTextField;

@property (strong, nonatomic) IBOutlet UILabel *LengthTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *WidthTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *SizeTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *LengthTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *WidthTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *SizeTextField;
@property (strong, nonatomic) IBOutlet UIButton *LimitUseBtn;
@property (strong, nonatomic) IBOutlet UIButton *UseStateBtn;
@property (strong, nonatomic) IBOutlet MyGroupView *groupView;//分组 一次二次

@end

@implementation Peanut31View

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle]loadNibNamed:@"Peanut31View" owner:self options:nil] firstObject];
         [self initView];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}

-(UIView*)getViewWithPara:(NSDictionary *)para{
    Device *device = kDataModel.currentDevice;
    if (device->machineData.layerNumber>1) {
        self.baseLayerLabel = self.currentLayerLabel;
    }else{
        self.currentLayerLabel.frame = CGRectZero;
        self.currentLayerLabelHeightConstraint.constant = 0.0f;
    }
    [[NetworkFactory sharedNetWork] getPeanutbud];
    return self;
}

-(void)initView{
   
    [self.LimitUseBtn setTitle:kLanguageForKey(299) forState:UIControlStateNormal];
    [self.LimitUseBtn setTitle:kLanguageForKey(298) forState: UIControlStateSelected];
    [self.UseStateBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.UseStateBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    self.LimitUseBtn.layer.cornerRadius = 3.0f;
    self.UseStateBtn.layer.cornerRadius = 5.0f;
    self.groupView.delegate = self;
    [self initLanguage];
}

-(void)initLanguage{
    self.title = kLanguageForKey(162);
    self.SenseTitleLabel.text = kLanguageForKey(14);
    self.LimitSenseTitleLabel.text = kLanguageForKey(383);
    self.LengthTitleLabel.text = kLanguageForKey(380);
    self.WidthTitleLabel.text = kLanguageForKey(381);
    self.SizeTitleLabel.text = kLanguageForKey(382);
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x13) {
        [self updateView];
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (header[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getPeanutbud];
    }
}

-(void)updateView{
    Device *device = kDataModel.currentDevice;
    if (device->peanutbud3.isHasSecond) {
        if (self.groupView->groupNum != 2){
            [self.groupView setGroupNum:2 Title:[NSArray arrayWithObjects:kLanguageForKey(331),kLanguageForKey(332), nil]];
        }
        [self.groupView setHidden:NO];
    }else{
        [self.groupView setHidden:YES];
        currentgroup = 0;
    }
    bool enabled = NO;
    if (currentgroup == 0) {
        if (device->peanutbud3.buttonUse[0]) {
            self.LimitUseBtn.selected = YES;
            self.LimitUseBtn.backgroundColor = [UIColor greenColor];
            enabled = YES;
        }else{
            self.LimitUseBtn.selected = NO;
            self.LimitUseBtn.backgroundColor = [UIColor TaiheColor];
            enabled = NO;
        }
        [self.SenseTextField setText:[NSString stringWithFormat:@"%d",device->peanutbud3.textView[0]]];
        [self.LimitSenseTextField setText:[NSString stringWithFormat:@"%d",device->peanutbud3.textView[1]]];
        [self.LengthTextField setText:[NSString stringWithFormat:@"%d",device->peanutbud3.textView[2]]];
        [self.WidthTextField setText:[NSString stringWithFormat:@"%d",device->peanutbud3.textView[3]]];
        [self.SizeTextField setText:[NSString stringWithFormat:@"%d",device->peanutbud3.textView[4]*256+device->peanutbud3.textView[5]]];
    }else if (currentgroup == 1){
        if (device->peanutbud3.buttonUse[1]) {
            self.LimitUseBtn.selected = YES;
            self.LimitUseBtn.backgroundColor = [UIColor greenColor];
            enabled = YES;
        }else{
            self.LimitUseBtn.selected = NO;
            self.LimitUseBtn.backgroundColor = [UIColor TaiheColor];
            enabled = NO;
        }
        [self.SenseTextField setText:[NSString stringWithFormat:@"%d",device->peanutbud3.textView[6]]];
        [self.LimitSenseTextField setText:[NSString stringWithFormat:@"%d",device->peanutbud3.textView[7]]];
        [self.LengthTextField setText:[NSString stringWithFormat:@"%d",device->peanutbud3.textView[8]]];
        [self.WidthTextField setText:[NSString stringWithFormat:@"%d",device->peanutbud3.textView[9]]];
        [self.SizeTextField setText:[NSString stringWithFormat:@"%d",device->peanutbud3.textView[10]*256+device->peanutbud3.textView[11]]];
    }
    
    [self.LimitSenseTextField setEnabled:enabled];
    [self.LengthTextField setEnabled:enabled];
    [self.WidthTextField setEnabled:enabled];
    [self.SizeTextField setEnabled:enabled];
    if (device->peanutbud3.buttonUse[2]) {
        self.UseStateBtn.selected = YES;
        self.UseStateBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.UseStateBtn.selected = NO;
        self.UseStateBtn.backgroundColor = [UIColor TaiheColor];
    }
}
- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag == 1) {
        [sender initKeyboardWithMax:9 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 2){
        [sender initKeyboardWithMax:255 Min:0 Value:sender.text.integerValue];
    }else if (sender.tag == 3){
        [sender initKeyboardWithMax:21 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 4){
        [sender initKeyboardWithMax:19 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 5){
        [sender initKeyboardWithMax:(self.LengthTextField.text.intValue)*(self.WidthTextField.text.intValue) Min:1 Value:sender.text.integerValue];
    }
    
}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    if (sender.tag == 3 || sender.tag == 4) {
        if (self.SizeTextField.text.intValue > self.LengthTextField.text.intValue*self.WidthTextField.text.intValue) {
            [self.SizeTextField setText:[NSString stringWithFormat:@"%d", self.LengthTextField.text.intValue*self.WidthTextField.text.intValue]];
            if (currentgroup == 0) {
                [[NetworkFactory sharedNetWork] setPeanutbudEditWithIndex:5 Data:self.SizeTextField.text.intValue];
            }else if (currentgroup == 1){
                [[NetworkFactory sharedNetWork] setPeanutbudEditWithIndex:10 Data:self.SizeTextField.text.intValue];
            }
            
        }
    }
    if (currentgroup == 0) {
        [[NetworkFactory sharedNetWork] setPeanutbudEditWithIndex:sender.tag Data:sender.text.intValue];
    }else if (currentgroup == 1){
        [[NetworkFactory sharedNetWork] setPeanutbudEditWithIndex:sender.tag+5 Data:sender.text.intValue];
    }
}
- (IBAction)BtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    int value = 0;
    if (sender.selected) {
        value = 1;
    }else{
        value = 0;
    }
    if (sender.tag == 0) {
        [[NetworkFactory sharedNetWork] setPeanutbudBtnWithIndex:currentgroup Data:value];
    }else{
        [[NetworkFactory sharedNetWork] setPeanutbudBtnWithIndex:2 Data:value];
    }
}

#pragma mark -切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork] getPeanutbud];
}

#pragma mark 切换一次二次
- (void)groupBtnClicked:(Byte)index{
    currentgroup = index;
    [self updateView];
}

@end
