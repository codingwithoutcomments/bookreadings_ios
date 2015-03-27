//
//  ReadingTableViewCell.h
//  bookreadings_ios
//
//  Created by Reath, Chris X. -ND on 3/24/15.
//  Copyright (c) 2015 Reath, Chris X. -ND. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadingTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView* coverImage;
@property (nonatomic, weak) IBOutlet UILabel * title;

@end
