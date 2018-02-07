//
//  WaveDataView.m
//  thColorSort
//
//  Created by taiheMacos on 2017/4/17.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//
#define SPACESIDE 30
#define HeightOffSet 10
#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height
#define GridVirtualHeight 256.0  //表格模拟显示高度
#define GridVirtualHeightOffset 6.0/256.0*self.gridHeight //表格虚线偏移量
#import "WaveDataView.h"
static int heightX1[5] = {15, 149, 255, 361, 495};
static int heightX2[5] = {3+4, 87, 255, 423, 507-4};
@implementation WaveDataView

-(void)initGridView{
    NSLog(@"init :%f,%f",self.gridHeight,self.gridWidth);
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.gridWidth = WIDTH-SPACESIDE*2;
    self.gridHeight = self.gridWidth*0.618;
    NSLog(@"layout :%f,%f",self.gridHeight,self.gridWidth);
}
-(void)displayView{
    if (self.waveDataType<=7 || self.waveDataType == wave_rgb_restrain) {
        self.currentShowWaveLength = WaveLength;
    }else{
        self.currentShowWaveLength = CalibrationWaveLength;
    }
    [self setNeedsDisplay];
}
-(void)bindWaveData:(Byte*)wavedata withIndex:(Byte)index{
    memcpy(waveData[index], wavedata, WaveLength);
    
}
-(void)bindCalibrationWaveData:(Byte*)calibrationwavedata withIndex:(Byte)index{
    memcpy(self->calibrationWaveData[index], calibrationwavedata, CalibrationWaveLength);
}
-(void)bindWaveColorType:(Byte*)wavetype andColorDiffLightType:(Byte)colorDiffLightType andAlgriothmType:(Byte)alogriothmtype{
    self.waveDataType = colorDiffLightType;
    _colorType = wavetype[0];
    _separate = wavetype[1];
    _firstUpperlimit = wavetype[2];
    NSLog(@"upper:%d",_firstUpperlimit);
    _firstLowerlimit = wavetype[3];
    NSLog(@"lower:%d",_firstLowerlimit);
    _secondUpperlimit =wavetype[4];
    _secondLowerlimit = wavetype[5];
    _algriothmtype = alogriothmtype;
    //    [self displayView];
}

-(void)bindWaveDataType:(Byte)type irUseType:(Byte)irType WaveCount:(Byte)count{
    self.waveDataType = type;
    self.irUseType = irType;
    self.waveDataCount = count;
}

