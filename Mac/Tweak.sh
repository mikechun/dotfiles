#!/usr/bin/env bash
# A script for tweaking various preferences of Mac OS X and apps
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2012-07-05
# See-Also: http://secrets.blacktree.com/
# See-Also: http://osxdaily.com/tag/defaults-write/
# See-Also: https://github.com/mathiasbynens/dotfiles/blob/master/.osx
set -eu

fontSerif='Palatino'
fontSansSerif='Lucida Grande'
fontMonospace='Envy Code R'

defaults write com.apple.dock showhidden -boolean true
defaults write com.apple.dock mouse-over-hilite-stack -boolean true
defaults write com.apple.dock mineffect -string suck
defaults write com.apple.dock expose-animation-duration -float 0.17
# Hot Corners with Cmd+[tb][lr] (inspired by http://macmule.com/2011/03/08/set-start-screen-saver-to-a-hot-corner/)
# domain=com.apple.Dock; for key in wvous-{b,t}{l,r}-{corner,modifier}; do echo defaults write $domain $key $(defaults read $domain $key); done
#defaults write com.apple.Dock wvous-tl-corner   5
#defaults write com.apple.Dock wvous-tl-modifier 1048576
#defaults write com.apple.Dock wvous-bl-corner   10
#defaults write com.apple.Dock wvous-bl-modifier 1048576
#defaults write com.apple.Dock wvous-br-corner   6
#defaults write com.apple.Dock wvous-br-modifier 1048576
#defaults write com.apple.Dock wvous-tr-corner   7
#defaults write com.apple.Dock wvous-tr-modifier 1048576
# However, a better way is to use AppleScript
osascript -e '
tell application "System Events" to tell expose preferences
	tell top left screen corner
		set activity to start screen saver
		set modifiers to {command}
	end tell
	tell bottom left screen corner
		set activity to sleep display
		set modifiers to {command}
	end tell
	tell bottom right screen corner
		set activity to disable screen saver
		set modifiers to {command}
	end tell
	tell top right screen corner
		set activity to dashboard
		set modifiers to {command}
	end tell
end tell
'
killall Dock

defaults write com.apple.finder ShowPathBar -boolean true
defaults write com.apple.finder PathBarRootAtHome -boolean true
defaults write com.apple.finder QLEnableTextSelection -bool TRUE                # Allow text selection in Quick Look
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false      # Disable the warning when changing a file extension
defaults write com.apple.desktopservices DSDontWriteNetworkStores true          # No .DS_Store on network volumes
killall Finder

if [[ -n "$(fc-list "$fontMonospace" 2>/dev/null)" ]]; then
    defaults write org.n8gray.QLColorCode font "$fontMonospace"
    defaults write org.n8gray.QLColorCode fontSizePoints 10
fi
qlmanage -r >/dev/null

# http://brettterpstra.com/2011/12/04/quick-tip-repeat-cocoa-text-actions-emacsvim-style/
defaults write -g NSRepeatCountBinding -string "^u"
defaults write -g NSTextKillRingSize 4
defaults write -g NSTextShowsControlCharacters -bool true
#defaults write -g InitialKeyRepeat 15;
#defaults write -g KeyRepeat 1;
defaults write -g ApplePressAndHoldEnabled -boolean false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g AppleShowAllExtensions -boolean true
defaults write -g AppleMiniaturizeOnDoubleClick -bool true
defaults write -g NSScrollAnimationEnabled -bool false
defaults write -g NSWindowResizeTime -float 0.001
defaults write -g NSRecentDocumentsLimit 8
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false         # Don't save to iCloud by default
defaults write -g NSNavPanelExpandedStateForSaveMode -boolean true      # Expand save panel by default
defaults write -g PMPrintingExpandedStateForPrint -bool true            # Expand printer panel by default
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# trackpad configs
defaults -currentHost write -g com.apple.mouse.tapBehavior 3
defaults -currentHost write -g com.apple.mouse.swapLeftRightButton -bool false
defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool true
defaults -currentHost write -g com.apple.trackpad.trackpadCornerClickBehavior -bool false
defaults -currentHost write -g com.apple.trackpad.twoFingerDoubleTapGesture -bool true
defaults -currentHost write -g com.apple.trackpad.scrollBehavior 2
defaults -currentHost write -g com.apple.trackpad.momentumScroll -bool true
defaults -currentHost write -g com.apple.trackpad.ignoreTrackpadIfMousePresent -bool false
defaults -currentHost write -g com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture 3
defaults -currentHost write -g com.apple.trackpad.pinchGesture -bool true
defaults -currentHost write -g com.apple.trackpad.rotateGesture -bool true
defaults -currentHost write -g com.apple.trackpad.threeFingerTapGesture 0
defaults -currentHost write -g com.apple.trackpad.threeFingerDragGesture -bool false
defaults -currentHost write -g com.apple.trackpad.threeFingerHorizSwipeGesture 0
defaults -currentHost write -g com.apple.trackpad.threeFingerVertSwipeGesture 0
defaults -currentHost write -g com.apple.trackpad.fourFingerHorizSwipeGesture 2
defaults -currentHost write -g com.apple.trackpad.fourFingerPinchSwipeGesture 2
defaults -currentHost write -g com.apple.trackpad.fourFingerVertSwipeGesture 2

defaults write com.apple.Safari WebKitDeveloperExtras -boolean true
defaults write com.apple.Safari WebKitWebGLEnabled -boolean true
defaults write com.apple.Safari IncludeDebugMenu -boolean true
# http://hints.macworld.com/article.php?story=20120731105734626
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2StandardFontFamily "$fontSansSerif"
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DefaultFontSize 18
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2FixedFontFamily "$fontMonospace"
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DefaultFixedFontSize 16

defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false  # Copy email addresses without the names

defaults write com.apple.Terminal SecureKeyboardEntry -bool true

# How to show Dictionary definitions first in Spotlight results
# See-Also: http://apple.stackexchange.com/a/52530
if ! defaults read com.apple.spotlight orderedItems 2>/dev/null | grep -q MENU_DEFINITION; then
    spotlightPlist=~/Library/Preferences/com.apple.spotlight.plist
    if [ -e $spotlightPlist ]; then
        defaults write com.apple.spotlight orderedItems -array-add '{"enabled"=true;"name"="MENU_DEFINITION";}'
    else
        plutil -convert binary1 -o $spotlightPlist -- - <<<\
'{"version":2'\
',"orderedItems":'\
'[{"enabled":true,"name":"MENU_DEFINITION"}'\
',{"enabled":true,"name":"APPLICATIONS"}'\
',{"enabled":true,"name":"SYSTEM_PREFS"}'\
',{"enabled":true,"name":"DOCUMENTS"}'\
',{"enabled":true,"name":"DIRECTORIES"}'\
',{"enabled":true,"name":"MESSAGES"}'\
',{"enabled":true,"name":"CONTACT"}'\
',{"enabled":true,"name":"EVENT_TODO"}'\
',{"enabled":true,"name":"IMAGES"}'\
',{"enabled":true,"name":"PDF"}'\
',{"enabled":true,"name":"BOOKMARKS"}'\
',{"enabled":true,"name":"MUSIC"}'\
',{"enabled":true,"name":"MOVIES"}'\
',{"enabled":true,"name":"FONTS"}'\
',{"enabled":true,"name":"PRESENTATIONS"}'\
',{"enabled":true,"name":"SPREADSHEETS"}'\
']}'
    fi
    open /System/Library/PreferencePanes/Spotlight.prefPane
fi
