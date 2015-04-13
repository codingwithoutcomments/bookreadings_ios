//
//  MasterViewController.h
//  bookreadings_ios
//
//  Created by Reath, Chris X. -ND on 3/18/15.
//  Copyright (c) 2015 Reath, Chris X. -ND. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reading.h"
#import "SlideNavigationController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <SlideNavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray * readings;
@property (strong, nonatomic) DetailViewController *detailViewController;

@end

