#!/bin/bash -e

cd x264 && ./build_android.sh

cd ../ffmpeg-3.2.2 && ./build_android.sh

