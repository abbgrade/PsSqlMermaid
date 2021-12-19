
task Testdata.DacPac.WWI.Clean -If ( Test-Path $PSScriptRoot\..\test\sql-server-samples ) -Jobs {
    Remove-Item $PSScriptRoot\..\test\sql-server-samples -Recurse -Force
}

task Testdata.DacPac.WWI.CheckoutSolution -If ( -Not ( Test-Path $PSScriptRoot\..\test\sql-server-samples )) -Jobs {
    $testdata = New-Item $PSScriptRoot\..\test\sql-server-samples -ItemType Directory
    Push-Location $testdata
    git init
    git remote add origin -f https://github.com/microsoft/sql-server-samples.git
    git config core.sparseCheckout true
    Set-Content .git/info/sparse-checkout samples/databases/wide-world-importers/wwi-ssdt/wwi-ssdt
    git pull --depth=1 origin master
    Pop-Location
}

task Testdata.DacPac.WWI.Create -Jobs Testdata.DacPac.WWI.CheckoutSolution, {
    # # can be enabled if dotnet core build is public and working
    # exec { dotnet build "$PsScriptRoot\..\test\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\WideWorldImporters.sqlproj" /p:NetCoreBuild=true }

    Import-Module Invoke-MsBuild

    Invoke-MsBuild "$PsScriptRoot\..\test\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\WideWorldImporters.sqlproj"

    assert ( Test-Path "$PsScriptRoot\..\test\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac" )
}

task Testdata.Create -Jobs Testdata.DacPac.WWI.Create
