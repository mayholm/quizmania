//
//  LoadQuestionsOperation.h
//  QuizMania
//
//  Created by Pär Majholm on 12/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import "Operation.h"
#import "Question.h"

@interface LoadQuestionsOperation : Operation

// output
@property (retain) NSArray<Question *> * questions;
@property (retain) NSDictionary<NSUUID *, NSData *> * images;

- (instancetype)initWithCount:(uint32_t)count blacklist:(NSSet<NSUUID *> *)blacklist;

@end
