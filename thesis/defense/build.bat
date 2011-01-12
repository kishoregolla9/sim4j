del *.aux *.dvi *.lof *.ps *.toc *.tmp *.blg
latex defense
bibtex defense
latex defense
dvips defense
"c:\program files (x86)\miktex 2.8\miktex\bin\ps2pdf.exe" defense.ps
start defense.pdf
