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

/*!
 yaw角度
 */
@property (nonatomic) CGFloat rotation;

/*!
 上一次的轉角
 */
@property (nonatomic) CGFloat lastDeviation;

/*!
 轉動中
 */
@property (nonatomic) BOOL turning;

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
        NSLog(@"============= [log] 修正");
        self.rotationDeviation = self.motionManager.deviceMotion.attitude.yaw;
        [self changeRotation:0];
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
    // 左為正，右為負,3.14~-3.14
    CGFloat rotation = motion.attitude.yaw;
//    NSLog(@"[log] rotation:%f",rotation / M_PI * 180);
    CGFloat deviation = rotation - self.rotation;
    if (fabs(deviation) > M_PI) {
        deviation = 2 * M_PI - fabs(self.rotation) - fabs(rotation);
        if(rotation > 0){
            deviation *= -1;
        }
    }
    
//    BOOL sort = self.lastDeviation > deviation;
//    CGFloat ddeviation = self.lastDeviation - deviation;
    self.lastDeviation = deviation;
    self.turning = NO;
    // 不動時的偏差修正
    if (fabs(deviation) > 0.01f) {
//        NSLog(@"[log] M_PI/18:%f",M_PI / 180 * 15);
        NSLog(@"[log] deviation:%f",deviation);
        // 一般直線行走轉角最多可能3.5度，所以轉角大於3.5度才定義為轉動中
        if (fabs(deviation) > M_PI / 180 * 3.5) {
//            NSLog(@"[log] deviation:%f",deviation);
            NSLog(@"============= [log] M_PI/18:%f",M_PI / 180 * 3.5);
            self.turning = YES;
        }
        [self changeRotation: -(rotation - self.rotationDeviation)];
    }else{
        self.rotationDeviation -= deviation;
    }
    self.rotation = rotation;
}

- (void)checkUserAccelerationWithMotion:(CMDeviceMotion *)motion
{
    if (!self.isRotationDeviation || self.turning) {
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
    
//    posX = posX * timeG;
//    posY = posY * timeG;
    CGFloat o = -(self.rotation - self.rotationDeviation);
    CGFloat s = posY * timeG;
    posX = s * sinf(o);
    posY = s * cosf(o);
    
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
