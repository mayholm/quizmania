//
//  LoadQuestionsOperation.m
//  QuizMania
//
//  Created by Pär Majholm on 12/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import "LoadQuestionsOperation.h"
#import "URLDataTaskOperation.h"
@import UIKit;

@interface LoadQuestionsOperation ()

@property (assign) uint32_t count;
@property (retain) NSSet<NSUUID *> * blacklist;

@end

@implementation LoadQuestionsOperation

- (instancetype)initWithCount:(uint32_t)count blacklist:(NSSet<NSUUID *> *)blacklist;
{
    self = [super init];
    if (self == nil) return nil;
    self.count = count;
    self.blacklist = blacklist;
    return self;
}

- (void)main
{
    NSURL * questionsURL = [[NSBundle mainBundle] URLForResource:@"questions" withExtension:@"json"];
    
    // download json file
    URLDataTaskOperation * dataTask = [[[URLDataTaskOperation alloc] initWithURL:questionsURL] autorelease];
    [dataTask main];
    
    NSArray * questionsJSONObject = [NSJSONSerialization JSONObjectWithData:[dataTask data] options:0 error:nil];
    
    // make Question objects from json objects
    NSMutableArray<Question *> * questions = [NSMutableArray array];
    for (NSDictionary * questionJSONObject in questionsJSONObject)
    {
        Question * question = [[[Question alloc] initWithJSONDictionary:questionJSONObject] autorelease];
        if (question != nil)
            [questions addObject:question];
    }
    
    // filter out blacklisted questions
    NSMutableArray<Question *> * filtered = [NSMutableArray array];
    for (Question * question in questions)
    {
        if ([self.blacklist containsObject:question.identifier] == NO)
            [filtered addObject:question];
    }
    
    // if no non-blacklisted questions left then use any questions
    if (filtered.count < 1)
        filtered = questions;
    
    // shuffle questions
    for (NSUInteger i = 0; i < filtered.count; i++)
        [filtered exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((uint32_t)filtered.count)];
    
    // limit count
    self.questions = [filtered subarrayWithRange:NSMakeRange(0, MIN(filtered.count, self.count))];
    
    // load images
    NSMutableDictionary<NSUUID *, NSData *> * images = [NSMutableDictionary dictionary];
    NSOperationQueue * imageLoadingQueue = [[NSOperationQueue new] autorelease];
    imageLoadingQueue.maxConcurrentOperationCount = 5;
    
    for (Question * question in self.questions)
    {
        NSURL * url = [NSURL URLWithString:question.imageURLString];
        if (url != nil)
        {
            [imageLoadingQueue addOperationWithBlock:^{
                URLDataTaskOperation * operation = [[[URLDataTaskOperation alloc] initWithURL:url] autorelease];
                [operation main];
                @synchronized (images) {
                    images[question.identifier] = operation.data;
                }
            }];
        }
    }
    
    [imageLoadingQueue waitUntilAllOperationsAreFinished];
    self.images = images;
}

@end
