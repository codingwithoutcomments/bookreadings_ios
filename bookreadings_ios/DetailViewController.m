//
//  DetailViewController.m
//  bookreadings_ios
//
//  Created by Reath, Chris X. -ND on 3/18/15.
//  Copyright (c) 2015 Reath, Chris X. -ND. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "AZCenterLabelButton.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize duration, progress, playPauseButton, slider, draggingProgressSlider, coverImage, widthConstraint;

static NSString* const CLOUD_FRONT_URL_AUDIO = @"https://d3e04w4j2r2rn6.cloudfront.net/";
static NSString* const CLOUD_FRONT_URL_IMAGE = @"https://d1onveq9178bu8.cloudfront.net";
static int const HEIGHT_OF_IMAGE = 200;

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
    
    if(_reading) {
        
        CGFloat scale = [UIScreen mainScreen].scale;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat width = screenRect.size.width;
        
        CGFloat retinaWidth = width * scale;
        NSString * screenWidth = [NSString stringWithFormat: @"%d",(int)retinaWidth];
        CGFloat height = HEIGHT_OF_IMAGE;
        CGFloat retinaHeight = height * scale;
        NSString * cellHeight = [NSString stringWithFormat: @"%d",(int)retinaHeight];
       
        //modifying the width constraint on the fly
        //http://stackoverflow.com/questions/23655096/change-frame-programmatically-with-auto-layout
        //
        widthConstraint.constant = width;
        
        NSString * coverImageString = [NSString stringWithFormat:@"%@%@/convert?w=%@&h=%@&fit=crop", CLOUD_FRONT_URL_IMAGE, _reading.coverImageURL, screenWidth, cellHeight];

        //set the background image
        coverImage.contentMode = UIViewContentModeTopLeft;
        [coverImage sd_setImageWithURL:[NSURL URLWithString:coverImageString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                          CGFloat scale = [UIScreen mainScreen].scale;
            
                          if (scale > 1.0) {
                              image = [UIImage imageWithCGImage:[image CGImage]
                                                          scale:[UIScreen mainScreen].scale
                                                    orientation:UIImageOrientationUp];
                              
                              coverImage.image = image;
                          }
        }];
        
        //gradient over UIImage
        [self gradientOverCoverImage];
        [self populateCommentBubble];
        
    }
}

-(void)gradientOverCoverImage {
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = CGRectMake(0, 0, self.coverImage.bounds.size.width, 7);
    gradient.colors = @[(id)[[UIColor colorWithWhite:0 alpha:0.2] CGColor],
                        (id)[[UIColor colorWithWhite:0 alpha:0.15] CGColor],
                        (id)[[UIColor colorWithWhite:0 alpha:0.1] CGColor],
                        (id)[[UIColor colorWithWhite:0 alpha:0.05] CGColor],
                        (id)[[UIColor clearColor] CGColor]];
    [self.coverImage.layer insertSublayer:gradient atIndex:0];
    
}

-(void)populateCommentBubble {
    
    //comment bubble and count
    CGRect rect = CGRectMake(0, 0, 30, 30);
    UIButton *button  = [[UIButton alloc] initWithFrame:rect];
    [button setImage:[UIImage imageNamed:@"SpeachBubble.png"] forState:UIControlStateNormal];
    button.titleLabel.textColor=[UIColor whiteColor];
    
    NSInteger commentCount = [self.reading commentCount];
    
    button.titleLabel.font = [UIFont systemFontOfSize:9];;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    if(commentCount >= 100 && scale == 2.0) {
        button.titleLabel.font = [UIFont systemFontOfSize:6];
    }
    
    if(commentCount >= 100 && scale == 3.0) {
        button.titleLabel.font = [UIFont systemFontOfSize:7];
    }
   
    float offset = -25;
    float titleOffset = -5.0;
    if(commentCount < 10 && scale == 3.0) {
        offset = -26;
        titleOffset = -10.0;
    } else if(commentCount >= 10 && commentCount < 100 && scale == 3.0) {
        offset = -27;
        titleOffset = -15.0;
    } else if(commentCount >= 100 && scale == 3.0) {
        offset = -29;
        titleOffset = -15.0;
    } else if(commentCount >= 10 && scale == 2.0) {
        offset = -30;
        titleOffset = -5.0;
    } else if (commentCount >= 100 && scale == 2.0){
        offset = -40;
        titleOffset = -5.0;
    }
    
    button.imageEdgeInsets = UIEdgeInsetsMake(5,
                                            0.0f,
                                            0.0f,
                                            offset);
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
                                            titleOffset,
                                            0.0f,
                                            0.0f);
    
    
    [button setTitle:[@(commentCount) stringValue] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem= rightBarButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
