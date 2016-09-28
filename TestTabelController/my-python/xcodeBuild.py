#!/usr/bin/python
# coding:utf-
import os
import fnmatch

buildDirPath = ''

sdkDevice="iphoneos9.3"
sdkSimulator="iphonesimulator9.3"
configuration_array=("Release" "Debug")
arch_array=("iphoneos" "iphonesimulator")
arch_device_array=("armv7" "arm64")
arch_iphonesimulator_array=("i386" "x86_64")

def build_debug(protectPath,ignoreProtects=[]):
    os.chdir(buildDirPath)
    os.system('xcodebuild clean -configuration Debug')
    os.system('xcodebuild -configuration Debug')

protectDirPath = raw_input("请输入工程路径:\r\n")
protectDirPath = protectDirPath.replace(' ','')
for path,secdirs,files in os.walk(protectDirPath):
    for dirName in secdirs:
        if fnmatch.fnmatch(dirName,'*.xcodeproj'):
            print "路径:" + os.path.dirname(os.path.join(path,dirName))
            buildDirPath = os.path.dirname(os.path.join(path,dirName))
            build_debug(buildDirPath)
