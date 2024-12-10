# Group 7 Mobile Programming
This repo is just for group 7 Mobile Programming subjects in UIN Malang

## How to use?
First, of course you should clone this repo. <br>

Then, take a look at `assets` folder. In that assets, there's have file named `.env.example`. Fill your odoo credentials there and rename it into `.env`. <br>

After doing that, now use this command to get packages : 
```bash
flutter pub get --no-example
```
<br>

If everything is done, now, try to run it :
```bash
flutter run
```
or, if you have visual studio code and flutter extensions, simply you can run or debug from that :) <br> <br>

Don't forget to rename your model of course :) <br> <br>
Have any problem with register?
Try this one, take a look at `lib/pages/auth/register.dart`,
Remove this following statement : 
```dart
'sel_groups_1_10_11': 11,
'in_group_12': true
```

## How to build?
Make sure you have the packages. If not, use this command
```bash
flutter pub get --no-example
```
After doing that, make sure to generate the key, use this command
```bash
keytool -genkey -v -keystore kel7_key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias kel7-alias
```

Input the password that you want, but, take a look at this : 
```dart
signingConfigs {
        release {
            keyAlias 'kel7-alias'
            keyPassword '123456'
            storeFile file('../../kel7_key.jks')
            storePassword '123456'
        }
    }
```

Don't change anything except keyPassword, and change that what you want as same as your key generated.

After that, run this command : <br>
for android,
```bash
flutter build apk --release --target-platform=android_arm64
```

for windows,
```bash
flutter build windows --release
```