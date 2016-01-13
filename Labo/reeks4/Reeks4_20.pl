use Win32::OLE 'in';
use Win32::OLE::Variant;
my $DateTime = Win32::OLE->new("WbemScripting.SWbemDateTime");

my $ComputerName  = ".";
my $NameSpace = "root/cimv2";
my $WbemServices = Win32::OLE->GetObject("winmgmts://$ComputerName/$NameSpace");
my $ProcessName="Excel.exe";
my $QueryProcess = "Select * From Win32_Process Where Name='$ProcessName'";
my $NameSpaceMS = "root/msapps12";
my $WbemServicesMS = Win32::OLE->GetObject("winmgmts://$ComputerName/$NameSpaceMS"); #lukt niet indien je enkel Office 2010 op je computer staan hebt
my $QueryExcel = "Select * From Win32_ExcelWorkBook";


sub toonproperties{
   my ($object)=shift;
   foreach $prop (in ($object->{"Properties_"})){#,$object->{"SystemProperties_"})){
        my $v=$prop->{Value};       
        schrijf($prop->{Name},$prop->{Isarray}? join(",",@{$v}):$v,$prop->{CimType});
      }
}

sub schrijf{
  my ($name,$value,$type)=@_;
  if ($type !=101) {
      printf "\n\t%s\t=%s (%s)",$name,$value,$type;
  } else {
      if ($value=~/\*\*/){
          $value=~s/\*/0/g;
      }
      $DateTime->{Value} = $value;
      printf "\n\t%s\t=%s (%s)",$name,$DateTime->GetVarDate,$value;
  }
}

sub geefstatus{
    (my $info)=shift;
    print "\n-------- $info -----------------------";
    foreach (in $WbemServices->ExecQuery($QueryProcess)){
       print "\n",$_->name,":",$_->{Handle};
       toonproperties($_);
    }


   foreach (in $WbemServicesMS->ExecQuery($QueryExcel)){
       print "\n",$_->{Path}," (Size= ",$_->{Size},")";
       toonproperties($_);
   }
}

geefstatus("Begin ");

my $Excel =  Win32::OLE->new('Excel.Application', 'Quit');
geefstatus("Nieuwe Excel Applicatie gestart");
my $Excel = Win32::OLE->GetActiveObject('Excel.Application');
geefstatus("Draaiende Excel-applicatie gebruiken");
my $Book = $Excel->Workbooks->Add();
geefstatus("Werkbook toegevoegd");
$Book->Save();
geefstatus("Werkboek opgeslaan");
print "\n\n";


