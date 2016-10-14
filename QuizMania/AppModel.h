//
//  AppModel.h
//  QuizMania
//
//  Created by Pär Majholm on 14/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject <NSCoding>

@property (readonly) NSSet<NSUUID *> * questionBlacklist;
@property (assign) int64_t totalScore;
@property (assign) int64_t highestRoundScore;
@property (assign) int64_t longestSpree;
@property (assign) double fastestRound;

- (void)blacklistQuestion:(NSUUID *)identifier;

#pragma mark - class methods

@property (class, readonly) AppModel * loadedModel;

+ (void)loadModelFromDisk;
+ (void)saveLoadedModelToDisk;

@end
