//
//  HTWXYView.h
//  CoreMotionSample
//
//  Created by Rex on 2018/2/4.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTWXYView : UIView

-(void)addPoint:(CGPoint)point;

//線的顏色
-(void)setColorStroke:(UIColor *)colorStroke;
-(void)setStartPoint:(CGPoint)point;

@end
