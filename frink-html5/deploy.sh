echo 'removing old zip file...'
rm frink.zip
echo 'generating new zip...'
\cd 'source'
zip -r frink.zip .
\cd '..'
mv 'source/frink.zip' frink.zip
echo 'compiling source�'
bbwp frink.zip
echo 'deploying to device...'
blackberry-deploy -installApp -password codemonkeylikefritos -device 192.168.1.10 -package 'bin/frink.bar'
echo 'complete!'