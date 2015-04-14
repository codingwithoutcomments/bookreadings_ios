//
//  DetailViewController.m
//  bookreadings_ios
//
//  Created by Reath, Chris X. -ND on 3/18/15.
//  Copyright (c) 2015 Reath, Chris X. -ND. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize duration, progress, playPauseButton, slider, draggingProgressSlider;

static NSString* const CLOUD_FRONT_URL_AUDIO = @"https://d3e04w4j2r2rn6.cloudfront.net/";

#pragma mark - Managing the detail item

- (void)setDetailItem:(Reading*)newReading {
    if (_reading != newReading) {
        _reading = newReading;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {

    if (self.reading) {
        
        // Update the user interface for the detail item.
        NSString * audioFileURLString = [NSString stringWithFormat:@"%@%@", CLOUD_FRONT_URL_AUDIO, self.reading.audioKey];
        self.audioPlayer = [[STKAudioPlayer alloc] init];
        [self.audioPlayer play:audioFileURLString];
        
        self.readingPlaying = TRUE;
       
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(setProgressAndDuration)
                                       userInfo:nil
                                        repeats:YES];
        
    }
}

- (IBAction)editingDidBegin:(id)sender {
    
    draggingProgressSlider = TRUE;
    
    self.progress.text = [self timeFormatted:self.slider.value];
    
    
}
- (IBAction)editingDidEnd:(id)sender {
    
    draggingProgressSlider = FALSE;
    
    float valueToSeekTo = self.slider.value;
    [self.audioPlayer seekToTime:valueToSeekTo];
    
}

-(void)setProgressAndDuration {
    
    if(!draggingProgressSlider) {
    
        //set the duraiton and progress
        self.duration.text = [self timeFormatted:(int)[self.audioPlayer duration]];
        self.progress.text = [self timeFormatted:(int)[self.audioPlayer progress]];
        
        self.slider.maximumValue = [self.audioPlayer duration];
        self.slider.value = [self.audioPlayer progress];
    }
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60);
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

- (IBAction)playPausePressed:(id)sender {
    
    if(self.readingPlaying) {
        [playPauseButton setImage:[UIImage imageNamed:@"playbutton.png"] forState:UIControlStateNormal];
        [self.audioPlayer pause];
        self.readingPlaying = FALSE;
    } else {
        [playPauseButton setImage:[UIImage imageNamed:@"Stop.png"] forState:UIControlStateNormal];
        [self.audioPlayer resume];
        self.readingPlaying = TRUE;
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];    // Call the super class implementation.
    // Usually calling super class implementation is done before self class implementation, but it's up to your application.
    
    [self.audioPlayer stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *sliderThumb = [UIImage imageNamed:@"uislider-thumb.png"];
    [slider setThumbImage:sliderThumb forState:UIControlStateNormal];
    [slider setThumbImage:sliderThumb forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
