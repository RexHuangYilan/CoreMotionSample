//
//  ViewController.m
//  CoreMotionSample
//
//  Created by Rex on 2017/9/24.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

@property(nonatomic,strong) CMMotionManager *motionManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)doAccelerometerPull {
    CMMotionManager *manager = [[CMMotionManager alloc] init];
    self.motionManager = manager;
    //判斷加速器是否可用，與是否開啟
    if ([manager isAccelerometerAvailable]){
        //更新頻率是100Hz
        manager.accelerometerUpdateInterval = 1.0;
        //開始更新，非主線程。- Pull
        [manager startAccelerometerUpdates];
    }
    //取得加速器資料
    CMAccelerometerData *newestAccel = self.motionManager.accelerometerData;
    NSLog(@"X = %.04f",newestAccel.acceleration.x);
    NSLog(@"Y = %.04f",newestAccel.acceleration.y);
    NSLog(@"Z = %.04f",newestAccel.acceleration.z);
}

- (IBAction)doAccelerometerPush {
    CMMotionManager *manager = [[CMMotionManager alloc] init];
    self.motionManager = manager;
    //判斷加速器是否可用，與是否開啟
    if ([manager isAccelerometerAvailable]){
        //更新頻率是100Hz
        manager.accelerometerUpdateInterval = 1.0;
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        //開始更新。- Push
        [manager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
         {
             //x軸代表手機的左邊還右邊往下，值為正(右)~負(左)
//             NSLog(@"X = %.04f",accelerometerData.acceleration.x);
             //y軸代表手機的上邊還下邊往下，值為正(上)~負(下)
//             NSLog(@"Y = %.04f",accelerometerData.acceleration.y);
             //z軸代表手機的螢幕正面還背面往下，值為正(正面)~負(背面)
//             NSLog(@"Z = %.04f",accelerometerData.acceleration.z);
         }];
    }
}

- (IBAction)doGyroPull {
}

- (IBAction)doGyroPush {
}

@end
