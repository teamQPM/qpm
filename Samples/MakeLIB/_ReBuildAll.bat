del _ReBuildAll.log

for %%X in (MakeLib*.qac) do call "%%X" -BUILD -lite -forcefull -exit -clear -log(_ReBuildAll.log) -logOnlyError

for %%X in (CheckLib*.qac) do call "%%X" -BUILD -lite -forcefull -exit -clear -log(_ReBuildAll.log) -logOnlyError