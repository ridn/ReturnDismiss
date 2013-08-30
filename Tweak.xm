#import <UIKit/UIKit2.h>



NSString* key;
static BOOL isReturnKey = NO;
NSTimer* timerForReturn;

%hook UIKeyboardLayoutStar
- (void)longPressAction
{
	if(isReturnKey && ![timerForReturn isValid])timerForReturn = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(returnKeyLongPress) userInfo:nil repeats:NO];
	%orig;
}
%new
- (void)returnKeyLongPress
{
	[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
	if (timerForReturn != nil)
		[timerForReturn invalidate];
	timerForReturn = nil;
	isReturnKey = NO;
		
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	key = [[[self keyHitTest:[touch locationInView:touch.view]] name] lowercaseString];
	if ([key isEqualToString:@"return-key"]) {
		isReturnKey = YES;
	}
	else {
		isReturnKey = NO;
	}
	%orig;
}
-(void)touchesEnded:(NSSet*)touches  withEvent:(UIEvent*)event {

	if (timerForReturn != nil)
	    [timerForReturn invalidate];
	timerForReturn = nil;
	isReturnKey = NO;
	%orig;
}

-(void)touchesMoved:(NSSet*)touches  withEvent:(UIEvent*)event {
    UITouch *touch = [touches anyObject];
	key = [[[self keyHitTest:[touch locationInView:touch.view]] name] lowercaseString];

	if ([key isEqualToString:@"return-key"]) {
	isReturnKey = YES;

    }else{
	if (timerForReturn != nil) {
		[timerForReturn invalidate];
	    timerForReturn = nil;
	}
	isReturnKey = NO;
	}
    %orig;
}
-(void)touchesCanceled:(NSSet*)touches	withEvent:(UIEvent*)event {

	if (timerForReturn != nil)
	    [timerForReturn invalidate];
	timerForReturn = nil;
		isReturnKey = NO;
		
	%orig;
}
%end
