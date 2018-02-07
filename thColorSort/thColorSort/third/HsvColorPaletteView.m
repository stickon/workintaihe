//
//  HsvColorPaletteView.m
//  thColorSort
//
//  Created by taihe on 2017/8/8.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "HsvColorPaletteView.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#define ColorPaletteWidth (self.frame.size.width-60.0)
#define ColorPaletteHeight (ColorPaletteWidth)*256.0/360.0
#define ColorPaletteOriginX 40.0
#define ColorPaletteOriginY 5.0
@interface HsvColorPaletteView()<UIGestureRecognizerDelegate>
{
    Byte *rgbaBuffer;
    int m_hsv_offset[2][7];
    Byte m_pixel_hsv[256][360][3];
    UIImage *image;
    CGRect CurrentRect[2];//当前的矩形
    BOOL CurrentRectHasTwoRect;//当前矩形是否有两个
}
@end
@implementation HsvColorPaletteView

-(nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        rgbaBuffer = malloc(360*256*4);
        [self initHsvOffsetArray];
    }
    UITapGestureRecognizer *singleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleClickHsvPaletteView:)];
    
    [singleClick setNumberOfTapsRequired:1];
    [self addGestureRecognizer:singleClick];
    singleClick.delegate = self;
    return self;
}

- (void)singleClickHsvPaletteView:(UIGestureRecognizer*)sender{
    CGPoint point = [sender locationInView:self];
    if (CGRectContainsPoint(CGRectMake(ColorPaletteOriginX, ColorPaletteOriginY, ColorPaletteWidth, ColorPaletteHeight), point)) {
        if (hashsv2) {
            BOOL containsPoint = NO;
            if (CGRectContainsPoint(CurrentRect[0], point)) {
                containsPoint = YES;
            }
            if (CurrentRectHasTwoRect) {
                if (CGRectContainsPoint(CurrentRect[1], point)) {
                    containsPoint = YES;
                }
            }
            if (containsPoint == NO) {
                int index = currentHsvIndex?0:1;
                if (self.delegate && [self.delegate respondsToSelector:@selector(hsvColorPaletteSetIndex:)]) {
                    [self.delegate hsvColorPaletteSetIndex:index];
                }
            }
        }
        
    }
}
- (void)initHsvOffsetArray{
    m_hsv_offset[0][0] = 0;		m_hsv_offset[0][1] = 60;	m_hsv_offset[0][2] = 120;
    m_hsv_offset[0][3] = 180;	m_hsv_offset[0][4] = 240;	m_hsv_offset[0][5] = 300; m_hsv_offset[0][6] = 360;
    m_hsv_offset[1][0] = 180;	m_hsv_offset[1][1] = 240;	m_hsv_offset[1][2] = 300;
    m_hsv_offset[1][3] = 0;		m_hsv_offset[1][4] = 60;	m_hsv_offset[1][5] = 120;   m_hsv_offset[1][6] = 180;
}

