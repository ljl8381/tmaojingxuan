//
//  customBrandView.m
//  TmallSelection
//
//  Created by ljl on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "customBrandView.h"


@implementation customBrandView
@synthesize btnDelegate;

-(id)initWithType:(NSInteger)type andDic:(NSArray *)array
{
    self =[super init];
    //self.backgroundColor = [UIColor clearColor];
    if (self) {
        if (type==1) {
            [self createManView:(NSArray *)array]; 
        }
        else
            [self createWomanView:(NSArray *)array];
    }
    self.showsVerticalScrollIndicator = NO;
    return self;
    
}

-(void)createManView:(NSArray *)array
{
    
    for (int i =0; i<4; i++) {
        switch (i) {
            case 0:
                for (int j =0; j<2;j++) {
                    ItemButton *cateItem=[[ItemButton alloc]initWithFrame:CGRectMake(10+110*j, 10, 100, 100)];
                    [cateItem setInfoWithDic:[array objectAtIndex:i+j]];
                    cateItem.btnDelegate=self;
                    [self addSubview:cateItem];
                    [cateItem release];
                }
                ItemButton *cateItem=[[ItemButton alloc]initWithFrame:CGRectMake(230, 10, 80, 100)];
                [self addSubview:cateItem];
                [cateItem setInfoWithDic:[array objectAtIndex:2]];
                cateItem.btnDelegate=self;
                [cateItem release];
                break;
            case 1:
                {
                ItemButton *secondcateItem=[[ItemButton alloc]initWithFrame:CGRectMake(10, 120, 300, 100)];
                [self addSubview:secondcateItem];
                [secondcateItem setInfoWithDic:[array objectAtIndex:3]];
                secondcateItem.btnDelegate=self;
                [secondcateItem release];   
                }
                break;  
            case 2:
                {
                ItemButton *line2CateItem=[[ItemButton alloc]initWithFrame:CGRectMake(10, 230, 160, 100)];
                [line2CateItem setInfoWithDic:[array objectAtIndex:4]];    
                [self addSubview:line2CateItem];
                line2CateItem.btnDelegate=self;
                [line2CateItem release];
                ItemButton *line2SecondItem=[[ItemButton alloc]initWithFrame:CGRectMake(180, 230, 130, 100)];
               [line2SecondItem setInfoWithDic:[array objectAtIndex:5]];
                [self addSubview:line2SecondItem];
                line2SecondItem.btnDelegate=self;
                [line2SecondItem release];
                }
                break;
            case 3:
                for (int j =0; j<3;j++) {
                    ItemButton *cateItem=[[ItemButton alloc]initWithFrame:CGRectMake(10+103*j, 340, 93, 100)];
                   [cateItem setInfoWithDic:[array objectAtIndex:6+j]];                   [self addSubview:cateItem];
                    cateItem.btnDelegate=self;
                    [cateItem release];
                }
                break;
            default:
                break;
        }

    }
}

-(void)createWomanView:(NSArray *)array
{
    
    for (int i =0; i<6; i++) {
        switch (i) {
            case 0:
            {
                ItemButton *cateItem=[[ItemButton alloc]initWithFrame:CGRectMake(10, 10, 130, 100)];
                [cateItem setInfoWithDic:[array objectAtIndex:0]];
                [self addSubview:cateItem];
                cateItem.btnDelegate=self;
                [cateItem release];
                ItemButton *secondCateItem=[[ItemButton alloc]initWithFrame:CGRectMake(150, 10, 160, 100)];
                [self addSubview:secondCateItem];
                [secondCateItem setInfoWithDic:[array objectAtIndex:1]];
                secondCateItem.btnDelegate=self;
                [secondCateItem release];
            }
                break;
            case 1:
            {
                for (int j =0; j<2;j++) {
                    ItemButton *cateItem=[[ItemButton alloc]initWithFrame:CGRectMake(10+110*j, 120, 100, 100)];
                    [cateItem setInfoWithDic:[array objectAtIndex:2+j]];                    [self addSubview:cateItem];
                    cateItem.btnDelegate=self;
                    [cateItem release];
                }
                ItemButton *secondcateItem=[[ItemButton alloc]initWithFrame:CGRectMake(230, 120, 81, 100)];
                [self addSubview:secondcateItem];
                [secondcateItem setInfoWithDic:[array objectAtIndex:4]];
                secondcateItem.btnDelegate=self;
                [secondcateItem release];   
            }
                break;  
            case 2:
            {
                ItemButton *line2CateItem=[[ItemButton alloc]initWithFrame:CGRectMake(10, 230, 130, 100)];
                [line2CateItem setInfoWithDic:[array objectAtIndex:5]];    
                [self addSubview:line2CateItem];
                line2CateItem.btnDelegate=self;
                [line2CateItem release];
                ItemButton *line2SecondItem=[[ItemButton alloc]initWithFrame:CGRectMake(150, 230, 160, 100)];
                [line2SecondItem setInfoWithDic:[array objectAtIndex:6]];
                [self addSubview:line2SecondItem];
                line2SecondItem.btnDelegate=self;
                [line2SecondItem release];
            }
                break;
            case 3:
                for (int j =0; j<3;j++) {
                    ItemButton *cateItem=[[ItemButton alloc]initWithFrame:CGRectMake(10+103*j, 340, 93, 100)];
                    [cateItem setInfoWithDic:[array objectAtIndex:7+j]];                    [self addSubview:cateItem];
                    cateItem.btnDelegate=self;
                    [cateItem release];
                }
                break;
            case 4:
            {
                ItemButton *line2CateItem=[[ItemButton alloc]initWithFrame:CGRectMake(10, 450, 160, 100)];
                [line2CateItem setInfoWithDic:[array objectAtIndex:10]];    
                [self addSubview:line2CateItem];
                line2CateItem.btnDelegate=self;
                [line2CateItem release];
                ItemButton *line2SecondItem=[[ItemButton alloc]initWithFrame:CGRectMake(180, 450, 130, 100)];
                [line2SecondItem setInfoWithDic:[array objectAtIndex:11]];
                [self addSubview:line2SecondItem];
                line2SecondItem.btnDelegate=self;
                [line2SecondItem release];
            }
            case 5:
            {
                ItemButton *secondcateItem=[[ItemButton alloc]initWithFrame:CGRectMake(10, 560, 300, 100)];
                [self addSubview:secondcateItem];
                secondcateItem.btnDelegate=self;
                [secondcateItem setInfoWithDic:[array objectAtIndex:12]];
                [secondcateItem release];   
            }

            default:
                break;
        }
        
    }


}

-(void)itemButtonClicked:(id)sender
{
    if (btnDelegate) {
        [btnDelegate itemButtonClicked:sender];
    }

}

@end
