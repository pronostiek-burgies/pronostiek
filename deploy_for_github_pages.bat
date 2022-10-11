flutter build web --release --base-href /pronostiek/
echo "build"
xcopy ".\build\web" ".\docs" /E /Y /R