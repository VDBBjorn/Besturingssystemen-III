my $ADOrecordset = $ADOcommand->Execute();
my $x=0;
   until ( $ADOrecordset->{EOF} ) {
      $x++;
      print $x , "\t"
          , $ADOrecordset->Fields("printStaplingSupported")->{Value} , "\t"
          , $ADOrecordset->Fields("printRate")->{Value} , "\t"
          , $ADOrecordset->Fields("printMaxResolutionSupported")->{Value} , "\t"
          , $ADOrecordset->Fields("printerName")->{Value} , "\n";
      $ADOrecordset->MoveNext();
  }
  $ADOrecordset->Close();
  $ADOconnection->Close();

#In PowerShell - vervolg van de LDAP-query:
  
   $sBase       = "LDAP://193.190.126.71/DC=iii,DC=hogent,DC=be";
   $sFilter     = "(&(objectCategory=printQueue)(printColor=TRUE)(printDuplexSupported=TRUE))";
   $sAttributes = "printMaxXExtent,whenChanged,printStaplingSupported,objectClass,printername,adspath,objectGUID"; 
   $sScope      = "subtree";
   $ADOcommand.CommandText = "<$sBase>;$sFilter;$sAttributes;$sScope";
   $ADOcommand.Properties.Item("Sort On").value = "printerName";
   
   $ADOrecordset = $ADOcommand.Execute();

   $ADOrecordset.RecordCount, " AD-objecten";
   $ADOrecordset.Fields.Count," Ldap attributen opgehaald per AD-object";
   
   for($i=0;$i -lt $ADOrecordset.RecordCount;$i++)
   {
      $ADOrecordset.Fields | foreach{
         Write-Host $_.name "(" $_.type ")" $_.value   
      }      
      $ADOrecordset.MoveNext();
    }  


