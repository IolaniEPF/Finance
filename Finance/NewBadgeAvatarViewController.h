//
//  NewBadgeAvatarViewController.h
//  Finance
//
//  Created by Blake Tsuzaki on 8/30/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface NewBadgeAvatarViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
@property (retain, nonatomic) IBOutlet UITableView *avatarTable;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *nextButton;
- (IBAction)nextButtonPressed:(id)sender;


@end
