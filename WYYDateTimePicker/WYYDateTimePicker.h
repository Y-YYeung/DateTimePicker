//
//  WYYAbstractDateTimePicker.h
//  WYYDatePicker
//
//  Created by Mon on 6/10/16.
//  Copyright © 2016 YYYeung. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CurrentCalendar [NSCalendar currentCalendar]

static const CGFloat RowHeight           = 35.f;
static const CGFloat YearComponentWidth  = 68.f;
static const CGFloat TimeSeparatorWidth  = 14.f;
static const CGFloat OtherComponentWidth = 40.f;

typedef struct _WYYYearRange {
    NSInteger startYear;
    NSInteger endYear;
} WYYYearRange;

NS_INLINE WYYYearRange WYYMakeYearRange(NSInteger startYear, NSInteger endYear) {
    WYYYearRange r;
    r.startYear = startYear;
    r.endYear = endYear;
    return r;
}

typedef enum : NSUInteger {
    HourFormat12,
    HourFormat24,
} HourFormat;

typedef enum : NSUInteger {
    HourPeriodDay,
    HourPeriodNight,
} HourPeriod;


@class WYYDateTimePicker;

typedef void(^DateTimePickerValueAMPMDidChange)(WYYDateTimePicker *dateTimePicker, HourPeriod hourPeriod, NSDate *dateTime);
typedef void(^DateTimePickerValueDidChange)(WYYDateTimePicker *dateTimePicker, NSDate *dateTime);
typedef void(^DateTimePickerSelectedValueDidConfirm)(WYYDateTimePicker *dateTimePicker, NSDate *dateTime);
typedef void(^DateTimePickerSelectedValueDidCancel)(WYYDateTimePicker *datetimePicker, NSDate *dateTime);

@protocol WYYDateTimePickerDelegate <NSObject>

@optional
- (void)dateTimePicker:(WYYDateTimePicker *)dateTimePicker didChangeDateTime:(NSDate *)dateTime;

/**
 *  @author YYYeung
 *
 *  @brief Called when the day/night is switched. Usable when the concrete instance is class of WYYDateTime12HourPicker.
 *
 *  @param dateTimePicker The manipulated DateTimePicker.
 *  @param hourPeriod     Indicates that day or night the time represents.
 *  @param dateTime       The selected dateTime when change the day/night symbol.
 */
- (void)dateTimePicker:(WYYDateTimePicker *)dateTimePicker didChangeAMPM:(HourPeriod)hourPeriod dateTime:(NSDate *)dateTime;

/**
 *  @author YYYeung
 *
 *  @brief Called when the selected dateTime is confirmed.
 *
 *  @param dateTimePicker The manipulated DateTimePicker.
 *  @param dateTime       The selected dateTime when confirming.
 */
- (void)dateTimePicker:(WYYDateTimePicker *)dateTimePicker didConfirmSelectedDateTime:(NSDate *)dateTime;

/**
 *  @author YYYeung
 *
 *  @brief Called when the DateTimePicker is canceled.
 *
 *  @param dateTimePicker The manipulated DateTimePicker.
 *  @param dateTime       The selected dateTime when canceled.
 */
- (void)dateTimePicker:(WYYDateTimePicker *)dateTimePicker didCancelSelectedDateTiem:(NSDate *)dateTime;


@end

@interface WYYDateTimePicker : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

/**
 *  @author YYYeung
 *
 *  @brief The range of choices of year.
 */
@property (nonatomic, assign) WYYYearRange yearRange;

/**
 *  @author YYYeung
 *
 *  @brief Indicates the time format is 12-hour or 24-hour.
 *         YES if the format is 24-hour, NO if the format is 12-hour.
 */
@property (nonatomic, assign, readonly) HourFormat hourFormat;

/**
 *  @author YYYeung
 *
 *  @brief Indicates whether the wheels of the picker view should have infinite rows. YES if picker view should have infinite rows, otherwise, NO. Default is YES.
 */
