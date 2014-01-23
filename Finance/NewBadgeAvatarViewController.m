//
//  NewBadgeAvatarViewController.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/30/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "NewBadgeAvatarViewController.h"
#import <Parse/Parse.h>
#import "RecipientCell.h"
@interface NewBadgeAvatarViewController ()
@property (retain, nonatomic) NSArray *users;
@property (retain, nonatomic) NSMutableArray *selectedUsers;
@end

@implementation NewBadgeAvatarViewController
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
    self.selectedUsers = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    PFQuery *userQuery = [PFUser query];
    [userQuery orderByAscending: @"username"];
    NSError *error = nil;
    self.users = [userQuery findObjects:&error];
    if(error){
        NSString *errorString = [error localizedDescription];
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:errorString
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
    }
    return [self.users count];
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecipientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recipientCell" forIndexPath:indexPath];
    cell.emailLabel.text = [[self.users objectAtIndex:indexPath.row] objectForKey:@"username"];
    cell.avatarNameLabel.text = [[self.users objectAtIndex:indexPath.row] objectForKey:@"AvatarName"];
    if([self.selectedUsers containsObject:[self.users objectAtIndex:indexPath.row]]){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.nextButton setEnabled:YES];
    [self.selectedUsers addObject:[self.users objectAtIndex:indexPath.row]];
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.selectedUsers removeObject:[self.users objectAtIndex:indexPath.row]];
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
}


- (IBAction)nextButtonPressed:(id)sender {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Sending";
    [HUD showWhileExecuting:@selector(uploadData) onTarget:self withObject:nil animated:YES];
}
- (void)uploadData{
    NSError *error = nil;
    PFFile *badgeImage = [PFFile fileWithName:[NSString stringWithFormat:@"%@.png",[[NSUserDefaults standardUserDefaults] objectForKey:@"BadgeName"]] data:[[NSUserDefaults standardUserDefaults] objectForKey:@"badgeImage"]];
    [badgeImage save:&error];
    PFObject *newBadge = [[PFObject alloc] initWithClassName:@"Badges"];
    [newBadge setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"BadgeName"] forKey:@"BadgeName"];
    [newBadge setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"BadgeDescription"] forKey:@"BadgeDescription"];
    [newBadge setObject:@NO forKey:@"Everyone"];
    [newBadge setObject:self.selectedUsers forKey:@"Recipients"];
    [newBadge setObject:badgeImage forKey:@"imageFile"];
    [newBadge save:&error];
    if(error){
        NSString *errorString = [error localizedDescription];
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:errorString
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
    }else{
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"Finished";
        sleep(2);
        [HUD hide:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadBadges"
                                                            object:nil
                                                          userInfo:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
