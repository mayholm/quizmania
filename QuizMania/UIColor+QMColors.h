//
//  UIColor+QMColors.h
//  QuizMania
//
//  Created by Pär Majholm on 11/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (QMColors)

+ (UIColor *)colorWithRGBInt:(uint32_t)rgbInt;

+ (UIColor *)qmCyan;
+ (UIColor *)qmCyanLight;
+ (UIColor *)qmViolet;
+ (UIColor *)qmPink;
+ (UIColor *)qmBrown;
+ (UIColor *)qmGold;

+ (UIColor *)qmBackground;
+ (UIColor *)qmForeground;
+ (UIColor *)qmAccent;

@end
