//
//  UIColor+QMColors.m
//  QuizMania
//
//  Created by Pär Majholm on 11/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import "UIColor+QMColors.h"

@implementation UIColor (QMColors)

+ (UIColor *)colorWithRGBInt:(uint32_t)rgbInt
{
    CGFloat r = ((rgbInt >> 16) & 0xFF) / 255.0;
    CGFloat g = ((rgbInt >> 8) & 0xFF) / 255.0;
    CGFloat b = ((rgbInt >> 0) & 0xFF) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

+ (UIColor *)qmCyan
{
    return [UIColor colorWithRGBInt:0x00ACC1];
}
+ (UIColor *)qmCyanLight
{
    return [UIColor colorWithRGBInt:0x00D4EF];
}
+ (UIColor *)qmViolet
{
    return [UIColor colorWithRGBInt:0x7E57C2];
}
+ (UIColor *)qmPink
{
    return [UIColor colorWithRGBInt:0xD81B60];
}
+ (UIColor *)qmBrown
{
    return [UIColor colorWithRGBInt:0x6D4C41];
}
+ (UIColor *)qmGold
{
    return [UIColor colorWithRGBInt:0xFFB300];
}

+ (UIColor *)qmBackground
{
    return [UIColor qmCyan];
}
+ (UIColor *)qmForeground
{
    return [UIColor qmViolet];
}
+ (UIColor *)qmAccent
{
    return [UIColor qmPink];
}

@end
