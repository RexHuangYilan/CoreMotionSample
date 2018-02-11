//
//  XYZViewManager.m
//  CoreMotionSample
//
//  Created by Rex on 2018/1/28.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import "XYZViewManager.h"

@interface XYZViewManager ()

@property (weak, nonatomic) IBOutlet UILabel *labelX;
@property (weak, nonatomic) IBOutlet UILabel *labelY;
@property (weak, nonatomic) IBOutlet UILabel *labelZ;

@end

@implementation XYZViewManager
@synthesize x = _x;
@synthesize y = _y;
@synthesize z = _z;

-(void)setX:(CGFloat)x
{
    if (fabs(_x) > fabs(x)) {
        return;
    }
    _x = x;
    self.labelX.text = [NSString stringWithFormat:@"%f",x];
}

-(void)setY:(CGFloat)y
{
    if (fabs(_y) > fabs(y)) {
        return;
    }
    _y = y;
    self.labelY.text = [NSString stringWithFormat:@"%f",y];
}

-(void)setZ:(CGFloat)z
{
    if (fabs(_z) > fabs(z)) {
        return;
    }
    _z = z;
    self.labelZ.text = [NSString stringWithFormat:@"%f",z];
}

-(CGFloat)x
{
    return [self.labelX.text floatValue];
}

-(CGFloat)y
{
    return [self.labelY.text floatValue];
}

-(CGFloat)z
{
    return [self.labelZ.text floatValue];
}
@end
