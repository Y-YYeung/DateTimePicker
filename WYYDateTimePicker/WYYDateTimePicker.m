//
//  WYYAbstractDateTimePicker.m
//  WYYDatePicker
//
//  Created by Mon on 6/10/16.
//  Copyright © 2016 YYYeung. All rights reserved.
//

#import "WYYDateTimePicker.h"

@interface WYYDateTimePicker ()

@property (nonatomic, assign, readwrite) HourFormat hourFormat;

@end

@implementation WYYDateTimePicker

#pragma mark - Initializer
- (instancetype)initWithFrame:(CGRect)frame{
    NSAssert(NO, @"Use initWithHeight:hourFormat: instead, please");
    return nil;
}

+ (instancetype)pickerWithHeight:(CGFloat)height hourFormat:(HourFormat)hourFormat needConfirmCancel:(BOOL)needConfirmCancel{
    Class class = nil;
    if (hourFormat == HourFormat12) {
        class = NSClassFromString(@"WYYDateTime12HourPicker");
    } else {
        class = NSClassFromString(@"WYYDateTime24HourPicker");
    }
    
    return [[class alloc] initWithHeight:height hourFormat:hourFormat needConfirmCancel:needConfirmCancel];
}

- (instancetype)initWithHeight:(CGFloat)height hourFormat:(HourFormat)hourFormat needConfirmCancel:(BOOL)needConfirmCancel{
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), height)];
    if (self) {
        self.hourFormat = hourFormat;
        self.needConfirmCancel = needConfirmCancel;
    }
    
    return self;
}

#pragma mark - View Helpers
- (void)setupSubviews{
    [self addSubview:self.pickerView];
}

#pragma mark - Helpers
- (void)configureDefaultValue{
    self.startYear  = 1970;
    self.endYear    = 2029;
}

- (BOOL)dateValidWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day{
    self.dateComponent.year  = year.integerValue;
    self.dateComponent.month = month.integerValue;
    self.dateComponent.day   = day.integerValue;
    
    return [self.dateComponent isValidDate];
}

- (BOOL)isValidDateInGregorianCalendarWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day{
    self.dateComponent.year  = year.integerValue;
    self.dateComponent.month = month.integerValue;
    self.dateComponent.day   = day.integerValue;
    
    return [self.dateComponent isValidDateInCalendar:CurrentCalendar];
}

- (BOOL)isValidDateInGregorianCalendarWithDateComponents:(NSDateComponents *)dateComponents{
    return [self.dateComponent isValidDateInCalendar:CurrentCalendar];
}

- (void)confirmAction:(UIBarButtonItem *)sender{
    if ([self.dateTimeDelegate respondsToSelector:@selector(dateTimePicker:didConfirmSelectedDateTime:)] && self.needConfirmCancel) {
        [self.dateTimeDelegate dateTimePicker:self didConfirmSelectedDateTime:self.selectedDate];
    }
}

- (void)cancelAction:(UIBarButtonItem *)sender{
    if ([self.dateTimeDelegate respondsToSelector:@selector(dateTimePicker:didCancelSelectedDateTiem:)] && self.needConfirmCancel) {
        [self.dateTimeDelegate dateTimePicker:self didCancelSelectedDateTiem:self.selectedDate];
    }
}

#pragma mark - Class Methods
+ (NSArray *)generateSequenceFrom:(NSInteger)from to:(NSInteger)to{
    NSMutableArray *sequence = [NSMutableArray array];
    for (NSInteger i = from; i <= to; i++) {
        [sequence addObject:[NSString stringWithFormat:@"%ld", i]];
    }
    
    return [sequence copy];
}

- (NSDate *)generateLocalDateWithDateComponents:(NSDateComponents *)dateComponents{
    return nil;
}

#pragma mark - Data Source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 8;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return self.years.count;
        case 1:
            return self.months.count;
        case 2:
            return self.days.count;
        case 3:
            return self.hours.count;
        case 4:
        case 6:
            return 1;
        case 5:
            return self.minutes.count;
        case 7:
            return self.seconds.count;
            
        default:
            return 0;
    }
}

