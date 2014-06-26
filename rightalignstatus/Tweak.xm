#import <UIKit/UIStatusBarNewUIStyleAttributes.h>

BOOL enabled = YES;
BOOL lenabled = NO;
BOOL carrierenabled = NO;
BOOL ssbenabled = YES;
BOOL ccenabled = NO;

CGFloat userfred = 0;
CGFloat userfgreen = 0;
CGFloat userfblue = 0;
CGFloat userbred = 0;
CGFloat userbgreen = 0;
CGFloat userbblue = 0;

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
// Change statusbar color?
-(id) initWithRequest:(id)arg1 backgroundColor:(id)arg2 foregroundColor:(id)arg3
{
	if(ccenabled){
		return %orig(arg1, [UIColor colorWithRed:userbred green:userbgreen blue:userbblue alpha:1], [UIColor colorWithRed:userfred green:userfgreen blue:userfblue alpha:1]);
	}
	
	return %orig;
}
%end

%hook SBStatusBarStateAggregator
// Hide (Editing to come later) Carrier Name
- (void)_updateServiceItem
{
    if(!carrierenabled){
		%orig;
	}
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
	
	if([prefs objectForKey:@"userfred"])
    {
        userfred = [[prefs objectForKey:@"userfred"] floatValue];
    }
	
	if([prefs objectForKey:@"userfgreen"])
    {
        userfgreen = [[prefs objectForKey:@"userfgreen"] floatValue];
    }
	
	if([prefs objectForKey:@"userfblue"])
    {
        userfblue = [[prefs objectForKey:@"userfblue"] floatValue];
    }
	if([prefs objectForKey:@"userbred"])
    {
        userbred = [[prefs objectForKey:@"userbred"] floatValue];
    }
	
	if([prefs objectForKey:@"userbgreen"])
    {
        userbgreen = [[prefs objectForKey:@"userbgreen"] floatValue];
    }
	
	if([prefs objectForKey:@"userbblue"])
    {
        userbblue = [[prefs objectForKey:@"userbblue"] floatValue];
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
