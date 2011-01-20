del *.aux *.dvi *.lof *.ps *.toc *.tmp *.blg
@rem call copyHypotheses.bat ..\results\2010-9-20_23_46_41-Square-Random-20x20
@rem call copyOutliers.bat
latex thesis
bibtex thesis
latex thesis
dvips thesis
"c:\program files (x86)\miktex 2.8\miktex\bin\ps2pdf.exe" thesis.ps
start thesis.pdf
