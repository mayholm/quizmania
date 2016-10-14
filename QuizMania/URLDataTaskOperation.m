//
//  URLDataTaskOperation.m
//  QuizMania
//
//  Created by Pär Majholm on 11/10/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import "URLDataTaskOperation.h"

@interface URLDataTaskOperation ()

@property (retain) NSURL * url;

@end

@implementation URLDataTaskOperation
{
    dispatch_semaphore_t _finishSemaphore;
}

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self == nil) return nil;
    _finishSemaphore = dispatch_semaphore_create(0);
    self.url = url;
    return self;
}

- (instancetype)initWithURLString:(NSString *)urlString
{
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (void)dealloc
{
    [_data release];
    [_response release];
    
    dispatch_release(_finishSemaphore);
    
    [super dealloc];
}

- (void)main
{
    [[[NSURLSession sharedSession] dataTaskWithURL:self.url completionHandler:
     ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        // change to weak self if save this block
        self.data = data;
        self.response = response;
        if (error)
            self.error = error;
        dispatch_semaphore_signal(_finishSemaphore);
        
    }] resume];
    dispatch_semaphore_wait(_finishSemaphore, DISPATCH_TIME_FOREVER);
}

- (NSHTTPURLResponse *)httpResponse
{
    return (NSHTTPURLResponse *)self.response;
}

@end
