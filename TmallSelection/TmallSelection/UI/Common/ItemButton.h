//
//  ItemButton.h
//  TmallSelection
//
//  Created by ljl on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemButton : UIView
{
    NSString    *_title;
    NSString    *_backgroundImage;
    UIButton    *_backgroundButton;
    NSInteger   _typeID;
    UILabel     *_titleLabel;

}

@end
