//
//  Observer.h
//  kvoTest
//
//  Created by Pär Majholm on 29/06/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ObserverCallback)(NSDictionary<NSString*, id>* change);

@interface Observer : NSObject

- (instancetype)initWithObject:(NSObject*)object
                       keyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                      callback:(ObserverCallback)callback;

- (instancetype)initWithObject:(NSObject*)object
                       keyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                        target:(NSObject*)target
                      selector:(SEL)selector;

@end
