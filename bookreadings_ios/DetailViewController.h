//
//  DetailViewController.h
//  bookreadings_ios
//
//  Created by Reath, Chris X. -ND on 3/18/15.
//  Copyright (c) 2015 Reath, Chris X. -ND. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <StreamingKit/STKAudioPlayer.h>
#import "Reading.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Reading * reading;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, strong) STKAudioPlayer *audioPlayer;


- (void)setDetailItem:(Reading*)newReading;

@end

