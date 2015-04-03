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
#import <AudioToolbox/AudioToolbox.h>
#import "Reading.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Reading * reading;
@property (weak, nonatomic) IBOutlet UILabel * duration;
@property (weak, nonatomic) IBOutlet UILabel * progress;
@property (weak, nonatomic) IBOutlet UIButton * playPauseButton;
@property (nonatomic, strong) STKAudioPlayer *audioPlayer;
@property BOOL readingPlaying;


- (IBAction)playPausePressed:(id)sender;
- (void)setDetailItem:(Reading*)newReading;

@end

