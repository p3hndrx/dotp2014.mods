$path = "C:\Users\Richard\Google Drive\MtG\Assets\Powershell Commands\DeckFix_src"
$approot = "D:\Program Files (x86)\Steam\steamapps\common\Magic 2014"

clear

Write-Host "`n
*************************************`n
***WELCOME TO DotPW DeckFix Script***`n
*************************************`n"

#MENU
function menu {
    Do {
    Write-Host " 
-----M14 DeckFix Operations--- 
1 = Exit 
2 = View Information
3 = Load File
4 = View Attributes
5 = Write Attributes
------------------------------"

    $choice1 = read-host -prompt "Select number & press enter" } 
 until ($choice1 -eq "1" -or $choice1 -eq "2" -or $choice1 -eq "3" -or $choice1 -eq "4"  -or $choice1 -eq "5")

 
Switch ($choice1) 
    { 
    #EXIT
    "1" {
        Exit-PSSession 
        clear
        } #end 1
    #VIEW INFO
    "2" {
        clear
        Write-Host "`n`n Application Root:" $approot

        if($source -eq $null){
        Write-Host "`n Loaded Deck:  NONE" -f red
           }else{
        Write-Host "`n Loaded Deck:" $source -f green
        }

        Write-Host "`n Template Path:" $path -f yellow
        Write-Host "`n Searching for files..."
        
            #header template
            $header = "$path\DeckFix_Header"
            Write-Host "Looking for HEADER... `t`t" (Test-Path $header)

            #personality template
            $personality = "$path\AI-Blue"
            Write-Host "Looking for PERSONALITY... `t" (Test-Path $personality)

            #land template
            $landcfg = "$path\DeckFix_LandPool"
            Write-Host "Looking for LandPool... `t" (Test-Path $landcfg)
              
            if(!(Test-Path $header) -OR !(Test-Path $personality) -OR !(Test-Path $landcfg)) {
            Write-Host "You may need to update your Template Path" -f red
            
          

        #ask to change path (if applicable)
            Do {
            Write-Host "`n`nDo you wish to change the Default Template Path?"
            $choice2 = read-host -prompt "Y/N"
            } 
            until ($choice2 -eq "Y" -or $choice2 -eq "N")

            Switch ($choice2) { 
                "Y" {
                    $target = $null
                    while ($target -eq $null){
                    $target = read-host "Enter source directory name"
                    if (-not(test-path $target)){
                    Write-host "Invalid directory path." -f "red"
                    $target = $null
                            }
                    elseif (-not (get-item $target).psiscontainer){
                    Write-host "Target must be a directory." -f "red"
                    $target = $null
                            }
                        }
                    $path = $target
                    Write-host "Changed Template Path to:" $path -f "green"
                    menu

                    }
                "N" {
                clear
                menu
                    }
                }
                }
        menu
        } #end 2
    #LOAD FILE
    "3" {
        Do{
        $choice3 = read-host -prompt "Any unsaved DECKS will be overridden-- Are you sure? Y/N"
        }
        until ($choice3 -eq "Y" -or $choice3 -eq "N")

 
        Switch ($choice3) 
            { 
            "Y"{
                #load deck
                $source = $null

                while ($source -eq $null){
                $source = read-host "`nSource File (XML):"
                if (-not(test-path $source)){
                    Write-host "Invalid file path."
                    $source = $null
                    }
                elseif ((get-item $source).psiscontainer){
                    Write-host "Source must be a file."
                    $source = $null
                    }
                }
                clear
                $deck = $source
                Write-host "Loaded Deck..." $deck -f "green"
                menu
                }
            "N"{
                clear
                Write-Host "Load Deck Cancelled"
                Write-host "Current Deck:" $source -f "green"
                menu
                }
            }
        } #end 3
    #VIEW ATTRIBUTES
    "4" {
        clear
        if($source -eq $null){
            Write-Host "`n Loaded Deck:  NONE" -f red
            menu
            }else{
            
            $deckxml = [xml](Get-Content $deck)
            Write-Host "LISTING ATTRIBUTES:"
            Write-Host "Filename: $deck`n"
            Write-Host "UID:" $deckxml.DECK.uid      
            Write-Host "LandPool ID:" $deckxml.DECK.LandPool.DECK.uid           
            
            #check for names
             if (($deckxml.DECK.LocalizedDeckNames.LOCALISED_TEXT.InnerText -eq $null) -OR ($deckxml.DECK.AiPersonality.LocalizedNames.LOCALISED_TEXT.InnerText -eq $null)) {
                Write-Host "Deck Name:  NO NAMESLOADED" -f red   
                }else{
                Write-Host "Deck Name:" $deckxml.DECK.LocalizedDeckNames.LOCALISED_TEXT.InnerText
                Write-Host "AI Personality Name:" $deckxml.DECK.AiPersonality.LocalizedNames.LOCALISED_TEXT.InnerText
                }

            #check for stats
            Write-Host "Deck STATS:`n"
            Write-Host "`tSize:`t" $deckxml.DECK.DECKSTATISTICS.size
            Write-Host "`tSpeed:`t" $deckxml.DECK.DECKSTATISTICS.speed
            Write-Host "`tFlex:`t" $deckxml.DECK.DECKSTATISTICS.flex
            Write-Host "`tSyn:`t" $deckxml.DECK.DECKSTATISTICS.syn "`n"
            
            #check for personality
             if($deckxml.DECK.AiPersonality -eq $null){
                Write-Host "AI Persona:  NONE" -f red   
                }else{
                Write-Host "AI Persona:" $deckxml.DECK.AiPersonality.PLANESWALKER_NAME_TAG.string -f green
                }

               
             #check for landpool
             if($deckxml.DECK.LandPool -eq $null){
                Write-Host "LandPool:  NONE" -f red   
                }else{
                Write-Host "LandPool:  Found" -f green
                }
             #check for images 
             if($deckxml.DECK.DeckBoxImage -eq $null){
                Write-Host "DeckBoxImage:  NONE" -f red   
                }else{
                Write-Host "DeckBoxImage:  Found" -f green
                }

            menu
            }
        } #end 4
    "5" {
        clear
        if($source -eq $null){
            Write-Host "`n Loaded Deck:  NONE" -f red
            menu
            }else{
                 #collect info
                 $newname = read-host -prompt "Deck Name:"
                 $newID = read-host -prompt "ID:"
                 $newSize = read-host -prompt "Size [1-10]:`t"
                 $newSpeed = read-host -prompt "Speed [1-10]:`t"
                 $newFlex = read-host -prompt "Flex [1-10]:`t"
                 $newSyn = read-host -prompt "Synergy [1-10]:`t"
                 
                 #pick a persona
                 Do{
                 $newPersona = read-host -prompt "Select AIPersona [B,U,G,R,W]" } 
                 until ($newPersona -eq "B" -or $newPersona -eq "U" -or $newPersona -eq "G" -or $newPersona -eq "R"  -or $newPersona -eq "W")

                 Switch ($newPersona) 
                   { 
                    "B" {
                        $aipersonality = [xml] (Get-Content "$path\AI-Black")
                        $ainame = "Black"
                        }
                    "U" {
                        $aipersonality = [xml] (Get-Content "$path\AI-Blue")
                        $ainame = "Blue"
                        }
                    "G" {
                        $aipersonality = [xml] (Get-Content "$path\AI-Green")
                        $ainame = "Green"
                        }
                    "R" {
                        $aipersonality = [xml] (Get-Content "$path\AI-Red")
                        $ainame = "Red"
                        }
                    "W" {
                        $aipersonality = [xml] (Get-Content "$path\AI-White")
                        $ainame = "White"
                        }
                   } #END PERSONA SWITCH
                 
                 #pick a deckboximage
                 Do{
                 $newDBI = read-host -prompt "Select DeckBoxImage[1=TL, 2=EDH, 3=60, N=Nicky LtD]" } 
                 until ($newDBI -eq "1" -or $newDBI -eq "2" -or $newDBI -eq "3" -or $newDBi -eq "N")

                 Switch ($newDBI) 
                   { 
                    "1" {
                        $boximage = [xml] (Get-Content "$path\DeckBox_TL")
                        $boxname = "Tiny Leader"
                        }
                    "2" {
                        $boximage = [xml] (Get-Content "$path\DeckBox_EDH")
                        $boxname = "EDH"                        }
                    "3" {
                        $boximage = [xml] (Get-Content "$path\DeckBox_60")
                        $boxname = "60-card"                        }
                    "N" {
                        $boximage = [xml] (Get-Content "$path\DeckBox_NKY")
                        $boxname = "Special Edition: Nicky"                        }
                   } #END DeckBoxImage SWITCH
                
                clear
                
                #confirmation
                Write-Host "`nThe following changes will be made:"
                Write-Host "New  Name:" $newName
                Write-Host "Set UID/ID:" $newID
                 $newlandID = [int]$newID + 1
                Write-Host "Set Land UID:" $newlandID
                Write-Host "Stats:`n"
                Write-Host "Size:`t" $newSize "`nSpeed:`t" $newSpeed "`nFlex:`t" $newFlex "`nSyn:`t" $newSyn
                Write-Host "`nPersona: `t"$ainame
                Write-Host "DeckBoxImage: " $boxname

                #confirm
                Do{
                $choice4 = read-host -prompt "Do you wish to store these values? Y/N" }
                until ($choice4 -eq "Y" -or $choice4 -eq "N")
 
                Switch ($choice4) 
                    { 
                    "Y"{
                        #load contents of deck
                        $deckxml = [xml](Get-Content $deck)

                        #write deckUID
                        $node = $deckxml.SelectNodes("/DECK")
                        $node.SetAttribute("uid","$newID")
                        $node.SetAttribute("tus_save_data_id","$newID")

                        #set Deckstatistics
                        $statnode = $deckxml.SelectNodes("/DECK/DECKSTATISTICS")
                        $statnode.SetAttribute("Size","$newSize")
                        $statnode.SetAttribute("Speed","$newSpeed")
                        $statnode.SetAttribute("Flex","$newFlex")
                        $statnode.SetAttribute("Syn","$newSyn")

                        #write LocalXML
                        $local = [xml] (Get-Content "$path\DeckFix_Header")
                        Foreach ($node in $local.DocumentElement) {
                            $deckxml.DocumentElement.AppendChild($deckxml.ImportNode($node, $true))
                        }
                        #setName of DECK
                        $namenode = $deckxml.DECK.LocalizedDeckNames.LOCALISED_TEXT
                        $namenode.set_InnerXML("<![CDATA[$newName]]>")


                        #write LandPool
                        $landpool = [xml] (Get-Content "$path\DeckFix_LandPool")
                        Foreach ($node in $landpool.DocumentElement) {
                            $deckxml.DocumentElement.AppendChild($deckxml.ImportNode($node, $true))
                        }
                        #write landPOOL ID
                        $landnode = $deckxml.SelectNodes("/DECK/LandPool/DECK")
                        $landnode.SetAttribute("uid","$newlandID")
                        $landnode.SetAttribute("tus_save_data_id","$newlandID")

                        #write AI Personality   
                        Foreach ($node in $aipersonality.DocumentElement) {
                                $deckxml.DocumentElement.AppendChild($deckxml.ImportNode($node, $true))
                            }
                        #setName of Personality
                        $namepers = $deckxml.DECK.AiPersonality.LocalizedNames.LOCALISED_TEXT
                        $namepers.set_InnerXML("<![CDATA[$newName]]>")

                        #write DeckBoxImage   
                        Foreach ($node in $boximage.DocumentElement) {
                                $deckxml.DocumentElement.AppendChild($deckxml.ImportNode($node, $true))
                            }
                        



                        #save after done
                        
                        $deckxml.save("C:\Users\Richard\Desktop\DATA_DECK_$newName.xml")
                        $deck = "C:\Users\Richard\Desktop\DATA_DECK_$newName.xml"
                        Write-host "Values Written to Deck..." -f "green"
                        menu
                        }
                    "N"{
                        clear
                        Write-Host "Attribute Update Cancelled"
                        Write-host "Current Deck:" $deck -f "green"
                        menu
                        }
                    }
            }
        } #end 5
    } #end switch
} #end menu
menu

