//
//  TransactionsView.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/27/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "TransactionsView.h"
#import <Parse/Parse.h>
#import "TransactionViewCell.h"
@interface TransactionsView ()
@property (retain, nonatomic) NSArray *transactionArray;
@end
@implementation TransactionsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //PFQuery *nonStudent = [PFUser query];
    //[nonStudent whereKey:@"isStudent" equalTo:@NO];
    
    
    //Define user object representations for Iolani Bank and Mom and Dad accounts
    
    PFQuery *senderQuery = [PFQuery queryWithClassName:@"Transactions"];
    [senderQuery whereKey:@"Sender" equalTo:[PFUser currentUser]];
    PFQuery *recipientQuery = [PFQuery queryWithClassName:@"Transactions"];
    [recipientQuery whereKey:@"Recipient" equalTo:[PFUser currentUser]];
    
    PFQuery *allTrans = [PFQuery orQueryWithSubqueries:nil];
    
    
    if ([[[PFUser currentUser] objectForKey: @"Superuser"] isEqual: @YES]) {
        
        //query for transactions made to/from Iolani Bank and Mom and Dad accounts
        PFQuery *nonStudentQuery = [PFUser query];
        [nonStudentQuery whereKey:@"isStudent" equalTo:@NO];
        NSArray *nonStudents = [nonStudentQuery findObjects];
        //fetch all nonstudent objects
        
        for (NSUInteger x = 0; x < [nonStudents count]; x++) {
            //query for transactions
            if ([PFUser currentUser] != nonStudents[x]) {
            //ensure current user isn't part of nonstudent query to prevent double listing
                PFQuery *query1 = [PFQuery queryWithClassName:@"Transactions"];
                [query1 whereKey:@"Sender" equalTo:[nonStudents objectAtIndex:x]];
                PFQuery *query2 = [PFQuery queryWithClassName:@"Transactions"];
                [query2 whereKey:@"Recipient" equalTo:[nonStudents objectAtIndex:x]];
                //allTrans = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:allTrans,query1,query2, nil]];
                //combine all into array then insert as subquery, otherwise will throw array in array-type exception
            }
        }
        
    }
    else    {
    
        allTrans = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:senderQuery,recipientQuery, nil]];
    }
    //PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:senderQuery,recipientQuery, nil]];
    //[query orderByDescending:@"createdAt"];
    
    [allTrans orderByDescending:@"createdAt"];
    
    NSError *error = nil;
    self.transactionArray = [allTrans /*query*/ findObjects:&error];
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
    return ([self.transactionArray count]+1);
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row<[self.transactionArray count]){
        TransactionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transactionCell" forIndexPath:indexPath];
        NSNumber *amountNum = [[self.transactionArray objectAtIndex: indexPath.row] objectForKey:@"Amount"];
        NSString *amountString;
        if([[[self.transactionArray objectAtIndex: indexPath.row] objectForKey:@"SenderString"] isEqualToString:[[PFUser currentUser] objectForKey:@"AvatarName"]]){
            amountString = [NSString stringWithFormat:@"- $%@",amountNum];
            cell.amountLabel.textColor = [UIColor redColor];
            cell.bigLabel.text = [NSString stringWithFormat:@"%@ - to %@",[[self.transactionArray objectAtIndex: indexPath.row] objectForKey:@"Description"],[[self.transactionArray objectAtIndex: indexPath.row] objectForKey:@"RecipientString"]];
        }
        else{
            amountString = [NSString stringWithFormat:@"+ $%@",amountNum];
            cell.amountLabel.textColor = [UIColor greenColor];
            cell.bigLabel.text = [NSString stringWithFormat:@"%@ - from %@",[[self.transactionArray objectAtIndex: indexPath.row] objectForKey:@"Description"],[[self.transactionArray objectAtIndex: indexPath.row] objectForKey:@"SenderString"]];
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"MM-dd-yyyy  h:mm a"];
        PFObject *transactionObject = [self.transactionArray objectAtIndex: indexPath.row];
        cell.littleLabel.text = [formatter stringFromDate:transactionObject.createdAt];
        cell.amountLabel.text = amountString;
        return cell;
    }else{
        TransactionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transactionCell" forIndexPath:indexPath];
        cell.bigLabel.text = @"Money to start off - from Mom and Dad";
        cell.littleLabel.text = @"Beginning of EPF";
        cell.amountLabel.textColor = [UIColor greenColor];
        cell.amountLabel.text = @"+ 35000";
        return cell;
    }
}

@end
