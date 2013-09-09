//
//  TransactionsViewController.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/27/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "TransactionsViewController.h"
#import "TransactionViewCell.h"
#import <Parse/Parse.h>
@interface TransactionsViewController ()

@end

@implementation TransactionsViewController
#define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

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
    self.XPView.delegate = self.XPView;
    self.XPView.dataSource = self.XPView;
    self.CashView.delegate = self.CashView;
    self.CashView.dataSource = self.CashView;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTables)
                                                 name:@"ReloadTransactions"
                                               object:nil];
    if([[[PFUser currentUser] objectForKey:@"Superuser"] isEqual:@YES]){
        [self.XPButton setHidden:NO];
        [self.badgeButton setHidden:NO];
    }else{
        [self.XPButton setHidden:YES];
        [self.badgeButton setHidden:YES];
    }
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    self.balanceLabel.formatBlock = ^NSString* (float value){
        NSString* formatted = [formatter stringFromNumber:@((int)value)];
        return [NSString stringWithFormat:@"Current Balance: $%@",formatted];
    };
    self.XPLabel.formatBlock = ^NSString* (float value){
        NSString* formatted = [formatter stringFromNumber:@((int)value)];
        return [NSString stringWithFormat:@"XP: %@pts",formatted];
    };
    [self.balanceLabel countFrom:0.0 to:[[[NSUserDefaults standardUserDefaults] objectForKey:@"currentBalance"] floatValue] withDuration:2.];
    
    [self.XPLabel countFrom:0.0 to:[[[NSUserDefaults standardUserDefaults] objectForKey:@"currentXP"] floatValue] withDuration:2.];
    
}
- (void)reloadTables{
    [self.CashView reloadData];
    [self.XPView reloadData];
    if([[[PFUser currentUser] objectForKey:@"Superuser"] isEqual:@YES]){
        [self.XPButton setHidden:NO];
        [self.badgeButton setHidden:NO];
    }else{
        [self.XPButton setHidden:YES];
        [self.badgeButton setHidden:YES];
    }
    [[[PFUser currentUser] objectForKey:@"Balances"] fetch];
    
    [self.balanceLabel countFrom:[[[NSUserDefaults standardUserDefaults] objectForKey:@"currentBalance"] floatValue] to:[[[[PFUser currentUser] objectForKey:@"Balances"] objectForKey:@"CashBalance"] floatValue] withDuration:2.];
    [self.XPLabel countFrom:[[[NSUserDefaults standardUserDefaults] objectForKey:@"currentXP"] floatValue] to:[[[[PFUser currentUser] objectForKey:@"Balances"] objectForKey:@"ExperiencePoints"] floatValue] withDuration:2.];
    
    [[NSUserDefaults standardUserDefaults] setObject:[[[PFUser currentUser] objectForKey:@"Balances"] objectForKey:@"ExperiencePoints"] forKey:@"currentXP"];
    [[NSUserDefaults standardUserDefaults] setObject:[[[PFUser currentUser] objectForKey:@"Balances"] objectForKey:@"CashBalance"] forKey:@"currentBalance"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_XPView release];
    [_CashView release];
    [_badgeButton release];
    [_XPButton release];
    [_balanceLabel release];
    [_XPLabel release];
    [super dealloc];
}
@end
