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
    [super dealloc];
}
@end
