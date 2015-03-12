# NNPickerField
UITextField subclasses supporting UIPickerViews as inputs (instead of the standard keyboard)

##Usage
The NNPickerFields are a simple way to accept non-keyboard input from a user, imitating the known and common combo-boxes.
The NNPickerFields are divided into several different classes, each handles a specific use-case:
- NNDatePickerField
- NNObjectPickerField
- NNNumberPickerField

The classes have internal documentation and are quite readable and descriptive. (Feel free to ask for explanations if not)

Every NNPickerField subclass has an option to show a UIToolbar accessory above it with an optional title and clear and close buttons:
```
[myNNPickerField setShowsToolBarWithTitle: @"Title" 
                     withCloseButtonTitle: @"Close ME"
                           withClearTitle: @"Cleanup"
                           withTitleColor: nil];
```

###NNDatePickerField
The NNDatePickerField utilizes the UIDatePicker and is used for selecting dates and times.
The picker supports all UIDatePickerModes: Date and time, Time, Date and Countdown:
```
[myDatePicker setDatePickerMode: UIDatePickerModeDateAndTime];
```

The picker also supports custom date formats, if no formats are provided - the system's default formats are used.
```
[myDatePicker setDateDisplayFormat: @"dd/MM/yy"];
```

The picker supports limiting date and time selection with minimum/maximum dates:
```
[myDatePicker setMinimumDate: [NSDate date]]; //Limits the minimum date to now.
[myDatePicker setMaximumDate: [NSDate dateWithTimeIntervalSinceNow: 60 * 60 * 24 * 7]]; //Limits the maximum date to a week from now.
```


###NNObjectPickerField
The NNObjectPickerField is used for picking object types - objects, strings, etc.
Basic usage:
```
[objectPickerField setItems: [NSArray arrayWithObjects: @"1", @"John", myObject]];
```
**Notice:** The NNObjectPickerField currently supports <code>NSString</code> and all objects that confirm to the <code>NNSelectable</code> protocol.

###NNNumberPickerField
The NNNumberPickerField is used for picking a number from a range of numbers.
Basic usage:
```
[myNumberPickerField showNumberRangeFromNumber:2005 toNumber:2015];
```
###NNPickerFieldDelegate
Each NNPickerField defines a custom delegate protocol of it's own and ll custom delegate protocols conform to the generic <code>NNPickerFieldDelegate</code> that informs the delegate of clicks on the 'close' and 'clear' buttons.
The custom delegate protocols ask wether a change in selection should occur and also informs the delegate of changes in selection.

##License
<pre>
Feel free to use this software at any way you see fit.
I hold no responsibility of any usage. The software is provided "AS IS".
I'll insert a more official license here once I find what fits.
</pre>
