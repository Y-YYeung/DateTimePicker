//
//  DetailViewController.h
//  DateTimePicker
//
//  Created by Mon on 6/19/16.
//  Copyright © 2016 YYYeung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYYDateTimePicker.h"

static const NSString *ValueChangePrompt         = @"Selected Date Changes to\n";
static const NSString *ValueConfirmSelectedPrompt = @"Confirm Selected Date\n";
static const NSString *ValueCancelSelectedPrompt = @"Cancel Selected Date\n";

@interface DetailViewController : UIViewController

@property (nonatomic, strong) WYYDateTimePicker *dateTimePicker;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UILabel *lbValueChangedPrompt;

@end
