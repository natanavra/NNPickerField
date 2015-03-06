//
//  NNObjectPickerField.h
//  NNLibraries
//
//  Created by Natan Abramov on 1/9/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NNPickerField.h"

@class NNObjectPickerField;

@protocol NNObjectPickerFieldDelegate <NNPickerFieldDelegate>
@optional
- (BOOL)pickerField:(NNObjectPickerField *)picker shouldSelectObject:(id)object atIndex:(NSInteger)index;
- (void)pickerField:(NNObjectPickerField *)picker didSelectObject:(id)object atIndex:(NSInteger)index;
@end

@interface NNObjectPickerField : NNPickerField
@property (nonatomic, weak) id<NNObjectPickerFieldDelegate> pickerDelegate;

/** Objects that conform to the <i>NNSelectable</i> protocol */
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, readonly) NSInteger selectedIndex;
@property (nonatomic, readonly) id selectedObject;

- (void)setCurrentSelectedIndex:(NSInteger)index;
- (void)setCurrentSelectedObject:(id)selectedObject;
- (void)setGenericItems:(NSArray *)items;

@end
