BOOL enabled = YES;
BOOL lenabled = NO;
BOOL carrierenabled = NO;
BOOL ssbenabled = YES;
BOOL ccenabled = NO;

CGFloat userred = 0;
CGFloat usergreen = 0;
CGFloat userblue = 0;

// Statusbar Alignment
%hook UIStatusBarItem
- (BOOL)appearsOnLeft
{
	if(enabled) { 
		if(lenabled) { return YES; }
		return NO;}

    return %orig;
}

- (BOOL)appearsOnRight
{
	if(enabled) { 
		if(lenabled) { return NO; }
		return YES;
    }
    
    return %orig;
}
%end

%hook UIStatusBarNewUIForegroundStyleAttributes
// Change statusbar items color
-(BOOL) _isForegroundColorSafe:(id)hexcolor
{
	return YES;
}

-(id) initWithHeight:(double)arg1 legibilityStyle:(long long)arg2 tintcolor:(id)arg3 backgroundColor:(id)arg4
{
		if(ccenabled){
			return %orig(arg1, arg2, [UIColor colorWithRed:userred green:usergreen blue:userblue alpha:1], arg4);}
		return %orig;
}
%end

%hook SBStatusBarStateAggregator
// Hide (Editing to come later) Carrier Name
- (void)_updateServiceItem
{
    if(!carrierenabled) %orig;
}
%end

%hook SBLockScreenViewController
// Force Small Statusbar LS iPad
- (long long)statusBarStyle
{
	if(ssbenabled) {
		return 0;
    }
	return %orig;
}
%end

%hook SBAwayController
// Force Statusbar Clock On LS?
- (BOOL)shouldShowLockStatusBarTime
{
	if(enabled) {
		return YES;
    }
	return %orig;
}
%end

// Let's load our settings.
static void loadSettings()
{
    // Allocate your prefs dictionary.
    NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.insomniac.ras.plist"];

	if([prefs objectForKey:@"enabled"])
    {
        // Must declare an object
        enabled = [[prefs objectForKey:@"enabled"] boolValue];
    }
    
    if([prefs objectForKey:@"lenabled"])
    {
        lenabled = [[prefs objectForKey:@"lenabled"] boolValue];
    }
	
    if([prefs objectForKey:@"carrierenabled"])
    {
        carrierenabled = [[prefs objectForKey:@"carrierenabled"] boolValue];
    }
	
	if([prefs objectForKey:@"ssbenabled"])
    {
        ssbenabled = [[prefs objectForKey:@"ssbenabled"] boolValue];
    }
    
	if([prefs objectForKey:@"ccenabled"])
    {
        ccenabled = [[prefs objectForKey:@"ccenabled"] boolValue];
    }
	
	if([prefs objectForKey:@"userred"])
    {
        userred = [[prefs objectForKey:@"userred"] floatValue];
    }
	
	if([prefs objectForKey:@"usergreen"])
    {
        usergreen = [[prefs objectForKey:@"usergreen"] floatValue];
    }
	
	if([prefs objectForKey:@"userblue"])
    {
        userblue = [[prefs objectForKey:@"userblue"] floatValue];
    }
	
    // Don't forget to release you resources!!
    [prefs release];
}

// What to do when the settings are changed.
static void settingsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    loadSettings();
}

// Let's add a notification listener to refresh settings without the need for a respring..
%ctor
{
    NSAutoreleasePool *pool([[NSAutoreleasePool alloc] init]);
    %init;

    // Call loadSettings() function on initial dlopen.
    loadSettings();

    // Here's our callback.
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingsChanged, CFSTR("com.insomniac.ras/refreshsettings"), NULL,  CFNotificationSuspensionBehaviorCoalesce);
    
    [pool drain];
}
