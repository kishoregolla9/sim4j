del *.aux *.dvi *.lof *.ps *.toc *.tmp *.blg
latex thesis
bibtex thesis
latex thesis
dvips thesis
"c:\program files (x86)\miktex 2.8\miktex\bin\ps2pdf.exe" thesis.ps
start thesis.pdf
