//
//  LayerChangedView.h
//  thColorSort
//
//  Created by taihe on 2017/5/11.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LayerChangedDelegate<NSObject>
-(void)didSelectLayerIndex:(Byte)layerIndex;
@end
@interface LayerChangedView : UIView

@property (nonatomic,strong) UIControl *backgroundView;
@property (nonatomic,strong) NSArray *btnTitleArray;
@property (nonatomic,weak) id<LayerChangedDelegate> delegate;
-(id)initWithFrame:(CGRect)frame andBtnTitleArray:(NSArray*)array;
-(void)showInView:(UIView*)view withFrame:(CGRect)frame AndLayerNum:(Byte)layerNum CurrentLayerIndex:(Byte)layerIndex;
- (void)fadeIn;
- (void)fadeOut;
@end
