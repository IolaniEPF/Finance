//
//  MainViewController.h
//  Finance
//
//  Created by Blake Tsuzaki on 8/21/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeView.h"
#import "MBProgressHUD.h"

@interface MainViewController : UIViewController <UIScrollViewDelegate,MBProgressHUDDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (retain, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (retain, nonatomic) IBOutlet UIScrollView *backgroundScrollView;
@property (retain, nonatomic) IBOutlet UIScrollView *foregroundScrollView;
@property (retain, nonatomic) IBOutlet UIView *foregroundView;
- (IBAction)changeImageSize:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *expandButton;
- (IBAction)refreshMain:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *refreshButton;
@property (retain, nonatomic) IBOutlet BadgeView *badgeView;
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;


@end
