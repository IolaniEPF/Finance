//
//  FeedbackViewController.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/29/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "FeedbackViewController.h"
#import "TestFlight.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_feedbackText release];
    [super dealloc];
}
- (IBAction)doneButtonTapped:(id)sender {
    [self.feedbackText resignFirstResponder];
    [TestFlight submitFeedback:self.feedbackText.text];
    self.feedbackText.text = @"Tap here to type";
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Thank you!"
                                                         message:@"We just received your feedback and will review it shortly."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
    [errorAlert release];
}
@end
