use Win32::OLE::Const;
my $excelAppl = Win32::OLE->GetActiveObject('Excel.Application')
  || Win32::OLE->new('Excel.Application', 'Quit');

#ophalen van argumenten
@ARGV or die "Geef een argument nl. de filenaam van het excel-bestand\n";

my $fso = Win32::OLE->new("Scripting.FileSystemObject");
my $naam=$ARGV[0];

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
print "\naantal werksheets: $book->{Worksheets}->{Count}\n";


