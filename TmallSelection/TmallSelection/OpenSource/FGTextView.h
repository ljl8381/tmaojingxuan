//
//  FGTextView.h
//  FreeGames
//
//  Created by ljl on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGTextView : UITextView {
    
    NSString *placeholder;    
    UIColor *placeholderColor;
    NSString *backgroundImageString;
    
@private
    
    UILabel *placeHolderLabel;
    
}


@property(nonatomic, retain) UILabel *placeHolderLabel;
@property(nonatomic, retain) NSString *placeholder;
@property(nonatomic, retain) UIColor *placeholderColor;
@property(nonatomic, retain) NSString *backgroundImageString;

-(void)textChanged:(NSNotification*)notification;

@end
