//
//  DeviceMotionManager.m
//  CoreMotionSample
//
//  Created by Rex on 2018/2/11.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import "DeviceMotionManager.h"

@interface DeviceMotionManager ()

@property (nonatomic, strong) CMMotionManager *motionManager;

/*!
 yaw偏差修正
 */
@property (nonatomic) CGFloat rotationDeviation;

@end

@implementation DeviceMotionManager

#pragma mark - get

- (CMMotionManager *)motionManager
{
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = 1/10.0;
    }
    return _motionManager;
}

#pragma mark - set

-(void)setIsRotationDeviation:(BOOL)isRotationDeviation
{
    _isRotationDeviation = isRotationDeviation;
    if (isRotationDeviation) {
        self.rotationDeviation = self.motionManager.deviceMotion.attitude.yaw;
    }
}

#pragma mark - DeviceMotion

- (void)startDeviceMotionUpdatesUsingReferenceFrame:(CMAttitudeReferenceFrame)referenceFrame
{
    if (self.motionManager.deviceMotionActive) {
        [self.motionManager stopDeviceMotionUpdates];
    }
    
    if (self.motionManager.isDeviceMotionAvailable) {
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        //開始更新
        __weak typeof(self) weakself = self;
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:referenceFrame toQueue:queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            
            [weakself checkRotationWithMotion:motion];
            [weakself checkUserAccelerationWithMotion:motion];
        }];
    }
}

#pragma mark - private

- (void)checkRotationWithMotion:(CMDeviceMotion *)motion
{
    CGFloat rotation = motion.attitude.yaw;

    [self changeRotation:rotation - self.rotationDeviation];
}

- (void)checkUserAccelerationWithMotion:(CMDeviceMotion *)motion
{
    if (!self.isRotationDeviation) {
        return;
    }
    
    CMAcceleration acc = motion.userAcceleration;
    CGFloat posX = acc.x;
    CGFloat posY = acc.y;
    // 防抖動
    if (fabs(posX) < 0.01) {
        posX = 0 ;
    }
    if (fabs(posY) < 0.01) {
        posY = 0 ;
    }
    if (posX == 0 && posY == 0) {
        return ;
    }
    
    CGFloat timeG = 9.81 * self.motionManager.deviceMotionUpdateInterval;
    
    posX = posX * timeG;
    posY = posY * timeG;
    [self addPoint:CGPointMake(posX, posY)];
}

-(void)addPoint:(CGPoint)point
{
    if (self.delegate) {
        [self.delegate addPoint:point];
    }
}

-(void)changeRotation:(CGFloat)rotation
{
    NSLog(@"rotation:%f",rotation);
    if (self.delegate) {
        [self.delegate changeRotation:rotation];
    }
}


@end
