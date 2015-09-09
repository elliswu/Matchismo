//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by WuEllis on 2015/8/28.
//  Copyright (c) 2015年 WuEllis. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic,readwrite) NSInteger score;
@property (nonatomic,strong) NSMutableArray *cards; //of Cards
@property (nonatomic, strong) NSMutableArray *choosingCards;
@property (nonatomic,readwrite) NSString *descriptions;
@property (nonatomic,readwrite) NSInteger cardMode;

@end

@implementation CardMatchingGame

-(NSMutableArray *)cards
{
    if(!_cards)_cards = [[NSMutableArray alloc] init];
    return _cards ;
}

-(NSString *)description
{
    if(!_descriptions)_descriptions = [[NSString alloc] init];
    return _descriptions;
}

-(instancetype)initWithCardCount:(NSInteger)count usingDeck:(Deck *)deck
{
    self = [super init]; //super's designated initializer
    if(self)
    {
        for (int i =0; i<count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

-(instancetype)initWithCardCount:(NSInteger)count usingDeck:(Deck *)deck chooseCardMode:(NSInteger)cardMode
{
    self = [super init]; //super's designated initializer
    if(self)
    {
        for (int i =0; i<count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    self.cardMode = cardMode ;
    self.choosingCards = [[NSMutableArray alloc] init];
    return self;
}

static const int MISMATCH_PENALTY = 2 ;
static const int MATCH_BONUS = 4 ;
static const int COST_TO_CHOOSE = 1 ;

-(void)chooseCardAtIndex:(NSUInteger)index
{
    if (self.cardMode == 2) {
        [self twoCardMode:index];
    } else if (self.cardMode == 3){
        [self threeCardMode:index];
    }
}

-(void) twoCardMode:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSString *msg = @"";
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            self.descriptions = msg;
        }else{
            self.score -=COST_TO_CHOOSE;
            msg = [msg stringByAppendingString:[NSString stringWithFormat:@"%@ cost %d",card.contents,COST_TO_CHOOSE]];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        int addscore = matchScore*MATCH_BONUS ;
                        self.score+=addscore;
                        otherCard.matched = YES;
                        card.matched = YES;
                        msg = [msg stringByAppendingString:[NSString stringWithFormat:@",Matched %@ ,%@ for %d points!",card.contents,otherCard.contents,addscore]];
                    }else{
                        self.score-=MISMATCH_PENALTY;
                        otherCard.chosen = NO ;
                        msg = [msg stringByAppendingString:[NSString stringWithFormat:@",%@ ,%@ not Match ! penalty %d points!",card.contents,otherCard.contents,MISMATCH_PENALTY ]];
                    }
                    break;
                }
            }
            self.descriptions = msg;
            NSLog(@"%@",msg);
            card.chosen = YES;
        }
    }
}

-(void) threeCardMode:(NSUInteger)index
{
    NSString *msg = @"";
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            [self.choosingCards removeObject:card];
        } else {
            msg = [msg stringByAppendingString:[NSString stringWithFormat:@"%@ cost %d",card.contents,COST_TO_CHOOSE]];
            self.score -=COST_TO_CHOOSE;
            card.chosen = YES;
            if (![self.choosingCards containsObject:card]) {
                if ([self.choosingCards count]>=2) {
                    int matchScore = [card match:self.choosingCards];
                    if (matchScore) {
                        msg = [msg stringByAppendingString:@",Match! success"];
                        int addscore = matchScore*MATCH_BONUS ;
                        self.score+=addscore;
                        for (Card *choosingCard in self.choosingCards) {
                            choosingCard.matched = YES;
                            msg = [msg stringByAppendingString:[NSString stringWithFormat:@"%@",choosingCard.contents]];
                        }
                        msg = [msg stringByAppendingString:[NSString stringWithFormat:@"%@",card.contents]];
                        card.matched = YES;
                        msg = [msg stringByAppendingString:[NSString stringWithFormat:@", get %d score;",matchScore]];
                        self.descriptions = msg;
                    } else {
                        msg = [msg stringByAppendingString:@",Not match! for"];
                        card.chosen = NO;
                        self.score-=MISMATCH_PENALTY;
                        for (Card *choosingCard in self.choosingCards) {
                            choosingCard.chosen = NO;
                            msg = [msg stringByAppendingString:[NSString stringWithFormat:@" %@ ",choosingCard.contents]];
                        }
                        msg = [msg stringByAppendingString:[NSString stringWithFormat:@" %@ ",card.contents]];
                        msg = [msg stringByAppendingString:[NSString stringWithFormat:@" penalty %d points ",MISMATCH_PENALTY]];
                    }
                    [self.choosingCards removeAllObjects];
                } else {
                    if (![self.choosingCards containsObject:card]) {
                        [self.choosingCards addObject:card];
                    }
                }
                self.descriptions = msg;
                NSLog(@"%@",msg);
            }
        }
    }
}

-(Card *) cardAtIndex:(NSUInteger *)index
{
    return (index < [self.cards count]) ? self.cards[(NSInteger)index]:nil;
}

-(void) reDealGame
{
    self.score = 0;
}
@end
