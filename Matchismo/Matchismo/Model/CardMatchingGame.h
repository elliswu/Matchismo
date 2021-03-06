//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by WuEllis on 2015/8/28.
//  Copyright (c) 2015年 WuEllis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

//designated initializer
-(instancetype)initWithCardCount:(NSInteger)count
                       usingDeck:(Deck *)deck;

-(instancetype)initWithCardCount:(NSInteger)count
                       usingDeck:(Deck *)deck
                  chooseCardMode:(NSInteger *)cardMode;

-(void)chooseCardAtIndex:(NSUInteger)index;

-(Card *) cardAtIndex:(NSUInteger *)index;

-(void) reDealGame;

@property (nonatomic,readonly) NSInteger score ;
@property (nonatomic,readonly) NSString *descriptions;
@end
