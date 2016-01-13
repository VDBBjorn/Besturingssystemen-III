use Win32::OLE 'in';
use Win32::OLE::Variant;
use Win32::OLE::Const "Active DS Type Library";
$Win32::OLE::Warn = 1;

@ARGV == 1 or die "geef twee argumenten :  usernaam Ldap-attribuut\n";

#. . . 'implementatie bind_object functie: zie reeks 6, sectie 5
my $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");
   $ADOconnection->{Provider} = "ADsDSOObject";
   $ADOconnection->{Properties}->{"User ID"}          = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Password"}         = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Encrypt Password"} = True;
   $ADOconnection->Open();                                     # mag je niet vergeten
my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");
   $ADOcommand->{ActiveConnection}      = $ADOconnection;    # verwijst naar het voorgaand object
   $ADOcommand->{Properties}->{"Page Size"} = 20;


my $wie=$ARGV[0];
my $prop=$ARGV[1];
my $result = zoek($wie,$prop);

print $result;

$ADOconnection->Close();

sub printlijn {
    my ( $refprefix, $suffix ) = @_;
    printf "%-35s%s\n", $$refprefix, $suffix;
    $$refprefix = "";
}


my $RootDSE=bind_object("RootDSE"); #serverless Binding
   $RootDSE->getinfo();


sub zoek {
    my ($wie,$prop)=@_;
    $domein=bind_object($RootDSE->{defaultNamingContext});
    my $sBase	= $domein->{adspath};
    my $sFilter	= "(&(objectCategory=person)(objectclass=user)(cn=$wie)($prop=*))";
    my $sAttributes = "$prop";
    my $sScope      = "subtree";
    $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
    my $ADOrecordset = $ADOcommand->Execute();

    unless (Win32::OLE->LastError()) {
        unless ( $ADOrecordset->{EOF} ) {
            $waarde=$ADOrecordset->Fields($prop)->{value};
            $type=$ADOrecordset->Fields($prop)->{type};
            $ADOrecordset->Close();
            return bepaalinhoud($waarde,$type);
        }
        return zoekverder($wie,$prop);
    }
    return "$prop($wie) is niet ingesteld";
}

sub zoekverder {
    my ($wie,$prop)=@_;
    $domein=bind_object($RootDSE->{defaultNamingContext});
    my $sBase	= $domein->{adspath};
    my $sFilter	= "(&(objectCategory=person)(objectclass=user)(cn=$wie))";
    my $sAttributes = "cn,adspath";
    my $sScope      = "subtree";
    $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
    my $ADOrecordset = $ADOcommand->Execute();

    unless (Win32::OLE->LastError() || $ADOrecordset->{EOF} ) {
        $Adspath=$ADOrecordset->Fields("AdsPath")->{value};
        $ADOrecordset->Close();
        my $user=bind_object($Adspath);
        $user->GetInfoEx([$prop],0);
        $waarde=$user->GetEx($prop);
        defined $waarde ? return bepaalinhoud($waarde)
            : return "$prop($wie) is niet ingesteld";
    }
    return "$wie is niet gevonden";
}

sub bepaalinhoud{ #gaat voor de meeste types juist
   my ($waarde,$type)=@_;
   my $res="";
   foreach (ref $waarde eq "ARRAY" ? @{$waarde} : $waarde) {
      if ($type == 204){
	 $res=$res.sprintf ("\n\t%*v02X ","", $_)
      }
      elsif (ref $_ eq "Win32::OLE::Variant") {
	 $res=$res."\n\t$_";
      }
      elsif (defined($_->{HighPart}) && defined($_->{LowPart})) {
	 $res=$res.convert_BigInt_string($_->{HighPart},$_->{LowPart});
      }
      else {
	 $res=$res."\n\t$_";
      }
   }
   return $res;
}

use Math::BigInt;
sub convert_BigInt_string{
    my ($high,$low)=@_;
    my $HighPart = Math::BigInt->new($high);
    my $LowPart = Math::BigInt->new($low);
    my $Radix = Math::BigInt->new('0x100000000'); #dit is 2^32
    $LowPart+=$Radix if ($LowPart<0); #als unsigned int interperteren

    return ($HighPart * $Radix + $LowPart);
}