@property (nonatomic, assign) BOOL loop;

/**
 *  @author YYYeung
 *
 *  @brief Indicates whether confirm and cancel button should show up. YES if confirm and cancel button should show up, otherwise, NO.
 */
@property (nonatomic, assign) BOOL needConfirmCancel;

@property (nonatomic, weak) id<WYYDateTimePickerDelegate> dateTimeDelegate;

#pragma mark - Data Source
@property (nonatomic, strong) NSArray<NSString *> *years;
@property (nonatomic, strong) NSArray<NSString *> *months;
@property (nonatomic, strong) NSArray<NSString *> *days;
@property (nonatomic, strong) NSArray<NSString *> *hours;
@property (nonatomic, strong) NSArray<NSString *> *minutes;
@property (nonatomic, strong) NSArray<NSString *> *seconds;

#pragma mark - Controls
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong, readonly) UIToolbar *toolBar;

#pragma mark - Other Properties
@property (nonatomic, strong) NSDate           *selectedDate;
@property (nonatomic, strong) NSDictionary     *titleAttributes;
@property (nonatomic, strong) NSDateComponents *dateComponent;

#pragma mark - Blocks
@property (nonatomic, copy) DateTimePickerValueAMPMDidChange      dateTimePickerValueAMPMDidChange;
@property (nonatomic, copy) DateTimePickerValueDidChange          dateTimePickerValueDidChange;
@property (nonatomic, copy) DateTimePickerSelectedValueDidConfirm dateTimePickerSelectedValueDidConfirm;
@property (nonatomic, copy) DateTimePickerSelectedValueDidCancel  dateTimePickerSelectedValueDidCancel;

#pragma mark - Initializer
+ (instancetype)pickerWithHeight:(CGFloat)height hourFormat:(HourFormat)hourFormat needConfirmCancel:(BOOL)needConfirmCancel yearRange:(WYYYearRange)range initialDate:(NSDate *)initialDate;
+ (instancetype)pickerWithHeight:(CGFloat)height hourFormat:(HourFormat)hourFormat needConfirmCancel:(BOOL)needConfirmCancel yearRange:(WYYYearRange)range initialDate:(NSDate *)initialDate valueDidChanged:(DateTimePickerValueDidChange)valueDidChange selectedValueDidConfirm:(DateTimePickerSelectedValueDidConfirm)selectedValueDidConfirm selectedValueDidCancel:(DateTimePickerSelectedValueDidCancel)selectedValueDidCancel;

- (instancetype)initWithHeight:(CGFloat)height hourFormat:(HourFormat)hourFormat needConfirmCancel:(BOOL)needConfirmCancel yearRange:(WYYYearRange)range initialDate:(NSDate *)initialDate;
- (instancetype)initWithHeight:(CGFloat)height hourFormat:(HourFormat)hourFormat needConfirmCancel:(BOOL)needConfirmCancel yearRange:(WYYYearRange)range initialDate:(NSDate *)initialDate valueDidChanged:(DateTimePickerValueDidChange)valueDidChange selectedValueDidConfirm:(DateTimePickerSelectedValueDidConfirm)selectedValueDidConfirm selectedValueDidCancel:(DateTimePickerSelectedValueDidCancel)selectedValueDidCancel;

#pragma mark - Other Methods
- (void)setupSubviews;
- (void)configureDefaultValue;
- (BOOL)isValidDateInGregorianCalendarWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day;
- (BOOL)dateValidWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day;
- (BOOL)isValidDateInGregorianCalendarWithDateComponents:(NSDateComponents *)dateComponents;
- (NSDate *)generateLocalDateWithDateComponents:(NSDateComponents *)dateComponents;


#pragma mark - Class Methods
+ (NSArray *)generateSequenceFrom:(NSInteger)from to:(NSInteger)to;


@end
