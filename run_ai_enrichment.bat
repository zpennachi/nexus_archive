@echo off
title Map & Manuscript Digital Archive — AI Vision Pipeline
echo ======================================================================
echo   MAP & MANUSCRIPT DIGITAL ARCHIVE — AI VISION PIPELINE
echo   Scholarly Transcription & Multilingual Translation Worker
echo ======================================================================
echo.
echo Select an action:
echo  [1] Process Next Batch (e.g. 50 items)
echo  [2] Process a Specific Collection (e.g. Harissa, Ottoman, Gaza, BNA)
echo  [3] Run Full Daily Quota (~1,400 items unattended)
echo  [4] Run All Unprocessed Items Until Finished
echo.
set /p choice="Enter choice [1-4, Default: 1]: "
if "%choice%"=="" set choice=1

if "%choice%"=="1" (
    set /p count="How many items to process [Default 50]: "
    if "%count%"=="" set count=50
    python "c:\Users\hi\Downloads\maps\image_processor\gemini_vision_enricher.py" %count%
)

if "%choice%"=="2" (
    echo.
    set /p col="Enter exact collection name: "
    set /p count="How many items in this collection (or 'all') [Default all]: "
    if "%count%"=="" set count=all
    python "c:\Users\hi\Downloads\maps\image_processor\gemini_vision_enricher.py" %count% "%col%"
)

if "%choice%"=="3" (
    echo Starting daily batch of 1400 items...
    python "c:\Users\hi\Downloads\maps\image_processor\gemini_vision_enricher.py" 1400
)

if "%choice%"=="4" (
    echo Starting full archive run...
    python "c:\Users\hi\Downloads\maps\image_processor\gemini_vision_enricher.py" all
)

echo.
echo ======================================================================
echo Batch complete! Refresh index.html in your browser to view updates.
echo ======================================================================
pause
