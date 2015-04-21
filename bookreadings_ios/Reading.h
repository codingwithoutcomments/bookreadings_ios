//
//  Reading.h
//  bookreadings_ios
//
//  Created by Reath, Chris X. -ND on 3/24/15.
//  Copyright (c) 2015 Reath, Chris X. -ND. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reading : NSObject

@property (nonatomic, strong) NSString * audioFilename;
@property (nonatomic, strong) NSString * audioKey;
@property (nonatomic, strong) NSString * coverImageURL;
@property (nonatomic, strong) NSDate * created;
@property (nonatomic, strong) NSString * createdByFullID;
@property (nonatomic, strong) NSString * createdByID;
@property (nonatomic, strong) NSString * createdByName;
@property (nonatomic, strong) NSString * information;
@property (nonatomic, strong) NSString * purchaseLink;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSString * title;
@property NSInteger commentCount;
@property NSInteger playedCount;
@property NSInteger likeCount;
@property (nonatomic, strong) NSString * key;

-(id)initWithDictionary:(NSDictionary*)reading key:(NSString*)key;
-(void)setCounts:(NSDictionary*)countsDictionary;

@end
