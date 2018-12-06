#import "SettingsCollapse.h"

BOOL isInsert = NO;
NSMutableSet *sectionSet = [[NSMutableSet alloc] init];
PSTableCell *theCell;
NSMutableDictionary *imagesDict = [[NSMutableDictionary alloc] init];
NSMutableDictionary *toggleDict = [[NSMutableDictionary alloc] init];

%hook PSTableCell

%property (nonatomic, retain) AppsPagingView *pagingView;
%property (nonatomic, assign) id delegate;

-(void)prepareForReuse {
	%orig;

	if (self.pagingView) {
		self.pagingView.hidden = YES;
	}
}

-(void)_updateAccessoryTypeForSpecifier:(id)arg1 {
	%orig;

	if (self.pagingView) {
		[self bringSubviewToFront:self.pagingView];
	}

	for (UIView *aView in self.subviews) {
		if ([aView isKindOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")]) {
			[self bringSubviewToFront:aView];
		}
	}
}

-(void)addSubview:(UIView *)subview {
	%orig;

	if (self.pagingView) {
		[self bringSubviewToFront:self.pagingView];
	}

	for (UIView *aView in self.subviews) {
		if ([aView isKindOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")]) {
			[self bringSubviewToFront:aView];
		}
	}
}

%new
-(void)setupPagingView {
	if (!self.pagingView) {
		self.pagingView = [[[AppsPagingView alloc] init] autorelease];
	
		[self addSubview:self.pagingView];
	}

	self.pagingView.delegate = self;

	[self layout];
}

%new
-(void)didSelectItemAtIndex:(int)index {
	if (self.delegate) {
		[self.delegate cell:self didSelectItemAtIndex:index];
	}
}

-(void)layoutSubviews {
	if (self.pagingView) {
		[self bringSubviewToFront:self.pagingView];
	}

	%orig;

	[self layout];

	for (UIView *aView in self.subviews) {
		if ([aView isKindOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")]) {
			[self bringSubviewToFront:aView];
		}
	}
}

%new
-(void)layout {
	if (self.pagingView) {
		self.pagingView.frame = CGRectMake(
			0.0,
			self.contentView.frame.origin.y,
			self.frame.size.width,
			self.contentView.bounds.size.height
		);

		self.pagingView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:1.0];

		self.pagingView.clipsToBounds = YES;

		if (@available(iOS 11.0, *)) {
			if (self.backgroundView.layer.maskedCorners == 0 && self.layer.cornerRadius > 0.0) {
				self.pagingView.layer.cornerRadius = self.layer.cornerRadius;
			} else {
				self.pagingView.layer.cornerRadius = self.backgroundView.layer.maskedCorners;
			}
		}
	}
}

-(void)dealloc {
	if (self.pagingView) {
		[self.pagingView removeFromSuperview];
		
		self.pagingView = nil;
	}

	%orig;
}

%end

%hook PSUIPrefsListController

// Nothing to see here, only avoiding UITableView inconsistency

-(void)beginUpdates {
	isInsert = YES;

	UITableView *table = [self table];

	[imagesDict removeAllObjects];

	[toggleDict removeAllObjects];

	[table reloadData];

	%orig;

	isInsert = NO;

	[imagesDict removeAllObjects];

	[toggleDict removeAllObjects];

	[table reloadData];
}

-(void)endUpdates {
	isInsert = YES;

	UITableView *table = [self table];

	[imagesDict removeAllObjects];

	[toggleDict removeAllObjects];

	[table reloadData];

	%orig;

	isInsert = NO;

	[imagesDict removeAllObjects];

	[toggleDict removeAllObjects];

	[table reloadData];
}

-(void)insertOrderedSpecifier:(id)arg1 animated:(BOOL)arg2 {
	isInsert = YES;

	UITableView *table = [self table];

	[imagesDict removeAllObjects];

	[toggleDict removeAllObjects];
		
	[table reloadData];

	%orig;

	isInsert = NO;

	[imagesDict removeAllObjects];

	[toggleDict removeAllObjects];

	[table reloadData];
}

-(void)viewDidLoad {
	%orig;

	UITableView *tableView = [self table];

	[tableView registerClass:[CustomHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"CustomHeaderFooterView"];

	NSUserDefaults *defaults = [[[NSUserDefaults alloc] initWithSuiteName:@"com.shiftcmdk.settingscollapsepreferences"] autorelease];

	id enabledSectionsArray = [defaults arrayForKey:@"enabledSections"];

	if (enabledSectionsArray) {
		[sectionSet addObjectsFromArray:(NSArray *)enabledSectionsArray];
	}
}

-(long long)tableView:(id)arg1 numberOfRowsInSection:(long long)arg2 {
	if (isInsert) {
		return %orig;
	}

	NSArray *groups = [self valueForKey:@"_groups"];
	NSArray *specifiers = [self specifiers];

	int currentGroupIndex = [[groups objectAtIndex:arg2] intValue];

	if (currentGroupIndex >= specifiers.count) {
		return %orig;
	}

	id groupIdentifier = [[specifiers objectAtIndex:currentGroupIndex] valueForKey:@"identifier"];

	if (sectionSet && [sectionSet containsObject:groupIdentifier]) {
		return 1.0;
	}

	return %orig;
}

-(double)tableView:(id)arg1 heightForRowAtIndexPath:(id)arg2 {
	if (isInsert) {
		return %orig;
	}

	NSArray *groups = [self valueForKey:@"_groups"];
	NSArray *specifiers = [self specifiers];

	int currentGroupIndex = [[groups objectAtIndex:((NSIndexPath *)arg2).section] intValue];

	if (currentGroupIndex >= specifiers.count) {
		return %orig;
	}

	id groupIdentifier = [[specifiers objectAtIndex:currentGroupIndex] valueForKey:@"identifier"];

	if ([sectionSet containsObject:groupIdentifier]) {
		return 59.0 + 1.0 / [UIScreen mainScreen].scale;
	}

	return %orig;
}

// TODO: Add support for airplane mode/vpn

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (isInsert) {
		return %orig;
	}

	NSArray *groups = [self valueForKey:@"_groups"];
	NSArray *specifiers = [self specifiers];

	int currentGroupIndex = [[groups objectAtIndex:indexPath.section] intValue];
	id groupIdentifier = [[specifiers objectAtIndex:currentGroupIndex] valueForKey:@"identifier"];

	if ([sectionSet containsObject:groupIdentifier]) {
		// PSUIPrefsListController sometimes doesn't like custom cells
		PSTableCell *originalCell = (PSTableCell *)%orig;

		// we just throw all of our UI on top
		[originalCell setupPagingView];

		originalCell.pagingView.hidden = NO;

		unsigned long start = [self rangeOfSpecifiersInGroupID:groupIdentifier].location + 1;
		unsigned long upperBound = [self rangeOfSpecifiersInGroupID:groupIdentifier].location + [self rangeOfSpecifiersInGroupID:groupIdentifier].length;

		NSMutableArray *images = [[[NSMutableArray alloc] init] autorelease];

		//NSMutableSet *toggleSet = [NSMutableSet set];

		//CFTimeInterval startTime = CFAbsoluteTimeGetCurrent();

		if ([imagesDict objectForKey:groupIdentifier]) {
			images = [imagesDict objectForKey:groupIdentifier];
		} else {
			for (unsigned long i = start; i < upperBound; i++) {
				PSSpecifier *specifier = [specifiers objectAtIndex:i];
				NSMutableDictionary *properties = [specifier valueForKey:@"_properties"];

				/*id specifierID = [properties objectForKey:@"id"];

				if (specifierID && ([[specifierID stringValue] isEqual:@"AIRPLANE_MODE"] || [[specifierID stringValue] isEqual:@"VPN"])) {
					[toggleSet addObject:[NSNumber numberWithInt:images.count]];
				}*/

				id iconImage = [properties objectForKey:@"iconImage"];

				if (!iconImage) {
					id bundleIdentifier = [properties objectForKey:@"AppBundleID"];

					if ([bundleIdentifier stringValue]) {
						int imageIndex = images.count;
						[images addObject:[originalCell blankIcon]];

						NSIndexPath *oldIndexPath = [self indexPathForSpecifier:specifier];

						dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
							UIImage *image = [UIImage _applicationIconImageForBundleIdentifier:[bundleIdentifier stringValue] format:0 scale:[UIScreen mainScreen].scale];

							dispatch_async(dispatch_get_main_queue(), ^{
								NSIndexPath *newIndexPath = [self indexPathForSpecifier:specifier];

								if (oldIndexPath.row == newIndexPath.row && oldIndexPath.section == newIndexPath.section) {
									[images replaceObjectAtIndex:imageIndex withObject:image];

									NSMutableArray *updateImages = [imagesDict objectForKey:groupIdentifier];

									if (updateImages && imageIndex < updateImages.count) {
										[updateImages replaceObjectAtIndex:imageIndex withObject:image];

										[imagesDict setObject:updateImages forKey:groupIdentifier];
									}

									PSTableCell *updateCell = (PSTableCell *)[tableView cellForRowAtIndexPath:indexPath];

									if (updateCell && updateCell.pagingView) {
										[updateCell.pagingView setImage:image atIndex:imageIndex];
									}
								}
							});
						});

						continue;
					}

					// Need to find a better way for this
					if (!theCell) {
						theCell = [[%c(PSTableCell) alloc] 
							initWithStyle:1 
							reuseIdentifier:@"PSLinkCell" 
							specifier:[specifiers objectAtIndex:i]
						];
					}

					//NSLog(@"%@", [[specifiers objectAtIndex:i] valueForKey:@"_properties"]);

					[theCell setSpecifier:specifier];
					[theCell refreshCellContentsWithSpecifier:specifier];

					id lazyIcon = [theCell getLazyIcon];

					if (!lazyIcon) {
						lazyIcon = [theCell blankIcon];
					}

					// double check, probably unnecessary because blankIcon is never null?!
					if (lazyIcon) {
						[images addObject:lazyIcon];
					} else {
						[images addObject:[[[UIImage alloc] init] autorelease]];
					}
				} else {
					[images addObject:iconImage];
				}
			}
			[imagesDict setObject:images forKey:groupIdentifier];
		}

		/*if (![toggleDict objectForKey:groupIdentifier]) {
			[toggleDict setObject:toggleSet forKey:groupIdentifier];
		}*/

		//NSLog(@"%@ %f", groupIdentifier, CFAbsoluteTimeGetCurrent() - startTime);

		[originalCell.pagingView setImages:images];

		originalCell.delegate = self;

		return originalCell;
	}
	return %orig;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	static NSString *headerReuseIdentifier = @"CustomHeaderFooterView";

    CustomHeaderFooterView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerReuseIdentifier];
	sectionHeaderView.index = (int)section;
	sectionHeaderView.delegate = self;

	NSArray *groups = [self valueForKey:@"_groups"];
	NSArray *specifiers = [self specifiers];

	int currentGroupIndex = [[groups objectAtIndex:section] intValue];
	id groupIdentifier = [[specifiers objectAtIndex:currentGroupIndex] valueForKey:@"identifier"];

	NSString *showMore = @"Show More";
	NSString *showLess = @"Show Less";

	NSBundle *widgetsBundle = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Widgets.framework"];

	NSUserDefaults *defaults = [[[NSUserDefaults alloc] initWithSuiteName:@"com.shiftcmdk.settingscollapsepreferences"] autorelease];

	BOOL useChevron = [[defaults objectForKey:@"usechevron"] boolValue];

	sectionHeaderView.useChevron = useChevron;

	if ([sectionSet containsObject:groupIdentifier]) {
		if (!useChevron) {
			if (widgetsBundle) {
				showMore = [widgetsBundle localizedStringForKey:@"SHOW_MORE_TITLE" value:@"Show More" table:@"Widgets"];
			}

			[sectionHeaderView.expandHideButton setTitle:showMore forState:UIControlStateNormal];
		} else {
			NSBundle *bundle = [NSBundle bundleWithPath:@"/Library/Application Support/com.shiftcmdk.settingscollapse.bundle"];

			UIImage *image = [UIImage imageNamed:@"arrow_down" inBundle:bundle compatibleWithTraitCollection:nil];

			[sectionHeaderView.expandHideButton setTitle:nil forState:UIControlStateNormal];
			[sectionHeaderView.expandHideButton setImage:image forState:UIControlStateNormal];
		}
	} else {
		if (!useChevron) {
			if (widgetsBundle) {
				showLess = [widgetsBundle localizedStringForKey:@"SHOW_LESS_TITLE" value:@"Show Less" table:@"Widgets"];
			}

			[sectionHeaderView.expandHideButton setTitle:showLess forState:UIControlStateNormal];
		} else {
			NSBundle *bundle = [NSBundle bundleWithPath:@"/Library/Application Support/com.shiftcmdk.settingscollapse.bundle"];

			UIImage *image = [UIImage imageNamed:@"arrow_up" inBundle:bundle compatibleWithTraitCollection:nil];

			[sectionHeaderView.expandHideButton setTitle:nil forState:UIControlStateNormal];
			[sectionHeaderView.expandHideButton setImage:image forState:UIControlStateNormal];
		}
	}

    return sectionHeaderView;  
}

