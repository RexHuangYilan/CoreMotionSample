//
//  CompassPointerView.h
//  CompassSample
//
//  Created by Rex on 2018/1/27.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CompassPointerView : UIView

/*!
 北邊顏色
 defalut Red
 */
@property (nonatomic, strong) IBInspectable UIColor *colorNorth;

/*!
 南邊顏色
 defalut blue
 */
@property (nonatomic, strong) IBInspectable UIColor *colorSouth;

/*!
 外邊距
 defalut 0
 */
@property (nonatomic) IBInspectable CGFloat margin;
@end
