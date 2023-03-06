# Define a function to create a database
function Create-Database($databasePath) {
    $catalog = New-Object -ComObject ADOX.Catalog
    $catalog.Create("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=$databasePath")
}

# Define a function to execute a SQL command
function Invoke-ADOCommand($databasePath, $command) {
    $connection = New-Object -ComObject ADODB.Connection
    $connection.Open("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=$databasePath")
    $connection.Execute($command)
}

# Create a database file named test.accdb in C:\temp folder
Create-Database "C:\temp\test.accdb"

# Create a table named PostData with two fields: ID and Content
Invoke-ADOCommand "C:\temp\test.accdb" "CREATE TABLE PostData (ID COUNTER PRIMARY KEY, Content TEXT)"
