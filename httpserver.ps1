$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://+:8080/")
$listener.Start()
Write-Host "Listening on port 8080..."

while ($true) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    Write-Host "Received request from $($request.RemoteEndPoint.Address)"

    if ($request.HttpMethod -eq "POST") {
        # Read the request content as a string
        $reader = New-Object System.IO.StreamReader($request.InputStream)
        $content = $reader.ReadToEnd()

        # Write the content to a text file
        Out-File -FilePath "C:\temp\post.txt" -InputObject $content -Append

        # Close the reader
        $reader.Close()
    }

    # Send a simple response
    # $buffer = [System.Text.Encoding]::UTF8.GetBytes("OK")
    $buffer = [System.Text.Encoding]::UTF8.GetBytes("Your IP address is $($request.RemoteEndPoint.Address)")
    $response.ContentLength64 = $buffer.Length
    $output = $response.OutputStream
    $output.Write($buffer, 0, $buffer.Length)
    $output.Close()
}
