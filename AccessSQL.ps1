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


# Create a database connection
$conn = New-Object -ComObject ADODB.Connection
$conn.Open("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=C:\temp\test.accdb")

# Create a record set
$rs = New-Object -ComObject ADODB.RecordSet

# Execute a SQL query to select all records from PostData table
$rs.Open("SELECT * FROM PostData", $conn)

# Loop through the record set and display each record
$rs | ForEach-Object {
    Write-Host "ID: $($_.Fields.Item('ID').Value)"
    Write-Host "Content: $($_.Fields.Item('Content').Value)"
}

# Close the record set and the connection
$rs.Close()
$conn.Close()
