#dsquery * "cn=Schema,cn=configuration,dc=iii,dc=hogent,dc=be" -filter "(defaultobjectCategory=*)" 
#          -attr ldapdisplayname defaultObjectCategory

#. . . 'implementatie bind_object functie: zie reeks 6, sectie 5

use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

my $RootDSE=bind_object("RootDSE"); #serverless Binding
   $RootDSE->getinfo();
   
my $schema=bind_object($schema->{adspath}); #bevat de volledige bind-string

my %lijst;  # keys %lijst   : alle objectcategorieen
            # @{$lijst{$_}} : alle ldapdisplaynamen met $_ als defaultobjectcategory

sub zonder_LDAP {
    print "\nzonder LDAP-query:\n\nEven geduld !!!\n\n";
    $schema->{filter}=["classSchema"];
    foreach (in $schema) {
        $_->Get("defaultobjectcategory") =~ /.*?=(.*?),/;
        push @{$lijst{$1}},$_->{ldapdisplayname};
    }
}

sub met_LDAP{
    print "\nmet LDAP-query: ";
    my $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");
       $ADOconnection->{Provider} = "ADsDSOObject";
       $ADOconnection->{Properties}->{"User ID"}          = ". . ."; # vul in of zet in commentaar
       $ADOconnection->{Properties}->{"Password"}         = ". . ."; # vul in of zet in commentaar
       $ADOconnection->{Properties}->{"Encrypt Password"} = True;
       $ADOconnection->Open();                                     # mag je niet vergeten
    my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");
       $ADOcommand->{ActiveConnection}        = $ADOconnection;    # verwijst naar het voorgaand object
       $ADOcommand->{Properties}->{"Page Size"} = 20;

    my $sBase  = $RootDSE->{schemaNamingContext};
    my $sFilter = "(&(objectCategory=classSchema)(defaultobjectcategory=*))";
    my $sAttributes = "ldapdisplayname,defaultobjectcategory";
    my $sScope      = "OneLevel";
       $ADOcommand->{Properties}->{"Sort On"} = "cn";
       $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
    
        my $ADOrecordset = $ADOcommand->Execute();
        until ( $ADOrecordset->{EOF} ){
               $ADOrecordset->Fields("defaultobjectcategory")->{Value} =~ /.*?=(.*?),/;
               push @{$lijst{$1}},$ADOrecordset->Fields("ldapdisplayname")->{Value};
               $ADOrecordset->MoveNext();
        }
        $ADOrecordset->Close();
        $ADOconnection->Close();
}

#met_LDAP();
#zonder_LDAP();

print "\n\nobjectCategory $_ als default ingesteld voor ", 
              scalar @{$lijst{$_}}, " klassen:\n\t", join("\n\t",@{$lijst{$_}})
	foreach grep {@{$lijst{$_}} > 1} keys %lijst;




