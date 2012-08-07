//
//  FGHeader.h
//  FreeGames
//
//  Created by ljl on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef TmallSelection_TSHeader_h
#define TmallSelection_TSHeader_h

#define SCREEN_SIZE                     [[UIScreen mainScreen] bounds]
#define SCREEN_WIDTH                    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                   [[UIScreen mainScreen] bounds].size.height
#define IOS5                            [[[UIDevice currentDevice]systemVersion] intValue] >=5 ? YES:NO
#define HEIGHT_NAVIGATIONBAR            44.0f
#define	WIDTH_VIEW                      320.0f
#define	HEIGHT_VIEW                     (480.0f-HEIGHT_NAVIGATIONBAR)
#define	FULL_SIZE                       CGRectMake(0, 0, 320 , 480)
// the path of the source files
#define kDefaultSourcePath				[[NSBundle mainBundle] resourcePath]
#define kDefaultImageSourcePath			[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"default"]
#define kSearchRecordsFileName          @"searchrecords.plist"


#define MAIN_DATA_NOTIFICATION                     @"MAIN_DATA_NOTIFICATION"        //首页获取数据通知
#define SUGGEST_DATA_NOTIFICATION                  @"SUGGEST_DATA_NOTIFICATION"     //获取提示通知
#define SEARCH_HOTWORDS_NOTIFICATION               @"SEARCH_HOTWORDS_NOTIFICATION"  //搜索结果通知
#define SEARCH_DATA_NOTIFICATION                   @"SEARCH_DATA_NOTIFICATION"      //搜索结果通知
#define SEARCH_MORE_NOTIFICATION                   @"SEARCH_MORE_NOTIFICATION"      //搜索更多结果通知
#define DETIAL_PAGE_DATA_NOTIFICATION              @"DETIAL_PAGE_DATA_NOTIFICATION"
#define FREE_DATA_NOTIFICATION                     @"FREE_DATA_NOTIFICATION"
#define CATE_DATA_NOTIFICATION                     @"CATE_DATA_NOTIFICATION"
#define CATEGORY_DATA_NOTIFICATION                 @"CATEGORY_DATA_NOTIFICATION"
#define FEEDBACK_DATA_NOTIFICATION                 @"FEEDBACK_DATA_NOTIFICATION"
#define ALBUM_DATA_NOTIFICATION                    @"ALBUM_DATA_NOTIFICATION"
#define ALBUM_EARLIER_DATA_NOTIFICATION            @"ALBUM_EARLIER_DATA_NOTIFICATION"
#define ALBUM_DETIAL_DATA_NOTIFICATION             @"ALBUM_DETIAL_DATA_NOTIFICATION"    //Album详细页通知
#define CATEGORY_DETIAL_DATA_NOTIFICATION          @"CATEGORY_DETIAL_DATA_NOTIFICATION" //Category详细页通知
#define MORE_DATA_NOTIFICATION                     @"MORE_DATA_NOTIFICATION"            //更多页通知
#define EVALUATE_DATA_NOTIFICATION                 @"EVALUATE_DATA_NOTIFICATION"         //评价结果
#define SHARE_SUCCESS_NOTIFICATION                 @"SHARE_SUCCESS_NOTIFICATION"         //评价结果
#define WEIBO_NOTIFICATION                         @"WEIBO_NOTIFICATIO"                 //微博授权通知
#define GAME_ICON                       [UIImage imageNamed:@"default_pic.png"]
#define GAME_ICON_FRAME                 CGRectMake(20.5, 26.5, 57 , 57)
#define REMMEND_IMG_ONE                 @"image_item_star_off.png"
#define REMMEND_IMG_TWO                 @"image_item_star_half.png"
#define REMMEND_IMG_THREE               @"image_item_star_on.png"
#define INDUCTION_VIEW_HEIGHT_CLOSED    100
#define INDUCTION_VIEW_HEIGHT_OPEND     140
#define IMAGE_LINE                      @"image_item_sortline.png"
#define MORE_BUTTON_IMG                 @"images_btn_loadmore.png"
#define MORE_BUTTON_IMG_PRESSED         @"images_btn_loadmore_pressed.png"
#define MORE_BUTTON_HRIGHT              60

typedef enum _FGCellViewStyle {
    FGCellViewStyleSearch= 100,
	FGCellViewStyleSearchHistory,
    FGCellViewStyleCategory,
} FGCellViewStyle;
#endif
