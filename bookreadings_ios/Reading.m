//
//  Reading.m
//  bookreadings_ios
//
//  Created by Reath, Chris X. -ND on 3/24/15.
//  Copyright (c) 2015 Reath, Chris X. -ND. All rights reserved.
//

#import "Reading.h"

@implementation Reading

@synthesize audioFilename, audioKey, coverImageURL, created, createdByFullID, createdByID, createdByName, information, purchaseLink, tags, title, commentCount, playedCount, likeCount, commentKeys;

-(id)initWithDictionary:(NSDictionary*)reading key:(NSString*)key {
    
    if ( self = [super init] ) {
        
        self.key = key;
        
        if([reading objectForKey:@"audio_filename"]){
            self.audioFilename = [reading objectForKey:@"audio_filename"];
        }
        
        if([reading objectForKey:@"audio_key"]){
            self.audioKey = [reading objectForKey:@"audio_key"];
        }
        
        if([reading objectForKey:@"cover_image_url"]) {
            self.coverImageURL = [reading objectForKey:@"cover_image_url"];
        }
        
        if([reading objectForKey:@"created"]) {
            double unixTimeStamp = [[reading objectForKey:@"created"] doubleValue];
            NSTimeInterval _interval = unixTimeStamp;
            self.created = [NSDate dateWithTimeIntervalSince1970:_interval];
        }
        
        if([reading objectForKey:@"created_by"]) {
            self.createdByFullID = [reading objectForKey:@"created_by"];
        }
        
        if([reading objectForKey:@"created_by_id"]) {
            self.createdByID = [reading objectForKey:@"created_by_id"];
        }
        
        if([reading objectForKey:@"created_by_name"]) {
            self.createdByName = [reading objectForKey:@"created_by_name"];
        }
        
        if([reading objectForKey:@"description"]) {
            self.information = [reading objectForKey:@"description"];
        }
        
        if([reading objectForKey:@"purchaseLink"]) {
            self.purchaseLink = [reading objectForKey:@"purchaseLink"];
        }
        
        if([reading objectForKey:@"tags"]) {
            self.tags = [reading objectForKey:@"tags"];
        }
        
        if([reading objectForKey:@"title"]) {
            self.title = [reading objectForKey:@"title"];
        }
        
        if([reading objectForKey:@"comments"]) {
            
            commentKeys = [[NSMutableArray alloc] init];
            
            NSMutableDictionary * comment_location_dictionary = [reading objectForKey:@"comments"];
            for(id key in comment_location_dictionary) {
                [commentKeys addObject:key];
            }
            
        }
        
        return self;
        
    } else {
        return nil;
    }
}

-(void)setCounts:(NSDictionary*)countsDictionary {
    
    if([countsDictionary objectForKey:@"comment_count"]) {
        self.commentCount = [[countsDictionary objectForKey:@"comment_count"] integerValue];
    }
    
    if([countsDictionary objectForKey:@"like_count"]) {
        self.likeCount = [[countsDictionary objectForKey:@"like_count"] integerValue];
    }
    
    if([countsDictionary objectForKey:@"play_count"]) {
        self.playedCount = [[countsDictionary objectForKey:@"play_count"] integerValue];
    }
    
}


@end
