//
//  NewTransactionViewController.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/28/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "NewTransactionViewController.h"
#import "UINavigationController+KeyboardDismiss.h"
#import <Parse/Parse.h>

@interface NewTransactionViewController ()

@end

@implementation NewTransactionViewController

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
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0f green:45/255.0f blue:107/255.0f alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_transactionTypeSegment release];
    [_transactionAmountText release];
    [_transactionDescriptionText release];
    [super dealloc];
}
- (IBAction)nextButtonTapped:(id)sender {
    [self.transactionAmountText resignFirstResponder];
    [self.transactionDescriptionText resignFirstResponder];
    if([self.transactionAmountText.text isEqualToString:@""]||[self.transactionDescriptionText.text isEqualToString:@""]){
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"You left something blank."
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        
    }else{
        NSNumberFormatter *amountFormatter = [[NSNumberFormatter alloc] init];
        [amountFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
        [amountFormatter setMaximumFractionDigits:2];
        if([amountFormatter numberFromString:self.transactionAmountText.text] != nil && [[amountFormatter numberFromString:self.transactionAmountText.text] floatValue] >0){
            [[NSUserDefaults standardUserDefaults] setObject:[amountFormatter numberFromString:self.transactionAmountText.text] forKey:@"transactionAmount"];
            [self saveTransactionData];
        }
    }
}

- (void)saveTransactionData{
    [[NSUserDefaults standardUserDefaults] setObject:self.transactionDescriptionText.text forKey:@"transactionDescription"];
    [[NSUserDefaults standardUserDefaults] setObject:[self.transactionTypeSegment titleForSegmentAtIndex:[self.transactionTypeSegment selectedSegmentIndex]] forKey:@"transactionType"];
    [self transitionToNext];
}

- (void)transitionToNext{
    [self performSegueWithIdentifier:@"chooseAvatarSegue" sender:self];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
