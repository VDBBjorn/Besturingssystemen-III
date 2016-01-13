my $RootDSE=bind_object("RootDSE"); #serverless Binding
   $RootDSE->getinfo();
my $domein  = bind_object( $RootDSE->Get("defaultNamingContext") );
my $sBase  = $domein->{adspath};

my $sFilter     = "(&(objectCategory=printQueue)(printColor=TRUE)(printDuplexSupported=TRUE))";
my $sAttributes = "printMaxXExtent,whenChanged,printStaplingSupported,objectClass,printername,adspath,objectGUID";
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   $ADOcommand->{Properties}->{"Sort On"} = "printerName";



