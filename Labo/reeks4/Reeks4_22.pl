use Win32::OLE 'in';
use Math::BigInt;

my $DirectoryName="c:\\emacs";  #experimenteer met andere waarden
my $ShowLevel = 2;

my $WbemServices = Win32::OLE->GetObject("winMgmts://./root/cimv2");
my $Directory = $WbemServices->Get("Win32_Directory='$DirectoryName'");

#Alternatief met een  query
my $DirectoryName="c:\\\\emacs";  #vier-dubbele \-tekens
my ($Directory) = (in $WbemServices->ExecQuery("Select * From Win32_Directory Where Name='$DirectoryName'"));

DirectorySize($Directory,$ShowLevel);

sub DirectorySize {
   my ($Directory,$Level) = @_;
   my $Size = Math::BigInt->new();

   my $Query = "ASSOCIATORS OF {Win32_Directory='$Directory->{Name}'} WHERE AssocClass=CIM_DirectoryContainsFile";
   $Size += $_->{FileSize} foreach in $WbemServices->ExecQuery($Query);
   my $Query = "ASSOCIATORS OF {Win32_Directory='$Directory->{Name}'} 
                WHERE AssocClass=Win32_SubDirectory Role=GroupComponent";
   $Size += DirectorySize($_,$Level-1) foreach in $WbemServices->ExecQuery($Query);

   printf "%12s%s%s\n", $Size,("\t" x ($ShowLevel-$Level+1)), $Directory->{Name} if $Level >= 0;
   return $Size;
}




