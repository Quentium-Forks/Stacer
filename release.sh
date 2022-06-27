#!/bin/bash
VERSION=1.2.0
RELEASE=release
DIR=stacer-$VERSION

rm -rf $RELEASE build
mkdir $RELEASE build
cd build
cmake -DCMAKE_BUILD_TYPE=debug -DCMAKE_CXX_COMPILER=g++ -DCMAKE_PREFIX_PATH=/opt/qt515 ..
make -j $(nproc)
cd ..

mkdir $RELEASE/$DIR/stacer -p
cp -r icons applications debian $RELEASE/$DIR
cp -r build/output/* $RELEASE/$DIR/stacer

# translations
/opt/qt515/bin/lupdate stacer/stacer.pro -no-obsolete
/opt/qt515/bin/lrelease stacer/stacer.pro
mkdir $RELEASE/$DIR/stacer/translations
mv translations/*.qm $RELEASE/$DIR/stacer/translations

# linuxdeployqt
wget -cO lqt "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod +x lqt
unset QTDIR
unset QT_PLUGIN_PATH
unset LD_LIBRARY_PATH
cp $RELEASE/$DIR/icons/hicolor/256x256/apps/stacer.png $RELEASE/$DIR/stacer/stacer.png
./lqt $RELEASE/$DIR/applications/stacer.desktop -unsupported-allow-new-glibc
./lqt $RELEASE/$DIR/stacer/stacer -bundle-non-qt-libs -no-translations -unsupported-allow-new-glibc -appimage
mv Stacer-*.AppImage $RELEASE/
rm lqt

if [ "$1" == "deb" ]; then
    cd $RELEASE/$DIR
    dh_make --createorig --indep --yes
    debuild --no-lintian -us -uc
fi
