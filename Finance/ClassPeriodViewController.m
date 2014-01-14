//
//  ClassPeriodViewController.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/23/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "ClassPeriodViewController.h"

@interface ClassPeriodViewController ()

@end

@implementation ClassPeriodViewController

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
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:140/255.0f green:0/255.0f blue:0/255.0f alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_classPeriod release];
    [_nextButton release];
    [super dealloc];
}
- (IBAction)nextButtonTapped:(UIBarButtonItem *)sender {
    if(self.classPeriod.selectedSegmentIndex != -1){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(self.classPeriod.selectedSegmentIndex + 1)] forKey:@"classPeriod"];
        [self performSegueWithIdentifier:@"nameSegue" sender:self];
    }
}
@end
