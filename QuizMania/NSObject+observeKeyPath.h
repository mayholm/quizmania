//
//  NSObject+observeKeyPath.h
//  kvoTest
//
//  Created by Pär Majholm on 29/06/16.
//  Copyright © 2016 Pär Majholm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Observer.h"

@interface NSObject (observeKeyPath)

- (Observer*)observeKeyPath:(NSString*)keyPath callback:(ObserverCallback)callback;
- (Observer*)observeKeyPath:(NSString*)keyPath target:(NSObject*)target selector:(SEL)selector;

- (Observer*)observeKeyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options callback:(ObserverCallback)callback;
- (Observer*)observeKeyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options target:(NSObject*)target selector:(SEL)selector;

@end
