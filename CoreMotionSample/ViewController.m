//
//  ViewController.m
//  CoreMotionSample
//
//  Created by Rex on 2017/9/24.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "ViewController.h"
#import "XYZViewManager.h"

#import "XYViewController.h"

#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

@property(nonatomic,strong) CMMotionManager *motionManager;

@property (strong, nonatomic) IBOutlet XYZViewManager *accelerometerPullViewManager;
@property (strong, nonatomic) IBOutlet XYZViewManager *accelerometerPushViewManager;

@property (strong, nonatomic) IBOutlet XYZViewManager *gyroPushViewManager;
@property (strong, nonatomic) IBOutlet XYZViewManager *gyroPullViewManager;
@property (strong, nonatomic) IBOutlet XYZViewManager *referNorthViewManager;
@property (weak, nonatomic) IBOutlet UIView *pointView;

//@property (weak,nonatomic) id<XYViewControllerDelegate> delegate;

@end


#define showsize( expr ) ( printf(#expr " = %zd\n", ( expr ) ) )

CGPoint *pass_back(CGPoint points[4])
{
    showsize(sizeof(points));
    return points;
}

@implementation ViewController

#pragma mark - live cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CMMotionManager *manager = [[CMMotionManager alloc] init];
    self.motionManager = manager;
    self.motionManager.accelerometerUpdateInterval = 0.5;
    self.motionManager.gyroUpdateInterval = 0.5;
    self.motionManager.deviceMotionUpdateInterval = 1/10.0;
    
}



- (IBAction)doAccelerometerPull
{
    //判斷加速器是否可用，與是否開啟
    if ([self.motionManager isAccelerometerAvailable] && ![self.motionManager isAccelerometerActive]){
        //開始更新，非主線程。- Pull
        [self.motionManager startAccelerometerUpdates];
    }
    //取得加速器資料
    CMAccelerometerData *newestAccel = self.motionManager.accelerometerData;
//    NSLog(@"X = %.04f",newestAccel.acceleration.x);
//    NSLog(@"Y = %.04f",newestAccel.acceleration.y);
//    NSLog(@"Z = %.04f",newestAccel.acceleration.z);
    self.accelerometerPullViewManager.x = newestAccel.acceleration.x;
    self.accelerometerPullViewManager.y = newestAccel.acceleration.y;
    self.accelerometerPullViewManager.z = newestAccel.acceleration.z;
}

- (IBAction)doAccelerometerPush
{
    //判斷加速器是否可用，與是否開啟
    if ([self.motionManager isAccelerometerAvailable]){
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        //開始更新。- Push
        __weak typeof(self) weakself = self;
        [self.motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
         {
             //x軸代表手機的左邊還右邊往下，值為正(右)~負(左)
             weakself.accelerometerPushViewManager.x = accelerometerData.acceleration.x;
             //y軸代表手機的上邊還下邊往下，值為正(上)~負(下)
             weakself.accelerometerPushViewManager.y = accelerometerData.acceleration.y;
             //z軸代表手機的螢幕正面還背面往下，值為正(正面)~負(背面)
             weakself.accelerometerPushViewManager.z = accelerometerData.acceleration.z;
         }];
    }
}

- (IBAction)doGyroPull
{
    // 判斷陀羅儀是否開啟
    if ([self.motionManager isGyroAvailable] && ![self.motionManager isGyroActive]){
        //開始更新，非主線程。- Pull
        [self.motionManager startGyroUpdates];
    }
    CMGyroData *gyroData = self.motionManager.gyroData;
    self.gyroPullViewManager.x = gyroData.rotationRate.x;
    self.gyroPullViewManager.y = gyroData.rotationRate.y;
    self.gyroPullViewManager.z = gyroData.rotationRate.z;
}

- (IBAction)doGyroPush
{
    // 判斷陀羅儀是否開啟
    if ([self.motionManager isGyroAvailable]){
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        //開始更新。- Push
        __weak typeof(self) weakself = self;
        [self.motionManager startGyroUpdatesToQueue:queue withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
            
            //x軸代表手機的左邊還右邊往下，值為正(右)~負(左)
            weakself.gyroPushViewManager.x = gyroData.rotationRate.x;
            //y軸代表手機的上邊還下邊往下，值為正(上)~負(下)
            weakself.gyroPushViewManager.y = gyroData.rotationRate.y;
            //z軸代表手機的螢幕正面還背面往下，值為正(正面)~負(背面)
            weakself.gyroPushViewManager.z = gyroData.rotationRate.z;
        }];
    }
}

- (IBAction)doReferNorth:(id)sender
{
    if (self.motionManager.isDeviceMotionAvailable){
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        //開始更新
        __weak typeof(self) weakself = self;
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            
            CMAcceleration acc = motion.userAcceleration;
            CMRotationMatrix rot = motion.attitude.rotationMatrix;
            
            //x軸代表手機的左邊還右邊往下，值為正(右)~負(左)
            weakself.referNorthViewManager.x = acc.x;
            //y軸代表手機的上邊還下邊往下，值為正(上)~負(下)
            weakself.referNorthViewManager.y = acc.y;
            //z軸代表手機的螢幕正面還背面往下，值為正(正面)~負(背面)
            weakself.referNorthViewManager.z = acc.z;
            
//            //x軸代表手機的左邊還右邊往下，值為正(右)~負(左)
//            weakself.referNorthViewManager.x = (acc.x*rot.m11 + acc.y*rot.m21 + acc.z*rot.m31)*9.81;
//            //y軸代表手機的上邊還下邊往下，值為正(上)~負(下)
//            weakself.referNorthViewManager.y = (acc.x*rot.m12 + acc.y*rot.m22 + acc.z*rot.m32)*9.81;
//            //z軸代表手機的螢幕正面還背面往下，值為正(正面)~負(背面)
//            weakself.referNorthViewManager.z = (acc.x*rot.m13 + acc.y*rot.m23 + acc.z*rot.m33)*9.81;
            
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
        }];
    }
}

-(void)addPoint:(CGPoint)point
{
//    if (self.delegate) {
//        [self.delegate addPoint:point];
//    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.destinationViewController isKindOfClass:XYViewController.class]) {
//        XYViewController *vc = (XYViewController *)segue.destinationViewController;
//        self.delegate = vc;
//    }
}

@end
