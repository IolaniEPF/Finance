//
//  XPTransactionRecipientViewController.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/30/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "XPTransactionRecipientViewController.h"
#import <Parse/Parse.h>
#import "RecipientCell.h"
@interface XPTransactionRecipientViewController ()
@property (retain, nonatomic) NSArray *users;
@property (retain, nonatomic) NSMutableArray *selectedUsers;
@end

@implementation XPTransactionRecipientViewController
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
    [self.avatarTable setMultipleTouchEnabled:YES];
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

- (void)dealloc {
    [_avatarTable release];
    [_nextButton release];
    [super dealloc];
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
    for (int i = 0; i< [self.selectedUsers count]; i++) {
        PFObject *newTransaction = [[PFObject alloc] initWithClassName:@"XPTransactions"];
        [newTransaction setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"XPAmount"] forKey:@"Amount"];
        [newTransaction setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"XPDescription"] forKey:@"Description"];
        //PFQuery *recipientBalanceQuery = [PFQuery queryWithClassName:@"Balances"];
        //[recipientBalanceQuery whereKey:@"AvatarName" equalTo:[[self.selectedUsers objectAtIndex:i] objectForKey:@"AvatarName"]];
        //PFObject *recipientBalance = [recipientBalanceQuery getFirstObject];
        //NSNumber *transactionAmount = [[NSUserDefaults standardUserDefaults]objectForKey:@"XPAmount"];
        [newTransaction setObject:[self.selectedUsers objectAtIndex:i] forKey:@"Recipient"];
        [newTransaction setObject:[PFUser currentUser] forKey:@"Sender"];
        [newTransaction setObject:[[self.selectedUsers objectAtIndex:i] objectForKey:@"AvatarName"] forKey:@"RecipientString"];
        //[recipientBalance setObject:[NSNumber numberWithFloat:([[recipientBalance objectForKey:@"ExperiencePoints"] floatValue]+[transactionAmount floatValue])] forKey:@"ExperiencePoints"];
        [newTransaction save:&error];
        //[PFObject saveAll:[NSArray arrayWithObjects:newTransaction,recipientBalance, nil] error:&error];
    }
    
    if(error){
        [HUD hide:YES];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadTransactions"
                                                            object:nil
                                                          userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadBalances"
                                                            object:nil
                                                          userInfo:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
