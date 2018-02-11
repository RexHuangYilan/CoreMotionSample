//
//  HTWCoordinatesView.m
//  CoreMotionSample
//
//  Created by Rex on 2018/2/10.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import "HTWCoordinatesView.h"

@implementation HTWCoordinatesView

#pragma mark - init

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self steupProperty];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self steupProperty];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self steupProperty];
    }
    return self;
}

-(void)steupProperty
{
    _colorLine = [UIColor blackColor];
    _gridWidth = 10;
}

#pragma mark - set

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self.layer display];
}

-(void)setColorLine:(UIColor *)colorLine
{
    _colorLine = colorLine;
    [self setNeedsDisplay];
}

-(void)setGridWidth:(NSUInteger)gridWidth
{
    _gridWidth = gridWidth;
    [self setNeedsDisplay];
}

#pragma mark - draw

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawCoordinatesWithRect:rect];
}

-(void)drawCoordinatesWithRect:(CGRect)rect
{
    [self removeAllSubLayer:self.layer];
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    CGFloat startX = fmodf(width / 2, self.gridWidth);
    CGFloat startY = fmodf(height / 2, self.gridWidth);
    
    [self drawCoordinatesWithRect:rect
                       horizontal:YES
                       pointValue:startX
                        maxLength:width];
    [self drawCoordinatesWithRect:rect
                       horizontal:NO
                       pointValue:startY
                        maxLength:height];
}

-(void)drawCoordinatesWithRect:(CGRect)rect
                    horizontal:(BOOL)horizontal
                    pointValue:(CGFloat)pointValue
                     maxLength:(CGFloat)maxLength
{
    while (pointValue < maxLength)
    {
        CGPoint point = CGPointMake(horizontal ? pointValue : 0, horizontal ? 0 : pointValue);
        CGFloat lineWidth = (maxLength / 2) != pointValue ? 1 : 3;
        CAShapeLayer *layer = [self getLineLayerWithRect:rect
                                                   point:point
                                              horizontal:!horizontal
                                             strokeColor:self.colorLine
                                               lineWidth:lineWidth];
        [self.layer addSublayer:layer];
        pointValue += self.gridWidth;
    }
}

#pragma mark - private

// 取得layer
-(CAShapeLayer *)getLineLayerWithRect:(CGRect)rect
                                point:(CGPoint)point
                            horizontal:(BOOL)horizontal
                           strokeColor:(UIColor *)strokeColor
                             lineWidth:(CGFloat)lineWidth
{
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = strokeColor.CGColor;
    shapeLayer.lineWidth = lineWidth;
    
    //建立path
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPoint sPoints[2];//座標
    sPoints[0] = CGPointMake(horizontal ? 0 : point.x, horizontal ? point.y : 0);
    sPoints[1] = CGPointMake(horizontal ? width : point.x, horizontal ? point.y : height);
    //加入路徑
    CGPathAddLines(path, NULL, sPoints, 2);
    //設置path
    [shapeLayer setPath:path];
    
    CGPathRelease(path);
    
    return shapeLayer;
}

-(void)removeAllSubLayer:(CALayer *)layer
{
    NSArray *aryTemp = [layer.sublayers copy];
    [aryTemp enumerateObjectsUsingBlock:^(CALayer * _Nonnull subLayer, NSUInteger idx, BOOL * _Nonnull stop) {
        [subLayer removeFromSuperlayer];
    }];
}

@end
