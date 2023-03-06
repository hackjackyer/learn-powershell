# Create a HTTP listener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://+:8080/")
$listener.Start()
Write-Host "Listening on port 8080..."

# Create a database connection
$conn = New-Object -ComObject ADODB.Connection
$conn.Open("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=C:\temp\test.accdb")

while ($true) {
    # Get the request context
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    Write-Host "Received request from $($request.RemoteEndPoint.Address)"

    if ($request.HttpMethod -eq "POST") {
        # Read the request content as a string
        $reader = New-Object System.IO.StreamReader($request.InputStream)
        $content = $reader.ReadToEnd()

        # Execute a SQL statement to insert the content into a table named PostData
        $conn.Execute("INSERT INTO PostData (Content) VALUES ('$content')")

        # Close the reader
        $reader.Close()
    }

    # Send a simple response
    $buffer = [System.Text.Encoding]::UTF8.GetBytes("OK")
    $response.ContentLength64 = $buffer.Length
    $output = $response.OutputStream
    $output.Write($buffer, 0, $buffer.Length)
    $output.Close()
}
