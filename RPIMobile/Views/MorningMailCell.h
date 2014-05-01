//
//  MorningMailCell.h
//  RPIMobile
//
//  Created by Stephen Silber on 11/13/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MorningMailCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *mmTitle;
@property (nonatomic, strong) IBOutlet UIImageView *mmImage;
@property (nonatomic, strong) IBOutlet UILabel *mmDescription;

@property (nonatomic) float requiredCellHeight;

@end
