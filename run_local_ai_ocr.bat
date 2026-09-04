@echo off
echo =======================================================
echo Local AI Vision OCR & Document Translation Worker
echo Running on NVIDIA GeForce RTX 5070 Ti (CUDA Accelerated)
echo =======================================================
echo.
set /p count="How many images to process in this run (e.g. 25, 100, 500) [Default: 25]: "
if "%count%"=="" set count=25

set /p col="Specific collection name (optional - press Enter for all): "

echo.
echo Starting batch processing for %count% items...
python "c:\Users\hi\Downloads\maps\image_processor\local_vision_ocr.py" %count% "%col%"
echo.
echo Done! Refresh index.html in your browser to view new translations and transcriptions.
pause
