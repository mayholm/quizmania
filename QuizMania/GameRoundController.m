//
//  GameRoundController.m
//  QuizMania
//
//  Created by Pär Majholm on 11/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import "GameRoundController.h"
#import "GameFinishController.h"
#import "LoadQuestionsOperation.h"
#import "NSObject+observeKeyPath.h"
#import "AppModel.h"
#import "AnswerButton.h"

@interface GameRoundController ()

@property (retain) GameRound * gameRound;
@property (retain) NSOperationQueue * operationQueue;
@property (retain) LoadQuestionsOperation * loadQuestionsOperation;
@property (retain) Observer * currentQuestionObserver;

@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UILabel * questionLabel;
@property (retain, nonatomic) IBOutlet UIButton *plus10LifelineButton;
@property (retain, nonatomic) IBOutlet UIButton *fiftyFiftyLifelineButton;
@property (retain, nonatomic) IBOutlet UIView * timeBar;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint * timeBarWidth;
@property (retain, nonatomic) IBOutlet UILabel * timeLeftLabel;
@property (retain, nonatomic) IBOutletCollection(AnswerButton) NSArray * answerButtons;

@end

@implementation GameRoundController

- (void)dealloc
{
    [_gameRound release];
    [_operationQueue release];
    [_loadQuestionsOperation release];
    [_currentQuestionObserver release];
    [_imageView release];
    [_questionLabel release];
    [_plus10LifelineButton release];
    [_fiftyFiftyLifelineButton release];
    [_timeLeftLabel release];
    [_timeBarWidth release];
    [_timeBar release];
    [_answerButtons release];
    [super dealloc];
}

- (void)setUp
{
    __block GameRoundController * weakSelf = self;
    self.currentQuestionObserver = [self observeKeyPath:@"gameRound.currentQuestion" callback:^(NSDictionary<NSString *, id> * change) {
        Question * question = weakSelf.gameRound.currentQuestion;
        UIImage * image = [UIImage imageWithData:weakSelf.gameRound.images[question.identifier]];
        weakSelf.imageView.image = image;
        weakSelf.questionLabel.text = question.text;
        for (NSUInteger i = 0; i < question.options.count; i++)
        {
            AnswerButton * button = (AnswerButton*)weakSelf.answerButtons[i];
            button.label.text = question.options[i];
            button.enabled = YES;
        }
    }];
    
    self.operationQueue = [[NSOperationQueue new] autorelease];
    NSSet * blacklist = AppModel.loadedModel.questionBlacklist;
    self.loadQuestionsOperation = [[[LoadQuestionsOperation alloc] initWithCount:10 blacklist:blacklist] autorelease];
    [self.operationQueue addOperation:self.loadQuestionsOperation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSBlockOperation * operation = [NSBlockOperation blockOperationWithBlock:^{
        NSArray * questions = self.loadQuestionsOperation.questions;
        NSDictionary * images = self.loadQuestionsOperation.images;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.gameRound = [[[GameRound alloc] initWithQuestions:questions images:images] autorelease];
            self.plus10LifelineButton.enabled = YES;
            self.fiftyFiftyLifelineButton.enabled = YES;
            [self.gameRound startTimingCurrentQuestion];
        });
        for (Question * question in questions)
            [AppModel.loadedModel blacklistQuestion:question.identifier];
        [AppModel saveLoadedModelToDisk];
    }];
    
    [operation addDependency:self.loadQuestionsOperation];
    [self.operationQueue addOperation:operation];
    
    CADisplayLink * displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTimeBar)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (IBAction)answerPressed:(AnswerButton *)sender
{
    NSUInteger index = [self.answerButtons indexOfObject:sender];
    BOOL wasLastQuestion = self.gameRound.numberOfQuestionsLeft == 0;
    [self.gameRound answerWithOption:(uint32_t)index];
    [self.gameRound startTimingCurrentQuestion];
    if (wasLastQuestion)
        [self performSegueWithIdentifier:@"showGameFinished" sender:self];
}

- (IBAction)plus10LifelifePressed:(UIButton *)sender
{
    [self.gameRound usePlus10Lifeline];
    sender.enabled = NO;
}

- (IBAction)fiftyFiftyLifelinePressed:(UIButton *)sender
{
    BOOL wasNotUsedYet = [self.gameRound use5050Lifeline];
    if (wasNotUsedYet)
    {
        sender.enabled = NO;
        uint32_t correct = self.gameRound.currentQuestion.indexOfCorrectOption;
        uint32_t offset = 1 + arc4random_uniform(3);
        uint32_t offsetSecond = offset == 3 ? 1 : offset + 1;
        uint32_t indexOfFirstToRemove = (correct + offset) % 4;
        uint32_t indexOfSecondToRemove = (correct + offsetSecond) % 4;
        ((UIButton*)self.answerButtons[indexOfFirstToRemove]).enabled = NO;
        ((UIButton*)self.answerButtons[indexOfSecondToRemove]).enabled = NO;
    }
}

- (void)updateTimeBar
{
    self.timeLeftLabel.text = [NSString stringWithFormat:@"%d", (uint32_t)round(self.gameRound.timeLeft)];
    self.timeBarWidth.active = NO;
    self.timeBarWidth = [NSLayoutConstraint constraintWithItem:self.timeBar
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.timeBar.superview
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:MAX(0.0001, self.gameRound.timeLeftFraction)
                                                      constant:0];
    self.timeBarWidth.active = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GameFinishController * gameFinishController = (GameFinishController *)segue.destinationViewController;
    [gameFinishController setUpWithGameRound:self.gameRound];
}

@end
