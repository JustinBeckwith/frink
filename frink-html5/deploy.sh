cd source
"C:\Program Files\7-Zip\7za.exe" a -tzip source.zip *
cd ..
move source\source.zip source.zip
bbwp source.zip
blackberry-deploy -installApp -password tartans -device 192.168.177.128 -package bin\source.bar
