//
//  NSObject+observeKeyPath.m
//  kvoTest
//
//  Created by Pär Majholm on 29/06/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import "NSObject+observeKeyPath.h"

@implementation NSObject (observeKeyPath)

- (Observer*)observeKeyPath:(NSString*)keyPath callback:(ObserverCallback)callback
{
    return [self observeKeyPath:keyPath options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld callback:callback];
}
- (Observer*)observeKeyPath:(NSString*)keyPath target:(NSObject*)target selector:(SEL)selector
{
    return [self observeKeyPath:keyPath options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld target:target selector:selector];
}

- (Observer*)observeKeyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options callback:(ObserverCallback)callback
{
    Observer *observer = [[[Observer alloc] initWithObject:self keyPath:keyPath options:options callback:callback] autorelease];
    return observer;
}
- (Observer*)observeKeyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options target:(NSObject*)target selector:(SEL)selector
{
    Observer *observer = [[[Observer alloc] initWithObject:self keyPath:keyPath options:options target:target selector:selector] autorelease];
    return observer;
}

@end
