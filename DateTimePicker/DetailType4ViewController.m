//
//  DetailType4ViewController.m
//  DateTimePicker
//
//  Created by Mon on 6/19/16.
//  Copyright © 2016 YYYeung. All rights reserved.
//

#import "DetailType4ViewController.h"

@interface DetailType4ViewController ()<WYYDateTimePickerDelegate>

@end

@implementation DetailType4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dateTimePicker = [WYYDateTimePicker pickerWithHeight:200.f hourFormat:HourFormat24 needConfirmCancel:YES yearRange:WYYMakeYearRange(2012, 2029) initialDate:[NSDate date]];
    self.dateTimePicker.dateTimeDelegate = self;
    self.dateTimePicker.loop = NO;
    [self.view addSubview:self.dateTimePicker];
    self.dateTimePicker.center = self.view.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dateTimePicker:(WYYDateTimePicker *)dateTimePicker didConfirmSelectedDateTime:(NSDate *)dateTime{
    self.lbValueChangedPrompt.text = [NSString stringWithFormat:@"%@ %@", ValueConfirmSelectedPrompt, [self.dateFormatter stringFromDate:dateTime]];
}

- (void)dateTimePicker:(WYYDateTimePicker *)dateTimePicker didCancelSelectedDateTiem:(NSDate *)dateTime{
    self.lbValueChangedPrompt.text = [NSString stringWithFormat:@"%@ %@", ValueCancelSelectedPrompt, [self.dateFormatter stringFromDate:dateTime]];
}

- (void)dateTimePicker:(WYYDateTimePicker *)dateTimePicker didChangeDateTime:(NSDate *)dateTime{
    self.lbValueChangedPrompt.text = [NSString stringWithFormat:@"%@ %@", ValueChangePrompt, [self.dateFormatter stringFromDate:dateTime]];
}

@end
