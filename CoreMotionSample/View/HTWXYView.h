//
//  HTWXYView.h
//  CoreMotionSample
//
//  Created by Rex on 2018/2/4.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTWXYView;

@protocol HTWXYViewDelegate <NSObject>

-(void)xyView:(HTWXYView *)xyView changeCurrentPoint:(CGPoint)currentPoint deviceCurrentPoint:(CGPoint)deviceCurrentPoint;

@end

@interface HTWXYView : UIView

/*!
 線顏色
 defalut red
 */
@property (nonatomic, strong) IBInspectable UIColor *colorStroke;

/*!
 開始坐標
 defalut (0,0)
 */
@property (nonatomic) CGPoint startPoint;

/*!
 目前坐標
 */
@property (readonly) CGPoint currentPoint;

/*!
 比例，一公尺幾個Point
 defalut 1;
 */
@property (nonatomic) CGFloat scalePoint;

/*!
 delegate
 */
@property (nonatomic, weak) IBOutlet id<HTWXYViewDelegate> delegate;



-(void)addPoint:(CGPoint)point;

@end
