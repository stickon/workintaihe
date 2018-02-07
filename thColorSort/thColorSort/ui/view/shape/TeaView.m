//
//  TeaView.m
//  thColorSort
//
//  Created by taihe on 2018/1/18.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "TeaView.h"

@interface TeaView ()<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *lightTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lightSenseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lightSizeTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *lightSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *lightSizeTextField;
@property (strong, nonatomic) IBOutlet UIButton *lightUseBtn;
@property (strong, nonatomic) IBOutlet UILabel *foldSenseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *foldTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *foldSenseTextField;
@property (strong, nonatomic) IBOutlet UIButton *foldUseBtn;
@property (strong, nonatomic) IBOutlet UILabel *fatstemTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *thinstemTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *fatstemTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *thinstemTextField;
@property (strong, nonatomic) IBOutlet UIButton *fatUseBtn;
@property (strong, nonatomic) IBOutlet UIButton *thinUseBtn;
@end
@implementation TeaView

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle]loadNibNamed:@"TeaView" owner:self options:nil] firstObject];
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
    [[NetworkFactory sharedNetWork] getTea];
    return self;
}

-(void)initView{
    self.lightUseBtn.layer.cornerRadius = 4.0f;
    self.foldUseBtn.layer.cornerRadius = 3.0f;
    self.fatUseBtn.layer.cornerRadius = 3.0f;
    self.thinUseBtn.layer.cornerRadius = 3.0f;
    [self initLanguage];
}

-(void)initLanguage{
    [self.lightUseBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.lightUseBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    [self.foldUseBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.foldUseBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    [self.fatUseBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.fatUseBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    [self.thinUseBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.thinUseBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    self.lightTitleLabel.text = kLanguageForKey(276);
    self.lightSenseTitleLabel.text = kLanguageForKey(14);
    self.lightSizeTitleLabel.text = kLanguageForKey(277);
    self.foldSenseTitleLabel.text = kLanguageForKey(14);
    self.foldTitleLabel.text = kLanguageForKey(278);
    self.fatstemTitleLabel.text = kLanguageForKey(279);
    self.thinstemTitleLabel.text = kLanguageForKey(280);
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x15) {
        [self updateView];
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (header[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getTea];
    }
}

-(void)updateView{
    Device *device = kDataModel.currentDevice;
    self.lightSenseTextField.text = [NSString stringWithFormat:@"%d",device->tea.textView[0][0]*256+device->tea.textView[0][1]];
    self.lightSizeTextField.text = [NSString stringWithFormat:@"%d",device->tea.textView[1][0]*256+device->tea.textView[1][1]];
    self.foldSenseTextField.text = [NSString stringWithFormat:@"%d",device->tea.textView[2][0]*256+device->tea.textView[2][1]];
    self.fatstemTextField.text = [NSString stringWithFormat:@"%d",device->tea.textView[3][0]*256+device->tea.textView[3][1]];
    self.thinstemTextField.text = [NSString stringWithFormat:@"%d",device->tea.textView[4][0]*256+device->tea.textView[4][1]];
    if (device->tea.buttonUse[0]) {
        self.lightUseBtn.selected = true;
        self.lightUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.lightUseBtn.selected = false;
        self.lightUseBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->tea.buttonUse[1]) {
        self.foldUseBtn.selected = true;
        self.foldUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.foldUseBtn.selected = false;
        self.foldUseBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->tea.buttonUse[2]) {
        self.fatUseBtn.selected = true;
        self.fatUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.fatUseBtn.selected = false;
        self.fatUseBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->tea.buttonUse[3]) {
        self.thinUseBtn.selected = true;
        self.thinUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.thinUseBtn.selected = false;
        self.thinUseBtn.backgroundColor = [UIColor TaiheColor];
    }
}

- (IBAction)useBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = [UIColor greenColor];
        [[NetworkFactory sharedNetWork] setTeaStateWithType:sender.tag-10 State:1];
    }else{
        sender.backgroundColor = [UIColor TaiheColor];
        [[NetworkFactory sharedNetWork] setTeaStateWithType:sender.tag-10 State:0];
    }
}

- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag == 1) {
        [sender initKeyboardWithMax:255 Min:0 Value:sender.text.integerValue];
    }else if (sender.tag == 2){
        [sender initKeyboardWithMax:3000 Min:0 Value:sender.text.integerValue];
    }else if (sender.tag == 3){
        [sender initKeyboardWithMax:244 Min:64 Value:sender.text.integerValue];
    }else if (sender.tag == 4){
        [sender initKeyboardWithMax:224 Min:64 Value:sender.text.integerValue];
    }else if (sender.tag == 5){
        [sender initKeyboardWithMax:255 Min:32 Value:sender.text.integerValue];
    }
}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [[NetworkFactory sharedNetWork] setTeaValueWithType:sender.tag Value:sender.text.integerValue];
}

#pragma mark -切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork] getTea];
}
@end
