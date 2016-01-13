De rootdirectory die bij de C:partitie hoort

    SELECT * FROM Win32_Directory WHERE name="c:\\"
of
   SELECT * FROM Win32_Directory WHERE name='c:\\'

Je gebruikt best het sleutelattribuut om de instantie te beschrijven. 
Je mag de ' ' of " "-tekens niet weglaten, en backslashen backslashen !

Opmerking: Beide WMI-objecten zijn aan elkaar geassocieerd via de associatorklasse Win32_LogicalDiskRootDirectory. Deze associatorklasse direct ophalen lukt niet omdat de enige attributen een reference-type hebben.


