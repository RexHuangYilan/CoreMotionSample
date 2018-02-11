//
//  CenterXYView.m
//  CoreMotionSample
//
//  Created by Rex on 2018/2/9.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import "CenterXYView.h"

@implementation CenterXYView

#pragma mark - set

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setupCenter];
}

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self setupCenter];
}

-(void)setupCenter
{
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
    [self setStartPoint:center];
}

@end
