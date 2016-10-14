//
//  GameFinishController.m
//  QuizMania
//
//  Created by Pär Majholm on 12/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import "GameFinishController.h"
#import "AppModel.h"

@interface GameFinishController ()

@property (retain) GameRound * gameRound;

@property (retain, nonatomic) IBOutlet UILabel *countsLabel;
@property (retain, nonatomic) IBOutlet UILabel *scoreLabel;
@property (retain, nonatomic) IBOutlet UILabel *fastestAnswerLabel;
@property (retain, nonatomic) IBOutlet UILabel *averageAnswerLabel;
@property (retain, nonatomic) IBOutlet UILabel *slowestAnswerLabel;
@property (retain, nonatomic) IBOutlet UILabel *roundTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *longestSpreeLabel;

@end

@implementation GameFinishController

- (void)dealloc
{
    [_gameRound release];
    [_scoreLabel release];
    [_countsLabel release];
    [_fastestAnswerLabel release];
    [_averageAnswerLabel release];
    [_slowestAnswerLabel release];
    [_roundTimeLabel release];
    [_longestSpreeLabel release];
    [super dealloc];
}

- (void)setUpWithGameRound:(GameRound *)gameRound;
{
    self.gameRound = gameRound;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO  move following logic out of controller into model
    
    NSMutableArray<Answer *> * timelyAnswers = [NSMutableArray array];
    for (Answer * answer in self.gameRound.answers)
    {
        if (answer.elapsedTime < self.gameRound.questionTimeout)
            [timelyAnswers addObject:answer];
    }
    
    uint32_t right = 0;
    uint32_t wrong = 0;
    NSTimeInterval totalTime = 0;
    NSTimeInterval fastestTime = 100000;
    NSTimeInterval slowestTime = 0;
    for (Answer * answer in timelyAnswers)
    {
        if (answer.selectedOption == answer.question.indexOfCorrectOption)
            right += 1;
        else
            wrong += 1;
        
        totalTime += answer.elapsedTime;
        fastestTime = MIN(fastestTime, answer.elapsedTime);
        slowestTime = MAX(slowestTime, answer.elapsedTime);
    }
    
    /*
    @property (scoreLabel;
    @property (fastestAnswerLabel;
    @property (averageAnswerLabel;
    @property (slowestAnswerLabel;
    @property (roundTimeLabel;
    @property (longestSpreeLabel;
     */
    
    self.fastestAnswerLabel.text = [NSString stringWithFormat:@"%.2fs", fastestTime];
    self.averageAnswerLabel.text = [NSString stringWithFormat:@"%.2fs", totalTime / timelyAnswers.count];
    self.slowestAnswerLabel.text = [NSString stringWithFormat:@"%.2fs", slowestTime];
    self.roundTimeLabel.text = [NSString stringWithFormat:@"%.2fs", totalTime];
    //self.fastestAnswerLabel.text = @(fastestTime).stringValue;
    
    uint32_t numberOfTimeouts = (uint32_t)(self.gameRound.questions.count - timelyAnswers.count);
    
    self.countsLabel.text = [NSString stringWithFormat:@"%u right, %u wrong, %u timed out", right, wrong, numberOfTimeouts];
    
    int64_t score = (int64_t)((right * 1000) / (totalTime * 0.2));
    score = score - (int64_t)((score / MAX(0.01, right)) * (numberOfTimeouts + wrong) * 0.5);
    self.scoreLabel.text = [NSString stringWithFormat:@"%lld", score];
    
    if (AppModel.loadedModel.highestRoundScore == 0) // TODO better handling of the never played case
        AppModel.loadedModel.highestRoundScore = score;
    else
        AppModel.loadedModel.highestRoundScore = MAX(score, AppModel.loadedModel.highestRoundScore);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [AppModel saveLoadedModelToDisk];
    });
}

@end
