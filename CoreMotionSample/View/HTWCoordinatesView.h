//
//  HTWCoordinatesView.h
//  CoreMotionSample
//
//  Created by Rex on 2018/2/10.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface HTWCoordinatesView : UIView

/*!
 格線寬
 defalut 10
 */
@property(nonatomic) IBInspectable NSUInteger gridWidth;

/*!
 線顏色
 defalut Black
 */
@property (nonatomic, strong) IBInspectable UIColor *colorLine;

@end
