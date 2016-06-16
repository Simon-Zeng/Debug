//
//  RoundCornerView.m
//  ElongClient
//  圆角带边框的View
//
//  Created by haibo on 11-9-19.
//  Copyright 2011 elong. All rights reserved.
//

#import "eLongRoundCornerView.h"
#import "eLongDefine.h"

@implementation eLongRoundCornerView

@synthesize selected;
@synthesize image;
@synthesize borderColor;
@synthesize fillColor;
@synthesize imageRadius;


- (void)dealloc {
	self.image			= nil;
	self.borderColor	= nil;
	self.fillColor		= nil;
    self.placeholder    = nil;
    _downLoadImageView  = nil;
	CGImageRelease(imageRef);
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.fillColor = [UIColor clearColor];
		self.clipsToBounds = NO;
		self.selected	= NO;
        self.imageRadius = 5.0f;
        _downLoadImageView = [[UIImageView alloc] init];
        _downLoadImageView.frame = CGRectZero;
        _downLoadImageView.hidden = YES;
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = NO;
		self.selected	= NO;
        self.imageRadius = 5.0f;
        _downLoadImageView = [[UIImageView alloc] init];
        _downLoadImageView.frame = CGRectZero;
        _downLoadImageView.hidden = YES;
	}
	
	return self;
}


- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat height = self.bounds.size.height;
	CGContextTranslateCTM(context, 0.0, height);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextSetLineWidth(context, 1.0);
	CGContextSaveGState(context);
	
	UIColor *pathColor = RGBACOLOR(240, 240, 240, 1);
	[pathColor setStroke];
	if (fillColor) {
		[fillColor setFill];
	}
	
	CGRect rrect = CGRectMake(3, 3, self.frame.size.width - 6, self.frame.size.height - 6);
	CGFloat radius = self.imageRadius;
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	
	// Start at 1
	CGContextMoveToPoint(context, minx, midy);
	// Add an arc through 2 to 3
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	// Add an arc through 4 to 5
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	// Add an arc through 6 to 7
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	// Add an arc through 8 to 9
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	// Close the path
	CGContextClosePath(context);
	
	if (imageRef) {
		CGContextClip(context);
		CGContextDrawImage(context, rect, imageRef);
	}else {
		// Fill & stroke the path
		CGContextDrawPath(context, kCGPathFillStroke);
	}
	
	if (selected) {
		CGContextRestoreGState(context);
		[borderColor setStroke];
		CGContextSetLineWidth(context, 3.0f);
		
		CGRect orrect = CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 4);
		CGFloat ominx = CGRectGetMinX(orrect), omidx = CGRectGetMidX(orrect), omaxx = CGRectGetMaxX(orrect);
		CGFloat ominy = CGRectGetMinY(orrect), omidy = CGRectGetMidY(orrect), omaxy = CGRectGetMaxY(orrect);
		
		// Start at 1
		CGContextMoveToPoint(context, ominx, omidy);
		// Add an arc through 2 to 3
		CGContextAddArcToPoint(context, ominx, ominy, omidx, ominy, radius);
		// Add an arc through 4 to 5
		CGContextAddArcToPoint(context, omaxx, ominy, omaxx, omidy, radius);
		// Add an arc through 6 to 7
		CGContextAddArcToPoint(context, omaxx, omaxy, omidx, omaxy, radius);
		// Add an arc through 8 to 9
		CGContextAddArcToPoint(context, ominx, omaxy, ominx, omidy, radius);
		// Close the path
		CGContextClosePath(context);
		CGContextDrawPath(context, kCGPathStroke);
	}
}


- (void)setImage:(UIImage *)img {
	CGImageRelease(imageRef);
	imageRef = CGImageRetain(img.CGImage);
	[self setNeedsDisplay];
}


- (void)selectedWithColor:(UIColor *)boardColor {
	self.selected	 = YES;
	self.borderColor = boardColor;
	[self setNeedsDisplay];
}


- (void)deselect {
	self.selected = NO;
	[self setNeedsDisplay];
}

@end


@implementation SmallLoadingView


- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
		
		indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		indicatorView.hidesWhenStopped	= YES;
		indicatorView.center			= CGPointMake(frame.size.width / 2, frame.size.height / 2);
		[self addSubview:indicatorView];
		
		self.hidden = YES;
	}
	
	return self;
}


- (void)startLoading {
	if (self.hidden == YES) {
		self.hidden = NO;
		[indicatorView startAnimating];
	}
}


- (void)stopLoading {
	if (self.hidden == NO) {
		self.hidden = YES;
		[indicatorView stopAnimating];
	}
}

-(void)dealloc{
    indicatorView = nil;
}

@end



@implementation SmallLoadingViewWithStatus

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        _statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, frame.size.height - 16, frame.size.width - 6, 16)];
        _statusLabel.font = [UIFont systemFontOfSize:9];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor whiteColor];
        [_statusImageView addSubview:_statusLabel];
    }
    
    return self;
}
-(void)setImageAuditStatus:(NSInteger)imageAuditStatus
{
    if (imageAuditStatus == 0) {//未审核
        _statusLabel.backgroundColor = [UIColor colorWithHexStr:@"#999999"];
        _statusLabel.text = @"图片审核中";
        //        [_statusLabel sizeToFit];
        _statusImageView.alpha = 1;
        [self addSubview:_statusImageView];
    }else if (imageAuditStatus == 1) {//通过
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.text = @"";
    }else if (imageAuditStatus == 2){//未通过
        _statusLabel.backgroundColor = [UIColor colorWithHexStr:@"#ff5555"];
        _statusLabel.text = @"审核失败";
        //        [_statusLabel sizeToFit];
        _statusImageView.alpha = 1;
        [self addSubview:_statusImageView];
    }
    
}

@end