- (void)fillHsvPixelArray:(int)offset{
    int m_hsv_v = 200;
    // 整幅图像
    static int i,j;
    int p, q, t, index;
    for( i=0; i<60; i++)
    {
        for( j=0; j<256; j ++)
        {
            p = (255 - j)*m_hsv_v/255;
            q = (15300-i*j)*m_hsv_v/15300;
            t = (15300+(i-60)*j)*m_hsv_v/15300;
            
            index = i + m_hsv_offset[offset][0];
            m_pixel_hsv[j][index][0] = p;
            m_pixel_hsv[j][index][1] = t;
            m_pixel_hsv[j][index][2] = m_hsv_v;
            
            index = i + m_hsv_offset[offset][1];
            m_pixel_hsv[j][index][0] = p;
            m_pixel_hsv[j][index][1] = m_hsv_v;
            m_pixel_hsv[j][index][2] = q;
            
            index = i + m_hsv_offset[offset][2];
            m_pixel_hsv[j][index][0] = t;
            m_pixel_hsv[j][index][1] = m_hsv_v;
            m_pixel_hsv[j][index][2] = p;
            
            index = i + m_hsv_offset[offset][3];
            m_pixel_hsv[j][index][0] = m_hsv_v;
            m_pixel_hsv[j][index][1] = q;
            m_pixel_hsv[j][index][2] = p;
            
            index = i + m_hsv_offset[offset][4];
            m_pixel_hsv[j][index][0] = m_hsv_v;
            m_pixel_hsv[j][index][1] = p;
            m_pixel_hsv[j][index][2] = t;
            
            index = i + m_hsv_offset[offset][5];
            m_pixel_hsv[j][index][0] = q;
            m_pixel_hsv[j][index][1] = p;
            m_pixel_hsv[j][index][2] = m_hsv_v;
        }
    }
    
    for (int i=0; i<360*256*4; i+=4) {
        rgbaBuffer[i] = m_pixel_hsv[256-i/4/360-1][(i/4)%360][0];
        rgbaBuffer[i+1] = m_pixel_hsv[256-i/4/360-1][(i/4)%360][1];
        rgbaBuffer[i+2] = m_pixel_hsv[256-i/4/360-1][(i/4)%360][2];
        rgbaBuffer[i+3] = 220;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef contextref = CGBitmapContextCreate(rgbaBuffer, 360, 256, 8, 360*4, colorSpace, kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst);
    CGImageRef cgimage = CGBitmapContextCreateImage(contextref);
    image = [[UIImage alloc]initWithCGImage:cgimage];
    CGImageRelease(cgimage);
    CGContextRelease(contextref);
    CGColorSpaceRelease(colorSpace);
}
/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    [self fillHsvPixelArray:self.offset];//填充背景
    UIImage *scaleimage = [self scaleToSize:image size:CGSizeMake(ColorPaletteWidth, ColorPaletteHeight)];//缩放背景
    CGRect imageRect = CGRectMake(ColorPaletteOriginX,ColorPaletteOriginY, ColorPaletteWidth,ColorPaletteHeight);
    [scaleimage drawInRect:imageRect];//绘制背景
    UIColor *stringColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0];  //设置文本的颜色
    
    NSDictionary* attrs =@{NSForegroundColorAttributeName:stringColor,
                           NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter"size:10],
                           }; //在词典中加入文本的颜色 字体 大小
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGFloat dashArray[] = {1,1};
    CGContextSetLineDash(context, 0, dashArray, 2);
    CGContextSetLineWidth(context, 0.4);
    
    //绘制坐标 和坐标线
    CGFloat verticalAverage =((ColorPaletteHeight)/256*250)/5;
    for (int i = 0; i<= 5; i++) {
        NSString * stringText= [NSString stringWithFormat:@"%d",(250-i*50)];
        [stringText drawAtPoint:CGPointMake(15, i*verticalAverage+3) withAttributes:attrs];
        if (i != 5) {
            [[UIColor grayColor] setStroke];
            CGContextMoveToPoint(context,ColorPaletteOriginX, (CGFloat)i*verticalAverage+ColorPaletteOriginY+(CGFloat)((ColorPaletteHeight)/256.0*6));
            CGContextAddLineToPoint(context, ColorPaletteOriginX+ColorPaletteWidth,(CGFloat)i*verticalAverage+ColorPaletteOriginY+(CGFloat)((ColorPaletteHeight)/256.0*6));
        }
    }
    CGFloat horizatalAverage =(ColorPaletteWidth)/6;
    for (int i = 0; i<= 6; i++) {
        NSString *stringText = [NSString stringWithFormat:@"%d",m_hsv_offset[self.offset][i]];
            [stringText drawAtPoint:CGPointMake(i*horizatalAverage+35, ColorPaletteHeight+8) withAttributes:attrs];
        if (i != 0 && i != 6) {
            CGContextMoveToPoint(context,(CGFloat)i*horizatalAverage+ColorPaletteOriginX,ColorPaletteOriginY);
            CGContextAddLineToPoint(context, (CGFloat)i*horizatalAverage+ColorPaletteOriginX,ColorPaletteOriginY+ColorPaletteHeight);
        }
    }
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSetLineWidth(context, 0.8);
    //矩形
    if (hashsv2) {
        if (currentHsvIndex == 0) {
            [self drawHsvRectWithIndex:1];
        }else{
            [self drawHsvRectWithIndex:0];
        }
    }
    [self drawHsvRectWithIndex:currentHsvIndex];

    
    //亮度线
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 0.5);
    for (int i = 0; i < 256; i++)
    {
        CGFloat x = (CGFloat)(i/256.0*(ColorPaletteWidth))+ColorPaletteOriginX;
        CGFloat y = ColorPaletteHeight - (CGFloat)(lightY[i]/256.0*(ColorPaletteHeight))+ColorPaletteOriginY;
        if (i == 0) {
            CGContextMoveToPoint(context, x, y);
        }else
        {
            CGContextAddLineToPoint(context, x, y);
        }
    }
    [[UIColor redColor] setStroke];
    CGContextStrokePath(context);
    
    
    CGContextBeginPath(context);
    [[UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1.0] setFill];
    /*画噪声点*/
    for(int i = 0;i<1024;i++)
    {
        int x = pointX[i];
        int hs = x*2;    /* 底层发送数据时除以2了 这里要乘以2*/
        CGFloat y = ColorPaletteHeight-(CGFloat)pointY[i]/256.0*ColorPaletteHeight+ColorPaletteOriginY;
        if(self.offset)
        {
            hs+=180;
            if(hs>360)
            {
                hs-=360;
            }
        }
        hs = (CGFloat)hs/360.0*ColorPaletteWidth+ColorPaletteOriginX;
        CGContextFillEllipseInRect(context, CGRectMake(hs, y, 1.0, 1.0));
    }
   CGContextStrokePath(context);
    
    //灰度线 下限
    CGContextBeginPath(context);
    CGContextSetLineWidth(context,0.8);
    CGContextSetRGBStrokeColor(context, 0.1, 0.1, 0.1, 1.0);//线条颜色

    const CGPoint points[] = {CGPointMake(ColorPaletteOriginX, ColorPaletteHeight-hsvVstart[currentHsvIndex]/256.0*(CGFloat)ColorPaletteHeight+ColorPaletteOriginY),CGPointMake(ColorPaletteOriginX+ColorPaletteWidth,ColorPaletteHeight-hsvVstart[currentHsvIndex]/256.0*(CGFloat)ColorPaletteHeight+ColorPaletteOriginY)};
    CGContextStrokeLineSegments(context,points,2);
    CGContextStrokePath(context);
    
