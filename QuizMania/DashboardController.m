//
//  DashboardController.m
//  QuizMania
//
//  Created by Pär Majholm on 11/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import "DashboardController.h"
#import "GameRoundController.h"
#import "AppModel.h"
#import "UIColor+QMColors.h"


@interface DashboardController ()

@property (retain, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (retain, nonatomic) IBOutlet UIView *highScoreView;

@end

@implementation DashboardController

- (void)dealloc
{
    [_highScoreLabel release];
    [_highScoreView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.highScoreView.layer.borderWidth = 3;
    self.highScoreView.layer.borderColor = [UIColor qmCyanLight].CGColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.highScoreLabel.text = [NSString stringWithFormat:@"%lld", AppModel.loadedModel.highestRoundScore];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GameRoundController * gameRoundController = (GameRoundController *)segue.destinationViewController;
    [gameRoundController setUp];
}

- (IBAction)unwindToDashboard:(UIStoryboardSegue*)sender { }

@end