// TODO: Add support for airplane mode/vpn

%new
-(void)cell:(UITableViewCell *)cell didSelectItemAtIndex:(int)index {
	UITableView *tableView = [self table];

	NSIndexPath *indexPath = [tableView indexPathForCell:cell];

	if (indexPath) {
		NSArray *groups = [self valueForKey:@"_groups"];
		NSArray *specifiers = [self specifiers];

		int currentGroupIndex = [[groups objectAtIndex:indexPath.section] intValue];
		id groupIdentifier = [[specifiers objectAtIndex:currentGroupIndex] valueForKey:@"identifier"];

		unsigned long theIndex = [self rangeOfSpecifiersInGroupID:groupIdentifier].location + 1 + index;

		PSSpecifier *spec = [specifiers objectAtIndex:theIndex];

		NSMutableDictionary *properties = [spec valueForKey:@"properties"];

		/*id specifierID = [properties objectForKey:@"id"];

		if (specifierID) {
			if ([[specifierID stringValue] isEqual:@"AIRPLANE_MODE"]) {
				BOOL airplaneEnabled = [%c(PSUIPrefsListController) airplaneMode];

				[self _setAirplaneMode:!airplaneEnabled];

				[toggleDict removeObjectForKey:groupIdentifier];

				PSSpecifier *airplaneSpecifier = [self specifierForID:@"AIRPLANE_MODE"];

				NSIndexPath *airplaneIndexPath = nil;

				if (airplaneSpecifier && (airplaneIndexPath = [self indexPathForSpecifier:airplaneSpecifier])) {
					NSMutableSet *toggleSet = [NSMutableSet set];

					[toggleSet addObject:[NSNumber numberWithInt:airplaneIndexPath.row]];

					[toggleDict setObject:toggleSet forKey:groupIdentifier];

					[((PSTableCell *)cell).pagingView updateToggles:airplaneEnabled ? [NSSet set] : toggleSet disabledToggles:airplaneEnabled ? toggleSet : [NSSet set]];
				}

				return;
			}

			if ([[specifierID stringValue] isEqual:@"VPN"]) {
				return;
			}
		}*/

		id enabledProperty = [properties objectForKey:@"enabled"];

		if (!enabledProperty || (enabledProperty && [enabledProperty intValue] != 0)) {
			id customControllerClass = [properties objectForKey:@"customControllerClass"];

			if (customControllerClass && [customControllerClass isEqual:@"DevicePINController"]) {
				UITableView *tableView = [self table];

				[self tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]];
			} else {
				[self _showControllerFromSpecifier:spec];
			}
		}
	}
}

%new
-(void)didTapButtonAtIndex:(NSInteger)index {
	NSArray *groups = [self valueForKey:@"_groups"];
	NSArray *specifiers = [self specifiers];

	int currentGroupIndex = [[groups objectAtIndex:index] intValue];
	id groupIdentifier = [[specifiers objectAtIndex:currentGroupIndex] valueForKey:@"identifier"];

	if ([sectionSet containsObject:groupIdentifier]) {
		[sectionSet removeObject:groupIdentifier];
	} else {
		[sectionSet addObject:groupIdentifier];
	}

	NSUserDefaults *defaults = [[[NSUserDefaults alloc] initWithSuiteName:@"com.shiftcmdk.settingscollapsepreferences"] autorelease];

	[defaults setObject:[sectionSet allObjects] forKey:@"enabledSections"];

	UITableView *tableView = [self table];

	NSMutableIndexSet *mutableIndexSet = [[[NSMutableIndexSet alloc] init] autorelease];
	[mutableIndexSet addIndex:index];

	[tableView reloadSections:mutableIndexSet withRowAnimation:UITableViewRowAnimationFade];
}

-(void)dealloc {
	[sectionSet release];

	[theCell release];

	[imagesDict release];

	[toggleDict release];

	%orig;
}

%end
