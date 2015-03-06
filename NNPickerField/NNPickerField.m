//
//  NNPickerField.m
//  NNLibraries
//
//  Created by Natan Abramov on 2/28/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNPickerField.h"

typedef NS_ENUM(NSInteger, toolbarItemIndex) {
    toolbarClearItemIndex = 0,
    toolbarTitleItemIndex = 2,
    toolbarCloseItemIndex = 4,
};

@interface NNPickerField ()
@property (nonatomic, readonly) BOOL showsToolbar;
@property (nonatomic, copy, readonly) UIColor *titleColor;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *clearButtonTitle;
@property (nonatomic, copy, readonly) NSString *closeButtonTitle;
@end

@implementation NNPickerField

#pragma mark - Overrides

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

- (BOOL)becomeFirstResponder {
    [self PROTECTED(setupPicker)];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [super resignFirstResponder];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if(self = [super initWithCoder: decoder]) {
        _pickerPlaceholder = self.text;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame: frame]) {
        _pickerPlaceholder = self.text;
    }
    return self;
}

#pragma mark - Static Components

- (UIToolbar *)PROTECTED(inputAccessoryToolbar) {
    static UIToolbar *toolbar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44.0f)];
        
        NSMutableArray *toolbarItems = [NSMutableArray array];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle: nil
                                                                 style: UIBarButtonItemStylePlain
                                                                target: self
                                                                action: @selector(PROTECTED(clearField))];
        [toolbarItems addObject: item];
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                                       target: nil
                                                                                       action: nil];
        [toolbarItems addObject: flexibleSpace];
        
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, toolbar.frame.size.width * 0.6, toolbar.frame.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.text = nil;
        label.textAlignment = NSTextAlignmentCenter;
        UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView: label];
        [toolbarItems addObject: titleItem];
        
        flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                      target: nil
                                                                      action: nil];
        [toolbarItems addObject: flexibleSpace];
        
        item = [[UIBarButtonItem alloc] initWithTitle: nil
                                                style: UIBarButtonItemStyleDone
                                               target: self
                                               action: @selector(PROTECTED(closePicker))];
        [toolbarItems addObject: item];
        toolbar.items = toolbarItems;
        
    });
    return toolbar;
}

#pragma mark - UIToolbar

- (void)updateToolBarDisplay {
    if(_showsToolbar) {
        UIToolbar *toolbar = [self PROTECTED(inputAccessoryToolbar)];
        NSMutableArray *items = [toolbar.items mutableCopy];
        UIBarButtonItem *clearItem = items[toolbarClearItemIndex];
        UIBarButtonItem *closeItem = items[toolbarCloseItemIndex];
        UIBarButtonItem *titleItem = items[toolbarTitleItemIndex];
        
        clearItem.enabled = _clearButtonTitle.length > 0;
        [clearItem setTitle: _clearButtonTitle.length > 0 ? _clearButtonTitle : nil];
        [clearItem setTarget: self];
        
        closeItem.enabled = _closeButtonTitle.length > 0;
        [closeItem setTitle: _closeButtonTitle.length > 0 ? _closeButtonTitle : nil];
        [closeItem setTarget: self];
        
        if(_title) {
            UILabel *title = (UILabel *)titleItem.customView;
            title.text = _title;
            title.textColor = _titleColor ? _titleColor : [UIColor blackColor];
        }
        
        [toolbar setItems: items animated: YES];
        self.inputAccessoryView = toolbar;
    } else {
        self.inputAccessoryView = nil;
    }
}

- (void)PROTECTED(closePicker) {
    if([_pickerDelegate respondsToSelector: @selector(pickerFieldDidClose:)]) {
        [_pickerDelegate pickerFieldDidClose: self];
    }
    [self resignFirstResponder];
}

- (void)PROTECTED(clearField) {
    if([_pickerDelegate respondsToSelector: @selector(pickerFieldDidClearSelection:)]) {
        [_pickerDelegate pickerFieldDidClearSelection: self];
    }
    self.text = _pickerPlaceholder;
    [self resignFirstResponder];
}

- (void)setShowsToolBarWithTitle:(NSString *)title withCloseButtonTitle:(NSString *)closeTitle withClearTitle:(NSString *)clearTitle withTitleColor:(UIColor *)color {
    _showsToolbar = YES;
    _clearButtonTitle = [clearTitle copy];
    _title = [title copy];
    _closeButtonTitle = [closeTitle copy];
    _titleColor = [color copy];
}

#pragma mark - Picker Related

- (void)PROTECTED(setupPicker) {
    [self updateToolBarDisplay];
    
    //To hide the blinking cursor.
    self.tintColor = [UIColor clearColor];
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

@end
