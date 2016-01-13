use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

#Steeds alle qualifiers ophalen 
my @Classes = @ARGV ? map {$WbemServices->Get($_,wbemFlagUseAmendedQualifiers)} @ARGV
                    : in $WbemServices->ExecQuery("select * from meta_class","WQL",wbemFlagUseAmendedQualifiers);

foreach my $Class (@Classes){
  my $Methods = $Class->{Methods_};
  
  foreach my $Method (in $Methods) {
    if ($Method->Qualifiers_->Item("ValueMap") && $Method->Qualifiers_->Item("Values")) {
      @ReturnValues{@{$Method->Qualifiers_->Item("ValueMap")->{Value}}}
        =@{$Method->Qualifiers_->Item("Values")->{Value}};
      printf "\n%s -- %s (ValueMap)",$Class->{Path_}->{Relpath},$Method->{Name};
      foreach $key (sort {$a <=> $b} keys %ReturnValues) { 
        printf "\n\t%s: %s",$key,$ReturnValues{$key};
      }
    }

    if (!$Method->Qualifiers_->Item("ValueMap") && $Method->Qualifiers_->Item("Values")) {
      @ReturnValues=@{$Method->Qualifiers_->Item("Values")->{Value}};
      printf "\n%s -- %s (Values)",$Class->{Path_}->{Relpath},$Method->{Name};     
      my $i=0;
      foreach (sort {$a <=> $b} @ReturnValues) {
        printf "\n\t%d: %s",$i++,$_;
      }
    }

  }
}


