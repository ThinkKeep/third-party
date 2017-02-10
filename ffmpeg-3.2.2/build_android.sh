ANDROID_NDK=/opt/android-ndk-r13b
SYSROOT=$ANDROID_NDK/platforms/android-9/arch-arm/
# You should adjust this path depending on your platform, e.g. darwin-x86_64 for Mac OS
TOOLCHAIN=$ANDROID_NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64
CPU=arm
PREFIX=$(pwd)/../android-lib

# Set these if needed
ADDI_CFLAGS="-I$(pwd)/../x264-android/include"
ADDI_LDFLAGS="-L$(pwd)/../x264-android/lib"

./configure \
    --prefix=$PREFIX \
    --disable-shared \
    --enable-static \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-doc \
    --disable-symver \
    --enable-gpl \
    --enable-demuxer=mpegts \
    --disable-decoders \
    --enable-decoder=aac \
    --enable-decoder=h264 \
    --disable-demuxers \
    --disable-parsers \
    --enable-parser=aac \
    --enable-parser=h264 \
    --enable-jni \
    --enable-libx264 \
    --enable-encoder=libx264 \
    --enable-memalign-hack \
    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
    --target-os=linux \
    --arch=arm \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --extra-cflags="-Os -fpic -marm $ADDI_CFLAGS" \
    --extra-ldflags="$ADDI_LDFLAGS"

make clean
make
make install

$TOOLCHAIN/bin/arm-linux-androideabi-ld -rpath-link=$SYSROOT/usr/lib -L$SYSROOT/usr/lib -L$PREFIX/lib -soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so \
    ../x264-android/lib/libx264.a \
    libavcodec/libavcodec.a \
    libavfilter/libavfilter.a \
    libswresample/libswresample.a \
    libavformat/libavformat.a \
    libavutil/libavutil.a \
    libswscale/libswscale.a \
    libpostproc/libpostproc.a \
    libavdevice/libavdevice.a \
    -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker $TOOLCHAIN/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a


