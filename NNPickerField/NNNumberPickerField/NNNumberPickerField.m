//
//  NNNumberPickerField.m
//  NNLibraries
//
//  Created by Natan Abramov on 2/28/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNNumberPickerField.h"

@interface NNNumberPickerField () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, weak) UIPickerView *picker;
@end

@implementation NNNumberPickerField
@synthesize pickerDelegate = _pickerDelegate;

#pragma mark - Static Components

- (UIPickerView *)pickerView {
    static UIPickerView *picker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        picker = [[UIPickerView alloc] init];
    });
    return picker;
}

#pragma mark - Overrides

- (void)initZero {
    _selectedIndex = -1;
    _selectedNumber = NSNotFound;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame: frame]) {
        [self initZero];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder: aDecoder]) {
        [self initZero];
    }
    return self;
}

- (void)PROTECTED(setupPicker) {
    [super PROTECTED(setupPicker)];
    UIPickerView *picker = [self pickerView];
    _picker = picker;
    picker.delegate = self;
    picker.dataSource = self;
    self.inputView = picker;
    
    [self setCurrentSelectedIndex: _selectedIndex == -1 ? 0 : _selectedIndex];
}

- (void)PROTECTED(clearField) {
    [super PROTECTED(clearField)];
    _selectedIndex = -1;
    _selectedNumber = NSNotFound;
}

#pragma mark - Instance Methods

- (void)showNumberRangeFromNumber:(NSInteger)fromNumber toNumber:(NSInteger)toNumber {
    if(fromNumber > toNumber) {
        NSInteger holder = fromNumber;
        fromNumber = toNumber;
        toNumber = holder;
    } else if(fromNumber == toNumber) {
        toNumber ++;
    }
    _fromNumber = fromNumber;
    _toNumber = toNumber;
    _selectedNumber = NSNotFound;
    [_picker reloadAllComponents];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self numberOfRows];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat: @"%zi", _fromNumber + row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    BOOL shouldSelect = YES;
    if([_pickerDelegate respondsToSelector: @selector(pickerField:shouldSelectNumber:)]) {
        shouldSelect = [_pickerDelegate pickerField: self shouldSelectNumber: _fromNumber + row];
    }
    if(shouldSelect) {
        _selectedIndex = row;
        _selectedNumber = _fromNumber + row;
        self.text = [NSString stringWithFormat: @"%zi", _selectedNumber];
        if([_pickerDelegate respondsToSelector: @selector(pickerField:didSelectNumber:)]) {
            [_pickerDelegate pickerField: self didSelectNumber: _selectedNumber];
        }
    }
}

- (void)setSelectedNumber:(NSInteger)selectedNumber {
    if(selectedNumber >= _fromNumber && selectedNumber <= _toNumber) {
        _selectedNumber = selectedNumber;
        _selectedIndex = _selectedNumber - _fromNumber;
    }
}

- (void)setCurrentSelectedIndex:(NSInteger)index {
    if(index >= 0 && index < [self numberOfRows]) {
        [_picker selectRow: index inComponent: 0 animated: YES];
        [self pickerView: _picker didSelectRow: index inComponent: 0];
    }
}

- (NSInteger)numberOfRows {
    return _toNumber - _fromNumber + 1;
}

@end
