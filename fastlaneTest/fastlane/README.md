fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios fastlaneTest_hoc
```
fastlane ios fastlaneTest_hoc
```
发布fastlaneTest到Fir.im
### ios fastlaneTest2_hoc
```
fastlane ios fastlaneTest2_hoc
```
发布fastlaneTest2到Fir.im
### ios fastlaneTest_release
```
fastlane ios fastlaneTest_release
```
发布fastlaneTest到App Store
### ios fastlaneTest2_release
```
fastlane ios fastlaneTest2_release
```
发布fastlaneTest2到App Store
### ios adhoc
```
fastlane ios adhoc
```
发布指定Target到Fir
### ios release
```
fastlane ios release
```
发布指定Target到AppStore

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
