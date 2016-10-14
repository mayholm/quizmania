//
//  GameRound.h
//  QuizMania
//
//  Created by Pär Majholm on 11/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "Answer.h"

@interface GameRound : NSObject

@property (readonly) uint32_t numberOfQuestionsLeft;
@property (readonly) Question * currentQuestion;
@property (readonly) NSArray<Answer *> * answers;
@property (readonly) NSTimeInterval timeLeft;
@property (readonly) double timeLeftFraction;
@property (readonly) NSArray<Question *> * questions;
@property (readonly) NSDictionary<NSUUID *, NSData *> * images;
@property (readonly) NSTimeInterval questionTimeout;

- (instancetype)initWithQuestions:(NSArray<Question *> *)questions images:(NSDictionary<NSUUID *, NSData *> *)images;

- (void)startTimingCurrentQuestion;
- (void)answerWithOption:(uint32_t)optionIndex;
- (void)usePlus10Lifeline;
- (BOOL)use5050Lifeline;

@end
