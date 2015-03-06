//
//  NNObjectPickerField.m
//  NNLibraries
//
//  Created by Natan Abramov on 1/9/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNObjectPickerField.h"
#import "NNSelectable.h"

@interface NNObjectPickerField () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, weak) UIPickerView *picker;
@end

@implementation NNObjectPickerField
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

static NSArray *_genericItems = nil;

- (NSArray *)genericItems {
    if(!_genericItems) {
        _genericItems = @[];
    }
    return _genericItems;
}

- (void)setGenericItems:(NSArray *)items {
    if(![[self genericItems] isEqualToArray: items]) {
        _genericItems = [items copy];
    }
}

#pragma mark - Overrides

- (void)initZero {
    _selectedIndex = -1;
    _selectedObject = nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder: aDecoder]) {
        [self initZero];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame: frame]) {
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
    
    if(!_items) {
        _items = [self genericItems];
    }
    
    [_picker reloadAllComponents];
    
    [self setCurrentSelectedIndex: _selectedIndex == -1 ? 0 : _selectedIndex];
}

- (void)PROTECTED(clearField) {
    [super PROTECTED(clearField)];
    _selectedIndex = -1;
    _selectedObject = nil;
}

#pragma mark - UIPickerView Protocols


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _items.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    id object = _items[row];
    if([object conformsToProtocol: @protocol(NNSelectable)]) {
        return [object title];
    } else if([object isKindOfClass: NSString.class]) {
        return object;
    } else if([object isKindOfClass: [NSDictionary class]]) {
        return [object allValues][row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(_items.count == 0) {
        return;
    }
    
    BOOL shouldSelect = YES;
    if([_pickerDelegate respondsToSelector: @selector(pickerField:shouldSelectObject:atIndex:)]) {
        shouldSelect = [_pickerDelegate pickerField: self shouldSelectObject: _items[row] atIndex: row];
    }
    
    if(shouldSelect) {
        _selectedObject = _items[row];
        _selectedIndex = row;
        self.text = [_selectedObject conformsToProtocol: @protocol(NNSelectable)] ? [_selectedObject title] : _selectedObject;
        
        if([_pickerDelegate respondsToSelector: @selector(pickerField:didSelectObject:atIndex:)]) {
            [_pickerDelegate pickerField: self didSelectObject: _selectedObject atIndex: _selectedIndex];
        }
    }
}

- (void)setCurrentSelectedIndex:(NSInteger)index {
    NSArray *useItems = _items;
    if(!useItems) {
        useItems = [self genericItems];
    }
    if(index >= 0 && index < useItems.count) {
        if(_picker) {
            [_picker selectRow: index inComponent: 0 animated: YES];
            [self pickerView: _picker didSelectRow: index inComponent: 0];
        } else {
            _selectedIndex = index;
        }
    }
}

- (void)setCurrentSelectedObject:(id)selectedObject {
    NSArray *useItems = _items;
    if(!useItems) {
        useItems = [self genericItems];
    }
    
    if([useItems containsObject: selectedObject]) {
        [self setCurrentSelectedIndex: [useItems indexOfObject: selectedObject]];
    }
}

- (void)setItems:(NSArray *)items {
    _items = [items copy];
    [_picker reloadAllComponents];
}

@end
