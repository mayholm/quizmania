//
//  AppModel.m
//  QuizMania
//
//  Created by Pär Majholm on 14/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import "AppModel.h"

@interface AppModel ()

@property (retain) NSMutableSet<NSUUID *> * mutableQuestionBlacklist;

@end

@implementation AppModel

- (instancetype)init
{
    self = [super init];
    if (self == nil) return nil;
    self.mutableQuestionBlacklist = [[NSMutableSet new] autorelease];
    return self;
}

#pragma mark - NSCoding

- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self == nil) return nil;
    self.mutableQuestionBlacklist = [NSMutableSet setWithSet:[coder decodeObjectForKey:@"questionBlacklist"]];
    self.totalScore = [coder decodeInt64ForKey:@"totalScore"];
    self.highestRoundScore = [coder decodeInt64ForKey:@"highestRoundScore"];
    self.longestSpree = [coder decodeInt64ForKey:@"longestSpree"];
    self.fastestRound = [coder decodeDoubleForKey:@"fastestRound"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.questionBlacklist forKey:@"questionBlacklist"];
    [coder encodeInt64:self.totalScore forKey:@"totalScore"];
    [coder encodeInt64:self.highestRoundScore forKey:@"highestRoundScore"];
    [coder encodeInt64:self.longestSpree forKey:@"longestSpree"];
    [coder encodeDouble:self.fastestRound forKey:@"fastestRound"];
}

#pragma mark - public methods

- (void)blacklistQuestion:(NSUUID *)identifier
{
    @synchronized (self) {
        [self.mutableQuestionBlacklist addObject:identifier];
    }
}

#pragma mark - public properties

- (NSSet<NSUUID *> *)questionBlacklist
{
    return [NSSet setWithSet:self.mutableQuestionBlacklist];
}

#pragma mark - class

static AppModel * loadedModel = nil;

+ (AppModel *)loadedModel
{
    return loadedModel;
}

+ (void)loadModelFromDisk
{
    @synchronized (loadedModel)
    {
        loadedModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
        [loadedModel retain];
        if (loadedModel == nil)
            loadedModel = [[AppModel alloc] init];
    }
}

+ (void)saveLoadedModelToDisk
{
    @synchronized (loadedModel)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self filePath]] == NO)
            [[NSFileManager defaultManager] createDirectoryAtPath:[self directoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
        [NSKeyedArchiver archiveRootObject:loadedModel toFile:[self filePath]];
    }
}

+ (NSString *)filePath
{
    NSArray * directories = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    return [NSString stringWithFormat:@"%@/%@", [directories firstObject], @"app-model"];
}

+ (NSString *)directoryPath
{
    NSArray * directories = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    return [directories firstObject];
}

@end
