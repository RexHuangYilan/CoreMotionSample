//
//  XYViewController.m
//  CoreMotionSample
//
//  Created by Rex on 2018/2/9.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import "XYViewController.h"
#import "CenterXYView.h"
#import "HTWCoordinatesView.h"

#import <CoreMotion/CoreMotion.h>


@interface XYViewController ()
<
HTWXYViewDelegate
>

@property (weak, nonatomic) IBOutlet HTWCoordinatesView *coordinageView;
@property (weak, nonatomic) IBOutlet CenterXYView *xyView;
@property (weak, nonatomic) IBOutlet UILabel *labXY;
@property (weak, nonatomic) IBOutlet UIView *viewPoint;

@property (weak, nonatomic) IBOutlet UIView *viewMask;
@property (weak, nonatomic) IBOutlet UIView *viewMaskPoint;
@end

@implementation XYViewController

#pragma mark - live cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.xyView.scalePoint = self.coordinageView.gridWidth;
    
}

#pragma mark - set

-(void)setXyView:(CenterXYView *)xyView
{
    _xyView = xyView;
    _xyView.delegate = self;
}

-(void)setDeviceMotionManager:(DeviceMotionManager *)deviceMotionManager
{
    _deviceMotionManager = deviceMotionManager;
    deviceMotionManager.delegate = self;
    self.title = deviceMotionManager.info[@"title"];
}

#pragma mark - 

- (IBAction)doCorrectRotationDeviation:(id)sender
{
    self.deviceMotionManager.isRotationDeviation = YES;
    [UIView animateWithDuration:.5 animations:^{
        self.viewMask.alpha = 0;
    }];
}

#pragma mark - DeviceMotionManagerDelegate

-(void)addPoint:(CGPoint)point
{
    [self.xyView addPoint:point];
}

-(void)changeRotation:(CGFloat)rotation
{
    if (self.deviceMotionManager.isRotationDeviation) {
        self.viewPoint.transform = CGAffineTransformMakeRotation(rotation);
    }else{
        self.viewMaskPoint.transform = CGAffineTransformMakeRotation(rotation);
    }
}

#pragma mark - HTWXYViewDelegate

-(void)xyView:(HTWXYView *)xyView changeCurrentPoint:(CGPoint)currentPoint deviceCurrentPoint:(CGPoint)deviceCurrentPoint
{
    self.labXY.text = [NSString stringWithFormat:@"x:%.2f y:%.2f",currentPoint.x,currentPoint.y];
    self.viewPoint.center = deviceCurrentPoint;
}

@end
