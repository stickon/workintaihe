//
//  RedTeaView.m
//  thColorSort
//
//  Created by taihe on 2018/1/18.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "RedTeaView.h"
@interface RedTeaView ()<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *lengthTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *disableLengthTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *enableLengthTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *enableShortTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *senseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *minLengthTitleLabel;
@property (strong, nonatomic) IBOutlet UISwitch *disableLengthSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *enableLengthSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *enableShortSwitch;
@property (strong, nonatomic) IBOutlet BaseUITextField *senseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *minLengthTextField;
@property (strong, nonatomic) IBOutlet UILabel *areaTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *areaAvgTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *areaSenseTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *areaAvgTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *areaSenseTextField;
@property (strong, nonatomic) IBOutlet UIButton *bigAreaUseBtn;
@property (strong, nonatomic) IBOutlet UIButton *smallAreaUseBtn;
@property (strong, nonatomic) IBOutlet UILabel *thicknessTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *disablethicknessTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *enableFatTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *enableThinTitleLabel;
@property (strong, nonatomic) IBOutlet UISwitch *disablethicknessSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *enableFatSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *enableThinSwitch;
@property (strong, nonatomic) IBOutlet UILabel *widthTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *heightTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *fatSenseTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *widthTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *heightTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *sizeTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *fatSenseTextField;

@end
@implementation RedTeaView

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle]loadNibNamed:@"RedTeaView" owner:self options:nil] firstObject];
        [self initView];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}

-(UIView*)getViewWithPara:(NSDictionary *)para{
    [self initView];
    Device *device = kDataModel.currentDevice;
    if (device->machineData.layerNumber>1) {
        self.baseLayerLabel = self.currentLayerLabel;
    }else{
        self.currentLayerLabel.frame = CGRectZero;
        self.currentLayerLabelHeightConstraint.constant = 0.0f;
    }
    [[NetworkFactory sharedNetWork] getRedTea];
    return self;
}

-(void)initView{
    [self.bigAreaUseBtn setTitle:kLanguageForKey(362) forState:UIControlStateNormal];
    [self.bigAreaUseBtn setTitle:kLanguageForKey(363) forState:UIControlStateSelected];
    [self.smallAreaUseBtn setTitle:kLanguageForKey(364) forState:UIControlStateNormal];
    [self.smallAreaUseBtn setTitle:kLanguageForKey(365) forState:UIControlStateSelected];
    self.bigAreaUseBtn.layer.cornerRadius = 3.0f;
    self.smallAreaUseBtn.layer.cornerRadius = 3.0f;
    [self initLanguage];
}

-(void)initLanguage{
    self.lengthTitleLabel.text = kLanguageForKey(301);
    self.disableLengthTitleLabel.text = kLanguageForKey(287);
    self.enableLengthTitleLabel.text = kLanguageForKey(285);
    self.enableShortTitleLabel.text = kLanguageForKey(286);
    self.senseTitleLabel.text = kLanguageForKey(14);
    self.minLengthTitleLabel.text = kLanguageForKey(288);
    self.areaTitleLabel.text = kLanguageForKey(123);
    self.areaAvgTitleLabel.text = kLanguageForKey(361);
    self.areaSenseTitleLabel.text = kLanguageForKey(14);
    self.thicknessTitleLabel.text = kLanguageForKey(303);
    self.disablethicknessTitleLabel.text = kLanguageForKey(283);
    self.enableFatTitleLabel.text = kLanguageForKey(281);
    self.enableThinTitleLabel.text = kLanguageForKey(282);
    self.widthTitleLabel.text = kLanguageForKey(37);
    self.heightTitleLabel.text = kLanguageForKey(38);
    self.sizeTitleLabel.text = kLanguageForKey(39);
    self.fatSenseTitleLabel.text = kLanguageForKey(14);
    self.title = kLanguageForKey(159);
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x1e) {
        if (header[1] == 0x03) {
            [gNetwork getRedTea];
        }
        [self updateView];
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (header[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getRedTea];
    }
}

