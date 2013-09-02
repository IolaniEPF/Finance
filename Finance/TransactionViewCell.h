//
//  TransactionViewCell.h
//  Finance
//
//  Created by Blake Tsuzaki on 8/29/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *bigLabel;
@property (retain, nonatomic) IBOutlet UILabel *littleLabel;
@property (retain, nonatomic) IBOutlet UILabel *amountLabel;

@end
