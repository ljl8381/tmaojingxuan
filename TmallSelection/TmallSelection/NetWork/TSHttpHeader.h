//
//  TSHttpHeader.h
//  FreeGames
//
//  Created by ljl on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef FG_HttpHeader_h
#define FG_HttpHeader_h

#import "TSHttpObject.h"
#import "TSHttpObject+Receive.h"
#import "TSHttpObject+Send.h"
#import "TSHttpObjectDelegate.h"

#define MAX_TIMEOUT_SECONDS     30
#define MAX_OPERATION_COUNT     1
#define SEVER_DOMAIN            @"http://10.248.51.29/api/"
    

typedef struct
{
    request_Type        requestType;	
	NSString            *requestUrl;
    
}requestArray;


static const requestArray request_Array[] =
{
    {main_data_type,              @"http://freegames.renren.com/api/homePageView"},
    {hotwords_data_type,          @"http://freegames.renren.com/api/getAllHotWords"},
    {suggest_data_type,           @"http://freegames.renren.com/api/getThinkSearch"},
    {search_data_type,            @"http://freegames.renren.com/api/getSearchResult"},
    {search_more_type,            @"http://www.115.com"},
    {cate_data_type,              @"http://freegames.renren.com/api/rankHome"},
    {category_data_type,          @"http://freegames.renren.com/api/rankList"},//?genreId=6014&currentPageIndex=0
    {more_feedback_type,          @"http://www.sina.com"},
    {detial_data_type,            @"http://freegames.renren.com/api/gameDetail"},
    {free_data_type,              @"http://freegames.renren.com/api/recommends"},
    {album_data_type,             @"http://freegames.renren.com/api/subjectHome"},
    {album_earlier_data_type,     @"http://freegames.renren.com/api/subjectHome"},
    {album_detial_data_type,      @"http://freegames.renren.com/api/subjectDetail"},
    {more_data_type,              @"http://www.baidu.com"},
    {report_download_type,        @"http://freegames.renren.com/app/download"},
    {evaluate_game_type,          @"http://freegames.renren.com/rate/saveRate"},
    //.....
    
};

//static const requestArray request_Array[] =
//{
//    {main_data_type,              @"http://dev.fg.renren.com/api/homePageView"},
//    {hotwords_data_type,          @"http://dev.fg.renren.com/api/getAllHotWords"},
//    {suggest_data_type,           @"http://dev.fg.renren.com/api/getThinkSearch"},
//    {search_data_type,            @"http://dev.fg.renren.com/api/getSearchResult"},
//    {search_more_type,            @"http://www.115.com"},
//    {cate_data_type,              @"http://dev.fg.renren.com/api/rankHome"},
//    {category_data_type,          @"http://dev.fg.renren.com/api/rankList"},//?genreId=6014&currentPageIndex=0
//    {more_feedback_type,          @"http://www.sina.com"},
//    {detial_data_type,            @"http://dev.fg.renren.com/api/gameDetail"},
//    {free_data_type,              @"http://dev.fg.renren.com/api/recommends"},
//    {album_data_type,             @"http://dev.fg.renren.com/api/subjectHome"},
//    {album_earlier_data_type,     @"http://dev.fg.renren.com/api/subjectHome"},
//    {album_detial_data_type,      @"http://dev.fg.renren.com/api/subjectDetail"},
//    {more_data_type,              @"http://dev.fg.renren.com/api/subjectDetail"},
//    {report_download_type,        @"http://dev.fg.renren.com/app/download"},
//    {evaluate_game_type,          @"http://dev.fg.renren.com/rate/saveRate"},
//    //.....
//    
//};
#endif

