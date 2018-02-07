//
//  PeanutView.m
//  thColorSort
//
//  Created by taihe on 2018/1/18.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "PeanutView.h"
@interface PeanutView ()
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *firstSenseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *SecondSenseTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *firstSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *seconSenseTextField;
@property (strong, nonatomic) IBOutlet UIButton *firstSenseUseBtn;
@property (strong, nonatomic) IBOutlet UIButton *secondSenseUseBtn;
@property (strong, nonatomic) IBOutlet UIButton *UseStateBtn;
@end

@implementation PeanutView

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle]loadNibNamed:@"PeanutView" owner:self options:nil] firstObject];
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
    [self.firstSenseUseBtn setTitle:kLanguageForKey(299) forState:UIControlStateNormal];
    [self.firstSenseUseBtn setTitle:kLanguageForKey(298) forState: UIControlStateSelected];
    [self.secondSenseUseBtn setTitle:kLanguageForKey(299) forState:UIControlStateNormal];
    [self.secondSenseUseBtn setTitle:kLanguageForKey(298) forState:UIControlStateSelected];
    [self.UseStateBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.UseStateBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    self.firstSenseUseBtn.layer.cornerRadius = 3.0f;
    self.secondSenseUseBtn.layer.cornerRadius = 3.0f;
    self.UseStateBtn.layer.cornerRadius = 5.0f;
    [self initLanguage];
}

-(void)initLanguage{
    self.title = kLanguageForKey(162);
    self.firstSenseTitleLabel.text = kLanguageForKey(296);
    self.SecondSenseTitleLabel.text = kLanguageForKey(297);
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
    BOOL hiddenSecond;
    if (device->peanutbud.isHasSecond) {
        hiddenSecond = NO;
        self.seconSenseTextField.text = [NSString stringWithFormat:@"%d",device->peanutbud.textView[1]];
        if (device->peanutbud.buttonUse[1]) {
            self.secondSenseUseBtn.selected = YES;
            self.secondSenseUseBtn.backgroundColor = [UIColor greenColor];
        }else{
            self.secondSenseUseBtn.selected = NO;
            self.secondSenseUseBtn.backgroundColor = [UIColor TaiheColor];
        }
    }else{
        hiddenSecond = YES;
    }
    self.SecondSenseTitleLabel.hidden = hiddenSecond;
    self.seconSenseTextField.hidden = hiddenSecond;
    self.secondSenseUseBtn.hidden = hiddenSecond;
    self.firstSenseTextField.text = [NSString stringWithFormat:@"%d",device->peanutbud.textView[0]];
    if (device->peanutbud.buttonUse[0]) {
        self.firstSenseUseBtn.selected = YES;
        self.firstSenseUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.firstSenseUseBtn.selected = NO;
        self.firstSenseUseBtn.backgroundColor = [UIColor TaiheColor];
    }
    
    if (device->peanutbud.buttonUse[2]) {
        self.UseStateBtn.selected = YES;
        self.UseStateBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.UseStateBtn.selected = NO;
        self.UseStateBtn.backgroundColor = [UIColor TaiheColor];
    }
}

- (IBAction)useStateChanged:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = [UIColor greenColor];
        [[NetworkFactory sharedNetWork] setPeanutbudBtnWithIndex:(int)sender.tag-10 Data:1];
    }else{
        sender.backgroundColor = [UIColor TaiheColor];
        [[NetworkFactory sharedNetWork] setPeanutbudBtnWithIndex:(int)sender.tag-10 Data:0];
    }
}
- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:9 Min:1 Value:sender.text.integerValue];
}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [[NetworkFactory sharedNetWork] setPeanutbudEditWithIndex:(int)sender.tag Data:(int)sender.text.integerValue];
}

#pragma mark -切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork] getPeanutbud];
}
@end
