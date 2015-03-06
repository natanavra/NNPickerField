//
//  NNNumberPickerField.h
//  NNLibraries
//
//  Created by Natan Abramov on 2/28/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NNPickerField.h"

@class NNNumberPickerField;

@protocol NNNumberPickerDelegate <NNPickerFieldDelegate>
@optional
- (BOOL)pickerField:(NNNumberPickerField *)picker shouldSelectNumber:(NSInteger)number;
- (void)pickerField:(NNNumberPickerField *)picker didSelectNumber:(NSInteger)number;
@end

@interface NNNumberPickerField : NNPickerField
@property (nonatomic, weak) id<NNNumberPickerDelegate> pickerDelegate;

@property (nonatomic, readonly) NSInteger selectedIndex;
@property (nonatomic) NSInteger selectedNumber;
@property (nonatomic) NSInteger fromNumber;
@property (nonatomic) NSInteger toNumber;

- (void)setCurrentSelectedIndex:(NSInteger)index;
- (void)showNumberRangeFromNumber:(NSInteger)fromNumber toNumber:(NSInteger)toNumber;
- (NSInteger)numberOfRows;

@end
