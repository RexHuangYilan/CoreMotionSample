//
//  CompassPointerView.m
//  CompassSample
//
//  Created by Rex on 2018/1/27.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import "CompassPointerView.h"

@implementation CompassPointerView

#pragma mark - init

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
    self.backgroundColor = [UIColor clearColor];
    _colorNorth = [UIColor redColor];
    _colorSouth = [UIColor blueColor];
}

#pragma mark - set

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect bounds = frame;
    bounds.origin.x = 0;
    bounds.origin.y = 0;
    // 需設定 bounds 在重畫時才會正確
    self.bounds = bounds;
}

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self.layer display];
}

-(void)setColorNorth:(UIColor *)colorNorth
{
    _colorNorth = colorNorth;
    [self.layer display];
}

-(void)setColorSouth:(UIColor *)colorSouth
{
    _colorSouth = colorSouth;
    [self.layer display];
}

-(void)setMargin:(CGFloat)margin
{
    _margin = margin;
    [self.layer display];
}

#pragma mark - private

-(void)removeAllSubLayer:(CALayer *)layer
{
    NSArray *aryTemp = [layer.sublayers copy];
    [aryTemp enumerateObjectsUsingBlock:^(CALayer * _Nonnull subLayer, NSUInteger idx, BOOL * _Nonnull stop) {
        [subLayer removeFromSuperlayer];
    }];
}

// 取得layer
-(CAShapeLayer *)getShapeLayerWithPoints:(CGPoint *)sPoints fillColor:(UIColor *)fillColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.fillColor = fillColor.CGColor;
    shapeLayer.lineWidth = 1;
    
    //建立path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //加入路徑
    CGPathAddLines(path, NULL, sPoints, 3);
    CGPathCloseSubpath(path);
    
    //設置path
    [shapeLayer setPath:path];
    
    CGPathRelease(path);
    
    return shapeLayer;
}

#pragma mark - draw

- (void)drawRect:(CGRect)rect
{
    [self removeAllSubLayer:self.layer];
    
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    //畫北
    CGPoint nPoints[3];//座標
    nPoints[0] = CGPointMake(width / 2.0, 0 + self.margin);
    nPoints[1] = CGPointMake(0, height / 2.0);
    nPoints[2] = CGPointMake(width, height / 2.0);
    CAShapeLayer *layerNorth = [self getShapeLayerWithPoints:nPoints fillColor:self.colorNorth];
    
    //畫南
    CGPoint sPoints[3];//座標
    sPoints[0] = CGPointMake(width / 2.0, height - self.margin);
    sPoints[1] = CGPointMake(0, height / 2.0);
    sPoints[2] = CGPointMake(width, height / 2.0);
    CAShapeLayer *layerSouth = [self getShapeLayerWithPoints:sPoints fillColor:self.colorSouth];
    
    //加入layer
    [self.layer addSublayer:layerNorth];
    [self.layer addSublayer:layerSouth];
}

@end
