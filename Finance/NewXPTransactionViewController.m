//
//  NewXPTransactionViewController.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/30/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "NewXPTransactionViewController.h"

@interface NewXPTransactionViewController ()

@end

@implementation NewXPTransactionViewController

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
        [self saveTransactionData];
    }
}

- (void)saveTransactionData{
    NSNumberFormatter *amountFormatter = [[NSNumberFormatter alloc] init];
    if([amountFormatter numberFromString:self.transactionAmountText.text]){
        [[NSUserDefaults standardUserDefaults] setObject:[amountFormatter numberFromString:self.transactionAmountText.text] forKey:@"XPAmount"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"XPAmount"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.transactionDescriptionText.text forKey:@"XPDescription"];
    [self transitionToNext];
}

- (void)transitionToNext{
    [self performSegueWithIdentifier:@"XPchooseAvatarSegue" sender:self];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [_transactionAmountText release];
    [_transactionDescriptionText release];
    [super dealloc];
}
@end
