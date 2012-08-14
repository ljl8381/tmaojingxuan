//
//  ItemButton.h
//  TmallSelection
//
//  Created by ljl on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol itemButtonClickDelegate;

@interface ItemButton : UIView
{
    NSString    *_title;
    NSString    *_backgroundImage;
    UIButton    *_backgroundButton;
    NSInteger   _typeID;
    UILabel     *_titleLabel;
    id<itemButtonClickDelegate> btnDelegate;
}
-(void)setInfoWithDic:(NSDictionary *)infoDic;
-(CGSize)getSizeWithText:(NSString *) text withFont:(UIFont *)font;
@property (nonatomic,assign) id<itemButtonClickDelegate> btnDelegate;
@property (nonatomic,copy) NSString   *title; 
@end

@protocol itemButtonClickDelegate <NSObject>

@optional
-(void)itemButtonClicked:(id)sender;
@end