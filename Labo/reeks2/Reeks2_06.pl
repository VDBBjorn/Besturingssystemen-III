use Win32::OLE::Const;
my $excelAppl = Win32::OLE->GetActiveObject('Excel.Application')
  || Win32::OLE->new('Excel.Application', 'Quit');

my $fso = Win32::OLE->new("Scripting.FileSystemObject");
my $naam = "testbook.xlsx";
my $book;

if ($fso->FileExists($naam)) {
  my $padnaam = $fso->GetAbsolutePathName($naam);
  $book=$excelAppl->{Workbooks}->Open($padnaam); #volledige padnaam
}
else
{
    my $map = $fso->GetAbsolutePathName("."); #de huidige directory
    my $padnaam = $map."\\".$naam;            #bouw de absolute naam
    $book = $excelAppl->{Workbooks}->Add();   #voeg een werkboek toe
    $book->SaveAs($padnaam);                  #bewaar onder de juiste naam
}

#een waarde wijzigen
$nsheet=$book->{Worksheets}->Item(1);
$range=$nsheet->Cells(5,1);
$range->{Value}=20;

for ($i=0;$i<4;$i++){
     for ($j=0; $j < 3; $j++) {
         $mat->[$i][$j]="***";  #zero-based in perl
     }
}
#Value van de juiste range wijzigen
$nsheet->Range($nsheet->Cells(1,1),$nsheet->Cells(4,3))->{Value}=$mat;
$book->Save();


