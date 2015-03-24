//
//  MasterViewController.m
//  bookreadings_ios
//
//  Created by Reath, Chris X. -ND on 3/18/15.
//  Copyright (c) 2015 Reath, Chris X. -ND. All rights reserved.
//

#import <Firebase/Firebase.h>
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ReadingTableViewCell.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.readings = [[NSMutableArray alloc] init];
    
    Firebase * myRootRef = [[Firebase alloc] initWithUrl:@"https://bookreadings.firebaseio.com/readingsByFeatured"];
    
    [myRootRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        NSString * reading_id = snapshot.value[@"reading_id"];
        [self lookupAndAddSingleReading:reading_id];
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

-(void)lookupAndAddSingleReading:(NSString *)readingID {
    
    NSString * baseReadingString = @"https://bookreadings.firebaseio.com/readings";
    NSString * readingRefString = [NSString stringWithFormat:@"%@/%@", baseReadingString, readingID];
    Firebase * readingRef = [[Firebase alloc] initWithUrl:readingRefString];
    [readingRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        //create a new reading object and add to readings
        Reading * reading = [[Reading alloc] initWithDictionary:snapshot.value];
        [self.readings addObject:reading];
        [self.tableView reloadData];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.readings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReadingTableViewCell *cell = (ReadingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Reading * reading = self.readings[indexPath.row];
    NSURL * url = [NSURL URLWithString:@"https://d1onveq9178bu8.cloudfront.net/api/file/25GB4DQATQaRj1pYYDQA/convert?w=623&h=623&fit=crop&align=center"];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    cell.coverImage.image = [UIImage imageWithData:imageData];
    //cell.textLabel.text = reading.title;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
