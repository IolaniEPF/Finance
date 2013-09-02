//
//  NewTransactionViewController.h
//  Finance
//
//  Created by Blake Tsuzaki on 8/28/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface NewTransactionViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
@property (retain, nonatomic) IBOutlet UISegmentedControl *transactionTypeSegment;
@property (retain, nonatomic) IBOutlet UITextField *transactionAmountText;
@property (retain, nonatomic) IBOutlet UITextField *transactionDescriptionText;
- (IBAction)nextButtonTapped:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end
