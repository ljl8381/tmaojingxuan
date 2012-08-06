//
//  UIProgressBar.h
//  
//
//  
//  
//

#import <UIKit/UIKit.h>


@interface UIProgressBar : UIView 
{
	float minValue, maxValue;
	float currentValue;
	UIColor  *progressRemainingColor;
    UIImageView  *progressView;
}

@property (nonatomic, readwrite) float  currentValue;
@property (nonatomic, retain) UIColor  *progressRemainingColor;


@end
