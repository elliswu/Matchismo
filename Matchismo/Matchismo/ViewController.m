//
//  ViewController.m
//  Matchismo
//
//  Created by WuEllis on 2015/8/26.
//  Copyright (c) 2015年 WuEllis. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface ViewController ()
@property (strong,nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation ViewController

-(CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]  usingDeck:[self createDeck]];
    }
    return _game;
}


-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    int chooseButtonIndex = [self.cardButtons indexOfObjectIdenticalTo:sender];
    [self.game chooseCardAtIndex:chooseButtonIndex];
    [self UpdateUI];
    
}

-(void)UpdateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text =[NSString stringWithFormat:@"Score: %ld",(long)self.game.score];
}

-(NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}
-(UIImage *)backgroundForCard:(Card *)card
{
    return  [UIImage imageNamed:card.isChosen ? @"cardfront":@"cardback"];
}

@end
