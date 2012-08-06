//
//  FGEngine+Main.m
//  FreeGames
//
//  Created by ljl on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FGEngine+Main.h"
#import "SearchViewController.h"
#import "MainViewController.h"
#import "GameDetailView.h"
#import "SearchResultViewController.h"
@implementation TSEngine (Main)

//请求首页数据
-(void)requestMainData:(int)pageNo  proType:(int)type
{
    TRACE(@"请求首页数据");
    [_fgHttpObject requestMainData:pageNo  proType:type];
}


//开始进行搜索
-(void)beginToSearch:(NSString *)searchText withController:(UIViewController *)viewcontroller  andPageNo:(int)pageNo

{
    TRACE(@"开始进行搜索");
    if ([viewcontroller isKindOfClass:[SearchViewController class]])
    {
        TRACE(@"跳转到搜索结果页");
        [self reportEvent:@"搜索页跳转到搜索结果页" withParameters:nil];
        SearchResultViewController *searchResultView  =[[SearchResultViewController alloc]init];
        searchResultView.searchString = searchText;
        [viewcontroller.navigationController  pushViewController:searchResultView animated:YES];
        searchResultView.sDelegate = self;
        searchResultView.gDelegate = self;
        [searchResultView release];
        
    }
    [_fgHttpObject beginToSearch:searchText  andPageNo:pageNo];    
}

//请求推荐热词
-(void)requestHotWords
{
    TRACE(@"请求热词信息");
    [_fgHttpObject requestHotWords];
}
//请求提示信息
-(void)requestSuggestionData:(NSString *)suggestText
{
    TRACE(@"获取提示信息");
    [_fgHttpObject requestSuggestionData:suggestText];
}

//请求更多
-(void)requestMoreResult:(NSString *)searchText  andPageNo:(int)pageNo

{
    TRACE(@"获取更多搜索结果信息");
    [_fgHttpObject beginToSearch:searchText  andPageNo:pageNo]; 
    
}
@end
