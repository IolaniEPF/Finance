//
//  TransactionRecipientViewController.h
//  Finance
//
//  Created by Blake Tsuzaki on 8/28/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface TransactionRecipientViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
- (IBAction)nextButtonPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (retain, nonatomic) IBOutlet UITableView *avatarTable;

@end
