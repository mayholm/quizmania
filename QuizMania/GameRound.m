//
//  GameRound.m
//  QuizMania
//
//  Created by Pär Majholm on 11/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import "GameRound.h"

@interface GameRound ()

@property (readwrite, retain) NSArray<Question *> * questions;
@property (readwrite, assign) NSTimeInterval questionTimeout;
@property (readwrite, retain) NSDictionary<NSUUID *, NSData *> * images;

@property (assign) NSUInteger indexOfCurrentQuestion;
@property (retain) NSMutableArray<Answer *> * mutableAnswers;
@property (retain) NSDate * startTimeOfCurrentQuestion;
@property (assign) BOOL usedPlus10Lifeline;
@property (assign) BOOL used5050Lifeline;

@end

@implementation GameRound

#pragma mark - public methods

- (instancetype)initWithQuestions:(NSArray<Question *> *)questions images:(NSDictionary<NSUUID *, NSData *> *)images
{
    self = [super init];
    if (self == nil) return nil;
    self.questions = questions;
    self.mutableAnswers = [NSMutableArray array];
    self.questionTimeout = 15.0;
    self.images = images;
    return self;
}

- (void)startTimingCurrentQuestion
{
    self.startTimeOfCurrentQuestion = [NSDate date];
}

- (void)answerWithOption:(uint32_t)optionIndex
{
    NSTimeInterval elapsedTime = self.startTimeOfCurrentQuestion.timeIntervalSinceNow * -1;
    Answer * answer = [[[Answer alloc] initWithQuestion:self.currentQuestion
                                         selectedOption:optionIndex
                                            elapsedTime:elapsedTime] autorelease];
    [self.mutableAnswers addObject:answer];
    if (self.indexOfCurrentQuestion + 1 < self.questions.count)
        self.indexOfCurrentQuestion += 1;
}

- (void)usePlus10Lifeline
{
    if (self.usedPlus10Lifeline) return;
    self.usedPlus10Lifeline = YES;
    self.startTimeOfCurrentQuestion = [self.startTimeOfCurrentQuestion dateByAddingTimeInterval:10];
}

- (BOOL)use5050Lifeline
{
    if (self.used5050Lifeline) return NO;
    self.used5050Lifeline = YES;
    return YES;
}

#pragma mark - public propertes

- (Question *)currentQuestion
{
    return self.questions[self.indexOfCurrentQuestion];
}

- (uint32_t)numberOfQuestionsLeft
{
    return (uint32_t)(self.questions.count - (self.indexOfCurrentQuestion + 1));
}

- (NSArray<Answer *> *)answers
{
    return [NSArray arrayWithArray:self.mutableAnswers];
}

- (NSTimeInterval)timeLeft
{
    NSTimeInterval elapsedTime = self.startTimeOfCurrentQuestion.timeIntervalSinceNow * -1;
    return self.questionTimeout - elapsedTime;
}

- (double)timeLeftFraction
{
    NSTimeInterval elapsedTime = self.startTimeOfCurrentQuestion.timeIntervalSinceNow * -1;
    return 1 - (elapsedTime / self.questionTimeout);
}

#pragma mark - KVO

+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    
    if ([key isEqualToString:@"currentQuestion"]) {
        keyPaths = [keyPaths setByAddingObject:@"indexOfCurrentQuestion"];
    }
    
    return keyPaths;
}

@end
