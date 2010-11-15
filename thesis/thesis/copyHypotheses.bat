copy %1\eps\Anchor_Neighbors_vs_Error-Random-20x20-Square-with-400-nodes-Radius2.5-to-2.5.eps ..\thesis\figures\numneighbors\AnchorNeighborsVsError.eps
copy %1\eps\Anchor_Neighbors_vs_Error-Random-20x20-Square-with-400-nodes-Radius2.5-to-2.5-Excluding2.0.eps ..\thesis\figures\numneighbors\AnchorNeighborsVsErrorExcluding.eps

copy %1\eps\AnchorSetErrors-Random-20x20-Square-with-400-nodes-Radius2.5.eps ..\thesis\figures\numneighbors\AnchorSetErrorVsError.eps
copy %1\eps\AnchorSetErrors-Random-20x20-Square-with-400-nodes-Radius2.5-Excluding2.0.eps ..\thesis\figures\numneighbors\AnchorSetErrorVsErrorExcluding.eps

for %%s in ( Sum Minimum Mean ) do (
  copy %1\eps\%%s_Anchor_Distance_vs_Error-Random-20x20-Square-with-400-nodes-Radius2.5-to-2.5.eps ..\thesis\figures\distances\%%sAnchorDistanceVsError.eps
  copy %1\eps\%%s_Anchor_Distance_vs_Error-Random-20x20-Square-with-400-nodes-Radius2.5-to-2.5-Excluding2.0.eps ..\thesis\figures\distances\%%sAnchorDistanceVsErrorExcluding.eps
)

copy %1\eps\Anchor_Area_vs_Error-Random-20x20-Square-with-400-nodes-Radius2.5-to-2.5.eps ..\thesis\figures\areas\AnchorAreaVsError.eps
copy %1\eps\Anchor_Area_vs_Error-Random-20x20-Square-with-400-nodes-Radius2.5-to-2.5-Excluding2.0.eps ..\thesis\figures\areas\AnchorAreaVsErrorExcluding.eps

copy %1\eps\Minimum_Anchor_Triangle_Height_vs_Error-Random-20x20-Square-with-400-nodes-Radius2.5-to-2.5.eps ..\thesis\figures\heights\AnchorHeightVsError.eps
copy %1\eps\Minimum_Anchor_Triangle_Height_vs_Error-Random-20x20-Square-with-400-nodes-Radius2.5-to-2.5-Excluding2.0.eps ..\thesis\figures\heights\AnchorHeightVsErrorExcluding.eps

