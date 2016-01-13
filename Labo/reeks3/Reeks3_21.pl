SELECT *
FROM   Win32_Process
WHERE  Workingsetsize > 10000000
  OR  (WriteOperationCount > ReadOperationCount
       And ThreadCount >= 10)

Je kan ook een lijst met gewenste attributen opgeven, maar dat heeft geen effect op de performantie:
      SELECT Name,Workingsetsize,WriteOperationCount,ReadOperationCount,ThreadCount ....

