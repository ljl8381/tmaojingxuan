//
//  FGCell.h
//  FreeGames
//
//  Created by ljl on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FGCell : UITableViewCell 
{
	UIView              *_view;
	BOOL                _callSuperSetEditing;
	UITableView         *_selfTableView;
}

@property(nonatomic, readonly) UIView *view;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier viewStyle:(FGCellViewStyle)aViewStyle;
- (void)redisplay;
- (void)setData:(NSObject *)aData;
- (void)setCallSuperSetEditing:(BOOL)callSuperSetEditing;
- (void)setTableView:(UITableView *)tableView;
@end

