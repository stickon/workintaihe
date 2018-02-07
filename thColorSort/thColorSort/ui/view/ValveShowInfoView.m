//
//  ValveShowInfoView.m
//  thColorSort
//
//  Created by taihe on 2018/1/15.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "ValveShowInfoView.h"
#import "ValveShowView.h"
@interface ValveShowInfoView()<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet ValveShowView *valveShowView;
@property (strong, nonatomic) IBOutlet UILabel *chuteNumLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *chuteNumTextField;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *frontViewLabel;
@property (strong, nonatomic) IBOutlet UILabel *rearViewLabel;

@end
@implementation ValveShowInfoView

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"ValveShowInfoView" owner:self options:nil] firstObject];
        [self initView];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}

-(UIView*)getViewWithPara:(NSDictionary *)para{
    return self;
}

-(void)initView{
    self.valveShowView.valveNum = 72;
    self.valveShowView->frontValveFrequency = NULL;
    self.valveShowView->rearValveFrequency = NULL;
    self.title = kLanguageForKey(149);
    self.chuteNumLabel.text =  kLanguageForKey(41);
    self.chuteNumTextField.text = [NSString stringWithFormat:@"%d",kDataModel.currentDevice.currentSorterIndex];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(valvetimeout) userInfo:nil repeats:YES];
    Device *device = kDataModel.currentDevice;
    if (device->machineData.layerNumber>1) {
        self.baseLayerLabel = self.currentLayerLabel;
        
    }else{
        self.currentLayerLabel.frame = CGRectZero;
        self.currentLayerLabelHeightConstraint.constant = 0.0f;
    }
    [self initLanguage];
}

- (void)initLanguage{
    self.frontViewLabel.text = kLanguageForKey(75);
    self.rearViewLabel.text = kLanguageForKey(76);
}

-(void)updateWithHeader:(NSData *)headerData{
    const char*a = headerData.bytes;
    Device *device = kDataModel.currentDevice;
    if (a[0] == 0x0e) {
        if (a[1] == 0x01) {
            [self.valveShowView bindValveData:device->valveFrequency withValveNum:device->valveCount HasRearView:device->valveFrontRear];
        }
    }else if (a[0] == 0x55){
        [_timer invalidate];
        [super updateWithHeader:headerData];
    }
}


-(void)networkError:error{
    [_timer invalidate];
    [super networkError:error];
}
- (IBAction)myTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:kDataModel.currentDevice->machineData.chuteNumber Min:1 Value:sender.text.integerValue];
}



#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    Byte value = sender.text.intValue;
    kDataModel.currentDevice.currentSorterIndex = value;
    
}

-(void)valvetimeout{
    [[NetworkFactory sharedNetWork] getValveFrequency];
}

-(BOOL)Back{
    [_timer invalidate];
    return [super Back];
}

#pragma mark - layout subview

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = (width-80)*0.618+20;
    NSLog(@"%f",height);
    self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, height+100);
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, height+100);
    NSLog(@"screenwidth:%f",[UIScreen mainScreen].bounds.size.width);
    NSLog(@"screen height:%f",[UIScreen mainScreen].bounds.size.height);
    [self.valveShowView setNeedsLayout];
}

#pragma mark 切换层
- (void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
}

@end
