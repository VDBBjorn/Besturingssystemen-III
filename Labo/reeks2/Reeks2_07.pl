use Win32::OLE qw(in);
use Win32::OLE::Const ".*Excel"; #versie-onafhankelijk - kan problemen geven thuis bij bepaalde Excel-versies

my $excelAppl = Win32::OLE->GetActiveObject('Excel.Application')
    || Win32::OLE->new('Excel.Application', 'Quit');


$excelAppl->{DisplayAlerts}=0;
$excelAppl->{Visible}=1;

my $book = $excelAppl->{Workbooks}->Add();   #voeg een werkboek toe

$sheet=$book->WorkSheets(1);
$sheet->{name}="veelvouden van 2 tot 10" ;
#$range=$sheet->Range("A1:I50"); #beter vervangen door onderstaande regel
$range=$sheet->Range($sheet->Cells(1,1),$sheet->Cells(50,9)); 
$mat = $range->{Value};
$i=1;
foreach my $rij (@$mat) {
     $j=2;
     foreach (@$rij){
         $_=$i*$j if ($i*$j<=100);
         $j++;
     }
     $i++;
}
$range->{Value}=$mat; #Niet cel per cel wegschrijven

$range->Rows(1)->{font}->{bold}=1;


$range->Borders(xlInsideVertical)->{LineStyle} = xlContinuous;
$range->Borders(xlEdgeRight)->{LineStyle} = xlContinuous;
$range->Borders(xlEdgeLeft)->{LineStyle} = xlContinuous;
$range->rows(1)->Borders(xlEdgeBottom)->{LineStyle} = xlContinuous;

#opslaan in voud.xlsx
my $fso = Win32::OLE->new("Scripting.FileSystemObject");
my $map = $fso->GetAbsolutePathName("."); #de huidige directory
my $padnaam = $map."\\voud.xlsx";            #bouw de absolute naam
$book->SaveAs($padnaam);                  #bewaar onder de juiste naam

#Andere oplossing voor de matrix-bewerkingen :
for ($i=1;$i<=100;$i++){
     for ($j=2; $i*$j <= 100; $j++) {
         $mat->[$i-1][$j-2]=$i*$j;
     }
}


