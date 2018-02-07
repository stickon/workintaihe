//
//  TipsView.m
//  thColorSort
//
//  Created by taihe on 2017/5/25.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "TipsView.h"
@interface TipsView()
@property (strong, nonatomic) IBOutlet UIButton *cancelbtn;
@property (strong, nonatomic) IBOutlet UIButton *okbtn;
@property (strong, nonatomic) IBOutlet UILabel *tipsTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *showInfobtn;

@end

@implementation TipsView
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSArray *viewxib = [[NSBundle mainBundle]loadNibNamed:@"TipsView" owner:self options:nil];
        self = [viewxib objectAtIndex:0];
        self.frame = frame;
        self.cancelbtn.layer.cornerRadius = 3.0f;
        self.okbtn.layer.cornerRadius = 3.0f;
        self.showInfobtn.hidden = true;
    }
    
    return self;
}
-(id)initWithFrame:(CGRect)frame okTitle:(NSString*)okText cancelTitle:(NSString*)cancelText tips:(NSString *)tipsTitle{
    if (self = [super initWithFrame:frame]) {
        NSArray *viewxib = [[NSBundle mainBundle]loadNibNamed:@"TipsView" owner:self options:nil];
        self = [viewxib objectAtIndex:0];
        self.frame = frame;
        
        [self.cancelbtn setTitle:cancelText forState:UIControlStateNormal];
        [self.okbtn setTitle:okText forState:UIControlStateNormal];
        self.tipsTitleLabel.text = tipsTitle;
        self.cancelbtn.layer.cornerRadius = 3.0f;
        self.okbtn.layer.cornerRadius = 3.0f;
        self.showInfobtn.hidden = true;
    }
    
    return self;
}

- (IBAction)btnClick:(UIButton *)sender {

    if (sender.tag == 100) {
        [self cancelClick];
    }else if (sender.tag == 101){
        [self okBtnClick];
    }
    [self fadeOut];
}

-(void)showInView:(UIView*)view withFrame:(CGRect)frame{
    if (!_backgroundView) {
        
        _backgroundView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        _backgroundView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
        
        [_backgroundView addTarget:self
                            action:@selector(fadeOut)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    [self fadeIn];
    
}

-(void)showInView:(UIView *)view withFrame:(CGRect)frame okTitle:(NSString *)okText cancelTitle:(NSString*)cancelText tips:(NSString*)tipsTitle{
    if (!_backgroundView) {
        _backgroundView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        _backgroundView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
        
        [_backgroundView addTarget:self
                            action:@selector(fadeOut)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    [self.cancelbtn setTitle:cancelText forState:UIControlStateNormal];
    [self.okbtn setTitle:okText forState:UIControlStateNormal];
    self.tipsTitleLabel.text = tipsTitle;
    [self fadeIn];
}

-(void)okBtnClick{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(tipsViewResult:)]) {
        [self.delegate tipsViewResult:1];
    }
}

-(void)cancelClick{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(tipsViewResult:)]) {
        [self.delegate tipsViewResult:0];
    }
}

- (void)fadeIn
{
//        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    UIWindow *windowView = [UIApplication sharedApplication].keyWindow;
    [windowView addSubview:_backgroundView];
    [windowView addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
//        self.frame = CGRectMake(self.bounds.size.width / 2, self.bounds.size.height / 2, 260, 160);
//    self.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
//                self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
//        self.frame = CGRectMake(0, -100, 260, 180);
    } completion:^(BOOL finished) {
        if (finished) {
            [_backgroundView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}



@end
