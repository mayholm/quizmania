//
//  URLDataTaskOperation.h
//  QuizMania
//
//  Created by Pär Majholm on 11/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import "Operation.h"

@interface URLDataTaskOperation : Operation

// output
@property (retain) NSData * data;
@property (retain) NSURLResponse * response;
@property (readonly) NSHTTPURLResponse * httpResponse;

- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithURLString:(NSString *)urlString;

@end
