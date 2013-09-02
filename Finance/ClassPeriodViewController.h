//
//  ClassPeriodViewController.h
//  Finance
//
//  Created by Blake Tsuzaki on 8/23/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassPeriodViewController : UIViewController
@property (retain, nonatomic) IBOutlet UISegmentedControl *classPeriod;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *nextButton;
- (IBAction)nextButtonTapped:(UIBarButtonItem *)sender;

@end
