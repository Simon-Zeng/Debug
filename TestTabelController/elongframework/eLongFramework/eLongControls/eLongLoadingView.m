#import "eLongLoadingView.h"
#import "eLongWaitingView.h"
#import "eLongDefine.h"
#import "eLongExtension.h"

static eLongLoadingView *loadingView = nil;
static eLongLoadingView *blockLoadingView = nil;


@implementation eLongLoadingView

@synthesize outTime;
@synthesize loadHidden;

- (id)init:(CGRect)bgframe alertframe:(CGRect)alertframe alertBgPath:(NSString *)alertBgPath backgroundColor:(UIColor *)backgroundColor{
    if ((self = [super initWithFrame:bgframe])) {
	
		if (backgroundColor==nil) {
			
			[self setBackgroundColor:RGBACOLOR(0, 0, 0, 1)];
		}
		else {
			
			UIColor* bgColor = [[UIColor alloc] initWithRed: 128/255.0 green:138/255.0 blue:135/255.0 alpha:1];
			
			[self setBackgroundColor:bgColor];
		}
		alertFrame=alertframe;
		alertShowing = NO;
		content = [[UIView alloc] initWithFrame:CGRectMake((bgframe.size.width -  alertframe.size.width) / 2, (bgframe.size.height - alertframe.size.height) / 2, alertframe.size.width, alertframe.size.height)];
    

        flashView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, content.frame.size.width - 39, content.frame.size.height)];
        if (alertBgPath) {
            flashView.image = [UIImage noCacheImageNamed:alertBgPath];
            UILabel *tipsLbl = [[UILabel alloc] initWithFrame:flashView.bounds];
            tipsLbl.font = FONT_12;
            tipsLbl.backgroundColor = [UIColor clearColor];
            tipsLbl.textAlignment = NSTextAlignmentCenter;
            tipsLbl.textColor = RGBACOLOR(240, 240, 240, 1);
            [flashView addSubview:tipsLbl];
            
        }else{
            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < 24; i++) {
                [imageArray safeAddObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_%d.png",i]]];
            }
            flashView.animationImages = imageArray;
            flashView.animationRepeatCount = 0;
            flashView.animationDuration = 1.5;
        }
		
        
        
		[content addSubview:flashView];
	

		// 右上角取消按钮
		cancelReqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelReqBtn.exclusiveTouch = YES;
		[cancelReqBtn setBackgroundImage:[UIImage noCacheImageNamed:@"bookclose_btn.png"] forState:UIControlStateNormal];
		[cancelReqBtn addTarget:self action:@selector(cancelclick) forControlEvents:UIControlEventTouchUpInside];
		cancelReqBtn.frame = CGRectMake(content.frame.size.width - 39, 0, 39, 48);
		[content addSubview:cancelReqBtn];
        
        
        // 分割线
        UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SCALE, 48)];
        splitView.backgroundColor = RGBACOLOR(200, 200, 200, 1);
        [cancelReqBtn addSubview:splitView];
		
        [self addSubview:content];
        
		[self setAlpha:1];
		[self setHidden:YES];
        
        loadHidden = YES;
    }
    return self;
}

- (void)cancelclick {
    if (self.m_util) {
        // 如果有请求在执行，通过请求的方法取消loading
        [self.m_util cancel];
    }
    else {
        [self hideAlertMessage];
    }
    
    if ([_delegate respondsToSelector:@selector(cancelLoading)]) {
        [_delegate cancelLoading];
    }
}

+ (eLongLoadingView *)sharedLoadingView {
    if (!loadingView) {  
        loadingView = [[eLongLoadingView alloc]init:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) alertframe:CGRectMake(0, 0, 186, 48) alertBgPath:nil backgroundColor:nil];
   
	}
    return loadingView;
}

