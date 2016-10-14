//
//  Question.h
//  QuizMania
//
//  Created by Pär Majholm on 11/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (readonly) NSString * text;
@property (readonly) NSArray<NSString *> * options;
@property (readonly) uint32_t indexOfCorrectOption;
@property (readonly) NSString * imageURLString;
@property (readonly) NSUUID * identifier;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@end
