//
//  Observer.m
//  kvoTest
//
//  Created by Pär Majholm on 29/06/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import "Observer.h"

@interface Observer ()

@property (nonatomic, assign) NSObject *observedObject;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, copy) ObserverCallback callback;
@property (nonatomic, assign) NSObject *target;
@property (nonatomic, assign) SEL selector;

@end

@implementation Observer

- (void)dealloc
{
    [self.observedObject removeObserver:self forKeyPath:self.keyPath];
    [_callback release];
    [_keyPath release];
    [super dealloc];
}

- (instancetype)initWithObject:(NSObject*)object
                       keyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                      callback:(ObserverCallback)callback
{
    return [self initWithObject:object keyPath:keyPath options:options callback:callback target:nil selector:nil];
}

- (instancetype)initWithObject:(NSObject*)object
                       keyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                        target:(NSObject*)target
                      selector:(SEL)selector
{
    return [self initWithObject:object keyPath:keyPath options:options callback:nil target:target selector:selector];
}

#pragma mark - designated initializer

- (instancetype)initWithObject:(NSObject*)object
                       keyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                      callback:(ObserverCallback)callback
                        target:(NSObject*)target
                      selector:(SEL)selector;
{
    self = [super init];
    if (self == nil) return nil;
    
    self.observedObject = object;
    self.keyPath = keyPath;
    self.callback = callback;
    self.target = target;
    self.selector = selector;
    
    [object addObserver:self forKeyPath:keyPath options:options context:nil];
    
    return self;
}

#pragma mark - NSKeyValueObserver informal protocol

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (self.callback != nil)
        self.callback(change);
    if (self.selector != nil)
        [self.target performSelector:self.selector withObject:change];
}

@end
