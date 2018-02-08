//
//  HTWXYView.m
//  CoreMotionSample
//
//  Created by Rex on 2018/2/4.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import "HTWXYView.h"

@interface HTWXYView ()

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) NSMutableArray<NSValue *> *points;

@end

@implementation HTWXYView

#pragma mark - draw

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // 畫線
    [self.path stroke];
}

// 取得layer
-(void)drawWithRelativePoint:(CGPoint)relativePoint
{
    CGFloat posX = self.path.currentPoint.x + relativePoint.x ;
    CGFloat posY = self.path.currentPoint.y + relativePoint.y ;
    // 移至最後一點
    [self.path addLineToPoint:CGPointMake(posX, posY)];
    [self setNeedsDisplay];
}

#pragma mark - get

-(UIBezierPath *)path
{
    if (!_path)
    {
        _path = [UIBezierPath bezierPath];
    }
    return _path;
}

-(NSMutableArray<NSValue *> *)points
{
    if (!_points)
    {
        _points = [NSMutableArray array];
    }
    return _points;
}

#pragma mark - set

-(void)setColorStroke:(UIColor *)colorStroke
{
    [colorStroke setStroke];
}

-(void)setStartPoint:(CGPoint)point
{
    [self.path removeAllPoints];
    [self.path moveToPoint:point];
    for (NSValue *value in self.points)
    {
        CGPoint point = [value CGPointValue];
        [self drawWithRelativePoint:point];
    }
}

#pragma mark - public

-(void)addPoint:(CGPoint)point
{
    [self.points addObject:[NSValue valueWithCGPoint:point]];
    [self drawWithRelativePoint:point];
}

@end
