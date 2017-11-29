$folder = "C:\temp\download"  #your download folder from 01
$file = "C:\Users\Richard\Desktop\OGW\list.csv" #get from gatherer-- rename # to "Number"

$folder+"\1.jpg"

$list = import-csv -Delimiter "`t" $file

foreach ($card in $list) 
{
$path = $folder+"\"+$card.Number+".jpg"
$cap = $card.Name.ToUpper()
$newname = $cap+".jpg"
Rename-Item $path -NewName $newname

}