-(void)bindColorDiffLightType:(Byte)colorDiffLightType{
    self.waveDataType = colorDiffLightType;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect withCGContextRef:(CGContextRef)contextRef compressNum:(float)compress color:(UIColor*)uiColor waveIndex:(Byte)index{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextBeginPath(currentContext);
    for (int i = 0; i < self.currentShowWaveLength; i++)
    {
        CGFloat x = i/compress+SPACESIDE;
        float average;
        if (self.waveDataType<=wave_diff_IR || self.waveDataType == wave_rgb_restrain) {
            average = waveData[index][i];
        }else{
            average = calibrationWaveData[index][i];
        }
        
        CGFloat y =_gridHeight- (float)(average*_gridHeight)/GridVirtualHeight;
        if (i == 0) {
            CGContextMoveToPoint(currentContext, x, y+HeightOffSet);
        }else
        {
            CGContextAddLineToPoint(currentContext, x, y+HeightOffSet);
        }
    }
    [uiColor setStroke];
    CGContextStrokePath(currentContext);
}

-(UIColor *)getDrawColor:(Byte)type{
    UIColor *color;
    if (self.waveDataType == wave_rgb_IR) {
        if (type == 0) {
            color = [UIColor colorWithRed:69.0/255.0 green:69/255.0 blue:69.0/255.0 alpha:1.0];
        }else{
            color = [UIColor colorWithRed:178.0/255.0 green:58.0/255.0 blue:238.0/255.0 alpha:1.0];
        }
    }
    switch (type) {
        case ClrRed:
            color = [UIColor redColor];
            break;
        case ClrGreen:
            color = [UIColor greenColor];
            break;
        case ClrBlue:
            color = [UIColor blueColor];
            break;
        case ClrRedGreen:
            color = [UIColor colorWithRed:1.0 green:1.0 blue:0 alpha:1.0];
            break;
        case ClrRedBlue:
            color = [UIColor colorWithRed:1.0 green:0 blue:1.0 alpha:1.0];
            break;
        case ClrGreenBlue:
            color = [UIColor colorWithRed:0 green:1.0 blue:1.0 alpha:1.0];
            break;
        case ClrRedGreenBlue:
            color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
            break;
    }
    return color;
}
- (void)drawRect:(CGRect)rect {
    
    [[UIColor whiteColor] set];
    UIRectFill ([self bounds]);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext,0.5);
    
    float compressNum = self.currentShowWaveLength/_gridWidth;
    
    if (self.waveDataType == 0) {//rgb
        [self drawRect:rect withCGContextRef:currentContext compressNum:compressNum color:[self getDrawColor:_colorType] waveIndex:0];
        
        CGContextSetLineWidth(currentContext,0.8);
        CGFloat separate = (_separate/256.0)*_gridWidth+SPACESIDE;
        //sense
        //upper
        
            CGFloat firstupper = _gridHeight-(_firstUpperlimit/GridVirtualHeight)*_gridHeight+HeightOffSet;
            CGFloat secondupper =_gridHeight-(_secondUpperlimit/GridVirtualHeight)*_gridHeight+HeightOffSet;
            if(_separate == 0)
            {
                CGContextMoveToPoint(currentContext, SPACESIDE, firstupper);
                CGContextAddLineToPoint(currentContext, _gridWidth+SPACESIDE, firstupper);
                [[UIColor blackColor] setStroke];
                CGContextStrokePath(currentContext);
            }
            else
            {
                //first
                CGContextMoveToPoint(currentContext, SPACESIDE, firstupper);
                CGContextAddLineToPoint(currentContext, separate, firstupper);
                [[UIColor blackColor] setStroke];
                CGContextStrokePath(currentContext);
                
                //second
                CGContextMoveToPoint(currentContext, separate, secondupper);
                CGContextAddLineToPoint(currentContext,_gridWidth+SPACESIDE, secondupper);
                [[UIColor blackColor] setStroke];
                CGContextStrokePath(currentContext);
                
            }
        //lower
        
            CGFloat firstlower =_gridHeight- (_firstLowerlimit/GridVirtualHeight)*_gridHeight+HeightOffSet;
            CGFloat secondlower =_gridHeight- (_secondLowerlimit/GridVirtualHeight)*_gridHeight+HeightOffSet;
            
            //first
            if(_separate == 0)
            {
                CGContextMoveToPoint(currentContext, SPACESIDE, firstlower);
                CGContextAddLineToPoint(currentContext, _gridWidth+SPACESIDE, firstlower);
                [[UIColor blackColor] setStroke];
                CGContextStrokePath(currentContext);
            }
            else
            {
                CGContextMoveToPoint(currentContext, SPACESIDE, firstlower);
                CGContextAddLineToPoint(currentContext, separate, firstlower);
                [[UIColor blackColor] setStroke];
                CGContextStrokePath(currentContext);
                
                //second
                CGContextMoveToPoint(currentContext, separate, secondlower);
                CGContextAddLineToPoint(currentContext,_gridWidth+SPACESIDE, secondlower);
                [[UIColor blackColor] setStroke];
                CGContextStrokePath(currentContext);
            }
        CGContextSetLineWidth(currentContext,0.5);

    }
    else if(self.waveDataType == wave_diff)//diff
    {
        [self drawRect:rect withCGContextRef:currentContext compressNum:compressNum color:[self getDrawColor:_colorType] waveIndex:0];
        
        [self drawRect:rect withCGContextRef:currentContext compressNum:compressNum color:[self getDrawColor:_separate] waveIndex:1];
        
    }
    else if(self.waveDataType == wave_light || self.waveDataType == wave_rgb_IR)//light
    {
        if(self.waveDataType == wave_light){
            [self drawRect:rect withCGContextRef:currentContext compressNum:compressNum color:[self getDrawColor:_colorType] waveIndex:0];
            
        }else if (self.waveDataType == wave_rgb_IR){
            UIColor *color;
            if (_colorType==0) {
                color = [UIColor colorWithRed:69.0/255.0 green:69/255.0 blue:69.0/255.0 alpha:1.0];
            }else{
                color = [UIColor colorWithRed:178.0/255.0 green:58.0/255.0 blue:238.0/255.0 alpha:1.0];
            }
            [self drawRect:rect withCGContextRef:currentContext compressNum:compressNum color:color waveIndex:0];
        }
        CGContextSetLineWidth(currentContext,0.8);
        CGFloat upper = _gridHeight-(_firstUpperlimit/GridVirtualHeight)*_gridHeight+HeightOffSet;
        CGFloat lower =_gridHeight-(_firstLowerlimit/GridVirtualHeight)*_gridHeight+HeightOffSet;
        CGContextBeginPath(currentContext);
        CGContextMoveToPoint(currentContext, SPACESIDE, upper);
        CGContextAddLineToPoint(currentContext, _gridWidth+SPACESIDE, upper);
        [[UIColor blackColor] setStroke];
        CGContextStrokePath(currentContext);
        
        CGContextBeginPath(currentContext);
        CGContextMoveToPoint(currentContext, SPACESIDE, lower);
        CGContextAddLineToPoint(currentContext, _gridWidth+SPACESIDE, lower);
        [[UIColor blackColor] setStroke];
        CGContextStrokePath(currentContext);
        CGContextSetLineWidth(currentContext,0.5);
        
    }
    else if (self.waveDataType == wave_diff_IR){
        [self drawRect:rect withCGContextRef:currentContext compressNum:compressNum color:[UIColor colorWithRed:69.0/255.0 green:69/255.0 blue:69.0/255.0 alpha:1.0] waveIndex:0];
        [self drawRect:rect withCGContextRef:currentContext compressNum:compressNum color:[UIColor colorWithRed:178.0/255.0 green:58.0/255.0 blue:238.0/255.0 alpha:1.0] waveIndex:1];
    }
    else if(self.waveDataType == 3 ||self.waveDataType == 4 ||self.waveDataType == 5||self.waveDataType == wave_origin ||self.waveDataType == wave_calibration || self.waveDataType == wave_test_data)
    {
        if (self.waveDataType == wave_origin ||self.waveDataType == wave_calibration || self.waveDataType == wave_test_data){
            CGContextSetLineWidth(currentContext,0.8);
            if (self.dataType == 2) {
                CGContextBeginPath(currentContext);
                for (int i = 0; i < 5; i++)
                {
                    CGFloat x = heightX1[i]/compressNum+SPACESIDE;
                    CGContextMoveToPoint(currentContext, x, HeightOffSet);
                    //                    NSLog(@"%f",x);
                    CGContextAddLineToPoint(currentContext, x, self.gridHeight+HeightOffSet);
                    
                    [[UIColor grayColor] setStroke];
                    CGContextStrokePath(currentContext);
                }
            }else if (self.dataType == 1){
                CGContextBeginPath(currentContext);
                for (int i = 0; i < 5; i++)
                {
                    CGFloat x = heightX2[i]/compressNum+SPACESIDE;
                    CGContextMoveToPoint(currentContext, x, HeightOffSet);
                    
                    CGContextAddLineToPoint(currentContext, x, self.gridHeight+HeightOffSet);
                    
                    [[UIColor grayColor] setStroke];
                    CGContextStrokePath(currentContext);
                }
            }
        }
        CGContextSetLineWidth(currentContext,0.5);
        for (int i = 0; i<self.waveDataCount; i++) {
            UIColor *color;
            if (i == 0) {
                color = [UIColor redColor];
            }else if (i == 1){
                color = [UIColor greenColor];
            }else if (i == 2){
                color = [UIColor blueColor];
            }else if (i == 3){
                if (_irUseType == 2) {
                    color = [UIColor colorWithRed:178.0/255.0 green:58.0/255.0 blue:238.0/255.0 alpha:1.0];
                }else{
                    color = [UIColor colorWithRed:69.0/255.0 green:69/255.0 blue:69.0/255.0 alpha:1.0];
                }
                
            }else if (i == 4){
                color = [UIColor colorWithRed:178.0/255.0 green:58.0/255.0 blue:238.0/255.0 alpha:1.0];
            }
            [self drawRect:rect withCGContextRef:currentContext compressNum:compressNum color:color waveIndex:i];
        }
    }else if (self.waveDataType == wave_rgb_restrain){
        [self drawRect:rect withCGContextRef:currentContext compressNum:compressNum color:[self getDrawColor:_colorType] waveIndex:0];
        CGContextSetLineWidth(currentContext,0.8);
        CGFloat upper = _gridHeight-(_firstUpperlimit/GridVirtualHeight)*_gridHeight+HeightOffSet;
        CGContextBeginPath(currentContext);
        CGContextMoveToPoint(currentContext, SPACESIDE, upper);
        CGContextAddLineToPoint(currentContext, _gridWidth+SPACESIDE, upper);
        [[UIColor blackColor] setStroke];
        CGContextStrokePath(currentContext);
        CGContextSetLineWidth(currentContext,0.5);
        
    }
    [self drawGrid];
}

