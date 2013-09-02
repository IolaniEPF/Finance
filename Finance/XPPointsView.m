//
//  XPPointsView.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/27/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "XPPointsView.h"
#import <Parse/Parse.h>
#import "XPPointsViewCell.h"
@interface XPPointsView ()
@property (retain, nonatomic) NSArray *transactionArray;
@end

@implementation XPPointsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    PFQuery *recipientQuery = [PFQuery queryWithClassName:@"XPTransactions"];
    [recipientQuery whereKey:@"Recipient" equalTo:[PFUser currentUser]];
    [recipientQuery orderByDescending:@"createdAt"];
    
    NSError *error = nil;
    self.transactionArray = [recipientQuery findObjects:&error];
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
    return [self.transactionArray count];
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XPPointsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPCell" forIndexPath:indexPath];
    NSNumber *amountNum = [[self.transactionArray objectAtIndex:indexPath.row] objectForKey:@"Amount"];
    if([amountNum integerValue] < 0){
        cell.amountLabel.textColor = [UIColor redColor];
    }else{
        cell.amountLabel.textColor = [UIColor greenColor];
    }
    cell.amountLabel.text = [NSString stringWithFormat:@"%@ pts",[[self.transactionArray objectAtIndex:indexPath.row] objectForKey:@"Amount"]];
    cell.bigLabel.text = [[self.transactionArray objectAtIndex:indexPath.row] objectForKey:@"Description"];
    return cell;
}

- (void)dealloc {
    [super dealloc];
}
@end
