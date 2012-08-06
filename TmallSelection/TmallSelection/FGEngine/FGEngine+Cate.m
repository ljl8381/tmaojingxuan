//
//  FGEngine+Cate.m
//  FreeGames
//
//  Created by ljl on 12-5-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FGEngine+Cate.h"
#import "CategoryDetialPage.h"

@implementation TSEngine (Cate)


//请求分类列表
-(void)requestCateMainData
{
    [_fgHttpObject requestCateMainData];
}

//请求具体分类内容
-(void)requestCategoryData:(NSInteger)index andCurrentType:(int )currentType withPageNo:(int)pageNo
{
    [_fgHttpObject requestCategoryData:index andCurrentType:currentType withPageNo:pageNo];
}
//显示类别详细页
- (void)showCategoryDetial:(UIViewController *)supperViewController andCategoryType:(NSDictionary *)cateInfo
{
    TRACE(@"显示类别详细页");
    [self reportEvent:[NSString stringWithFormat:@"%@页跳转到分类详情列表",[supperViewController class]] withParameters:nil];
    CategoryDetialPage *_gameDetialView = [[CategoryDetialPage alloc]init];
    _gameDetialView.cgdDelegate = self;
    _gameDetialView.cateID = [[cateInfo objectForKey:@"genreId"] intValue];
    _gameDetialView.cateNameString = [cateInfo objectForKey:@"title"];
    [supperViewController.navigationController pushViewController:_gameDetialView animated:YES];
    [self requestCategoryData:_gameDetialView.cateID andCurrentType:2 withPageNo:0];
    [_gameDetialView release];
}

@end
