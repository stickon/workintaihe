//
//  TipsView.h
//  thColorSort
//
//  Created by taihe on 2017/5/25.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TipsViewResultDelegate<NSObject>
-(void)tipsViewResult:(Byte)value;
@end
@interface TipsView : UIView
@property (nonatomic,strong) UIControl *backgroundView;

@property (nonatomic,weak) id<TipsViewResultDelegate> delegate;
-(id)initWithFrame:(CGRect)frame;
-(id)initWithFrame:(CGRect)frame okTitle:(NSString*)okText cancelTitle:(NSString*)cancelText tips:(NSString *)tipsTitle;
-(void)showInView:(UIView*)view withFrame:(CGRect)frame;
-(void)showInView:(UIView *)view withFrame:(CGRect)frame okTitle:(NSString *)okText cancelTitle:(NSString*)cancelText tips:(NSString*)tipsTitle;
- (void)fadeIn;
- (void)fadeOut;
@end
