@interface SBLockScreenViewController
-(int) statusBarStyle:(id)stylenumber;
-(long long) statusBarStyle;
-(BOOL) wantsToShowStatusBarTime;
-(BOOL) shouldShowLockStatusBarTime;
@end

@interface SBLockScreenViewControllerBase
-(BOOL) shouldShowLockStatusBarTime;
@end

@interface SBStatusBarStateAggregator
-(void) _updateServiceItem;
@end
