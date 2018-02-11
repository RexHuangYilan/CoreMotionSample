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
@property (nonatomic) CGPoint currentPoint;

@end

@implementation HTWXYView

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
    self.colorStroke = [UIColor redColor];
    _scalePoint = 1;
}

#pragma mark - draw

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.colorStroke setStroke];
    // 畫線
    [self.path stroke];
}

// 取得layer
-(void)drawWithRelativePoint:(CGPoint)relativePoint
{
    CGFloat posX = self.path.currentPoint.x + relativePoint.x * self.scalePoint;
    CGFloat posY = self.path.currentPoint.y - relativePoint.y * self.scalePoint;
    // 移至最後一點
    [self.path addLineToPoint:CGPointMake(posX, posY)];
    [self setNeedsDisplay];
    [self addCurrentPoint:relativePoint];
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
    _colorStroke = colorStroke;
    [self setNeedsDisplay];
}

-(void)setStartPoint:(CGPoint)startPoint
{
    _startPoint = startPoint;
    [self redraw];
}

-(void)setCurrentPoint:(CGPoint)currentPoint
{
    _currentPoint = currentPoint;
    if ([self.delegate respondsToSelector:@selector(xyView:changeCurrentPoint:deviceCurrentPoint:)]) {
        [self.delegate xyView:self
           changeCurrentPoint:currentPoint
           deviceCurrentPoint:self.path.currentPoint];
    }
}

-(void)setScalePoint:(CGFloat)scalePoint
{
    _scalePoint = scalePoint;
    [self redraw];
}

#pragma mark - privage

-(void)redraw
{
    [self.path removeAllPoints];
    [self.path moveToPoint:self.startPoint];
    self.currentPoint = CGPointMake(0,0);
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

-(void)addCurrentPoint:(CGPoint)point
{
    CGFloat posX = self.currentPoint.x + point.x;
    CGFloat posY = self.currentPoint.y + point.y;
    self.currentPoint = CGPointMake(posX, posY);
}

@end
