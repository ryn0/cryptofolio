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

    $format = "{0,-12} {1,15} {2,10} {3,5} {4,15} {5,25}"

    $format -f `
        "Coin name", "Amount in USD", "Percentage", "Symbol", "USD","Amount"

    $format -f `
        "---------", "-------------", "----------", "------", "---", "-----"
             
    $totalUsd = 0

    $Array = New-Object System.Collections.ArrayList

    foreach($holding in $heldAmounts.cryptoPortfolio)
    {
        $nameOfCoin = $holding.id
        $response = Invoke-WebRequest -Uri "https://api.coinmarketcap.com/v1/ticker/$nameOfCoin"
    
        $currentDetails = (ConvertFrom-Json -InputObject $response)  
    
        $currentPriceUsd = [Convert]::ToDecimal($currentDetails.price_usd)

        $heldValue = ($currentPriceUsd * $holding.amount)
        
        $totalUsd = $totalUsd + $heldValue

        $Array.Add($currentDetails) | out-null
    } 
     
    foreach($item in $Array)
    {  
        $currentPriceUsd = [Convert]::ToDecimal($item.price_usd)
       
        $holding = $heldAmounts.cryptoPortfolio | where {   $_.id -eq $item.id }
        $heldValue = ($currentPriceUsd * $holding.amount)
        
        $formattedValue = "{0:C2}" -f $heldValue
        $percentage =  [math]::Round(( ($heldValue / $totalUsd) * 100),2)
         
        $format -f `
            $item.id, $formattedValue, "$percentage%", $item.symbol, ("{0:C2}" -f $currentPriceUsd), ($holding.amount)
    }


    Write-Host "--------------"
    Write-Host "Total:"  ("{0:C2}" -f $totalUsd)
    Write-Host "--------------"
    
    Read-Host
}

Calculate-Portfolio -holdingsJson $json