for %%s in ( 7 8 9 10 ) do (
  copy ..\results\20100930_162118_Square-Random-10x10-20Sets-10Nets\AnchorSet6\Network%%s\eps\networkcontours\NetContours-R2.5-Rank1-AnchorSet1.eps figures\outliers\AS6\AS6NetworkContour%%s.eps 
  copy ..\results\20100930_162118_Square-Random-10x10-20Sets-10Nets\AnchorSet6\Network%%s\eps\networkdiffs-nostats\NetDiff-R2.5-Rank1-AnchorSet1.eps figures\outliers\AS6\AS6NetworkDiff%%s.eps
)

