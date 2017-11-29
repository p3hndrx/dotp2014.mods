$deckpath = "C:\Users\Richard\Desktop\Convert\Lists"
$decks = gci $deckpath

foreach($deck in $decks)
    {
    get-content $deck.fullname | clip.exe
    & 'C:\Users\Richard\Desktop\Convert\Create from Decklist.exe'
    $filename = $deck.Name.ToUpper()

    Write-Host "Missing... $filename"
    read-host 

    rni C:\Users\Richard\Desktop\Convert\DATA_DECKS_1000100_TEMP.XML "$filename.XML"

    }