//    灰度线 上限
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 0.1, 0.1, 0.1, 1.0);//线条颜色
    CGContextMoveToPoint(context, ColorPaletteOriginX, ColorPaletteHeight-hsvVend[currentHsvIndex]/256.0*(CGFloat)ColorPaletteHeight+ColorPaletteOriginY);
    CGContextAddLineToPoint(context, ColorPaletteOriginX+ColorPaletteWidth,ColorPaletteHeight-hsvVend[currentHsvIndex]/256.0*(CGFloat)ColorPaletteHeight+ColorPaletteOriginY);
    CGContextStrokePath(context);
}
- (void)drawHsvRectWithIndex:(Byte)index{
    CGContextRef context = UIGraphicsGetCurrentContext();
    int hsvX1=hsvHstart[index],hsvX2=hsvHend[index];
    if (self.offset == 1) {
        hsvX1 = hsvHstart[index] + 180;
        if (hsvX1>=360) {
            hsvX1 -= 360;
        }
        hsvX2 = hsvHend[index] +180;
        if (hsvX2 >= 360) {
            hsvX2 -=360;
        }
    }
    
    if (hsvX1 < hsvX2) {//没跨界
        CGRect hsv1rect = CGRectMake(hsvX1/360.0*(CGFloat)ColorPaletteWidth+ColorPaletteOriginX, ColorPaletteHeight-hsvSend[index]/256.0*(CGFloat)ColorPaletteHeight+ColorPaletteOriginY, (hsvX2-hsvX1)/360.0*(CGFloat)ColorPaletteWidth, (hsvSend[index]-HsvSstart[index])/256.0*(CGFloat)ColorPaletteHeight);
        
        CGContextSaveGState(context);
        if (hsvUsed[index]) {
            if (index == currentHsvIndex) {
                CurrentRect[0] = hsv1rect;
                CurrentRectHasTwoRect = NO;
                CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
            }else{
                CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
            }
            CGContextFillRect(context, hsv1rect);
        }else{
            CGFloat dashArray[] = {3,1};
            CGContextSetLineDash(context, 0, dashArray, 2);
            if (index == currentHsvIndex) {
                CurrentRect[0] = hsv1rect;
                CurrentRectHasTwoRect = NO;
                CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
            }else{
                CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
            }
            CGContextAddRect(context, hsv1rect);
            CGContextStrokePath(context);
        }
        CGContextRestoreGState(context);
        
    }else{
        CGContextSetRGBFillColor(context, 0, 1.0, 0, 1.0);
        CGRect hsvRect1 = CGRectMake(hsvX1/360.0*(CGFloat)ColorPaletteWidth+ColorPaletteOriginX, ColorPaletteHeight-hsvSend[index]/256.0*(CGFloat)ColorPaletteHeight+ColorPaletteOriginY, (360-hsvX1)/360.0*(CGFloat)ColorPaletteWidth, (hsvSend[index]-HsvSstart[index])/256.0*(CGFloat)ColorPaletteHeight);
        CGRect hsvRect2 = CGRectMake(ColorPaletteOriginX, ColorPaletteHeight-hsvSend[index]/256.0*(CGFloat)ColorPaletteHeight+ColorPaletteOriginY, hsvX2/360.0*(CGFloat)ColorPaletteWidth, (hsvSend[index]-HsvSstart[index])/256.0*(CGFloat)ColorPaletteHeight);
        CGContextSaveGState(context);
        if (hsvUsed[index]) {
            if (index == currentHsvIndex) {
                CurrentRect[0] = hsvRect1;
                CurrentRect[1] = hsvRect2;
                CurrentRectHasTwoRect = YES;
                CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
            }else{
                CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
            }
            CGContextFillRect(context, hsvRect1);
            CGContextFillRect(context, hsvRect2);
            CGContextStrokePath(context);
        }else{
            CGFloat dashArray[] = {3,1};
            CGContextSetLineDash(context, 0, dashArray, 2);
            if (index == currentHsvIndex) {
                CurrentRect[0] = hsvRect1;
                CurrentRect[1] = hsvRect2;
                CurrentRectHasTwoRect = YES;
                CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
            }else{
                CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
            }
            CGContextAddRect(context, hsvRect1);
            CGContextAddRect(context, hsvRect2);
            CGContextStrokePath(context);
        }
        CGContextRestoreGState(context);
    }
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(void)setIsoffset:(int)offset{
    self.offset = offset;
    [self setNeedsDisplay];
}
- (void)dealloc{
    if (rgbaBuffer) {
        free(rgbaBuffer);
        rgbaBuffer = NULL;
    }
}
@end
