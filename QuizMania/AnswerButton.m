//
//  AnswerButton.m
//  QuizMania
//
//  Created by Pär Majholm on 14/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import "AnswerButton.h"
#import "UIColor+QMColors.h"

@implementation AnswerButton

- (void)setHighlighted:(BOOL)highlighted
{
    BOOL changed = highlighted != self.highlighted;
    [super setHighlighted:highlighted];
    if (changed)
    {
        if (highlighted)
        {
            self.layer.borderWidth = 3;
            self.layer.borderColor = [UIColor qmAccent].CGColor;
        }
        else
        {
            self.layer.borderWidth = 0;
        }
    }
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (enabled)
        self.label.textColor = [UIColor qmAccent];
    else
        self.label.textColor = [UIColor lightGrayColor];
}

@end
