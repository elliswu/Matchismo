//
//  PlayingCard.h
//  Matchismo
//
//  Created by WuEllis on 2015/8/26.
//  Copyright (c) 2015年 WuEllis. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong,nonatomic) NSString *suit;
@property (nonatomic)NSUInteger rank;
+(NSArray *) validSuits;
+(NSUInteger *) maxRank;

@end