-(void)updateView{
    Device *device = kDataModel.currentDevice;
    self.senseTextField.text = [NSString stringWithFormat:@"%d",device->redTea.textView[0]];
    self.minLengthTextField.text = [NSString stringWithFormat:@"%d",device->redTea.textView[1]];
    self.areaAvgTextField.text = [NSString stringWithFormat:@"%d",device->redTea.textView[2]];
    self.areaSenseTextField.text = [NSString stringWithFormat:@"%d",device->redTea.textView[3]];
    self.widthTextField.text = [NSString stringWithFormat:@"%d",device->redTea.textView[4]];
    self.heightTextField.text = [NSString stringWithFormat:@"%d",device->redTea.textView[5]];
    self.sizeTextField.text = [NSString stringWithFormat:@"%d",device->redTea.textView[6]*256+device->redTea.textView[7]];
    self.fatSenseTextField.text = [NSString stringWithFormat:@"%d",device->redTea.textView[8]];
    int disableLengthIndex = device->redTea.buttonUse[0];
    if (disableLengthIndex == 0) {
        self.disableLengthSwitch.on = YES;
        self.disableLengthSwitch.userInteractionEnabled = NO;
        self.enableLengthSwitch.on = NO;
        self.enableShortSwitch.on = NO;
        self.senseTextField.enabled = NO;
        self.minLengthTextField.enabled = NO;
        
        self.enableLengthSwitch.userInteractionEnabled = YES;
        self.enableShortSwitch.userInteractionEnabled = YES;
    }else if (disableLengthIndex == 1){
        self.enableLengthSwitch.on = YES;
        self.enableLengthSwitch.userInteractionEnabled = NO;
        self.disableLengthSwitch.userInteractionEnabled = YES;
        self.enableShortSwitch.userInteractionEnabled = YES;
        self.disableLengthSwitch.on = NO;
        self.enableShortSwitch.on = NO;
        
        self.senseTextField.enabled = YES;
        self.minLengthTextField.enabled = NO;
    }else if (disableLengthIndex == 2){
        self.enableShortSwitch.on = YES;
        self.disableLengthSwitch.on = NO;
        self.enableLengthSwitch.on = NO;
        self.senseTextField.enabled = YES;
        self.minLengthTextField.enabled = YES;
        
        self.enableLengthSwitch.userInteractionEnabled = YES;
        self.disableLengthSwitch.userInteractionEnabled = YES;
        self.enableShortSwitch.userInteractionEnabled = NO;
    }
    if (device->redTea.buttonUse[1]) {
        self.bigAreaUseBtn.selected = YES;
        self.bigAreaUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.bigAreaUseBtn.selected = NO;
        self.bigAreaUseBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->redTea.buttonUse[2]) {
        self.smallAreaUseBtn.selected = YES;
        self.smallAreaUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.smallAreaUseBtn.selected = NO;
        self.smallAreaUseBtn.backgroundColor = [UIColor TaiheColor];
    }
    int fatthinIndex = device->redTea.buttonUse[3];
    if (fatthinIndex == 0) {
        self.disablethicknessSwitch.on = YES;
        self.enableFatSwitch.on = NO;
        self.enableThinSwitch.on = NO;
        
        self.enableFatSwitch.userInteractionEnabled = YES;
        self.enableThinSwitch.userInteractionEnabled = YES;
        self.disablethicknessSwitch.userInteractionEnabled = NO;
        self.widthTextField.enabled = NO;
        self.heightTextField.enabled = NO;
        self.sizeTextField.enabled = NO;
        self.fatSenseTextField.enabled = NO;
    }else if (fatthinIndex == 1){
        self.enableFatSwitch.on = YES;
        self.enableThinSwitch.on = NO;
        self.disablethicknessSwitch.on = NO;
        
        self.enableFatSwitch.userInteractionEnabled = NO;
        self.enableThinSwitch.userInteractionEnabled = YES;
        self.disablethicknessSwitch.userInteractionEnabled = YES;
        self.widthTextField.enabled = YES;
        self.heightTextField.enabled = YES;
        self.sizeTextField.enabled = YES;
        self.fatSenseTextField.enabled = YES;
    }else if (fatthinIndex == 2){
        self.enableThinSwitch.on = YES;
        self.disablethicknessSwitch.on = NO;
        self.enableFatSwitch.on = NO;
        self.enableFatSwitch.userInteractionEnabled = YES;
        self.enableThinSwitch.userInteractionEnabled = NO;
        self.disablethicknessSwitch.userInteractionEnabled = YES;
        
        self.widthTextField.enabled = NO;
        self.heightTextField.enabled = NO;
        self.sizeTextField.enabled = NO;
        self.fatSenseTextField.enabled = YES;
    }
}
- (IBAction)useStateChanged:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = [UIColor greenColor];
        [[NetworkFactory sharedNetWork] setRedTeaStateWithType:sender.tag-10 State:1];
    }else{
        sender.backgroundColor = [UIColor TaiheColor];
        [[NetworkFactory sharedNetWork] setRedTeaStateWithType:sender.tag-10 State:0];
    }
}

- (IBAction)switchUseStateChanged:(UISwitch *)sender {
    if (sender.tag == 21) {
        if (sender.on) {
            [[NetworkFactory sharedNetWork] setRedTeaStateWithType:0 State:0];
        }
    }else if (sender.tag == 22){
        [[NetworkFactory sharedNetWork] setRedTeaStateWithType:0 State:1];
    }else if (sender.tag == 23){
        [[NetworkFactory sharedNetWork] setRedTeaStateWithType:0 State:2];
    }else if (sender.tag == 31){
        [[NetworkFactory sharedNetWork] setRedTeaStateWithType:3 State:0];
    }else if (sender.tag == 32){
        {
            [[NetworkFactory sharedNetWork] setRedTeaStateWithType:3 State:1];
        }
    }else if (sender.tag == 33){
        if (sender.on) {
            [[NetworkFactory sharedNetWork] setRedTeaStateWithType:3 State:2];
        }
    }
}

- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag == 1) {
        [sender initKeyboardWithMax:255 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 2){
        [sender initKeyboardWithMax:255 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 3){
        [sender initKeyboardWithMax:5 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 4){
        [sender initKeyboardWithMax:30 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 5){
        [sender initKeyboardWithMax:19 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 6){
        [sender initKeyboardWithMax:19 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 7){
        [sender initKeyboardWithMax:self.widthTextField.text.integerValue*self.heightTextField.text.integerValue Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 8){
        [sender initKeyboardWithMax:248 Min:32 Value:sender.text.integerValue];
    }
}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [[NetworkFactory sharedNetWork] setRedTeaWithType:sender.tag Value:sender.text.integerValue];
}

#pragma mark -切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork] getRedTea];
}



@end
