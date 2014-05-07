#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>

__attribute__((visibility("hidden")))
@interface RASListController : PSListController
- (id)specifiers;
@end

@implementation RASListController

- (id)specifiers
{
	if(_specifiers == nil)
		_specifiers = [[self loadSpecifiersFromPlistName:@"RightAlignStatus" target:self] retain];

	return _specifiers;
}

@end
