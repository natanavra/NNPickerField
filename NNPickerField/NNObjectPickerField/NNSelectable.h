//
//  NNSelectable.h
//  NNLibraries
//
//  Created by Natan Abramov on 1/9/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NNSelectable <NSObject>
@required
- (NSString *)title;
@optional
- (NSInteger)objectID;
- (NSString *)objectStringID;
@end