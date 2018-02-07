//
//  HsvColorPaletteView.h
//  thColorSort
//
//  Created by taihe on 2017/8/8.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HsvColorPaletteChangeHsvDelegate<NSObject>
- (void) hsvColorPaletteSetIndex:(int)index;
@end
@interface HsvColorPaletteView : UIView{
    @public
    int HsvSstart[2];
    int hsvSend[2];
    int hsvVstart[2];
    int hsvVend[2];
    int hsvHstart[2];
    int hsvHend[2];
    BOOL hashsv2;
    int currentHsvIndex;
    int lightColorIndex;
    Byte hsvUsed[2];
    Byte pointX[1024];
    Byte pointY[1024];
    Byte lightY[256];
}
@property (nonatomic,assign) int offset;
@property (nonatomic,weak) id<HsvColorPaletteChangeHsvDelegate> delegate;
-(void)setIsoffset:(int)offset;
@end