+ (eLongLoadingView *)sharedBlockLoadingView{
    if (!blockLoadingView) {
        blockLoadingView = [[eLongLoadingView alloc]init:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) alertframe:CGRectMake(0, 0, 186, 48) alertBgPath:@"loading_block.png" backgroundColor:nil];
    }
    return blockLoadingView;
}

- (void) refreshTips:(NSString *)tips{
    if (self == blockLoadingView) {
        UILabel *tipsLbl = (UILabel *)[[flashView subviews] objectAtIndex:0];
        tipsLbl.text = tips;
    }
}

- (void) showAlertMessage:(NSString *)message delegate:(id<LoadingViewDelegate>)delegate{
    self.delegate = delegate;
    [self showAlertMessage:message utils:nil];
}

- (void)showAlertMessage:(NSString *)message utils:(eLongHTTPRequest *)httpUtil {
    if (loadHidden) {
        content.hidden = NO;
        cancelReqBtn.hidden = NO;
    
        self.m_util = httpUtil;
        loadHidden = NO;
        
        flashView.frame = CGRectMake(0.0, 0.0, content.frame.size.width - 39, content.frame.size.height);
        [flashView startAnimating];
//        ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
//        [delegate.window addSubview:self];
//        lvyue
        [[self mainWindow] addSubview:self];
        const CGFloat *bgColorComponents = CGColorGetComponents(self.backgroundColor.CGColor);
        
        self.backgroundColor = [UIColor colorWithRed:bgColorComponents[0] green:bgColorComponents[1] blue:bgColorComponents[2] alpha:.2];
        [self setHidden:NO];
        
        //渐变
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.backgroundColor = [UIColor colorWithRed:bgColorComponents[0] green:bgColorComponents[1] blue:bgColorComponents[2] alpha:.38];
        
        [UIView commitAnimations];
    }else{
        self.m_util = httpUtil;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)showAlertMessageNoCancel{
    if (loadHidden) {
        content.hidden = NO;
        cancelReqBtn.hidden = YES;
        
        loadHidden = NO;
        
        
        flashView.frame = CGRectMake(24.0, 0.0, content.frame.size.width - 39, content.frame.size.height);
        [flashView startAnimating];
        
//        ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
//        
//        [delegate.window addSubview:self];
//        lvyue
        [[self mainWindow]addSubview:self];
        const CGFloat *bgColorComponents = CGColorGetComponents(self.backgroundColor.CGColor);
        
        self.backgroundColor = [UIColor colorWithRed:bgColorComponents[0] green:bgColorComponents[1] blue:bgColorComponents[2] alpha:.2];
        [self setHidden:NO];
        
        //渐变
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.backgroundColor = [UIColor colorWithRed:bgColorComponents[0] green:bgColorComponents[1] blue:bgColorComponents[2] alpha:.38];
        
        [UIView commitAnimations];
    }else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)hideAlertMessage{
    if (!loadHidden) {
        [self performSelector:@selector(removeAlertMessage) withObject:nil afterDelay:0.2];
    }
}
- (void)hideAlertMessageNoDelay{
    if (!loadHidden) {
        [self removeAlertMessage];
    }
}
- (void) removeAlertMessage{
    const CGFloat *bgColorComponents = CGColorGetComponents(self.backgroundColor.CGColor);
    
    [flashView stopAnimating];
    self.backgroundColor = [UIColor colorWithRed:bgColorComponents[0] green:bgColorComponents[1] blue:bgColorComponents[2] alpha:0];
    content.hidden = YES;
    cancelReqBtn.hidden = YES;
    
    [self removeAll];
}

- (void)removeAll {
    loadHidden=YES;
    //[flashView.layer removeAnimationForKey:@"flashlight"];
    [flashView stopAnimating];
	[self setHidden:YES];
	[self removeFromSuperview];
}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (self.m_util){
        [self.m_util cancel];
        self.m_util = nil;
    }
	
}


- (UIWindow *)mainWindow{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)]){
        return [app.delegate window];
    }
    else{
        return [app keyWindow];
    }
}

@end