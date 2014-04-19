//
//  FinanceViewController.h
//  Finance
//
//  Created by Blake Tsuzaki on 8/16/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import <Parse/Parse.h>

@class GPPSignInButton;

@interface FinanceViewController : UIViewController <GPPSignInDelegate>
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *signInActivity;
@property (retain, nonatomic) IBOutlet UILabel *signInLabel;
@property (retain, nonatomic) IBOutlet UILabel *bankLabel1;
@property (retain, nonatomic) IBOutlet UILabel *bankLabel2;
@property (retain, nonatomic) IBOutlet UIImageView *bankLogo;
@property (retain, nonatomic) IBOutlet UIImageView *userImageView;
@end
