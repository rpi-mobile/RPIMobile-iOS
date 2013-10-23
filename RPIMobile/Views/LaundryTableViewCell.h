//
//  LaundryTableViewCell.h
//  RPIMobile
//
//  Created by Stephen Silber on 10/3/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaundryTableViewCell : UITableViewCell {
    UILabel *titleLbl;
    UILabel *washInUseLbl;
    UILabel *washOpenLbl;
    UILabel *dryInUseLbl;
    UILabel *dryOpenLbl;
}

@property (strong) IBOutlet UILabel *titleLbl;
@property (strong) IBOutlet UILabel *washInUseLbl;
@property (strong) IBOutlet UILabel *washOpenLbl;
@property (strong) IBOutlet UILabel *dryInUseLbl;
@property (strong) IBOutlet UILabel *dryOpenLbl;

@end
