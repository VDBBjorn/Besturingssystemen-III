my $ADOrecordset = $ADOcommand->Execute();
Win32::OLE->LastError()&& die (Win32::OLE->LastError());

print $ADOrecordset->{RecordCount}," AD-objecten\n";
print $ADOrecordset->Fields->{Count}," Ldap attributen opgehaald per AD-object\n";

use Win32::OLE::Variant;
use Win32::OLE qw(in);

foreach my $field (in $ADOrecordset->{Fields}) {
   print "\n$field->{name}($field->{type}):";
   $waarde=$field->{value};
   foreach (ref $waarde eq "ARRAY" ? @{$waarde} : $waarde) {
      $field->{type} == 204
         ? printf "\n\t%*v02X ","", $_
         : print  "\n\t$_";
   }
}



