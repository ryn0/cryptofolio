# cryptofolio
A cryptocurrency portfolio value calculator 

### This is a script which will calculate the current USD value of a cryptocurrency portfolio at the market rates from [coinmarketcap.com](http://CoinMarketCap.com)

## How To Use

  1. Download the script: crypto_value.ps1 from this git repository (you could just copy and paste the contents to a text file and save as .ps1 if you want).
  2. Open the script in a text editor like notepad or the PowerShell ISE.
  3. Find the id's of the currencies you have by looking at the JSON here: [coinmarketcap.com/v1/ticker](https://api.coinmarketcap.com/v1/ticker/)
  4. Edit the JSON in the script and set your own currency/ value pairings, for example: 
```
 $json = '{"cryptoPortfolio":[
        {"id": "bitcoin",  "amount": .5 },
        {"id": "litecoin", "amount": 4.2 },
        {"id": "ethereum", "amount": 1 },
        {"id": "monero",   "amount": 3 },
        {"id": "stratis",  "amount": 20 }
    ]}'
```
 
   5. Save the script with the id and amounts in your portfolio (make sure this is correct JSON!).
   6. Execute the script for the current market value. You can execute the script by right clicking in Windows and selecting: "Run with PowerShell".
   7. See output
![example image](https://i.imgur.com/6beudDc.png "An exemplary image")

## How To Be Lazy
For added convience, create a shortcut to the script and add it to your taskbar. This way you can just click once and see the value of your portfolio at any time. The target of the shortcut would be something like: 
```
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\scripts\crypto_value.ps1"
```
In the above example, C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe is the path to PowerShell and "C:\scripts\crypto_value.ps1" is the path to the script.
