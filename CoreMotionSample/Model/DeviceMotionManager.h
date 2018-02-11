//
//  DeviceMotionManager.h
//  CoreMotionSample
//
//  Created by Rex on 2018/2/11.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@protocol DeviceMotionManagerDelegate <NSObject>

@required

-(void)addPoint:(CGPoint)point;
-(void)changeRotation:(CGFloat)rotation;

@end

@interface DeviceMotionManager : NSObject

@property (nonatomic, weak) id<DeviceMotionManagerDelegate> delegate;

/*!
 點擊資訊
 */
@property (nonatomic, strong) NSDictionary *info;

/*!
 是否修正旋轉偏差
 */
@property (nonatomic) BOOL isRotationDeviation;

/*!
 開始感測
 */
- (void)startDeviceMotionUpdatesUsingReferenceFrame:(CMAttitudeReferenceFrame)referenceFrame;

@end
