# implementatie bind_object functie: zie sectie 5
use Win32::OLE::Const "Active DS Type Library";  #bibliotheek inladen

$containerAds="CN=Users,DC=iii,DC=hogent,DC=be";
$cont = bind_object($containerAds);
$cont->{filter}=["user"];
foreach $object (in $cont){
    $waarde=$object->{UserAccountControl};
    printf "\n%20s  accountdisabled    ",$object->{cn}  if $object->{AccountDisabled};
    printf " --  bit  %2s staat aan",ADS_UF_ACCOUNTDISABLE if $waarde & ADS_UF_ACCOUNTDISABLE;
    printf "\n%20s  password required ",$object->{cn} if $object->{PasswordRequired};
    printf "  --  bit  %2s staat uit ",ADS_UF_PASSWD_NOTREQD unless $waarde & ADS_UF_PASSWD_NOTREQD;
}