#pragma mark - Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return YearComponentWidth;
        case 1:
        case 2:
        case 3:
        case 5:
        case 7:
            return OtherComponentWidth;
        case 4:
        case 6:
            return TimeSeparatorWidth;
            
        default:
            return 0;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return RowHeight;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title = nil;
    switch (component) {
        case 0:
            title = self.years[row];
            break;
        case 1:
            title = self.months[row];
            break;
        case 2:
            title = self.days[row];
            break;
        case 3:
            title = self.hours[row];
            break;
        case 4:
        case 6:
            title = @":";
            break;
        case 5:
            title = self.minutes[row];
            break;
        case 7:
            title = self.seconds[row];
            break;
            
        default:
            return nil;
    }
    
    return [[NSAttributedString alloc] initWithString:title attributes:self.titleAttributes];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    // Translate year, month and day
    NSString *year  = self.years[[pickerView selectedRowInComponent:0]];
    NSString *month = self.months[[pickerView selectedRowInComponent:1]];
    NSString *day   = self.days[[pickerView selectedRowInComponent:2]];
    
    self.dateComponent.year  = year.integerValue;
    self.dateComponent.month = month.integerValue;
    self.dateComponent.day   = day.integerValue;
    
    // Verify if the date is valid
    if (component == 0 || component == 1 || component == 2) {
        BOOL dateValid = [self isValidDateInGregorianCalendarWithDateComponents:self.dateComponent];
        
        if (!dateValid) {
            NSInteger selectedDayRow = [pickerView selectedRowInComponent:2];
            [pickerView selectRow:selectedDayRow - 1 inComponent:2 animated:YES];
            [self pickerView:pickerView didSelectRow:selectedDayRow - 1 inComponent:2];
            return;
        }
    } else if (component == 4 || component == 6) {
        return;
    }
    
    // Date is valid, translate time
    if ([self.dateTimeDelegate respondsToSelector:@selector(dateTimePicker:didChangeDateTime:)]) {
        NSString *hour = self.hours[[pickerView selectedRowInComponent:3]];
        NSString *minute = self.minutes[[pickerView selectedRowInComponent:5]];
        NSString *second = self.seconds[[pickerView selectedRowInComponent:7]];
        
        self.dateComponent.hour   = hour.integerValue;
        self.dateComponent.minute = minute.integerValue;
        self.dateComponent.second = second.integerValue;
        
        [self.dateTimeDelegate dateTimePicker:self didChangeDateTime:[self generateLocalDateWithDateComponents:self.dateComponent]];
    }
}

#pragma mark - Accessors
- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 200.f)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (NSArray *)years{
    if (!_years) {
        _years = [[self class] generateSequenceFrom:self.startYear to:self.endYear];
    }
    
    return _years;
}

- (NSArray *)months{
    if (!_months) {
        _months = [[self class] generateSequenceFrom:1 to:12];
    }
    
    return _months;
}

- (NSArray *)days{
    if (!_days) {
        _days = [[self class] generateSequenceFrom:1 to:31];
    }
    
    return _days;
}

- (NSArray *)hours{
    if (!_hours) {
        _hours = self.hourFormat == HourFormat12 ? [[self class] generateSequenceFrom:0 to:11] : [[self class] generateSequenceFrom:0 to:23];
    }
    
    return _hours;
}

- (NSArray *)minutes{
    if (!_minutes) {
        _minutes = [[self class] generateSequenceFrom:0 to:59];
    }
    
    return _minutes;
}

- (NSArray *)seconds{
    if (!_seconds) {
        _seconds = [[self class] generateSequenceFrom:0 to:59];
    }
    
    return _seconds;
}

- (NSDictionary *)titleAttributes{
    if (!_titleAttributes) {
        _titleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10.f]};
    }
    
    return _titleAttributes;
}

- (NSDateComponents *)dateComponent{
    if (!_dateComponent) {
        _dateComponent = [[NSDateComponents alloc] init];
    }
    
    return _dateComponent;
}

- (void)setStartYear:(NSInteger)startYear{
    _startYear = startYear < 1970 ? 1970 : startYear;
}

- (void)setEndYear:(NSInteger)endYear{
    _endYear = endYear < self.startYear ? self.startYear + 59 : endYear;
}

@end
