//
//  FeedbackViewController.h
//  Finance
//
//  Created by Blake Tsuzaki on 8/29/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface FeedbackViewController : UIViewController <MBProgressHUDDelegate>
@property (retain, nonatomic) IBOutlet UITextView *feedbackText;
- (IBAction)doneButtonTapped:(id)sender;

@end
