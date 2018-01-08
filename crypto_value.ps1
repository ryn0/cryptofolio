# see all coins: https://api.coinmarketcap.com/v1/ticker/
 $json = '{"cryptoPortfolio":[
        {"id": "bitcoin",  "amount": .5 },
        {"id": "litecoin", "amount": 4.2 },
        {"id": "ethereum", "amount": 1 },
        {"id": "monero",   "amount": 3 },
        {"id": "stratis",  "amount": 20 }
    ]}'



function Calculate-Portfolio ($holdingsJson) 
{
    $heldAmounts = (ConvertFrom-Json -InputObject $holdingsJson)    

    $format = "{0,-12} {1,15} {2,15} {3,15} {4,5} {5,15} {6,17}"

    $format -f `
        "Coin name", "Amount in USD", "Amount in BTC", "Percentage USD", "Symbol", "USD for Each","Quantity"

    $format -f `
        "---------", "-------------", "-------------", "--------------",     "------","------------",    "--------"
             
    $totalUsd = 0
    $totalBtc = 0

    $Array = New-Object System.Collections.ArrayList

    foreach($holding in $heldAmounts.cryptoPortfolio)
    {
        $nameOfCoin = $holding.id
        $response = Invoke-WebRequest -Uri "https://api.coinmarketcap.com/v1/ticker/$nameOfCoin"
    
        $currentDetails = (ConvertFrom-Json -InputObject $response)  
    
        $currentPriceUsd = [Convert]::ToDecimal($currentDetails.price_usd)
        $heldValueUsd = ($currentPriceUsd * $holding.amount)
        $totalUsd = $totalUsd + $heldValueUsd

        $currentPriceBtc = [Convert]::ToDecimal($currentDetails.price_btc)
        $heldValueBtc = ($currentPriceBtc * $holding.amount)
        $totalBtc = $totalBtc + $heldValueBtc

        $Array.Add($currentDetails) | out-null
    } 
     
    foreach($item in $Array)
    {  
        $holding = $heldAmounts.cryptoPortfolio | where {   $_.id -eq $item.id }

        $currentPriceUsd = [Convert]::ToDecimal($item.price_usd)      
        $heldValueUsd = ($currentPriceUsd * $holding.amount)        
        $formattedValueUsd = "{0:C2}" -f $heldValueUsd
        $percentageUsd =  [math]::Round(( ($heldValueUsd / $totalUsd) * 100),3)

        $currentPriceBtc = [Convert]::ToDecimal($item.price_btc)      
        $heldValueBtc = ($currentPriceBtc * $holding.amount)        
        $formattedValueBtc = $heldValueBtc.ToString("#.########")
        $percentageBtc =  [math]::Round(( ($heldValueBtc / $totalBtc) * 100),3)
 
         
        $format -f `
            $item.id, $formattedValueUsd, $formattedValueBtc, "$percentageUsd%", $item.symbol, ("{0:C4}" -f $currentPriceUsd), ($holding.amount)
    }


    Write-Host "--------------"
    Write-Host "Total USD:"  ("{0:C2}" -f $totalUsd)
    Write-Host "Total BTC:" $totalBtc.ToString("#.########")
    Write-Host "--------------"
    
    Read-Host
}

Calculate-Portfolio -holdingsJson $json