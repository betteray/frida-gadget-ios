#!/bin/bash

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

FRIDA_GADGET_VERSION=$(get_latest_release "frida/frida")
FRIDA_GADGET="frida-gadget-$FRIDA_GADGET_VERSION-ios-universal.dylib"

FRIDA_GADGET_FILENAME="libfrida-gadget.dylib"
FRIDA_GADGET_CONFIG_FILENAME="libfrida-gadget.config"
FRIDA_GADGET_CYDIA_CONFIG_FILENAME="libfrida-gadget.plist"

make_clean() {
    rm -f $FRIDA_GADGET
    rm -f $FRIDA_GADGET.xz
    rm -f _/DEBIAN/control
    rm -f _/Library/MobileSubstrate/DynamicLibraries/$FRIDA_GADGET_FILENAME
    rm -f _/Library/MobileSubstrate/DynamicLibraries/$FRIDA_GADGET_CONFIG_FILENAME
    rm -f _/Library/MobileSubstrate/DynamicLibraries/$FRIDA_GADGET_CYDIA_CONFIG_FILENAME
}

download_gadget() {
    wget -c "https://github.com/frida/frida/releases/download/$FRIDA_GADGET_VERSION/$FRIDA_GADGET.xz" \
    && xz -d "$FRIDA_GADGET.xz" \
    && mv frida-gadget-$FRIDA_GADGET_VERSION-ios-universal.dylib _/Library/MobileSubstrate/DynamicLibraries/$FRIDA_GADGET_FILENAME
}

save_config() {
    echo    "{" >> _/Library/MobileSubstrate/DynamicLibraries/$FRIDA_GADGET_CONFIG_FILENAME
    echo    "    \"interaction\": {" >> _/Library/MobileSubstrate/DynamicLibraries/$FRIDA_GADGET_CONFIG_FILENAME
    echo    "        \"type\": \"script-directory\"," >> _/Library/MobileSubstrate/DynamicLibraries/$FRIDA_GADGET_CONFIG_FILENAME
    echo    "        \"on_change\": \"reload\"," >> _/Library/MobileSubstrate/DynamicLibraries/$FRIDA_GADGET_CONFIG_FILENAME
    echo    "        \"path\": \"/Library/MobileSubstrate/DynamicLibraries/scripts\"" >> _/Library/MobileSubstrate/DynamicLibraries/$FRIDA_GADGET_CONFIG_FILENAME
    echo    "    }" >> _/Library/MobileSubstrate/DynamicLibraries/$FRIDA_GADGET_CONFIG_FILENAME
    echo    "}" >> _/Library/MobileSubstrate/DynamicLibraries/$FRIDA_GADGET_CONFIG_FILENAME

    echo    "{ Filter = { Bundles = ( \"com.apple.UIKit\" ); }; }" >> _/Library/MobileSubstrate/DynamicLibraries/$FRIDA_GADGET_CYDIA_CONFIG_FILENAME
}

save_control() {
    echo    "Package: me.thepapaya.fridagadget" >> _/DEBIAN/control
    echo    "Name: frida-gadget" >> _/DEBIAN/control
    echo    "Depends: mobilesubstrate" >> _/DEBIAN/control
    echo    "Architecture: iphoneos-arm" >> _/DEBIAN/control
    echo    "Description: frida gadget script directory mode for ui-app." >> _/DEBIAN/control
    echo    "Maintainer: ray" >> _/DEBIAN/control
    echo    "Author: ray" >> _/DEBIAN/control
    echo    "Section: Tweaks" >> _/DEBIAN/control
    echo    "Version: $FRIDA_GADGET_VERSION" >> _/DEBIAN/control
    echo    "Depiction: https://thepapaya.me/cydia/depictions/?p=me.thepapaya.fridagadget" >> _/DEBIAN/control
}


$(make_clean)
$(save_config)
$(save_control)
$(download_gadget)

# make package
find ./_ -name ".DS_Store" -delete

rm -rf ./out
mkdir out

perl $THEOS/bin/dm.pl ./_ "out/me.thepapaya.fridagadget_${FRIDA_GADGET_VERSION}_iphoneos-arm.deb"