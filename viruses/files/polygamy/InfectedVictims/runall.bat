@echo off
@echo Start now with the dropper

copy E:\victims\vic.* vic.*
pause
cscript gen0.js
echo .
echo .
echo .
copy vic.py inf1.py
pause
copy E:\victims\vic.* vic.*


echo Inf1: python to python
C:\Python33\python.exe inf1.py
echo .
echo .
echo .
copy vic.py inf2.py
pause
copy E:\victims\vic.* vic.*

echo Inf2: python to ruby
C:\Python33\python.exe inf2.py
echo .
echo .
echo .
copy vic.rb inf3.rb
pause
copy E:\victims\vic.* vic.*

echo Inf3: ruby to python
C:\Ruby200\bin\ruby inf3.rb
echo .
echo .
echo .
copy vic.py inf4.py
pause
copy E:\victims\vic.* vic.*

echo Inf4: python to matlab
C:\Python33\python.exe inf4.py
echo .
echo .
echo .
copy vic.m inf5.m
pause
copy E:\victims\vic.* vic.*

echo Inf5: matlab to python
matlab -nodesktop -nosplash -r inf5
echo .
echo .
echo .
copy vic.py inf6.py
pause
copy E:\victims\vic.* vic.*

echo Inf6: python to vbs
C:\Python33\python.exe inf6.py
echo .
echo .
echo .
copy vic.vbs inf7.vbs
pause
copy E:\victims\vic.* vic.*

echo Inf7: vbs to python
cscript inf7.vbs
echo .
echo .
echo .
copy vic.py inf8.py
pause
copy E:\victims\vic.* vic.*

echo Inf8: python to js
C:\Python33\python.exe inf8.py
echo .
echo .
echo .
copy vic.js inf9.js
pause
copy E:\victims\vic.* vic.*

echo Inf9: js to python
cscript inf9.js
echo .
echo .
echo .
copy vic.py inf10.py
pause
copy E:\victims\vic.* vic.*

echo Inf10: python to ruby
C:\Python33\python.exe inf10.py
echo .
echo .
echo .
copy vic.rb inf11.rb
pause
copy E:\victims\vic.* vic.*

echo Inf11: ruby to ruby
C:\Ruby200\bin\ruby inf11.rb
echo .
echo .
echo .
copy vic.rb inf12.rb
pause
copy E:\victims\vic.* vic.*

echo Inf12: ruby to matlab
C:\Ruby200\bin\ruby inf12.rb
echo .
echo .
echo .
copy vic.m inf13.m
pause
copy E:\victims\vic.* vic.*

echo Inf13: matlab to ruby
matlab -nodesktop -nosplash -r inf13
echo .
echo .
echo .
copy vic.rb inf14.rb
pause
copy E:\victims\vic.* vic.*

echo Inf14: ruby to vbs
C:\Ruby200\bin\ruby inf14.rb
echo .
echo .
echo .
copy vic.vbs inf15.vbs
pause
copy E:\victims\vic.* vic.*

echo Inf15: vbs to ruby
cscript inf15.vbs
echo .
echo .
echo .
copy vic.rb inf16.rb
pause
copy E:\victims\vic.* vic.*

echo Inf16: ruby to js
C:\Ruby200\bin\ruby inf16.rb
echo .
echo .
echo .
copy vic.js inf17.js
pause
copy E:\victims\vic.* vic.*

echo Inf17: js to ruby
cscript inf17.js
echo .
echo .
echo .
copy vic.rb inf18.rb
pause
copy E:\victims\vic.* vic.*

echo Inf18: ruby to matlab
C:\Ruby200\bin\ruby inf18.rb
echo .
echo .
echo .
copy vic.m inf19.m
pause
copy E:\victims\vic.* vic.*

echo Inf19: matlab to matlab
matlab -nodesktop -nosplash -r inf19
echo .
echo .
echo .
copy vic.m inf20.m
pause
copy E:\victims\vic.* vic.*

echo Inf20: matlab to vbs
matlab -nodesktop -nosplash -r inf20
echo .
echo .
echo .
copy vic.vbs inf21.vbs
pause
copy E:\victims\vic.* vic.*

echo Inf21: vbs to matlab
cscript inf21.vbs
echo .
echo .
echo .
copy vic.m inf22.m
pause
copy E:\victims\vic.* vic.*

echo Inf22: matlab to js
matlab -nodesktop -nosplash -r inf22
echo .
echo .
echo .
copy vic.js inf23.js
pause
copy E:\victims\vic.* vic.*

echo Inf23: js to matlab
cscript inf23.js
echo .
echo .
echo .
copy vic.m inf24.m
pause
copy E:\victims\vic.* vic.*

echo Inf24: matlab to vbs
matlab -nodesktop -nosplash -r inf24
echo .
echo .
echo .
copy vic.vbs inf25.vbs
pause
copy E:\victims\vic.* vic.*

echo Inf25: vbs to vbs
cscript inf25.vbs
echo .
echo .
echo .
copy vic.vbs inf26.vbs
pause
copy E:\victims\vic.* vic.*

echo Inf26: vbs to js
cscript inf25.vbs
echo .
echo .
echo .
copy vic.js inf27.js
pause
copy E:\victims\vic.* vic.*

echo Inf27: js to vbs
cscript inf27.js
echo .
echo .
echo .
copy vic.vbs inf28.vbs
pause
copy E:\victims\vic.* vic.*

echo Inf28: vbs to js
cscript inf28.vbs
echo .
echo .
echo .
copy vic.js inf29.js
pause
copy E:\victims\vic.* vic.*

echo Inf29: js to js
cscript inf29.js
echo .
echo .
echo .
copy vic.js inf30.js
pause
copy E:\victims\vic.* vic.*

echo Inf30: js to FIN
cscript inf30.js
echo .
echo .
echo .
echo FIN!!
cmd
