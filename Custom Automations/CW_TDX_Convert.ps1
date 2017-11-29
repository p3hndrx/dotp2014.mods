#Be sure to use the resize & crop Adobe Droplet

$env:Path = $env:Path + ';D:\Program Files (x86)\M14 Tools\Gibbed Tools\'
$tool = "D:\Program Files (x86)\M14 Tools\Gibbed Tools\Gibbed.Duels.TdxConvert.exe"  #this doesn't typically change
$folder = "C:\temp\download"   #change here


$cards = get-childitem $folder

# $cards.name

foreach ($card in $cards)
{

& Gibbed.Duels.TdxConvert.exe --dxt1 $card.FullName

}
