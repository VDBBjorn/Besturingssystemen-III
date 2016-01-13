#. . . implementatie functie bind_object zie sectie 5 in reeks 6

use Win32::OLE qw(in);
use Win32::OLE::Const "Active DS Type Library";

#onderaan staan een aantal nieuwe functies.

@ARGV == 2 or die "geef  het nummer van de eerste en laatste regel op die moeten verwerkt worden\n";

our $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");
   $ADOconnection->{Provider} = "ADsDSOObject";
   $ADOconnection->{Properties}->{"User ID"}          = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Password"}         = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Encrypt Password"} = True;
   $ADOconnection->Open();                                       # mag je niet vergeten

my $RootObj=bind_object("RootDSE"); #serverless Binding
   $RootObj->getinfo();

our $cont=bind_object("ou=...,ou=...,ou=labo,".$RootObj->{defaultNamingContext});

our %samlijst=maakhash($RootObj->{defaultNamingContext},"(samAccountName=*)","samAccountName","adspath","subtree");
my $start=$ARGV[0];
my $eind=$ARGV[1];
my @provincie= qw (Brabant Antwerpen Limburg Luik Namen Luxemburg Henegouwen  WVlaanderen OVlaanderen);

open my $fh, "p8\\stdinwe.out" or die $!;

my $tel=1;
while (<$fh>){
  if ($tel > $start && $tel<$eind){
     @fields = split(/:/);
     $nr=$fields[4]/1000;
     $prov=@provincie[$nr-1];
     my $richt=substr($fields[13],0,6);
     my $gtype=ADS_GROUP_TYPE_DOMAIN_LOCAL_GROUP || ADS_GROUP_TYPE_SECURITY_ENABLED;
     add_groep ($prov,$gtype);

     $gtype=ADS_GROUP_TYPE_GLOBAL_GROUP || ADS_GROUP_TYPE_SECURITY_ENABLED;
     add_groep ($richt,$gtype);
     my $sam=$fields[1];
     my $naam=$fields[2]."_".$fields[3];
     add_user ($prov,$richt,$sam,$naam);

   }
   $tel++;
}
close $fh;
$ADOconnection->close();


sub add_user{
   my ($group1,$group2,$sam,$naam)=@_;
   print "add_user sam=",$sam,"\n";
   if (! exists $samlijst{lc($sam)}){
      local $user=$cont->Create("user", "cn=$sam");
      $user->put ("samAccountName" , $sam);
      $user->{"givenName"}=$naam;
      $user->SetInfo();
      $samlijst{lc($sam)}=$user->{"adspath"};
      print "\tuser $sam toegevoegd \n" unless (Win32::OLE->LastError());
      local $groep=bind_object($samlijst{lc($group1)});
      $groep->Add($user->{"adsPath"});
      print "\t\t-> $group1\n" unless (Win32::OLE->LastError());
      $groep=bind_object($samlijst{lc($group2)});
      $groep->Add($user->{"adsPath"});
      print "\t\t-> $group2\n" unless (Win32::OLE->LastError());
    }
}



sub add_groep{
   my ($sam,$gtype)=@_;
   print "add_groep sam=",$sam,"\n";
   if (! exists $samlijst{lc($sam)}){
      local $groep=$cont->Create("group", "cn=$sam");
      $groep->put ("samAccountName" , $sam);
      $groep->{"grouptype"}=$gtype;
      $groep->SetInfo();

      $samlijst{lc($sam)}=$groep->{"adspath"};
      print "groep $sam toegevoegd\n" unless (Win32::OLE->LastError());
    }
}


sub maakhash{
    my ($dn,$sFilter,$key,$value,$sScope)=@_;
    my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");
       $ADOcommand->{ActiveConnection}      = $ADOconnection;        # verwijst naar het voorgaand object
       $ADOcommand->{Properties}->{"Page Size"} = 20;

    my $sBase  = "LDAP://";
       $sBase .= "193.190.126.71/" unless (uc($ENV{USERDOMAIN}) eq "III");        # als je niet in het domein zelf zit
       $sBase .= $dn;
    my $sAttributes = $key.",".$value;

       $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
    my $ADOrecordset = $ADOcommand->Execute();

    my %samnaam;
    until ( $ADOrecordset->{EOF} ) {
        $samnaam{lc($ADOrecordset->Fields($key)->{Value})}
                 =$ADOrecordset->Fields($value)->{Value};
        $ADOrecordset->MoveNext();
    }

    $ADOrecordset->Close();

    return %samnaam;
}



