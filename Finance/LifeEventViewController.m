//
//  LifeEventViewController.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/28/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "LifeEventViewController.h"

@interface LifeEventViewController ()

@end

@implementation LifeEventViewController

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
    [self.newsText setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"newsStory"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_newsText release];
    [super dealloc];
}
- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
