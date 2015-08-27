//
//  Deck.h
//  Matchismo
//
//  Created by WuEllis on 2015/8/26.
//  Copyright (c) 2015年 WuEllis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

-(void)addCard:(Card *)card atTop:(BOOL)atTop;
-(void)addCard:(Card *)card;

-(Card *)drawRandomCard;

@end
