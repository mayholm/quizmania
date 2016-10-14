//
//  Question.m
//  QuizMania
//
//  Created by Pär Majholm on 11/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import "Question.h"

@interface Question ()

@property (readwrite, retain) NSString * text;
@property (readwrite, retain) NSArray<NSString *> * options;
@property (readwrite, assign) uint32_t indexOfCorrectOption;
@property (readwrite, retain) NSString * imageURLString;
@property (readwrite, retain) NSUUID * identifier;

@end

@implementation Question

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary
{
    self = [super init];
    if (self == nil) return nil;
    self.text = jsonDictionary[@"text"];
    self.options = jsonDictionary[@"options"];
    self.indexOfCorrectOption = (uint32_t)[jsonDictionary[@"indexOfCorrectOption"] intValue];
    self.imageURLString = jsonDictionary[@"imageURL"];
    self.identifier = jsonDictionary[@"identifier"];
    return self;
}

@end
