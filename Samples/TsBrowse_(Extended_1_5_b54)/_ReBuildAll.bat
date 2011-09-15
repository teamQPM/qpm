del _ReBuildAll.log

for %%X in (*.qac) do call "%%X" -BUILD -lite -forcefull -exit -clear -log(_ReBuildAll.log) -logOnlyError