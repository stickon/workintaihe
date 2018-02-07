//
//  LayerChangedView.m
//  thColorSort
//
//  Created by taihe on 2017/5/11.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "LayerChangedView.h"
@interface LayerChangedView(){
    Byte selectIndex;
    Byte currentIndex;
}
@property (strong, nonatomic) IBOutlet UIButton *layer1btn;
@property (strong, nonatomic) IBOutlet UIButton *layer2btn;
@property (strong, nonatomic) IBOutlet UIButton *layer3btn;
@property (strong, nonatomic) IBOutlet UIButton *layer4btn;
@property (strong, nonatomic) IBOutlet UIButton *layer5btn;
@property (strong, nonatomic) IBOutlet UIButton *layer6btn;
@property (strong, nonatomic) IBOutlet UIButton *cancelbtn;
@property (strong, nonatomic) IBOutlet UIButton *okbtn;
@end
@implementation LayerChangedView
-(id)initWithFrame:(CGRect)frame andBtnTitleArray:(NSArray*)array{
    if (self = [super initWithFrame:frame]) {
        NSArray *viewxib = [[NSBundle mainBundle]loadNibNamed:@"LayerChangedView" owner:self options:nil];
        self = [viewxib objectAtIndex:0];
        self.frame = frame;
        [self.layer1btn setTitle:[array objectAtIndex:0] forState:UIControlStateNormal];
        NSLog(@"layer:%@",[array objectAtIndex:0]);
        [self.layer1btn setTitle:[array objectAtIndex:0] forState:UIControlStateSelected];
        [self.layer2btn setTitle:[array objectAtIndex:1]forState:UIControlStateNormal];
        [self.layer3btn setTitle:[array objectAtIndex:2] forState:UIControlStateNormal];
        [self.layer4btn setTitle:[array objectAtIndex:3] forState:UIControlStateNormal];
        [self.layer5btn setTitle:[array objectAtIndex:4] forState:UIControlStateNormal];
        [self.layer6btn setTitle:[array objectAtIndex:5] forState:UIControlStateNormal];
        [self.cancelbtn setTitle:[array objectAtIndex:6] forState:UIControlStateNormal];
        [self.okbtn setTitle:[array objectAtIndex:7] forState:UIControlStateNormal];
        self.layer1btn.layer.cornerRadius = 3.0f;
        self.layer2btn.layer.cornerRadius = 3.0f;
        self.layer3btn.layer.cornerRadius = 3.0f;
        self.layer4btn.layer.cornerRadius = 3.0f;
        self.layer5btn.layer.cornerRadius = 3.0f;
        self.layer6btn.layer.cornerRadius = 3.0f;
        self.cancelbtn.layer.cornerRadius = 3.0f;
        self.okbtn.layer.cornerRadius = 3.0f;
    }
    
    return self;
}

- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag <7) {
        selectIndex = sender.tag;
        NSArray<UIButton*> *layerBtns = [self subviews];
        for (UIButton* btn in layerBtns) {
            if (btn.tag<7) {
                if (btn.tag != selectIndex) {
                    btn.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:181.0/255.0 blue:171.0/255.0 alpha:1.0];
                }
                else{
                    btn.backgroundColor = [UIColor greenColor];
                }
            }
        }

    }
    if (sender.tag == 100) {
        [self cancelClick];
    }else if (sender.tag == 101){
        [self okBtnClick];
    }
}

-(void)showInView:(UIView*)view withFrame:(CGRect)frame AndLayerNum:(Byte)layerNum CurrentLayerIndex:(Byte)layerIndex{
    if (!_backgroundView) {
        
        _backgroundView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        _backgroundView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
        
        [_backgroundView addTarget:self
                            action:@selector(cancelClick)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    selectIndex = layerIndex;
    currentIndex = selectIndex;
    NSArray<UIButton*> *layerBtns = [self subviews];
    for (UIButton* btn in layerBtns) {
        if (btn.tag<7) {
            btn.tintColor = [UIColor clearColor];
            if (btn.tag>layerNum) {
                [btn setHidden:YES];
            }else{
            if (btn.tag == layerIndex) {
                
                btn.backgroundColor = [UIColor greenColor];
                
            }
            else{
                btn.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:181.0/255.0 blue:171.0/255.0 alpha:1.0];
            }
            }
        }
    }
    [self fadeIn];
    
}

-(void)okBtnClick{
    if (selectIndex != currentIndex){
        if (self.delegate &&[self.delegate respondsToSelector:@selector(didSelectLayerIndex:)]) {
            [self.delegate didSelectLayerIndex:selectIndex];
        }
    }
    [self fadeOut];
}

-(void)cancelClick{
     [self fadeOut];
}
- (void)fadeIn
{
    //    _contentView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    UIWindow *windowView = [UIApplication sharedApplication].keyWindow;
    [windowView addSubview:_backgroundView];
    [windowView addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        ;
        NSLog(@"self.bounds:%f",[UIScreen mainScreen].bounds.size.width/2.0-160.0);
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2.0-160.0, 0, 320, 180);
    } completion:^(BOOL finished) {

    }];
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 0.0;
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2.0-160.0, -100, 320, 180);
    } completion:^(BOOL finished) {
        if (finished) {
            [_backgroundView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

@end
