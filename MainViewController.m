//
//  MainViewController.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/21/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "MainViewController.h"
#import "UIImage+RoundedImage.h"
#import <Parse/Parse.h>
#import "UICountingLabel.h"
#import "LifeEventViewController.h"
#import "EPFWebViewController.h"

@interface MainViewController ()
@property (retain, nonatomic) UICountingLabel *balanceLabel;
@property (retain, nonatomic) UICountingLabel *XPLabel;
@end

@implementation MainViewController
#define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

MBProgressHUD *HUD;
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshAllData)
                                                 name:@"ReloadEverything"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadBalances)
                                                 name:@"ReloadBalances"
                                               object:nil];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"TabBack.png"]];
    [self.avatarImageView setImage:[UIImage roundedImageWithImage:[UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"plusImage"]]]];
    [self.backgroundImageView setImage:[UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundImage"]]];
    self.nameLabel.text = [[PFUser currentUser]objectForKey:@"AvatarName"];
    self.badgeView.dataSource = self.badgeView;
    self.badgeView.delegate = self.badgeView;
    [self displayCountingLabels];
}

- (void)viewDidAppear:(BOOL)animated{
    [self performSelector:@selector(displayLatestNewsStory) withObject:nil afterDelay:.5];
}

- (void)displayLatestNewsStory{
    //[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"newsStory"]; //REMOVE IN FINAL
    PFQuery *newsQuery = [[PFQuery alloc] initWithClassName:@"NewStory"];
    [newsQuery orderByAscending:@"createdAt"];
    PFObject *newsObject = [newsQuery getFirstObject];
    if ((newsObject != nil) && ![[newsObject objectForKey:@"Story"]isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"newsStory"]]){
        [[NSUserDefaults standardUserDefaults] setObject:[newsObject objectForKey:@"Story"] forKey:@"newsStory"];
        [self performSegueWithIdentifier:@"newsSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    EPFWebViewController *webViewController = segue.destinationViewController;
    
    if([segue.identifier isEqualToString:@"announcementsSegue"])
    {
        webViewController.webViewURL = @"https://sites.google.com/a/iolani.org/epfiolani/";
        webViewController.navBar.title = @"Announcements";
        
    }else if([segue.identifier isEqualToString:@"driveSegue"]){
        webViewController.webViewURL = @"https://drive.google.com/a/iolani.org/folderview?id=0Bzogsftlz2EjUGI3OGdyZVFnNVE&usp=sharing";
        webViewController.navBar.title = @"Class Drive";
    }
}

- (void)displayCountingLabels{
    self.balanceLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
    [self.balanceLabel setFont:[UIFont fontWithName:@"Avenir Next Condensed" size:30.0]];
    [self.headerView addSubview:self.balanceLabel];
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    self.balanceLabel.formatBlock = ^NSString* (float value){
        NSString* formatted = [formatter stringFromNumber:@((int)value)];
        return [NSString stringWithFormat:@"Balance: $%@",formatted];
    };
    self.XPLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(275,0,250,40)];
    [self.XPLabel setFont:[UIFont fontWithName:@"Avenir Next Condensed" size:30.0]];
    [self.headerView addSubview:self.XPLabel];
    self.XPLabel.formatBlock = ^NSString* (float value){
        NSString* formatted = [formatter stringFromNumber:@((int)value)];
        return [NSString stringWithFormat:@"XP: %@pts",formatted];
    };
    self.balanceLabel.method = UILabelCountingMethodEaseInOut;
    self.XPLabel.method = UILabelCountingMethodEaseInOut;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentBalance"]==nil){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:0.0] forKey:@"currentBalance"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentXP"]==nil){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:0.0] forKey:@"currentXP"];
    }
    
    [self.balanceLabel countFrom:0.0 to:[[[[[PFUser currentUser] objectForKey:@"Balances"] fetchIfNeeded] objectForKey:@"CashBalance"] floatValue] withDuration:2.];
    
    [self.XPLabel countFrom:0.0 to:[[[[[PFUser currentUser] objectForKey:@"Balances"] fetchIfNeeded] objectForKey:@"ExperiencePoints"] floatValue] withDuration:2.];
    
    [[NSUserDefaults standardUserDefaults] setObject:[[[PFUser currentUser] objectForKey:@"Balances"] objectForKey:@"ExperiencePoints"] forKey:@"currentXP"];
    [[NSUserDefaults standardUserDefaults] setObject:[[[PFUser currentUser] objectForKey:@"Balances"] objectForKey:@"CashBalance"] forKey:@"currentBalance"];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.backgroundScrollView setContentOffset:CGPointMake((scrollView.contentOffset.x *.5), (scrollView.contentOffset.y *.5)) animated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_backgroundImageView release];
    [_avatarImageView release];
    [_backgroundScrollView release];
    [_foregroundScrollView release];
    [_foregroundView release];
    [_expandButton release];
    [_refreshButton release];
    [_badgeView release];
    [_headerView release];
    [_nameLabel release];
    [super dealloc];
}
- (IBAction)changeImageSize:(id)sender {
    if(self.foregroundScrollView.contentOffset.y == 0){
        if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        [self.foregroundScrollView setContentOffset:CGPointMake(0, -380) animated:YES];
        }else{
            [self.foregroundScrollView setContentOffset:CGPointMake(0, -220) animated:YES];
        }
        [self.expandButton setImage:[UIImage imageNamed:@"Up.png"] forState:UIControlStateNormal];
    }else{
        [self.foregroundScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.expandButton setImage:[UIImage imageNamed:@"Down.png"] forState:UIControlStateNormal];
    }
}
- (IBAction)refreshMain:(id)sender {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD showWhileExecuting:@selector(refreshAllData) onTarget:self withObject:nil animated:YES];
}

