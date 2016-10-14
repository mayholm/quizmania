//
//  Answer.m
//  QuizMania
//
//  Created by Pär Majholm on 12/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import "Answer.h"

@interface Answer ()

@property (readwrite, retain) Question * question;
@property (readwrite, assign) uint32_t selectedOption;
@property (readwrite, assign) NSTimeInterval elapsedTime;

@end

@implementation Answer

- (instancetype)initWithQuestion:(Question *)question
                  selectedOption:(uint32_t)selectedOption
                     elapsedTime:(NSTimeInterval)elapsedTime
{
    self = [super init];
    if (self == nil) return nil;
    self.question = question;
    self.selectedOption = selectedOption;
    self.elapsedTime = elapsedTime;
    return self;
}

@end
