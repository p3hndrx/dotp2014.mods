#$deck = "C:\Users\Richard\Desktop\DECK_NEW_DECK.XML"
#$deck = "C:\users\richard\desktop\DATA_DECKS_1000100_TEMP.XML"
$deck = "C:\Users\Richard\Desktop\DECK_2HGAGGRO.XML"

  


#$deckxml.DECK.AiPersonality.LocalizedNames.LOCALISED_TEXT
$deckxml.DECK.LandPool

$node = $deckxml.SelectNodes("/DECK")
#$deckxml.DECK
#$deckxml.DECK.DECKSTATISTICS  
#$deckxml.DECK.LocalizedDeckNames.LOCALISED_TEXT



#$node.SetAttribute("uid","?")

#$namenode = $deckxml.DECK.LocalizedDeckNames.LOCALISED_TEXT
#$namenode.set_InnerXML("<![CDATA[MYDECK]]>")
#$namepers = $deckxml.DECK.AiPersonality.LocalizedNames.LOCALISED_TEXT
#$namepers.set_InnerXML("<![CDATA[MYDECK]]>")

#$deckxml.save("C:\Users\Richard\Desktop\DECK_GENERATED.XML")



$deckxml = [xml](Get-Content $deck)
                        #set ID
                        $node = $deckxml.SelectNodes("/DECK")
                        $node.SetAttribute("uid","$newID")

                        
                        #write localized name:
                        $newLocal = $deckxml.CreateElement("LocalizedDeckNames")
                        $deckxml.DECK.AppendChild($newLocal)
                        $newLocalText = $deckxml.CreateElement("LOCALISED_TEXT")
                        #$deckxml.DECK.LocalizedDeckNames.AppendChild($newLocalText)
                        $newLocalText.SetAttribute(“LanguageCode”,”en-US”);
                        #$deckxml.DECK.LocalizedDeckNames.LOCALISED_TEXT.set_InnerXML("<![CDATA[MYDECK]]>")
                        

                        

                        $deckxml
                        $deckxml.save("C:\Users\Richard\Desktop\DECK_GENERATED.XML")



 if(($deckxml.DECK.LocalizedDeckNames.LOCALISED_TEXT -eq $null) -or ($deckxml.DECK.AiPersonality.LocalizedNames.LOCALISED_TEXT -eq $null)){
            Write-Host "Deck NAME:`t Not Defined" -f red
            }else{
            Write-Host "Deck NAME:"
            $deckxml.DECK.LocalizedDeckNames.LOCALISED_TEXT
            $deckxml.DECK.AiPersonality.LocalizedNames.LOCALISED_TEXT
            }

$newtext = Get-Content c:\users\Richard\Desktop\DECK_2HGAGGRO.XML
(get-content c:\users\Richard\Desktop\DECK_NEW_DECK.xml).replace('</DECK>', $newtext) | sc c:\users\Richard\Desktop\DECK_NEW_DECK_REPLACED.xml