//
//  UIProgressBar.h
//  
//
//  
//  
//

#import "UIProgressBar.h"


@implementation UIProgressBar

@synthesize   currentValue;
@synthesize  progressRemainingColor;
- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame])
	{
		minValue = 0;
		maxValue = 1;
		currentValue = 0;
		self.backgroundColor = [UIColor clearColor];
        progressView =[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"images_progress_bar_focus.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        [self addSubview:progressView];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context,[[progressRemainingColor colorWithAlphaComponent:1] CGColor]);
	CGContextSetFillColorWithColor(context, [[progressRemainingColor colorWithAlphaComponent:1] CGColor]);

	
	float radius = (rect.size.height / 2) - 2;
	CGContextMoveToPoint(context, 2, rect.size.height/2);

	CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius);
	CGContextAddLineToPoint(context, rect.size.width - radius - 2, 2);
	CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius);
	CGContextFillPath(context);
	
	CGContextSetFillColorWithColor(context, [progressRemainingColor CGColor]);

	CGContextMoveToPoint(context, rect.size.width - 2, rect.size.height/2);
	CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius);
	CGContextAddLineToPoint(context, radius + 2, rect.size.height - 2);
	CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius);
	CGContextFillPath(context);
	
	
	CGContextMoveToPoint(context, 2, rect.size.height/2);
	
	CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius);
	CGContextAddLineToPoint(context, rect.size.width - radius - 2, 2);
	CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius);
	CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius);
	
	CGContextAddLineToPoint(context, radius + 2, rect.size.height - 2);
	CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius);
	CGContextStrokePath(context);
	
}

-(void)setCurrentValue:(float)newValue
{
	currentValue = newValue;
    progressView.frame = CGRectMake(2, 2, (currentValue/(maxValue - minValue)) * (self.bounds.size.width), self.bounds.size.height-4);
	[self setNeedsDisplay];
}

-(void)setProgressRemainingColor:(UIColor *)newColor
{
	[newColor retain];
	[progressRemainingColor release];
	progressRemainingColor = newColor;
	[self setNeedsDisplay];

}

- (void)dealloc
{
    [progressView release];
	[progressRemainingColor release];
    [super dealloc];
}


@end