- (void)refreshAllData{
    NSError *error = nil;
    HUD.labelText = @"Updating images";
    PFQuery *backgroundQuery = [PFQuery queryWithClassName:@"Background"];
    [backgroundQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    PFFile *backgroundImage = [[backgroundQuery getFirstObject:&error] objectForKey:@"imageFile"];
    [[NSUserDefaults standardUserDefaults] setObject:[backgroundImage getData] forKey:@"backgroundImage"];
    self.backgroundImageView.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundImage"]];
    PFQuery *avatarQuery = [PFQuery queryWithClassName:@"Avatar"];
    [avatarQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    PFFile *avatarImage = [[avatarQuery getFirstObject:&error] objectForKey:@"imageFile"];
    [[NSUserDefaults standardUserDefaults] setObject:[avatarImage getData] forKey:@"plusImage"];
    self.avatarImageView.image = [UIImage roundedImageWithImage:[UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"plusImage"]]];
    
    if(error){
        [self loadingError:error];
    }else{
        HUD.labelText = @"Updating user";
        [self refreshUserData];
    }
}
- (void)refreshUserData{
    
    [[PFUser currentUser] refresh];
    
    HUD.labelText = @"Updating transactions";
    
    [self reloadBalances];
    
    HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"Finished";
    
    sleep(2);
    [HUD hide:YES];
}

- (void)reloadBalances{
    [self.balanceLabel countFrom:[[[NSUserDefaults standardUserDefaults] objectForKey:@"currentBalance"] floatValue] to:[[[[[PFUser currentUser] objectForKey:@"Balances"] fetchIfNeeded] objectForKey:@"CashBalance"] floatValue] withDuration:2.];
    [self.XPLabel countFrom:[[[NSUserDefaults standardUserDefaults] objectForKey:@"currentXP"] floatValue] to:[[[[[PFUser currentUser] objectForKey:@"Balances"] fetchIfNeeded] objectForKey:@"ExperiencePoints"] floatValue] withDuration:2.];
    [[NSUserDefaults standardUserDefaults] setObject:[[[PFUser currentUser] objectForKey:@"Balances"] objectForKey:@"ExperiencePoints"] forKey:@"currentXP"];
    [[NSUserDefaults standardUserDefaults] setObject:[[[PFUser currentUser] objectForKey:@"Balances"] objectForKey:@"CashBalance"] forKey:@"currentBalance"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadTransactions"
                                                        object:nil
                                                      userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadBadges"
                                                        object:nil
                                                      userInfo:nil];
}
- (void)loadingError:(NSError *)error{
    NSString *errorString = [error localizedDescription];
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:errorString
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
    [errorAlert release];
}
@end
