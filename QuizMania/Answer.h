//
//  Answer.h
//  QuizMania
//
//  Created by Pär Majholm on 12/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"

@interface Answer : NSObject

@property (readonly) Question * question;
@property (readonly) uint32_t selectedOption;
@property (readonly) NSTimeInterval elapsedTime;

- (instancetype)initWithQuestion:(Question *)question
                  selectedOption:(uint32_t)selectedOption
                     elapsedTime:(NSTimeInterval)elapsedTime;

@end