-(void)drawGrid{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    UIColor *stringColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0];  //设置文本的颜色
    
    NSDictionary* attrs =@{NSForegroundColorAttributeName:stringColor,
                           NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter"size:10],
                           }; //在词典中加入文本的颜色 字体 大小
    //网格实线边框
    CGContextAddRect(currentContext, CGRectMake(SPACESIDE, HeightOffSet, self.gridWidth, self.gridHeight));
    [[UIColor blackColor] setStroke];
    CGContextStrokePath(currentContext);
    
    //垂直线
    
    CGContextBeginPath(currentContext);
    float rectVerticalAverage= (self.gridWidth)/9;
    for (int i = 0; i<= 9; i++) {
        
        
        CGFloat arr[] = {3,1};
        if (i != 0 && i!=9) {
            CGContextMoveToPoint(currentContext, (float)i*rectVerticalAverage+SPACESIDE, HeightOffSet);
            CGContextAddLineToPoint(currentContext, (float)i*rectVerticalAverage+SPACESIDE, self.gridHeight+HeightOffSet);
            [[UIColor grayColor] setStroke];
            CGContextSetLineDash(currentContext, 0, arr, 2);
        }
        CGContextStrokePath(currentContext);
    }
    //水平线 与坐标
    CGContextBeginPath(currentContext);
    float horizatalAverage =(self.gridHeight-GridVirtualHeightOffset)/5;
    for (int i = 0; i<= 5; i++) {
    
            NSString * stringText= [NSString stringWithFormat:@"%d",(250-i*50)];
            [stringText drawAtPoint:CGPointMake(8, i*horizatalAverage+5+GridVirtualHeightOffset) withAttributes:attrs];

        if (i<5) {
            CGFloat arr[] = {3,1};
            CGContextMoveToPoint(currentContext,SPACESIDE, i*horizatalAverage+HeightOffSet+GridVirtualHeightOffset);
            CGContextAddLineToPoint(currentContext, self.gridWidth+SPACESIDE, i*horizatalAverage+HeightOffSet+GridVirtualHeightOffset);
            [[UIColor grayColor] setStroke];
            CGContextSetLineDash(currentContext, 0, arr, 2);
            
            CGContextStrokePath(currentContext);
        }
        
        
    }
}
@end
