//
//  FGCell.m
//  FreeGames
//
//  Created by ljl on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FGCell.h"

@implementation FGCell

const unsigned int kLeftCapWidth = 10;
const unsigned int kTopCapHeight = 15;

@synthesize view = _view;

#pragma mark -
#pragma mark Override base functions.
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier viewStyle:(FGCellViewStyle)viewStyle
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
	{
		_callSuperSetEditing = YES;
		CGRect frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		
		// Stretchable image view with left&top cap with/height.
		UIImage* image = [[UIImage imageNamed:NSLocalizedString(@"CellSelectedBackground", nil)] stretchableImageWithLeftCapWidth:kLeftCapWidth topCapHeight:kTopCapHeight];
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
		imageView.image = image;
		self.selectedBackgroundView = imageView;
		[imageView release];
        // Create a view and add it as a subview of self's contentView.
		switch (viewStyle) 
		{

//			case FGCellViewStyleSearch:
//				_view = [[FGSearchCellView alloc] initWithFrame:frame];
//				break;
//			case FGCellViewStyleSearchHistory:
//				_view = [[FGSearchHistoryCellView alloc] initWithFrame:frame];
//				break;
//            case FGCellViewStyleCategory:
//				_view = [[FGCategoryCell alloc] initWithFrame:frame];
//				break;   
            default:
				_view = [[UIView alloc] initWithFrame:frame];
				break;
		}
		
		_view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:_view];
    }
    return self;
}

- (void)dealloc {
	[_view release];
    [super dealloc];
}

#pragma mark -
#pragma mark Public functions.
- (void)redisplay {
	[_view setNeedsDisplay];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
	if (_callSuperSetEditing) {
		[super setEditing:editing animated:animated];
	}
	else {
		_selfTableView.editing = NO;
	}
}

- (void)setCallSuperSetEditing:(BOOL)callSuperSetEditing {
	_callSuperSetEditing = callSuperSetEditing;
}

- (void)setTableView:(UITableView *)tableView {
	_selfTableView = tableView;
}

- (void)setData:(NSObject *)aData {
	// Pass the data to the view
	//_view.data = aData;
}


@end
