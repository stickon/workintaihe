//
//  GreenTeaShortStemView.m
//  thColorSort
//
//  Created by taihe on 2018/1/18.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "GreenTeaShortStemView.h"
@interface GreenTeaShortStemView ()
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *areaTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *areaavgTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *areasenseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *fatTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *fatsenseTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *lightTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lightSenseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lightSizeTitleLabel;

@property (strong, nonatomic) IBOutlet BaseUITextField *areaAvgTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *areaSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *fatSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *lightSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *lightSizeTextField;
@property (strong, nonatomic) IBOutlet UIButton *bigAreaUseBtn;
@property (strong, nonatomic) IBOutlet UIButton *smallAreaUseBtn;
@property (strong, nonatomic) IBOutlet UIButton *fatUseBtn;
@property (strong, nonatomic) IBOutlet UIButton *lightUseBtn;
@end
@implementation GreenTeaShortStemView

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle]loadNibNamed:@"GreenTeaShortStemView" owner:self options:nil] firstObject];
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
        [self initCurrentLayerLabel];
    }else{
        self.currentLayerLabel.frame = CGRectZero;
        self.currentLayerLabelHeightConstraint.constant = 0.0f;
    }
    [[NetworkFactory sharedNetWork] getGreenTeaSG];
    return self;
}

-(void)initView{
    self.bigAreaUseBtn.layer.cornerRadius = 3.0f;
    self.smallAreaUseBtn.layer.cornerRadius = 3.0f;
    self.fatUseBtn.layer.cornerRadius = 3.0f;
    self.lightUseBtn.layer.cornerRadius = 3.0f;
    [self.bigAreaUseBtn setTitle:kLanguageForKey(362) forState:UIControlStateNormal];
    [self.bigAreaUseBtn setTitle:kLanguageForKey(363) forState:UIControlStateSelected];
    [self.smallAreaUseBtn setTitle:kLanguageForKey(364) forState:UIControlStateNormal];
    [self.smallAreaUseBtn setTitle:kLanguageForKey(365) forState:UIControlStateSelected];
    [self.lightUseBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.lightUseBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    [self.fatUseBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.fatUseBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    self.title = [NSString stringWithFormat:@"%@%@",kLanguageForKey(167),kLanguageForKey(284)];
    [self initLanguage];
}

-(void)initLanguage{
    self.areaTitleLabel.text = kLanguageForKey(123);
    self.areaavgTitleLabel.text = kLanguageForKey(361);
    self.areasenseTitleLabel.text = kLanguageForKey(14);
    self.fatTitleLabel.text = [NSString stringWithFormat:@"%@%@",kLanguageForKey(278),kLanguageForKey(354)];
    self.fatsenseTitleLabel.text = kLanguageForKey(14);
    self.lightTitleLabel.text =[NSString stringWithFormat:@"%@%@",kLanguageForKey(276),kLanguageForKey(354)];
    self.lightSenseTitleLabel.text = kLanguageForKey(14);
    self.lightSizeTitleLabel.text = kLanguageForKey(277);
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x1f) {
        [self updateView];
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (header[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getGreenTeaSG];
    }
}

-(void)updateView{
    Device *device = kDataModel.currentDevice;
    
    self.areaAvgTextField.text = [NSString stringWithFormat:@"%d",device->greenTeaSG.textView[0]];
    self.areaSenseTextField.text = [NSString stringWithFormat:@"%d",device->greenTeaSG.textView[1]];
    self.fatSenseTextField.text = [NSString stringWithFormat:@"%d",device->greenTeaSG.textView[2]];
    self.lightSenseTextField.text = [NSString stringWithFormat:@"%d",device->greenTeaSG.textView[3]];
    self.lightSizeTextField.text = [NSString stringWithFormat:@"%d",device->greenTeaSG.lastView[0]*256+device->greenTeaSG.lastView[1]];
    
    if (device->greenTeaSG.buttonUse[0]) {
        self.bigAreaUseBtn.selected = true;
        self.bigAreaUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.bigAreaUseBtn.selected = false;
        self.bigAreaUseBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->greenTeaSG.buttonUse[1]) {
        self.smallAreaUseBtn.selected = true;
        self.smallAreaUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.smallAreaUseBtn.selected = false;
        self.smallAreaUseBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->greenTeaSG.buttonUse[2]) {
        self.fatUseBtn.selected = true;
        self.fatUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.fatUseBtn.selected = false;
        self.fatUseBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->greenTeaSG.buttonUse[3]) {
        self.lightUseBtn.selected = true;
        self.lightUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.lightUseBtn.selected = false;
        self.lightUseBtn.backgroundColor = [UIColor TaiheColor];
    }
}
- (IBAction)useBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [[NetworkFactory sharedNetWork] setGreenTeaSGStateWithType:sender.tag-10 State:1];
    }else{
        [[NetworkFactory sharedNetWork] setGreenTeaSGStateWithType:sender.tag-10 State:0];
    }
}

- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag == 1) {
        [sender initKeyboardWithMax:5 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 2) {
        [sender initKeyboardWithMax:30 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 3) {
        [sender initKeyboardWithMax:244 Min:64 Value:sender.text.integerValue];
    }else if (sender.tag == 4) {
        [sender initKeyboardWithMax:255 Min:0 Value:sender.text.integerValue];
    }else if (sender.tag == 5) {
        [sender initKeyboardWithMax:3000 Min:0 Value:sender.text.integerValue];
    }
    
}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [[NetworkFactory sharedNetWork] setGreenTeaSGWithType:sender.tag Value:sender.text.integerValue];
}

#pragma mark -切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork] getGreenTeaSG];
}

@end
