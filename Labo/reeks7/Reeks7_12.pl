#dsquery * "cn=configuration,dc=iii,dc=hogent,dc=be" -filter "(fromServer=*)" -attr objectclass
#onderstaande query geeft geen resultaten
#dsquery * "cn=configuration,dc=iii,dc=hogent,dc=be" -filter "(fromServer=*be)" -attr objectclass

#Vervang in de oplossing enkel de "base" in:
my $RootDSE=bind_object("RootDSE");
   $RootDSE->getinfo();

my $configuration  = bind_object( $RootDSE->Get("configurationNamingContext") );
my $sBase  = $configuration->{adspath};
 
#En geef als argument "fromServer"



