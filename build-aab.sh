if [ ! -n "$1" ]
then
	echo "$0 - require build number"
else
  echo $1
  flutter build appbundle --flavor Staging --build-number=$1
  cp build/app/outputs/bundle/stagingRelease/app-staging-release.aab ~/Desktop/babilon_1.$1.aab
fi
