//
//  FunctionListViewController.m
//  CoreMotionSample
//
//  Created by Rex on 2018/2/10.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import "FunctionListViewController.h"
#import "XYViewController.h"

#import "DeviceMotionManager.h"

static NSString *cellIdentifier = @"FunctionCell";
static NSString *dataFile = @"FunctionList";

@interface FunctionListViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dateSource;


@end

@implementation FunctionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:dataFile ofType:@"plist"];
    self.dateSource = [NSArray arrayWithContentsOfFile:path];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dateSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.dateSource[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = data[@"title"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *data = self.dateSource[indexPath.row];
    SEL sel = NSSelectorFromString(data[@"selector"]);
    
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL, id) = (void *)imp;
        func(self, sel, data);
    }
}

#pragma mark - table event

- (void)doArbitrary:(NSDictionary *)sender {
    DeviceMotionManager *deviceMotionManager = [DeviceMotionManager new];
    deviceMotionManager.info = sender;
    [deviceMotionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
    [self pushXYViewControllerWithMotionManager:deviceMotionManager];
}

- (void)doArbitraryCorrected:(NSDictionary *)sender {
    DeviceMotionManager *deviceMotionManager = [DeviceMotionManager new];
    deviceMotionManager.info = sender;
    [deviceMotionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical];
    [self pushXYViewControllerWithMotionManager:deviceMotionManager];
}

- (void)doMagneticNorth:(NSDictionary *)sender {
    DeviceMotionManager *deviceMotionManager = [DeviceMotionManager new];
    deviceMotionManager.info = sender;
    [deviceMotionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXMagneticNorthZVertical];
    [self pushXYViewControllerWithMotionManager:deviceMotionManager];
}

- (void)doTrueNorthZVertical:(NSDictionary *)sender {
    DeviceMotionManager *deviceMotionManager = [DeviceMotionManager new];
    deviceMotionManager.info = sender;
    [deviceMotionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
    [self pushXYViewControllerWithMotionManager:deviceMotionManager];
}

- (void)pushXYViewControllerWithMotionManager:(DeviceMotionManager *)motionManager
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XYViewController *vc = [sb instantiateViewControllerWithIdentifier:@"XYViewController"];
    vc.deviceMotionManager = motionManager;
//    vc.title = cell.textLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
