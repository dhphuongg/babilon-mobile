if [ ! -n "$1" ]
then
	echo "$0 - require build number"
else
  echo $1
  flutter build apk --flavor Dev --build-number=$1
  cp build/app/outputs/flutter-apk/app-dev-release.apk ~/Desktop/babilon_1.$1.apk
fi